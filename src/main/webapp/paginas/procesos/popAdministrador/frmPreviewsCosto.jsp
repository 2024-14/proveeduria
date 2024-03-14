<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@ page import="com.conexion.ServicioConsulta"  %>
<%@ page errorPage="../general/errorGral.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	ServicioConsulta sC = new ServicioConsulta(pContext);
	String lsSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	String proveedor = request.getParameter("pProveedor");
	if(proveedor.equals("ADMINISTRADOR")){
		proveedor="todos";
	}else if(proveedor.equals("UTIMPOR")){
		proveedor = "UTIMPOR";
	}
	String estado [] = request.getParameterValues("pEstado");
	String estado1  = request.getParameter("pEstado");
	String fecha_desde = request.getParameter("pFechaDesde");
	String fecha_hasta = request.getParameter("pFechaHasta");
	
	String detallePreviewCosto [][] = null;
	String imprimir="N";
	
	try{
		imprimir = request.getParameter("pImprimir");
	}catch(Exception e ){
		imprimir="N";
	}
	System.out.println("imprimir:"+imprimir);
	
	if(imprimir.equals("S")){
		String nombre = "Reporte_PreviewsCosto.xls";
		response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");		
	}

 %>
 <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
 <title>Detalle de solicitud</title>
 <style type="text/css">
.etiqueta_formulario{
font-family:"Arial, Verdana";
font-size:10pt;
background-color:#C81414;
color:#FFFFFF;
font-weight: bold;}

.detalle_formulario{
font-family:"Arial, Verdana";
font-size:12px;
background-color:#CCCCCC;
color:#000000}


</style>
<script type="text/javascript">
function ok() {  
	document.frmDetPreFactura.submit();
}			

</script>

</head>
<body onload="ok()">
	<form name="frmDetPreFactura"  method="post" target="_bandeja" action="ExportarPdf.jsp">
	 	<table border="1" align="center">
	 		<tr>
	 			<td>
	 				<table border="0" align="center" width=100%>
	 				   <tr>
		 					<td align="center" class="etiqueta_formulario" colspan="5">
				 				 Reporte - Preview de Costos &nbsp;
				 			</td>
	 					</tr>
	 					<tr>
		 					<td align="center" class="etiqueta_formulario">
				 				PROVEEDOR : <%=(proveedor.equals(""))?"TODOS":proveedor.toUpperCase()%>  &nbsp;
				 			</td>
				 			
				 			<td align="center" class="etiqueta_formulario">
				 				MES : <%=sA.dateMonth().toUpperCase() %> 
				 			</td>
				 			
				 			<td align="center" class="etiqueta_formulario">
				 				Año : <%=sA.dateYear()%> 
				 			</td>
				 			<td align="center" colspan="2" class="etiqueta_formulario">
				 				SOCIEDAD : <%=sA.consultaSociedad(lsSociedad).toUpperCase()%>
				 			</td>
				 			<% 
				 			if(imprimir.equals("P")){
				 			 	sA.previewCostoPdf(estado1, proveedor, proveedor, sA.dateMonth(),lsSociedad, sA.consultaSociedad(lsSociedad).toUpperCase(),fecha_desde,fecha_hasta);
				 			}  
				 			%>
	 					</tr>
	 				</table>
	 			</td>
	 		</tr>
	 		<tr>
	 			<td>
					<table border="1" align="center" width="100%">
						<thead>
							<tr class="etiqueta_formulario">
								<td align="center">Codigo de Articulo</td>
								<td align="center">Artículo</td>
								<td align="center">Costo unitario</td>
								<td align="center">Q despachada</td>
								<td align="center">Costo total</td>
							</tr>
							<% 
							detallePreviewCosto = sA.consultaPreviwesCosto(proveedor,estado,lsSociedad,fecha_desde,fecha_hasta);
								if(detallePreviewCosto!=null){
									for(int i=0;i<detallePreviewCosto[0].length;i++){
							 %>
							<tr class="detalle_formulario" >
								<td ><%=detallePreviewCosto[0][i]%></td>
								<td align="right" ><%=detallePreviewCosto[1][i]%></td>
								<td align="right" ><%=detallePreviewCosto[2][i]%></td>
								<td align="right" ><%=detallePreviewCosto[3][i]%></td>
								<td align="right" ><%=detallePreviewCosto[4][i]%></td>
							</tr>
							<%}%>
							<tr>
								<td colspan="4" class="etiqueta_formulario" align="center">SUMATORIA TOTAL : </td>
								<td class="detalle_formulario" align="right"><b><%=detallePreviewCosto[5][0]%></b></td>
							</tr>
							<%}%>
						</thead>
						<%sA.cerrarSesionBD();%>
					</table>
				</td>
			</tr>
			<% if(detallePreviewCosto==null){%>
			<tr>
				<td>
					<table border="0" align="center">
						<tr>
							<td class="titulo" align="center">No existen datos a presentar</td>
						</tr>
					</table>
				</td>
			</tr>
			<% }
			   %>
		</table>
	</form>
</body>
	<%sA.cerrarSesionBD();%>
</html>