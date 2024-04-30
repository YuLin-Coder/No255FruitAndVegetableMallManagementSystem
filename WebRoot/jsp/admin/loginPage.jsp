<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<jsp:include page="common/head.jsp">
	<jsp:param value="登录" name="titleName" />
</jsp:include>
<script src="${ctx}/res/js/jquery.cookie.js"></script>
<script src="${ctx}/res/js/jquery.ripples.js"></script>
</head>
<style>
* {
	margin: 0;
	padding: 0;
}

html {
	height: 100%;
}

body {
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	background-size: cover;
	background-position: 50% 0;
	height: 100%;
	text-align: center;
}

body:before {
	display: inline-block;
	vertical-align: middle;
	height: 100%;
}

form {
	width: 24%;
	margin-left: 38%;
	padding-top: 15%;
}
</style>
<body style="background-image: url(${ctx}/res/images/bg2.jpg)">
	<form class="layui-form layui-form-pane" action="">
		<label style="font-size: 30px; font-weight: 700; margin-bottom: 30px;">管理员登录</label>
		<div class="layui-form-item" style="margin-top: 30px;">
			<label class="layui-form-label">手机号</label>
			<div class="layui-input-block">
				<input type="text" name="tel" id="tel" lay-verify="required|tel"
					placeholder="请输入手机号" autocomplete="off" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">密码</label>
			<div class="layui-input-block">
				<input type="password" name="password" id="password"
					lay-verify="required" placeholder="请输入密码" autocomplete="off"
					class="layui-input">
			</div>
		</div>
		<div class="layui-form-item" style="float: left;">
			<input type="checkbox" id="cookieRemember" name="cookieRemember"
				value="true" lay-skin="primary" checked title="记住帐号?">
		</div>
		</div>
		<div class="layui-form-item">
			<button class="layui-btn" style="width: 100%;" lay-submit
				lay-filter="login">登录</button>
		</div>
	</form>
	<script>
		$(document).ready(
				function() {
					//获取cookie的值
					var tel = $.cookie('tel');
					var password = $.cookie('password');
					//将获取的值填充入输入框中
					$('#tel').val(tel);
					$('#password').val(password);
					if (tel != null && tel != '' && password != null
							&& password != '') {
						//选中记住密码的复选框
						$("#cookieRemember").attr('checked', true);
					}
					$('body').ripples({
						resolution : 512,
						dropRadius : 20, //px
						perturbance : 0.04
					});
				});
		layui.use([ 'form', 'layer' ], function() {
			var form = layui.form, layer = layui.layer;
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
				/** 实现记住密码功能 */
				var tel = $('#tel').val();
				var password = $('#password').val();
				if ($('#cookieRemember').is(':checked') == true) {
					$.cookie("tel", tel, {
						expires : 7
					});//存储一个带7天期限的cookie
					$.cookie("password", password, {
						expires : 7
					});
				} else {
					$.cookie("tel", "", {
						expires : -1
					});
					$.cookie("password", "", {
						expires : -1
					});
				}

				var url = "${ctx}/admin/doLogin";
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
				window.location.href = "${ctx}/admin/index";
			} else {
				layer.msg(data.errList, {
					offset : 't',
					icon : 5
				});
			}
		}
	</script>
</body>

</html>