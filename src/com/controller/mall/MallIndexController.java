package com.controller.mall;

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

import com.entity.Goods;
import com.entity.GoodsType;
import com.entity.OrdersInfo;
import com.service.GoodsService;
import com.service.GoodsTypeService;
import com.service.OrdersService;
import com.service.UsersService;

@Controller
@RequestMapping("/mall")
public class MallIndexController {
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private UsersService usersService;
	@Autowired
	private GoodsTypeService goodsTypeService;
	@Autowired
	private OrdersService ordersService;
	/**
	 * 首页
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/index")
	public ModelAndView index() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		GoodsType goodsType = new GoodsType();
		goodsType.setPage(0);
		goodsType.setLimit(1000);
		List<GoodsType> typeList = goodsTypeService.getList(goodsType);
		Goods goods = new Goods();
		goods.setPage(0);
		goods.setLimit(10);
		// 查询已上架商品标识
		goods.setFlag("list");
		// 推荐为默认排序
		List<Goods> recList = goodsService.getList(goods);
		// 热卖根据销量排序
		goods.setCheckFlag("hot");
		List<Goods> hotList = goodsService.getList(goods);
		// 新品根据创建时间排序
		goods.setCheckFlag("new");
		List<Goods> newList = goodsService.getList(goods);
		modelAndView.addObject("recList", recList);
		modelAndView.addObject("hotList", hotList);
		modelAndView.addObject("newList", newList);
		modelAndView.addObject("typeList", typeList);
		modelAndView.setViewName("index");
		return modelAndView;
	}

	/**
	 * 商品列表
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public ModelAndView list(HttpServletRequest request) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		String typeId = request.getParameter("typeId");
		GoodsType goodsType = new GoodsType();
		goodsType.setPage(0);
		goodsType.setLimit(1000);
		List<GoodsType> typeList = goodsTypeService.getList(goodsType);
		modelAndView.addObject("typeList", typeList);
		modelAndView.addObject("typeId", typeId);
		modelAndView
				.addObject("serachName", request.getParameter("serachName"));
		modelAndView.setViewName("list");
		return modelAndView;
	}

	/**
	 * 取得商品信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/getGoodsList")
	public Map<String, Object> getGoodsList(HttpServletRequest request,
			HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		Goods goods = new Goods();
		String serachName = request.getParameter("serachName");
		String typeId = request.getParameter("typeId");
		goods.setTypeId(typeId);
		goods.setName(serachName);
		// 查询已上架商品标识
		goods.setFlag("list");
		int count = goodsService.getTotal(goods); // 总条数
		int page = Integer.parseInt(request.getParameter("page"));// 当前页
		int limit = Integer.parseInt(request.getParameter("limit"));// 每页条数
		goods.setPage((page - 1) * limit);
		goods.setLimit(limit);
		List<Goods> goodsList = goodsService.getList(goods);
		if (goodsList != null) {
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("title", "商品信息");
			data.put("list", goodsList);
			data.put("goodsAmount", count);
			map.put("goodsAmount", count);
			map.put("data", data);
			map.put("errList", null);
		} else {
			map.put("errList", "没有查到数据！");
		}
		return map;
	}

	/**
	 * 商品详情
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail")
	public ModelAndView detail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		String goodsId = request.getParameter("goodsId");
		// 商品信息
		Goods goods = goodsService.selectByPrimaryKey(goodsId);
		// 推荐商品
		Goods inputDto = new Goods();
		inputDto.setPage(0);
		inputDto.setLimit(8);
		inputDto.setTypeId(goods.getTypeId());
		// 查询已上架商品标识
		inputDto.setFlag("list");
		List<Goods> goodsList = goodsService.getList(inputDto);
		modelAndView.addObject("goodsList", goodsList);
		modelAndView.addObject("goods", goods);
		modelAndView.setViewName("detail");
		// 查询商品评价
		OrdersInfo ordersInfo = new OrdersInfo();
		ordersInfo.setGoodsId(goodsId);
		List<OrdersInfo> ordersList = ordersService.getInfoList(ordersInfo);
		modelAndView.addObject("ordersList", ordersList);
		return modelAndView;
	}
}
