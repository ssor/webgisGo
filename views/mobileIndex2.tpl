<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <meta name="viewport" content="initial-scale=1, maximum-scale=1, minimum-scale=1"> -->
    <!-- <meta name="apple-mobile-web-app-capable" content="yes"> -->
    <title>车辆列表</title>
    <link rel="stylesheet" href="/stylesheets/framework7.css">
    <script type="text/javascript" src="/javascripts/jquery.js"></script>
    <script type="text/javascript" src="/javascripts/underscore.js"></script>
    <script src="/javascripts/tools.js" type="text/javascript"></script>
    <script type="text/javascript">
    var carID = null;

    $(document).ready(function() {
        // $.ajaxSetup({cache:false});
        $.get("/cars", function(data) {
                var carList = data
                _.each(carList, function(_car) { //添加当前不存在的
                    addCar(_car);
                });
            })
            // check_geolocation_support();  
    });

    function addCar(_car) {
        var ele = '';
        var carID = "'" + _car.ID + "'";
        ele = ele + '<li><a href="/uploadgps/' + _car.ID + '" onclick="testalert(' + carID + ')"> <div class="icons"><i class="icon"></i></div> <div class="inner"> <div class="text">' + _car.Note + '</div> <div class="after">' + _car.Note + '</div> </div></a></li>';

        $('#container').append(ele);
    }

    function testalert(_carID) {
        // if(_id == null) alert(null);
        carID = _carID;
        console.log('you click ' + _carID);
        check_geolocation_support();
    }

    function goback() {
        carID = null;
        console.log('goback');
    }

    function check_geolocation_support() {
        if (carID == null) return;
        if (!navigator.geolocation) {
            alert("您的浏览器不支持使用HTML 5来获取地理位置服务");
            return;
        }
        getLocation();
    }

    function getLocation() {
        console.log("正在尝试获取地理位置信息");
        $("#lblTip").html("正在尝试获取地理位置信息");
        // navigator.geolocation.watchPosition(showPosition);
        navigator.geolocation.getCurrentPosition(showPosition, showError);
        if (carID != null) {
            setTimeout(getLocation, 5000);
        }
    }

    function showPosition(position) {

        $("#lblTip").html("已成功获取地理位置信息");

        $("#inputLongitude")[0].value = position.coords.longitude;
        $("#inputLatitude")[0].value = (position.coords.latitude);
        var strTime = date2str(new Date(), "yyyy-MM-dd hh:mm:ss");
        $("#lblTime").html("上传时间：" + strTime);
        // return;
        //上传数据
        var obj = new Object;
        obj.Longitude = position.coords.longitude * 3600000 + "";
        obj.Latitude = position.coords.latitude * 3600000 + "";
        // obj.Time = strTime;
        obj.carID = carID;
        // var strUrl  =   "http://{$ip}:{$port}/addPos" ;
        var strUrl = get_host_url() + "/postgps";
        // var json = $.toJSON(obj);
        jQuery.post(strUrl, obj, function(_data) {
            // alert("Data: " + data + "\nStatus: " + status);
        });
        // setTimeout(getLocation,  5000);
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
    </script>
</head>

<body>
    <div class="views">
        <div class="view view-main dynamic-toolbar">
            <div class="toolbar-top">
                <div class="toolbar-inner">
                    <div class="links-left"></div>
                    <h1 class="sliding">车辆列表</h1>
                    <div class="links-right"><a href="#" class="open-panel"><i class="icon-bars-blue"></i></a></div>
                </div>
            </div>
            <div class="pages toolbar-top-through">
                <div data-page="index" class="page">
                    <div class="page-content">
                        <!--               <div class="content-block">
                <div class="content-block-title">Welcome To Framework7</div>
                <p><a href="about.html" class="button">Read About Framework7</a></p>
              </div> -->
                        <div class="list-panel">
                            <div class="content-block-title">选择需要上传数据的车辆</div>
                            <ul id="container">
                                <!--                   <li><a href="ks-modals.html">
                      <div class="icons"><i class="icon-f7"></i></div>
                      <div class="inner">
                        <div class="text">Modals</div>
                        <div class="after">CEO</div>
                      </div></a></li>
                  <li><a href="ks-transitions.html">
                      <div class="icons"><i class="icon-f7"></i></div>
                      <div class="inner">
                        <div class="text">Transitions And Effects</div>
                      </div></a></li>
                  <li><a href="ks-panels.html">
                      <div class="icons"><i class="icon-f7"></i></div>
                      <div class="inner">
                        <div class="text">Side Panels</div>
                      </div></a></li>
                  <li><a href="ks-list-panels.html">
                      <div class="icons"><i class="icon-f7"></i></div>
                      <div class="inner">
                        <div class="text">Data Lists</div>
                      </div></a></li>
                  <li><a href="ks-forms.html">
                      <div class="icons"><i class="icon-f7"></i></div>
                      <div class="inner">
                        <div class="text">Forms</div>
                      </div></a></li> -->
                            </ul>
                        </div>
                        <div class="content-block">
                            <!-- <div class="content-block-title">Core Features</div> -->
                            <p><a href="#" class="button call-alert">关于</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-overlay"></div>
    <div class="modal modal-alert">
        <div class="modal-inner">
            <div class="modal-text"></div>
        </div>
        <div class="modal-buttons"><span class="modal-button button-ok">OK</span></div>
    </div>
    <div class="modal modal-confirm">
        <div class="modal-inner">
            <div class="modal-text"></div>
        </div>
        <div class="modal-buttons"><span class="modal-button">Cancel</span><span class="modal-button button-ok">OK</span></div>
    </div>
    <div class="modal modal-prompt">
        <div class="modal-inner">
            <div class="modal-text"></div>
            <input type="text" id="modal-input" class="modal-input">
        </div>
        <div class="modal-buttons"><span class="modal-button">Cancel</span><span class="modal-button button-ok">OK</span></div>
    </div>
    <script type="text/javascript" src="/javascripts/framework7.js"></script>
    <script>
    var app = new Framework7();
    var $ = app.$;
    var mainView = app.addView('.view-main');
    var rightView = app.addView('.view-right');
    $(document).on('click', '.call-alert', function() {
        app.alert('欢迎使用WebGIS 1.0移动端！')
    })
    $(document).on('click', '.call-confirm', function() {
        app.confirm('Are you feel good today?', function() {
            app.alert('Great!');
        })
    })
    $(document).on('click', '.call-prompt', function() {
        app.prompt('What is your name?', function(data) {
            app.confirm('Are you sure that your name is ' + data + '?', function() {
                app.alert('Ok, your name is ' + data + ' ;)');
            })
        })
    })
    </script>
</body>

</html>
