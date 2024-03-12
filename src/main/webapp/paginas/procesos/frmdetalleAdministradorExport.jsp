<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.util.List"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	//Operacion op = new Operacion(pContext);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	sA.mergeProveeduria();
	
	String proveedor = request.getParameter("pProveedor");
	String solicitud = request.getParameter("pSolicitud");
	String usuario = request.getParameter("pUsuario");
	String ubicacion = request.getParameter("pUbicacion");
	String articulo = request.getParameter("pArticulo");
	String imprimir = request.getParameter("pImprimir");
	int border=0;
	int contGeneral=0;
	int i=0;
	double sumTotal = 0.0;
	 
	usuario = usuario.replaceAll("~"," ");
	ubicacion = ubicacion.replaceAll("~"," ");
	articulo = articulo.replaceAll("~"," ");
	 
	String estadoDT = request.getParameter("pEstadoDT");
	String estadoDP = request.getParameter("pEstadoDP");
	String estadoR = request.getParameter("pEstadoR");
	String estadoND = request.getParameter("pEstadoND");
	//String estadoDE = request.getParameter("pEstadoDE");

	String fecha_desde = request.getParameter("pFechaDesde");
	String fecha_hasta = request.getParameter("pFechaHasta");
	String presentar = "";
	try{
		presentar = request.getParameter("pPresentar");
		System.out.println("presentar : "+presentar);
		if(presentar==null){
			presentar = "N";
		}
	}catch(Exception e){
		presentar = "";
	}
	if (proveedor.equals("proveedor")){
		proveedor="";
		estadoR="'5','6','7'";
	}
	
	System.out.println("Datos JZU: "+proveedor+" | "+solicitud
						+ " | "+usuario+" | "+ubicacion+" | "+articulo
						+ " | "+fecha_desde+" | "+fecha_hasta+"|"+estadoDT+"|"+estadoDP+"|"+estadoR+"|"+estadoND+"|"+estadoND+"|");
						
  
	ResultSet detalle = null;
	
	if(imprimir.equals("S")){
		String nombre = "Detalle_solicitudes.xls";
		response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");	
		border=1;
	}
	
	

	List<String[]> bandejaAdmin = sA.consultaDetalleAdministrador(nombreSociedad,proveedor,solicitud,usuario,
			ubicacion,articulo,fecha_desde,fecha_hasta,estadoDT,estadoDP,estadoR,estadoND,false);
	
	int CantBandejaAdmin=bandejaAdmin.size();
	System.out.println("CantBandejaAdmin: "+CantBandejaAdmin);
	
 %>

 
 <script type="text/javascript">
	$(document).ready(function(){
		inicializar();
		$("#myTable").tablesorter({dateFormat: "uk"}); 
	});
	
	function cambiaEstadoCombo(y, idx){
		var valor = document.getElementById(y+idx).value;
		if(valor=="10"){
			document.getElementById("txtObservacion"+idx).value ="Obs:Despacho Denegado";
			document.getElementById("txtObservacion"+idx).style.display='inline';
			document.getElementById("txtObservacion"+idx).focus();
		}else{
			document.getElementById("txtObservacion"+idx).value="";
			document.getElementById("txtObservacion"+idx).style.display='none';
		}
				
	}
	
	function inicializar(){
		var detOrden = document.frmDetAdministrador.elements.length;
		for (i = 0; i < detOrden; i++){
			if (document.frmDetAdministrador.elements[i].name.indexOf("txtObservacion")>=0)
				document.frmDetAdministrador.elements[i].style.display='none';
		}
	}
	
	function myEventFunction(event,z,idx){
		var x = event.which || event.keyCode;
		//var y = String.fromCharCode(x);      // Convert the value into a character
	    var dato ="";	    
	    if (x==38){
	    	idx=idx*1-1;
	    	dato = z.name+idx;
	    	document.getElementById(dato).focus();
	    }
		if (x==40){
			idx=idx*1+1;
			dato = z.name+idx;
			document.getElementById(dato).focus();
	    }
	}	
	
</script>
 
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle de solicitud</title>

