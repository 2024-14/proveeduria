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
	String resultado = op.actualizaPortalAdmin(cadena);
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">	
		<script type="text/javascript">
			var respuesta = "<%=resultado%>";	
			alert(respuesta);
/*			if (respuesta.indexOf("Error") == -1){
				window.opener.loadPortal();
				window.opener.cancelar();
			}
*/			//window.close();
			var ruta = "../configuracion/frmPortalAdministrador.jsp";
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
			<%op.cerrarSesionBD();%>
</html>