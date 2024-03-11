<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
		
	//String cadena = request.getParameter("pCadena");
	//System.out.println("Cadena "+cadena);
	
	String oficina = request.getParameter("pOficina");
	String lsSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	
	//
	String rutas = "../configuracion/frmMetaIndicadorServicio.jsp";
	String resultado = sA.eliminarIndicadorServicio(oficina, lsSociedad);
	//System.out.println(rutas);
	
 %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle de solicitud</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
</head>
<body>
<br/>
<br/>
<br/>
<p align="center">
Eliminando ...  <img src="../../imagenes/loading (1).gif" width="15"></img>
</p>
</body>
<% //sA.recibirSolicitud(cadena); %>
<script type="text/javascript">
	alert("<%=resultado%>");
	//$(document).ready(function(){
		var ruta = "../configuracion/frmMetaIndicadorServicio.jsp";
	$('#detalle_menu').load(ruta);
		
	//});
    
	window.close();
</script>

</html>