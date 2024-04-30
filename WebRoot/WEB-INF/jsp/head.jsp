<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<meta charset="UTF-8">
<title>${param.titleName}</title>
<link rel="stylesheet"
	href="${ctx}/res/layui-v2.2.5/layui/css/layui.css" />
<script type="text/javascript"
	src="${ctx}/res/layui-v2.2.5/layui/layui.js"></script>
<script src="${ctx}/res/js/ajax.js"></script>
<script src="${ctx}/res/js/jquery-3.1.1.js"></script>
<script src="${ctx}/res/js/validator.js"></script>
<style>
.layui-elem-quote {
	border-left: 5px solid #8fce23;
}

.layui-laypage .layui-laypage-curr .layui-laypage-em {
	background-color: #8fce23;
}

.layui-form-checked[lay-skin=primary] i {
	border-color: #8fce23;
	background-color: #8fce23;
}

.layui-form-checkbox[lay-skin=primary]:hover i {
	border-color: #8fce23;
}
</style>