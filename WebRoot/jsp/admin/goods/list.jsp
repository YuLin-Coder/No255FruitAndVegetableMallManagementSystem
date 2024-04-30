<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../common/head.jsp">
	<jsp:param value="商品管理" name="titleName" />
</jsp:include>
</head>
<body>
	<jsp:include page="../common/header.jsp">
		<jsp:param value="goods" name="fun" />
	</jsp:include>
	<blockquote class="layui-elem-quote">
		<button class="layui-btn layui-btn-sm" onclick="doAddPage()">
			<i class="layui-icon">&#xe608;</i> 新增商品
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-primary"
			onclick="reloadTable()">
			<i class="layui-icon">&#x1002;</i> 刷新
		</button>
		<div class="layui-form-item" style="float: right;">
			<form>
				<div class="layui-input-inline">
					<input type="text" id="serachName" placeholder="商品名"
						class="layui-input">
				</div>
				<button type="button" class="layui-btn" onclick="reloadTable()">
					<i class="layui-icon">&#xe615;</i>
				</button>
				<button type="reset" class="layui-btn layui-btn-primary">重置</button>
			</form>
		</div>
	</blockquote>
	<div id="layer-photos">
		<table class="layui-hide" id="TABLE_GOODS" lay-filter="goods"></table>
	</div>
	<script type="text/html" id="operationBar">
		{{#  if(d.useFlag == 0){ }}
  	 		<a class="layui-btn layui-btn-xs" lay-event="ok">上架</a>
  		{{#  } else if(d.useFlag == 1){ }}
			<a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="stop">下架</a>
  	 	{{#  } }}
  		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>
  		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="noTpl">
  		{{ d.LAY_INDEX }}
	</script>
	<script type="text/html" id="goodsImg">
  		<img style="height:30px;" src="${ctx}{{ d.goodsImg }}" layer-src="${ctx}{{ d.goodsImg }}" onclick="openImage()">
	</script>
	<script type="text/html" id="useFlag">
 	 	{{#  if(d.useFlag == 0){ }}
  	 		未上架
  		{{#  } else if(d.useFlag == 1){ }}
  		 	出售中
  	 	{{#  } }}
	</script>
	<jsp:include page="../common/footer.jsp" />
	<script>
		layui.use([ 'layer', 'table', 'element' ], function() {
			var table = layui.table;
			layer = layui.layer; //表格

			var tableIns = table.render({
				elem : '#TABLE_GOODS' //指定原始表格元素选择器（推荐id选择器）
				,
				id : 'goodsTable',
				cols : [ [ {
					field : 'id',
					title : '序号',
					width : '10%',
					align : 'center',
					sort : true,
					fixed : true,
					templet : '#noTpl'
				}, {
					field : 'typeName',
					title : '商品类型',
					width : '10%',
					align : 'center',
					sort : true
				}, {
					field : 'name',
					title : '商品名',
					width : '12%',
					align : 'center'
				}, {
					field : 'goodsImg',
					title : '商品图片',
					width : '10%',
					align : 'center',
					templet : '#goodsImg'
				}, {
					field : 'price',
					title : '价格',
					width : '10%',
					align : 'center',
					sort : true
				}, {
					field : 'stockAmount',
					title : '库存',
					width : '10%',
					align : 'center',
					sort : true
				}, {
					field : 'createTime',
					title : '创建时间',
					width : '15%',
					align : 'center',
					sort : true
				}, {
					field : 'useFlag',
					title : '状态',
					width : '8%',
					align : 'center',
					sort : true,
					templet : '#useFlag'
				}, {
					fixed : 'right',
					title : '操作',
					width : '15%',
					align : 'center',
					toolbar : '#operationBar'
				} ] ],
				url : '${ctx}/admin/goods/getList',
				page : true,
				height : 'pull-315',
				limits : [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ],
				limit : 10,
				done : function(res, curr, count) {
					//如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、curr为当前页、count为数据总长度
				}
			});

			//监听工具条
			table.on('tool(goods)', function(obj) { //注：tool是工具条事件名，goodsTable是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值
				var id = data.id;
				if (layEvent === 'del') { //删除
					layer.confirm('确定删除这个商品么？', function(index) {
						obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
						layer.close(index);
						//向服务端发送删除指令
						doDelete(id);
					});
				} else if (layEvent === 'edit') { //编辑
					doEditPage(id);
					//同步更新缓存对应的值
					obj.update({});
				} else if (layEvent === 'stop') { //下架
					doStop(id);
					//同步更新缓存对应的值
					obj.update({});
				} else if (layEvent === 'ok') { //上架
					doOk(id);
					//同步更新缓存对应的值
					obj.update({});
				}
			});
		});

		function openImage() {
			layer.photos({
				photos : '#layer-photos',
				anim : 5
			//0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
			});
		}

		function reloadTable() {
			layui.use('table', function() {
				var table = layui.table //表格
				table.reload('goodsTable', {
					where : {
						serachName : $('#serachName').val()
					}
				});
			});

		}

		// 打开新增页
		function doAddPage(id) {
			//iframe层
			layer.open({
				type : 2,
				title : '新增',
				shadeClose : false,
				maxmin : true,
				shade : 0.8,
				area : [ '40%', '655px' ],
				content : '${ctx}/admin/goods/editPage'
			});
		}

		// 打开编辑页
		function doEditPage(id) {
			//iframe层
			layer.open({
				type : 2,
				title : '编辑',
				shadeClose : false,
				maxmin : true,
				shade : 0.8,
				area : [ '40%', '655px' ],
				content : '${ctx}/admin/goods/editPage?id=' + id
			});
		}

		// 删除
		function doDelete(id) {
			var url = '${ctx}/admin/goods/delete';
			var data = {
				id : id
			}
			doAjaxSubmit("post", url, data, "deleteSuccess");
		}
		//删除回调
		function deleteSuccess(data) {
			layer.msg(data.msg, {
				offset : 't',
				icon : 1
			});
			return false;
		}

		//下架
		function doStop(id) {
			var url = '${ctx}/admin/goods/stop';
			var data = {
				id : id
			};
			doAjaxSubmit("post", url, data, "stopSuccess");
		}
		function stopSuccess(data) {
			location.reload();
			parent.layer.msg(data.msg, {
				offset : 't',
				icon : 1
			});
			return false;
		}
		//上架
		function doOk(id) {
			var url = '${ctx}/admin/goods/ok';
			var data = {
				id : id
			};
			doAjaxSubmit("post", url, data, "okSuccess");
		}
		function okSuccess(data) {
			location.reload();
			parent.layer.msg(data.msg, {
				offset : 't',
				icon : 1
			});
			return false;
		}
	</script>
</body>
</html>