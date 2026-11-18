<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Chuyển hướng thẳng vào trang chủ hiển thị video ở ngoài màn hình
    response.sendRedirect(request.getContextPath() + "/home");
%>
