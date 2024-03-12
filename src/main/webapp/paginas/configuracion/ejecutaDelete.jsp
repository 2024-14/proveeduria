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
	String sociedad = session.getAttribute("SOCIEDAD").toString();
	String usuario = request.getParameter("pUsuario");
	Operacion op = new Operacion(pContext);
	System.out.println("llega a ejecuta_delete");
	String resultado = op.deletePortalAdmin(usuario, sociedad);
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">	
		<script type="text/javascript">
			var respuesta = "<%=resultado%>";	
			alert(respuesta);
		/*	if (respuesta.indexOf("Error") == -1){
				window.opener.loadPortal();
				window.opener.cancelar();
			}
		*/	//window.close();
			var ruta = "../configuracion/frmPortalAdministrador.jsp";
			$('#detalle_menu').load(ruta);
			
		</script>	
	</head>
	<body>
		<br/>
		<br/>
		<br/>
		<p align="center">
			Eliminando registro ...  <img src="../../imagenes/loading (1).gif" width="15"></img>
		</p>
	  <%op.cerrarSesionBD();%>
	</body>
</html>