package com.utils;

import javax.servlet.http.HttpServletRequest;

public class SessionUtil {
	// 得到管理员用户名
	public static String getAdminName(HttpServletRequest request) {
		try {
			return request.getSession().getAttribute("loginAdminName")
					.toString();
		} catch (Exception e) {
			// TODO: handle exception
			return "";
		}
	}

	// 得到管理员用户ID
	public static String getAdminId(HttpServletRequest request) {
		try {
			return request.getSession().getAttribute("loginAdminId").toString();
		} catch (Exception e) {
			// TODO: handle exception
			return "";
		}
	}

	// 得到普通用户名
	public static String getUserName(HttpServletRequest request) {
		try {
			return request.getSession().getAttribute("loginUserName")
					.toString();
		} catch (Exception e) {
			// TODO: handle exception
			return "";
		}
	}

	// 得到普通用户ID
	public static String getUserId(HttpServletRequest request) {
		try {
			return request.getSession().getAttribute("loginUserId").toString();
		} catch (Exception e) {
			return "";
		}
	}
	
	public static String getUserHeadImg(HttpServletRequest request) {
		try {
			return request.getSession().getAttribute("loginHeadImg").toString();
		} catch (Exception e) {
			return "";
		}
	}

}
