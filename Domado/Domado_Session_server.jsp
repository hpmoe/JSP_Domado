<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%@ include file="Domado_dbconn.jsp" %>

<%
	String mem_id = request.getParameter("mem_id");
	String mem_pass = request.getParameter("mem_pass");

	ResultSet rs = null;
	Statement stmt = conn.createStatement();
	
	String sql = "SELECT mem_pass FROM member WHERE mem_id='";
	sql += mem_id + "'";
	rs =stmt.executeQuery(sql);
	
	String mem_pass2="";
	while(rs.next()) {
		mem_pass2 = rs.getString("mem_pass");		
	}	
	if (mem_pass.equals(mem_pass2)) {
		session.setAttribute("mem_id", mem_id);
		session.setAttribute("mem_pass", mem_pass); //입장허가 해준 것 
		out.println("통과~~~~<br><br>");
		out.println("<a href='04-01_Photo_Client.jsp'>영상처리 실행</a><h1>");
	}
	else
		out.println("### 도로로롯 도도마도 #####");
	
	stmt.close();
	conn.close();			
	
%>


</body>
</html>
