<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="head.jsp">
	<jsp:param value="商品列表" name="titleName" />
</jsp:include>
</head>
<style>
.goods-area {
	text-align: center;
	width: 100%;
	height: 520px;
}

.goods {
	width: 19%;
	height: 250px;
	margin-top: 10px;
	margin-left: 10px;
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

.layui-tab {
	margin: 30px 0 0 0;
	text-align: center !important;
}

.layui-tab-title {
	border-bottom-style: none;
}

.layui-tab-brief>.layui-tab-title .layui-this {
	color: #1E9FFF;
}

.layui-tab-brief>.layui-tab-more li.layui-this:after,.layui-tab-brief>.layui-tab-title .layui-this:after
	{
	border-bottom: 2px solid #1E9FFF;
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
						src="${ctx}/res/images/logo.jpg" /></a>
				</div>
			</div>
			<div class="layui-col-xs6">
				<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
					<ul class="layui-tab-title">
						<li id="all" onclick="getGoodsList('all')">全部</li>
						<c:forEach items="${typeList}" var="typeList" varStatus="vs">
							<li id="${typeList.id}" onclick="getGoodsList('${typeList.id}')">
								${typeList.name}</li>
						</c:forEach>
					</ul>
				</div>
			</div>
			<div class="layui-col-xs4">
				<div class="serach">
					<form class="layui-form" action="">
						<div class="layui-form-item">
							<div class="layui-input-inline" style="width: 280px;">
								<input type="text" name="serachName" id="serachName"
									value="${serachName}" placeholder="请输入商品名称..."
									autocomplete="off" class="layui-input">
							</div>
							<div class="layui-input-inline" style="width: 100px;">
								<button class="layui-btn layui-btn-normal" type="button"
									onclick="getGoodsList('')">
									<i class="layui-icon">&#xe615;</i> 搜索
								</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="goods-area">
		<div id="goodsListView"></div>
	</div>
	<jsp:include page="footer.jsp" />
	<!-- 模板 -->
	<script id="goodsList" type="text/html">
	<ul class="fly-list">
 	{{#  layui.each(d.list, function(index, item){ }}
		<a href="${ctx}/mall/detail?goodsId={{ item.id }}">
		<div class="goods">
			<img class="goods-img" src="${ctx}{{ item.goodsImg }}" />
			<div class="info">
				<p>{{ item.name }}</p>
				<p class="goods-price">￥{{ item.price }}</p>
			</div>
		</div>
		</a>
	 {{#  }); }}
	 {{#  if(d.goodsAmount === 0){ }}
	 	   没有找到您搜索的商品~
	 {{#  } }} 
	</ul>
	{{#  if(d.goodsAmount > 20){ }}
	 	  <div id="goodsListPage" style="text-align: center"></div>
	{{#  } }} 
	</script>
	<script>
		var page = 1;
		var limit = 20;
		var count = 0;
		var typeIdFlag = '${typeId}';
		layui.use([ 'laypage', 'laytpl', 'layer' ], function() {
			getGoodsList(typeIdFlag);
		});
		window.onscroll = function() {
			var topScroll = getScrollTop(); //滚动的距离,距离顶部的距离
			var bignav = document.getElementById("bignav"); //获取到导航栏id
			if (topScroll > 120) { //当滚动距离大于250px时执行下面的东西
				bignav.style.position = 'fixed';
				bignav.style.top = '0';
				bignav.style.zIndex = '9999';
				bignav.style.borderBottom = '1px #eeeeee solid'
			} else { //当滚动距离小于250的时候执行下面的内容，也就是让导航栏恢复原状
				bignav.style.position = 'static';
				bignav.style.borderBottom = 'none';
			}
		};

		// 取得商品列表信息
		function getGoodsList(typeId) {
			if (typeId == 'all' || typeIdFlag == 'all') {
				typeIdFlag = '';
				typeId = '';
				$("#all").addClass('layui-this');
			} else if (typeId == '') {
				typeIdFlag = '';
				$("#all").addClass('layui-this');
			} else {
				typeIdFlag = typeId;
				$("#" + typeId).addClass('layui-this');
			}
			var url = '${ctx}/mall/getGoodsList';
			var data = {
				page : page,
				limit : limit,
				serachName : $("#serachName").val(),
				typeId : typeId
			};
			doAjaxSubmit("post", url, data, "getGoodsListSuccess");
		}

		// 取得商品列表回调
		function getGoodsListSuccess(data) {
			var getTpl = goodsList.innerHTML;
			var view = document.getElementById('goodsListView');
			var laytpl = layui.laytpl;
			laytpl(getTpl).render(data.data, function(html) {
				view.innerHTML = html;
			});

			count = data.goodsAmount;

			var laypage = layui.laypage;
			//论题分页
			laypage.render({
				elem : 'goodsListPage',
				count : count,
				theme : '#1E9FFF',
				limit : limit,
				limits : [ 20, 30, 50, 80, 100 ],
				curr : page,
				first : '首页',
				last : '尾页',
				layout : [ 'count', 'prev', 'page', 'next', 'limit', 'skip' ],
				jump : function(obj, first) {
					//首次不执行
					if (!first) {
						page = obj.curr;
						limit = obj.limit;
						getGoodsList(typeIdFlag);
						backTop();
					}
				}
			});
		}
	</script>
</body>

</html>