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

import com.entity.Goods;
import com.entity.GoodsType;
import com.service.GoodsService;
import com.service.GoodsTypeService;
import com.utils.CommonUtil;
import com.utils.ImageUpload;
import com.utils.SessionUtil;

@Controller
@RequestMapping("/admin/goods")
public class AdminGoodsController {
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private GoodsTypeService goodsTypeService;

	@RequestMapping("/list")
	public ModelAndView list() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/goods/list");
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
		System.out.println(serachName+"2222");
		Goods goods = new Goods();
		goods.setName(serachName);
		int count = goodsService.getTotal(goods); // 总条数
		int page = Integer.parseInt(request.getParameter("page"));// 当前页
		int limit = Integer.parseInt(request.getParameter("limit"));// 每页条数
		goods.setPage((page - 1) * limit);
		goods.setLimit(limit);
		List<Goods> data = goodsService.getList(goods);
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
			Goods goods = goodsService.selectByPrimaryKey(id);
			modelAndView.addObject("goods", goods);
		}
		GoodsType goodsType = new GoodsType();
		goodsType.setPage(0);
		goodsType.setLimit(1000);
		List<GoodsType> typeList = goodsTypeService.getList(goodsType);
		modelAndView.addObject("typeList", typeList);
		modelAndView.setViewName("/admin/goods/edit");
		return modelAndView;
	}

	/**
	 * 新增，编辑
	 * 
	 * @param request
	 * @param response
	 * @param goods
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/edit")
	public Map<String, Object> edit(HttpServletRequest request,
			HttpServletResponse response, Goods goods) {
		Map<String, Object> map = new HashMap<String, Object>();
		goods.setUpdateOperator(SessionUtil.getAdminName(request));
		if ("".equals(CommonUtil.converObjToStr(goods.getId()))) {
			// 新增
			goods.setId(CommonUtil.getUUID32());
			goods.setStatus("C");
			goods.setCreateOperator(SessionUtil.getAdminName(request));
			goodsService.insertSelective(goods);
			map.put("msg", "新增成功！");
		} else {
			// 编辑
			goods.setStatus("U");
			goodsService.updateByPrimaryKeySelective(goods);
			map.put("msg", "修改成功！");
		}
		map.put("errList", null);
		return map;
	}

	@ResponseBody
	@RequestMapping("/delete")
	public Map<String, Object> delete(HttpServletRequest request,
			HttpServletResponse response, Goods goods) {
		Map<String, Object> map = new HashMap<String, Object>();
		goods.setStatus("D");
		goods.setUpdateOperator(SessionUtil.getAdminName(request));
		goodsService.updateByPrimaryKeySelective(goods);
		map.put("msg", "操作成功！");
		map.put("errList", null);
		return map;
	}

	@ResponseBody
	@RequestMapping("/uploadImg")
	public Map<String, Object> uploadImg(HttpServletRequest request,
			HttpServletResponse response, HttpSession session,
			MultipartFile file) throws IOException {
		Map<String, Object> map = new HashMap<String, Object>();
		if (file != null) {
			// 上传
			String images = ImageUpload.uploadFile(request, file, "upload");
			map.put("images", images);
			map.put("msg", "上传成功！");
			map.put("code", 0);
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("src", images);
			map.put("data", data);
		}
		return map;
	}
	
	/**
	 * 下架
	 * 
	 * @param request
	 * @param response
	 * @param goods
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/stop")
	public Map<String, Object> stop(HttpServletRequest request,
			HttpServletResponse response, Goods goods) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 编辑
		goods.setUpdateOperator(SessionUtil.getAdminName(request));
		goods.setUseFlag("0");
		goods.setStatus("U");
		goodsService.updateByPrimaryKeySelective(goods);
		map.put("msg", "下架成功！");
		map.put("errList", null);
		return map;
	}

	/**
	 * 上架
	 * 
	 * @param request
	 * @param response
	 * @param goods
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/ok")
	public Map<String, Object> ok(HttpServletRequest request,
			HttpServletResponse response, Goods goods) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 编辑
		goods.setUpdateOperator(SessionUtil.getAdminName(request));
		goods.setUseFlag("1");
		goods.setStatus("U");
		goodsService.updateByPrimaryKeySelective(goods);
		map.put("msg", "上架成功！");
		map.put("errList", null);
		return map;
	}

}
