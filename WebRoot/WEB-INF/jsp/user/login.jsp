<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<jsp:include page="../head.jsp">
	<jsp:param value="登录" name="titleName" />
</jsp:include>
</head>
<style>
body {
	padding: 15px;
	text-align: center;
}
</style>

<body>
	<fieldset class="layui-elem-field layui-field-title"
		style="margin-top: 30px;">
		<legend>欢迎来到果蔬商城</legend>
	</fieldset>

	<form class="layui-form layui-form-pane" action="">
		<div class="layui-form-item" style="display: inline-table;">
			<label class="layui-form-label">手机号</label>
			<div class="layui-input-inline">
				<input type="text" value="${tel}" name="tel" id="tel"
					lay-verify="required|tel" placeholder="请输入手机号" maxlength="11"
					class="layui-input">
			</div>
		</div>
		<br>
		<div class="layui-form-item" style="display: inline-table;">
			<label class="layui-form-label">密码</label>
			<div class="layui-input-inline">
				<input type="password" name="password" lay-verify="required"
					placeholder="请填写6到16位密码" maxlength="16" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item">
			<button class="layui-btn " style="background-color:#8fce23;" lay-submit="" lay-filter="login">立即登录</button>
			<button type="button" class="layui-btn layui-btn-primary"
				onclick="regPage()">注册账号</button>
		</div>
	</form>
	<script>
		$("#nickName").focus();
		layui.use([ 'element', 'form', 'layer' ], function() {
			var element = layui.element, form = layui.form; //导航的hover效果、二级菜单等功能，需要依赖element模块
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
			form.on('submit(login)', function(data) {
				var url = "${ctx}/login/doLogin";
				var data = {
					tel : data.field.tel,
					password : data.field.password
				};
				doAjaxSubmit("post", url, data, "loginSuccess");
				return false;
			});
		});
		function loginSuccess(data) {
			if (data.errList == null) {
				parent.window.location.href = "${ctx}/mall/index";
			} else {
				layer.msg(data.errList, {
					icon : 5
				});
			}
		}

		function regPage() {
			window.location.href = "${ctx}/login/regPage";
		}
	</script>
</body>

</html>