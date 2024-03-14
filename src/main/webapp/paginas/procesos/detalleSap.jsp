<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServicioConsulta"  %>
<%@page import="java.sql.ResultSet"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServicioConsulta sC = new  ServicioConsulta(pContext);
	ResultSet detalle = null;
	int color=0;
	int error=2;
	String mes=null;
	String meta_ind=null;
	String colors=null;
	String contrato = request.getParameter("pContrato");
	String presentar = "S";
	
	//exporta a excel
	String nombre = "Detalle_Envio_SAP.xls";
	response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");		
		
/*	String imprimir = request.getParameter("pImprimir");
	System.out.println("imprimir:"+imprimir);
	if(imprimir.equals("S")){
		String nombre = "Reporte_Indicadores.xls";
		response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");		
	}
	*/
 %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle Envio SAP</title>
<style type="text/css">

.titulo{
font-family:"Arial, Verdana";
font-size:08pt;
font-weight:bold;
color:#C81414}

.etiqueta_formulario{font-family:"Arial, Verdana";
font-size:12px;
background-color:#C81414;
color:#FFFFFF;
font-weight: bold;}

.detalle_formulario{
font-family:"Arial, Verdana";
font-size:12px;
background-color:#CCCCCC;
color:#000000}

.detalle_formulario_i{
font-family:"Arial, Verdana";
font-size:12px;
background-color:#EBEBEB;
color:#000000}
</style>
</head>
<body>
<div>
<table border="1" align="center" width="100%">
	<tr>
		<td align="center" class="etiqueta_formulario" colspan="7">
			DETALLE ENVIO A SAP &nbsp;
		</td>
	</tr>
	<tr>
		<td align="center" class="etiqueta_formulario" colspan="7">
			CONTRATO : 			&nbsp; <%=contrato%>
		</td>
	</tr>
	<tr>
		<td class="etiqueta_formulario" align="center">SOLICITUD</td>
		<td class="etiqueta_formulario" align="center">POSICION_SOLICITUD</td>
		<td class="etiqueta_formulario" align="center">CONTRATO</td>
		<td class="etiqueta_formulario" align="center">POSICION_CONTRATO</td>
		<td class="etiqueta_formulario" align="center">CENTRO</td>
		<td class="etiqueta_formulario" align="center">CANTIDAD_RECIBIDA</td>
		<td class="etiqueta_formulario" align="center">PRECIO</td>	
	</tr>
<% if(presentar.equals("S")){
	detalle = sC.detalleEnvioSap(contrato);
	if(detalle!=null){
		while(detalle.next()){
			colors="detalle_formulario";
%>
	<tr>
		<td class="<%=colors%>" align="center"><%=detalle.getString(1)%></td>
		<td class="<%=colors%>" align="center"><%=detalle.getString(2)%></td>
		<td class="<%=colors%>" align="center"><%=detalle.getString(3)%></td>
		<td class="<%=colors%>" align="center"><%=detalle.getString(4)%></td>
		<td class="<%=colors%>" align="center"><%=detalle.getString(5)%></td>
		<td class="<%=colors%>" align="center"><%=detalle.getString(6)%></td>
		<td class="<%=colors%>" align="center"><%=detalle.getString(7)%></td>
	</tr>
<%			}
		}
	}
%>
</table>	
</div>
</body>
<%sC.cerrarSesionBD();%>
</html>
