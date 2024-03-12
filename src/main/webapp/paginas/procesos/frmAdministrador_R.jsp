<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.ResultSet"%>
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
	
	ResultSet estado = null; 
	ResultSet rSProveedor=null; 
	String proveedor = "",rutas="",solicitud = "",usuario ="",
			ubicacion  ="",articulo ="",estadoDT ="",estadoDP ="",estadoR ="",estadoND ="",fecha_hasta ="",fecha_desde ="";
	String ls_tipo_usuario = request.getSession().getAttribute("PS_ROL").toString();
	
	try{
	proveedor = request.getParameter("pProveedor");
	solicitud = request.getParameter("pSolicitud");
	usuario = request.getParameter("pUsuario");
	ubicacion = request.getParameter("pUbicacion");
	articulo = request.getParameter("pArticulo");
	 
	estadoDT = request.getParameter("pEstadoDT");
	estadoDP = request.getParameter("pEstadoDP");
	estadoR = request.getParameter("pEstadoR");
	estadoND = request.getParameter("pEstadoND");
	
	/* if(estadoDT==null){estadoDT="0";}
	if(estadoDP==null){estadoDP="0";}
	if(estadoR==null){estadoR="0";}
	if(estadoND==null){estadoND="0";} */

	fecha_desde = request.getParameter("pFechaDesde");
	fecha_hasta = request.getParameter("pFechaHasta");
	
	rutas = "../procesos/frmdetalleAdministrador.jsp?pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="+usuario+
	"&pUbicacion="+ubicacion+"&pArticulo="+articulo+"&pEstadoDT="+estadoDT+"&pEstadoDP="+estadoDP+"&pEstadoR="+estadoR+
	"&pEstadoND="+estadoND+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta+"&pPresentar=S"+"&pImprimir=N";

	
	System.out.println("tipo de usuario: "+ls_tipo_usuario);
	
	System.out.println(" rutas ::: >>>"+rutas);
	
	}catch(Exception e){
		e.printStackTrace();
	}
	String presentar = "";
	String otroDatos = "";
	try{
		presentar = request.getParameter("pPresentar");
		
		System.out.println("presentar : "+presentar);
		if(presentar==null){
			presentar = "N";
			otroDatos = "N";
		}else{
			otroDatos = "S";
		}
	}catch(Exception e){
		presentar = "N";
		otroDatos = "N";	
	}
	
	
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
	#detalle_solicitudes{
		max-height: 450px;
		overflow: scroll;
	}
	.disableWin{
	     pointer-events: none;
	}
	.titulo_tabla:hover {
		background-color:#FF0000;
	}
</style>


