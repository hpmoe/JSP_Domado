<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%

	MultipartRequest multi = new MultipartRequest(request, "c:\\upload", 
			5*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	

	String tmp;
	Enumeration params = multi.getParameterNames();
	
	tmp = (String) params.nextElement();
	String name = multi.getParameter(tmp);
	String algo = multi.getParameter(tmp);
	tmp = (String) params.nextElement();
	
	String parameter = multi.getParameter(tmp);
	
	int value=0;
	if(!multi.getParameter(tmp).equals(""))
		value = Integer.parseInt(multi.getParameter(tmp));
	
	
	Enumeration files = multi.getFileNames();
	tmp = (String) files.nextElement();
	String filename = multi.getFilesystemName(tmp);

	out.println("업로드 파일명 :" + filename + "<br>");
	
	String infname = multi.getParameter("infname");
	String outfname = multi.getParameter("outfname");
	
	
	
	int inW, inH,outW=0, outH=0;
	
	File inFp;
	FileInputStream inFs;
	inFp = new File("C:/Upload/" + filename);
	long fLen = inFp.length();
	inH = inW = (int)Math.sqrt(fLen);	
	inFs = new FileInputStream(inFp.getPath());
	// (2) JSP에서 배열 처리
	int[][]  inImage = new int[inH][inW]; // 메모리 할당
	// 파일 --> 메모리
	for (int i=0; i<inH; i++) {
		for (int k=0; k<inW; k++) {
			inImage[i][k] = inFs.read();
		}
	}
	inFs.close();
	
	int[][] outImage = null;
	outW = outH = inW;
	
	switch (algo) {
	case "1" :   // 반전하기
		// 반전 알고리즘 :  out = 255 - in
		// (중요!) 출력영상의 크기 결정 --> 알고리즘에 의존
		outH = inH;
		outW = inW;
		// 메모리 할당
		outImage = new int[outH][outW];
		// 진짜 영상처리 알고리즘
		for(int i=0; i<inH; i++)
			for (int k=0; k<inW; k++) {
				outImage[i][k] = 255 - inImage[i][k];
			}
		break;
	case "2" :   // 밝게하기
		// 더하기 알고리즘 :  out = in + 값  (주의!오버플로)
		// (중요!) 출력영상의 크기 결정 --> 알고리즘에 의존
		outH = inH;
		outW = inW;
		// 메모리 할당
		outImage = new int[outH][outW];
		// 진짜 영상처리 알고리즘
		for(int i=0; i<inH; i++)
			for (int k=0; k<inW; k++) {
				int value2 = inImage[i][k] + value;
				if (value2 > 255)
					 value2 = 255;
				if (value2 < 0)
					value2 = 0;
				outImage[i][k] = value2;				
			}
		break;	
	case "3": //어둡게하기 
		
		outH = inH;
		outW = inW;
		// 메모리 할당
		outImage = new int[outH][outW];
		// 진짜 영상처리 알고리즘
		for(int i=0; i<inH; i++)
			for (int k=0; k<inW; k++) {
				int value2 = inImage[i][k] - Integer.parseInt(parameter);
				if (value2 > 255)
					 value2 = 255;
				if (value2 < 0)
					value2 = 0;
				outImage[i][k] = value2;				
			}
		break;	
		
	case "4": //확대하기 
		
		outH = inH*2;
		outW = inW*2;
		// 메모리 할당
		outImage = new int[outH][outW];
		// 진짜 영상처리 알고리즘
		for(int i=0; i<outH; i++)
			for (int k=0; k<outW; k++) {
				int value2 = inImage[i/value][k/value];
				outImage[i][k] = value2;				
			}
		break;	
		case "5": //축소하기 
			
			outH = inH/value;
			outW = inW/value;
			// 메모리 할당
			outImage = new int[outH][outW];
			// 진짜 영상처리 알고리즘
			for(int i=0; i<outH; i++)
				for (int k=0; k<outW; k++) {
					int value2 = inImage[i*value][k*value];
					outImage[i][k] = value2;				
				}
			break;
			
		case "6"://mask-blur
			outImage = new int[outW][outH];
			int t1=1,t2=9;
			double maskv = (double)t1/t2;
			double[][] maskb = {{maskv,maskv,maskv},{maskv,maskv,maskv},{maskv,maskv,maskv}};
			double temp=0.0;
			for(int i=0;i<outW;i++){
				for(int k=0;k<outH;k++){
					if((i >0 && i < outW-1) && (k>0 && k<outH-1)){
						for(int x=0;x<3;x++){
							for(int y=0;y<3;y++){
								temp += maskb[x][y]*inImage[i-1+x][k-1+y];
							}
						}
						outImage[i][k] = (int)temp;
						temp = 0.0;
					}
					else	
						outImage[i][k] = inImage[i][k];
				}
			}
			break;
			
		case "7" ://mask-embos
			outImage = new int[outW][outH];
			int[][] maskemb = {{-1,0,0},{0,0,0},{0,0,1}};
			int tem = 0;
			for(int i=0;i<inW;i++){
				for(int k=0;k<inH;k++){
					if((i > 0 && i < outW-1) && (k>0 && k<outH-1)){
						for(int x=0;x<3;x++){
							for(int y=0;y<3;y++){
								tem += maskemb[x][y]*inImage[i-1+x][k-1+y];
							}
						}
						outImage[i][k] = tem;
						tem=0;
					}
					else
						outImage[i][k] = 0;
				}
			}
			break;
		
		case "8" ://b&w
			outImage = new int[outW][outH];
			for(int i=0;i<inW;i++){
				for(int k=0;k<inH;k++){
					if(inImage[i][k] < 128){
						outImage[i][k] = 0;
					}else
						outImage[i][k] = 255;
				}
			}
			break;
			
		case "9" ://rot
			outImage = new int[outW][outH];
			int c = outW/2, xd, yd;
			double rad = value*Math.PI/180.0;
			for(int i=0;i<outW;i++){
				for(int k=0;k<outH;k++){
					xd = (int)(Math.cos(rad)*(k-c) - Math.sin(rad)*(i-c)+c);
					yd = (int)(Math.sin(rad)*(k-c)+Math.cos(rad)*(i-c)+c);
					if((0<=xd && xd<outH) && (0<=yd && yd<outW))
						outImage[i][k] = inImage[xd][yd];
				}
			}
			break;
	} //endswitch
	
	// (4) 결과를 파일로 쓰기
	File outFp;
	FileOutputStream outFs;
	String outFname = "out_" + filename ;
	outFp = new File("C:/Out/"+outFname);
	outFs = new FileOutputStream(outFp.getPath());
	// 메모리 --> 파일
	for (int i=0; i<outH; i++) {
		for (int k=0; k<outW; k++) {
			outFs.write(outImage[i][k]);
		}
	}
	out.println("<h1><a href='http://localhost:8080/JSP_study/Domado_download.jsp?file="
		       +outFname+ "'>다운로드</a></h1>");
	
	outFs.close();
	
	// out.println("c:/Out/out_" + filename + " 처리됨~");
	
	
	
	
%>


</body>
</html>
