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
<style>
form {
	margin-right: 20px;
}
</style>
<body>
	<form class="layui-form">
		<div class="goods_left">
			<input type="hidden" id="id" name="id" value="${goods.id}">
			<div class="layui-form-item" style="margin-top: 20px;">
				<label class="layui-form-label">商品名称</label>
				<div class="layui-input-block">
					<input type="text" name="name" value="${goods.name}" maxlength="12"
						lay-verify="required" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">类型</label>
				<div class="layui-input-block">
					<select name="typeId" lay-verify="required" lay-search>
						<c:forEach items="${typeList}" var="typeList" varStatus="vs">
							<option value="${typeList.id}">${typeList.name}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">价格</label>
				<div class="layui-input-block">
					<input type="number" name="price" value="${goods.price}"
						maxlength="10" placeholder="请输入商品价格" lay-verify="required"
						class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">库存</label>
				<div class="layui-input-block">
					<input type="number" name="stockAmount"
						value="${goods.stockAmount}" maxlength="10"
						placeholder="请输入商品库存数量" lay-verify="required" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">商品图片</label>
				<div class="layui-input-block">
					<div class="layui-upload">
						<button type="button" class="layui-btn layui-btn-danger"
							id="uploadBtn">上传图片</button>
						<div class="layui-upload-list">
							<img class="layui-upload-img" id="image"
								style="width: 100px; height: 100px;"
								<c:if test="${goods.goodsImg != null}">src="${ctx}${goods.goodsImg}"</c:if>
								<c:if test="${goods.goodsImg == null}">src="${ctx}/res/images/default.jpg"</c:if>>
							<input type="hidden"
								value="<c:if test="${goods.goodsImg != null}">${goods.goodsImg}</c:if>"
								value="<c:if test="${goods.goodsImg == null}">/res/images/default.jpg</c:if>"
								id="imagePath" name="imagePath">
							<p id="demoText"></p>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-form-item layui-form-text">
				<label for="des" class="layui-form-label">商品详情</label>
				<div class="layui-input-block">
					<textarea id="des" name="des" required placeholder="请输入商品详情"
						lay-verify="des" class="layui-textarea" style="height: 260px;">${goods.des}</textarea>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="margin-left: 5%;">
			<div class="layui-input-block">
				<button type="button" class="layui-btn" lay-submit=""
					lay-filter="editSubmit">提交</button>
				<button type="button" onclick="doCannel()"
					class="layui-btn layui-btn-primary">取消</button>
			</div>
		</div>
	</form>
	<script>
		layui.use([ 'form', 'upload', 'layedit' ],function() {
			var form = layui.form, upload = layui.upload, layedit = layui.layedit;
			form.render();
			//自定义验证规则
			form.verify({
				tel : function(value) {
					if (!IsMobilePhoneNumber(value)) {
						return '请输入正确的手机号!';
					}
				},
				password : [ /^[\S]{6,16}$/,
						'密码必须6到16位，且不能出现空格' ],
				des : function(value) {
					layedit.sync(editIndex);
				}
			});
			//图片上传
			var uploadInst = upload
					.render({
						elem : '#uploadBtn',
						url : '${ctx}/admin/goods/uploadImg',
						before : function(obj) {
							//预读本地文件示例，不支持ie8
							obj
									.preview(function(index,
											file, result) {
										$('#image').attr('src',
												result); //图片链接（base64）
									});
						},
						done : function(res) {
							//如果上传失败
							if (res.code > 0) {
								return layer.msg('上传失败');
							}
							//上传成功
							$("#imagePath").val(res.images);
						},
						error : function() {
							//演示失败状态，并实现重传
							var demoText = $('#demoText');
							demoText
									.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-mini demo-reload">重试</a>');
							demoText.find('.demo-reload').on(
									'click', function() {
										uploadInst.upload();
									});
						}
					});
			//构建一个默认的编辑器
			var editIndex = layedit.build('des',
					{
						tool : [ 'face', '|', 'left', 'center',
								'right' ],
						height : 100
					});

			//自定义工具栏
			layedit.build('editSubmit');
			//监听提交  
			form.on('submit(editSubmit)', function(data) {
				var url = '${ctx}/admin/goods/edit';
				var data = {
					id : $("#id").val(),
					name : data.field.name,
					typeId : data.field.typeId,
					price : data.field.price,
					stockAmount : data.field.stockAmount,
					goodsImg : data.field.imagePath,
					des : layedit.getContent(editIndex)
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