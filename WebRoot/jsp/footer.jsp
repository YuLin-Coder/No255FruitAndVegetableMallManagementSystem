<%@ page pageEncoding="utf-8"%>
<div class="layui-footer" style="text-align: center; margin-top: 100px;">
	<!-- 底部固定区域 -->
	2019 &copy; <a href="#">基于SSM框架的网上商城</a>
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