package com.controller.admin;

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

import com.entity.Admin;
import com.service.AdminService;
import com.utils.CommonUtil;
import com.utils.SessionUtil;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {
	@Autowired
	private AdminService adminService;

	/**
	 * 登录页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/loginPage")
	public ModelAndView loginPage() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/loginPage");
		return modelAndView;
	}

	/**
	 * 登录
	 * 
	 * @param request
	 * @param response
	 * @param session
	 * @param admin
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/doLogin")
	public Map<String, Object> doLogin(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Admin admin)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		admin.setPassword(CommonUtil.getMD5(admin.getPassword()));
		admin = adminService.login(admin);
		if (admin != null) {
			session.setAttribute("loginAdminName", admin.getNickName());
			session.setAttribute("loginAdminId", admin.getId());
			session.setAttribute("limit", admin.getLimits());
			map.put("msg", "登录成功！");
			map.put("errList", null);
		} else {
			map.put("errList", "账号或密码不正确！");
		}
		return map;
	}

	/**
	 * 首页
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/index")
	public ModelAndView index() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/user/list");
		return modelAndView;
	}

	/**
	 * 管理员编辑页面显示
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/adminInfo")
	public ModelAndView adminInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/info");
		Admin admin = adminService.selectByPrimaryKey(SessionUtil
				.getAdminId(request));
		modelAndView.addObject("admin", admin);
		return modelAndView;
	}

	/**
	 * 管理员信息保存
	 * 
	 * @param request
	 * @param response
	 * @param session
	 * @param admin
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/adminInfoEdit")
	public Map<String, Object> adminInfoEdit(HttpServletRequest request,
			HttpServletResponse response, HttpSession session, Admin admin)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		admin.setId(SessionUtil.getAdminId(request));
		admin.setStatus("U");
		adminService.updateByPrimaryKeySelective(admin);
		map.put("msg", "操作成功！");
		map.put("errList", null);
		return map;
	}

	/**
	 * 管理员修改密码页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/adminPassword")
	public ModelAndView adminPassword(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/password");
		return modelAndView;
	}

	/**
	 * 管理员密码修改
	 * 
	 * @param request
	 * @param response
	 * @param session
	 * @param admin
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/adminPasswordEdit")
	public Map<String, Object> adminPasswordEdit(HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String password_old = CommonUtil.getMD5(request
				.getParameter("password_old"));
		String password_new = CommonUtil.getMD5(request
				.getParameter("password"));
		Admin admin = adminService.selectByPrimaryKey(SessionUtil
				.getAdminId(request));
		if (password_new.equalsIgnoreCase(admin.getPassword())) {
			map.put("errList", "与原始密码相同！");
		} else if (!password_old.equalsIgnoreCase(admin.getPassword())) {
			map.put("errList", "旧密码输入错误！");
		} else {
			admin.setId(SessionUtil.getAdminId(request));
			admin.setPassword(password_new);
			admin.setStatus("U");
			adminService.updateByPrimaryKeySelective(admin);
			map.put("msg", "修改成功！");
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
		return "redirect:/admin/loginPage";
	}
}
