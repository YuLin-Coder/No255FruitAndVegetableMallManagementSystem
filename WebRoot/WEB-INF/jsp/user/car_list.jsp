<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>

<head>
<jsp:include page="../head.jsp">
	<jsp:param value="购物车" name="titleName" />
</jsp:include>
</head>
<body>
	<jsp:include page="../header.jsp" />
	<div class="layui-row">
		<div class="layui-col-xs3">
			<jsp:include page="leftnav.jsp">
				<jsp:param value="goodsCar" name="fun" />
			</jsp:include>
		</div>
		<div class="layui-col-xs8">
			<fieldset class="layui-elem-field layui-field-title"
				style="margin-top: 30px;">
				<legend>我的购物车</legend>
			</fieldset>
			<table class="layui-hide" id="TABLE_GOODSCAR" lay-filter="goodsCar"></table>
			<button style="float: right;" class="layui-btn layui-btn-danger"
				onclick="doBuy()">提交订单</button>
		</div>
	</div>

	<jsp:include page="../footer.jsp" />
	<script type="text/html" id="operationBar">
		{{#  if(d.goodsStock == '0'){ }}
  	 		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
  		{{#  } else }}
			<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit">修改数量</a>
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
  	 	{{# }}
	</script>
	<script type="text/html" id="noTpl">
  		{{ d.LAY_INDEX }}
	</script>
	<script type="text/html" id="goodsImg">
  	<a href="${ctx}/mall/detail?goodsId={{ d.goodsId }}">
		<img style="height:30px;" src="${ctx}{{ d.goodsImg }}" layer-src="${ctx}{{ d.goodsImg }}" onclick="openImage()">
	<a>	
	</script>
	<script>
		var goodsId = new Array();
		var carId = new Array();
		layui.use([ 'layer', 'table', 'element' ], function() {
			var table = layui.table;
			layer = layui.layer; //表格

			var tableIns = table.render({
				elem : '#TABLE_GOODSCAR',
				id : 'goodsCarTable',
				cols : [ [ {
					type : 'checkbox',
					fixed : true
				}, {
					field : 'id',
					title : '序号',
					width : '10%',
					align : 'center',
					sort : true,
					fixed : true,
					templet : '#noTpl'
				}, {
					field : 'goodsName',
					title : '商品名称',
					width : '15%',
					align : 'center'
				}, {
					field : 'goodsImg',
					title : '商品图片',
					width : '10%',
					align : 'center',
					templet : '#goodsImg'
				}, {
					field : 'goodsPrice',
					title : '单价',
					width : '10%',
					align : 'center'
				}, {
					field : 'amount',
					title : '数量',
					width : '10%',
					align : 'center'
				}, {
					field : 'sumPrice',
					title : '总价',
					width : '15%',
					align : 'center',
					sort : true
				}, {
					fixed : 'right',
					title : '操作',
					width : '25%',
					align : 'center',
					toolbar : '#operationBar'
				} ] ],
				url : '${ctx}/user/getCarList',
				page : true,
				height : 'pull-315',
				limits : [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ],
				limit : 10,
				done : function(res, curr, count) {
					//如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、curr为当前页、count为数据总长度
				}
			});

			//监听工具条
			table.on('tool(goodsCar)', function(obj) { //注：tool是工具条事件名，goodsCarTable是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值
				var id = data.id;
				var goodsId = data.goodsId;
				if (layEvent === 'del') { //删除
					layer.confirm('确定删除这个商品么？', function(index) {
						obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
						layer.close(index);
						//向服务端发送删除指令
						doDelete(id);
					});
				} else if (layEvent === 'edit') { //编辑
					doEditPage(id, goodsId);
					//同步更新缓存对应的值
					obj.update({});
				}
			});
			table.on('checkbox(goodsCar)', function(obj){
				  if(obj.checked == true && obj.type == 'one'){
					 goodsId.push(obj.data.goodsId);
					 carId.push(obj.data.id);
				  }else if(obj.checked == false && obj.type == 'one'){
					  for(var i=0; i<goodsId.length; i++) {
						 if(goodsId[i] == obj.data.goodsId) {
							goodsId.splice(i, 1);
							carId.splice(i, 1);
						    break;
						  }
					  }
				  }
				  if(obj.checked == true && obj.type == 'all'){
					  for(var i=0; i<table.checkStatus('goodsCarTable').data.length; i++) {
						  goodsId.push(table.checkStatus('goodsCarTable').data[i].goodsId); 
						  carId.push(table.checkStatus('goodsCarTable').data[i].id); 
					  }
				  }else if(obj.checked == false && obj.type == 'all'){
					  goodsId = new Array();
					  carId = new Array();
				  }
				});
		});
		
		//批量购买
		function doBuy(){
			layui.use('table', function() {
				var table = layui.table;
				if(table.checkStatus('goodsCarTable').data.length<1){
					layer.msg("请至少选择一个商品！", {
						icon : 5
					});
					return false;
				} else{
					window.location.href = "${ctx}/user/buyPage?goodsId=" + goodsId.toString()
					+ "&flag=car"+ "&carId=" + carId.toString();
				}
			});
		}


		function reloadTable() {
			layui.use('table', function() {
				var table = layui.table; //表格
				table.reload('goodsCarTable', {
					where : {
					}
				});
			});

		}

		// 打开修改数量
		function doEditPage(id, goodsId) {
			layer.prompt({
				title : '要修改的数量',
				formType : 0
			}, function(amount, index) {
				if (!isNumber(amount)) {
					layer.msg("请输入正确的数量！", {
						offset : 't',
						icon : 5
					});
					return false;
				}
				layer.close(index);
				var url = '${ctx}/user/editGoodsCar';
				var data = {
					id : id,
					amount : amount,
					goodsId : goodsId
				};
				doAjaxSubmit("post", url, data, "editSuccess");
			});
		}
		function editSuccess(data) {
			if (data.errList == null) {
				layer.msg(data.msg, {
					offset : 't',
					icon : 1
				});
				reloadTable();
			} else {
				layer.msg(data.errList, {
					offset : 't',
					icon : 5
				});
				return false;
			}
		}

		// 删除
		function doDelete(id) {
			var url = '${ctx}/user/deleteGoodsCar';
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

		function isNumber(value) {
			var patrn = /^[1-9]*$/;
			if (patrn.exec(value) == null || value == "") {
				return false;
			} else {
				return true;
			}
		}
	</script>
</body>

</html>