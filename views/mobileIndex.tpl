<!DOCTYPE html>
<html>

<head>
    <title>
        {{.title}}
    </title>
    <meta http-equiv="Content-Type" content="text/html;	charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    
    .row-container {
        border: rgb(205, 205, 205) 1px solid;
        border-left-style: none;
        border-right-style: none;
        border-top-style: none;
    }
    
    .left-image {
        width: 100%;
        height: 100%;
        max-width: 48px;
        margin-top: 0px;
        margin-left: 15px;
    }
    
    .main-title {
        font-size: 150%;
        margin-top: 1%;
    }
    
    .event-detail {
        margin-top: 5px;
        padding-bottom: 5px;
        color: rgb(123, 123, 123);
        font-size: 100%;
        border-bottom: 1px solid rgba(100, 100, 100, 0.4);
    }
    </style>
    <script type="text/javascript" src="/javascripts/jquery.js">
    </script>
    <script type="text/javascript" src="/javascripts/tools.js">
    </script>
    <script src="/bootstrap/js/bootstrap.min.js">
    </script>
    <script type="text/javascript" src="/javascripts/underscore.js"></script>
    <script language="javascript" type="text/javascript">
    var output;
    var elementIDList = [];

    $(document).ready(function() {
        $.ajaxSetup({
            cache: false
        });
        $.get("/cars", function(data) {
            if(data.Code == 0){            
                var carList = data.Data
                _.each(carList, function(_item) { //添加当前不存在的
                    // updateTile(_item);
                    showCar(_item)
                });
            }
        })
    });

    function showCar(car) {
        var container = $('#tile_container');
        var note = "无"
        if (car.Note != null && car.Note.length > 0) {
            note = car.Note
        }
        var ele = $('<div class="row"> <div class="col-xs-12 col-sm-12 col-md-12 event-detail"> <div style="font-size: 20px; color: rgba(10,10,10,0.8);">' + car.ID + '</div> <div style = "color: rgba(100,100,100,0.5);">' + note + '</div> </div> </div>')
        container.append(ele)
        ele.bind('click', function() {
            // testalert(_car.carID);
            console.log(car.ID)
            redirect_to_sub_form(car.ID);
        });
    }

    function redirect_to_sub_form(id) {
        var host = get_host_url();
        // var host = window.location.href.substring(window.location.protocol.length);
        top.location.href = host + "/uploadgps?carID=" + id;
        // body...
    }
    </script>
</head>

<body>
    <div style="margin-bottom:-1px;">
        <h3 id="title">
            {{.title}}
        </h3>
    </div>
    <div class="container" style="background-color: rgb(200,200,200);">
        <h5 style="color: rgb(120,120,120);">选择需要上传数据的车辆</h5>
    </div>
    <div class="container" id="tile_container">
<!-- <div class="row">
    <div class="col-xs-12 col-sm-12 col-md-12 event-detail">
        <div style="font-size: 20px; color: rgba(10,10,10,0.8);">车12345</div>
        <div style="color: rgba(100,100,100,0.5);">一辆车</div>
    </div>
</div>
 -->    </div>
    <div id="output"></div>
</body>

</html>
