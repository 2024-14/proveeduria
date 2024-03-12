<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
	Operacion op = new Operacion(pageContext);
	op.cerrarSesionBD();
	op.cerrarSesionUsuario();
%>
<html>
  <head>
   	<script type="text/javascript">
		function mensaje(){
			alert("La conexion ha finalizado con Exito");
			System.out.println("La conexion ha finalizado con Exito");
			//alert("La conexion ha finalizado con Exito");
			//window.open("../login/frmLogin.html");	
			top.open("../login/frmLogin.html","_self");  
			
		}
   	</script>
  </head>  
  <body onload="javascript:mensaje();">
  
  </body>
</html>
