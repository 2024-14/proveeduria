<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion" %>
<%@ page import="com.conexion.ServiciosAdministrador"  %>

<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    Operacion op = new Operacion(pageContext); 
	ServiciosAdministrador sA = new  ServiciosAdministrador(pageContext);

	String lsUsuario;
	lsUsuario = request.getSession().getAttribute("USUARIO").toString();
	sA.mergeProveeduria();

%> 
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:lang="es" lang="es">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<link href="../../css/estilo.css" rel="stylesheet"></link>
		<script type="text/javascript" src="../../js/jquery.tablesorter.js"></script>
		<title>M&oacute;dulo&nbsp;de&nbsp;Proveedor</title>
		
		<script type="text/javascript">
		$(function(){
			$('#detalleMainProveedor').css({ maxHeight: ($(window).innerHeight())-90});
			$(window).resize(function(){
			  $('#detalleMainProveedor').css({ maxHeight: $(window).innerHeight()-90 });
			});
		});
		
		
		$(document).ready(function(){
			cargar_detalle();
			$("#myTable").tablesorter({dateFormat: "uk"});
		});
		
		function cargar_detalle(){
			$('#detalleMainProveedor').load("../protegido/detalleMainProveedor.jsp");
		}
			function cargar(index){
				//var setId = "";
				var solicitud = "";
				var i=0;
				var length = document.frmProv.elements.length;
				for (i=0; i < length; i++ ){
					if (document.frmProv.elements[i].name=="txtSolicitud"+index){
						solicitud = document.frmProv.elements[i].value;}
				}
				var url = "frmDespacho.jsp?pSolicitud="+solicitud;
				//var url = "despacho.jsp?pSolicitud="+solicitud;
					window.open(url, "_miTarget","resizable=yes, width="+screen.width+" , height=600 menubar=no,toolbar=no,status=yes");
				//window.open(url, "_new","");
			}

			function verificaLogin(atributo){
				alert("verifica login: "+atributo);
			
				if (atributo == "false"){
					alert("Debe ingresar con su usuario");
					window.open("../login/frmLogin.html", "_self");
				}
			}
			function refrescar()
			{
				location.reload(true);				
			}
		</script>
		
	<style type="text/css">
	#consulta, #detalle_solicitudes, #subdetalle{
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
	#detalleMainProveedor{
		overflow: scroll;
		border: 1px solid #C81414;
		margin: 10px;
	}
	
	.etiqueta_formulario_1{
		font-family:"Arial, Verdana";
		font-size:20px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
	.etiqueta_formulario2{
		cursor: pointer;
		font-family:"Arial, Verdana";
		font-size:12px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
	img {
		cursor: pointer;
	}
</style>
	</head>
	<body>
		 <form name="frmMainProveedor"> 
			<div id="detalle_solicitudes" class="etiqueta_formulario_1" align="left">Bandeja de Trabajo - Proveedor</div>
			<div  id="detalleMainProveedor"></div>
		 </form>
	</body> 
			 <%sA.cerrarSesionBD();%>	
</html>