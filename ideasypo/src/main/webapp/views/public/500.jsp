<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" isELIgnored="false" isErrorPage="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <jsp:include page="base.jsp"/>
    <title>内部错误</title>
</head>
<body>
<div class="sr_insideWrong">
    <div class="wrongList">
        <h1>很抱歉，你的请求无法处理！</h1>
        <p><%=exception == null ? "系统异常" : exception.getMessage()%>
        </p>
        <h2>请和管理员联系，或者稍后再试</h2>
    </div>
</div>
</body>
</html>