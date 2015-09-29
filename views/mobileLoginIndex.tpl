<!DOCTYPE html>
<html>
<head>
    <title>车辆监控系统登录</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/bootstrap/css/bootstrap.css" rel="stylesheet" media="screen">
    <script type="text/javascript" language="javascript" src="/javascripts/jquery.min.js"></script>
    <script type="text/javascript" src="/javascripts/jquery.qrcode.min.js"></script>
    <script src="/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/javascripts/tools.js"></script>
    <script type="text/javascript">
    $(document).ready(function() {
        $(document).keydown(function(event) {
            console.log(event.keyCode);
            if (event.keyCode == 13) { //return key
                login();
            }
        });
    });

    function login() {
        var username = $('#username').val();
        var password = $('#password').val();
        if (username == null || username.length <= 0 || password == null || password.length <= 0) {
            $('#lblTip').text("用户名和密码为空！");
            return;
        };
        console.log('username => ' + username);
        console.log('password => ' + password);
        var obj = {
            id: username,
            pwd: password
        };
        var url = get_host_url() + "/checkLogin";
        $.post(url, obj, function(data) {
            if (data != '') {
                console.log(data);

                if (data != null && data.Code == 0) {
                    console.log('login success');
                    top.location.href = get_host_url() + "/mobile";
                } else {
                    console.log('login failed');
                    $('#lblTip').text("用户名和密码不匹配，请检查输入是否有误！");
                }
            }
        });
    }
    </script>
</head>

<body style="background-color: rgb(249,249,249);">
    <div style="height: 80px;"></div>
    <div class="container" id="container" style="margin-bottom: 50px;">
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="text-align: center;">
                <img src="/Image/webgis_logo.png">
            </div>
        </div>
    </div>
    <div class="container" id="tile_container" style="margin-bottom:80px;">
        <form class="form-horizontal" role="form">
            <div class="form-group">
                <div class="col-xs-1 col-sm-2 col-md-4 col-lg-4"></div>
                <div class="col-xs-10 col-sm-8 col-md-4 col-lg-4">
                    <input type="text" class="form-control" id="username" placeholder="账号">
                </div>
            </div>
            <div class="form-group">
                <div class="col-xs-1 col-sm-2 col-md-4 col-lg-4"></div>
                <div class="col-xs-10 col-sm-8 col-md-4 col-lg-4">
                    <input type="password" class="form-control" id="password" placeholder="密码">
                </div>
                <p class="help-block" id="lblTip" style="color: rgba(256,0,0,0.6);"></p>
            </div>
        </form>
        <div class="col-xs-1 col-sm-2 col-md-5 col-lg-5"></div>
        <div class="col-xs-10 col-sm-8 col-md-2 col-lg-2" style="padding-left: 5px; padding-right: 5px;margin-top: 10px;">
            <button type="button" class="btn btn-primary btn-lg btn-block" onclick="login()">登录</button>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-xs-0 col-sm-1 col-md-3 col-lg-3"></div>
            <div class="col-xs-12 col-sm-10 col-md-6 col-lg-6" style="text-align: center;margin-bottom: 20px;margin-top: 30px;">
                <div style="height:2px; background-color: rgb(200,200,200); "></div>
            </div>
        </div>
    </div>
</body>

</html>
