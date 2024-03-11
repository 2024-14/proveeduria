<%@ page import="com.conexion.JspLib"  %>
      <%
      JspLib obj=new JspLib(pageContext);
      String ls_nombreDialogo=request.getParameter("nombreDialogo");
      String ls_param=obj.getParamString();
      if(ls_param!=null && ls_param.length()>0){
         ls_nombreDialogo=JspLib.concatenarParametro(ls_nombreDialogo,ls_param);
      }
     String ls_titulo=request.getParameter("titulo");
      if(ls_titulo==null)
       ls_titulo="";
     %> 
     <html>
<head>
<title><%=ls_titulo%></title>
<frameset rows="0,*" frameborder="NO" border="0" framespacing="0" rows="*">
<frame name="admin" scrolling="NO" noresize src="gep_blanca.jsp" >
<frame name="topFrame" scrolling="NO" noresize src="<%=ls_nombreDialogo%>" >
</frameset>
</head>
<body>
</body>
</html>