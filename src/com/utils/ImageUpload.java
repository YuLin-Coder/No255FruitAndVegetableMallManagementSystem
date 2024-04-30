package com.utils;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public class ImageUpload {

	public static String uploadFile(HttpServletRequest request,
			MultipartFile image, String type) throws IOException {
		// 获得物理路径
		String pathRoot = request.getSession().getServletContext()
				.getRealPath("");
		String path = "";
		if (!image.isEmpty()) {
			// 生成uuid作为文件名称
			String uuid = UUID.randomUUID().toString().replaceAll("-", "");
			// 获得文件类型（可以判断如果不是图片，禁止上传）
			String contentType = image.getContentType();
			// 获得文件后缀名称
			String imageName = contentType
					.substring(contentType.indexOf("/") + 1);
			if ("upload".equals(type)) {
				path = "/res/images/upload/" + uuid + "." + imageName;
			}

			try {
				image.transferTo(new File(pathRoot + path));
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return path;
		} else
			return "";
	}
}
