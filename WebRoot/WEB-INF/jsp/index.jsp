<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="head.jsp">
	<jsp:param value="首页" name="titleName" />
</jsp:include>
</head>
<style>
#banner img {
	width: 100%;
	height: 450px;
}

.layui-tab-title {
	border-bottom-style: hidden;
}

.layui-tab {
	text-align: center !important;
	margin-top: 30px;
}

.goods-area {
	text-align: center;
	width: 100%;
	height: 520px;
}

.goods {
	width: 18%;
	height: 250px;
	margin-top: 10px;
	margin-left: 20px;
	float: left;
	transition: all 0.6s;
}

.goods:hover {
	box-shadow: 0px 0px 15px 5px #DEDEDE;
	transform: scale(1.05);
}

.goods-img {
	height: 200px;
	width: 90%;
}

.goods-price {
	color: #FF5722;
	font-size: 20px;
	font-weight: 700;
}

.logo {
	margin-left: 50%;
	margin-top: 10px;
	margin-bottom: 10px;
	float: left;
}

.logo img {
	height: 80px;
}

.serach {
	margin-top: 30px;
}

.serach input {
	width: 100%;
}
</style>

<body>
	<jsp:include page="header.jsp" />
	<div
		style="background-color: #FFFFFF; text-align: center; width: 100%;"
		id="bignav">
		<div class="layui-row">
			<div class="layui-col-xs2">
				<div class="logo">
					<a href="${ctx}/mall/index"><img
						src="${ctx}/res/images/logo.png" /></a>
				</div>
			</div>
			<div class="layui-col-xs6">
				<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
					<ul class="layui-tab-title">
						<a href="${ctx}/mall/list?typeId=all">
							<li>全部</li>
						</a>
						<c:forEach items="${typeList}" var="typeList" varStatus="vs">
							<a href="${ctx}/mall/list?typeId=${typeList.id}">
								<li>${typeList.name}</li>
							</a>
						</c:forEach>
					</ul>
				</div>
			</div>
			<div class="layui-col-xs4">
				<div class="serach">
					<form class="layui-form" action="${ctx}/mall/list?typeId=all"
						method="post">
						<div class="layui-form-item">
							<div class="layui-input-inline" style="width: 280px;">
								<input type="text" name="serachName" id="serachName"
									placeholder="请输入商品名称..." autocomplete="off" class="layui-input">
							</div>
							<div class="layui-input-inline" style="width: 100px;">
								<button style="background-color:#8fce23;" class="layui-btn " type="submit">
									<i class="layui-icon">&#xe615;</i> 搜索
								</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="layui-carousel" id="banner">
		<div carousel-item="">
			<div>
				<img src="${ctx}/res/images/banner1.png">
			</div>
			<div>
				<img src="${ctx}/res/images/banner2.png">
			</div>
			<div>
				<img src="${ctx}/res/images/banner3.png">
			</div>
			<div>
				<img src="${ctx}/res/images/banner4.png">
			</div>
			
		</div>
	</div>

	<fieldset class="layui-elem-field layui-field-title"
		style="margin-top: 25px;">
		<legend>为您推荐</legend>
	</fieldset>
	<div class="goods-area">
		<c:forEach items="${recList}" var="recList">
			<a href="${ctx}/mall/detail?goodsId=${recList.id}">
				<div class="goods">
					<img class="goods-img" src="${ctx}${recList.goodsImg}" />
					<div class="info">
						<p>${recList.name}</p>
						<p class="goods-price">￥${recList.price}</p>
					</div>
				</div>
			</a>
		</c:forEach>
	</div>
	<fieldset class="layui-elem-field layui-field-title"
		style="margin-top: 25px;">
		<legend>热卖商品</legend>
	</fieldset>
	<div class="goods-area">
		<c:forEach items="${hotList}" var="hotList">
			<a href="${ctx}/mall/detail?goodsId=${hotList.id}">
				<div class="goods">
					<img class="goods-img" src="${ctx}${hotList.goodsImg}" />
					<div class="info">
						<p>${hotList.name}</p>
						<p class="goods-price">￥${hotList.price}</p>
					</div>
				</div>
			</a>
		</c:forEach>
	</div>
	<fieldset class="layui-elem-field layui-field-title"
		style="margin-top: 25px;">
		<legend>最新上市</legend>
	</fieldset>
	<div class="goods-area">
		<c:forEach items="${newList}" var="newList">
			<a href="${ctx}/mall/detail?goodsId=${newList.id}">
				<div class="goods">
					<img class="goods-img" src="${ctx}${newList.goodsImg}" />
					<div class="info">
						<p>${newList.name}</p>
						<p class="goods-price">￥${newList.price}</p>
					</div>
				</div>
			</a>
		</c:forEach>
	</div>
	<jsp:include page="footer.jsp" />
	<script>
		layui.use([ 'element', 'carousel', 'form' ], function() {
			var form = layui.form, carousel = layui.carousel;
			//图片轮播
			carousel.render({
				elem : '#banner',
				width : '100%',
				height : '450px',
				interval : 5000
			});
		});
		window.onscroll = function() {
			var topScroll = getScrollTop(); //滚动的距离,距离顶部的距离
			var bignav = document.getElementById("bignav"); //获取到导航栏id
			if (topScroll > 120) { //当滚动距离大于250px时执行下面的东西
				bignav.style.position = 'fixed';
				bignav.style.top = '0';
				bignav.style.zIndex = '9999';
				bignav.style.borderBottom = '1px #eeeeee solid';
			} else { //当滚动距离小于250的时候执行下面的内容，也就是让导航栏恢复原状
				bignav.style.position = 'static';
				bignav.style.borderBottom = 'none';
			}
		};
	</script>
</body>

</html>