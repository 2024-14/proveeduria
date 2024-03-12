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
	//Operacion op = new Operacion(pContext);
	ServicioConsulta sC = new  ServicioConsulta(pContext);
		
	String proveedor = request.getParameter("pProveedor");
	String solicitud = request.getParameter("pSolicitud");
	String usuario = request.getParameter("pUsuario");
	String area = request.getParameter("pArea");
	String ceco = request.getParameter("pCeco");
	String sociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();

	String imprimir = request.getParameter("pImprimir");
	String fecha_desde = request.getParameter("pFechaDesde");
	String fecha_hasta = request.getParameter("pFechaHasta");
	String presentar = "";
	try{
		presentar = request.getParameter("pPresentar");
		//System.out.println("presentar : "+presentar);
		if(presentar==null){
			presentar = "N";
		}
	}catch(Exception e){
		presentar = "";
	}
	
	if(imprimir.equals("S")){
		String nombre = "Reporte_General_Proveeduria.xls";
		response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");	
		
	}
						
	String mes=sC.obtieneMes(fecha_hasta.substring(4,5));

	List<String[]> reporteGeneral = sC.consultaReporteGeneral(sociedad,proveedor,solicitud,area,usuario,ceco,fecha_desde,fecha_hasta);
	int CantReporteGeneral=reporteGeneral.size();
	System.out.println("CantReporteGeneral: "+CantReporteGeneral);
 %>
<head>

<script type="text/javascript">
	$(document).ready(function(){
		$("#tbDetalleConsulta").tablesorter({dateFormat: "uk"}); 
	});
</script>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle de solicitud</title>

<style type="text/css">

.titulo{
	font-family:"Arial, Verdana";
	font-size:08pt;
	font-weight:bold;
	color:#C81414
}

.etiqueta_formulario{font-family:"Arial, Verdana";
	font-size:12px;
	background-color:#C81414;
	color:#FFFFFF;
	font-weight: bold;
}

.detalle_formulario{
	font-family:"Arial, Verdana";
	font-size:13px;
	background-color:#CCCCCC;
	color:#000000
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


	<%if(imprimir.equals("S")){%>
	<table border="1" align="center" width="150%">
  				<tr>
					<td align="center" class="etiqueta_formulario" colspan="19">
						REPORTE MENSUAL PROVEEDURIA &nbsp;
					</td>
				</tr>
				<tr>
					<td align="center" class="etiqueta_formulario" colspan="19">
						MES : 			&nbsp; <%=mes%> &nbsp;||&nbsp;&nbsp;
						SOCIEDAD :		&nbsp; <%=sociedad%> &nbsp;||&nbsp;&nbsp;
						FECHA DESDE :	&nbsp; <%=fecha_desde%> &nbsp;||&nbsp;&nbsp;
						FECHA HASTA :	&nbsp; <%=fecha_hasta%> &nbsp;
					</td>
				</tr>
				<tr>
					<td align="center" class="etiqueta_formulario" colspan="19">
						SOLICITUD : 			&nbsp; <%=solicitud%> &nbsp;||&nbsp;&nbsp;
						USUARIO :		&nbsp; <%=usuario%> &nbsp;||&nbsp;&nbsp;
						CENTRO DE COSTO :		&nbsp; <%=ceco%> &nbsp;||&nbsp;&nbsp;
						PROVEEDOR :	&nbsp; <%=proveedor%> &nbsp;||&nbsp;&nbsp;
						AREA DE EMPRESA:	&nbsp; <%=area%> &nbsp;
					</td>
				</tr>
			</table>
<%	}	
%>
	<%
	if(CantReporteGeneral != 0){
	%>
	<table width="150%" id="tbDetalleConsulta" class="tablesorter">
		<thead>
			<tr align="center" >
				<td class="etiqueta_formulario2">Sociedad</td>
				<td class="etiqueta_formulario2">Proveedor</td>
				<td class="etiqueta_formulario2">No. Solicitud</td>
				<td class="etiqueta_formulario2">Región</td>
				<td class="etiqueta_formulario2">Nombre Ubicación</td>
				<td class="etiqueta_formulario2">Usuario</td>
				<td class="etiqueta_formulario2">Estatus</td>
				<td class="etiqueta_formulario2">Centro de Costo</td>
				<td class="etiqueta_formulario2">Área Empresa</td>
				<td class="etiqueta_formulario2">Fecha Despacho</td>
				<td class="etiqueta_formulario2">Fecha Recepción</td>
				<td class="etiqueta_formulario2">Id Material</td>
				<td class="etiqueta_formulario2">Texto breve del material</td>
				<td class="etiqueta_formulario2">N° de Guia</td>
				<td class="etiqueta_formulario2">Cant Solicitada</td>
				<td class="etiqueta_formulario2">Cant Despachada</td>
				<td class="etiqueta_formulario2">Cant Recibida</td>
				<td class="etiqueta_formulario2">Costo Unitario</td>
				<td class="etiqueta_formulario2">Costo Total</td>			
			</tr>
			</thead>
			<tbody>
			<%
			int i = 0;
			for(String[] detalleReporte : reporteGeneral){
			 %>		
			<tr class="detalle_formulario" >
				<td align="center" width=""><%=(detalleReporte[0]==null)?"":detalleReporte[0]%></td>
				<td width="8%"><%=(detalleReporte[1]==null)?"":detalleReporte[1]%></td>
				<td width=""><%=(detalleReporte[2]==null)?"":detalleReporte[2]%></td>
				<td align="center" width=""><%=(detalleReporte[3]==null)?"":detalleReporte[3]%></td>
				<td width="15%"><%=(detalleReporte[4]==null)?"":detalleReporte[4]%></td>
				<td width="25%"><%=(detalleReporte[5]==null)?"":detalleReporte[5]%></td>
				<td align="center" width="10%"><%=(detalleReporte[6]==null)?"":detalleReporte[6]%></td>
				<td width=""><%=(detalleReporte[7]==null)?"":detalleReporte[7]%></td>
				<td width="5%"><%=(detalleReporte[8]==null)?"":detalleReporte[8]%></td>
				<td align="center" width="5%"><%=(detalleReporte[9]==null)?"":detalleReporte[9]%></td>
				<td align="center" width="5%"><%=(detalleReporte[10]==null)?"":detalleReporte[10]%></td>
				<td width=""><%=(detalleReporte[11]==null)?"":detalleReporte[11]%></td>
				<td width="25%"><%=(detalleReporte[12]==null)?"":detalleReporte[12]%></td>
				<td align="center" width="5%"><%=(detalleReporte[13]==null)?"":detalleReporte[13]%></td>
				<td align="center" width=""><%=(detalleReporte[14]==null)?"":detalleReporte[14]%></td>
				<td align="center" width=""><%=(detalleReporte[15]==null)?"":detalleReporte[15]%></td>	
				<td align="center" width="5%"><%=(detalleReporte[16]==null)?"":detalleReporte[16]%></td>	
				<td align="right" width="5%"><%=detalleReporte[17]%></td>	
				<td align="right" width="5%"><%=detalleReporte[18]%></td>																																					
			</tr>
			<%}
			%>
			</tbody>
			</table>
		<%}else{ %>
			<table align="center" width="100%" cellpadding="1" cellspacing="0" >
				<tr>
					<td class="titulo" align="center">No existen datos a presentar</td>
				</tr>
			</table>
<%} 
sC.cerrarSesionBD();%>	
</body>
</html>