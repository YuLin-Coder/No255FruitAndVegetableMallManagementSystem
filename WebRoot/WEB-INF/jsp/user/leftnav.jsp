<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<ul class="layui-nav layui-nav-tree layui-inline layui-bg-cyan"
	style="margin-right: 10px;">
	<li
		class="layui-nav-item <%="goodsCar".equals(request.getParameter("fun")) ? "layui-this"
					: ""%>"><a
		href="${ctx}/user/carlist"><i class="layui-icon">&#xe657;</i> 购物车</a></li>
	<li
		class="layui-nav-item  <%="index".equals(request.getParameter("fun")) ? "layui-this"
					: ""%>"><a
		href="${ctx}/user/index"><i class="layui-icon">&#xe68e;</i> 个人信息</a></li>
	<li
		class="layui-nav-item  <%="orders".equals(request.getParameter("fun")) ? "layui-this"
					: ""%>"><a
		href="${ctx}/user/orderslist"><i class="layui-icon">&#xe60a;</i> 我的订单</a></li>
	<li
		class="layui-nav-item  <%="password".equals(request.getParameter("fun")) ? "layui-this"
					: ""%>" ><a
		href="${ctx}/user/password"><i class="layui-icon">&#xe620;</i> 修改密码</a></li>
	<li
		class="layui-nav-item  <%="recAddress".equals(request.getParameter("fun")) ? "layui-this"
					: ""%>"><a
		href="${ctx}/user/addresslist"><i class="layui-icon">&#xe609;</i> 收货地址管理</a></li>
</ul>
<style>
.layui-nav-tree {
	text-align: left;
	height: 500px;
}

.layui-table {
	width: 80%;
}

.layui-col-xs3 {
	margin-top: 50px;
	text-align: right;
}

.layui-col-xs8 {
	margin-left: 30px;
	margin-top: 20px;
	text-align: left;
}

.layui-bg-cyan {
	background-color: #f3f3f3 !important;
}

.layui-nav-tree .layui-nav-item a:hover {
	background-color: #cecece;
}

.layui-nav-tree .layui-nav-child dd.layui-this,.layui-nav-tree .layui-nav-child dd.layui-this a,.layui-nav-tree .layui-this,.layui-nav-tree .layui-this>a,.layui-nav-tree .layui-this>a:hover
	{
	background-color: #cecece;
}

.layui-nav-tree .layui-nav-bar {
	background-color: #1e9fff;
}

.layui-col-xs3 ul li a {
	color: #000000 !important;
}
</style>