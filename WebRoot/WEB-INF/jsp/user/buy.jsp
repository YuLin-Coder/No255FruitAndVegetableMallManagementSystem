<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<jsp:include page="../head.jsp">
	<jsp:param value="下单" name="titleName" />
</jsp:include>
</head>
<style>
.order-content {
	padding-left: 50px;
	padding-right: 50px;
	padding-top: 20px;
}

.buy {
	margin-top: 50px;
	float: right;
}

.sumPrice {
	color: red;
	font-size: 24px !important;
}
</style>

<body>
	<jsp:include page="../header.jsp" />
	<div class="order-content">
		<fieldset class="layui-elem-field layui-field-title"
			style="margin-top: 30px;">
			<legend>确认订单</legend>
		</fieldset>

		<table class="layui-table" lay-skin="line">
			<colgroup>
				<col width="30">
				<col width="120">
				<col width="150">
				<col width="30">
				<col width="30">
				<col width="30">
			</colgroup>
			<thead>
				<tr>
					<th>序号</th>
					<th>图片</th>
					<th>标题</th>
					<th>单价</th>
					<th>数量</th>
					<th>总价</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${goodsList}" var="goodsList" varStatus="vs">
					<tr>
						<td>${vs.count}</td>
						<td><img src="${ctx}${goodsList.goodsImg}" style=""></td>
						<td>${goodsList.name}</td>
						<td>￥${goodsList.price}</td>
						<td><c:if test="${flag == 'car'}">
						${goodsList.amount}
						</c:if> <c:if test="${flag == 'info'}">
						${amount}
						</c:if></td>
						<td class="sumPrice">￥ <c:if test="${flag == 'info'}">
						 ${sumPrice}
						 </c:if> <c:if test="${flag == 'car'}">
						 ${goodsList.sumPrice}
						 </c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<fieldset class="layui-elem-field layui-field-title">
			<legend>选择收货地址</legend>
		</fieldset>
		<form class="layui-form" action="">
			<div class="layui-form-item">
				<label class="layui-form-label">收货地址</label>
				<div class="layui-input-block">
					<select name="address" lay-verify="required" id="address">
						<c:forEach items="${addressList}" var="addressList">
							<option value="${addressList.id}">${addressList.name}--${addressList.tel}--${addressList.address}</option>
						</c:forEach>
					</select>
				</div>
			</div>
		</form>
		<div class="buy">
			<button onclick="buy()" id="buyBtn"
				class="layui-btn layui-btn-lg layui-btn-danger">结算(￥${resultPrice})</button>
		</div>
	</div>

	<jsp:include page="../footer.jsp" />
	<script>
		layui.use([ 'element', 'form', 'layer' ], function() {
		});

		function buy() {
			var recAddressId = $("#address").val();
			if (recAddressId == '') {
				layer.msg('没有收货地址！请在个人中心-收货地址管理处维护收货地址！', {
					icon : 5
				});
				return false;
			}
			var url = "${ctx}/user/buy";
			var data = {
				goodsId : '${goodsId}',
				carId : '${carId}',
				flag : '${flag}',
				amount : '${amount}',
				recAddressId : recAddressId
			};
			doAjaxSubmit("post", url, data, "buySuccess");
		}
		function buySuccess(data) {
			if (data.errList == null) {
				window.location.href = "${ctx}/user/orderslist?flag=buy";
			} else {
				layer.msg(data.errList, {
					icon : 5
				});
				return false;
			}
		}
	</script>
</body>

</html>