<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="head.jsp">
	<jsp:param value="商品详情" name="titleName" />
</jsp:include>
</head>
<style>
.content {
	margin-top: 20px;
	margin-left: 5%;
	margin-right: 5%;
}

.goods-content {
	height: 480px;
	width: 100%;
}

.goods-img {
	text-align: left;
	width: 45%;
	float: left;
}

.goods-img img {
	border: 1px #EEEEEE solid;
	width: 95%;
	min-height: 400px;
	max-height: 460px;
}

.goods-info {
	width: 45%;
	float: left;
	text-align: left;
	margin-top: 20px;
}

.goods-price {
	color: #FF5722;
	font-size: 20px;
	font-weight: 700;
}

.goods-title {
	font-size: 24px;
	font-weight: 500;
}

.layui-field-box {
	text-align: center;
}

.goods-right {
	border: 1px #EEEEEE solid;
	margin-top: 5px;
	height: 180px;
}

.goods-img-right {
	width: 95%;
	height: 140px;
}

.goods-price-right {
	color: #FF5722;
	font-size: 14px;
	font-weight: 500;
}

.des {
	width: 98%;
}
</style>

<body>
	<jsp:include page="header.jsp" />
	<div class="content">
		<div class="layui-row">
			<div class="layui-col-xs10">
				<div class="goods-content">
					<div class="goods-img">
						<img src="${ctx}${goods.goodsImg}" />
					</div>
					<div class="goods-info">
						<p class="goods-title">${goods.name}</p>
						<br />
						<p>类型：${goods.typeName}</p>
						<br />
						<p>
							售价：<span class="goods-price">￥${goods.price}</span>
						</p>
						<br />
						<p>库存：${goods.stockAmount}</p>
						<br />
						<p>月销：${goods.saleAmount}</p>
						<br /> <label style="float: left; line-height: 35px;">数量：</label>
						<input type="number" name="number" id="number" value="1"
							style="float: left; width: 50px;" class="layui-input">
						<div style="height: 50px; margin-top: 50px;">
							<button class="layui-btn layui-btn-bg layui-btn-danger"
								onclick="buy()">立即购买</button>
							<button class="layui-btn layui-btn-bg layui-btn-warm"
								onclick="addCar()">加入购物车</button>
						</div>

					</div>
				</div>
				<div class="des">
					<div class="layui-tab layui-tab-card">
						<ul class="layui-tab-title">
							<li class="layui-this">商品详情</li>
							<!-- <li>用户评价</li> -->
						</ul>
						<div class="layui-tab-content" style="height: 100px;">
							<div class="layui-tab-item layui-show">${goods.des}</div>
							<div class="layui-tab-item">
								<c:forEach items="${ordersList}" var="ordersList">
									<blockquote class="layui-elem-quote layui-quote-nm">
										${ordersList.rvalContent}<span style="float: right;">—${ordersList.nickName}&nbsp;&nbsp;</span>
									</blockquote>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-col-xs2">
				<div class="rec">
					<fieldset class="layui-elem-field">
						<legend>推荐</legend>
						<div class="layui-field-box">
							<c:forEach items="${goodsList}" var="goodsList">
								<div class="goods-right">
									<a href="${ctx}/mall/detail?goodsId=${goodsList.id}"> <img
										class="goods-img-right" src="${ctx}${goodsList.goodsImg}" />
										<div class="info">
											<p>${goodsList.name}</p>
											<p class="goods-price-right">￥${goodsList.price}</p>
										</div>
									</a>
								</div>
							</c:forEach>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp" />
	<script type="text/javascript">
		function addCar() {
			var number = $("#number").val();
			if (isNumber(number)) {
				var url = "${ctx}/user/addCar";
				var data = {
					goodsId : '${goods.id}',
					amount : $("#number").val()
				};
				doAjaxSubmit("post", url, data, "addSuccess");
			}
		}
		function addSuccess(data) {
			if (data.errList == null) {
				layer.msg(data.msg, {
					offset : 't',
					icon : 1
				});
			} else {
				layer.msg(data.errList, {
					offset : 't',
					icon : 5
				});
			}
		}

		function buy() {
			var number = $("#number").val();
			if (isNumber(number)) {
				window.location.href = "${ctx}/user/buyPage?goodsId=${goods.id}"
						+ "&flag=info&amount=" + number;
			}
		}

		function isNumber(value) {
			var result = true;
			if ('${loginUserId}' == '') {
				loginPage();
				result = false;
			}
			var patrn = /^[1-9]*$/;
			if (patrn.exec(value) == null || value == "") {
				layer.msg('请输入正确的数量！', {
					offset : 't',
					icon : 5
				});
				result = false;
			}
			if (parseInt(value) > parseInt('${goods.stockAmount}')) {
				layer.msg('库存不够' + value + '个！', {
					offset : 't',
					icon : 5
				});
				result = false;
			}
			return result;
		}
	</script>
</body>

</html>