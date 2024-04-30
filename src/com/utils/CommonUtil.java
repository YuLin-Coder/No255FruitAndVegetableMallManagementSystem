package com.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ndktools.javamd5.Mademd5;

public class CommonUtil {

	/**
	 * 构造方法
	 */
	private CommonUtil() {

	}

	/**
	 * 32位UUID
	 * 
	 * @return
	 */
	public static String getUUID32() {
		return UUID.randomUUID().toString().replace("-", "").toLowerCase();
	}

	/**
	 * 密码加密
	 * 
	 * @return
	 */
	public static String getMD5(String password) {
		Mademd5 mad = new Mademd5();
		return mad.toMd5(password);
	}

	/**
	 * 取得系统时间（yyyy-MM-dd HH:mm:ss.SSS）
	 * 
	 * @return 系统时间
	 */
	public static String getSystimeSSS() {
		Calendar c = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss.SSS");
		return formatter.format(c.getTime());
	}

	/**
	 * 取得系统时间（yyyy-MM-dd HH:mm:ss）
	 * 
	 * @return 系统时间
	 */
	public static String getSystimess() {
		Calendar c = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return formatter.format(c.getTime());
	}

	/**
	 * 取得系统时间（yyyy-MM-dd HH:mm）
	 * 
	 * @return 系统时间
	 */
	public static String getSystimemm() {
		Calendar c = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		return formatter.format(c.getTime());
	}

	/**
	 * 取得系统时间（yyyy-MM-dd）
	 * 
	 * @return 系统时间
	 */
	public static String getSystimedd() {
		Calendar c = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		return formatter.format(c.getTime());
	}

	/**
	 * 获取时间戳
	 * 
	 * @return
	 * @throws InterruptedException 
	 */
	public static String getTimeStamp() throws InterruptedException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmssSSS");
		TimeUnit.MILLISECONDS.sleep(1);//毫秒
		return sdf.format(new Date());
	}

	/**
	 * 获取客户端IP地址.<br>
	 * 支持多级反向代理
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @return 客户端真实IP地址
	 */
	public static String getRemoteAddr(final HttpServletRequest request) {
		try {
			String remoteAddr = request.getHeader("X-Forwarded-For");
			// 如果通过多级反向代理，X-Forwarded-For的值不止一个，而是一串用逗号分隔的IP值，此时取X-Forwarded-For中第一个非unknown的有效IP字符串
			if (isEffective(remoteAddr) && (remoteAddr.indexOf(",") > -1)) {
				String[] array = remoteAddr.split(",");
				for (String element : array) {
					if (isEffective(element)) {
						remoteAddr = element;
						break;
					}
				}
			}
			if (!isEffective(remoteAddr)) {
				remoteAddr = request.getHeader("X-Real-IP");
			}
			if (!isEffective(remoteAddr)) {
				remoteAddr = request.getRemoteAddr();
			}
			if ("0:0:0:0:0:0:0:1".equals(remoteAddr)) {
				remoteAddr = "127.0.0.1";
			}
			return remoteAddr;
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * 远程地址是否有效.
	 * 
	 * @param remoteAddr
	 *            远程地址
	 * @return true代表远程地址有效，false代表远程地址无效
	 */
	private static boolean isEffective(final String remoteAddr) {
		boolean isEffective = false;
		if ((null != remoteAddr) && (!"".equals(remoteAddr.trim()))
				&& (!"unknown".equalsIgnoreCase(remoteAddr.trim()))) {
			isEffective = true;
		}
		return isEffective;
	}

	/**
	 * Object转BigDecimal（异常返回0）
	 * 
	 * @param obj
	 *            待转数据
	 * @return 转换后数据
	 */
	public static BigDecimal converObjToBig(Object obj) {
		BigDecimal big = null;
		try {
			big = new BigDecimal(obj.toString());
		} catch (Exception e) {
			big = new BigDecimal(0);
		}
		return big;
	}

	/**
	 * Object转String(异常返回空字符串）
	 * 
	 * @param obj
	 *            待转数据
	 * @return 转换后数据
	 */
	public static String converObjToStr(Object obj) {
		try {
			if (obj != null) {
				return String.valueOf(obj);
			}
		} catch (Exception e) {
			return "";
		}
		return "";
	}

	/**
	 * Object转Integer（异常返回0）
	 * 
	 * @param obj
	 *            待转数据
	 * @return 转换后数据
	 */
	public static Integer converObjToInt(Object obj) {
		Integer inte = null;
		try {
			inte = new BigDecimal(obj.toString()).intValue();
		} catch (Exception e) {
			inte = 0;
		}
		return inte;
	}

	/**
	 * Object转Double（异常返回0）
	 * 
	 * @param obj
	 *            待转数据
	 * @return 转换后数据
	 */
	public static Double converObjToDbl(Object obj) {
		Double dbl = null;
		try {
			dbl = new BigDecimal(obj.toString()).doubleValue();
		} catch (Exception e) {
			dbl = 0D;
		}
		return dbl;
	}

	public static void downloadFileFullPath2(String filePath, String fileName,
			HttpServletResponse response) throws FileNotFoundException {
		// 读到流中
		InputStream inStream = new FileInputStream(filePath + fileName);// 文件的存放路径
		// 设置输出的格式
		response.reset();
		response.setContentType("bin");
		response.addHeader("Content-Disposition", "attachment; filename=\""
				+ fileName + "\"");
		// 循环取出流中的数据
		byte[] b = new byte[100];
		int len;
		try {
			while ((len = inStream.read(b)) > 0)
				response.getOutputStream().write(b, 0, len);
			inStream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
