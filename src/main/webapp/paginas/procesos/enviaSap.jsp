<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@ page import="com.conexion.ServicioConsulta"  %>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.DAO.RespuestaSap"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 <% 
JspFactory jspFactory = JspFactory.getDefaultFactory();
PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
String contrato = request.getParameter("pContrato");
System.out.println("llega solictud: "+contrato);
ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
RespuestaSap respuesta = null;
respuesta=sA.generaPedidoSap(contrato);
//generaPedido()
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<script type="text/javascript" src="../../js/jquery-1.11.2.js"></script>
<script type="text/javascript" src="../../js/jquery-ui.js"></script>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<script type="text/javascript">
   $(document).ready(function(){
		$('#enviaSap').click(function(){ carga(); });
		$('#detalleSap').click(function(){	cargaDetalle(<%=contrato%>); });	
	});
	function cargaDetalle(contract){
		var ruta = "../procesos/detalleSap.jsp?pContrato="+contract;
		window.open(ruta, "_self");
	}
	function carga(){
		window.close();
	}
	alert("Enviando pedido con contrato: "+<%=contrato%>);
</script>
</head>
<body>

<div class="etiqueta_formulario">La respuesta de envio sap:</div>
<div class="detalle_formulario"><%=respuesta.getCadenaRespuestaSap() %></div>
<div class="etiqueta_formulario">Cadena enviada a Sap: </div>
<div class="detalle_formulario"><%=respuesta.getCadenaEnviadaSap() %></div>

<div align="center">
	<input type="button" value="Detalle" class="detalleSap" id="detalleSap" name="detalleSap"/>
</div>
</body>
<%sA.cerrarSesionBD();%>
</html>
