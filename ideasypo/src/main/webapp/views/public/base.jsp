<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--<%@ page import="com.xiaomingming.api.vo.UsUser" %>--%>
<%
    String path = request.getContextPath();
    String port = (request.getServerPort() == 80 || request.getServerPort() == 443) ? "" : ":" + String.valueOf(request.getServerPort());
    String basePath = request.getScheme() + "://" + request.getServerName() + port + path + "/";
    request.setAttribute("_basePath", basePath);
    request.setAttribute("_jsvesion", "20171228");
    request.setAttribute("_projectTitle", "Api接口管理系统");
//    UsUser user = (UsUser) request.getSession().getAttribute("_currentUser");
%>
<base href="${_basePath}"/>
<meta charset="utf-8"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>${_projectTitle}</title>
<script type="text/javascript" src="${_basePath}static/js/jquery-3.2.1.min.js?v=${_jsvesion}"></script>
<link rel="stylesheet" type="text/css" href="${_basePath}static/css/iview.css?v=${_jsvesion}">
<script type="text/javascript" src="${_basePath}static/js/vue.min.js?v=${_jsvesion}"></script>
<script type="text/javascript" src="${_basePath}static/js/iview.min.js?v=${_jsvesion}"></script>
<script type="text/javascript">
    var basePath = '${_basePath}';
    function isEmpty(str) {
        if (str === "" || str === 0 || str === "0" || str === null || str === false || typeof str === 'undefined' || str.length === 0) {
            return true;
        }
        return false;
    }
    function getQueryString(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null)return unescape(r[2]);
        return null;
    }
    /*
     存储localstorage时候最好是封装一个自己的键值，在这个值里存储自己的内容对象，封装一个方法针对自己对象进行操作。避免冲突也会在开发中更方便。
     */
    var innerStorage = (function innerStorage() {
        var ms = "innerStorage";
        var storage = window.localStorage;
        if (!window.localStorage) {
            return false;
        }
        var set = function (key, value) {
            //存储
            var mydata = storage.getItem(ms);
            if (!mydata) {
                this.init();
                mydata = storage.getItem(ms);
            }
            mydata = JSON.parse(mydata);
            mydata.data[key] = value;
            storage.setItem(ms, JSON.stringify(mydata));
            return mydata.data;
        };
        var get = function (key) {
            //读取
            var mydata = storage.getItem(ms);
            if (!mydata) {
                return false;
            }
            mydata = JSON.parse(mydata);

            return mydata.data[key];
        };
        var remove = function (key) {
            //读取
            var mydata = storage.getItem(ms);
            if (!mydata) {
                return false;
            }
            mydata = JSON.parse(mydata);
            delete mydata.data[key];
            storage.setItem(ms, JSON.stringify(mydata));
            return mydata.data;
        };
        var clear = function () {
            //清除对象
            storage.removeItem(ms);
        };
        var init = function () {
            storage.setItem(ms, '{"data":{}}');
        };
        return {
            set: set,
            get: get,
            remove: remove,
            init: init,
            clear: clear
        };


    })();
    function removeByValue(arr, val) {
        for (var i = 0; i < arr.length; i++) {
            if (arr[i] == val) {
                arr.splice(i, 1);
                break;
            }
        }
    }
</script>





