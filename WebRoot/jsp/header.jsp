<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<ul class="layui-nav layui-bg-blue">
	<li class="layui-nav-item"><a href="${ctx}/mall/index">首页</a></li>
	<c:if test="${loginUserName != null}">
		<li class="layui-nav-item" style="float: right;"><a
			href="javascript:;"><img src="${ctx}${loginHeadImg}"
				style="width: 30px; height: 30px; border-radius: 100%;">${loginUserName}</a>
			<dl class="layui-nav-child">
				<dd>
					<a href="${ctx}/user/index">个人中心</a>
				</dd>
				<dd>
					<a href="${ctx}/login/logout">退出</a>
				</dd>
			</dl></li>
		<li class="layui-nav-item" style="float: right;"><a href="${ctx}/user/carlist"><i
				class="layui-icon">&#xe657;</i> 购物车</a></li>

	</c:if>
	<c:if test="${loginUserName == null}">
		<li class="layui-nav-item" style="float: right;" onclick="regPage()">
			<a href="javascript:;">注册</a>
		</li>
		<li class="layui-nav-item" style="float: right;" onclick="loginPage()"><a
			href="javascript:;">登录</a></li>
	</c:if>
</ul>
<script>
	function loginPage() {
		layer.open({
			type : 2,
			title : '登录',
			shadeClose : true,
			shade : 0.8,
			area : [ '380px', '380px' ],
			content : '${ctx}/login/loginPage'
		});
	}

	function regPage() {
		layer.open({
			type : 2,
			title : '注册',
			shadeClose : true,
			shade : 0.8,
			area : [ '380px', '380px' ],
			content : '${ctx}/login/regPage'
		});
	}
</script>