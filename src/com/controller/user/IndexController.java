package com.controller.user;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.entity.Goods;
import com.entity.GoodsCar;
import com.entity.Orders;
import com.entity.OrdersInfo;
import com.entity.RecAddress;
import com.entity.Users;
import com.service.GoodsCarService;
import com.service.GoodsService;
import com.service.GoodsTypeService;
import com.service.OrdersService;
import com.service.RecAddressService;
import com.service.UsersService;
import com.utils.CommonUtil;
import com.utils.ImageUpload;
import com.utils.SessionUtil;

@Controller
@RequestMapping("/user")
public class IndexController {
	@Autowired
	private UsersService usersService;
	@Autowired
	private GoodsTypeService goodsTypeService;
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private OrdersService ordersService;
	@Autowired
	private GoodsCarService goodsCarService;
	@Autowired
	private RecAddressService recAddressService;

	/**
	 * 用户首页
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/index")
	public ModelAndView index(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("user/index");
		Users user = usersService.selectByPrimaryKey(SessionUtil
				.getUserId(request));
		modelAndView.addObject("user", user);
		return modelAndView;
	}

	/**
	 * 编辑页面显示
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/userEditPage")
	public ModelAndView userEditPage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("user/userEditPage");
		Users user = usersService.selectByPrimaryKey(SessionUtil
				.getUserId(request));
		modelAndView.addObject("user", user);
		return modelAndView;
	}

	/**
	 * 更换头像
	 * 
	 * @param request
	 * @param response
	 * @param session
	 * @param file
	 * @return
	 * @throws IOException
	 */
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
		user.setUpdateOperator(SessionUtil.getUserName(request));
		user.setFlag("edit");
		user.setCheckFlag("nickName");
		int nickName = usersService.checkRepeat(user);
		user.setCheckFlag("tel");
		int phone = usersService.checkRepeat(user);
		user.setCheckFlag("mail");
		int email = usersService.checkRepeat(user);
		user.setCheckFlag("no");
		if (nickName > 0) {
			map.put("errList", "昵称已存在！");
		} else if (phone > 0) {
			map.put("errList", "手机号已存在！");
		} else if (email > 0) {
			map.put("errList", "邮箱已存在！");
		} else {
			// 编辑
			user.setPassword(null);
			user.setStatus("U");
			usersService.updateByPrimaryKeySelective(user);
			map.put("msg", "编辑成功！");
			map.put("errList", null);
		}
		return map;
	}

	/**
	 * 修改密码页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/password")
	public ModelAndView password(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("user/password");
		return modelAndView;
	}

	/**
	 * 密码修改
	 * 
	 * @param request
	 * @param response
	 * @param session
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/userPasswordEdit")
	public Map<String, Object> userPasswordEdit(HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String password_old = CommonUtil.getMD5(request
				.getParameter("password_old"));
		String password_new = CommonUtil.getMD5(request
				.getParameter("password"));
		Users user = usersService.selectByPrimaryKey(SessionUtil
				.getUserId(request));
		if (password_new.equalsIgnoreCase(user.getPassword())) {
			map.put("errList", "与原始密码相同！");
		} else if (!password_old.equalsIgnoreCase(user.getPassword())) {
			map.put("errList", "旧密码输入错误！");
		} else {
			user.setId(SessionUtil.getUserId(request));
			user.setPassword(password_new);
			user.setStatus("U");
			usersService.updateByPrimaryKeySelective(user);
			map.put("msg", "修改成功！");
			map.put("errList", null);
		}
		return map;
	}

	/**
	 * 购物车
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/carlist")
	public ModelAndView carlist() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("user/car_list");
		return modelAndView;
	}

	/**
	 * 取得购物车数据
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/getCarList")
	public Map<String, Object> getCarList(HttpServletRequest request,
			HttpServletResponse response) {
		GoodsCar goodsCar = new GoodsCar();
		int count = goodsCarService.getTotal(goodsCar); // 总条数
		String spage=request.getParameter("page");
		String slimit=request.getParameter("limit");
		int page=1;
		int limit=8;
		if(!com.mysql.jdbc.StringUtils.isNullOrEmpty(spage)){
		page = Integer.parseInt(spage);// 当前页
		}
		if(!com.mysql.jdbc.StringUtils.isNullOrEmpty(slimit)){
		limit = Integer.parseInt(slimit);// 每页条数
		}
		goodsCar.setPage((page - 1) * limit);
		goodsCar.setLimit(limit);
		List<GoodsCar> data = goodsCarService.getList(goodsCar);
		String msg = (data == null) ? "没有查到数据！" : "success";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("data", data);
		map.put("count", count);
		map.put("msg", msg);
		map.put("code", 0);
		return map;
	}

	/**
	 * 地址管理页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addresslist")
	public ModelAndView addresslist() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("user/address_list");
		return modelAndView;
	}

	/**
	 * 取得用户地址列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/getAddressList")
	public Map<String, Object> getAddressList(HttpServletRequest request,
			HttpServletResponse response) {
		RecAddress recAddress = new RecAddress();
		recAddress.setUserId(SessionUtil.getUserId(request));
		int count = recAddressService.getTotal(recAddress); // 总条数
		int page = Integer.parseInt(request.getParameter("page"));// 当前页
		int limit = Integer.parseInt(request.getParameter("limit"));// 每页条数
		recAddress.setPage((page - 1) * limit);
		recAddress.setLimit(limit);
		List<RecAddress> data = recAddressService.getList(recAddress);
		String msg = (data == null) ? "没有查到数据！" : "success";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("data", data);
		map.put("count", count);
		map.put("msg", msg);
		map.put("code", 0);
		return map;
	}

	@RequestMapping("/editAddressPage")
	public ModelAndView editAddressPage(HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		String id = request.getParameter("id");
		if (!"".equals(id) && id != null) {
			RecAddress recAddress = recAddressService.selectByPrimaryKey(id);
			modelAndView.addObject("recAddress", recAddress);
		}
		modelAndView.setViewName("user/address_edit");
		return modelAndView;
	}

	/**
	 * 新增，编辑地址
	 * 
	 * @param request
	 * @param response
	 * @param user
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/editAddress")
	public Map<String, Object> editAddress(HttpServletRequest request,
			HttpServletResponse response, RecAddress recAddress) {
		Map<String, Object> map = new HashMap<String, Object>();
		recAddress.setUpdateOperator(SessionUtil.getUserName(request));
		if ("".equals(CommonUtil.converObjToStr(recAddress.getId()))) {
			// 新增
			recAddress.setId(CommonUtil.getUUID32());
			recAddress.setUserId(SessionUtil.getUserId(request));
			recAddress.setStatus("C");
			recAddress.setCreateOperator(SessionUtil.getUserName(request));
			recAddressService.insertSelective(recAddress);
			map.put("msg", "新增成功！");
		} else {
			// 编辑
			recAddress.setStatus("U");
			recAddressService.updateByPrimaryKeySelective(recAddress);
			map.put("msg", "修改成功！");
		}
		map.put("errList", null);
		return map;
	}

	/**
	 * 删除地址
	 * 
	 * @param request
	 * @param response
	 * @param recAddress
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/deleteAddress")
	public Map<String, Object> deleteAddress(HttpServletRequest request,
			HttpServletResponse response, RecAddress recAddress) {
		Map<String, Object> map = new HashMap<String, Object>();
		recAddress.setStatus("D");
		recAddress.setUpdateOperator(SessionUtil.getUserName(request));
		recAddressService.updateByPrimaryKeySelective(recAddress);
		map.put("msg", "删除成功！");
		map.put("errList", null);
		return map;
	}

	/**
	 * 加入购物车
	 * 
	 * @param request
	 * @param response
	 * @param recAddress
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/addCar")
	public Map<String, Object> addCar(HttpServletRequest request,
			HttpServletResponse response, GoodsCar goodsCar) {
		Map<String, Object> map = new HashMap<String, Object>();
		goodsCar.setId(CommonUtil.getUUID32());
		goodsCar.setUserId(SessionUtil.getUserId(request));
		goodsCar.setStatus("C");
		goodsCar.setCreateOperator(SessionUtil.getUserName(request));
		goodsCar.setUpdateOperator(SessionUtil.getUserName(request));
		// 校验购物车是否已经有这个商品了
		GoodsCar goodsCheck = goodsCarService.getGoodsByGoodsId(goodsCar);
		if (goodsCheck != null) {
			// 如果有则增加数量
			int amount = CommonUtil.converObjToInt(goodsCar.getAmount())
					+ CommonUtil.converObjToInt(goodsCheck.getAmount());
			goodsCheck.setAmount(String.valueOf(amount));
			goodsCarService.updateByPrimaryKeySelective(goodsCheck);
		} else {
			goodsCarService.insertSelective(goodsCar);
		}
		map.put("msg", "已添加至购物车！");
		map.put("errList", null);
		return map;
	}

	/**
	 * 修改购物车商品数量
	 * 
	 * @param request
	 * @param response
	 * @param goods
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/editGoodsCar")
	public Map<String, Object> editGoodsCar(HttpServletRequest request,
			HttpServletResponse response, GoodsCar goodsCar) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 修改数量先check库存
		Goods stock = goodsService.selectByPrimaryKey(goodsCar.getGoodsId());
		if (CommonUtil.converObjToInt(stock.getStockAmount()) >= CommonUtil
				.converObjToInt(goodsCar.getAmount())) {
			goodsCar.setUpdateOperator(SessionUtil.getUserName(request));
			goodsCar.setStatus("U");
			goodsCarService.updateByPrimaryKeySelective(goodsCar);
			map.put("msg", "修改成功！");
			map.put("errList", null);
		} else {
			map.put("errList", "库存只有" + stock.getStockAmount() + "个了");
		}
		return map;
	}

	/**
	 * 从购物车删除商品
	 * 
	 * @param request
	 * @param response
	 * @param goods
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/deleteGoodsCar")
	public Map<String, Object> deleteGoodsCar(HttpServletRequest request,
			HttpServletResponse response, GoodsCar goodsCar) {
		Map<String, Object> map = new HashMap<String, Object>();
		goodsCar.setUpdateOperator(SessionUtil.getUserName(request));
		goodsCar.setStatus("D");
		goodsCarService.updateByPrimaryKeySelective(goodsCar);
		map.put("msg", "删除成功！");
		map.put("errList", null);
		return map;
	}

	/**
	 * 购买页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/buyPage")
	public ModelAndView buyPage(HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		String[] goodsId = request.getParameter("goodsId").split(",");
		Users users = usersService.selectByPrimaryKey(SessionUtil
				.getUserId(request));
		modelAndView.addObject("users", users);
		// 购买方式
		String flag = request.getParameter("flag");
		modelAndView.addObject("flag", flag);
		List<Goods> goodsList = null;
		// 特殊处理
		if ("info".equals(flag)) {
			// 详情页购买
			goodsList = goodsService.selectBuyGoodsList(goodsId);
			String amount = request.getParameter("amount");
			int sumPrice = Integer.parseInt(amount)
					* CommonUtil.converObjToInt(goodsList.get(0).getPrice());
			modelAndView.addObject("sumPrice", sumPrice);
			modelAndView.addObject("goodsId", goodsId[0]);
			modelAndView.addObject("amount", amount);
			modelAndView.addObject("resultPrice", sumPrice);
		} else if ("car".equals(flag)) {
			// 购物车购买
			// 查询购物车商品信息
			Goods goodsCar = new Goods();
			goodsCar.setGoodsId(goodsId);
			goodsCar.setUserId(SessionUtil.getUserId(request));
			goodsList = goodsService.selectBuyCarGoodsList(goodsCar);
			String goodsIds = StringUtils.join(goodsId, ",");
			modelAndView.addObject("goodsId", goodsIds);
			String carIds = StringUtils
					.join(request.getParameter("carId"), ",");
			modelAndView.addObject("carId", carIds);
			int resultPrice = 0;
			for (int i = 0; i < goodsList.size(); i++) {
				resultPrice += CommonUtil.converObjToInt(goodsList.get(i)
						.getSumPrice());
			}
			modelAndView.addObject("resultPrice", resultPrice);
		}
		modelAndView.addObject("goodsList", goodsList);
		RecAddress recAddress = new RecAddress();
		recAddress.setUserId(SessionUtil.getUserId(request));
		recAddress.setPage(0);
		recAddress.setLimit(1000);
		List<RecAddress> addressList = recAddressService.getList(recAddress);
		modelAndView.addObject("addressList", addressList);
		modelAndView.setViewName("/user/buy");
		return modelAndView;
	}

	@ResponseBody
	@RequestMapping("/buy")
	public Map<String, Object> buy(HttpServletRequest request,
			HttpServletResponse response) throws InterruptedException {
		Map<String, Object> map = new HashMap<String, Object>();
		String flag = request.getParameter("flag");
		String recAddressId = request.getParameter("recAddressId");
		String[] goodsId = request.getParameter("goodsId").split(",");
		String amount = request.getParameter("amount");
		String userName = SessionUtil.getUserName(request);
		Goods goodsCar = new Goods();
		goodsCar.setGoodsId(goodsId);
		if ("car".equals(flag)) {
			goodsCar.setUserId(SessionUtil.getUserId(request));
		}
		List<Goods> goodsList = goodsService.selectBuyCarGoodsList(goodsCar);
		String orderNo = CommonUtil.getTimeStamp();
		String orderId = CommonUtil.getUUID32();
		OrdersInfo ordersInfo = new OrdersInfo();
		ordersInfo.setStatus("C");
		ordersInfo.setUseFlag("0");
		ordersInfo.setOrderId(orderId);
		ordersInfo.setCreateOperator(userName);
		ordersInfo.setUpdateOperator(userName);

		int resultPrice = 0;
		for (int i = 0; i < goodsList.size(); i++) {
			// 校验商品数量
			Goods goodsCheck = goodsService.selectByPrimaryKey(goodsList.get(i)
					.getId());
			if (CommonUtil.converObjToInt(goodsCheck.getStockAmount()) == 0) {
				map.put("errList", "不好意思，商品“" + goodsCheck.getName()
						+ "”已经卖完了,请重新下单!");
				return map;
			}
			resultPrice += CommonUtil.converObjToInt(goodsList.get(i)
					.getSumPrice());
			ordersInfo.setId(CommonUtil.getUUID32());
			ordersInfo.setGoodsId(goodsId[i]);
			ordersInfo.setUserId(SessionUtil.getUserId(request));
			// 商品库存减少
			Goods goods = goodsService.selectByPrimaryKey(goodsId[i]);
			if (CommonUtil.converObjToInt(goods.getStockAmount()) > 1) {
				// 商品未出售完，下单-插入订单详情
				if ("car".equals(flag)) {
					ordersInfo.setAmount(goodsList.get(i).getAmount());
				} else {
					ordersInfo.setAmount(amount);
				}
				ordersService.insertSelective(ordersInfo);
				// 商品数量减1
				int newAmount = CommonUtil.converObjToInt(goods
						.getStockAmount()) - 1;
				goods = new Goods();
				goods.setId(goodsId[i]);
				goods.setStockAmount(String.valueOf(newAmount));
				goodsService.updateByPrimaryKeySelective(goods);
				map.put("msg", "购买成功！");
				map.put("errList", null);
			} else if (CommonUtil.converObjToInt(goods.getStockAmount()) == 1) {
				// 商品未出售完，下单-插入订单详情
				ordersInfo.setAmount(goodsList.get(i).getAmount());
				ordersService.insertSelective(ordersInfo);
				// 卖了这个就没了，给商品下架，数量减1
				int newAmount = CommonUtil.converObjToInt(goods
						.getStockAmount()) - 1;
				goods = new Goods();
				goods.setId(goodsId[i]);
				goods.setStockAmount(String.valueOf(newAmount));
				goods.setUseFlag("1");
				goodsService.updateByPrimaryKeySelective(goods);
				map.put("msg", "购买成功！");
				map.put("errList", null);
			} else {
				map.put("errList", "库存不足！请重新下单！");
				return map;
			}
		}
		// 插入订单表
		Orders order = new Orders();
		order.setId(orderId);
		order.setOrderNo(orderNo);
		order.setUserId(SessionUtil.getUserId(request));
		if ("car".equals(flag)) {
			order.setPrice(String.valueOf(resultPrice));
		} else {
			int price = CommonUtil.converObjToInt(goodsList.get(0).getPrice())
					* Integer.valueOf(amount);
			order.setPrice(String.valueOf(price));
		}
		order.setRecAddresId(recAddressId);
		order.setStatus("C");
		order.setUseFlag("0");
		order.setCreateOperator(userName);
		order.setUpdateOperator(userName);
		ordersService.insertSelective(order);
		// 购物车购买，删除购物车商品
		if ("car".equals(flag)) {
			String[] carId = request.getParameter("carId").split(",");
			for (int i = 0; i < carId.length; i++) {
				GoodsCar delGood = new GoodsCar();
				delGood.setId(carId[i]);
				delGood.setStatus("D");
				delGood.setUpdateOperator(userName);
				goodsCarService.updateByPrimaryKeySelective(delGood);
			}
		}
		return map;
	}

	/**
	 * 订单页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/orderslist")
	public ModelAndView orderslist(HttpServletRequest request) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		String flag = request.getParameter("flag");
		if ("buy".equals(flag)) {
			modelAndView.addObject("flag", flag);
		}
		modelAndView.setViewName("user/orders_list");
		return modelAndView;
	}

	/**
	 * 取得订单数据
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/getOrdersList")
	public Map<String, Object> getOrdersList(HttpServletRequest request,
			HttpServletResponse response) {
		Orders orders = new Orders();
		orders.setUserId(SessionUtil.getUserId(request));
		orders.setFlag("user");
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
		modelAndView.setViewName("user/orders_info");
		return modelAndView;
	}

	/**
	 * 评价
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/evel")
	public Map<String, Object> evel(HttpServletRequest request,
			HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		String[] values = request.getParameter("values").split(",");
		String[] content = request.getParameter("content").split("@!@");
		String orderId = request.getParameter("id");
		OrdersInfo ordersInfo = new OrdersInfo();
		ordersInfo.setOrderId(orderId);
		List<OrdersInfo> orderInfoList = ordersService.getInfoList(ordersInfo);
		for (int i = 0; i < orderInfoList.size(); i++) {
			OrdersInfo evelInfo = new OrdersInfo();
			evelInfo.setId(orderInfoList.get(i).getId());
			evelInfo.setEval(values[i]);
			evelInfo.setRvalContent(content[i]);
			evelInfo.setUpdateOperator(SessionUtil.getUserName(request));
			ordersService.updateByPrimaryKeySelective(evelInfo);
		}
		map.put("msg", "评价成功！");
		map.put("errList", null);
		return map;
	}

	@ResponseBody
	@RequestMapping("/deleteOrders")
	public Map<String, Object> deleteOrders(HttpServletRequest request,
			HttpServletResponse response, Orders orders) {
		Map<String, Object> map = new HashMap<String, Object>();
		orders = ordersService.selectByPrimaryKey(orders.getId());
		if ("2".equals(orders.getUseFlag())) {
			// 管理员已经删除，则状态改为全部删除
			orders.setUseFlag("3");
			orders.setStatus("D");
		} else {
			// 管理员未删除，则状态改为用户删除
			orders.setUseFlag("1");
		}
		orders.setUpdateOperator(SessionUtil.getAdminName(request));
		ordersService.updateByPrimaryKeySelective(orders);
		map.put("msg", "删除成功！");
		map.put("errList", null);
		return map;
	}
}
