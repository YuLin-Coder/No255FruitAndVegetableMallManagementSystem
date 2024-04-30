package com.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.utils.SessionUtil;

//登录认证的拦截器
public class UserLoginInterceptor implements HandlerInterceptor {

	// 执行Handler方法之前执行
	// 用于身份认证、身份授权
	// 比如身份认证，如果认证通过表示当前用户没有登陆，需要此方法拦截不再向下执行
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {

		// 从session中取出用户份信息
		String userId = SessionUtil.getUserId(request);

		if (userId != null && !"".equals(userId)) {
			// 身份存在，放行
			return true;
		}

		// 执行这里表示用户身份需要验证，跳转到登录界面
		request.getRequestDispatcher("/WEB-INF/jsp/user/login.jsp").forward(
				request, response);

		// return false表示拦截，不向下执行
		// return true表示放行
		return false;
	}

	// 进入Handler方法之后，返回modelAndView之前执行
	// 应用场景从modelAndView出发：将公用的模型数据(比如菜单导航)在这里
	// 传到视图，也可以在这里统一指定视图
	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		System.out.println("HandlerInterceptor1......postHandle");

	}

	// 执行Handler完成执行此方法
	// 应用场景：统一异常处理，统一日志处理
	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {

		System.out.println("HandlerInterceptor1......afterHandle");

	}
}