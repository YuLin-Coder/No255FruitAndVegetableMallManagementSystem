<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../common/head.jsp">
	<jsp:param value="管理员管理" name="titleName" />
</jsp:include>
</head>
<style>
form {
	margin-right: 20px;
}
</style>
<body>
	<form class="layui-form">
		<div class="admin_left">
			<input type="hidden" id="id" name="id" value="${admin.id}">
			<div class="layui-form-item" style="margin-top: 20px;">
				<label class="layui-form-label">昵称</label>
				<div class="layui-input-block">
					<input type="text" name="nickName" value="${admin.nickName}"
						placeholder="请输入昵称" maxlength="12" lay-verify="required"
						class="layui-input">
				</div>
			</div>
			<c:if test="${admin.password == null}">
				<div class="layui-form-item">
					<label class="layui-form-label">密码</label>
					<div class="layui-input-block">
						<input type="password" name="password" value=""
							placeholder="请输入密码" lay-verify="required|password" maxlength="16"
							class="layui-input">
					</div>
				</div>
			</c:if>
			<div class="layui-form-item" pane="">
				<label class="layui-form-label">身份</label>
				<div class="layui-input-block">
					<input type="radio" name="limits" value="超级管理员" title="超级管理员"
						<c:if test="${admin.limits == '超级管理员' || admin.limits == null}">checked=""</c:if>>
					<input type="radio" name="limits" value="管理人员" title="管理人员"
						<c:if test="${admin.limits == '管理人员'}">checked=""</c:if>>
					<input type="radio" name="limits" value="运维人员" title="运维人员"
						<c:if test="${admin.limits == '运维人员管理人员'}">checked=""</c:if>>
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">手机号码</label>
				<div class="layui-input-block">
					<input type="tel" name="tel" value="${admin.tel}" maxlength="11"
						placeholder="请输入手机号码" lay-verify="required|tel"
						class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">邮箱</label>
				<div class="layui-input-block">
					<input type="text" value="${admin.mail}" name="mail" maxlength="30"
						placeholder="请输入邮箱" lay-verify="email"
						class="layui-input adminEmail">
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
		layui.use([ 'form' ], function() {
			var form = layui.form;
			form.render();
			//自定义验证规则
			form.verify({
				tel : function(value) {
					if (!IsMobilePhoneNumber(value)) {
						return '请输入正确的手机号!';
					}
				},
				password : [ /^[\S]{6,16}$/, '密码必须6到16位，且不能出现空格' ]
			});
			//监听提交  
			form.on('submit(editSubmit)', function(data) {
				var url = '${ctx}/admin/admin/edit';
				var data = {
					id : $("#id").val(),
					nickName : data.field.nickName,
					password : data.field.password,
					tel : data.field.tel,
					mail : data.field.mail,
					limits : $("input[type='radio']:checked").val()
				};
				doAjaxSubmit("post", url, data, "editSuccess");
			});
		});

		//提交
		function editSuccess(data) {
			if (data.errList == null) {
				//关闭窗口
				parent.layer.closeAll();
				//重载表格
				parent.reloadTable();
				//修改结果提示
				parent.layer.msg(data.msg, {
					offset : 't',
					anim : 1,
					icon : 1
				});
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