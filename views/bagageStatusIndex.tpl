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
	var bagageID = "<%= bagageID %>";
	 $(document).ready(function() {
        $.ajaxSetup({
            cache:  false
        });
        setInterval("statusRequest()", 5000);
        statusRequest();
	 });
	 function statusRequest(){
		var url = "/getBagageStatus";
		$.post(url, {bagageID: bagageID}, function(data){
			updateStatus(data);
		});	 	
	 }
	 function updateStatus(data){
	 	console.log(data);
	 	var obj = JSON.parse(data);
	 	$("#carID")[0].value = obj.carID;
	 	$("#timeStamp")[0].value = obj.timeStamp;
	 	$('#imgPosition').attr("src","/Image/carPos/"+ obj.imageName);
	 }
</script>
</head>
<body style="background-color: rgb(216,218,219);">
	<div id="title">单号状态</div>

	<div class="container" id="tile_container" style="margin-bottom:80px;">
		<div class = "row">

		</div>


	   <form class="form-horizontal" role="form" style="margin-top:20px;">
		  <div class="form-group">
            <label for="inputPassword3" class="col-xs-3 col-sm-2 col-md-2 col-md-offset-2 col-lg-2 col-lg-offset-2 control-label" style="text-align: left; font-weight: 100; color: rgb(100,100,100);">单号</label>

		    <div class="col-xs-12 col-sm-12  col-md-4 col-lg-4">
		      <input type="text" class="form-control" id="bagageID" placeholder="<%= bagageID %>"  disabled>
		    </div>
		  </div>
		  <div class="form-group">
            <label class="col-xs-12 col-sm-12 col-md-2 col-md-offset-2 col-lg-2 col-lg-offset-2 control-label" style="text-align: left; font-weight: 100; color: rgb(100,100,100);">当前位置</label>
		    <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4" style="text-align:center;">
		      <img id="imgPosition" src="" style="width:100%;max-width: 512px;">
		      <!-- <img id="imgPosition" src="/Image/rt.png" style="width:100%;"> -->

		    </div>
		  </div>		  
		  <div class="form-group">
            <label for="inputPassword3" class="col-xs-3 col-sm-2 col-md-2 col-md-offset-2 col-lg-2 col-lg-offset-2 control-label" style="text-align: left; font-weight: 100; color: rgb(100,100,100);">所在车辆</label>
		    <div class="col-xs-12 col-xs-offset-1 col-sm-10 col-md-4 col-lg-4">
		      <input type="text" class="form-control" id="carID" placeholder="" disabled>
		    </div>
		  </div>
	
		  <div class="form-group">
            <label for="inputPassword3" class="col-xs-3 col-sm-2 col-md-2 col-md-offset-2 col-lg-2 col-lg-offset-2 control-label" style="text-align: left; font-weight: 100; color: rgb(100,100,100);">更新时间</label>
		    <div class="col-xs-12 col-xs-offset-1 col-sm-10 col-md-4 col-lg-4">
		      <input type="text" class="form-control" id="timeStamp" placeholder="" disabled>
		    </div>
		  </div>		  	  
		</form>	
	</div>

</body>
</html>
