<!DOCTYPE html>
<html>
<head>
<title>单号状态查询</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="/bootstrap/css/bootstrap.css" rel="stylesheet" media="screen">    
<style type="text/css">
    #title{
        margin-top: 0;
        background-color: rgb(90,90,90);
        margin-bottom: 2px;
        padding: 10px 0px 10px;
        color: white;
        text-align: center;
        font-size: 23px;
    }
</style>
<script type="text/javascript" language="javascript" src="/javascripts/jquery.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
	 $(document).ready(function() {
	 });
	 function login(){
	 	var bagageID = $('#bagageID')[0].value;
	 	console.log('bagageID => ' + bagageID);
	 	var url = "/getBagageExits/" + bagageID;
	 	$.get(url,function(data){
	 		if(data == "ok"){
				var url = "/bagageStatusIndex/" + bagageID;
				top.location.href = url;
	 		}else{
	 			console.warn(bagageID + ' not exists!');
	 			$("#lblTip").html("单号不存在!");
	 		}
	 	});
	 }
</script>
</head>
<body style="background-color: rgb(249,249,249);">
	<div id="title">单号查询</div>

	<div style="height: 50px;"></div>
	<div class="container" id = "container" style="margin-bottom: 50px;">
	  <div class="row">
<!-- 	    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="text-align: center;">
	    	<div> <img src="/Image/bagageCheck.png"> </div>
	    </div>	   -->	
<!-- 	    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="text-align: center;">
	        <div style="font-size: 28px; color: rgba(66,139,202,2.5);">单号查询</div>
	    </div> -->
	  </div>
	</div>

	<div class="container" id="tile_container" style="margin-bottom:80px;">
		<form class="form-horizontal" role="form">
		  <div class="form-group">
		    <div class="col-xs-1 col-sm-2 col-md-4 col-lg-4"></div>
		    <div class="col-xs-10 col-sm-8 col-md-4 col-lg-4">
		      <input type="text" class="form-control" id="bagageID" placeholder="输入单号" >
		      <div id="lblTip" style="color: rgba(255,0,0,0.7); margin-top: 5px; padding-left: 12px;"></div>
		    </div>
		  </div>
		</form>	
	    <div class="col-xs-1 col-sm-2 col-md-5 col-lg-5"></div>
	    <div class="col-xs-10 col-sm-8 col-md-2 col-lg-2" style="padding-left: 5px; padding-right: 5px;margin-top: 35px;">
			<button type="button" class="btn btn-primary btn-lg btn-block" onclick="login()">查询</button>
	    </div>
	</div>

	<div style="width:100%;text-align:center;">
	</div>

	<div class= "container">
	  <div class="row">
	    <div class="col-xs-0 col-sm-1 col-md-3 col-lg-3"></div>
	    <div class="col-xs-12 col-sm-10 col-md-6 col-lg-6" style="text-align: center;margin-bottom: 20px;margin-top: 30px;">
			<div style="height:2px; background-color: rgb(200,200,200); "></div>
	    </div>
	  </div>
	</div>
</body>
</html>
