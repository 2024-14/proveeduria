<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion" %>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/transitional.dtd">
<html lang="es">
<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	String setId = request.getParameter("pSetId");
	String nroOrden = request.getParameter("pNroOrden");
	String cadena = request.getParameter("pCadena");
	String usuario = session.getAttribute("USUARIO").toString();
	Operacion op = new Operacion(pContext);
	System.out.println("llega a ejecuta_insert");
	String resultado = op.insertPortalAdmin(cadena);
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">	
		<script type="text/javascript">
	/*		if (respuesta.indexOf("Error") == -1){
				window.opener.loadPortal();
				window.opener.cancelar();
			}
	*/		//var ruta = "../configuracion/frmPortalAdministrador.jsp";
			//$('#detalle_menu').load(ruta);
			//window.close();
			var respuesta = "<%=resultado%>";	
		alert(respuesta);
		//alert("Exito");
		//$(document).ready(function(){
		var ruta = "../configuracion/frmPortalAdministrador.jsp";
		$('#detalle_menu').load(ruta);
		//window.close();
		</script>	
	</head>
	<body>
		<br/>
		<br/>
		<br/>
		<p align="center">
			Insertando registro ...  <img src="../../imagenes/loading (1).gif" width="15"></img>
		</p>
	</body>
	
</html>