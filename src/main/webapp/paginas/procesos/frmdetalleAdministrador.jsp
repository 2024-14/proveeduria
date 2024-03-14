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
		border=0;
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
		myFunction(idx);		
	}
	
	function inicializar(){
		var detOrden = document.frmDetAdministrador.elements.length;
		for (var i = 0; i < detOrden; i++){
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

	.txtcc{
		text-align:center;
	}

</style>
</head>

<body>
	<form name="frmDetAdministrador" >
		<table border="<%=border%>" id="myTable" width="1900px" class="tablesorter" >
			<thead>
			<tr align="center">
					<th class="etiqueta_formulario2" width="100px">Proveedor</th>
					<th class="etiqueta_formulario2" width="75px">No. solicitud</th>
					<th class="etiqueta_formulario2" width="400px">Usuario</th>
					<th class="etiqueta_formulario2" width="300px">Nombre ubicación</th>
					<th class="etiqueta_formulario2" width="400px">Artículo</th>
					<th class="etiqueta_formulario2" width="1px">Costo Unitario</th>
					<th class="etiqueta_formulario2" width="1px">Q Solicitada</th>
					<th class="etiqueta_formulario2" width="75px">Fecha Despacho</th>
					<th class="etiqueta_formulario2" width="1px">Q Despachada</th>
					<th class="etiqueta_formulario2" width="75px">Fecha de Recepción</th>
					<th class="etiqueta_formulario2" width="5px">Q Recibida</th>
					<th class="etiqueta_formulario2" width="70px">Costo Total</th>
					<th class="etiqueta_formulario2" width="1px">Estatus</th>
					<th class="etiqueta_formulario2" width="1px">Confirmar Recepción</th>
					<th class="etiqueta_formulario2" width="1px">Cancelar Posición</th>
					<th class="etiqueta_formulario2" width="200px">Observacion</th>
				</tr>
			</thead>
			<tbody>
<% if(presentar.equals("S")){
 //try{
	 
	/* 
	 
detalle = sA.consultaDetalleAdministrador(request.getSession().getAttribute("PS_SOCIEDAD").toString(),
 proveedor,solicitud,usuario,ubicacion,articulo,fecha_desde,fecha_hasta,estadoDT,estadoDP,estadoR,estadoND,false); 
 
*/

//if(detalle!=null){
if(CantBandejaAdmin != 0){
	
     i = 1 ;
     int idx = 1;
     
 	
				     
				     
		    // while(detalle.next()){ 
	    	for(String[] detalleBandeja : bandejaAdmin){
 	
				 try{
				 contGeneral++;
				 sumTotal = sumTotal + Double.parseDouble(detalleBandeja[11].replace(",", "."));
				 //System.out.println("Suma Total: "+sumTotal);
					
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
				<td class="detalle_formulario"><%=detalleBandeja[0]%><input type="hidden" name="txtProveedor" id="txtProveedor<%=idx%>" value="<%=detalleBandeja[1]%>"> </td>
				<td class="detalle_formulario"><%=detalleBandeja[2]%><input type="hidden" name="txtSolicitud" id="txtSolicitud<%=idx%>" value="<%=detalleBandeja[2]%>">
																		<input type="hidden" name="txtNlinea" id="txtNlinea<%=idx%>" value="<%=detalleBandeja[3]%>"></td>
				<td class="detalle_formulario"><%=detalleBandeja[4]%><input type="hidden" name="txtUsuario" id="txtUsuario<%=idx%>" value="<%=detalleBandeja[4]%>"></td>
				<td class="detalle_formulario"><%=detalleBandeja[5]%></td>
				<td class="detalle_formulario"><%=detalleBandeja[6]%><input type="hidden" name="txtDesArticulo" id="txtDesArticulo<%=idx%>" value="<%=detalleBandeja[6]%>"></td>
				<td class="detalle_formulario" align="right"><%=detalleBandeja[7]%></td>
				
				<td class="detalle_formulario" align="center"><%=detalleBandeja[8]%><input type="hidden" name="txtCantidadSoli" id="txtCantidadSoli<%=idx%>" value="<%=detalleBandeja[8]%>"></td>
				<td class="detalle_formulario" align="center"> <%=(detalleBandeja[10]==null)?"":detalleBandeja[10]%><input type="hidden" name="txtFechaDespacho" id="txtFechaDespacho<%=idx%>" value="<%=detalleBandeja[10]%>"></td>
				<td class="detalle_formulario" align="center"><%=detalleBandeja[9]%><input type="hidden" name="txtCantidaDesp" id="txtCantidaDesp<%=idx%>"  value="<%=detalleBandeja[9]%>"></td>
				<td class="detalle_formulario" align="center"><span style="display:none"><%=detalleBandeja[15]%></span>
					<input type="text" name="txtFechaRecepcion" id="txtFechaRecepcion<%=idx %>" <%=disable%> value="<%=(detalleBandeja[15]==null)?"":detalleBandeja[15]%>" onchange="myFunction('<%=idx%>')" onkeydown="myEventFunction(event, this,'<%=idx%>');" size="10px" class="txtcc"> </td>
				<td class="detalle_formulario" align="center"><span style="display:none"><%=detalleBandeja[14]%></span>
					<input type="text" name="txtCantReciba" id="txtCantReciba<%=idx %>" <%=disable%> value="<%=detalleBandeja[14]%>" onchange="myFunction('<%=idx%>')" onkeydown="myEventFunction(event, this,'<%=idx%>');" size="5px" class="txtcc"></td>
				<td class="detalle_formulario" align="right"><%=detalleBandeja[11]%></td>
				<td class="detalle_formulario" align="center"> <span style="display:none"><%=detalleBandeja[12]%></span>
					<select id="txtEstado<%=i%>"  name="txtEstado<%=i%>" <%=disable%> onchange="javascript:cambiaEstadoCombo('txtEstado','<%=i%>');">
						<%
						//detalleBandeja[13];
						if(detalleBandeja[13].equals("2")||detalleBandeja[13].equals("3")||detalleBandeja[13].equals("4")){ %>
							<option value="2">No Despachado</option>	<!--%=detalleBandeja[12]%-->
							<option value="3">Despachado Parcial</option>
							<option value="4">Despachado Total</option>
							<!-- <option value="11">No Recibido</option>  -->
							<!--<option value="6">Recibido Parcial</option> -->
							<!--<option value="7">Recibido Total</option> -->
							<option value="10">Despachado Denegado</option>
						<% }else{%>
							<option value="<%=detalleBandeja[13]%>"><%=detalleBandeja[12]%></option>
						<%} %>
					</select>
					<script type="text/javascript">
						<%//String estado = detalleBandeja[13];
							if(detalleBandeja[13].equals("2")||detalleBandeja[13].equals("3")||detalleBandeja[13].equals("4")){ 
							//System.out.println("Estado"+detalleBandeja[13]);
							%>
								document.frmDetAdministrador.txtEstado<%=i%>.value = "<%=detalleBandeja[13].trim()%>";
								//document.frmDetAdministrador.txtEstado. = 
						<%}%>	
					</script> 
				</td>
				<!--input type="hidden" name="txtEstado" value="< %=detalleBandeja[13]% > "></td-->
				<td class="detalle_formulario" align="center"><input type="radio"  id="cbmConfirma<%=i%>" <%=disable%> name="cbmConfirma<%=i%>" checked="checked" onchange="myFunction('<%=idx%>')"/></td>
				<td class="detalle_formulario" align="center"><input type="radio"  id="cbmCancelarPosición<%=i%>" <%=disable%> name="cbmConfirma<%=i%>"  onchange="myFunction('<%=idx%>')"/></td>
				<td class="detalle_formulario" align="center"><input type="text"  id="txtObservacion<%=i%>" <%=disable%> name="txtObservacion<%=i%>"  onchange="myFunction('<%=idx%>')"/><%=(detalleBandeja[16]==null)?"":detalleBandeja[16]%></td>																																				
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
					<td colspan="4" align="center" class="detalle_formulario" >	<input type="hidden" name="txtCantidad" id="txtCantidad" value="<%=idx%>"></td>
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
</body>
<%sA.cerrarSesionBD();%>	
</html>