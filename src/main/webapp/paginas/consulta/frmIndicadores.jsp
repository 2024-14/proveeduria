<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
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
	String boton=" type=\"hidden\" ";
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Modulo del Administrador</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
<script type="text/javascript" src="../../js/jquery.tablesorter.js"></script>

<style type="text/css">
	#consulta, #detalle_consulta, #subdetalle{
		border: 1px solid #C81414;
		margin: 10px;
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

	#detalle_indicadores1{
		overflow: auto;
		max-height: 200px;
	}
	#detalle_indicadores2{
		overflow: auto;
		max-height: 200px;
	}
	#detalle_indicadores3{
		overflow: auto;
		max-height: 200px;
	}
	#detalle_indicadoresx{
		min-height: 100px;
		border: 1px solid #C81414;
		margin-left: auto;
	   	margin-right: auto;
	   	width: 50%;
	}
	#detalle_indicadores1x{
		border: 1px solid #C81414;
		margin-left: auto;
	   	margin-right: auto;
	   	width: 90%;
		min-height: 100px;
	}
	#detalle_indicadores2x{
		border: 1px solid #C81414;
		margin-left: auto;
	   	margin-right: auto;
	   	width: 90%;
		min-height: 100px;
	}
	#detalle_indicadores3x{
		border: 1px solid #C81414;
		margin-left: auto;
	   	margin-right: auto;
	   	width: 90%;
		min-height: 100px;
	}
	.titulo_tabla1 {
		margin:2px;
		font-family:"Arial, Verdana";
		font-size:12pt;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}	.titulo_tabla1:hover {
		background-color:#FF0000;
		cursor: pointer;
	}
	.etiqueta_formulario_1 {
		margin:2px;
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
	$(document).ready(function(){
		$('#fecha_desde').datepicker({ dateFormat: 'dd/mm/yy' }).val();
		$('#fecha_hasta').datepicker({ dateFormat: 'dd/mm/yy' }).val();
		
		$('#consultar').click(function(){
			cargar_detalle_indicadores('S','../consulta/frmdetalleIndicadores.jsp','N');
			cargar_reporte_indicadores('S','../consulta/frmdetalleIndicadoresReporte.jsp','N','N');
		});	
		$('#exportar').click(function(){
			cargar_detalle_indicadores('S','../consulta/frmdetalleIndicadores.jsp','S');
		});
		$('#exportar1').click(function(){
			cargar_reporte_indicadores('S','../consulta/frmdetalleIndicadoresReporte.jsp','S','1');
		});
		$('#exportar2').click(function(){
			cargar_reporte_indicadores('S','../consulta/frmdetalleIndicadoresReporte.jsp','S','2');
		});
		$('#exportar3').click(function(){
			cargar_reporte_indicadores('S','../consulta/frmdetalleIndicadoresReporte.jsp','S','3');
		});
		//cargar_detalle_indicadores('N','../consulta/frmdetalleIndicadores.jsp','N');	
		$('.titulo_tabla1').click(function(){
			 $("#desplegable").toggle(100);
		});
	});
	
	function mayuscula(campo){
		campo.value=campo.value.toUpperCase();
	} 
	 
	function cargar_detalle_indicadores(presentar,url,imprimir){
		
		$('#detalle_indicadores').load("../procesos/loadDetalleAdministrador.jsp");
		
		
		var proveedor = "";
		<% boton=" type=\"button\" ";%>
		var rol = "<%=request.getSession().getAttribute("PS_ROL").toString()%>";
		if(rol=='P'){
			proveedor="<%=request.getSession().getAttribute("USUARIO").toString()%>";
		}else{
		    proveedor = document.getElementById("cmbProveedor").value;
		}
		var oficina = document.getElementById("cmbOficina").value;
		oficina = oficina.replace(/ /gi,"~");
		var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
		var ruta = url+"?pProveedor="+proveedor+"&pFechaDesde="+fecha_desde+
				"&pFechaHasta="+fecha_hasta+"&pPresentar="+presentar+"&pOficina="+oficina+
				"&pImprimir="+imprimir;
		//alert(ruta);
		$('#detalle_indicadores').load(ruta);
		
		if(imprimir=="S"){
			window.open(ruta, "_self");
		}
		 $("#desplegable").toggle(100);
		 $("#desplegable2").show(100);
				
	}
	
	
	function cargar_reporte_indicadores(presentar,url,imprimir,repNum){
		
		$('#detalle_indicadores1').load("../procesos/loadDetalleAdministrador.jsp");
		$('#detalle_indicadores2').load("../procesos/loadDetalleAdministrador.jsp");
		$('#detalle_indicadores3').load("../procesos/loadDetalleAdministrador.jsp");
			
		var proveedor = "";
		//alert(repNum);
		
		var rol = "<%=request.getSession().getAttribute("PS_ROL").toString()%>";
		if(rol=='P'){
			proveedor="<%=request.getSession().getAttribute("USUARIO").toString()%>";
		}else{
		    proveedor = document.getElementById("cmbProveedor").value;
		}
		
		
		var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
		//System.out.println("frmIndicadores :: Proveedor : "+proveedor+" FechaInicio : "+fechaDesde+" FechaFin : "+fechaHasta);
				
		if (repNum == 1 || repNum == 'N'){ 
			//alert("entra en 1");
			var ruta1 = url+"?pProveedor="+proveedor+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+
			fecha_hasta+"&pPresentar="+presentar+"&pImprimir="+imprimir+"&pTipoInd=1";
			//alert(ruta1);
			$('#detalle_indicadores1').load(ruta1);
			if(imprimir=="S"){
				window.open(ruta1, "_self");
			}
		}
		if(repNum == 2 || repNum == 'N'){
			//alert("entra en 2");
			var ruta2 = url+"?pProveedor="+proveedor+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+
			fecha_hasta+"&pPresentar="+presentar+"&pImprimir="+imprimir+"&pTipoInd=2";
			//alert(ruta2);
			$('#detalle_indicadores2').load(ruta2);
			if(imprimir=="S"){
				window.open(ruta2, "_self");
			}
		}
		 if(repNum == 3 || repNum == 'N') {
			//alert("entra en 3");
			var ruta3 = url+"?pProveedor="+proveedor+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+
			fecha_hasta+"&pPresentar="+presentar+"&pImprimir="+imprimir+"&pTipoInd=3";
			//alert(ruta3);
			$('#detalle_indicadores3').load(ruta3);
			if(imprimir=="S"){
				window.open(ruta3, "_self");
			}
		}
	}	
	
</script>
</head>

<body>
  <form name="frmDetOrden">
	<div class="titulo_tabla">Indicadores de Servicio</div>
	<div class="titulo_tabla1">Criterios de Consulta</div>
	<div id="desplegable">
	
	<table>
	<%if(!request.getSession().getAttribute("PS_ROL").toString().equals("P")){ %>
		<tr>
			<td class="etiqueta_formulario">Proveedor :</td>
			<td class="detalle_formulario">
				<select id="cmbProveedor"  style="width: 100%;" name="cmbProveedor">
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
		<%} %>
		<tr>
			<td class="etiqueta_formulario">Oficina :</td>
			<td class="detalle_formulario">
				<select id="cmbOficina"  style="width: 100%;" name="cmbOficina">
		           <%
					List<String[]> loficina = sA.consultaOficinaMetaIndicador(sociedad);
					for(String[] loficina_u : loficina){
					%>	
					<option value="<%=loficina_u[0]%>" selected="selected"><%=loficina_u[0]%></option>
					<%}%> 				
				</select>
			</td>
		</tr>
	    <tr>
			<td  class="etiqueta_formulario">Fecha Desde:</td>
			<td  class="detalle_formulario"><input  type="text" id="fecha_desde" name="fecha_desde" value="<%=sA.fechaInicio()%>" size="24"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Fecha Hasta:</td>
			<td class="detalle_formulario"><input type="text" id="fecha_hasta" name="fecha_hasta" value="<%=sA.fechaFin2()%>" size="24"></td>
		</tr>
		<tr>
			<td colspan="6" align="center">
				<input type="button" value="Consultar" id="consultar" name="consultar">
				<input type="button" value=" Imprimir " id="imprimir" name="imprimir" onclick="window.print()">
			</td>
		</tr>
	</table>
	</div>
	<div class="etiqueta_formulario_1" >Detalle de Indicadores</div>
	<div id="desplegable2" style="display:none;">
	
	<div id="detalle_indicadoresx" align="center" >
	<table  border="1" align="center" width="100%">
			<tr>
				<td align="center" class="etiqueta_formulario" colspan="10">
					Reporte de Indicadores de Servicio
				</td>
			</tr>
		</table>
		<div id="detalle_indicadores" align="center" ></div>
	</div>
	 <table border="0" align="center" height="1" width="100%">
		<tr>
			<td align="center" >
				<input type="button" value="    Exportar   " id="exportar" name="Imprimir">
			</td>
		</tr>
	</table>
	
	<div id="detalle_indicadores1x" align="center" >
	 	<table  border="1" align="center" width="100%">
			<tr>
				<td align="center" class="etiqueta_formulario" colspan="10">
					Cumplimiento Mensual de la Proveeduria
				</td>
			</tr>
		</table>
	<div id="detalle_indicadores1" align="center" ></div>
	</div>
	
	
		<table border="0" align="center" height="1" width="100%">
			<tr>
				<td align="center" >
					<input type="button" value="    Exportar   " id="exportar1" name="Imprimir">
				</td>
			</tr>
		</table>
	
	<div id="detalle_indicadores2x" align="center" >
		<table border="1" align="center" width="100%">
					<tr>
				<td align="center" class="etiqueta_formulario" colspan="10">
					Cumplimiento al Cronograma Establecido
				</td>
			</tr>
		</table>
	<div id="detalle_indicadores2" align="center" ></div>
	</div>
	
		 <table border="0" align="center" height="1" width="100%">
			<tr>
				<td align="center" >
					<input type="button" value="    Exportar   " id="exportar2" name="Imprimir">
				</td>
			</tr>
		</table>
		
	<div id="detalle_indicadores3x" align="center" >
	<table border="1" align="center" width="100%">
		<tr>
			<td align="center" class="etiqueta_formulario" colspan="10">
				Cumplimiento en el despacho de la Proveeduria
			</td>
		</tr>	
	</table>
	<div id="detalle_indicadores3" align="center" ></div>
	</div>
	
	<table border="0" align="center" height="1" width="100%">
		<tr>
			<td align="center" >
				<input <%=boton%> value="    Exportar   " id="exportar3" name="Imprimir">
			</td>
		</tr>
	</table>
	</div>
  </form>
</body>
<%sA.cerrarSesionBD();%>
</html>