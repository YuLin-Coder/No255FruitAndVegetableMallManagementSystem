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

import com.entity.Orders;
import com.entity.OrdersInfo;
import com.service.OrdersService;
import com.utils.CommonUtil;
import com.utils.ImageUpload;
import com.utils.SessionUtil;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrdersController {
	@Autowired
	private OrdersService ordersService;

	@RequestMapping("/list")
	public ModelAndView list() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/orders/list");
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
		Orders orders = new Orders();
		orders.setFlag("admin");
		orders.setOrderNo(serachName);
		int count = ordersService.getTotal(orders); // 总条数
		int page = Integer.parseInt(request.getParameter("page"));// 当前页
		int limit = Integer.parseInt(request.getParameter("limit"));// 每页条数
		orders.setPage((page - 1) * limit);
		orders.setLimit(limit);
		List<Orders> data = ordersService.getList(orders);
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
			Orders orders = ordersService.selectByPrimaryKey(id);
			modelAndView.addObject("orders", orders);
		}
		modelAndView.setViewName("/admin/orders/edit");
		return modelAndView;
	}

	/**
	 * 新增，编辑
	 * 
	 * @param request
	 * @param response
	 * @param orders
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/edit")
	public Map<String, Object> edit(HttpServletRequest request,
			HttpServletResponse response, Orders orders) {
		Map<String, Object> map = new HashMap<String, Object>();
		orders.setUpdateOperator(SessionUtil.getAdminName(request));
		if ("".equals(CommonUtil.converObjToStr(orders.getId()))) {
			// 新增
			orders.setId(CommonUtil.getUUID32());
			orders.setStatus("C");
			orders.setCreateOperator(SessionUtil.getAdminName(request));
			ordersService.insertSelective(orders);
			map.put("msg", "新增成功！");
		} else {
			// 编辑
			orders.setStatus("U");
			ordersService.updateByPrimaryKeySelective(orders);
			map.put("msg", "修改成功！");
			map.put("errList", null);
		}
		return map;
	}

	@ResponseBody
	@RequestMapping("/delete")
	public Map<String, Object> delete(HttpServletRequest request,
			HttpServletResponse response, Orders orders) {
		Map<String, Object> map = new HashMap<String, Object>();
		orders = ordersService.selectByPrimaryKey(orders.getId());
		if ("1".equals(orders.getUseFlag())) {
			// 用户已经删除，则状态改为全部删除
			orders.setUseFlag("3");
			orders.setStatus("D");
		} else {
			// 用户未删除，则状态改为管理员删除
			orders.setUseFlag("2");
		}
		orders.setUpdateOperator(SessionUtil.getAdminName(request));
		ordersService.updateByPrimaryKeySelective(orders);
		map.put("msg", "删除成功！");
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

	/**
	 * 订单详情页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/ordersInfoPage")
	public ModelAndView ordersInfoPage(HttpServletRequest request)
			throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		String orderId = request.getParameter("id");
		OrdersInfo ordersInfo = new OrdersInfo();
		ordersInfo.setOrderId(orderId);
		List<OrdersInfo> orderInfo = ordersService.getInfoList(ordersInfo);
		if (orderInfo.get(0).getEval() != null
				&& !"".equals(orderInfo.get(0).getEval())) {
			modelAndView.addObject("isEval", "isEval");
		} else {
			modelAndView.addObject("isEval", "no");
		}
		modelAndView.addObject("orderInfoList", orderInfo);
		modelAndView.addObject("orderId", orderId);
		modelAndView.setViewName("admin/orders/edit");
		return modelAndView;
	}
}
