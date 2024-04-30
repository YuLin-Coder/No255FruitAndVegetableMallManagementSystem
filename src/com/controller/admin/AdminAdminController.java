package com.controller.admin;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.entity.Admin;
import com.service.AdminService;
import com.utils.CommonUtil;
import com.utils.SessionUtil;

@Controller
@RequestMapping("/admin/admin")
public class AdminAdminController {
	@Autowired
	private AdminService adminService;

	@RequestMapping("/list")
	public ModelAndView list() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/admin/list");
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
		Admin admin = new Admin();
		admin.setNickName(serachName);
		int count = adminService.getTotal(admin); // 总条数
		int page = Integer.parseInt(request.getParameter("page"));// 当前页
		int limit = Integer.parseInt(request.getParameter("limit"));// 每页条数
		admin.setPage((page - 1) * limit);
		admin.setLimit(limit);
		List<Admin> data = adminService.getList(admin);
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
			Admin admin = adminService.selectByPrimaryKey(id);
			modelAndView.addObject("admin", admin);
		}
		modelAndView.setViewName("/admin/admin/edit");
		return modelAndView;
	}

	/**
	 * 新增，编辑
	 * 
	 * @param request
	 * @param response
	 * @param admin
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/edit")
	public Map<String, Object> edit(HttpServletRequest request,
			HttpServletResponse response, Admin admin) {
		Map<String, Object> map = new HashMap<String, Object>();
		admin.setUpdateOperator(SessionUtil.getAdminName(request));
		if (!"".equals(CommonUtil.converObjToStr(admin.getId()))) {
			admin.setFlag("edit");
		}
		admin.setCheckFlag("nickName");
		int nickName = adminService.checkRepeat(admin);
		admin.setCheckFlag("tel");
		int phone = adminService.checkRepeat(admin);
		admin.setCheckFlag("mail");
		int email = adminService.checkRepeat(admin);
		if (nickName > 0) {
			map.put("errList", "昵称已存在！");
		} else if (phone > 0) {
			map.put("errList", "手机号已存在！");
		} else if (email > 0) {
			map.put("errList", "邮箱已存在！");
		} else {
			if ("".equals(CommonUtil.converObjToStr(admin.getId()))) {
				// 新增
				admin.setId(CommonUtil.getUUID32());
				admin.setPassword(CommonUtil.getMD5(admin.getPassword()));
				admin.setStatus("C");
				admin.setCreateOperator(SessionUtil.getAdminName(request));
				adminService.insertSelective(admin);
				map.put("msg", "新增成功！");
			} else {
				// 编辑
				admin.setPassword(null);
				admin.setStatus("U");
				adminService.updateByPrimaryKeySelective(admin);
				map.put("msg", "修改成功！");
			}
			map.put("errList", null);
		}
		return map;
	}

	@ResponseBody
	@RequestMapping("/delete")
	public Map<String, Object> delete(HttpServletRequest request,
			HttpServletResponse response, Admin admin) {
		Map<String, Object> map = new HashMap<String, Object>();
		admin.setStatus("D");
		admin.setUpdateOperator(SessionUtil.getAdminName(request));
		adminService.updateByPrimaryKeySelective(admin);
		map.put("msg", "操作成功！");
		map.put("errList", null);
		return map;
	}

}
