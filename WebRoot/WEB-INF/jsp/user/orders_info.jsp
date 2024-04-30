<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../head.jsp">
	<jsp:param value="评价" name="titleName" />
</jsp:include>
</head>
<body>

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
							<td><a href="#" onclick="detail('${orderInfoList.goodsId}')"><img
									style="width: 100px;" src="${ctx}${orderInfoList.goodsImg}" /></a></td>
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
		<c:if test="${isEval != 'isEval'}">
			<div class="layui-form-item" style="margin-left: 5%;">
				<div class="layui-input-block">
					<button type="button" class="layui-btn" lay-submit=""
						lay-filter="editSubmit">提交评价</button>
					<button type="button" onclick="doCannel()"
						class="layui-btn layui-btn-primary">取消</button>
				</div>
			</div>
		</c:if>
	</form>
	<script>
		layui.use([ 'form', 'table' ], function() {
			var form = layui.form, table = layui.table;
			form.render();
			//自定义验证规则
			form.verify({});

			//监听提交  
			form.on('submit(editSubmit)', function(data) {
				var radio_value = new Array();
				var i = 0;
				var values = '';
				var content = '';
				var checked = $("input:checked"); //获取所有被选中的标签元素
				for (i = 0; i < checked.length; i++) { //将所有被选中的标签元素的值保存成一个字符串，以逗号隔开
					var j = i + 1;
					if (i < checked.length - 1) {
						values += checked[i].value + ',';
						content += $("#" + "revelContent" + j).val() + '@!@';
					} else {
						values += checked[i].value;
						content += $("#" + "revelContent" + j).val();
					}
				}
				var url = '${ctx}/user/evel';
				var data = {
					id : $("#id").val(),
					values : values,
					content : content
				}
				doAjaxSubmit("post", url, data, "editSuccess");
			});
		});

		//提交
		function editSuccess(data) {
			if (data.errList == null) {
				//关闭窗口
				parent.layer.closeAll();
				//重载表格
				parent.reloadTable();
				//修改结果提示
				parent.layer.msg(data.msg, {
					offset : 't',
					anim : 1,
					icon : 1
				});
			} else {
				layer.msg(data.errList, {
					icon : 5
				});
				return false;
			}
		}
		//取消
		function doCannel() {
			parent.layer.closeAll();
		}

		function detail(goodsId) {
			parent.window.location.href = "${ctx}/mall/detail?goodsId="
					+ goodsId;
		}
	</script>
</body>
</html>