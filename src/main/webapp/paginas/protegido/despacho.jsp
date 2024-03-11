<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion"  %>
<%@ page errorPage="../general/errorGral.jsp" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="es">
<head>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
<script type="text/javascript" src="../../js/jquery-1.11.2.js"></script>
<script type="text/javascript" src="../../js/jquery-ui.js"></script>
<script type="text/javascript" src="../../js/jquery.tablesorter.js"></script>

<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	Operacion op = new Operacion(pContext);
	
	String lsUsuario = request.getSession().getAttribute("USUARIO").toString();
	String vendorId = lsUsuario;//op.getVendorId(lsUsuario);
	
	//String ls_validaGuia = op.getUsuarioGuiaRemision(lsUsuario);
	
	String pass = request.getSession().getAttribute("PASS").toString();
	String sociedad = request.getSession().getAttribute("SOCIEDAD").toString();
	String id_ruc = op.ConsultaRUC(lsUsuario, pass,sociedad);
	String setsolicitud = request.getParameter("pSolicitud");
	//String pedido = request.getParameter("pNroOrden");
	
	String setid= "", noOrden="", dept="", s_estado="";
	String cantidad = "";
	String guia_remision2;
	if(op!=null){
		System.out.println("OP no null");
	}
	request.getSession().setAttribute("RUTAS", "../protegido/mainProveedor.jsp");
	
	List<String[]> detalleDespacho = op.getDetPedido(setsolicitud, id_ruc,sociedad);
	int CantDetalleDespacho=detalleDespacho.size();
	System.out.println("CantDetalleDespacho: "+CantDetalleDespacho);
	
	List<String[]> hdr = op.getHdrPedido(setsolicitud, lsUsuario, sociedad);
	int CantHdr=hdr.size();
	System.out.println("CantHdr: "+CantHdr);
	
%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<link href="../../css/estilo.css" rel="stylesheet"></link>
<title>M&oacute;dulo&nbsp;de&nbsp;Proveedor</title>


<style type="text/css">

	.titulo{
		font-family:"Arial, Verdana";
		font-size:08pt;
		font-weight:bold;
		color:#C81414;
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

	#detalle_despacho0{
		border: 1px solid #C81414;
		overflow: auto;
	}


</style>


