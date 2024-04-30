package com.controller.admin;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.entity.Users;
import com.service.UsersService;
import com.utils.CommonUtil;
import com.utils.ImageUpload;
import com.utils.SessionUtil;

@Controller
@RequestMapping("/admin/user")
public class AdminUserController {
	@Autowired
	private UsersService userService;

	@RequestMapping("/list")
	public ModelAndView list() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/user/list");
		return modelAndView;
	}

	@ResponseBody
	@RequestMapping("/getList")
	public Map<String, Object> getList(HttpServletRequest request,
			HttpServletResponse response) {
		String serachName = request.getParameter("serachName");
		try {
			if(serachName!=null)
			serachName=new String(serachName.getBytes("iso-8859-1"),"UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Users user = new Users();
		user.setNickName(serachName);
		int count = userService.getTotal(user); // 总条数
		int page = Integer.parseInt(request.getParameter("page"));// 当前页
		int limit = Integer.parseInt(request.getParameter("limit"));// 每页条数
		user.setPage((page - 1) * limit);
		user.setLimit(limit);
		List<Users> data = userService.getList(user);
		String msg = (data == null) ? "没有查到数据！" : "success";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("data", data);
		map.put("count", count);
		map.put("msg", msg);
		map.put("code", 0);
		return map;
	}

	@RequestMapping("/editPage")
	public ModelAndView editPage(HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		String id = request.getParameter("id");
		if (!"".equals(id) && id != null) {
			Users user = userService.selectByPrimaryKey(id);
			modelAndView.addObject("user", user);
		}
		modelAndView.setViewName("/admin/user/edit");
		return modelAndView;
	}

	/**
	 * 新增，编辑
	 * 
	 * @param request
	 * @param response
	 * @param user
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/edit")
	public Map<String, Object> edit(HttpServletRequest request,
			HttpServletResponse response, Users user) {
		Map<String, Object> map = new HashMap<String, Object>();
		user.setUpdateOperator(SessionUtil.getAdminName(request));
		if (!"".equals(CommonUtil.converObjToStr(user.getId()))) {
			user.setFlag("edit");
		}
		user.setCheckFlag("nickName");
		int nickName = userService.checkRepeat(user);
		user.setCheckFlag("tel");
		int phone = userService.checkRepeat(user);
		user.setCheckFlag("mail");
		int email = userService.checkRepeat(user);
		if (nickName > 0) {
			map.put("errList", "昵称已存在！");
		} else if (phone > 0) {
			map.put("errList", "手机号已存在！");
		} else if (email > 0) {
			map.put("errList", "邮箱已存在！");
		} else {
			if ("".equals(CommonUtil.converObjToStr(user.getId()))) {
				// 新增
				user.setId(CommonUtil.getUUID32());
				user.setPassword(CommonUtil.getMD5(user.getPassword()));
				user.setStatus("C");
				user.setCreateOperator(SessionUtil.getAdminName(request));
				userService.insertSelective(user);
				map.put("msg", "新增成功！");
			} else {
				// 编辑
				user.setPassword(null);
				user.setStatus("U");
				userService.updateByPrimaryKeySelective(user);
				map.put("msg", "修改成功！");
			}
			map.put("errList", null);
		}
		return map;
	}

	@ResponseBody
	@RequestMapping("/delete")
	public Map<String, Object> delete(HttpServletRequest request,
			HttpServletResponse response, Users user) {
		Map<String, Object> map = new HashMap<String, Object>();
		user.setStatus("D");
		user.setUpdateOperator(SessionUtil.getAdminName(request));
		userService.updateByPrimaryKeySelective(user);
		map.put("msg", "操作成功！");
		map.put("errList", null);
		return map;
	}

	@ResponseBody
	@RequestMapping("/uploadHeadImg")
	public Map<String, Object> uploadHeadImg(HttpServletRequest request,
			HttpServletResponse response, HttpSession session,
			MultipartFile file) throws IOException {
		Map<String, Object> map = new HashMap<String, Object>();
		if (file != null) {
			// 上传
			String headImg = ImageUpload.uploadFile(request, file, "upload");
			map.put("headImg", headImg);
			map.put("msg", "上传成功！");
			map.put("code", 0);
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("src", headImg);
			map.put("data", data);
		}
		return map;
	}

}
