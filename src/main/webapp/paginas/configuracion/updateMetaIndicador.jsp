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
	String lsSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	
	String oficina = request.getParameter("pOficina");
	String enero = request.getParameter("pEnero");
	String febrero = request.getParameter("pFebrero");
	String marzo = request.getParameter("pMarzo");
	String abril = request.getParameter("pAbril");
	String mayo = request.getParameter("pMayo");
	String junio = request.getParameter("pJunio");
	String julio = request.getParameter("pJulio");
	String agosto = request.getParameter("pAgosto");
	String septiembre = request.getParameter("pSeptiembre");
	String octubre = request.getParameter("pOctubre");
	String noviembre = request.getParameter("pNoviembre");
	String diciembre = request.getParameter("pDiciembre");
	String estado = request.getParameter("pEstado");
	//
	String rutas = "../configuracion/frmMetaIndicadorServicio.jsp";
	String resultado= sA.actualizarIndicadorServicio(oficina, enero, febrero, marzo,
			 abril, mayo, junio, julio, agosto, septiembre,
			 octubre, noviembre, diciembre, estado, lsSociedad);
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
Actualizando ...  <img src="../../imagenes/loading (1).gif" width="15"></img>
</p>
</body>
<% //sA.recibirSolicitud(cadena); %>
<script type="text/javascript">
	alert("<%=resultado%>");
	//$(document).ready(function(){
		var ruta = "../configuracion/frmMetaIndicadorServicio.jsp";
	$('#detalle_menu').load(ruta);
		
	//});
    
	//window.close();
</script>
<%sA.cerrarSesionBD(); %>
</html>