<script type="text/javascript">

	$(function(){
		$('#detalle_despacho0').css({ maxHeight: ($(window).innerHeight())-240});
		$(window).resize(function(){
		  $('#detalle_despacho0').css({ maxHeight: $(window).innerHeight()-240 });
		});
	});
	
	$(document).ready(function(){
		$('#exportar').click(function(){cargarReporte('S');	});
		$('#Guardar').click(function(){grabar();});
		$('#Cancelar').click(function(){cancelar();});
		$('#exportarpdf').click(function(){cargarPdf('S');	});
	});
	
	$(document).ready(function() {
		var data='<s:property escape="false" value="simInfos" />';
	});
	
	
	$(document).ready(function(){
		$(".datepicker").datepicker({ dateFormat: 'dd/mm/yy' }).val();
		$("#myTable").tablesorter({dateFormat: "uk"});
		
	});

	var map1;
	var mapForm;

	top.window.moveTo(0, 0);
	if (document.all) {
		top.window.resizeTo(screen.availWidth, screen.availHeight);
	} else {
		if (document.layers || document.getElementById) {
			if (top.window.outerHeight < screen.availHeight
					|| top.window.outerWidth < screen.availWidth) {
				top.window.outerHeight = screen.availHeight;
				top.window.outerWidth = screen.availWidth;
			}
		}
	}
	
	function addElement(idx, cadena){
		var mapInputGen = document.createElement("input");
		mapInputGen.type = "hidden";
		mapInputGen.name = "cadena"+idx;
		mapInputGen.value = cadena;
		//alert(idx+"|"+cadena);
		return mapInputGen;
	}
	
	function grabar() {
		document.getElementById("Guardar").value="Guardando...";
		document.getElementById("Guardar").disabled=true;
		
		var detOrden = document.frmDetOrden.elements.length;
		
		var linea = 0;
		var cadena = "";
		var i=0;
		var solicitud = "";
		var solicitante = "";
		var idx=0;
		var ruc="";
		var validaGuia="";
		var contGeneral=0;
		var estadoFinal=0;
		
		var num_linea=0;
		var material="";
		var producto = "";
		var cantPedida = 0;
		var TotDesp = 0;
		var estado = "";
		var cantDesp = 0;
		var guiaRemi = "";
		var fecha_desp2 = "";

		 //JZURITA Inicio
		 mapForm = document.createElement("form");
	     mapForm.method = "POST"; // or "post" if appropriate
	     mapForm.action = "ejecutaDespacho.jsp";
	     
	     var mapInputSol = document.createElement("input");
	     mapInputSol.type = "hidden";
	     mapInputSol.name = "pSolicitud";	     		
	     mapInputSol.value = <%=setsolicitud%>;
	     mapForm.appendChild(mapInputSol);	     
	     //JZURITA Fin
		 
	     if (ruc ==""){
			ruc = document.getElementById("hdRuc").value;
			//alert("Ruc::"+ruc);
		 }
	     if (validaGuia ==""){
	    	 validaGuia = document.getElementById("txtValidaGuia").value;
				//alert("Ruc::"+ruc);
	     }
	     
	     var mapInputRuc = document.createElement("input");
	     mapInputRuc.type = "hidden";
	     mapInputRuc.name = "pRuc";	     		
	     mapInputRuc.value = ruc;
	     mapForm.appendChild(mapInputRuc);	    
	     
		for (i = 0; i < detOrden; i++) {
			linea = 0;
			
			if (document.frmDetOrden.elements[i].name == "txtSolicitud") {
				solicitud = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtSolicitante") {
				solicitante = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtIdDet") {
				num_linea = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtProducto") {
				material = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtProductoDes") {
				producto = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtCantPed") {
				cantPedida = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtTotDesp") {
				TotDesp = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtEstado") {
				estado = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtCantDesp") {
				cantDesp = document.frmDetOrden.elements[i].value;
			}	
			if (document.frmDetOrden.elements[i].name == "txtguia_remi2") {
				guiaRemi = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtfechadesp2") {
				fecha_desp2 = document.frmDetOrden.elements[i].value;
				linea = 1;
			}

			if (linea == 1) {
				if(cantDesp!=0){
					console.log("cantDesp !=0 : "+cantDesp);
					if(fecha_desp2 == ""){	
						alert("NO puede hacer despachos si no ingresa FECHA de despacho...!!!");
						document.getElementById("Guardar").value="Guardar";
						document.getElementById("Guardar").disabled=false;
						return;
					}
					if(!validaFechaDDMMAAAA(fecha_desp2)){	
						alert("Debe ingresar una fecha Valida!");
						document.getElementById("Guardar").value="Guardar";
						document.getElementById("Guardar").disabled=false;
						return;
					}
				}
				TotDesp = parseFloat(TotDesp) + parseFloat(cantDesp);
				if (TotDesp > cantPedida) {
					alert("La cantidad despachada no debe ser mayor a la pedida");
					document.getElementById("Guardar").value="Guardar";
					document.getElementById("Guardar").disabled=false;
					return;
				}
				if( cantDesp == "0"){
					alert("No debe ingresar cantidad en cero.");
					document.getElementById("Guardar").value="Guardar";
					document.getElementById("Guardar").disabled=false;
					return;
				}
				if (validaGuia == "S" ){
					if (guiaRemi==""){
						if(cantDesp!=""){
						 	alert("Con este usuario es Obligatorio Ingresar la Guia de Remision.");
						 	document.getElementById("Guardar").value="Guardar";
							document.getElementById("Guardar").disabled=false;
							return;
						}
					}
				}
				if (cantDesp > 0) {
					contGeneral++;
					if (document.frmDetOrden.elements[i].name == "txtTotDesp"){
						document.frmDetOrden.elements[i].value = TotDesp;
					}	
					
					//Compara Cantidad pedida vs Total Despachado para sacar estado Despacho Total o Parcial
					if(cantPedida == TotDesp){
						estadoFinal=4; //Despacho Total
					}else{
						estadoFinal=3;	//Despacho Parcial
					}	
					
					cadena = solicitud+"|"+num_linea+"|"+solicitante+"|"+"<%=lsUsuario%>"+
							"|"+material+"|"+producto+"|"+cantPedida+"|"+TotDesp+"|"+
							estadoFinal+"|"+guiaRemi+"|"+fecha_desp2+"|";
					
					cadena = cadena+ruc+"|";
					if(cadena!=null){
						if(cadena!=""){
							if (solicitud!=null){
								if (cantDesp!=null){
									mapForm.appendChild(addElement(idx,cadena)); //Agrega cadena
								}
							idx = idx*1+1;
							}
						}
					}
				}
				
				linea = 0; 
				cadena= "";
				estadoFinal=0;
				
				num_linea = 0;
				material = 0;
				producto = "";
				cantPedida = 0;
				TotDesp = 0;
				estado = 0;
				cantDesp = 0;
				guiaRemi = "";
				fecha_desp2 = "";
			}
		}
		
		if( contGeneral == 0){
			alert("Debe ingresar al menos una cantidad para despachar.");
			document.getElementById("Guardar").value="Guardar";
			document.getElementById("Guardar").disabled=false;
			return;
		}
		//JZURITA Inicio		
		var mapInputTam = document.createElement("input");
	    mapInputTam.type = "hidden";
	    mapInputTam.name = "length";	     		
	    mapInputTam.value = idx;
	    mapForm.appendChild(mapInputTam);
	    //JZURITA Fin
	     
		/*var ancho = 200;
	    var alto  = 180;
		var posicion_x; 
		var posicion_y; 
		posicion_x=(screen.width/2)-(ancho/2); 
		posicion_y=(screen.height/2)-(alto/2);
		
		//map1 = window.open("", "_ejecutaD", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");
		//map1 = window.open("", "_ejecutaD");
		//map1 = window.open("", "_new", "");
		// map1 = window.open();	
		*/
		
 		document.body.appendChild(mapForm);
		map1 = window.open("","_self");
  	
		if (map1) {
    		mapForm.submit();
    	} else {
    		alert("You must allow popups for this map to work.");
    	}
    	//map1.close();
    }
	
	
	function myEventFunction(event,z,idx){
		var x = event.which || event.keyCode;
		var y = String.fromCharCode(x);      // Convert the value into a character
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
	
	
	function cancelar() {
		top.window.close();
		window.open("../protegido/menu.jsp?Pparametro=S",target="_menu");
		<%
			request.getSession().setAttribute("RUTAS", "../protegido/mainProveedor.jsp");
		%>
	}
	
	function cambiaEstado() {
		var estadoPed = document.frmDetOrden.hdnEstado.value;
		var estadoNew = document.frmDetOrden.cmbEstado.value;
		if (estadoPed == estadoNew) {
			alert("Debe seleccionar un estado diferente");
		}
	}
	function verificaLogin(atributo) {
		if (atributo == "false") {
			alert("Debe ingresar con su usuario");
			window.open("../login/frmLogin.html", "_self");
		}
	}


	
	function cargarReporte(presentar){
		var url = "reporte_despacho.jsp?pSolicitud="+"<%=setsolicitud%>";
		//$('#exportar').load(url);
		if(presentar=="S"){	
			window.open(url, "_self");		
		}
		
	}
	
	function cargarPdf(presentar){
		var url = "reporte_despacho.jsp?pSolicitud="+"<%=setsolicitud%>";
		$('#exportar').load(url);
		if(presentar=="S"){	
			window.open(url, "_self");	
		}		
	}
	
	
	
	function guiaremi()
	{
		var guia_remision;
		var detOrden = document.frmDetOrden.elements.length;
    	guia_remision = document.getElementById('txtguiaremi').value; 
    	var cantPedida = "";
    	var cantDesp = "";
    	var TotDesp = "";
    	var lbFlag = "0";
    	for (var i = 0; i < detOrden; i++)
		{
    		if (document.frmDetOrden.elements[i].name == "txtCantPed") {
				cantPedida = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtTotDesp") {
				TotDesp = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtCantDesp") {
				cantDesp = document.frmDetOrden.elements[i].value;
			}
    		if (document.frmDetOrden.elements[i].name == "txtguia_remi2") {
    			if (cantPedida==TotDesp){
    				lbFlag = "1";
    			}
    			if (cantDesp == ""){
    				lbFlag = "1";
    			}
    			if (document.frmDetOrden.guia_remi.checked == true){
    				if (lbFlag=="0"){
    					document.frmDetOrden.elements[i].value = guia_remision;
    				}
	    		}else{
	    			document.frmDetOrden.elements[i].value = "";
	    		}
    			lbFlag = "0";
    		}
    	}
    }
    
    function fechadesp()
	{
		var fechaDespacho;
		var detOrden = document.frmDetOrden.elements.length;
    	fechaDespacho = document.getElementById('txtfechadesc').value;
    	var cantPedida = "";
    	var cantDesp = "";
    	var TotDesp = "";
    	var lbFlag = "0";
    	for (var i = 0; i < detOrden; i++)
		{
    		if (document.frmDetOrden.elements[i].name == "txtCantPed") {
				cantPedida = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtTotDesp") {
				TotDesp = document.frmDetOrden.elements[i].value;
			}
			if (document.frmDetOrden.elements[i].name == "txtCantDesp") {
				cantDesp = document.frmDetOrden.elements[i].value;
			}
    		if (document.frmDetOrden.elements[i].name == "txtfechadesp2") {
    			
    			if (cantPedida==TotDesp){
    				lbFlag = "1";
    			}
    			if (cantDesp == ""){
					lbFlag = "1";
				}
    			if (document.frmDetOrden.chfechadesp.checked == true){
    				if (lbFlag=="0"){
    	    			document.frmDetOrden.elements[i].value = fechaDespacho;
    				}
    			}else{
	    			document.frmDetOrden.elements[i].value = "";
	    		}
    			lbFlag = "0";
    		}    		
    	}    
    }

    function validaFechaDDMMAAAA(fecha){
    	var dtCh= "/";
    	var minYear=1900;
    	var maxYear=2100;
    	function isInteger(s){
    		var i;
    		for (i = 0; i < s.length; i++){
    			var c = s.charAt(i);
    			if (((c < "0") || (c > "9"))) return false;
    		}
    		return true;
    	}
    	function stripCharsInBag(s, bag){
    		var i;
    		var returnString = "";
    		for (i = 0; i < s.length; i++){
    			var c = s.charAt(i);
    			if (bag.indexOf(c) == -1) returnString += c;
    		}
    		return returnString;
    	}
    	function daysInFebruary (year){
    		return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
    	}
    	function DaysArray(n) {
    		for (var i = 1; i <= n; i++) {
    			this[i] = 31;
    			if (i==4 || i==6 || i==9 || i==11) {this[i] = 30;}
    			if (i==2) {this[i] = 29;}
    		}
    		return this;
    	}
    	function isDate(dtStr){
    		var daysInMonth = DaysArray(12);
    		var pos1=dtStr.indexOf(dtCh);
    		var pos2=dtStr.indexOf(dtCh,pos1+1);
    		var strDay=dtStr.substring(0,pos1);
    		var strMonth=dtStr.substring(pos1+1,pos2);
    		var strYear=dtStr.substring(pos2+1);
    		strYr=strYear;
    		if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1);
    		if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1);
    		for (var i = 1; i <= 3; i++) {
    			if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1);
    		}
    		month=parseInt(strMonth);
    		day=parseInt(strDay);
    		year=parseInt(strYr);
    		if (pos1==-1 || pos2==-1){
    			return false;
    		}
    		if (strMonth.length<1 || month<1 || month>12){
    			return false;
    		}
    		if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
    			return false;
    		}
    		if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
    			return false;
    		}
    		if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
    			return false;
    		}
    		return true;
    	}
    	if(isDate(fecha)){
    		return true;
    	}else{
    		return false;
    	}
    }
