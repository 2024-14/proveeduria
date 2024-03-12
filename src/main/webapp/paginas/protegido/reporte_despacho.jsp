<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion"  %>	
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="es">
<head>

<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	Operacion op = new Operacion(pContext); 
	String lsUsuario = request.getSession().getAttribute("USUARIO").toString();
	String vendorId = lsUsuario;//op.getVendorId(lsUsuario);		
	
	
	
	String pass = request.getSession().getAttribute("PASS").toString();
	String sociedad = request.getSession().getAttribute("SOCIEDAD").toString();
	String id_ruc = op.ConsultaRUC(lsUsuario, pass,sociedad);
	String setsolicitud = request.getParameter("pSolicitud");
	//String pedido = request.getParameter("pNroOrden");
	
	String setid= "", noOrden="", dept="", s_estado="";
	String cantidad = "";

	String nombre = "Reporte_Despacho.xls";
	response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");
	
	List<String[]> detalleDespacho = op.getDetPedido(setsolicitud, id_ruc,sociedad);
	int CantDetalleDespacho=detalleDespacho.size();
	System.out.println("CantDetalleDespacho: "+CantDetalleDespacho);
	
	List<String[]> hdr = op.getHdrPedido(setsolicitud, lsUsuario, sociedad);
	int CantHdr=hdr.size();
	System.out.println("CantHdr: "+CantHdr);
	
%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>M&oacute;dulo&nbsp;de&nbsp;Proveedor</title>
<style type="text/css">
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

.titulo_tabla{
font-family:"Arial, Verdana";
font-size:14px;
background-color:#C81414;
color:#FFFFFF;
font-weight: bold;}
</style>
</head>
<body onload="javascript:verificaLogin(<%=request.getSession().getAttribute("AUTH").toString()%>);">
	<form name="frmDetOrden">
		<table width="100%" border="0" align="center">
			<tr>
				<td colspan="10" align="center" class="titulo_tabla">Solicitud de Proveeduria</td>
			</tr>
			
		</table>
		<table>
			<%
			//try{
			//hdr = op.getHdrPedido(setsolicitud,lsUsuario,solcitud); 
			for(String[] detalleHdr : hdr){
			//if(hdr!=null){
			//if (hdr.next()) {
			//setid = hdr.getString(1);
			//noOrden = hdr.getString(2);%>
			<tr>
				<td colspan="2" class="etiqueta_formulario">Set Id:</td>
				<td colspan="1" class="detalle_formulario"><%=op.consultaSociedad(sociedad)%></td>
				<td colspan="1"  class="etiqueta_formulario">Solicitante:</td>			
				<td colspan="6"  class="detalle_formulario">	
				<%=detalleHdr[2]%>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="etiqueta_formulario">Solicitud:</td>
				<td colspan="1" class="detalle_formulario"><%=detalleHdr[0]%>
				
				</td>
				<td colspan="1" class="etiqueta_formulario">Departamento:</td>
				<td colspan="6" class="detalle_formulario"><%=detalleHdr[4]%></td>
			</tr>
			<tr>
				<td colspan="2" class="etiqueta_formulario">Estado:</td>
				<td colspan="1" class="detalle_formulario"><%=detalleHdr[1]%></td>
				<td colspan="1" class="etiqueta_formulario">Ubicación:</td>
				<td colspan="6" class="detalle_formulario"><%= detalleHdr[3]%></td>
			</tr>
			<tr>
				<td colspan="2" class="etiqueta_formulario">Guia de Remision:</td>
					<td colspan="1" class="detalle_formulario"></td>
				<td colspan="1" class="etiqueta_formulario">Fecha de despacho:</td>
					<td colspan="6" class="detalle_formulario"></td>				
			</tr>
			<% 
			}
			
			  
			%>
		</table>
		<br/> 
		<% 
		if(CantDetalleDespacho != 0){
		%>
			<table width="100%" border="0" align="center">
				<tr align="center">
					<td class="etiqueta_formulario" width="1px">Nro</td>
					<td class="etiqueta_formulario" width="1px">C&oacute;digo</td>
					<td class="etiqueta_formulario">Producto</td>
					<td class="etiqueta_formulario" width="100">Fecha</td>
					<td class="etiqueta_formulario" width="1px">Cant. Pedida</td>
					<td class="etiqueta_formulario" width="1px">Total Despachado</td>
					<td class="etiqueta_formulario" width="1px">Cant. Despachada</td>
					<td class="etiqueta_formulario" width="100">Estado</td>
					<td class="etiqueta_formulario" width="1px">Guia de Remision</td>
					<td class="etiqueta_formulario" width="1px">Fecha despacho</td>
			</tr>
			
			
			<% 
				int idx = 0;
				for(String[] registroDetalle : detalleDespacho){
			 %>	
			 		<tr>
					<td class="detalle_formulario"><%=registroDetalle[0]%>
					
						</td>
					<td class="detalle_formulario"><%=registroDetalle[1]%>
					<td class="detalle_formulario"><%=registroDetalle[2]%>
					<td class="detalle_formulario"><%=registroDetalle[3]%>
					<td class="detalle_formulario"><%=registroDetalle[4]%></td>
					<td class="detalle_formulario"><%=registroDetalle[5]%></td>
					<td class="detalle_formulario">0</td>
					<td align="center" class="detalle_formulario"><%
					if (registroDetalle[4].equals(registroDetalle[5]))
						out.println("Despacho Total");
					else if (registroDetalle[5].equals("0"))
						out.println("No Despachado");
					else	
						out.println("Despacho Parcial");
					
					%>
					</td>
					<td class="detalle_formulario"><%=(registroDetalle[6]==null)?"":registroDetalle[6]%></td>
					<td class="detalle_formulario"><%=(registroDetalle[7]==null)?"":registroDetalle[7]%></td>
				</tr>
				
			<% idx ++; 
			} %>
			</table>			
			<%}else{ %>
			<table align="center" width="100%" cellpadding="1" cellspacing="0" >
				<tr>
					<td class="titulo" align="center">No existen datos a presentar</td>
				</tr>
			</table>
			<% } %>
	</form>
	<%op.cerrarSesionBD();%>
</body>
</html>