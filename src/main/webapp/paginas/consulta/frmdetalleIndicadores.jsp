<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServicioConsulta"  %>
<%@page import="java.util.List"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	
	System.out.println("1");
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServicioConsulta sC = new  ServicioConsulta(pContext);
	
	int color=0;
	int error=2;
	String mes=null;
	String meta_ind=null;
	String colors=null;
	
	List<String> listIndicadores = null;
	List<String> listProveed = null;
		
	String sociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	String proveedor = request.getParameter("pProveedor");
	String oficina = request.getParameter("pOficina");
	String oficinaM=oficina.replaceAll("~", " ");
	String fecha_desde = request.getParameter("pFechaDesde");
	String fecha_hasta = request.getParameter("pFechaHasta");
		String presentar = "";
	String imprimir = request.getParameter("pImprimir");
	
	try{
		presentar = request.getParameter("pPresentar");
		System.out.println("PROVEEDOR:"+proveedor+":");
		if(presentar==null){
			presentar = "N";
		}
	}catch(Exception e){
		presentar = "";	
	}
	
	mes=sC.obtieneMes(fecha_hasta.substring(4,5));
	
	try{	
		if(imprimir.equals("S")){
			String nombre = "Reporte_Indicadores.xls";
			response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");		
		}
	}catch(Exception e){
		imprimir = "N";
		out.println(e.getMessage());
	}	
	
	int f0= sC.obtieneTotalIndicadores(proveedor,fecha_desde,fecha_hasta,sociedad);
 %>
<head>
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

.detalle_formulario_i{
font-family:"Arial, Verdana";
font-size:12px;
background-color:#EBEBEB;
color:#000000}
</style>
</head>
<body>

<table border="1" align="center" width="100%">
	<tr>
		<td>
			<table border="1" align="center" width="100%">
  				<%
  					if ( imprimir.equals("S")){
  						
  				%>
  				<tr>
					<td align="center" class="etiqueta_formulario" colspan="5">
						REPORTE :: INDICADORES DE SERVICIO
					</td>
				</tr>
				<%} %>
				<tr align="center" >
					<td class="etiqueta_formulario" >
						MES
					</td>
					<td class="etiqueta_formulario">
						OFICINA
					</td>
					<td class="etiqueta_formulario" >
						FECHA DESDE
					</td>
					<td class="etiqueta_formulario" >
						FECHA HASTA
					</td>
					<td class="etiqueta_formulario">
						TOTAL APROBADAS
					</td>
				</tr>
				<tr align="center" >
					<td align="center" class="detalle_formulario" >
					<p><%=mes%></p>
					</td>
					<td class="detalle_formulario">
						<%=oficinaM%>
					</td>
					<td class="detalle_formulario" >
						<%=fecha_desde%>
					</td>
					<td class="detalle_formulario" >
						<%=fecha_hasta%>
					</td>
					<td class="detalle_formulario">
						<%=f0%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table border="1" align="center" width="100%">
				<tr>
					<td class="etiqueta_formulario" align="center">PROVEEDOR</td>
					<td class="etiqueta_formulario" align="center">INDICADOR</td>
					<!-- td class="etiqueta_formulario">MEDICIÓN</td -->
					<td class="etiqueta_formulario" align="center">META</td>
					<td class="etiqueta_formulario" align="center">RESULTADO</td>
					<td class="etiqueta_formulario" align="center">CALIFICACIÓN</td>	
				</tr>
<%
if(presentar.equals("S"))
{
	meta_ind = sC.metaIndicadores(oficina,fecha_desde, fecha_hasta);
	listProveed = sC.proveedorIndicador(sociedad,proveedor);
	int j =listProveed.size();
for (int i = 0; i < j ; i++)
	{
 		System.out.println("INDICADOR DEL PROVEEDOR: "+listProveed.get(i));
 		listIndicadores = null;
 		System.out.println("llama a Lista de indicadores");
 		listIndicadores = sC.obtieneIndicadoresv2(listProveed.get(i), fecha_desde, fecha_hasta, sociedad);
 		colors="detalle_formulario_i";
		if(color%2==0){
		colors="detalle_formulario";
		}
		color++;
		//System.out.println("Comienza <tr> <td> etc :"+listIndicadores.get(0)+" "+listIndicadores.get(1)+" "+listIndicadores.get(2));			

		%>
			<tr>
				<td class="<%=colors%>" rowspan="3"  align="center"><%=listProveed.get(i)%></td>
				<td class="<%=colors%>">Cumplimiento Mensual de la Proveeduría</td>
				<td class="<%=colors%>" align="center"><%=meta_ind%> %</td>
				<td class="<%=colors%>" align="center"><%=listIndicadores.get(0)%> %</td>
				<td class="<%=colors%>" align="center">
				<%
				if(Float.parseFloat(listIndicadores.get(0).replaceAll(",", "."))>Float.parseFloat(meta_ind)){%>
				SATISFACTORIO
				<%}else{%>
					<p class="titulo">INCUMPLIMIENTO</p>
				<%}%>
				</td>
			</tr>
			<tr>
				<td class="<%=colors%>">Cumplimiento al Cronograma Establecido</td>
				<td class="<%=colors%>" align="center"><%=meta_ind%> %</td>
				<td class="<%=colors%>" align="center"><%=listIndicadores.get(1)%> %</td>
				<td class="<%=colors%>" align="center">
				<%
				if(Float.parseFloat(listIndicadores.get(1).replaceAll(",", "."))>Float.parseFloat(meta_ind)){%>
					SATISFACTORIO
				<%}else{%>
					<p class="titulo">INCUMPLIMIENTO</p>
				<%}%>
				</td>
			</tr>
			<tr>
				<td class="<%=colors%>">Cumplimiento en el  despacho de la Proveeduría</td>
				<td class="<%=colors%>" align="center"><%=meta_ind%> %</td>
				<td class="<%=colors%>" align="center"><%=listIndicadores.get(2)%> %</td>
				<td class="<%=colors%>" align="center">
				<%
				//System.out.println("indicador3 :"+listIndicadores.get(2));			
				if(Float.parseFloat(listIndicadores.get(2).replaceAll(",", "."))>Float.parseFloat(meta_ind)){%>
				SATISFACTORIO
				<%}else{
				%>
					<p class="titulo">INCUMPLIMIENTO</p>
				<%}%>
				</td>
			</tr>
<%		}
 }
 %>
			</table>
		</td>
	</tr>
</table>	
</body>
	<%sC.cerrarSesionBD();%>
</html>