<script type="text/javascript">
	$(document).ready(function(){
		$('#fecha_desde').datepicker({ dateFormat: 'dd/mm/yy' }).val();
		$('#fecha_hasta').datepicker({ dateFormat: 'dd/mm/yy' }).val();

		$('#consultar').click(function(){ cargar_detalle_solicitudes('S','N','N'); });	
		$('#generarPedido').click(function(){ cargar_generar_pedido('S','N'); });
		$('#previewCosto').click(function(){popup('../procesos/popAdministrador/popPreviewsCosto.jsp',270,150);});
		$('#prefacturacion').click(function(){popup('../procesos/popAdministrador/popPreFactura.jsp',270,150);});
		//$('#consultar').click(function(){cambiaEstado();});	
		$('#exportar').click(function(){cargar_detalle_solicitudes('S','N','S');});
		$('#recibir').click(function(){	
			
			recibir();
				});
		$('#reversa').click(function(){	reversa();	});
		$('.titulo_tabla').click(function(){
			$("#desplegable").css("display", "block");
			$("#oculto").css("display", "none");
			//var despegable = frmDetOrden.desplegable;
		});
		//$('#txtFechaRecepcion').datepicker({ dateFormat: 'dd/mm/yy' }).val();
		cargar_detalle_solicitudes('<%=presentar%>','<%=otroDatos%>','N');	
		
	
	});
	

	
	
	var map1;
	var mapForm;
    /*
	
	function pdf(){
		alert("Prueba");
		*/
		/*
		var pdf = new jsPDF('p','pt','letter');
	    var specialElementHandlers = {
	    '#desplegable': function (element, renderer) {
	        return true;
	        }
	    };

	    pdf.addHTML($('#desplegable').first(), function() {
	        pdf.save("caravan.pdf");
	    });
		*/
		/*
		var doc = new jsPDF('p', 'in', 'letter');
        var source = $('#desplegable').first();
        var specialElementHandlers = {
        	    '#editor': function(element, renderer){
        	        return true;
        	    }
        	};

        doc.fromHTML(
           $('#desplegable').get(0), // [Refer Exact code tutorial][2]HTML string or DOM elem ref.
            0.5,    // x coord
            0.5,    // y coord
            {
                'width': 7.5, // max width of content on PDF
                'elementHandlers': specialElementHandlers
            });

        doc.save("Test.pdf");
	}*/
	
	function mayuscula(campo){
		campo.value=campo.value.toUpperCase();
	} 
	
	
	function cargar_generar_pedido(presentar,ortaRuta){
		
		var proveedor = document.getElementById("cmbProveedor").value;
		var solicitud = document.getElementById("solicitud").value;
		var usuario = document.getElementById("usuario").value;
		var nombre_ubicacion = document.getElementById("ubicacion").value;
		var articulo = document.getElementById("articulo").value;
	
		var estado = 0;
		var estadoDT = 0;
		var estadoDP = 0;
		var estadoR = 0;
		var estadoND = 0;
		if(presentar=='S'){
			estado = document.frmDetOrden.estadoDT.checked;
		if(estado==true){
			estadoDT = document.getElementById("estadoDT").value;
		}
		estado = document.frmDetOrden.estadoDP.checked;
		if(estado==true){
			estadoDP = document.getElementById("estadoDP").value;
		}
		estado = document.frmDetOrden.estadoR.checked;
		if(estado==true){
			estadoR = document.getElementById("estadoR").value;
		}
		estado = document.frmDetOrden.estadoND.checked;
		if(estado==true){
			estadoND = document.getElementById("estadoND").value;
		}
		}
		var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
		//var estado = document.getElementsByTagName('estado').Value;
		
		var ruta = "../procesos/generaPedido.jsp?pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="
		+usuario+"&pUbicacion="+nombre_ubicacion+"&pArticulo="+articulo+"&pEstadoDT="+estadoDT
		+"&pEstadoDP="+estadoDP+"&pEstadoR="+estadoR+"&pEstadoND="+estadoND
		+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta+"&pEstado="+estado+"&pPresentar="+presentar;
		
		popup(ruta,500,500);
		
	}
	
	function cargar_detalle_solicitudes(presentar,ortaRuta,imprimir){
		
		var proveedor = document.getElementById("cmbProveedor").value;
		//alert(proveedor);
		var solicitud = document.getElementById("solicitud").value;
		var usuario = document.getElementById("usuario").value;
		var nombre_ubicacion = document.getElementById("ubicacion").value;
		var articulo = document.getElementById("articulo").value;
		
		var estado = 0;
		var estadoDT = 0;
		var estadoDP = 0;
		var estadoR = 0;
		var estadoND = 0;
		
		if(presentar=='S'){
			estado = document.frmDetOrden.estadoDT.checked;
		if(estado==true){
			estadoDT = document.getElementById("estadoDT").value;
		}
		estado = document.frmDetOrden.estadoDP.checked;
		if(estado==true){
			estadoDP = document.getElementById("estadoDP").value;
		}
		estado = document.frmDetOrden.estadoR.checked;
		if(estado==true){
			estadoR = document.getElementById("estadoR").value;
			//alert("estadoR:"+estadoR);
		}
		estado = document.frmDetOrden.estadoND.checked;
		if(estado==true){
			estadoND = document.getElementById("estadoND").value;
		}
		}
		var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
		//var estado = document.getElementsByTagName('estado').Value;
		
		var ruta = "../procesos/frmdetalleAdministrador.jsp?pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="
		+usuario+"&pUbicacion="+nombre_ubicacion+"&pArticulo="+articulo+"&pEstadoDT="+estadoDT
		+"&pEstadoDP="+estadoDP+"&pEstadoR="+estadoR+"&pEstadoND="+estadoND
		+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta+"&pEstado="+estado+"&pPresentar="+presentar+"&pImprimir="+imprimir;
		//alert(ruta);
		if(ortaRuta=="S"){
			ruta = "<%=rutas%>";
		}
		
		$('#detalle_solicitudes').load(ruta);
		if(presentar=="S"){
			$("#desplegable").css("display", "none");
		}
		if(imprimir=="S"){
			window.open(ruta, "_self");
		}
		
	}	

	function cambiaEstado() {
		var estadoNew =	document.getElementsByTagName('estado');
	}
	
	function popup(url,ancho,alto) {
		var posicion_x; 
		var posicion_y; 
		posicion_x=(screen.width/2)-(ancho/2); 
		posicion_y=(screen.height/2)-(alto/2); //status=no, scroll=NO
		//window.open(url, "leonpurpura.com", "width="+ancho+",height="+alto+",menubar=0,toolbar=0,directories=0,scrollbars=1,resizable=1,left="+posicion_x+",top="+posicion_y+"");
		window.open(url, "popup", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");
		//window.focus();
	}
	
	function cambiaSociedad(){
		var proveedorNew = document.frmDetOrden.cmbProveedor.value;
	}
	
	function addElement(idx, cadena){
		var mapInputGen = document.createElement("input");
		mapInputGen.type = "hidden";
		mapInputGen.name = "cadena"+idx;
		mapInputGen.value = cadena;
		//alert(idx+"|"+cadena);
		return mapInputGen;
	}
	
	function recibir(){
		
		var detAdministrador = document.frmDetAdministrador.elements.length;
		//alert("1: "+detAdministrador);
		var i;
		var j;
		var proveedor = "";
		var solicitud = "";
		var numeroLinea="";
		var usuario="";
		var descArticulo = "";
		var cantidadSoli = "";
		var fechaDespachado = "";
		var cantidadDesp = "";
		var fechaRecepcion = "";
		var cantidadRecibida = "";
		var estado = "";
		var checked;
		var pase = 0;
		var cadena = "";
		var ii =0;
		var ind = 1;
		var idx=0;
		var observacion="";
		var cantidadGrid = "";
		
		//JZURITA Inicio
		 mapForm = document.createElement("form");
	     mapForm.method = "POST"; // or "post" if appropriate
	     mapForm.action = "../procesos/frmAdmRecibir.jsp";
	     
	     var mapInputAdi = document.createElement("input");
	     mapInputAdi.type = "hidden";
	     mapInputAdi.name = "pAdiconal";	     		
	     mapInputAdi.value = "1";
	     mapForm.appendChild(mapInputAdi);	     
	     //JZURITA Fin
	     i=detAdministrador - 1;
	     for (i; i > 0; i--) {
	   	 if (document.frmDetAdministrador.elements[i].name =="txtCantidad") {
	    		 cantidadGrid = document.frmDetAdministrador.elements[i].value;	 
	    		 break;
	    	 }
	     }
	     
	     //alert("cantidadGrid::"+cantidadGrid);
	     if(cantidadGrid!=0){
		     for (j=1; j<cantidadGrid; j++) {
		    	 for (i = 0; i < detAdministrador; i++) {
					if (document.frmDetAdministrador.elements[i].id == "txtProveedor"+j) {					
						proveedor = document.frmDetAdministrador.elements[i].value;
						//alert("proveedor::"+proveedor);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtSolicitud"+j) {
						solicitud = document.frmDetAdministrador.elements[i].value;
						//alert("solicitud::"+solicitud);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtNlinea"+j) {
						numeroLinea = document.frmDetAdministrador.elements[i].value;
						//alert("numeroLinea::"+numeroLinea);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtUsuario"+j) {
						usuario = document.frmDetAdministrador.elements[i].value;
						//alert("usuario::"+usuario);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtDesArticulo"+j) {
						descArticulo = document.frmDetAdministrador.elements[i].value;
						//alert("descArticulo::"+descArticulo);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtCantidadSoli"+j) {
						cantidadSoli = document.frmDetAdministrador.elements[i].value;
						//alert("cantidadSoli::"+cantidadSoli);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtFechaDespacho"+j) {
						fechaDespachado = document.frmDetAdministrador.elements[i].value;
						//alert("fechaDespachado::"+fechaDespachado);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtCantidaDesp"+j) {
						cantidadDesp = document.frmDetAdministrador.elements[i].value;
						//alert("cantidadDesp::"+cantidadDesp);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtFechaRecepcion"+j) {
						fechaRecepcion = document.frmDetAdministrador.elements[i].value;
						//alert("fechaRecepcion::"+fechaRecepcion);
					}
					if (document.frmDetAdministrador.elements[i].id == "txtCantReciba"+j) {
						cantidadRecibida = document.frmDetAdministrador.elements[i].value;
						//alert("cantidadRecibida::"+cantidadRecibida);
					}				
					if (document.frmDetAdministrador.elements[i].id=="txtEstado"+j) {
						estado = document.frmDetAdministrador.elements[i].value;
						//alert("txtEstado"+ind+"::"+estado);
						if(estado=="2"){
							//Inicio MCA 
							estado="11";//si un despacho es "No despachado" se setea en "No Recibido"
							//alert(" Favor escoja un Estado para un Item con estado No Despachado. Debe Seleccionar No Recibido / Despacho Denegado ");
							//return false;
							//Fin MCA
						}
					}
					if (document.frmDetAdministrador.elements[i].id=="txtObservacion"+j) {
						//alert("observacion:"+observacion);
						observacion = document.frmDetAdministrador.elements[i].value;
						//alert("txtEstado"+ind+"::"+estado);
					}					
					if (document.frmDetAdministrador.elements[i].id == "cbmConfirma"+j) {
						checked = document.frmDetAdministrador.elements[i].checked;
						var disable = false;
						disable = document.frmDetAdministrador.elements[i].disabled;
						if(checked==true){
							//alert("Solicitud "+solicitud+" no ha sido confrimado");
						//	return;
							if(disable==false){
								pase = 1;
							}
						}
						//alert("pase::"+pase);
					}
		    	 }
		    	 
					ind = ind*1+1;
					ii = i;
					if(pase==1){
						cadena = cadena+proveedor+"|"+solicitud+"|"+numeroLinea+"||"+descArticulo
						+"|"+cantidadSoli+"|"+fechaDespachado+"|"+cantidadDesp+"|"+
						fechaRecepcion+"|"+cantidadRecibida+"|"+estado+"|";
						
						cadena = proveedor+"|"+solicitud+"|"+numeroLinea+"||"+descArticulo
						+"|"+cantidadSoli+"|"+fechaDespachado+"|"+cantidadDesp+"|"+
						fechaRecepcion+"|"+cantidadRecibida+"|"+estado+"|"+observacion+"|";
						
						
		
						if(estado=="10"){
							if(observacion==""){
								alert("Favor Ingrese la Observacion para el item que tiene como estado Despacho Denegado");
								return false;
							}
						}
						
						if(cadena!=null){
						if(cadena!=""){
							//alert("Ruc::"+ruc);
							if (solicitud!=null){
								if (cantidadDesp!=null){
									mapForm.appendChild(addElement(idx,cadena));
								}
							idx = idx*1+1;						
							//alert(idx+"|"+cadena);
							}
						}
						}
		     }
					proveedor = "";
					solicitud = "";
					numeroLinea="";
					usuario="";
					descArticulo = "";
					cantidadSoli = "";
					fechaDespachado = "";
					cantidadDesp = "";
					fechaRecepcion = "";
					cantidadRecibida = "";
					estado = "";
					pase = 0;
	     }
		   //JZURITA Inicio
				
				var mapInputTam = document.createElement("input");
			    mapInputTam.type = "hidden";
			    mapInputTam.name = "length";	     		
			    mapInputTam.value = idx;
			    mapForm.appendChild(mapInputTam);
			    //JZURITA Fin
					
			var proveedor = document.getElementById("cmbProveedor").value;
			
			var mapInputProveedor = document.createElement("input");
			mapInputProveedor.type = "hidden";
			mapInputProveedor.name = "pProveedor";	     		
			mapInputProveedor.value = "proveedor";
		    mapForm.appendChild(mapInputProveedor);
		     
			var solicitud = document.getElementById("solicitud").value;
			var mapInputSolicitud = document.createElement("input");
			mapInputSolicitud.type = "hidden";
			mapInputSolicitud.name = "pSolicitud";	     		
			mapInputSolicitud.value = solicitud;
		    mapForm.appendChild(mapInputSolicitud);
		    
			var usuario = document.getElementById("usuario").value;		
	        var mapInputUsuario = document.createElement("input");
	        mapInputUsuario.type = "hidden";
	        mapInputUsuario.name = "pUsuario";	     		
	        mapInputUsuario.value = usuario;
		    mapForm.appendChild(mapInputUsuario);
		    
			var nombre_ubicacion = document.getElementById("ubicacion").value;
			var mapInputUbicacion = document.createElement("input");
			mapInputUbicacion.type = "hidden";
			mapInputUbicacion.name = "pUbicacion";	     		
			mapInputUbicacion.value = nombre_ubicacion;
		    mapForm.appendChild(mapInputUbicacion);
		    
			var articulo = document.getElementById("articulo").value;
			var mapInputArticulo = document.createElement("input");
			mapInputArticulo.type = "hidden";
			mapInputArticulo.name = "pArticulo";	     		
			mapInputArticulo.value = articulo;
		    mapForm.appendChild(mapInputArticulo);
		    
			
			var estadoDT = 0;
			var estadoDP = 0;
			var estadoR = 0;
			var estadoND = 0;
			//if(presentar=='S'){
			var estado = document.frmDetOrden.estadoDT.checked;
			if(estado==true){
				estadoDT = document.getElementById("estadoDT").value;
				var mapInputEstadoDT = document.createElement("input");
				mapInputEstadoDT.type = "hidden";
				mapInputEstadoDT.name = "pEstadoDT";	     		
				mapInputEstadoDT.value = estadoDT;
			    mapForm.appendChild(mapInputEstadoDT);
			}
			estado = document.frmDetOrden.estadoDP.checked;
			if(estado==true){
				estadoDP = document.getElementById("estadoDP").value;
				var mapInputEstadoDP = document.createElement("input");
				mapInputEstadoDP.type = "hidden";
				mapInputEstadoDP.name = "pEstadoDP";	     		
				mapInputEstadoDP.value = estadoDP;
			    mapForm.appendChild(mapInputEstadoDP);
			}
			estado = document.frmDetOrden.estadoR.checked;
			if(estado==true){
				estadoR = document.getElementById("estadoR").value;
				//alert("estadoR::"+estadoR);
				var mapInputEstadoR = document.createElement("input");
				mapInputEstadoR.type = "hidden";
				mapInputEstadoR.name = "pEstadoR";	     		
				mapInputEstadoR.value = estadoDP;
			    mapForm.appendChild(mapInputEstadoR);
			}
			estado = document.frmDetOrden.estadoND.checked;
			if(estado==true){
				estadoND = document.getElementById("estadoND").value;
				var mapInputEstadoND = document.createElement("input");
				mapInputEstadoND.type = "hidden";
				mapInputEstadoND.name = "pEstadoND";	     		
				mapInputEstadoND.value = estadoND;
			    mapForm.appendChild(mapInputEstadoND);
			}
			//}
			var fecha_desde = document.getElementById("fecha_desde").value;
			var mapInputFechaDesde = document.createElement("input");
			mapInputFechaDesde.type = "hidden";
			mapInputFechaDesde.name = "pFechaDesde";	     		
			mapInputFechaDesde.value = fecha_desde;
			mapForm.appendChild(mapInputFechaDesde);
			
			var fecha_hasta = document.getElementById("fecha_hasta").value;
			var mapInputFechaHasta = document.createElement("input");
			mapInputFechaHasta.type = "hidden";
			mapInputFechaHasta.name = "pFechaHasta";	     		
			mapInputFechaHasta.value = fecha_hasta;
			mapForm.appendChild(mapInputFechaHasta);
			
			var ancho=200;
			var alto=200;
			var posicion_x; 
			var posicion_y; 
			posicion_x=(screen.width/2)-(ancho/2); 
			posicion_y=(screen.height/2)-(alto/2);
			//JZURITA Inicio
			document.body.appendChild(mapForm);
			 map1 = window.open("",target="_bandeja");
	    	if (map1) {
	    		mapForm.submit();
	    		alert("Recibido Correctamente.");
	    	} else {
	    		alert("You must allow popups for this map to work.");
	    	}
	    	map1.close();
	    }else{
	    	alert("No hay solicitudes para recibir.")
	    }
	     

	}
	
	function reversa(){
		
		var detAdministrador = document.frmDetAdministrador.elements.length;
		var solicitud = "";
		var numeroLinea = "";
		var cadena="";
		var pase=0;
		
		if(detAdministrador!= 0){
		for (i = 0; i < detAdministrador; i++) {
			
			if (document.frmDetAdministrador.elements[i].name == "txtNlinea") {
				numeroLinea = document.frmDetAdministrador.elements[i].value;
				pase=1;
			}
			if (document.frmDetAdministrador.elements[i].name == "txtSolicitud") {
				solicitud = document.frmDetAdministrador.elements[i].value;
			}
			
			if(numeroLinea!=""&&solicitud!=""){
				cadena = cadena+solicitud+"|"+numeroLinea+"|";
				pase=0;
				solicitud = "";
				numeroLinea="";
			}
		}
		
		var proveedor = document.getElementById("cmbProveedor").value;
		var solicitud = document.getElementById("solicitud").value;
		var usuario = document.getElementById("usuario").value;
		var nombre_ubicacion = document.getElementById("ubicacion").value;
		var articulo = document.getElementById("articulo").value;
		
		var estadoDT = 0;
		var estadoDP = 0;
		var estadoR = 0;
		var estadoND = 0;
		//if(presentar=='S'){
		var estado = document.frmDetOrden.estadoDT.checked;
		if(estado==true){
			estadoDT = document.getElementById("estadoDT").value;
		}
		estado = document.frmDetOrden.estadoDP.checked;
		if(estado==true){
			estadoDP = document.getElementById("estadoDP").value;
		}
		estado = document.frmDetOrden.estadoR.checked;
		if(estado==true){
			estadoR = document.getElementById("estadoR").value;
		}
		estado = document.frmDetOrden.estadoND.checked;
		if(estado==true){
			estadoND = document.getElementById("estadoND").value;
		}
		//}
		var fecha_desde = document.getElementById("fecha_desde").value;
		var fecha_hasta = document.getElementById("fecha_hasta").value;
		//var estado = document.getElementsByTagName('estado').Value;
		//if(cadena!=""){
		var ruta = "../procesos/frmAdmReversa.jsp?pCadena="+cadena+"&pAdiconal=1&pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="
		+usuario+"&pUbicacion="+nombre_ubicacion+"&pArticulo="+articulo+"&pEstadoDT="+estadoDT
		+"&pEstadoDP="+estadoDP+"&pEstadoR="+estadoR+"&pEstadoND="+estadoND
		+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta+"&pEstado="+estado+"&pPresentar=S";
		
		var ancho=200;
		var alto=200;
		var posicion_x; 
		var posicion_y; 
		posicion_x=(screen.width/2)-(ancho/2); 
		posicion_y=(screen.height/2)-(alto/2);
		window.open(ruta ,  /*"popup", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");/*/target="_bandeja");
		
		/*
		
		//$('#detalle_solicitudes').load(ruta);
		//cargar_detalle_solicitudes("S");
		alert("OK");
		$('#detalle_menu').load("../procesos/frmAdministrador.jsp?pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="
		+usuario+"&pUbicacion="+nombre_ubicacion+"&pArticulo="+articulo+"&pEstadoDT="+estadoDT
		+"&pEstadoDP="+estadoDP+"&pEstadoR="+estadoR+"&pEstadoND="+estadoND
		+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta+"&pEstado="+estado+"&pPresentar=S");
		}else{
			alert("No hay datos para Relaizar procesos recibir");
		}*/
		}else{
			alert("No hay datos en la consulta");
		}
			
		
	}
	
	
	function verificaLogin(atributo){
				if (atributo == "false"){
					alert("Debe ingresar con su usuario");
					window.open("../login/frmLogin.html", "_self");
				}
			}
	
	function pedidoSap(){
		alert("Generar Pedido...!!!");
	}
	
</script>
</head>

<body >

  <form name="frmDetOrden">

	<table width="100%" >
			<tr>
				<td class="titulo_tabla">
				<a class="ver_mas demo" id="criterioConsulta" name="criterioConsulta" >Criterios de Consulta</a>
				 </td>
			</tr>
		</table>
	<div id="desplegable">
	<table cellpadding="0">
		<tr>
			<td class="etiqueta_formulario">Proveedor :</td>
			<td class="detalle_formulario">
				<select id="cmbProveedor" style="width: 100%;" name="cmbProveedor" onchange="javascript:cambiaSociedad();">
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
			<td class="etiqueta_formulario">No. solicitud : </td>
			<td class="detalle_formulario"><input type="text" id="solicitud" name="solicitud" size="24"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Usuario : </td>
			<td class="detalle_formulario"><input type="text" id="usuario" name="usuario" size="24"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Nombre ubicacion: </td>
			<td class="detalle_formulario"><input type="text" id="ubicacion" name="ubicacion" size="24"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Articulo : </td>
			<td class="detalle_formulario"><input type="text" id="articulo" name="articulo" size="24"></td>
		</tr>
		<tr>
			<td class="etiqueta_formulario">Estado: </td>
			<td class="detalle_formulario">
			<table width="100%">
				<tr><td>Despachado Total</td><td><input type="checkbox" id="estadoDT" name="estadoDT" value="4" /></td></tr>
				<tr><td>Despachado parcial</td><td><input type="checkbox" id="estadoDP" name="estadoDP" value="3" /></td></tr>
				<tr><td>Recibido</td><td><input type="checkbox" id="estadoR" name="estadoR" checked="checked" value="'6','7'"/></td></tr>
				<tr><td>No despachado</td><td><input type="checkbox" id="estadoND" name="estadoND"   value="2"/></td></tr>
			</table>
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
			<td colspan="6" align="center"><input type="button" value="Consultar" id="consultar" name="consultar"></td>
		</tr>
	</table>
	</div>
	<div></div>
		<div class="etiqueta_formulario_1" >Solicitudes de Proveeduria</div>
		<div id="subdetalle">
			<div class="etiqueta_formulario_1" >Detalles Solicitudes</div>			
			<div id="detalle_solicitudes"></div>
		</div>
		<div align="center">
			<table border="0" align="center" height="1" width="700">
				<tr>
					<td align="center" ><input type="button" value="      Reversa      " id="reversa" name="reversa"></td>
				</tr>
			</table>
		</div>
		<div id="oculto"></div>

  </form>
<%sA.cerrarSesionBD();%>
</body>
<script type="text/javascript">

		var proveedor = "<%=proveedor%>";
		var solicitud = "<%=solicitud%>";
		var usuario = "<%=usuario%>";
		var nombre_ubicacion = "<%=ubicacion%>";
		var articulo = "<%=articulo%>";
		var estadoDT = <%=estadoDT%>;
		var estadoDP = <%=estadoDP%>;
		var estadoR = "<%=estadoR%>";
		var estadoND = <%=estadoND%>;
		
		var fecha_desde = "<%=fecha_desde%>";
		var fecha_hasta = "<%=fecha_hasta%>";
		
		//alert("||"+estadoDT+"|"+estadoDP+"|"+estadoR+"|"+estadoND+"|");
		if(proveedor!="null"){document.getElementById("cmbProveedor").value = proveedor;} 
		if(solicitud!="null"){document.getElementById("solicitud").value = solicitud;}
		if(usuario!="null"){document.getElementById("usuario").value =usuario;}
		if(nombre_ubicacion!="null"){document.getElementById("ubicacion").value =nombre_ubicacion;}
		if(articulo!="null"){document.getElementById("articulo").value =articulo;}
		if(fecha_desde!="null"){document.getElementById("fecha_desde").value = fecha_desde;}
		if(fecha_hasta!="null"){document.getElementById("fecha_hasta").value = fecha_hasta;}
		
		if(estadoDT!="0"){document.frmDetOrden.estadoDT.checked = true;}else{document.frmDetOrden.estadoDT.checked = false;}
		if(estadoDP!="0"){document.frmDetOrden.estadoDP.checked = true;}else{document.frmDetOrden.estadoDP.checked = false;}
		if(estadoR!="0"){document.frmDetOrden.estadoR.checked = true;}else{document.frmDetOrden.estadoR.checked = false;}
		if(estadoND!="0"){document.frmDetOrden.estadoND.checked = true;}else{document.frmDetOrden.estadoND.checked = false;}

</script>
</html>