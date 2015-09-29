<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;     charset=utf-8" />
    <script type="text/javascript" language="javascript" src="/javascripts/jquery.js"></script>
    <script type="text/javascript" src="http://api.go2map.com/maps/js/api_v2.5.js"></script>
    <script type="text/javascript">
    </script>
    <script type="text/javascript" language="javascript">
    var g_map;
    var g_mark;
    //var isMonitoring;
    var refreshTimeSpan = 2000;
    var RoutePoints = [];
    // 所有要回放的点都要放到这个数组里面，之后的回放操作从该数组中获取回放点
    var ReplayArray = [];
    var g_viewArray = []; //
    var g_markArray = []; //  
    var bReplaying = false;
    var iTimeElapse = 0;

    function initialize() {
        var latlng = new sogou.maps.LatLng(39.8552, 116.4321);
        var myOptions = {
            zoom: 15,
            center: latlng,
            mapTypeId: sogou.maps.MapTypeId.ROADMAP
        };
        //     初始化地图及各个按钮的位置
        var vMapDiv = document.getElementById("map_canvas");
        g_map = new sogou.maps.Map(vMapDiv, myOptions);

        $.ajaxSetup({
            cache: false
        });
    }

    function RouteReplay_SetPointMarkOnMap(Point) {
        //var pos = new sogou.maps.LatLng(Point.StrLatitude,Point.StrLongitude);
        var pos = Point;
        //{lat:Point.StrLatitude,lng:Point.StrLongitude};
        if (g_mark != null) {
            g_mark.setMap(null); // delete the mark
        }
        if (bReplaying == true) {
            g_mark = new sogou.maps.Marker({
                position: pos,
                map: g_map,
                icon: "/Image/car.gif"
            });
            g_map.setCenter(pos);
        }
    }

    function ClearRoutePointsMarkOnMap() {
        if (g_markArray != null) {
            for (var i = 0; i < g_markArray.length; i++) {
                if (g_markArray[i] != null) {
                    g_markArray[i].setMap(null);
                }
            }
        }
    }

    function AddRoutePointsMarkOnMap() {
        if (null == g_markArray) {
            g_markArray = new Array();
        }
        var flightPlanCoordinates = new Array();
        for (var j = 0; j < ReplayArray.length; j++) {
            var carRoutePoint = ReplayArray[j];
            var location = new sogou.maps.LatLng(carRoutePoint.lat / 3600000, carRoutePoint.lng / 3600000);
            flightPlanCoordinates.push(location);
            var mark = new sogou.maps.Marker({
                position: location,
                map: g_map,
                icon: "/Image/point-48-48.png"
            });
            g_markArray.push(mark);
            // var name1View = new NameOverlay(location, numberFormat(j+1), g_map);
            // if(g_viewArray == null)
            // {
            //      g_viewArray = new Array();
            // }
            // g_viewArray.push(name1View);
        }

        var flightPath = new sogou.maps.Polyline({
            path: flightPlanCoordinates,
            strokeColor: "#FF0000",
            strokeOpacity: 1.0,
            strokeWeight: 6
        });

        flightPath.setMap(g_map);
    }

    function numberFormat(i) {
        if (i < 10) {
            return '0' + i;
        } else {
            return i.toString();
        }
    }

    function timer_SetPointMarkOnMap() {
        if (iTimeElapse >= ReplayArray.length) {
            //if (iTimeElapse >= RoutePoints.length) {
            // 清楚所有路线经过点的地图标记
            //ClearRoutePointsMarkOnMap();
            iTimeElapse = 0;
        }
        var carRoutePoint = ReplayArray[iTimeElapse];
        if (null != carRoutePoint) {
            var gLatLngPoint = new sogou.maps.LatLng(carRoutePoint.lat / 3600000, carRoutePoint.lng / 3600000);
            //var RoutePoint = RoutePoints[iTimeElapse];
            //var gLatLngPoint = new sogou.maps.LatLng(RoutePoint.StrLatitude / 3600000, RoutePoint.StrLongitude / 3600000);
            //AddRoutePointsMarkOnMap(gLatLngPoint, iTimeElapse);
            RouteReplay_SetPointMarkOnMap(gLatLngPoint);
            if (bReplaying == true) {
                iTimeElapse++;
                setTimeout(timer_SetPointMarkOnMap, refreshTimeSpan);
            }
        }
    }

    function CarRoutePoint(id, lat, lng, time) {
        this.carID = id;
        this.lat = lat;
        this.lng = lng;
        this.timeStump = time;
    }

    function ajaxGetRequestComplete(Points) {
        console.log(Points);
        // return;
        var RoutePoints = JSON.parse(Points);
        var pointsCount = RoutePoints.length;
        if (pointsCount <= 0) {
            alert("没有返回路线！");
            return;
        }
        ReplayArray.length = 0;

        for (var j = 0; j < pointsCount; j++) {
            ReplayArray[j] = new CarRoutePoint(RoutePoints[j].carID, RoutePoints[j].lat, RoutePoints[j].lng, RoutePoints[j].timeStamp);
        }
        if (bReplaying == false) {
            bReplaying = true;
            AddRoutePointsMarkOnMap();
            timer_SetPointMarkOnMap();
        } else {
            bReplaying = false;

        }
    }

    function requestRest_getPos() {
        var strUrl = "/getRoutePointList";
        $.get(strUrl, ajaxGetRequestComplete);
    }

    function StartReplay() {
        isMonitoring = true;
        //var  carID     =    "001";
        // if  (carID    ==   null ||   carID     ==   "")  {
        //     alert("请先输入车辆编码！");
        //     return;
        // }
        requestRest_getPos(); //通过服务器获取位置
    }


    $(document).ready(function() {
        initialize();
        StartReplay(); //初始化风地图完毕后，开始访问网络获得回放数据
    });

    function save_screen() {
        var points = "";
        var labels = "";
        for (var j = 0; j < ReplayArray.length; j++) {
            var carRoutePoint = ReplayArray[j];
            var latlng = new sogou.maps.LatLng(carRoutePoint.lat / 3600000, carRoutePoint.lng / 3600000);
            var sogouLatLng = new sogou.maps.Convertor().toSogou(latlng);
            if (points == "") {
                points += sogouLatLng.x + "," + sogouLatLng.y;
                labels += (j + 1);
            } else {
                points += "|" + sogouLatLng.x + "," + sogouLatLng.y;
                labels += "|" + (j + 1);
            }
        }
        // var latlng    =    new  sogou.maps.LatLng(39.8552,    116.4321);

        //返回的是搜狗坐标
        var center_point = g_map.getCenter();
        var sogouPointCenter = new sogou.maps.Convertor().toSogou(center_point);
        var zoom = g_map.zoom;
        var url = "http://api.go2map.com/engine/api/static/image+{'height':450,'width':550,'zoom':'" + zoom + "','center':'" + sogouPointCenter.x + "," + sogouPointCenter.y + "','points':'" + points + "','labels':'" + labels + "'}.png";
        window.open(url);

        // http://api.go2map.com/engine/api/static/image+{'height':450,'width':550,'zoom':'16','center':'116.62310000000002,39.80070861111111','points':'12982840.08081613,4809186.189441585|12982617.934170771,4809380.091845869|12982565.366061482,4809415.810071399|12982512.828874606,4809460.989202219|12982405.34255232,4809544.25243808','labels':'1|2|3|4|5'}.png
    }
    </script>
</head>

<body onload="">
    <div id="map_canvas" style="width:  100%;     height:   99%">
    </div>
    <!-- <input type='button' value='打 印' id='save_screen' style="width:8%;" onclick = 'save_screen()'/> -->
</body>

</html>
