<%@ page pageEncoding="utf-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<div class="layui-footer" style="text-align: center; margin-top: 100px;">
	<!-- 底部固定区域 -->
	2021 &copy; <a href="${ctx}/shop/admin/loginPage">果蔬商城&emsp;<b>后台登录</b></a>
</div>
<script>
function getScrollTop() {
	var scrollPos;
	if (window.pageYOffset) {
		scrollPos = window.pageYOffset;
	} else if (document.compatMode
			&& document.compatMode != 'BackCompat') {
		scrollPos = document.documentElement.scrollTop;
	} else if (document.body) {
		scrollPos = document.body.scrollTop;
	}
	return scrollPos;
}
layui.use([ 'element', 'carousel', 'layer', 'util' ], function() {
	var carousel = layui.carousel, util = layui.util;
	//固定块
	util.fixbar({});
});
</script>