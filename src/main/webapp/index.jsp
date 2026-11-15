<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Tự động chuyển hướng vào /waiting (nếu đã login hoặc có cookie sẽ tự vào home, chưa thì vào login)
    response.sendRedirect(request.getContextPath() + "/waiting");
%>
