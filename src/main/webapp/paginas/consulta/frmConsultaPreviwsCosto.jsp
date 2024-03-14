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
	System.out.println(session.getAttribute("NOMBREUSUARIO"));
	String lsUsuario = request.getSession().getAttribute("USUARIO").toString();
	String rol = request.getSession().getAttribute("PS_ROL").toString();
	String disable = "";
	String sociedad =request.getSession().getAttribute("PS_SOCIEDAD").toString();
	sA.mergeProveeduria();
	
	if (rol.equals("P")){
		disable = "disabled=\"disabled\""; 
	}
	
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Consulta PreFactura</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
<style type="text/css">
	#consulta, #detalle_consulta, #subdetalle{
		border: 1px solid #C81414;
		margin: 2px;
	}
	#menu{
		border: 1px solid #C81414;
		margin: 10px;
		background-color:#CCCCCC;
		color:#000000
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
		height: auto;
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
//overflow: scroll;
	$(document).ready(function(){
		$('#fecha_desde').datepicker({ dateFormat: 'dd/mm/yy' }).val();
		$('#fecha_hasta').datepicker({ dateFormat: 'dd/mm/yy' }).val();

		$('#consultar').click(function(){
			cargarConsulta('N');
		});
		$('#exportar').click(function(){
			cargarConsulta('S');
		});
		$('#exportarPdf').click(function(){
			cargarConsultaPdf('P');
		});
		$('.titulo_tabla1').click(function(){
			 $("#desplegable").toggle(100);
		});
		//cargarConsulta();
	});
	
	function cargarConsulta(presentar){
		
		var proveedor =  document.getElementById("cmbProveedor").value;
  		var estado1 = document.getElementById("estado");
        var estado = "";
                 
      	  for(i=0;i<estado1.length;i++){  
        	 if(estado1[i].selected == true){  
           		   estado=estado+"&pEstado="+estado1[i].value;  
        	  }  
     	   }  
      	var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
		var url = "../procesos/popAdministrador/frmPreviewsCosto.jsp?pProveedor="+proveedor
				+"&pImprimir="+presentar+estado+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta;
		//alert("MCA inla ruta es: "+url); 
		$('#detalle_solicitudes').load(url);
		
		
		if(presentar=="S"){
			window.open(url, "_self");
		}
		 $("#desplegable").toggle(100);
			
	}
	
	
	function cargarConsultaPdf(presentar){
		var proveedor =  document.getElementById("cmbProveedor").value;
  		var estado1 = document.getElementById("estado");
        var estado = "";
      	for(i=0; i<estado1.length; i++){  
        	if(estado1[i].selected == true){  
           	   estado=estado+"&pEstado="+estado1[i].value;  
        	 }  
     	   }  
    	var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
		var url = "../procesos/popAdministrador/frmPreviewsCosto.jsp?pProveedor="+proveedor+"&pImprimir="+presentar+estado+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta;
		$('#detalle_solicitudes').load(url, function() {
											abrirVentana("../procesos/popAdministrador/showpdf.html");
										}
		);
		
		<% sA.borra_archivo("/paginas/Pdf/previewcosto.pdf"); %>
 		/*if(presentar=="P"){
 			window.open(url, "_self");
 		}*/
		 $("#desplegable").toggle(100);
			
	}
	
	function abrirVentana(url) {
		window.open(url, "PDF", "directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no, width=800, height=800");
		}
	
	
	function cambiaSociedad(){
			var proveedorNew = document.frmConsultaPreFactura.cmbProveedor.value;
		}
	
</script>

</head>

<body>
	<form name="frmConsultaPreFactura">
	<div class="titulo_tabla">Preview de Costos</div>
	<div class="titulo_tabla1">Criterios de Consulta</div>
	<div id="desplegable">
	
<table>
  	<tr>
		<td class="etiqueta_formulario" >Proveedor</td>
		
		<td class="detalle_formulario" >
		<select style="width: 100%;" id="cmbProveedor"  name="cmbProveedor" <%=disable%>  onchange="javascript:cambiaSociedad();">
			<%if( disable.equals("")){ 
				List<String[]> lproveedor = sA.consultaProveedor(sociedad);
				for(String[] proveedor_u : lproveedor){
				%>	
				<option value="<%=proveedor_u[0]%>" selected="selected"><%=proveedor_u[0]%></option>
				<%}%> 
			<option value="todos" selected="selected">Todos</option>
		  <%}else{%>
				<option value="<%=lsUsuario%>"><%=lsUsuario%></option> 
			<%}%>
		</select>
		</td>
	</tr>
	<tr>
		<td class="etiqueta_formulario" >Estatus </td>
		<td class="detalle_formulario" >
		<select id="estado" name="estados" style="width: 100%;">
			<option id="estadoDT" value="'2','3','4'" selected="selected">Todos</option>
			<option id="estadoDT" value="'4'" >Desapachado Total</option>
			<option id="estadoDP" value="'3'" >Desapachado Parcial</option>
			<option id="estadoND" value="'2'" >No Desapachado</option>
		</select>
		</td>
	</tr> 
	<tr>
		<td  class="etiqueta_formulario">Fecha Desde:</td>
		<td  class="detalle_formulario"><input  type="text" id="fecha_desde" name="fecha_desde" value="<%=sA.fechaInicio()%>" size="24"></td>
	</tr>
	<tr>
		<td class="etiqueta_formulario">Fecha Hasta:</td>
		<td class="detalle_formulario"><input type="text" id="fecha_hasta" name="fecha_hasta" value="<%=sA.fechaFin()%>" size="24"></td>
	</tr>
	<tr>
			<td colspan="2" align="center"><input type="button" value="Consultar" id="consultar" name="consultar"></td>
	</tr>
  </table>
  </div>
 	<div id="subdetalle">
			<div class="etiqueta_formulario_1" >Detalles Previews de Costo</div>
			<div id="detalle_solicitudes" align="center" ></div>
		</div>

		
	<table align="center" width="100%">
		<tr>
			<td align="right" ><input type="button" id="exportar" name="exportar" value="     Exportar    "></td>
	   		<td align="center" ><input type="button" id="exportarPdf" name="exportarPdf" value="ExportarPdf"></td>
	   		<td align="left" ><input type="button" value="    Imprimir    " id="imprimir" name="imprimir" onclick="window.print()"></td>
	   </tr>
		</table>
		
		</form>
	</body>
		<%sA.cerrarSesionBD();%>
</html>