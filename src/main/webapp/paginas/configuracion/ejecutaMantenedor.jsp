<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador" %>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/transitional.dtd">
<html lang="es">
<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	
	String cadena = request.getParameter("pCadena");
	System.out.println("llega a ejecuta_mantenedor, cadena: "+cadena);
	
	
	ServiciosAdministrador sA = new ServiciosAdministrador(pContext);
	String resultado=sA.actualizarUsuarioUbicacion(cadena);
	
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">	
		<script type="text/javascript">
			alert("<%=resultado%>");
			var ruta = "../configuracion/frmMantenedorUsarioUbicacion.jsp";
			$('#detalle_menu').load(ruta);
		</script>
	</head>
	<body>
		<br/>
		<br/>
		<br/>
		<p align="center">
			Actualizando registro ...  <img src="../../imagenes/loading (1).gif" width="15"></img>
		</p>	  
	</body>

</html>