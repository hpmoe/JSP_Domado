<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%

	Connection conn = null; //JSP와 DB를 연결하는 교량 
	
	String url = "jdbc:mysql://localhost:3306/shop_db";
	String user = "root";
	String password= "1234";

	Class.forName("com.mysql.jdbc.Driver"); //mysql ~~~.jar 파일
	
	conn = DriverManager.getConnection(url, user, password);
	
	
%>
