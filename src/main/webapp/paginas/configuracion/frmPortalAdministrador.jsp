<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion" %>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<%
	Operacion op = new Operacion(pageContext);
	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
%> 
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
 <title>Administraci&oacute;n del Portal</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>

<script type="text/javascript" src="../../js/jquery.tablesorter.js"></script>

		
<style type="text/css">

	#subdetalle2{
	border: 1px solid #C81414;
	margin: 50px;
	width: 300px;
	}

	#detallePortalAdmin{
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
var grabar = "S";
var editar = "N";
var borrar = "N";

	$(document).ready(function(){
		$('#insertar').click(function(){insertar();});
		$('#cancelar').click(function(){cancelar();});
		$('#actualizar').click(function(){actualizar();});
		$('#eliminar').click(function(){eliminar();});
		loadPortal();
		document.frmProv1.Txtsociedad.value = '<%=nombreSociedad%>';	
	});
	
	function loadPortal(){
		$('#detallePortalAdmin').load("../configuracion/frmDetallePortalAdmin.jsp");	
	}
	
	function mayuscula(campo){
		campo.value=campo.value.toUpperCase();
	}  
		
	function verificaLogin(atributo){
		if (atributo == "false"){
			alert("Debe ingresar con su usuario");
			window.open("../login/frmLogin.html", "_self");
		}
	}
	
	
	function cargar(index){
		var i=0;
		var length = document.frmProv.elements.length;
		for (i=0; i < length; i++ ){
			if (document.frmProv.elements[i].name=="txtUsuario"+index){
					document.frmProv1.Usuario.value = document.frmProv.elements[i].value;
			}
			if (document.frmProv.elements[i].name=="txtClave"+index){
					document.frmProv1.Txtclave.value = document.frmProv.elements[i].value;
			}
			if (document.frmProv.elements[i].name=="txtRol"+index){
					document.frmProv1.Txtrol.value = document.frmProv.elements[i].value.substring(0,1);
			}
			if (document.frmProv.elements[i].name=="txtSociedad"+index){
					document.frmProv1.Txtsociedad.value = document.frmProv.elements[i].value;
			}
			if (document.frmProv.elements[i].name=="txtCorreo"+index){
				if(document.frmProv.elements[i].value.toString() == "null"){
					document.frmProv1.Txtcorreo.value = "";
				}else{	
					document.frmProv1.Txtcorreo.value = document.frmProv.elements[i].value;
				}
			}
			if (document.frmProv.elements[i].name=="txtRuc"+index){
				if(document.frmProv.elements[i].value.toString() == "null"){
					document.frmProv1.Txtruc.value = "";
				}else{	
					document.frmProv1.Txtruc.value = document.frmProv.elements[i].value;
				}
			}
			if (document.frmProv.elements[i].name=="txtEstatus"+index){
					document.frmProv1.Txtestado.value = document.frmProv.elements[i].value.substring(0,1);
			}
		}
		
		document.frmProv1.Usuario.disabled= true;
		grabar = "N";
		editar = "S";
		borrar = "S";
	}
		
	function insertar(index){
		if(grabar=="S"){
			var cadena = "";
			var usuario = document.frmProv1.Usuario.value;
			usuario = usuario.replace(/ /gi,"");
			
			var clave = document.frmProv1.Txtclave.value;
			clave = clave.replace(/ /gi,"");
			 
			var rol = document.frmProv1.Txtrol.value;
			var sociedad = document.frmProv1.Txtsociedad.value;
			var correo = document.frmProv1.Txtcorreo.value;
			var estado = document.frmProv1.Txtestado.value;
			var ruc = document.frmProv1.Txtruc.value;
			ruc = ruc.replace(/ /gi,"");
			
	
			cadena = cadena + usuario +"|"+ clave +"|"+rol+"|"+sociedad+"|"+correo+"|"+estado+"|"+ruc+"|";
				
			var ruta = "../configuracion/ejecutaInsert.jsp?&pCadena=" + cadena;
		    
			if ( usuario == "" || clave == "") {
				alert("usuario y/o clave vacias.");
				return;
			}else if ( rol== "P" && ruc == "" )
			{
				alert("Ruc es obligatorio.");
				return;
			}else{
				//window.open(ruta, "popup", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");
				$('#detalle_menu').load(ruta);
			}
		}else{
			alert("No puede ingresar Usuario ya Existente.");
		}
	}
		

	function actualizar(){
		if(editar=="S"){
			var cadena = "";
			var usuario = document.frmProv1.Usuario.value;
			var clave = document.frmProv1.Txtclave.value;
			clave = clave.replace(/ /gi,"");
			
			var rol = document.frmProv1.Txtrol.value;
			var sociedad = document.frmProv1.Txtsociedad.value;
			var correo = document.frmProv1.Txtcorreo.value;
			var estado = document.frmProv1.Txtestado.value;
			var ruc = document.frmProv1.Txtruc.value;
			ruc = ruc.replace(/ /gi,"");
			
			cadena = cadena + usuario +"|"+ clave +"|"+rol+"|"+sociedad+"|"+correo+"|"+estado+"|"+ruc+"|";
			var ruta = "../configuracion/actualizaInsert.jsp?&pCadena=" + cadena;
		    var ancho = 340;
		    var alto  = 180;
			var posicion_x; 
			var posicion_y; 
			posicion_x=(screen.width/2)-(ancho/2); 
			posicion_y=(screen.height/2)-(alto/2);
			
			if ( usuario == "" || clave == "") {
				alert("usuario y/o clave vacias.");
				return;
			}else if ( rol== "P" && ruc == "" )
			{
				alert("Ruc es obligatorio.");
				return;
			}else{
				//window.open(ruta, "popup", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");
				$('#detalle_menu').load(ruta);
			}
		}else{
			alert("Debe seleccionar un Usuario para poder modificarlo.");
		}	
	}
	
	
	function eliminar(){
		if(borrar=="S"){
			var usuario = document.frmProv1.Usuario.value;
			var ruta = "../configuracion/ejecutaDelete.jsp?&pUsuario=" + usuario;
			var respuesta= confirm("Esta seguro de Eliminar el usuario "+usuario);
			if(!respuesta)return;
			//window.open(ruta, "popup", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");
			$('#detalle_menu').load(ruta);
		}else{
			alert("Debe seleccionar un Usuario para eliminar.");
		}	
	}
		
	function cancelar(atributo){
		document.frmProv1.Usuario.value="";
		document.frmProv1.Txtclave.value="";
		document.frmProv1.Txtcorreo.value="";
		document.frmProv1.Txtruc.value="";
		document.frmProv1.Usuario.disabled=false;
		grabar = "S";
		editar = "N";
		borrar = "N";
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
	<form name="frmProv1"> 
		<div class="titulo_tabla" >
			Administración de Accesos al Portal	
		</div>
		<div id="subdetalle">
			<div class="etiqueta_formulario" >
				Detalles de los usuarios
			</div>
			<div  id="detallePortalAdmin"></div>
		</div>
		
		<div align="center">
		<table align="center">
			<tr>
				<td>
		<div   align="center" id="subdetalle" >
			<div id="detalle_solicitudes" class="etiqueta_formulario" align="center">Gestion de Usuarios</div>
		<table align="center" border="1">
			<thead>
				<tr>
					<td class="etiqueta_formulario">Usuario :</td>
					<td>
						<input size="30" type="text" id="Usuario" name="Usuario" onchange="mayuscula(this);" onkeypress="mayuscula(this);"/>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Clave : </td>
					<td>
						<input  type="text" id="Txtclave" name="Txtclave" size="30" onchange="mayuscula(this);" onkeypress="mayuscula(this);"/>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Rol : </td>
					<td>
						<select style="width: 100%;" id="Txtrol" name="Txtrol">
				          	<option value="P" >Proveedor</option>
							<option value="A" >Administrador</option>
							<option value="G" >Gerente</option>
							<option value="S" >Supervisor</option>
							<option value="J" >Jefatura</option>
					 	</select>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Sociedad: </td>
					<td>
						<select style="width: 100%;" id="Txtsociedad"  name="Txtsociedad" disabled="disabled" >
						<%
						List<String[]> lSociedad = op.getSociedad();
						for(String[] sociedad : lSociedad){	
						%>	
							<option value="<%=sociedad[0]%>" selected="selected"><%=sociedad[1]%></option>
						<%}%> 
						</select>
					</td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Correo : </td>
					<td><input size="30" type="text" id="Txtcorreo" name="Txtcorreo"/></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Ruc : </td>
					<td><input size="30" type="text" id="Txtruc" name="Txtruc" maxlength="13"/></td>
				</tr>
				<tr>
					<td class="etiqueta_formulario">Estado : </td>
					<td>
					  <select style="width: 100%;" id="Txtestado" name="Txtestado">
			          	<option value="A" selected="selected">Activo</option>
						<option value="I" >Inactivo</option>
					 </select>
				   </td>
				</tr>
			</thead>
		</table>
		
		<table width="100%">
			<tr align="center" >
				<td align="center">
					<img id="insertar" src="../../imagenes/guardar.png" alt="" />
					&nbsp;&nbsp;&nbsp;
					<img id="actualizar" src="../../imagenes/editar1.png" alt="" />
					&nbsp;&nbsp;&nbsp;
					<img id="eliminar" src="../../imagenes/images1.jpg" alt="" />
					&nbsp;&nbsp;&nbsp;
					<img id="cancelar" src="../../imagenes/cancelar_disabled.png" alt="" />
				</td>
			</tr>
		</table>	
	</div>
	</td>
			</tr>
		</table>
		</div>
		
	</form>
</body> 
		<%op.cerrarSesionBD(); %>
</html>