<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xmlns:lang="es">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<title>Error</title>
		<link href="../../css/estilo.css" rel="stylesheet"></link>
		<script type="text/javascript">
			function login(){
				window.clearTimeout()
				//window.close();
				window.open("../login/frmLogin.html","_self");
			}
		</script>
	</head>
	<body>
		<table>
			<tr>
				<td class="portada">Se&nbsp;ha&nbsp;generado&nbsp;el&nbsp;siguiente&nbsp;error:</td>
			</tr>
			<tr>
				<td class="titulo"><%=session.getAttribute("ERROR") %></td>
			</tr>
			<tr>
				<td class="titulo"><%=session.getAttribute("requestedPage") %></td>
			</tr>		
			<tr>
				<td class="enlaces"><a href="javascript:login();">Intente&nbsp;de&nbsp;Nuevo</a></td>
			</tr>
		</table>
	</body>
	<% session.setAttribute("ERROR",""); %>
</html>