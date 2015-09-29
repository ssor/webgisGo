<!DOCTYPE html>
<html>

<head>
    <title>选择路径</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/bootstrap/css/bootstrap.css" rel="stylesheet" media="screen">
    <link href="/stylesheets/index-theme.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .control-label {
        margin-left: -15px;
        margin-right: -20px;
        font-size: 15px;
    }
    </style>
    <script type="text/javascript" language="javascript" src="/javascripts/jquery.js"></script>
    <script src="/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/javascripts/underscore.js"></script>
    <script type="text/javascript" src="/javascripts/tools.js"></script>
    <script type="text/javascript">
    $(document).ready(function() {
        var date = new Date();
        $('#dateEnd')[0].value = date.format('yyyy-MM-dd');
        date.setDate(date.getDate() - 1);
        $('#dateStart')[0].value = date.format('yyyy-MM-dd');

        $.get('/cars', function(data) {
            console.log('carList => ', data);
            // var cars = JSON.parse(data);
            var cars = data
            if (cars != null) {
                var selectCars = $("#selectCars");
                _.each(cars, function(car) {
                    console.log("added car " + car.ID);
                    var ele = "<option value='" + car.ID + "'>" + car.ID + "</option>";
                    selectCars.append(ele);
                })
            }
        });
    });

    function setPara() {
        var carID = $("#selectCars").val();
        if (carID == null) {
            alert('必须先选择一辆车！');
            return;
        }
        var dateStart = $('#dateStart')[0].value;
        var dateEnd = $('#dateEnd')[0].value;
        if (dateStart >= dateEnd) {
            alert('开始时间点必须在结束时间点之前！');
            return;
        }
        var obj = {
            carID: carID,
            dateStart: dateStart,
            dateEnd: dateEnd
        };
        var url = get_host_url() + "/getRoutePoints";
        console.log("set route para: ", obj)
        $.post("/getRoutePoints", obj, function(data) {
            if (data.Code == 0) {
                console.log('设置路径参数 success');
                window.location.href = "/startReplaying";
            } else {
                console.info(' 设置路径参数失败！');
                alert(data.Message);
            }
        });
    }
    </script>
</head>

<body>
    <h4 class="main_page_title">路径回放</h4>
    <div class="demo-info" style="margin-bottom:25px;">
        <div class="demo-tip icon-tip"></div>
        <div>选择您要回放车辆的编号和时间段</div>
    </div>
    <div style="margin:10px 0;"></div>
    <div class="container" id="tile_container" style="margin-bottom:80px;margin-left:0px; padding-left:0px;">
        <form class="form-horizontal" role="form">
            <div class="form-group">
                <div class="col-xs-10 col-sm-8 col-md-4 col-lg-4">
                    <select class="form-control" id="selectCars">
                    </select>
                </div>
                <label class="col-xs-2 col-sm-2 col-md-2 control-label" style="text-align: left; font-weight: 100; color: rgb(180,180,180); padding-top: 12px;">选择车辆</label>
            </div>
            <div class="form-group">
                <div class="col-xs-10 col-sm-8 col-md-4 col-lg-4">
                    <input type="date" class="form-control" id="dateStart" placeholder="">
                </div>
                <label for="inputPassword3" class="col-xs-2 col-sm-2 control-label" style="text-align: left; font-weight: 100; color: rgb(180,180,180); padding-top: 12px;">开始时间点</label>
            </div>
            <div class="form-group">
                <div class="col-xs-10 col-sm-8 col-md-4 col-lg-4">
                    <input type="date" class="form-control" id="dateEnd" placeholder="">
                </div>
                <label for="inputPassword3" class="col-xs-2 col-sm-2 control-label" style="text-align: left; font-weight: 100; color: rgb(180,180,180); padding-top: 12px;">结束时间点</label>
            </div>
        </form>
        <div class="col-xs-10 col-sm-8 col-md-2 col-lg-2" style="padding-left: 0px; padding-right: 5px;margin-top: 10px;">
            <button type="button" class="btn btn-primary btn-lg btn-block" onclick="setPara()" style="">确定</button>
        </div>
    </div>
    <div class="description">
        <h3>说明</h3>
        <p></p>
    </div>
</body>

</html>
