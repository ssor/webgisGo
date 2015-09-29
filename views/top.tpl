<html>

<head>
    <title>管理页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script language=JavaScript1.2>
    function logout() {
        var r = confirm("确定要退出吗？")
        if (r == true) {
            top.location.href = '/logout';
            //top.location.href = window.location.pathname +'/Welcome/logout';
        }
    }

    function backToLogin() {
        top.location.href = '/';
    }
    </script>
    <base target="main">
    <link href="/stylesheets/skin.css" rel="stylesheet" type="text/css">
    <style type="text/css">
    .top_logout {
        font-size: 15px;
        color: rgb(152, 152, 152);
        font-weight: 500;
    }
    </style>
</head>

<body leftmargin="0" topmargin="0">
    <div style="height:3px;background-color: rgba(68,98,130,0.3);"></div>
    <div class="divTopbg">
        <div>
            <img src="/Image/logo2.png" style="max-width: 199px; margin-top: 5px; margin-left: 5px;" onclick = "backToLogin()">
        </div>
        <a href="/version" target="view_window" style="position: absolute; top: 15px; right: 60px;font-size: 15px; color: rgb(170,170,170); font-weight: 500;">关于</a>
        <!-- <label  class="admin_txt">欢迎您 <%= nickname %> ，感谢登录使用！</label> -->
        <a href="javascript:void(null)" onclick="logout()" class="top_logout" style="font-size: 15px; color: rgb(170,170,170); font-weight: 500;">退出
		</a>
    </div>
    <div style="height:3px;background-color: rgba(68,98,130,0.6);"></div>
</body>

</html>
