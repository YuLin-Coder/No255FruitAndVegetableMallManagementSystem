package com.controller.user;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.entity.Users;
import com.service.UsersService;
import com.utils.CommonUtil;

@Controller
@RequestMapping("/login")
public class LoginController {
	@Autowired
	private UsersService usersService;

	/**
	 * 登录页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/loginPage")
	public ModelAndView loginPage(HttpServletRequest request) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("tel", request.getParameter("tel"));
		modelAndView.setViewName("user/login");
		return modelAndView;
	}

	/**
	 * 登录
	 * 
	 * @param request
	 * @param response
	 * @param session
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/doLogin")
	public Map<String, Object> doLogin(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Users user)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		user.setPassword(CommonUtil.getMD5(user.getPassword()));
		user = usersService.login(user);
		if (user != null ) {
			session.setAttribute("loginUserName", user.getNickName());
			session.setAttribute("loginUserId", user.getId());
			session.setAttribute("loginHeadImg", user.getHeadImg());
			map.put("msg", "登录成功！");
			map.put("errList", null);
		} else {
			map.put("errList", "账号或密码不正确！");
		}
		return map;
	}
	
	/**
	 * 注册页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/regPage")
	public ModelAndView regPage() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("user/reg");
		return modelAndView;
	}
	
	/**
	 * 注册
	 * @param request
	 * @param response
	 * @param session
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/doReg")
	public Map<String, Object> doReg(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Users user)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		user.setCheckFlag("nickName");
		int nickName = usersService.checkRepeat(user);
		user.setCheckFlag("tel");
		int phone = usersService.checkRepeat(user);
		user.setCheckFlag("mail");
		int email = usersService.checkRepeat(user);
		if (nickName > 0) {
			map.put("errList", "昵称已存在！");
		} else if (phone > 0) {
			map.put("errList", "手机号已存在！");
		} else if (email > 0) {
			map.put("errList", "邮箱已存在！");
		} else {
			user.setId(CommonUtil.getUUID32());
			user.setPassword(CommonUtil.getMD5(user.getPassword()));
			user.setStatus("C");
			user.setCreateOperator(user.getNickName());
			user.setUpdateOperator(user.getNickName());
			usersService.insertSelective(user);
			map.put("tel", user.getTel());
			map.put("msg", "注册成功！");
			map.put("errList", null);
		}
		return map;
	}
	/**
	 * 退出登录
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/logout")
	public String logout(HttpSession session) throws Exception {
		session.invalidate();
		return "redirect:/mall/index";
	}
}
