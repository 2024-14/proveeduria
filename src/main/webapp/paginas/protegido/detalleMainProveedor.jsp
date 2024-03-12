<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion" %>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
	
    Operacion op = new Operacion(pageContext); 
	String lsUsuario = request.getSession().getAttribute("USUARIO").toString();
	String lsSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	
	List<String[]> bandejaProvedor = op.bandejaProveedor(lsUsuario, lsSociedad);
	int CantBandejaProveedor=bandejaProvedor.size();
	System.out.println("CantBandejaProveedor: "+CantBandejaProveedor);
	
%> 
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:lang="es" lang="es">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<link href="../../css/estilo.css" rel="stylesheet"></link>
		<script type="text/javascript" src="../../js/jquery.tablesorter.js"></script>
		<title>M&oacute;dulo&nbsp;de&nbsp;Proveedor</title>
		
		<script type="text/javascript">
		$(document).ready(function(){
			$("#myTable").tablesorter({dateFormat: "uk"});
		});
			
		</script>
		
	<style type="text/css">
	#consulta, #detalle_consulta, #subdetalle{
		border: 1px solid #C81414;
		margin: 10px;
	}
	#submenu{
		margin: 10px;
		border: 1px solid black;
		padding: 10px;
	}
	.imagen{
		margin-top: 3px;
		margin-left: 3px;
		position: absolute;
	}
	#detalle_solicitud{
		height: auto;
		overflow: scroll;
	}
	
	.etiqueta_formulario_1{
		font-family:"Arial, Verdana";
		font-size:20px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
.etiqueta_formulario2{
		cursor: pointer;
		font-family:"Arial, Verdana";
		font-size:12px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
</style>
	</head>
	<body>
		<form name="frmProv" action="despacho.jsp" method="get" target="_DESPACHO"> 
		<%
		if(CantBandejaProveedor != 0){
		%>
		<table align="center" width="100%" cellpadding="1" cellspacing="1" id="myTable" class="tablesorter">
			<thead>
				<tr align="center">
					<td class="etiqueta_formulario2" width="1px"></td>
					<td class="etiqueta_formulario2">Solicitud</td>
					<td class="etiqueta_formulario2">Fecha&nbsp;Aprobaci&oacute;n</td>
					<td class="etiqueta_formulario2">&Aacute;rea</td>
					<td class="etiqueta_formulario2">Ceco</td>
					<td class="etiqueta_formulario2">Total&nbsp;Pedido</td>
					<td class="etiqueta_formulario2">Estado</td>
				</tr>
			</thead>
			<tbody>
			<%
			int i = 0;
			for(String[] detalleBandeja : bandejaProvedor){
			 %>		
				<tr align="center" >
					<td class="detalle_formulario"><img alt="" src="../../imagenes/busqueda.png" width="30" onclick="javascript:cargar(<%=i%>);" name="botonbuscar" id="#botonbuscar"/></td>
					<td class="detalle_formulario"><%=detalleBandeja[0] %><input type="hidden" name="txtSolicitud<%=i%>" value="<%=detalleBandeja[0]%>"/></td>
					<td class="detalle_formulario"><%=detalleBandeja[1]%></td>
					<td class="detalle_formulario"><%=detalleBandeja[2] %></td>
					<td class="detalle_formulario"><%=detalleBandeja[3] %></td>
					<td class="detalle_formulario" align="right"><%=detalleBandeja[4]%>&nbsp;&nbsp;</td>
					<td class="detalle_formulario"><%=detalleBandeja[5] %></td>
				</tr>								
			<%	i++;
			}
			%>		
			</tbody>				
		</table>
		<%}else{ %>
		<table align="center" width="100%" cellpadding="1" cellspacing="0" >
			<tr>
				<td class="titulo" align="center">No existen datos a presentar</td>
			</tr>
		</table>
		<%} %>
		 </form>	
		 <%op.cerrarSesionBD();%>
	</body> 
</html>