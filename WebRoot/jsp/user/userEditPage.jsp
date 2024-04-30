<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../head.jsp">
	<jsp:param value="用户编辑" name="titleName" />
</jsp:include>
</head>
<style>
form {
	margin-right: 20px;
}
</style>
<body>
	<form class="layui-form">
		<div class="user_left">
			<input type="hidden" id="id" name="id" value="${user.id}">
			<div class="layui-form-item" style="margin-top: 20px;">
				<label class="layui-form-label">昵称</label>
				<div class="layui-input-block">
					<input type="text" name="nickName" value="${user.nickName}"
						maxlength="12" lay-verify="required" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item" pane="">
				<label class="layui-form-label">性别</label>
				<div class="layui-input-block">
					<input type="radio" name="sex" value="男" title="男"
						<c:if test="${user.sex == '男' || user.sex == null}">checked=""</c:if>>
					<input type="radio" name="sex" value="女" title="女"
						<c:if test="${user.sex == '女'}">checked=""</c:if>>
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">手机号码</label>
				<div class="layui-input-block">
					<input type="tel" name="tel" value="${user.tel}" maxlength="11"
						placeholder="请输入手机号码" lay-verify="required|tel"
						class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">邮箱</label>
				<div class="layui-input-block">
					<input type="text" value="${user.mail}" name="mail" maxlength="30"
						placeholder="请输入邮箱" lay-verify="email"
						class="layui-input userEmail">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">头像</label>
				<div class="layui-input-block">
					<div class="layui-upload">
						<button type="button" class="layui-btn layui-btn-danger"
							id="uploadBtn">上传头像</button>
						<div class="layui-upload-list">
							<img class="layui-upload-img" id="image"
								style="width: 100px; height: 100px;" src="${ctx}${user.headImg}">
							<input type="hidden" value="${user.headImg}" id="imagePath"
								name="imagePath">
							<p id="demoText"></p>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="margin-left: 5%;">
			<div class="layui-input-block">
				<button type="button" class="layui-btn" lay-submit=""
					lay-filter="editSubmit">提交</button>
				<button type="button" onclick="doCannel()"
					class="layui-btn layui-btn-primary">取消</button>
			</div>
		</div>
	</form>
	<script>
		layui.use([ 'form', 'upload' ],function() {
			var form = layui.form, upload = layui.upload;
			form.render();
			//自定义验证规则
			form.verify({
				tel : function(value) {
					if (!IsMobilePhoneNumber(value)) {
						return '请输入正确的手机号!';
					}
				},
				password : [ /^[\S]{6,16}$/,
						'密码必须6到16位，且不能出现空格' ]
			});
			//图片上传
			var uploadInst = upload
					.render({
						elem : '#uploadBtn',
						url : '${ctx}/user/uploadHeadImg',
						before : function(obj) {
							//预读本地文件示例，不支持ie8
							obj
									.preview(function(index,
											file, result) {
										$('#image').attr('src',
												result); //图片链接（base64）
									});
						},
						done : function(res) {
							//如果上传失败
							if (res.code > 0) {
								return layer.msg('上传失败');
							}
							//上传成功
							$("#imagePath").val(res.headImg);
						},
						error : function() {
							//演示失败状态，并实现重传
							var demoText = $('#demoText');
							demoText
									.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-mini demo-reload">重试</a>');
							demoText.find('.demo-reload').on(
									'click', function() {
										uploadInst.upload();
									});
						}
					});
			//监听提交  
			form.on('submit(editSubmit)', function(data) {
				var url = '${ctx}/user/edit';
				var data = {
					id : $("#id").val(),
					nickName : data.field.nickName,
					password : data.field.password,
					tel : data.field.tel,
					mail : data.field.mail,
					sex : $("input[type='radio']:checked")
							.val(),
					headImg : data.field.imagePath
				}
				doAjaxSubmit("post", url, data, "editSuccess");
			});
		});

		//提交
		function editSuccess(data) {
			if (data.errList == null) {
				parent.window.location.href = "${ctx}/user/index";
			} else {
				layer.msg(data.errList, {
					offset : 't',
					icon : 5
				});
				return false;
			}
		}
		//取消
		function doCannel() {
			parent.layer.closeAll();
		}
	</script>
</body>
</html>