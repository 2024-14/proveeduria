<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"%>
<%@ page import="com.conexion.Operacion"%>
<%@page import="java.util.List"%>
<%@ page errorPage="../general/errorGral.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	Operacion op = new Operacion(pContext); 
		
	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	String rol = "";
	String disable = "disabled=\"disabled\"";
	String ls_tipo_usuario = request.getSession()
				.getAttribute("PS_ROL").toString();
	if(ls_tipo_usuario.equals("G")||ls_tipo_usuario.equals("S")){
		disable="";
	}				
	String select = "";
		
 %>
 <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
 <title>Mantenedor Usuario y Ubicacion</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>

<script type="text/javascript" src="../../js/jquery.tablesorter.js"></script>

	
<style type="text/css">
	#consulta, #detalle_consulta, #subdetalle{
		border: 1px solid #C81414;
		margin: 10px;
	}
	#subdetalle1{
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
	#detalle_mantenedor2{
		max-height: 300px;
		overflow: auto;
	}
	
	.etiqueta_formulario_1{
		font-family:"Arial, Verdana";
		font-size:20px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
	#detalle_mantenedor{
		max-height: 150px;
		overflow: auto;
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
var guardar="N";
	$(document).ready(function(){
		$("#tbMantenedorUsuarioUbicacion").tablesorter(); 
		$('#btnGuardar').click(function(){
			grabar();
		
		});
		cargarDetalle();
		document.frmMantenedorUbicaciones.txtSociedad.value = '<%=nombreSociedad%>';
	});	

	function grabar() {
		if( guardar=="S"){
			var usuario = "";
			var nombreOficina = "";
			var piso = "";
			var direccion = "";
			var region = "";
			var ceco = "";
			var areaEmpresa = "";
			var estatus = "";
			var sociedad = "";
			var guiaRemison = "";
			var checkedGuiaRemision = "";
			var codigoUsuario ="";
			var detUsuarioUbicacion = document.frmMantenedorUbicaciones.elements.length;
			var cadena = "";
			var linea = 0;
			
			for (var i = 0; i < detUsuarioUbicacion; i++) {
				//linea = 0;
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtCodUsuario") {
					codigoUsuario = document.frmMantenedorUbicaciones.elements[i].value;
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtUsuario") {
					usuario = document.frmMantenedorUbicaciones.elements[i].value;
					usuario = usuario.replace(/ /gi,"~");
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtOficina") {
					nombreOficina = document.frmMantenedorUbicaciones.elements[i].value;
					nombreOficina = nombreOficina.replace(/ /gi,"~");
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtPiso") {
					piso = document.frmMantenedorUbicaciones.elements[i].value;
					piso = piso.replace(/ /gi,"~");
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtDireccion") {
					direccion = document.frmMantenedorUbicaciones.elements[i].value;
					direccion = direccion.replace(/ /gi,"~");
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtRegion") {
					region = document.frmMantenedorUbicaciones.elements[i].value;
					region = region.replace(/ /gi,"~");
					if ( region == "" ) {
						alert("Debe ingresar Region.");
						return;
					}
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtCeco") {
					ceco = document.frmMantenedorUbicaciones.elements[i].value;
					ceco = ceco.replace(/ /gi,"~");
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtArea") {
					areaEmpresa = document.frmMantenedorUbicaciones.elements[i].value;
					areaEmpresa = areaEmpresa.replace(/ /gi,"~");
					if ( areaEmpresa == "" ) {
						alert("Debe ingresar el Area.");
						return;
					}
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtEstado") {
					estatus = document.frmMantenedorUbicaciones.elements[i].value;
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtSociedad") {
					sociedad = document.frmMantenedorUbicaciones.elements[i].value;
					if(sociedad!=""){
						sociedad = "<%=nombreSociedad%>";
					}
				}
				
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtGuiaRemision") {
					checkedGuiaRemision = document.frmMantenedorUbicaciones.elements[i].checked;
					if(checkedGuiaRemision==true){
						guiaRemison = "S";
					}else{
						guiaRemison = "N";
					}
					linea = 1;
				}
					
				if(linea == 1){	
					cadena = cadena+codigoUsuario+'|'+usuario+"|"+nombreOficina+"|"+piso+"|"+direccion+"|"+region+"|"+ceco+"|"+areaEmpresa+"|"+estatus+"|"+sociedad+"|"+guiaRemison+"|";
					usuario = "";
					nombreOficina = "";
			    	piso = "";
					direccion = "";
					region = "";
					ceco = "";
					areaEmpresa = "";
					estatus = "";
					sociedad = "";
					guiaRemison = "";
					checkedGuiaRemision = "";
					codigoUsuario ="";
					linea = 0;
				}
	
			}//end for
			
			var ruta = "../configuracion/ejecutaMantenedor.jsp?pCadena="+cadena;
			$('#detalle_menu').load(ruta);
			
			/*
			var ancho = 340;
		    var alto  = 180;
			var posicion_x=(screen.width/2)-(ancho/2);
			var posicion_y=(screen.height/2)-(alto/2);
			window.open(ruta, "popup", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");
			*/
			//ventana = window.open(ruta,/*"popup","width=2,height=2"*/target="_bandeja");
			//alert("AKI");target=
			//ventana.close();
			//location.reload(true);
			//window.location.reload(true);
			//for(i=0;i<index;i++){
			//}
			//alert("Mantendor Usuario Ubicacion");
			//$('#detalle_menu').load("../configuracion/frmMantenedorUsarioUbicacion.jsp");
			
			//document.frmMantenedorUbicaciones.txtCodUsuario.value="";
			//document.frmMantenedorUbicaciones.txtUsuario.value="";
			//document.frmMantenedorUbicaciones.txtCeco.value="";
			
			//cancelar();
		}else{
			alert("Debe seleccionar un usuario para guardar.");
		}
	}
	
	function cancelar(atributo){
		document.frmMantenedorUbicaciones.txtOficina.value="";
		document.frmMantenedorUbicaciones.txtPiso.value="";
		document.frmMantenedorUbicaciones.txtDireccion.value="";
		document.frmMantenedorUbicaciones.txtRegion.value="";
		document.frmMantenedorUbicaciones.txtArea.value="";
		document.frmMantenedorUbicaciones.txtEstado.value="A";
	}
	function mayuscula(campo){
		campo.value=campo.value.toUpperCase();
	}
	
	
	
	function cargarDetalle(){
	
		var ruta = '../configuracion/frmdetalleMantenedorUsuariosNuevos.jsp';
		$('#detalle_mantenedor').load(ruta);
		
		var ruta = '../configuracion/frmdetalleMantenedorUsuarioUbicacion.jsp';
		$('#detalle_mantenedor2').load(ruta);
		
		
	}
	
	function cargar(index){
	
	var detUsuarioUbicacion = document.frmMantenedorUbicaciones.elements.length;
	//alert(detUsuarioUbicacion);
	for (var i = 0; i < detUsuarioUbicacion; i++) {
			//linea = 0;
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtCodUsuario"+index) {
				document.frmMantenedorUbicaciones.txtCodUsuario.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtUsuario"+index) {
				document.frmMantenedorUbicaciones.txtUsuario.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtOficina"+index) {
				document.frmMantenedorUbicaciones.txtOficina.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtPiso"+index) {
				document.frmMantenedorUbicaciones.txtPiso.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtDireccion"+index) {
				document.frmMantenedorUbicaciones.txtDireccion.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtRegion"+index) {
				document.frmMantenedorUbicaciones.txtRegion.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtCeco"+index) {
				document.frmMantenedorUbicaciones.txtCeco.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtArea"+index) {
				document.frmMantenedorUbicaciones.txtArea.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtEstado"+index) {
				document.frmMantenedorUbicaciones.txtEstado.value = document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtSociedad"+index) {
				document.frmMantenedorUbicaciones.txtSociedad.value = "<%=nombreSociedad%>";
				//document.frmMantenedorUbicaciones.elements[i].value;
			}
			if (document.frmMantenedorUbicaciones.elements[i].name == "txtGuia"+index) {
				document.frmMantenedorUbicaciones.txtGuiaRemision.checked = document.frmMantenedorUbicaciones.elements[i].checked;
			}
		}
	guardar="S";
	}
	
	function cargarN(index){
		var detUsuarioUbicacion = document.frmMantenedorUbicaciones.elements.length;
		for (var i = 0; i < detUsuarioUbicacion; i++) {
				//linea = 0;
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtCodUsuarioN"+index) {
					document.frmMantenedorUbicaciones.txtCodUsuario.value = document.frmMantenedorUbicaciones.elements[i].value;
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtUsuarioN"+index) {
					document.frmMantenedorUbicaciones.txtUsuario.value = document.frmMantenedorUbicaciones.elements[i].value;
				}
			
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtCecoN"+index) {
					document.frmMantenedorUbicaciones.txtCeco.value = document.frmMantenedorUbicaciones.elements[i].value;
				}
				if (document.frmMantenedorUbicaciones.elements[i].name == "txtSociedadN"+index) {
					document.frmMantenedorUbicaciones.txtSociedad.value = "<%=nombreSociedad%>";
				}
			}
		cancelar();
		guardar="S";
		}
	
	public void cerrarSesionBD() throws Exception {
        try {
            if (this.m_conn != null) {
                this.m_conn.close();
            }
            if (this.m_conn_sesion != null) {
                this.m_conn_sesion.close();
            }
            this.m_session.setAttribute("PS_CONEXION", (Object)null);
        }
        catch (Exception e) {
            e.getStackTrace();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
    }
</script>
</head>
<body>

	<form name="frmMantenedorUbicaciones" >

	<div class="titulo_tabla" >Mantenedor de Usuario y Ubicación </div>
		<div id="subdetalle1" >
			<div class="etiqueta_formulario" >Usuarios Nuevos</div>
			<div id="detalle_mantenedor"></div>
		</div>
		<div id="subdetalle" >
			<div class="etiqueta_formulario" >Detalles de Usuarios y Ubicaciones</div>
			<div id="detalle_mantenedor2"></div>
		</div>
		
			<div align="center">
		<table align="center">
			<tr>
				<td>
		<div   align="center" id="subdetalle" >
			<div id="detalle_solicitudes" class="etiqueta_formulario" align="center">Gestion de Usuario y Ubicacion</div>
			<table align="center" border="1">
				<tr>
					<td class="etiqueta_formulario">Codigo Usuario :</td>
					<td >
						<input style="width: 100%;" id="txtCodUsuario" name="txtCodUsuario" disabled="disabled" >
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Nombre Usuario :</td>
					<td>
						<input style="width: 100%;" id="txtUsuario" name="txtUsuario" >
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Nombre Oficina :</td>
					<td >
						<input style="width: 100%;" id="txtOficina" name="txtOficina">
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario" >Piso : </td>
					<td><input style="width: 100%;" id="txtPiso" name="txtPiso" ></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario" >Direccion : </td>
					<td><input style="width: 100%;" id="txtDireccion" name="txtDireccion" ></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Region :</td>
					<td>
						<select style="width: 100%;"  id="txtRegion"  name="txtRegion" >
							<option value="R1" >R1</option>
							<option value="R2" >R2</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Ceco :</td>
					<td>
						<input style="width: 100%;" id="txtCeco" name="txtCeco"  disabled="disabled">
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Area de empresa :</td>
					<td>
						<select style="width: 100%;" id="txtArea"  name="txtArea">
							<%
							List<String[]> lareas = sA.ObtieneAreas();
							for(String[] lareas_u : lareas){	
							%>	
								<option value="<%=lareas_u[0]%>"><%=lareas_u[1]%></option>
							<%}%> 
						</select>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Estado :</td>
					<td>
						<select style="width: 100%;" id="txtEstado"  name="txtEstado" >
							<option value="A" >ACTIVO</option>
							<option value="I" >INACTIVO</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Sociedad :</td>
					<td>
						<select style="width: 100%;" id="txtSociedad"  name="txtSociedad" disabled="disabled" >
						<%
						List<String[]> lSociedad = op.getSociedad();
						for(String[] sociedad_u : lSociedad){	
						%>	
							<option value="<%=sociedad_u[0]%>" selected="selected"><%=sociedad_u[1]%></option>
						<%}%> 
						</select>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario" >Guia Remision</td>
					<td align="center">
						<input style="width: 100%;" type="checkbox" id="txtGuiaRemision" name="txtGuiaRemision" >
					</td>
				</tr>
			</table>
			<table align="center">
				<tr>
					<td><img  id="btnGuardar"  src="../../imagenes/guardar.png"></td>
				</tr>
			</table>
		
			</div>
	</td>
			</tr>
		</table>
		</div>
		
	</form>
</body>
	<%sA.cerrarSesionBD(); %>
</html>