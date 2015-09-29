<html>
<head>
	<meta	http-equiv="Content-Type"	content="text/html;	charset=utf-8"	/>
    <meta name="viewport" content="width=device-width, initial-scale=1"> 
	<style>
		.infoWindowContent {
		  width: 120px;
		  height: 100px;
		  overflow: auto;
		}

		.tabContent {
		  font: 10pt sans-serif;
		  border-collapse: collapse;
		  table-layout: auto;
		}


		.key {
		  text-align: right;
		  font-weight: bold;
		  vertical-align: top;
		  white-space: nowrap 
		}

		.value {
		  vertical-align: top;  
		}
	</style>

    <script type="text/javascript" src="/javascripts/jquery.js"> </script>
	<script type="text/javascript" src="http://api.go2map.com/maps/js/api_v2.5.js"></script>
	<script	type="text/javascript" language="javascript">
		var cars = [{carID: '<%= carID %>'}];
		var bagageID = '<%= bagageID %>';
		var carWithMarkArray = null;
		var	g_map = null;
		var	isMonitoring;
		var	refreshTimeSpan	=	5000;
		
		function initialize(){
			var	latlng	= new sogou.maps.LatLng(39.8552, 116.4321);
			var	myOptions =	{
				zoom:	10,
				center:	latlng,
				mapTypeId:	sogou.maps.MapTypeId.ROADMAP
			};
			//	初始化地图及各个按钮的位置
			var	vMapDiv	=	document.getElementById("map_canvas");
			g_map	=	new	sogou.maps.Map(vMapDiv,	myOptions);

			$.ajaxSetup({
				cache:	false
			});
		}
		function requestRest_getPos(id){
			var	strUrl = "/getgps";
			// $.post(strUrl, null,ajaxGetRequestComplete, "json");
			$.post(strUrl, {carID: id},
					function(data){
						if(data!= null){
							// var Point = JSON.parse(data);
							CarMonitor_SetPointMarkOnMap(data);
						}
					},
					 "json");
		}
		function requestRest_getPoses(){
			var len = carWithMarkArray.length;
			for(i = 0; i < len; i++)
			{
				requestRest_getPos(carWithMarkArray[i].carID);
			}
			return;
		}	
		
		function CarMonitor_SetPointMarkOnMap(Point){
			var carid = Point.carID;
			if(null == carid) return;
			var cm = null;
			var j = 0;
			for(j = 0; j < carWithMarkArray.length; j++)
			{
				if(carid == carWithMarkArray[j].carID)
				{
					cm = carWithMarkArray[j];
					break;
				}
			}
			if(cm != null)
			{
				var	pos	= new sogou.maps.LatLng(Point.lat/3600000,Point.lng/3600000, true);
				// if(cm.marker != null) cm.marker.setMap(null);
				if(cm.marker == null)
				{
					var imageSrc = "/Image/MarkerGreenMd.png";
					if(Point.bagageBinded == true){
						imageSrc = "/Image/MarkerPinkMd.png";
					}
					var image = new sogou.maps.MarkerImage(imageSrc,
							    // 标记图标宽20像素，高32像素
							    new sogou.maps.Size(48, 48),
							    // 原点在图片左上角，设为(0,0)
							    new sogou.maps.Point(0,0),
							    // 锚点在小旗的旗杆脚上，相对图标左上角位置为(0,32)
							    new sogou.maps.Point(24, 48));

					cm.marker =	new	sogou.maps.Marker({	
										position:	pos,
										map:	g_map,
										title:  carid,
										icon:	image
										// icon:	"/Image/MarkerPink2.png"
									});
					attachSecretMessage(cm.marker,j,Point);			
				}
				else
				{
					cm.marker.setPosition(pos);
					if(cm.infowindow != null)
					{
						var contentString = getAddressComponentsHtml(Point);
						cm.infowindow.setContent(contentString);
						cm.infowindow.setPosition(pos);
						//cm.infowindow.open(g_map,cm.marker);
					}
				}
				cm = null;
			}
		}		
		function attachSecretMessage(marker, index,Point) {
			var infoWindow = null;
			// 首先创建信息窗口
			var contentString = getAddressComponentsHtml(Point);
			infoWindow = new sogou.maps.InfoWindow({
					content: contentString,
					maxWidth: 120
				});
			infoWindow.open(g_map,marker);
			// infoWindow.setPosition(pos);
			// 将信息窗口关联到全局数组
			if(index < carWithMarkArray.length)
			{
				carWithMarkArray[index].infowindow = infoWindow;
			}
			// 为标记添加事件监听
			if(null!= infoWindow)
			{
			  sogou.maps.event.addListener(marker, 'click', function() {
				infoWindow.open(g_map,marker);
			  });				
			}
		}
		function  openMyInfoWindow(index,carid){
			var infoWindow = null;
			var marker = null;
			if(index < carWithMarkArray.length)
			{
				marker = carWithMarkArray[index].marker;
				infoWindow = carWithMarkArray[index].infowindow;
			}
			if(null!= infoWindow)
			{
				infoWindow.open(g_map,marker);
			}
		}
		function getAddressComponentsHtml(Point) {
			var	location	=	new	sogou.maps.LatLng(Point.lat/3600000,Point.lng/3600000);
			var html = '<div class="infoWindowContent">' +
					   '<table class="tabContent">';
			var lng = location.lng().toString();
			if(lng.length > 8)
			{
				lng = lng.substring(0, 8);
			}
			var lat = location.lat().toString();
			if(lat.length > 8)
			{
				lat = lat.substring(0, 8);
			}
			var vDate = Point.timeStamp.substring(0,10);
			var vTime = Point.timeStamp.substring(11,19);
			html += tr("车牌：", Point.carID);
			html += tr("单号：", bagageID);
			html += tr("日期：", vDate);
			html += tr("时间：", vTime);
			// html += tr("经度：", lng);
			// html += tr("纬度：", lat);               

		  	html += '</table></div>';
		  	return html;
		}		
		function StartMonitoring()	{
			isMonitoring	=	true;
			requestRest_getPoses();
			setInterval("requestRest_getPoses()", refreshTimeSpan);
		}
		$(document).ready(function(){
			initialize();
			// 把要监控的车辆保存起来
			if(carWithMarkArray == null) carWithMarkArray = new Array();
			for(i=0;i<cars.length;i++)
			{
				var carWMark = new carWithMark(cars[i].carID,null);
				carWithMarkArray.push(carWMark);
			}	
			StartMonitoring();
		}
		);
		function tr(key, value) {
		  return '<tr>' +
				   '<td class="key">' + key + (key ? ':' : '') + '</td>' +
				   '<td class="value">' + value + '</td>' +
				 '</tr>';
		}
		function br() {
		  return '<tr><td colspan="2"><div style="width: 100%; border-bottom: 1px solid grey; margin: 2px;"</td></tr>';
		}
		function carWithMark(carID,marker){
			this.carID = carID;
			this.marker = marker;
			this.infowindow = null;
			this.toJsonString = function()
			{
				return '{"carID":"'+this.carID+'"}';
			}
		}  	
	</script>

</head>
<body	onload="">
	<div	id="map_canvas"	style="width:	100%;	height:	100%">
	</div>
</body>
</html>
