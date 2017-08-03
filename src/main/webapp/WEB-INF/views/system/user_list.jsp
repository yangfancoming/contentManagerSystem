<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/comm/mytags.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>后台管理系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="shortcut icon" href="${ctx}/static/img/favicon.ico">

    <link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
    <link rel="stylesheet" href="${ctx}/static/css/global.css">

    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/common.css" media="all">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/personal.css" media="all">
    <link rel="stylesheet" type="text/css" href="http://at.alicdn.com/t/font_9h680jcse4620529.css">

    <script src="${ctx}/static/layui/layui.js"></script>
    <%--<script type="text/javascript" src="${ctx}/static/js/index.js"></script>--%>


<body>
<div class="larry-grid larryTheme-A">
    <div class="larry-personal">
        <div class="layui-tab">
            <blockquote class="layui-elem-quote mylog-info-tit">
                <div class="layui-inline">
                    <a class="layui-btn  userAdd_btn"> <i class="layui-icon larry-icon larry-xinzeng1"></i>新增用户</a>
                </div>
            </blockquote>
            <div class="larry-separate"></div>
            <!-- 操作日志 -->
            <div class="layui-tab-item layui-field-box layui-show">
                <div class="layui-form">
                    <table class="layui-table" lay-even="" lay-skin="row">
                        <%--<colgroup>--%>
                            <%--<col width="50">--%>
                            <%--<col width="150">--%>
                            <%--<col width="150">--%>
                            <%--<col width="100">--%>
                            <%--<col width="150">--%>
                            <%--<col width="150">--%>
                            <%--<col width="120">--%>
                            <%--<col width="150">--%>
                            <%--<col width="202">--%>

                        <%--</colgroup>--%>
                        <thead >
                            <tr>
                                <th><input name="" lay-skin="primary" lay-filter="allChoose" type="checkbox"></th>
                                <th>登陆账号</th>
                                <th>用户姓名</th>
                                <th>用户状态</th>
                                <th>创建人</th>
                                <th>创建时间</th>
                                <th>修改人</th>
                                <th>修改时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="userTbody">
                            <%--<tr>--%>
                                <%--<td><input name="" lay-skin="primary" type="checkbox"></td>--%>
                                <%--<td>贤心</td>--%>
                                <%--<td>2016-11-29</td>--%>
                                <%--<td>人生就像是一场修行</td>--%>
                            <%--</tr>--%>

                        </tbody>
                    </table>
                </div>
                <div class="larry-table-page clearfix" id="userPage"></div>
            </div>

        </div>
    </div>
</div>
<script type="text/javascript">
    layui.use(['form', 'laypage', 'layer'], function () {
        var $ = layui.jquery,
                form = layui.form(),
                laypage = layui.laypage,
                layer = layui.layer;

        //全选
        form.on('checkbox(allChoose)', function (data) {
            var child = $(data.elem).parents('table').find('tbody input[type="checkbox"]');
            child.each(function (index, item) {
                item.checked = data.elem.checked;
            });
            form.render('checkbox');
        });
        //添加用户
        $(".userAdd_btn").click(function(){
            var index = layui.layer.open({
                title : "新增用户",
                type : 2,
                content : "${ctx}/user/user_add",
                area: ['550px', '265px'],
                success : function(layero, index){

                }
            });
        });
        //修改用户
         $("body").on("click",".user_edit",function(){
            var userId = $(this).attr("data-id");
             var index = layui.layer.open({
                 title : "编辑用户",
                 type : 2,
                 content : "${ctx}/user/user_update?userId="+userId,
                 area: ['550px', '265px'],
                 success : function(layero, index){

                 }
             });
        });
        //分配角色
        $("body").on("click",".user_grant",function(){
            var userId = $(this).attr("data-id");
            var index = layui.layer.open({
                title : '<i class="larry-icon larry-jiaoseguanli1"></i>分配角色',
                type : 2,
                content : "${ctx}/user/user_grant?userId="+userId,
                area: ['500px', '440px'],
                success : function(layero, index){

                }
            });
        });
        function paging(curr){
           // var loginLoading = layer.msg('数据加载中，请稍候',{icon: 16,time:false,shade:0.8});
            var pageLoading = layer.load(2);
            $.ajax({
                url : '${ctx}/user/ajax_user_list',
                type : 'post',
                data :{
                    page: curr || 1 ,   //当前页
                    rows: 7           //每页显示四条数据
                },
                success : function(data) {
                    if(data != "" ){
                        var pdata = $.parseJSON(data);
                        $(pdata.rows).each(function(index,item){

                            var userStatusLable;
                            switch (item.userStatus){
                                case 0:
                                    userStatusLable = '<span class="label label-success ">0-有效</span>';
                                    break;
                                case 1:
                                    userStatusLable = '<span class="label label-danger ">1-失效</span>'
                                    break;
                            }

                            var opt ='<div class="layui-btn-group">';
                            opt+=  '<a class="layui-btn layui-btn-mini user_edit" data-id="'+item.userId+'"><i class="layui-icon larry-icon larry-bianji2"></i> 编辑</a>';
                            opt+=  '<a class="layui-btn layui-btn-mini layui-btn-warm  user_grant" data-id="'+item.userId+'"><i class="layui-icon larry-icon larry-jiaoseguanli3"></i>角色</a>';
                            opt+=  '<a class="layui-btn layui-btn-mini layui-btn-danger  links_del" data-id=""><i class="layui-icon larry-icon larry-ttpodicon"></i>失效</a>';
                            opt+= '</div>';
                            $("#userTbody").append(
                                    '<tr>'+
                                    '<td><input name="" lay-skin="primary" type="checkbox"></td>'+
                                    '<td>'+item.userLoginName+'</td>'+
                                    '<td>'+item.userName+'</td>'+
                                    '<td>'+userStatusLable+'</td>'+
                                    '<td>'+item.creator+'</td>'+
                                    '<td>'+item.createTime+'</td>'+
                                    '<td>'+objNull(item.modifier)+'</td>'+
                                    '<td>'+objNull(item.updateTime)+'</td>'+
                                    '<td>'+opt+'</td>'+
                                    '</tr>'
                            );
                            form.render();

                        });
                        laypage({
                            cont: 'userPage',
                            pages:  pdata.totalSize,
                            curr: curr || 1, //当前页
                            skip: true,
                            jump: function(obj, first){ //触发分页后的回调
                                if(!first){ //点击跳页触发函数自身，并传递当前页：obj.curr
                                    $("#userTbody").text('');//先清空原先内容
                                    paging(obj.curr);


                                }
                            }
                        });
                        layer.close(pageLoading);
                    }


                }

            });
        }


        paging(1);






    });

    function objNull(obj) {
        if(typeof(obj) == "undefined" || obj == null){
            return "";
        }
        return obj;
    }

</script>

</body>
</html>