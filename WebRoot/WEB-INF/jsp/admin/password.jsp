<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="common/head.jsp">
	<jsp:param value="修改密码" name="titleName" />
</jsp:include>
</head>
<style>
.layui-form-item {
	margin-right: 20px;
}
</style>
<body class="childrenBody">
	<form class="layui-form">
		<div class="user_left" style="margin-top: 20px;">
			<input type="hidden" id="id" name="id" value="${admin.id}">
			<div class="layui-form-item">
				<label class="layui-form-label">旧密码</label>
				<div class="layui-input-block">
					<input type="password" name="password_old" value=""
						lay-verify="required|password" maxlength="16" class="layui-input">
				</div>
			</div>

			<div class="layui-form-item">
				<label class="layui-form-label">新密码</label>
				<div class="layui-input-block">
					<input type="password" name="password" value=""
						lay-verify="required|password" maxlength="16" class="layui-input">
				</div>
			</div>

			<div class="layui-form-item">
				<label class="layui-form-label">再输一遍</label>
				<div class="layui-input-block">
					<input type="password" name="password2" value=""
						lay-verify="required|password" maxlength="16" class="layui-input">
				</div>
			</div>

		</div>
		<div class="layui-form-item" style="margin-left: 5%;">
			<div class="layui-input-block">
				<button type="button" class="layui-btn" lay-submit=""
					lay-filter="editSubmit">保存</button>
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
				password : [ /^[\S]{6,16}$/, '密码必须6到16位，且不能出现空格' ]
			});

			//监听提交  
			form.on('submit(editSubmit)', function(data) {
				if (data.field.password != data.field.password2) {
					layer.msg("两次输入的密码不一致", {
						icon : 5
					});
					return false;
				}
				var url = '${ctx}/admin/adminPasswordEdit';
				var data = {
					password_old : data.field.password_old,
					password : data.field.password
				};
				doAjaxSubmit("post", url, data, "editSuccess");
			});
		});

		//提交
		function editSuccess(data) {
			debugger;
			if (data.errList == null) {
				//关闭窗口
				parent.layer.closeAll();
				//修改结果提示
				parent.layer.msg(data.msg, {
					offset : 't',
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