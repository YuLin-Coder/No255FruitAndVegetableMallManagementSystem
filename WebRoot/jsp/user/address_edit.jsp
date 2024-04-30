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
<style>
form {
	margin-right: 20px;
}
</style>
<body>
	<form class="layui-form">
		<div class="recAddress_left">
			<input type="hidden" id="id" name="id" value="${recAddress.id}">
			<div class="layui-form-item" style="margin-top: 20px;">
				<label class="layui-form-label">姓名</label>
				<div class="layui-input-block">
					<input type="text" name="name" value="${recAddress.name}"
						maxlength="12" lay-verify="required" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">联系电话</label>
				<div class="layui-input-block">
					<input type="tel" name="tel" value="${recAddress.tel}"
						maxlength="11" placeholder="请输入手机号码" lay-verify="required|tel"
						class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">详细地址</label>
				<div class="layui-input-block">
					<textarea placeholder="请输入地址" class="layui-textarea" id="address"
						name="address" lay-verify="required">${recAddress.address}</textarea>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="margin-left: 5%;">
			<div class="layui-input-block">
				<button type="button" class="layui-btn layui-btn-normal"
					lay-submit="" lay-filter="editSubmit">提交</button>
				<button type="button" onclick="doCannel()"
					class="layui-btn layui-btn-primary">取消</button>
			</div>
		</div>
	</form>
	<script>
		layui.use([ 'form' ], function() {
			var form = layui.form;
			form.render();
			//自定义验证规则
			form.verify({
				tel : function(value) {
					if (!IsMobilePhoneNumber(value)) {
						return '请输入正确的手机号!';
					}
				},
				password : [ /^[\S]{6,16}$/, '密码必须6到16位，且不能出现空格' ]
			});
			//监听提交  
			form.on('submit(editSubmit)', function(data) {
				var url = '${ctx}/user/editAddress';
				var data = {
					id : $("#id").val(),
					name : data.field.name,
					tel : data.field.tel,
					address : data.field.address
				};
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