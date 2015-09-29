<!DOCTYPE html>
<html>

<head>
    <title>WebGIS客户端</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="/bootstrap/css/bootstrap.css" rel="stylesheet" media="screen">
    <style type="text/css">
    #title {
        margin-top: 0;
        background-color: rgb(50, 50, 50);
        margin-bottom: 2px;
        padding: 10px 0px 10px;
        color: white;
        text-align: center;
        font-size: 23px;
    }
    
    body {
        background-color: rgb(216, 218, 219);
    }
    
    label {
        font-size: 16px;
    }
    
    .row-container {
        border: rgb(206, 205, 205) 4px solid;
        border-left-style: none;
        border-right-style: none;
        border-top-style: none;
    }
    
    .left-image {
        width: 100%;
        height: 100%;
        max-width: 72px;
    }
    
    .main-title {
        font-size: 150%;
        margin-top: 1%;
    }
    
    .event-detail {
        margin-top: 2%;
        padding-bottom: 2%;
        color: rgb(123, 123, 123);
        font-size: 100%;
    }
    </style>
    <script type="text/javascript" src="http://api.go2map.com/maps/js/api_v2.5.js"></script>
    <script type="text/javascript" src="/javascripts/jquery.js">
    </script>
    <script src="/bootstrap/js/bootstrap.min.js">
    </script>
    <script src="/javascripts/tools.js" type="text/javascript"></script>
    <script type="text/javascript">
    var carID = "{{.carID}}";
    $(document).ready(function() {
        $.ajaxSetup({
            cache: false
        });

        var windowHeight = window.screen.height;
        console.log("window height: " + windowHeight);

        var title = document.getElementById('title');
        console.log("title height: " + title.offsetHeight);

        var container_top = $('#tile_container').css('top');
        console.log("container top: " + container_top);


        var container = document.getElementById('tile_container');
        console.log("container height: " + container.offsetHeight);

        var footer = document.getElementById('footer');
        console.log("footer height: " + footer.offsetHeight);

        var documentHeight = $(document.body).height();
        var windowHeight = $(window).height();
        console.log("Document height: ", documentHeight);
        console.log("Window height: ", windowHeight);
        console.log("Window scroll: ", $(window).scrollTop());
        // console.log("Footer height: ", footerHeight);
        // console.log("Footer top: ", footerTop);
        console.log("-----------")
        if ((windowHeight - documentHeight) > 3) {
            $('#footer').css('margin-top', (windowHeight - documentHeight - 20) + 'px');

        }
        // var container = document.getElementById('tile_container');
        // console.log("container height: " + container.offsetHeight);

        // alert('title height => ' + title.offsetHeight);
        // var cssHeight = ((window.screen.height- title.offsetHeight) - 130) * 0.82;
        // var cssHeight = (window.screen.height- title.offsetHeight) - 130;
        // $('#map_canvas').css('height', (cssHeight)+'px');
        check_geolocation_support();
    });

    function check_geolocation_support() {
        // $('[id="btnEndTask"]').data('disabled',true);
        // $('#btnEndTask').data('disabled',true);
        if (!navigator.geolocation) {

            alert("您的浏览器不支持使用HTML 5来获取地理位置服务");
            return;
        }
        getLocation();
        // setInterval("intervalCheckTask()", 3000);

    }

    function intervalCheckTask() {
        var strUrl = "http://{$ip}:{$port}/index.php/Monitor/checkTask/carid/" + carID;
        // $.post(strUrl, null,ajaxGetRequestComplete, "json");
        $.post(strUrl, "", getTask);
        // $.post(strUrl, "", getTask, "json");
    }

    function getTask(data, status) {
        if (data == "no task") {
            $("#lblTask").html("无任务");
            $('[type="button"]').button('disable');
        } else {
            $("#lblTask").html(data);
            $('[type="button"]').button('enable');
        }
    }

    function endTask() {
        var strUrl = "http://endTask/carid/" + carID;
        $.post(strUrl, "", function(data, status) {
            if (data == "ok") {
                $("#lblTask").html("无任务");
                $('[type="button"]').button('disable');
            }
        });
    }

    function getLocation() {
        $("#lblTip").html("正在尝试获取地理位置信息...");
        console.log("正在尝试获取地理位置信息...");

        navigator.geolocation.getCurrentPosition(showPosition, showError);
    }

    function getInstance(a) {
        a.hasOwnProperty("_instance") || (a._instance = new a);
        return a._instance
    }

    function showPosition(position) {
        $("#lblTip").html("已成功获取地理位置信息");

        $("#inputLongitude")[0].value = position.coords.longitude;
        $("#inputLatitude")[0].value = (position.coords.latitude);
        var strTime = date2str(new Date(), "yyyy-MM-dd hh:mm:ss");
        $("#lblTime").html(strTime);
        // return;
        //上传数据
        // var data = new Object;
        var obj = {
            carID: carID,
            Lng: position.coords.longitude * 3600000,
            Lat: position.coords.latitude * 3600000
        }
        // data.Lon = position.coords.longitude * 3600000;
        // data.Lat = position.coords.latitude * 3600000;
        // var sogouPoint = new sogou.maps.LatLng(position.coords.latitude, position.coords.longitude);
        // var convertor = getInstance(sogou.maps.Convertor);
        //标准经纬度转换为Sogou地图坐标
        // var sogouCoord = convertor.toSogou(sogouPoint);
        // data.sogouLongitude = sogouCoord.x;
        // data.sogouLatitude = sogouCoord.y;
        // data.carID = carID;
        var strUrl = get_host_url() + "/postgps";
        // var json = $.toJSON(data);
        $.post(strUrl, obj, function(data, status) {
            if (data != null && data.Code == 0) {
                console.log("upload gps success")
                $("#lblTip").html("上传位置信息成功 " + strTime)
            } else {
                console.info("upload gps failed: ", data.Message)
                $("#lblTip").html(data.Message)
            }
            // alert("Data: " + data + "\nStatus: " + status);
        });
        setTimeout(getLocation, 5000);
    }

    function showError(error) {
        switch (error.code) {
            case error.PERMISSION_DENIED:
                $("#lblTip").html("获取地理位置信息失败，您已拒绝");
                break;
            case error.POSITION_UNAVAILABLE:
                $("#lblTip").html("无法获得当前位置信息");
                break;
            case error.TIMEOUT:
                $("#lblTip").html("获取位置信息时间超时");
                break;
            case error.UNKNOWN_ERROR:
                $("#lblTip").html("有异常错误发生");
                break;
        }
    }

    function redirect_to_main_form() {
        top.location.href = get_host_url() + "/mobile";
    }
    // check_geolocation_support();
    </script>
