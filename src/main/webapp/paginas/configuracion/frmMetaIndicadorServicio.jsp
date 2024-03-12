<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page errorPage="../general/errorGral.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);

	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	List<String[]> indicadoresServicio = sA.obenterMetaIndicador(nombreSociedad);
	int CantIndicadores=indicadoresServicio.size();
	System.out.println("CantIndicadores: "+CantIndicadores);
%>
 <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
 <title>Mantenedor Usuario y Ubicacion</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
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
	#detalle_indicador{
		height: auto;
		overflow: auto;
	}
	.fecha{}
	
	.etiqueta_formulario_1{
		font-family:"Arial, Verdana";
		font-size:20px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
	img {
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
	
	var gabar = "S";
	var editar = "N";
	var eliminar = "N";
	
	function cargar(index) {

		var detMetaIndicador = document.frmMetaIndicador.elements.length;

		
		for (i = 0; i < detMetaIndicador; i++) {
			//linea = 0;
			if (document.frmMetaIndicador.elements[i].name == "txtOficina"+index) {
				document.frmMetaIndicador.txtOficina.value = document.frmMetaIndicador.elements[i].value;
			}
			
			if (document.frmMetaIndicador.elements[i].name == "txtEnero"+index) {
				document.frmMetaIndicador.txtEnero.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtFebrero"+index) {
				document.frmMetaIndicador.txtFebrero.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtMarzo"+index) {
				document.frmMetaIndicador.txtMarzo.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtAbril"+index) {
				document.frmMetaIndicador.txtAbril.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtMayo"+index) {
				document.frmMetaIndicador.txtMayo.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtJunio"+index) {
				document.frmMetaIndicador.txtJunio.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtJulio"+index) {
				document.frmMetaIndicador.txtJulio.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtAgosto"+index) {
				document.frmMetaIndicador.txtAgosto.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtSeptiembre"+index) {
				document.frmMetaIndicador.txtSeptiembre.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtOctubre"+index) {
				document.frmMetaIndicador.txtOctubre.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtNoviembre"+index) {
				document.frmMetaIndicador.txtNoviembre.value = document.frmMetaIndicador.elements[i].value;
			}
			if (document.frmMetaIndicador.elements[i].name == "txtDiciembre"+index) {
				document.frmMetaIndicador.txtDiciembre.value = document.frmMetaIndicador.elements[i].value;
			}
			
			if (document.frmMetaIndicador.elements[i].name == "txtEstado"+index) {
				document.frmMetaIndicador.txtEstado.checked = document.frmMetaIndicador.elements[i].checked;
			}
				//alert("La cantidad despachada no debe ser mayor a la pedida");
				//return;
				
		}	
			document.frmMetaIndicador.txtOficina.disabled= true;
			//alert(gabar+"-"+editar+"-"+eliminar);
			gabar = "N";
			editar = "S";
			eliminar = "S";
			//alert(gabar+"-"+editar+"-"+eliminar);
			
	}
	
	function mayuscula(campo){
		campo.value=campo.value.toUpperCase();
	}
	
	function eliminarTabla(){
		if(eliminar=="S"){
			var nombre_oficina = document.frmMetaIndicador.txtOficina.value;
			var respuesta= confirm("Esta seguro de Eliminar "+nombre_oficina);
			if(!respuesta)return;
			
			nombre_oficina = nombre_oficina.replace(/ /gi,"~");
			var ruta = "../configuracion/deleteMetaIndicador.jsp?pOficina="+nombre_oficina;
			$('#detalle_menu').load(ruta);
		}else{
			alert("Debe seleccionar un MetaIndicador para eliminar.");
		}	
	}
	
	function guardar(){
		if(gabar=="S"){
			var nombre_oficina = document.frmMetaIndicador.txtOficina.value;
			if(nombre_oficina!=""){
				var enero = document.frmMetaIndicador.txtEnero.value;
				nombre_oficina = nombre_oficina.replace(/ /gi,"~");
				var febrero = document.frmMetaIndicador.txtFebrero.value;
				var marzo = document.frmMetaIndicador.txtMarzo.value;
				var abril = document.frmMetaIndicador.txtAbril.value;
				var mayo = document.frmMetaIndicador.txtMayo.value;
				var junio = document.frmMetaIndicador.txtJunio.value;
				var julio = document.frmMetaIndicador.txtJulio.value;
				var agosto = document.frmMetaIndicador.txtAgosto.value;
				var septiembre = document.frmMetaIndicador.txtSeptiembre.value;
				var octubre = document.frmMetaIndicador.txtOctubre.value;
				var noviembre = document.frmMetaIndicador.txtNoviembre.value;
				var diciembre = document.frmMetaIndicador.txtDiciembre.value;
				var auxEstado = document.frmMetaIndicador.txtEstado.checked;
				var Estado = "";
				if(auxEstado==true){
					Estado="S";
				}else{
					Estado="N";
				}
				var ruta = "../configuracion/insertMetaIndicador.jsp?pOficina="+nombre_oficina+
				"&pEnero="+enero+"&pFebrero="+febrero+"&pMarzo="+marzo+"&pAbril="+abril+"&pMayo="+mayo+
				"&pJunio="+junio+"&pJulio="+julio+"&pAgosto="+agosto+"&pSeptiembre="+septiembre+
				"&pOctubre="+octubre+"&pNoviembre="+noviembre+"&pDiciembre="+diciembre+"&pEstado="+Estado;
				//alert(ruta);
				$('#detalle_menu').load(ruta);
			}else{
				alert("No hay Nombre de oficina ingresado");
			}	
		}else{
			alert("No puede ingresar MetaIndicador ya Existente.");
		}	
	}
	
	function editarTabla(){
		if(editar=="S"){
			var nombre_oficina = document.frmMetaIndicador.txtOficina.value;
			nombre_oficina = nombre_oficina.replace(/ /gi,"~");
			var enero = document.frmMetaIndicador.txtEnero.value;
			var febrero = document.frmMetaIndicador.txtFebrero.value;
			var marzo = document.frmMetaIndicador.txtMarzo.value;
			var abril = document.frmMetaIndicador.txtAbril.value;
			var mayo = document.frmMetaIndicador.txtMayo.value;
			var junio = document.frmMetaIndicador.txtJunio.value;
			var julio = document.frmMetaIndicador.txtJulio.value;
			var agosto = document.frmMetaIndicador.txtAgosto.value;
			var septiembre = document.frmMetaIndicador.txtSeptiembre.value;
			var octubre = document.frmMetaIndicador.txtOctubre.value;
			var noviembre = document.frmMetaIndicador.txtNoviembre.value;
			var diciembre = document.frmMetaIndicador.txtDiciembre.value;
			var auxEstado = document.frmMetaIndicador.txtEstado.checked;
			var Estado = "";
			if(auxEstado==true){
				Estado="S";
			}else{
				Estado="N";
			}
			var ruta = "../configuracion/updateMetaIndicador.jsp?pOficina="+nombre_oficina+
			"&pEnero="+enero+"&pFebrero="+febrero+"&pMarzo="+marzo+"&pAbril="+abril+"&pMayo="+mayo+
			"&pJunio="+junio+"&pJulio="+julio+"&pAgosto="+agosto+"&pSeptiembre="+septiembre+
			"&pOctubre="+octubre+"&pNoviembre="+noviembre+"&pDiciembre="+diciembre+"&pEstado="+Estado;
			$('#detalle_menu').load(ruta);
		}else{
			alert("Debe seleccionar un MetaIndicador para poder modificarlo.");
		}		
	}
	

	function cancelar(){
		document.frmMetaIndicador.txtOficina.disabled = false;
		document.frmMetaIndicador.txtOficina.value = "";
		document.frmMetaIndicador.txtEnero.value = "";
		document.frmMetaIndicador.txtFebrero.value = "";
		document.frmMetaIndicador.txtMarzo.value = "";
		document.frmMetaIndicador.txtAbril.value = "";
		document.frmMetaIndicador.txtMayo.value = "";
		document.frmMetaIndicador.txtJunio.value = "";
		document.frmMetaIndicador.txtJulio.value = "";
		document.frmMetaIndicador.txtAgosto.value = "";
		document.frmMetaIndicador.txtSeptiembre.value = "";
		document.frmMetaIndicador.txtOctubre.value = "";
		document.frmMetaIndicador.txtNoviembre.value = "";
		document.frmMetaIndicador.txtDiciembre.value = "";
		document.frmMetaIndicador.txtEstado.checked = false;
		//alert(gabar+"-"+editar+"-"+eliminar);
		gabar = "S";
		editar = "N";
		eliminar = "N";
		//alert(gabar+"-"+editar+"-"+eliminar);
		
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


</head>
<body>
	<form name="frmMetaIndicador" >
	<div class="titulo_tabla" >Meta Indicador de Servicio </div>
		<div id="subdetalle">
			<div class="etiqueta_formulario" >Detalles de Indicadores</div>
			<div id="detalle_indicador">
				<%
				if(CantIndicadores != 0){
				%>
				<table width="100%">
					<thead>
						<tr class="etiqueta_formulario">
							<td align="center"></td>
							<td align="center">Nombre de Oficina</td>
							<td align="center">ENERO</td>
							<td align="center">FEBRERO</td>
							<td align="center">MARZO</td>
							<td align="center">ABRIL</td>
							<td align="center">MAYO</td>
							<td align="center">JUNIO</td>
							<td align="center">JULIO</td>
							<td align="center">AGOSTO</td>
							<td align="center">SEPTIEMBRE</td>
							<td align="center">OCTUBRE</td>
							<td align="center">NOVIEMBRE</td>
							<td align="center">DICIEMBRE</td>
							<td align="center">ESTADO</td>	
						</tr>
						</thead>
						<tbody>
						<%
						int i = 0;
						for(String[] indicadorServicio : indicadoresServicio){
						 %>
						<tr class="detalle_formulario" >
							<td class="detalle_formulario" align="center" width="1px"><img alt="" src="../../imagenes/busqueda.png" width="30" onclick="javascript:cargar(<%=i%>);" name="botonbuscar" id="#botonbuscar"/></td>
							<td class="detalle_formulario" align="center" width="20%" ><input id="txtOficina<%=i%>" name="txtOficina<%=i%>" type="hidden"  value="<%= indicadorServicio[0]%>"><%=(indicadorServicio[0]==null)?"":indicadorServicio[0]%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtEnero<%=i%>" name="txtEnero<%=i%>" type="hidden"  value="<%= (indicadorServicio[1]==null)?"0":indicadorServicio[1]%>"><%=((indicadorServicio[1]==null)?"0":indicadorServicio[1])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtFebrero<%=i%>" name="txtFebrero<%=i%>" type="hidden"  value="<%= (indicadorServicio[2]==null)?"0":indicadorServicio[2]%>"><%=((indicadorServicio[2]==null)?"0":indicadorServicio[2])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtMarzo<%=i%>" name="txtMarzo<%=i%>" type="hidden" value="<%= (indicadorServicio[3]==null)?"0":indicadorServicio[3]%>"><%=((indicadorServicio[3]==null)?"0":indicadorServicio[3])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtAbril<%=i%>" name="txtAbril<%=i%>" type="hidden" value="<%=(indicadorServicio[4]==null)?"0":indicadorServicio[4]%>"><%=((indicadorServicio[4]==null)?"0":indicadorServicio[4])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtMayo<%=i%>" name="txtMayo<%=i%>" type="hidden"  value="<%= (indicadorServicio[5]==null)?"0":indicadorServicio[5]%>"><%= ((indicadorServicio[5]==null)?"0":indicadorServicio[5])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtJunio<%=i%>" name="txtJunio<%=i%>" type="hidden" value="<%= (indicadorServicio[6]==null)?"0":indicadorServicio[6]%>"><%= ((indicadorServicio[6]==null)?"0":indicadorServicio[6])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtJulio<%=i%>" name="txtJulio<%=i%>" type="hidden" value="<%= (indicadorServicio[7]==null)?"0":indicadorServicio[7]%>"><%= ((indicadorServicio[7]==null)?"0":indicadorServicio[7])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtAgosto<%=i%>" name="txtAgosto<%=i%>" type="hidden" value="<%= (indicadorServicio[8]==null)?"0":indicadorServicio[8]%>"><%= ((indicadorServicio[8]==null)?"0":indicadorServicio[8])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtSeptiembre<%=i%>" name="txtSeptiembre<%=i%>" type="hidden" value="<%= (indicadorServicio[9]==null)?"0":indicadorServicio[9]%>"><%= ((indicadorServicio[9]==null)?"0":indicadorServicio[9])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtOctubre<%=i%>" name="txtOctubre<%=i%>" type="hidden" value="<%= (indicadorServicio[10]==null)?"0":indicadorServicio[10]%>"><%= ((indicadorServicio[10]==null)?"0":indicadorServicio[10])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtNoviembre<%=i%>" name="txtNoviembre<%=i%>" type="hidden" value="<%= (indicadorServicio[11]==null)?"0":indicadorServicio[11]%>"><%= ((indicadorServicio[11]==null)?"0":indicadorServicio[11])+"%"%></td>
							<td class="detalle_formulario" align="center" ><input class="fecha" id="txtDiciembre<%=i%>" name="txtDiciembre<%=i%>" type="hidden" value="<%= (indicadorServicio[12]==null)?"0":indicadorServicio[12]%>"><%= ((indicadorServicio[12]==null)?"0":indicadorServicio[12])+"%"%></td>								
							<% String checked = indicadorServicio[13];
							   String dato = ""; 
								   if(checked==null){dato = ""; }else if(checked.equals("S")){dato = "checked=\"checked\"";}
							 %>
							<td align="center"><input id="txtEstado<%=i%>" name="txtEstado<%=i%>" type="checkbox" disabled="disabled" <%=dato%> /></td>
							
						</tr>
							<%	
							i++;
							}
							%>
					</tbody>
					</table>
					<%}else{ %>
					<table align="center" width="100%" cellpadding="1" cellspacing="0" >
						<tr>
							<td class="titulo" align="center">No existen Indicadores</td>
						</tr>
					</table>
<%} %>		
		
			</div>
		</div>
		<div align="center">
		<table align="center">
			<tr>
				<td>
		<div   align="center" id="subdetalle" >
			<div id="detalle_solicitudes" class="etiqueta_formulario" align="center">Gestion de Meta Indicador</div>
		<table align="center" border="1">
			<thead>
				<tr>
					<td class="etiqueta_formulario">Nombre de oficina</td>
					<td><input id="txtOficina" name="txtOficina" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">ENERO : </td>
					<td><input id="txtEnero" name="txtEnero" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">FEBRERO : </td>
					<td><input id="txtFebrero" name="txtFebrero" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">MARZO : </td>
					<td><input id="txtMarzo" name="txtMarzo" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">ABRIL : </td>
					<td><input id="txtAbril" name="txtAbril" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">MAYO : </td>
					<td><input id="txtMayo" name="txtMayo" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">JUNIO :</td>
					<td><input id="txtJunio" name="txtJunio" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">JULIO : </td>
					<td><input id="txtJulio" name="txtJulio" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">AGOSTO : </td>
					<td><input id="txtAgosto" name="txtAgosto" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">SEPTIEMBRE : </td>
					<td><input id="txtSeptiembre" name="txtSeptiembre" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">OCTUBRE : </td>
					<td><input id="txtOctubre" name="txtOctubre" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">NOVIEMBRE : </td>
					<td><input id="txtNoviembre" name="txtNoviembre" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">DICIEMBRE : </td>
					<td><input id="txtDiciembre" name="txtDiciembre" type="text" onkeydown="myEventFunction(event, this,'');" value=""></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">ESTADO : </td>
					<td align="center"><input id="txtEstado" name="txtEstado"  type="checkbox"  /></td>
				</tr>
			</thead>
		</table>
		
		<table align="center">
			<tr> 
				<td align="center">
					<img  id="btnGuardar"  src="../../imagenes/guardar.png" onclick="guardar();">
					&nbsp;&nbsp;&nbsp;
					<img  id="btnEditar"  src="../../imagenes/editar1.png"  onclick="editarTabla();">
					&nbsp;&nbsp;&nbsp;
					<img  id="btnEliminar" src="../../imagenes/images1.jpg" onclick="eliminarTabla();" >
					&nbsp;&nbsp;&nbsp;
					<img  id="btnCancelar" src="../../imagenes/cancelar_disabled.png" onclick="cancelar();" >
				</td>
			</tr>
		</table>
		
			</div>
	</td>
			</tr>
		</table>
		</div>
	</form>
<%sA.cerrarSesionBD(); %>
	
</body>

</html>