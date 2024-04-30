<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<jsp:include page="../head.jsp">
	<jsp:param value="用户中心" name="titleName" />
</jsp:include>
</head>
<body>
	<jsp:include page="../header.jsp" />
	<div class="layui-row">
		<div class="layui-col-xs3">
			<jsp:include page="leftnav.jsp">
				<jsp:param value="index" name="fun" />
			</jsp:include>
		</div>
		<div class="layui-col-xs8">
			<fieldset class="layui-elem-field layui-field-title"
				style="margin-top: 30px;">
				<legend>个人信息</legend>
			</fieldset>
			<table class="layui-table" lay-skin="nob">
				<tbody>
					<tr>
						<td width="100">头像</td>
						<td width="500"><img src="${ctx}${user.headImg}"
							style="height: 100px;" /></td>
					</tr>
					<tr>
						<td>昵称</td>
						<td>${user.nickName}</td>
					</tr>
					<tr>
						<td>性别</td>
						<td><c:if test="${user.sex == '男'}">
								<i class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe662;</i>
							</c:if> <c:if test="${user.sex == '女'}">
								<i class="layui-icon" style="font-size: 30px; color: #ff00eb;">&#xe661;</i>
							</c:if></td>
					</tr>
					<tr>
						<td>电话</td>
						<td>${user.tel}</td>
					</tr>
					<tr>
						<td>邮箱</td>
						<td>${user.mail}</td>
					</tr>
					<tr>
						<td>加入时间</td>
						<td>${user.createTime}</td>
					</tr>
				</tbody>
			</table>
			<button class="layui-btn layui-btn-danger" onclick="doEditPage()">编辑</button>
		</div>
	</div>

	<jsp:include page="../footer.jsp" />

	<script>
		layui.use([ 'element', 'layer' ], function() {
		});

		// 打开编辑页
		function doEditPage() {
			//iframe层
			layer.open({
				type : 2,
				title : '编辑',
				shadeClose : false,
				maxmin : true,
				shade : 0.8,
				area : [ '30%', '550px' ],
				content : '${ctx}/user/userEditPage?id=' + '${user.id}'
			});
		}
	</script>
</body>

</html>