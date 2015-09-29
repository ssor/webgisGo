<!DOCTYPE html>
<html>

<head>
    <title>单号列表</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <link href="/stylesheets/index-theme.css" rel="stylesheet" type="text/css" />
    <link href="/dataTable/css/jquery.dataTables.css" rel="stylesheet" media="screen">
    <link href="http://g.alicdn.com/sj/dpl/1.5.1/css/sui.min.css" rel="stylesheet">
    <style type="text/css">

    </style>
    <script src="/javascripts/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="http://g.alicdn.com/sj/dpl/1.5.1/js/sui.min.js">
    </script>
    <script src="/dataTable/js/jquery.dataTables.js"></script>
    <script src="/javascripts/tools.js" type="text/javascript"></script>
</head>

<body style="margin-right:5px;">
    <div>
        <div class="main_page_title">单号查询</div>
        <div class="demo-info">
            <div>查询运输中包裹的状态</div>
        </div>
    </div>
    <div style="">
        <a href="javascript:void(0);" onclick="refresh_grid()" class="sui-btn btn-bordered btn-info" style="width:100px;  margin-top: 40px;">刷新</a>
        <a href="javascript:void(0);" onclick="startMnt()" class="sui-btn btn-bordered btn-info" style="width:100px;  margin-top: 40px; margin-left: 8px;">地图监控</a>
        <a href="javascript:void(0);" onclick="deleteBagage()" class="sui-btn btn-bordered btn-info" style="width:100px;  margin-top: 40px; margin-left: 8px;">删除</a>
    </div>
    <div style="border-bottom: solid 1px rgba(200,200,200,0.1); margin-top: 5px;margin-bottom:3px;"></div>
    <table id="dtProcess" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>单号</th>
                <th>所在车辆</th>
                <th>加入时间</th>
                <th>备注</th>
            </tr>
        </thead>
    </table>
    <script type="text/javascript">
    var table = null
    $(function() {
        table = $('#dtProcess').DataTable({
            "columnDefs": [],
            "paging": false,
            "ordering": true,
            "order": [
                [0, "asc"]
            ],
            "info": false,
            "searching": true,
            "ajax": {
                "url": "/bagages",
                "dataSrc": "Data"
            },
            "columns": [{
                "data": "ID",
                "width": "20%"
            }, {
                "data": "CarID",
                "width": "20%"
            }, {
                "data": "AddedTime",
                "width": "20%"
            }, {
                "data": "Note",
                "width": "40%"
            }]
        });
        $('#dtProcess tbody').on('click', 'tr', function() {
            //只能选中单行
            if ($(this).hasClass('selected')) {
                $(this).removeClass('selected');
            } else {
                table.$('tr.selected').removeClass('selected');
                $(this).addClass('selected');
            }

            //可以选中多行
            // $(this).toggleClass('selected');
        });
    })



    function refresh_grid() {
        table.ajax.reload()
    }

    function getSelectedID() {
        var data = table.rows(".selected").data()
        if (data.length <= 0) {
            alert("请先选择一辆车！")
            return null
        } else {
            var id = data[0].ID
            return id
        }
    }

    function startMnt() {
        var rows = grid1.datagrid('getSelections');
        if (rows.length > 0) {
            window.location.href = "/startBagageMnting/" + rows[0].bagageID;
            return;
        }
    }

    function deleteBagage() {
        var id = getSelectedID()
        if (id != null) {
            console.log("delete bagage ", id)
            $.confirm({
                body: '删除该信息将无法恢复，确定删除吗？',
                width: 'normal',
                backdrop: true,
                bgcolor: 'none',
                okHide: function() {
                    $.ajax({
                        url: '/bagages?id=' + id,
                        type: 'DELETE',
                        success: function(data) {
                            if (data.Code != 0) {
                                $.alert(data.Message)
                            } else {
                                refresh_grid()
                            }
                        }
                    });
                },
            })
        }
    }
    </script>
    <div class="description">
        <h3>说明</h3>
        <p></p>
    </div>
</body>

</html>
