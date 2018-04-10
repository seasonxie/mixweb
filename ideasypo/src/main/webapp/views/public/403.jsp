<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         language="java" isELIgnored="false" isErrorPage="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <jsp:include page="base.jsp"/>
    <title>禁止访问</title>
</head>
<body>
<div class="sr_noPower">
    <div class="wrongList">
        <h1>很抱歉，您请求的资源未获授权！</h1>
        <p><%=exception == null ? "尝试访问未获授权的资源" : exception.getMessage()%>
        </p>
        <h2>请和管理员联系以获得授权</h2>
    </div>
</div>
</body>
</html>
