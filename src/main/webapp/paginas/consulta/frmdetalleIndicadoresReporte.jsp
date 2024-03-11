<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServicioConsulta"  %>
<%@ page import="java.util.List"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServicioConsulta sC = new  ServicioConsulta(pContext);
		
	String proveedor = request.getParameter("pProveedor");
	String tipoInd= request.getParameter("pTipoInd");
	int cont=0;
	String detalleRep = "";
	if (tipoInd.equals("1")){
		 detalleRep="Cumplimiento Mensual de la Proveeduría";
	}else if(tipoInd.equals("2")){
		 detalleRep="Cumplimiento al Cronograma Establecido";
	}else if (tipoInd.equals("3")){
		 detalleRep="Cumplimiento en el despacho de la Proveeduría";
	}

	String sociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();

	String imprimir = request.getParameter("pImprimir");
	System.out.println("imprimir: "+imprimir);
	
	String fecha_desde = request.getParameter("pFechaDesde");
	String fecha_hasta = request.getParameter("pFechaHasta");
	String presentar = "";
	try{
		presentar = request.getParameter("pPresentar");
		if(presentar==null){
			presentar = "N";
		}
	}catch(Exception e){
		presentar = "";
	}
	
	if(imprimir.equals("S")){
		String nombre = "Reporte_Indicadores_Proveeduria.xls";
		response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");	
		System.out.println("entro imprimir: "+imprimir);
		
	}
						
	String mes=sC.obtieneMes(fecha_hasta.substring(4,5));
	
	List<String[]> reporteIndicador = sC.reporteIndicadores(sociedad,proveedor,fecha_desde,fecha_hasta,tipoInd);
	int CantIndicadoresReporte=reporteIndicador.size();
	System.out.println("CantIndicadoresReporte: "+CantIndicadoresReporte);
	
 %>
<head>

<script type="text/javascript">
	$(document).ready(function(){
		$("#tbDetalleConsulta<%=tipoInd%>").tablesorter({dateFormat: "uk"}); 
	});
</script>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle de solicitud</title>

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
font-size:13px;
background-color:#CCCCCC;
color:#000000}

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
	<%if(imprimir.equals("S")){
	%>
	<table border="1" align="center" width="100%">
		<tr>
			<td align="center" class="etiqueta_formulario" colspan="10">
				<%=detalleRep%> &nbsp;
			</td>
		</tr>
		<tr>
			<td align="center" class="etiqueta_formulario" colspan="10">
				MES : 			&nbsp; <%=mes%> &nbsp;||&nbsp;&nbsp;
				SOCIEDAD :		&nbsp; <%=sociedad%> &nbsp;||&nbsp;&nbsp;
				FECHA DESDE :	&nbsp; <%=fecha_desde%> &nbsp;||&nbsp;&nbsp;
				FECHA HASTA :	&nbsp; <%=fecha_hasta%> &nbsp;
			</td>
		</tr>
	</table>
<%	}	
%>
	<%
	if(CantIndicadoresReporte != 0){
	%>

	<table width="100%" id="tbDetalleConsulta<%=tipoInd%>" class="tablesorter">
		<thead>
			<tr align="center" >
				<td class="etiqueta_formulario2">No.</td>
				<td class="etiqueta_formulario2">Proveedor</td>
				<td class="etiqueta_formulario2">No. Solicitud</td>
				<td class="etiqueta_formulario2">Detalle</td>
				<td class="etiqueta_formulario2">Sitio</td>
				<td class="etiqueta_formulario2">Fecha Despacho</td>
				<td class="etiqueta_formulario2">Estado de Despacho</td>
				<td class="etiqueta_formulario2">Fecha Recepción</td>
				<td class="etiqueta_formulario2">Estado Recepción</td>
				<td class="etiqueta_formulario2">Observacion</td>
			</tr>
			</thead>
			<tbody>
		<% if(presentar.equals("S")){ 
			cont=0;
			for(String[] detalleIndicador : reporteIndicador){
				cont++;
			 %>
			<tr class="detalle_formulario" > 
				<td align="center" width=""><%=String.format("%03d", cont)%></td>
				<td align="center" width=""><%=(detalleIndicador[0]=="null")?"":detalleIndicador[0]%></td>
				<td align="center" width=""><%=(detalleIndicador[1]=="null")?"":detalleIndicador[1]%></td>
				<td align="center" width=""><%=(detalleIndicador[2]=="null")?"":detalleIndicador[2]%></td>
				<td align="center" width=""><%=(detalleIndicador[3]=="null")?"":detalleIndicador[3]%></td>
				<td align="center" width=""><%=(detalleIndicador[4]=="null")?"":detalleIndicador[4]%></td>
				<td align="center" width=""><%=(detalleIndicador[5]=="null")?"":detalleIndicador[5]%></td>
				<td align="center" width=""><%=(detalleIndicador[6]=="null")?"":detalleIndicador[6]%></td>
				<td align="center" width=""><%=(detalleIndicador[7]=="null")?"":detalleIndicador[7]%></td>
				<td align="center" width=""><%=(detalleIndicador[8]==null)?"":detalleIndicador[8]%></td>
			</tr>
		<%}}%>
	</tbody>
</table>
	<%}else{ %>
<table align="center" width="100%" cellpadding="1" cellspacing="0" >
	<tr>
		<td class="titulo" align="center">No existen datos a presentar</td>
	</tr>
</table>
<%} %>
</body>
</html>