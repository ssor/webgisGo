<!DOCTYPE html>
<html>

<head>
    <title>修改密码</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="http://g.alicdn.com/sj/dpl/1.5.1/css/sui.min.css" rel="stylesheet">
    <link href="/stylesheets/index-theme.css" rel="stylesheet" type="text/css" />
    <style type="text/css">

    </style>
    <script type="text/javascript" language="javascript" src="/javascripts/jquery.js"></script>
    <script type="text/javascript" src="http://g.alicdn.com/sj/dpl/1.5.1/js/sui.min.js"></script>
    <script type="text/javascript" src="/javascripts/tools.js"></script>
    <script type="text/javascript">
    // $(document).ready(function() {});

    function login() {
        var currentPassword = $('#currentPassword').val();
        var newpassword1 = $('#newpassword1').val();
        var newpassword2 = $('#newpassword2').val();
        if (newpassword2 != newpassword1) {
            alert('两次输入的新密码不一致！');
            return;
        }
        var obj = {
            currentPassword: currentPassword,
            newpassword: newpassword1
        };
        var url = get_host_url() + "/postNewPassword";
        $.post(url, obj, function(data) {
            if (data != '') {
                console.log(data);
                if (data.Code == 0) {
                    console.log('更改密码成功！');
                    alert('更改密码成功！', 'info');
                } else {
                    console.log('更改密码失败！');
                    alert('更改密码失败！', 'info');
                }
                window.location.href = get_host_url() + "/changePassword";
            }
        });
    }
    </script>
</head>

<body>
    <div>
        <div class="main_page_title">修改密码</div>
        <div class="demo-info">
            <div>输入旧密码，设置新密码</div>
        </div>
    </div>
    <div class="container" id="tile_container" style="margin-top:44px; margin-bottom:0px;margin-left:0px; padding-left:0px;">
        <form class="sui-form form-horizontal" role="form">
            <div class="control-group">
                <div class="controls">
                    <input type="password" class="form-control" id="currentPassword" placeholder="当前密码" style="width:300px;">
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <input type="password" class="form-control" id="newpassword1" placeholder="输入新密码" style="width:300px;">
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <input type="password" class="form-control" id="newpassword2" placeholder="再次输入新密码" style="width:300px;">
                </div>
            </div>
        </form>
            <button type="button" class="sui-btn btn-xlarge btn-primary" onclick="login()" style="margin-left:3px;">确定</button>
    </div>
    <div class="description">
        <h3>说明</h3>
        <p></p>
    </div>
</body>

</html>
