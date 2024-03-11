<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ page import="com.conexion.ServiciosAdministrador"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServiciosAdministrador sA = new ServiciosAdministrador(pContext); 
	String sociedad =request.getSession().getAttribute("PS_SOCIEDAD").toString(); 
	sA.mergeProveeduria();
	
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Modulo del Administrador</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<script type="text/javascript" src="../../js/jquery.tablesorter.js"></script>

<style type="text/css">
	#consulta, #detalle_consulta, #subdetalle{
		border: 1px solid #C81414;
		margin: 2px;
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
	#detalle_solicitudes{
		overflow: auto;
	}
	.titulo_tabla1 {
		margin:2px;
		font-family:"Arial, Verdana";
		font-size:12pt;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
	.titulo_tabla1:hover {
		background-color:#FF0000;
		cursor: pointer;
	}
	.titulo_tabla{
		margin:2px;
		font-family:"Arial, Verdana";
		font-size:14pt;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
</style>

<script type="text/javascript">
	var despleg=0;
	
	$(function(){
		  $('#detalle_solicitudes').css({ maxHeight: ($(window).innerHeight())-145});
		  $(window).resize(function(){
		    $('#detalle_solicitudes').css({ maxHeight: $(window).innerHeight()-145 });
		  });
	});
	$(document).ready(function(){
		$('#fecha_desde').datepicker({ dateFormat: 'dd/mm/yy' }).val();
		$('#fecha_hasta').datepicker({ dateFormat: 'dd/mm/yy' }).val();
		$('#consultar').click(function(){
			cargar_detalle_solicitudes('S','../consulta/frmdetalleConsulta.jsp','N');
			 if(despleg == 1){
				 despleg=0;
				 $('#detalle_solicitudes').css({ maxHeight: $(window).innerHeight()-145 });
			 }
		});	
		$('#exportar').click(function(){
			cargar_detalle_solicitudes('S','../consulta/frmdetalleConsulta.jsp','S');
		});	
		$('.titulo_tabla1').click(function(){
			 $("#desplegable").toggle(100);
			 if(despleg == 0){
				 despleg=1;
				 $('#detalle_solicitudes').css({ maxHeight: $(window).innerHeight()-315 });
			 }else{
				 despleg=0;
				    $('#detalle_solicitudes').css({ maxHeight: $(window).innerHeight()-145 });
			 }
		});
	});
	
	function mayuscula(campo){
		campo.value=campo.value.toUpperCase();
	} 
	
	function cargar_detalle_solicitudes(presentar,url,imprimir){
		$('#detalle_solicitudes').load("../procesos/loadDetalleAdministrador.jsp");

		var proveedor = "";
		var solicitud = "";
		var usuario = "";
		var area = "";
		var ceco = "";
		var rol = "<%=request.getSession().getAttribute("PS_ROL").toString()%>";
		if(rol=='P'){
			proveedor="<%=request.getSession().getAttribute("USUARIO").toString()%>";
		}else{
		    proveedor = document.getElementById("cmbProveedor").value;
		    solicitud = document.getElementById("solicitud").value;
		 	usuario = document.getElementById("usuario").value;
			area = document.getElementById("area").value;
		 	ceco = document.getElementById("ceco").value;
		}
		
		
		var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
				
		var ruta = url+"?pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="
		+usuario+"&pArea="+area+"&pCeco="+ceco+"&pFechaDesde="+fecha_desde+"&pFechaHasta="
		+fecha_hasta+"&pPresentar="+presentar+"&pImprimir="+imprimir;
		$('#detalle_solicitudes').load(ruta);
		
		if(imprimir=="S"){
			window.open(ruta, "_self");
		}
		 $("#desplegable").toggle(100);
			
	}	
	
	function popup(url,ancho,alto) {
		var posicion_x; 
		var posicion_y; 
		posicion_x=(screen.width/2)-(ancho/2); 
		posicion_y=(screen.height/2)-(alto/2); 
		window.open(url, "leonpurpura.com", "width="+ancho+",height="+alto+",menubar=0,toolbar=0,directories=0,scrollbars=no,resizable=no,left="+posicion_x+",top="+posicion_y+"");
		window.focus();
	}
	
	function cambiaProveedor(){
		var proveedorNew = document.frmDetOrden.cmbProveedor.value;
	}
	
</script>
</head>

<body>
  <form name="frmDetOrden">
	<div class="titulo_tabla">Reporte General</div>
	<div class="titulo_tabla1">Criterios de Consulta</div>
	<div id="desplegable">
	<table>
	<%if(!request.getSession().getAttribute("PS_ROL").toString().equals("P")){ %>
		<tr>
			<td class="etiqueta_formulario">Proveedor :</td>
			<td class="detalle_formulario">
				<select id="cmbProveedor" style="width: 100%;"  name="cmbProveedor" onchange="javascript:cambiaProveedor();">
		          <%
					List<String[]> lproveedor = sA.consultaProveedor(sociedad);
					for(String[] proveedor_u : lproveedor){
					%>	
					<option value="<%=proveedor_u[0]%>" selected="selected"><%=proveedor_u[0]%></option>
					<%}%> 
					<option value="" selected="selected">Todos</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Área de empresa : </td>
			<td>
				<select id="area" style="width: 100%;"  name="area" >
	        		<option value="" selected="selected">Todos</option>
			 		<%
	        	    List<String[]> lareas = sA.ObtieneAreas();
					for(String[] lareas_u : lareas){
					%>	
					<option value="<%=lareas_u[0]%>" ><%=lareas_u[1]%></option>
					<%}%> 
				</select>
			</td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">No. solicitud : </td>
			<td class="detalle_formulario"><input type="text" id="solicitud" name="area" size="31"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Usuario : </td>
			<td class="detalle_formulario"><input type="text" id="usuario" name="id_usuario" size="31"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Centro de costo : </td>
			<td class="detalle_formulario"><input type="text" id="ceco" name="area" size="31"></td>
		</tr>
		<%} %>
		<tr>
			<td  class="etiqueta_formulario">Fecha Desde:</td>
			<td  class="detalle_formulario"><input  type="text" id="fecha_desde" name="fecha_desde" value="<%=sA.fechaInicio()%>" size="31"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Fecha Hasta:</td>
			<td class="detalle_formulario"><input type="text" id="fecha_hasta" name="fecha_hasta" value="<%=sA.fechaFin()%>" size="31"></td>
		</tr>
		<tr>
			<td colspan="6" align="center"><input type="button" value="Consultar" id="consultar" name="consultar"></td>
		</tr>
	</table>
	</div>
		<div id="subdetalle">
			<div class="etiqueta_formulario_1" >Detalle de Solicitudes</div>
			<div id="detalle_solicitudes"></div>
		</div>
		
	<table border="0" align="center" height="1" width="100%">
		<tr>

		<td align="center" ><input type="button" value="     Exportar      " id="exportar" name="exportar"></td>
		</tr>
	</table>

  </form>
</body>
</html>