<style type="text/css">

	.titulo{
		font-family:"Arial, Verdana";
		font-size:12pt;
		font-weight:bold;
		color:#C81414;
	}
	.etiqueta_formulario2:hover{
		background-color:#FF0000;
	}
	.etiqueta_formulario2{
		cursor: pointer;
		font-family:"Arial, Verdana";
		font-size:12px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
	.detalle_formulario{
		font-family:"Arial, Verdana";
		font-size:13px;
		background-color:#CCCCCC;
		color:#000000;
	}
	.etiqueta_formulario{
		font-family:"Arial, Verdana";
		font-size:12px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}



</style>
</head>

<body>
	<form name="frmDetAdministrador" >
		<table border="<%=border%>" id="myTable" width="1900px" class="tablesorter" >
			<thead>
			<tr align="center">
					<th class="etiqueta_formulario2">Proveedor</th>
					<th class="etiqueta_formulario2">No. solicitud</th>
					<th class="etiqueta_formulario2">Usuario</th>
					<th class="etiqueta_formulario2" >Nombre ubicación</th>
					<th class="etiqueta_formulario2">Artículo</th>
					<th class="etiqueta_formulario2" width="1px">Costo Unitario</th>
					<th class="etiqueta_formulario2" width="1px">Q Solicitada</th>
					<th class="etiqueta_formulario2" width="30px">Fecha Despacho</th>
					<th class="etiqueta_formulario2" width="1px">Q Despachada</th>
					<th class="etiqueta_formulario2" width="1px">Fecha de Recepción</th>
					<th class="etiqueta_formulario2" width="1px">Q Recibida</th>
					<th class="etiqueta_formulario2" width="70px">Costo Total</th>
					<th class="etiqueta_formulario2" width="1px">Estatus</th>
					<th class="etiqueta_formulario2" width="1px">Confirmar Recepción</th>
					<th class="etiqueta_formulario2" width="1px">Cancelar Posición</th>
					<th class="etiqueta_formulario2" width="70px">Observacion</th>
				</tr>
			</thead>
			<tbody>
<% if(presentar.equals("S")){
 
if(CantBandejaAdmin != 0){
     i = 1 ;
     int idx = 1;
	    	for(String[] detalleBandeja : bandejaAdmin){
 	
				 try{
				 contGeneral++;
				 sumTotal = sumTotal + Double.parseDouble(detalleBandeja[11].replace(",", "."));
				 System.out.println("Suma Total: "+sumTotal);
					
				 }catch(Exception e){
					 System.out.println(e.getMessage());
				 	 sumTotal = 0.0;
				 }
			 String disable = "";
			 
			 if(detalleBandeja[13].equals("6")||detalleBandeja[13].equals("5")||detalleBandeja[13].equals("7")||detalleBandeja[13].equals("11")||detalleBandeja[13].equals("10")){				 
			 	disable = "disabled=\"disabled\"";
			 }
				 %>
				<tr>
					<td class="detalle_formulario"><%=detalleBandeja[0]%></td>
					<td class="detalle_formulario"><%=detalleBandeja[2]%>
					<td class="detalle_formulario"><%=detalleBandeja[4]%></td>
					<td class="detalle_formulario"><%=detalleBandeja[5]%></td>
					<td class="detalle_formulario"><%=detalleBandeja[6]%></td>
					<td class="detalle_formulario" align="right"><%=detalleBandeja[7]%></td>
					<td class="detalle_formulario" align="center"><%=detalleBandeja[8]%></td>
					<td class="detalle_formulario" align="center"> <%=(detalleBandeja[10]==null)?"":detalleBandeja[10]%></td>
					<td class="detalle_formulario" align="center"><%=detalleBandeja[9]%></td>
					<td class="detalle_formulario" align="center"><%=detalleBandeja[15]%></td>
					<td class="detalle_formulario" align="center"><%=detalleBandeja[14]%></td>
					<td class="detalle_formulario" align="right"><%=detalleBandeja[11]%></td>
					<td class="detalle_formulario" align="center"><%=detalleBandeja[12]%></td>
				</tr>
				<%
				i++;
				idx ++;
				}
	    	System.out.println("Termina For");
			%>
			</tbody>
			<tfoot >
				<tr>
					<td colspan="11" align="center" class="etiqueta_formulario" >Sumatoria Total:</td>
					<td colspan="1" align="right" class="detalle_formulario" ><b><%out.println(String.format("%.02f",sumTotal).replace(".", ","));%></b></td>
					<td colspan="4" align="center" class="detalle_formulario" ></td>
				</tr>
			</tfoot>
		</table>
		<%}else{%>
		<table align="center" width="100%" cellpadding="1" cellspacing="0" >
			<tr>
				<td class="titulo" align="center">No existen datos a presentar</td>
			</tr>
		</table>
		<%}}	System.out.println("Termina todo");
		%>
</form>	
<%sA.cerrarSesionBD();%>	
</body>
</html>