</script>


</head>
<body onload="javascript:verificaLogin(<%=request.getSession().getAttribute("AUTH").toString()%>);">
	<form name="frmDetOrden">
		<table width="100%" border="0" align="center">
			<tr>
				<td class="titulo_tabla">Solicitud de Proveeduria</td>
			</tr>
			<tr>
				<td align="center"><img src="../../imagenes/ico-roja.gif"
					width="750"></img></td>
			</tr>
		</table>
		<table>
			<%
			String ls_validaGuia="";
			//try{
			//hdr = op.getHdrPedido(setsolicitud,lsUsuario,solcitud);
			for(String[] detalleHdr : hdr){
			 
			//if(hdr!=null){
			//if (hdr.next()) {
			ls_validaGuia=op.getUsuarioGuiaRemision(detalleHdr[5],sociedad);
			//setid = detalleHdr[0];
			//noOrden = detalleHdr[1];%>
			<tr>
				<td class="etiqueta_formulario">Set Id:</td>
				<td class="detalle_formulario"><%=op.consultaSociedad(sociedad)%>
				<div><input type="hidden" name="hdnSetId" value="<%=""%>"/>
				</div></td>
				<td class="etiqueta_formulario">Solicitante:</td>			
				<td  class="detalle_formulario">
					<%=detalleHdr[2]%>
					<input type="hidden" name="txtSolicitante" value="<%=detalleHdr[2]%>" disabled="disabled" size="15" />
				</td>
			</tr>
			<tr>
				<td class="etiqueta_formulario">Solicitud:</td>
				<td class="detalle_formulario"><%=detalleHdr[0]%>
				<input type="hidden" name="txtSolicitud" value="<%=detalleHdr[0]%>" disabled="disabled" size="15" />
				</td>
				<td class="etiqueta_formulario">Departamento:</td>
				<td class="detalle_formulario"><%=detalleHdr[4]%></td>
			</tr>
			<tr>
				<td class="etiqueta_formulario">Estado:</td>
				<td class="detalle_formulario"><%=detalleHdr[1]%>
					<input type="hidden" name="txtEstado" value="<%=detalleHdr[1]%>" disabled="disabled" size="15" />
				</td>
				<td class="etiqueta_formulario">Ubicación:</td>
				<td class="detalle_formulario"><%= detalleHdr[3]%></td>				
			</tr>
			<tr>
				<td class="etiqueta_formulario">Guia de Remision:</td>
					<td class="detalle_formulario">
						<input type="text"	name="txtguiaremi" id="txtguiaremi" value="" size="10" />
						<input type="checkbox" id="guia_remi"  name="guia_remi"  onclick="javascript:guiaremi()"/>
						<input type="hidden" name="hdRuc" id="hdRuc" value="<%=id_ruc%>" />						
					</td>
				<td class="etiqueta_formulario">Fecha de despacho:</td>
				<td class="detalle_formulario">
					<input type="text"	id="txtfechadesc" name="txtfechadesc" value="" size="10" class="datepicker"/>
					<input type="checkbox"  id="chfechadesp"  name="chfechadesp"  onclick="javascript:fechadesp()"/>
					
				</td>				
			</tr>
			<%	
			}
			%>
		</table>
		<input type="hidden" id="txtValidaGuia" name="txtValidaGuia" value="<%=ls_validaGuia%>" size="10" />
		<br />
		<div id="div2" class="etiqueta_formulario_1" >Detalle de Solicitudes</div>
		<div id="detalle_despacho0">
		<%
		if(CantDetalleDespacho != 0){
		%>
		<table width="100%" border="0" align="center" id="myTable" class="tablesorter">
			<thead>
				<tr align="center">
					<th class="etiqueta_formulario2" width="1px">Nro</th>
					<th class="etiqueta_formulario2" width="1px">C&oacute;digo</th>
					<th class="etiqueta_formulario2">Producto</th>
					<th class="etiqueta_formulario2" width="100">Fecha</th>
					<th class="etiqueta_formulario2" width="1px">Cant. Pedida</th>
					<th class="etiqueta_formulario2" width="1px">Total Despachado</th>
					<th class="etiqueta_formulario2" width="1px">Cant. Despachada</th>
					<th class="etiqueta_formulario2" width="100">Estado</th>
					<th class="etiqueta_formulario2" width="1px">Guia de Remision</th>
					<th class="etiqueta_formulario2" width="1px">Fecha despacho</th>
				</tr>
			</thead>
			<tbody>
			<%
			int idx = 0;
			for(String[] registroDetalle : detalleDespacho){
			 %>						
				<tr>
					<td class="detalle_formulario"><%=registroDetalle[0]%>
						<input type="hidden"name="txtIdDet" value="<%=registroDetalle[0]%>" />
					</td>
					<td class="detalle_formulario"><%=registroDetalle[1]%>
						<input type="hidden" name="txtProducto" value="<%=registroDetalle[1]%>" /></td>
					<td class="detalle_formulario"><%=registroDetalle[2]%>
						<input type="hidden" name="txtProductoDes" value="<%=registroDetalle[2]%>" /></td>
					<td align="center" class="detalle_formulario"><%=registroDetalle[3]%>
						<input type="hidden" name="txtFecha" value="<%=registroDetalle[3]%>" /></td>
					<td align="center" class="detalle_formulario"><%=registroDetalle[4]%>
						<input type="hidden" name="txtCantPed" value="<%=registroDetalle[4]%>" /></td>
					<td align="center" class="detalle_formulario"><%=registroDetalle[5]%>
					    <input type="hidden" name="txtTotDesp" value="<%=registroDetalle[5] %>" /></td>
					<td class="detalle_formulario">
					<% 
						String cant_pedida = registroDetalle[4];
						String total_desp = registroDetalle[5]; 
						String propiedad="";
						//System.out.println("cant_pe="+cant_pedida);
						//System.out.println("total_desp="+total_desp);
						if(cant_pedida.equals(total_desp)){
							propiedad="disabled=\"disabled\"";
							//System.out.println("Ingreso detalle ");
						}
					%>
						<input type="text" name="txtCantDesp" id="txtCantDesp<%=idx%>" value="" <%=propiedad%> size="5"   onkeydown="myEventFunction(event, this,'<%=idx%>');" ></td>
					<td align="center" class="detalle_formulario"><%
					if (cant_pedida.equals(total_desp))
						out.println("Despacho Total");
					else if (total_desp.equals("0"))
						out.println("No Despachado");
					else	
						out.println("Despacho Parcial");
					
					%>
					</td>
					<td class="detalle_formulario">
						<input type="text"	name="txtguia_remi2" id="txtguia_remi2<%=idx %>"  <%=propiedad%> value="<%=(registroDetalle[6]!=null)?registroDetalle[6]:"" %>" size="10" onkeydown="myEventFunction(event, this,'<%=idx%>');" />
					</td>
					<td class="detalle_formulario">
						<input type="text"	name="txtfechadesp2"  class="datepicker" id="txtfechadesp2<%=idx %>" <%=propiedad%>  value="<%=(registroDetalle[7]!=null)?registroDetalle[7]:"" %>"  size="10"  onkeydown="myEventFunction(event, this,'<%=idx%>');" />
						
					</td>				
				</tr>
				<% idx ++;
				} %>
			<%}else{ %>
				<tr>
					<td class="titulo" align="center">No existen datos a presentar</td>
				</tr>
			<%} %>
			</tbody>
		</table>
		</div>
		<br />
		<table width="50%" border="0" align="center">
			<tr>
				<td><input type="button" id="Guardar" value="Guardar" width="40" height="35"/></td>
				<td><input type="button" id="Cancelar" value="Cancelar" width="40" height="35"/></td>
				<td><input type="button" value="Imprimir" width="40" height="35" onclick="window.print()"/></td>
				<td><input type="button" id="exportar" name="exportar" value="Exportar"></td>
			</tr>
		</table>
	</form>
</body>
</html>