</head>

<body>
    <div style="margin-bottom:-1px;">
        <h3 id="title">
            {{.carID}}
        </h3>
    </div>
    <div class="container" style="background-color: rgb(200,200,200);">
        <h5 style="color: rgb(120,120,120);">每隔一段时间上传位置信息</h5>
    </div>
    <div class="container" id="tile_container">
        <form class="form-horizontal" role="form">
            <div class="form-group">
                <label for="inputPassword3" class="col-xs-3 col-sm-2 control-label">纬度</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputLatitude" placeholder="0" disabled>
                </div>
            </div>
            <div class="form-group">
                <label for="inputPassword3" class="col-xs-3 col-sm-2 control-label">经度</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputLongitude" placeholder="0" disabled>
                </div>
            </div>
            <div class="form-group">
                <label for="inputPassword3" class="col-xs-12 col-sm-12 control-label" style="">上传时间:</label>
                <div class="col-xs-12 col-sm-12">
                    <h5 id="lblTime">尚未开始
                    <!-- <label>尚未开始</label> -->
                </h5>
                </div>
            </div>
            <div class="form-group">
                <!-- <label for="inputPassword3" class="col-xs-4 col-sm-3 control-label" style="font-size:13px;">提示：</label> -->
                <div class="col-xs-12 col-sm-12">
                    <h5 id="lblTip" style="text-align: center;"> </h5>
                </div>
            </div>
        </form>
    </div>
    <div id="footer">
        <button type="button" class="btn btn-primary btn-lg btn-block" onclick="redirect_to_main_form()" style="background-color:rgb(50,50,50);border-color:rgb(50,50,50);border-radius:0px;">主页面</button>
    </div>
</body>

</html>
