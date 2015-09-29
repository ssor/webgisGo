<html>
<head>
	<meta	http-equiv="Content-Type"	content="text/html;	charset=utf-8"	/>
    <meta name="viewport" content="width=device-width, initial-scale=1"> 

	<!-- <load	href='/stylesheets/common.css'	/> -->
	<style type="text/css">
		body
		{
			/*background-color: #eaeeef;*/
			background-color: rgb(223,232,246);
			margin: 0;
			padding: 0;
			font-family: "lucida Grande" ,Verdana, "Segoe UI" , Tahoma, Arial, Sans-Serif;
			color: #343434;
			min-width: 960px;
		}
	</style>
    <script type="text/javascript" src="/javascripts/jquery.js"> </script>
	<script type="text/javascript" src="http://api.go2map.com/maps/js/api_v2.5.js"></script>
	<script type="text/javascript" src="http://api.go2map.com/maps/js/component/ruler.js"></script>
	<!-- // <script	type="text/javascript"	language="javascript"	src="__PUBLIC__/Js/labels.js"></script> -->
	<!-- // <script	type="text/javascript"	language="javascript"	src="__PUBLIC__/Js/ruler.js"></script> -->
	
	<script	type="text/javascript" language="javascript">

		var	g_map;
		var	g_mark;
		var	isMonitoring;
		var	refreshTimeSpan	=	5000;
		g_infowindow = null;
		g_ruler = null;

	function RulerControl(controlDiv, map) {
		// 为自定义控件设置CSS样式
		controlDiv.style.padding = '5px';

		var controlUI = document.createElement('DIV');
		controlUI.style.backgroundColor = 'rgb(244,244,244)';
		controlUI.style.width = '55px';
		controlUI.style.height = '20px';
		controlUI.style.borderStyle = 'solid';
		controlUI.style.borderWidth = '1px';
		controlUI.style.cursor = 'pointer';
		controlUI.style.textAlign = 'center';
		controlUI.title = '点击我测量距离';
		controlDiv.appendChild(controlUI);

		var controlText = document.createElement('DIV');
		controlText.style.fontFamily = 'Arial,sans-serif';
		controlText.style.fontSize = '12px';
		controlText.style.paddingTop = '3px';
		controlText.style.paddingLeft = '4px';
		controlText.style.paddingRight = '4px';
		controlText.innerHTML = '<b>测距</b>';
		controlUI.appendChild(controlText);

		// 添加一个侦听器，使得点击后调用方法设置地图到
		// 上海
		sogou.maps.event.addDomListener(controlUI, 'click', function() {
		// map.setCenter(shanghai)
			g_ruler.open();
		});
	}

	
	function	initialize(){
		var	latlng	=	new	sogou.maps.LatLng(39.8552,	116.4321);
		var	myOptions	=	{
			zoom:	10,
			center:	latlng,
			mapControl: true,
			scaleControl: true,
			mapTypeId:	sogou.maps.MapTypeId.ROADMAP
		};
		//	初始化地图及各个按钮的位置
		var	vMapDiv	=	document.getElementById("map_canvas");
		g_map	=	new	sogou.maps.Map(vMapDiv,	myOptions);
		g_ruler = new Ruler({'map':g_map});


		var rulerDiv = document.createElement('DIV');
		rulerDiv.style.position="absolute";
		rulerDiv.style.right="20px";
		rulerDiv.style.top="1px";
		var homeControl = new RulerControl(rulerDiv, g_map);
		//将自定义的DIV添加到地图容器
		g_map.getContainer().appendChild(rulerDiv);

		
		$.ajaxSetup({
			cache:	false
		});
	}

	$(document).ready(function()	{
		initialize();
	});
	</script>
</head>
<body id = "bodycontent" onload="" style="border-left: solid rgb(233,233,233) 2px;">
	<div id="map_canvas" style="width: 100%; height: 99%"> </div>
</body>
</html>
