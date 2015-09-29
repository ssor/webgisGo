<!DOCTYPE html>
<html>

<head>
    <title>车辆列表</title>
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
        <div class="main_page_title">车辆管理</div>
        <div class="demo-info">
            <div>管理运输的车辆</div>
        </div>
    </div>
    <div>
        <a href="javascript:void(0);" onclick="refresh_grid()" class="sui-btn btn-bordered btn-info" style="width:100px;  margin-top: 40px;">刷新</a>
        <a href="javascript:void(0);" onclick="showAddCarModal()" class="sui-btn btn-bordered btn-info" style="width:100px;  margin-top: 40px; margin-left: 8px;">增加</a>
        <a href="javascript:void(0);" onclick="deleteCar()" class="sui-btn btn-bordered btn-info" style="width:100px;  margin-top: 40px; margin-left: 8px;">删除</a>
    </div>
    <div style="border-bottom: solid 1px rgba(200,200,200,0.1); margin-top: 5px;margin-bottom:3px;"></div>
    <table id="dtProcess" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>车牌号</th>
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
                "url": "/cars",
                "dataSrc": "Data"
            },
            "columns": [{
                "data": "ID",
                "width": "30%"
            }, {
                "data": "AddedTime",
                "width": "30%"
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

    function showAddCarModal() {
        $("#myModal").modal("show")
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

    function deleteCar() {
        var id = getSelectedID()
        if (id != null) {
            console.log("delete car ", id)
            $.confirm({
                body: '删除该信息将无法恢复，确定删除吗？',
                width: 'normal',
                backdrop: true,
                bgcolor: 'none',
                okHide: function() {
                    $.ajax({
                        url: '/cars?id=' + id,
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
    <!-- Modal-->
    <div id="myModal" tabindex="-1" role="dialog" data-hasfoot="false" class="sui-modal hide fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" data-dismiss="modal" aria-hidden="true" class="sui-close">×</button>
                    <h4 id="myModalLabel" class="modal-title">添加新用户</h4>
                </div>
                <div class="modal-body">
                    <form class="sui-form form-horizontal">
                        <div class="control-group">
                            <label for="inputEmail" class="control-label">车牌号：</label>
                            <div class="controls">
                                <input type="text" id="inputCarID" placeholder="京J0001">
                            </div>
                        </div>
                        <div class="control-group">
                            <label for="inputEmail" class="control-label">备注：</label>
                            <div class="controls">
                                <input type="text" id="inputNote" placeholder="无">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" data-ok="modal" class="sui-btn btn-primary btn-large" onclick="addCar()">添加</button>
                    <button type="button" data-dismiss="modal" class="sui-btn btn-default btn-large" onclick="cancel()">取消</button>
                </div>
            </div>
        </div>
        <script type="text/javascript">
        function cancel() {
            $("#myModal").modal("hide")
        }

        function addCar() {
            var obj = {
                carID: $("#inputCarID").val(),
                note: $("#inputNote").val()
            }
            $.post("/cars", obj, function(data) {
                if (data.Code == 0) {
                    refresh_grid()
                } else {
                    alert(data.Message)
                }
                cancel()
            })
        }
        </script>
    </div>
</body>

</html>
