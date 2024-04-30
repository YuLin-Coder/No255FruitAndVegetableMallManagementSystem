<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<jsp:include page="..//head.jsp">
	<jsp:param value="注册" name="titleName" />
</jsp:include>
</head>
<style>
body {
	padding: 15px;
	text-align: center;
}
</style>

<body>
	<form class="layui-form layui-form-pane" action="">
		<div class="layui-form-item">
			<label class="layui-form-label">昵称</label>
			<div class="layui-input-inline">
				<input type="text" id="nickName" name="nickName"
					lay-verify="required" placeholder="请输入昵称" maxlength="12"
					class="layui-input">
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">密码</label>
			<div class="layui-input-inline">
				<input type="password" name="password" lay-verify="required"
					placeholder="请填写6到16位密码" maxlength="16" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item" pane="">
			<label class="layui-form-label">性别</label>
			<div class="layui-input-block">
				<input type="radio" name="sex" value="男" title="男" checked="">
				<input type="radio" name="sex" value="女" title="女">
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">手机号</label>
			<div class="layui-input-inline">
				<input type="tel" name="tel" lay-verify="required"
					placeholder="请输入手机号" maxlength="11" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item">
			<button class="layui-btn layui-btn-normal" lay-submit=""
				lay-filter="reg">立即注册</button>
			<button type="button" class="layui-btn layui-btn-primary"
				onclick="doCannel()">等等再说</button>
		</div>
		<a href="javascript:;" onclick="loginPage()">已有账号？立即登录</a>
	</form>
	<script>
		$("#nickName").focus();
		layui.use([ 'element', 'form', 'layer' ], function() {
			var element = layui.element, form = layui.form; //导航的hover效果、二级菜单等功能，需要依赖element模块
			form.render();

			//监听提交
			form.on('submit(reg)', function(data) {
				var url = "${ctx}/login/doReg";
				var data = {
					nickName : data.field.nickName,
					password : data.field.password,
					sex : data.field.sex,
					tel : data.field.tel
				};
				doAjaxSubmit("post", url, data, "regSuccess");
				return false;
			});
		});
		function regSuccess(data) {
			if (data.errList == null) {
				parent.layer.msg(data.msg, {
					icon : 1
				});
				window.location.href = "${ctx}/login/loginPage?tel="
						+ data.tel;
			} else {
				layer.msg(data.errList, {
					icon : 5
				});
			}
		}

		function doCannel() {
			parent.layer.closeAll();
		}

		function loginPage() {
			window.location.href = "${ctx}/login/loginPage";
		}
	</script>
</body>

</html>