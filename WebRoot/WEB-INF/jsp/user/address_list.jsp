<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../head.jsp">
	<jsp:param value="地址管理" name="titleName" />
</jsp:include>
</head>
<body>
	<jsp:include page="../header.jsp" />
	<div class="layui-row">
		<div class="layui-col-xs3">
			<jsp:include page="leftnav.jsp">
				<jsp:param value="recAddress" name="fun" />
			</jsp:include>
		</div>
		<div class="layui-col-xs8">
			<fieldset class="layui-elem-field layui-field-title"
				style="margin-top: 30px;">
				<legend>我的收货地址</legend>
			</fieldset>
			<blockquote class="layui-elem-quote">
				<button class="layui-btn layui-btn-sm layui-btn-normal"
					onclick="doAddPage()">
					<i class="layui-icon">&#xe608;</i> 新增地址
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary"
					onclick="reloadTable()">
					<i class="layui-icon">&#x1002;</i> 刷新
				</button>
			</blockquote>
			<table class="layui-hide" id="TABLE_ADDRESS" lay-filter="address"></table>
		</div>
	</div>
	<jsp:include page="../footer.jsp" />
	<script type="text/html" id="operationBar">
  		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>
  		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="noTpl">
  		{{ d.LAY_INDEX }}
	</script>
	<script>
		layui.use([ 'layer', 'table', 'element' ], function() {
			var table = layui.table;
			layer = layui.layer; //表格

			var tableIns = table.render({
				elem : '#TABLE_ADDRESS' //指定原始表格元素选择器（推荐id选择器）
				,
				id : 'addressTable',
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
					title : '收货人姓名',
					width : '15%',
					align : 'center'
				}, {
					field : 'tel',
					title : '收货人联系电话',
					width : '20%',
					align : 'center',
					sort : true
				}, {
					field : 'address',
					title : '收货人地址',
					width : '30%',
					align : 'center'
				}, {
					fixed : 'right',
					title : '操作',
					width : '20%',
					align : 'center',
					toolbar : '#operationBar'
				} ] ],
				url : '${ctx}/user/getAddressList',
				page : true,
				height : 'pull-315',
				limits : [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ],
				limit : 10,
				done : function(res, curr, count) {
					//如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、curr为当前页、count为数据总长度
				}
			});

			//监听工具条
			table.on('tool(address)', function(obj) { //注：tool是工具条事件名，addressTable是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值
				var id = data.id;
				if (layEvent === 'del') { //删除
					layer.confirm('确定删除这个地址么？', function(index) {
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
				table.reload('addressTable', {
					where : {}
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
				area : [ '30%', '350px' ],
				content : '${ctx}/user/editAddressPage'
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
				area : [ '30%', '350px' ],
				content : '${ctx}/user/editAddressPage?id=' + id
			});
		}

		// 删除
		function doDelete(id) {
			var url = '${ctx}/user/deleteAddress';
			var data = {
				id : id
			};
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