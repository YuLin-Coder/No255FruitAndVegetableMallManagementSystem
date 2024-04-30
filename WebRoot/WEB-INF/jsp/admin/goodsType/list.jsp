<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../common/head.jsp">
	<jsp:param value="商品类型管理" name="titleName" />
</jsp:include>
</head>
<body>
	<jsp:include page="../common/header.jsp">
		<jsp:param value="goodsType" name="fun" />
	</jsp:include>
	<blockquote class="layui-elem-quote">
		<button class="layui-btn layui-btn-sm" onclick="doAddPage()">
			<i class="layui-icon">&#xe608;</i> 新增类型
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-primary"
			onclick="reloadTable()">
			<i class="layui-icon">&#x1002;</i> 刷新
		</button>
		<div class="layui-form-item" style="float: right;">
			<form>
				<div class="layui-input-inline">
					<input type="text" id="serachName" placeholder="类型名"
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
		<table class="layui-hide" id="TABLE_TYPE" lay-filter="goodsType"></table>
	</div>
	<script type="text/html" id="operationBar">
  		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>
  		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="noTpl">
  		{{ d.LAY_INDEX }}
	</script>
	<jsp:include page="../common/footer.jsp" />
	<script>
		layui.use([ 'layer', 'table', 'element' ], function() {
			var table = layui.table;
			layer = layui.layer; //表格

			var tableIns = table.render({
				elem : '#TABLE_TYPE' //指定原始表格元素选择器（推荐id选择器）
				,
				id : 'goodsTypeTable',
				cols : [ [ {
					field : 'id',
					title : '序号',
					width : '10%',
					align : 'center',
					sort : true,
					fixed : true,
					templet : '#noTpl'
				}, {
					field : 'name',
					title : '类型名',
					width : '20%',
					align : 'center'
				}, {
					field : 'sort',
					title : '顺序',
					width : '15%',
					align : 'center'
				}, {
					field : 'createOperator',
					title : '创建人',
					width : '15%',
					align : 'center'
				}, {
					field : 'createTime',
					title : '创建时间',
					width : '20%',
					align : 'center'
				}, {
					fixed : 'right',
					title : '操作',
					width : '20%',
					align : 'center',
					toolbar : '#operationBar'
				} ] ],
				url : '${ctx}/admin/goodsType/getList',
				page : true,
				height : 'pull-315',
				limits : [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ],
				limit : 10,
				done : function(res, curr, count) {
					//如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、curr为当前页、count为数据总长度
				}
			});

			//监听工具条
			table.on('tool(goodsType)', function(obj) { //注：tool是工具条事件名，goodsTypeTable是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				var id = data.id;
				if (layEvent === 'del') { //删除
					layer.confirm('确定删除这个商品类型么？', function(index) {
						obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
						layer.close(index);
						//向服务端发送删除指令
						doDelete(id);
					});
				} else if (layEvent === 'edit') { //编辑
					doEditPage(id);
					//同步更新缓存对应的值
					obj.update({});
				}
			});
		});

		function reloadTable() {
			layui.use('table', function() {
				var table = layui.table; //表格
				table.reload('goodsTypeTable', {
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
				area : [ '30%', '250px' ],
				content : '${ctx}/admin/goodsType/editPage'
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
				area : [ '30%', '250px' ],
				content : '${ctx}/admin/goodsType/editPage?id=' + id
			});
		}

		// 删除
		function doDelete(id) {
			var url = '${ctx}/admin/goodsType/delete';
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
	</script>
</body>
</html>