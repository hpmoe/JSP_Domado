<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>

<%
	String mem_id = (String) session.getAttribute("mem_id");
	String mem_pass = (String) session.getAttribute("mem_pass");
	
	if (mem_id ==null || mem_pass == null) {
		out.println("잘못된 접근 경로입니다... <br><br>");
		return;
	}
%>

<form name='fileForm' method='post' enctype='multipart/form-data'
   action='Domado_Server.jsp'>
   <p> <select name="algo">
		<option value=""> --- 선택하시오 ---</option>
			<option value="1">반전처리</option>
			<option value="2">밝게하기</option>
			<option value="3">어둡게하기</option>
			<option value="4">확대하기</option>
			<option value="5">축소하기</option>
			<option value="6">블러링</option>
			<option value="7">앰보싱</option>
			<option value="8">흑백</option>		
			<option value="9">회전</option>		
	</select>
	<p> 파라미터 : <input type="text" value="0" name="parameter">
	
	<p> 파일 : <input type='file' name='filename'>
	<p> <input type="submit" value="처리하기">
   
</form>

</body>
</html>
