<%@page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../common/head.jsp">
	<jsp:param value="用户管理" name="titleName" />
</jsp:include>
</head>
<style>
form {
	margin-right: 20px;
}
</style>
<body>
	<form class="layui-form">
		<div class="goodsType_left">
			<input type="hidden" id="id" name="id" value="${goodsType.id}">
			<div class="layui-form-item" style="margin-top: 20px;">
				<label class="layui-form-label">类型名</label>
				<div class="layui-input-block">
					<input type="text" name="name" value="${goodsType.name}"
						maxlength="12" lay-verify="required" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">顺序号</label>
				<div class="layui-input-block">
					<input type="sort" name="sort" value="${goodsType.sort}"
						maxlength="5" placeholder="请输入顺序号" lay-verify="required"
						class="layui-input">
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="margin-left: 5%;">
			<div class="layui-input-block">
				<button type="button" class="layui-btn"
					lay-submit="" lay-filter="editSubmit">提交</button>
				<button type="button" onclick="doCannel()"
					class="layui-btn layui-btn-primary">取消</button>
			</div>
		</div>
	</form>
	<script>
		layui.use([ 'form'],function() {
			var form = layui.form;
			form.render();
			//自定义验证规则
			form.verify({
			});
			//监听提交  
			form.on('submit(editSubmit)', function(data) {
				var url = '${ctx}/admin/goodsType/edit';
				var data = {
					id : $("#id").val(),
					name : data.field.name,
					sort : data.field.sort
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
					offset : 't',
					icon : 5
				});
				return false;
			}
		}
		//取消
		function doCannel() {
			parent.layer.closeAll();
		}
	</script>
</body>
</html>