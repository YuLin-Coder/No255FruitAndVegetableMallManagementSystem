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

import com.entity.GoodsType;
import com.service.GoodsTypeService;
import com.utils.CommonUtil;
import com.utils.ImageUpload;
import com.utils.SessionUtil;

@Controller
@RequestMapping("/admin/goodsType")
public class AdminGoodsTypeController {
	@Autowired
	private GoodsTypeService goodsTypeService;

	@RequestMapping("/list")
	public ModelAndView list() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/goodsType/list");
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
		GoodsType goodsType = new GoodsType();
		goodsType.setName(serachName);
		int count = goodsTypeService.getTotal(goodsType); // 总条数
		int page = Integer.parseInt(request.getParameter("page"));// 当前页
		int limit = Integer.parseInt(request.getParameter("limit"));// 每页条数
		goodsType.setPage((page - 1) * limit);
		goodsType.setLimit(limit);
		List<GoodsType> data = goodsTypeService.getList(goodsType);
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
			GoodsType goodsType = goodsTypeService.selectByPrimaryKey(id);
			modelAndView.addObject("goodsType", goodsType);
		}
		modelAndView.setViewName("/admin/goodsType/edit");
		return modelAndView;
	}

	/**
	 * 新增，编辑
	 * 
	 * @param request
	 * @param response
	 * @param goodsType
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/edit")
	public Map<String, Object> edit(HttpServletRequest request,
			HttpServletResponse response, GoodsType goodsType) {
		Map<String, Object> map = new HashMap<String, Object>();
		goodsType.setUpdateOperator(SessionUtil.getAdminName(request));
		if (!"".equals(CommonUtil.converObjToStr(goodsType.getId()))) {
			goodsType.setFlag("edit");
		}
		goodsType.setCheckFlag("name");
		int name = goodsTypeService.checkRepeat(goodsType);
		if (name > 0) {
			map.put("errList", "类型名已存在！");
		} else {
			if ("".equals(CommonUtil.converObjToStr(goodsType.getId()))) {
				// 新增
				goodsType.setId(CommonUtil.getUUID32());
				goodsType.setStatus("C");
				goodsType.setCreateOperator(SessionUtil.getAdminName(request));
				goodsTypeService.insertSelective(goodsType);
				map.put("msg", "新增成功！");
			} else {
				// 编辑
				goodsType.setStatus("U");
				goodsTypeService.updateByPrimaryKeySelective(goodsType);
				map.put("msg", "修改成功！");
			}
			map.put("errList", null);
		}
		return map;
	}

	@ResponseBody
	@RequestMapping("/delete")
	public Map<String, Object> delete(HttpServletRequest request,
			HttpServletResponse response, GoodsType goodsType) {
		Map<String, Object> map = new HashMap<String, Object>();
		goodsType.setStatus("D");
		goodsType.setUpdateOperator(SessionUtil.getAdminName(request));
		goodsTypeService.updateByPrimaryKeySelective(goodsType);
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
