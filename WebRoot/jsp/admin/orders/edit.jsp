<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../common/head.jsp">
	<jsp:param value="评价" name="titleName" />
</jsp:include>
</head>
<body style="text-align: center;">
	<form class="layui-form" style="margin-right: 20px;">
		<div class="user_left">
			<input type="hidden" id="id" name="id" value="${orderId}">
			<table class="layui-table" lay-skin="line">
				<colgroup>
					<col width="150">
					<col width="150">
					<col width="200">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th>序号</th>
						<th>商品图片</th>
						<th>商品名</th>
						<th>评价</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${orderInfoList}" var="orderInfoList"
						varStatus="vs">
						<tr>
							<td>${vs.count}</td>
							<td><img style="width: 100px;"
								src="${ctx}${orderInfoList.goodsImg}" /></td>
							<td>${orderInfoList.goodsName}</td>
							<td><c:if test="${isEval != 'isEval'}">
									<input type="radio" name="evel${vs.count}" value="5" title="满意"
										checked="">
									<input type="radio" name="evel${vs.count}" value="3" title="一般">
									<input type="radio" name="evel${vs.count}" value="1"
										title="不满意">
								</c:if> <c:if test="${isEval == 'isEval'}">
									<c:if test="${orderInfoList.eval == '5'}">
									满意
									</c:if>
									<c:if test="${orderInfoList.eval == '3'}">
									一般
									</c:if>
									<c:if test="${orderInfoList.eval == '1'}">
									不满意
									</c:if>
								</c:if> <br> <c:if test="${isEval != 'isEval'}">
									<input class="layui-input" value="不错。" lay-verify="required"
										name="revelContent${vs.count}" id="revelContent${vs.count}"
										maxlength="50" size="50" />
								</c:if> <c:if test="${isEval == 'isEval'}">
									<p>${orderInfoList.rvalContent}</p>
								</c:if></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<c:if test="${isEval != 'no'}">
			暂未评价
		</c:if>
		<button type="button" onclick="doCannel()"
			class="layui-btn layui-btn-primary">返回</button>
	</form>
	<script>
		layui.use([ 'form', 'table' ], function() {
			var form = layui.form;
			form.render();

		});

		//取消
		function doCannel() {
			parent.layer.closeAll();
		}
	</script>
</body>
</html>