<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<ul class="layui-nav layui-bg-cyan">
	<li
		class="layui-nav-item <%="user".equals(request.getParameter("fun"))
					? "layui-this"
					: ""%>"><a
		href="${ctx}/admin/user/list">用户管理</a></li>
	<li
		class="layui-nav-item <%="goods".equals(request.getParameter("fun"))
					? "layui-this"
					: ""%>"><a
		href="${ctx}/admin/goods/list">商品管理</a></li>
	<c:if test="${limit == '运维人员' || limit == '超级管理员'}">
		<li
			class="layui-nav-item <%="goodsType".equals(request.getParameter("fun"))
						? "layui-this"
						: ""%>"><a
			href="${ctx}/admin/goodsType/list">商品类型管理</a></li>
	</c:if>
	<li
		class="layui-nav-item <%="orders".equals(request.getParameter("fun"))
					? "layui-this"
					: ""%>"><a
		href="${ctx}/admin/orders/list">订单管理</a></li>
	<c:if test="${limit == '超级管理员'}">
		<li
			class="layui-nav-item <%="admin".equals(request.getParameter("fun"))
						? "layui-this"
						: ""%>"><a
			href="${ctx}/admin/admin/list">子管理员管理</a></li>
	</c:if>
	<c:if test="${loginAdminName != null}">
		<li class="layui-nav-item" style="float: right;"><a
			href="javascript:;">${loginAdminName}</a>
			<dl class="layui-nav-child">
				<dd>
					<a href="#" onclick="adminInfo()">个人信息</a>
				</dd>
				<dd>
					<a href="#" onclick="adminPassword()">修改密码</a>
				</dd>
				<dd>
					<a href="${ctx}/admin/logout">退出</a>
				</dd>
			</dl></li>
	</c:if>
</ul>
<script type="text/javascript">
	layui.use([ 'element' ], function() {

	});
	function adminInfo() {
		layer.open({
			type : 2,
			title : '编辑个人信息',
			shadeClose : false,
			maxmin : true,
			shade : 0.8,
			area : [ '30%', '300px' ],
			content : '${ctx}/admin/adminInfo'
		});
	}

	function adminPassword() {
		layer.open({
			type : 2,
			title : '修改密码',
			shadeClose : false,
			maxmin : true,
			shade : 0.8,
			area : [ '30%', '300px' ],
			content : '${ctx}/admin/adminPassword'
		});
	}
</script>
