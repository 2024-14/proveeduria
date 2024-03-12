<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@ page errorPage="../general/errorGral.jsp" %>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.OutputStream"%>
<%@ page import="com.conexion.ServicioConsulta"  %>
<%@ page import="java.io.*" %>
<%@ page import= "com.lowagie.text.*" %>
<%@ page import= "com.lowagie.text.pdf.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	ServicioConsulta sC = new ServicioConsulta(pContext);
	
	String fecha_desde	= request.getParameter("pFechaDesde");
	String fecha_hasta 	= request.getParameter("pFechaHasta");
	String proveedor 	= request.getParameter("pProveedor");
	String estado [] 	= request.getParameterValues("pEstado");
	String estado1 		= request.getParameter("pEstado");
	String lsSociedad 	= request.getSession().getAttribute("PS_SOCIEDAD").toString();
	
	System.out.println("Proveedor: "+proveedor);
	
	String detallePreFatura [][] = null;
	String suma = "";
	
	String nombre = "Reporte_PreFactura.xls";
	String imprimir="N";
	
	try{
		imprimir = request.getParameter("pImprimir");
	}catch(Exception e ){
		imprimir="N";
	}
	
	System.out.println("imprimir: "+imprimir);
	
	if(imprimir.equals("S")){
		
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

</head>
<body>
	<form name="frmDetPreFactura" >
	 	<table border="1" align="center">
	 		<tr>
	 			<td>
	 				<table border="0" align="center"  width="100%">
	 					<tr>
		 					<td align="center" class="etiqueta_formulario" colspan="5">
				 				Reporte - Pre Factura   &nbsp;
				 			</td>
				 		</tr>
	 					<tr>
		 					<td align="center"  class="etiqueta_formulario">
				 				PROVEEDOR : <%=(proveedor.equals(""))?"TODOS":proveedor.toUpperCase()%>  &nbsp;
				 			</td>
				 			<td align="center"  class="etiqueta_formulario">
				 				MES : <%=sA.dateMonth().toUpperCase()%> 
				 			</td>
				 			<td align="center"  class="etiqueta_formulario">
				 				AÑO : <%=sA.dateYear()%> 
				 			</td>
				 			<td align="center"  class="etiqueta_formulario" colspan="2">
				 				SOCIEDAD : <%=sA.consultaSociedad(lsSociedad).toUpperCase()%>
				 			</td>
	 					</tr>
	 				</table>
	 			</td>
	 			
	 		</tr>
	 		<tr>
	 			<td>
					<table border="1" align="center" width="100%">
						<thead>
							<tr class="etiqueta_formulario">
								<td>Codigo de Articulo</td>
								<td>Artículo</td>
								<td>Costo unitario</td>
								<td>Q recibida</td>
								<td>Costo total</td>
							</tr>
							<% 
							detallePreFatura = sA.consultaPreFactura(proveedor,estado,lsSociedad,fecha_desde,fecha_hasta);
								if(detallePreFatura!=null){
									for(int i=0;i<detallePreFatura[0].length;i++){
							 %>
							<tr class="detalle_formulario" >
								<td ><%=detallePreFatura[0][i]%></td>
								<td align="right" ><%=detallePreFatura[1][i]%></td>
								<td align="right" ><%=detallePreFatura[2][i]%></td>
								<td align="right" ><%=detallePreFatura[3][i]%></td>
								<td align="right" ><%=detallePreFatura[4][i]%></td>
							</tr>
							<%}%>
							<tr>
								
								<%suma = detallePreFatura[5][0];%>
								<td colspan="4" class="etiqueta_formulario">SUMATORIA TOTAL : </td>
								<td class="detalle_formulario" align="right"><%=detallePreFatura[5][0]%> </td>
							</tr>
							<%}%>
							<%
							if(imprimir.equals("P")){
							 	sA.PreFacturaPdf(estado1, proveedor, proveedor, sA.dateMonth(),lsSociedad, sA.consultaSociedad(request.getSession().getAttribute("PS_SOCIEDAD").toString()),fecha_desde,fecha_hasta);
							}
							%>
						</thead>
						
					</table>
				</td>
			</tr>
			<% if(detallePreFatura==null){%>
			<tr>
				<td>
					<table border="0" align="center">
						<tr>
							<td class="titulo" align="center">No existen datos a presentar</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>Estos valores no incluyen Impuestos</td>
			</tr>
			<% }%>
		</table>
	</form>
	<%sA.cerrarSesionBD();%>
</body>

</html>