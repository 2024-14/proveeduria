<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page errorPage="/paginas/general/error.jsp" %>
<%@ page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page import="com.conexion.Operacion"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xmlns:lang="es">
<!--
Creado por: CLS Viviana Estupiñan
Fecha: 13/06/2012
Comentario: JSP que realiza validaciones del login
Proyecto: [7336]-Inventario de Proveeduria
-->
<!--
Modificado por: CLS Viviana Estupiñan
Fecha: 02/12/2014
Comentario: JSP que realiza validaciones del login
Proyecto: [7336]-Inventario de Proveeduria
-->
<!--
Modificado por: CIMA Marlon Carangui
Fecha: 12/05/2015
Comentario: JSP que realiza validaciones del login
Proyecto: [x]-Portal de Proveeduria
-->
<%     
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);

	String error="";
	String logon="";
	String conn="";
	
	/*try{
		conn = request.getSession().getAttribute("PS_CONEXION").toString();
		System.out.println("Conexion? "+conn);
	}catch(Exception e){
		conn="false";
		System.out.println("No hay conexion!!" + e.getMessage());
	}*/
	
	try{
		logon=request.getSession().getAttribute("AUTH").toString();
	 	System.out.println("Logoneado? "+logon);
	}catch(Exception e){
		logon="false";
		System.out.println("No esta logoneado." + logon);
	}
	
	
%>
	<head>
 		<title>Portal&nbsp;de&nbsp;Proveedores</title>
 		<link href="../../css/estilo.css" rel="stylesheet"></link>
 		<style>
			input.uppercase{
			text-transform: uppercase;
			}
		</style>
		<script type="text/javascript">
		
			if("<%=conn%>" == "false" ){
				alert("No hay Conexion!!");
				window.open("../general/error.jsp",target="_self");
			}
			
			if("<%=logon%>" == "true"){
				//alert("ya esta logoneado");
				window.open("../protegido/frmMain.jsp",target="_self");
			}
			top.window.moveTo(0,0);
			if (document.all)
			{
			  top.window.resizeTo(screen.availWidth,screen.availHeight);
			}
			else{
			  if (document.layers||document.getElementById)
			  {
			    if(top.window.outerHeight<screen.availHeight||top.window.outerWidth<screen.availWidth)
			    {
			      top.window.outerHeight = screen.availHeight;
			      top.window.outerWidth = screen.availWidth;
			    }
			  }
			}
	
			var intentos = 0;
			
			function inicializar(){
				ventanaError();
				document.form1.txtUser.focus();
			}
			
			function ventanaError(){
				var error = document.form1.txtError.value;
				if(error!=""){
					var myWindow = window.alert(error);
					<% request.getSession().setAttribute("ERROR",""); %>
					//open("../general/errorGral.jsp", "ERROR", "width=400, height=100");
					//myWindow.blur();
				}		
			}
			
			function cerrar () {
				direccion="../general/cerrarConexion.jsp";
		   		var alto = (screen.availHeight-10)/2;
		    	var ancho =(screen.availWidth-10)/2; 
		    	ventana = window.open(direccion, "_blank", "left="+ancho+",top="+alto+",width=10, height=10, status=no, scroll=NO");
		   		ventana.focus();		        
		    	top.close();			    	
			}
			
			function ok() {
				debugger;
				var sociedad= document.form1.cmbSociedad.value;
				if (sociedad==""){
					alert("Debe escoger Sociedad.");
					return;
				}
			
				document.form1.txtUser.value = document.form1.txtUser.value.toUpperCase();
				document.form1.txtPassword.value = document.form1.txtPassword.value.toUpperCase();
				document.form1.submit();
				//mostrarOcultarElementos();
			}			
			
			function cambiaSociedad() {
				var estadoNew = document.form1.cmbSociedad.value;
	 		}
	 		
			function mostrarOcultarElementos() { //mostrar  
				  
				var sociedad= document.form1.cmbSociedad.value;
				if (sociedad==""){
					alert("Debe escoger Sociedad.");
					return;
				
				}
				
				document.form1.txtUser.value = document.form1.txtUser.value.toUpperCase();
				document.form1.txtPassword.value = document.form1.txtPassword.value.toUpperCase();
				//document.form1.submit();
				
				  var elemento1 = document.getElementById("correoUsuario_td");
				  var elemento2 = document.getElementById("correoUsuario1_td");
				  var elemento3 = document.getElementById("correoUsuario_input");
				  var elemento4 = document.getElementById("elemento4");
				  var elemento5 = document.getElementById("ingresarOTP_td");
				  var elemento6 = document.getElementById("ingresarOTP1_td");
				  var elemento7 = document.getElementById("ingresarOTP_input");
				 

				  //if (mostrar) {
				    elemento1.style.display = "table-cell";
				    elemento2.style.display = "table-cell";
				    elemento3.style.display = "table-cell";
					elemento4.style.display = "block";
				    elemento5.style.display = "table-cell";
				    elemento6.style.display = "table-cell";
				    elemento7.style.display = "table-cell";
				  //} else {
				    //elemento1.style.display = "none";
				    //elemento2.style.display = "none";
				    //elemento3.style.display = "none";
				  //}
				

				window.onload = function() {
				 mostrarOcultarElementos(false); // Oculta los elementos al cargar la página
				}
			}
				
			function mostrarOcultarElementos2() { //mostrar  
				  
				var sociedad= document.form1.cmbSociedad.value;
				if (sociedad==""){
					alert("Debe escoger Sociedad.");
					return;
				
				}
				
				document.form1.txtUser.value = document.form1.txtUser.value.toUpperCase();
				document.form1.txtPassword.value = document.form1.txtPassword.value.toUpperCase();
				//document.form1.submit();
				
				  var elemento1 = document.getElementById("correoUsuario_td");
				  var elemento2 = document.getElementById("correoUsuario1_td");
				  var elemento3 = document.getElementById("correoUsuario_input");
				  var elemento4 = document.getElementById("elemento4");
				  var elemento5 = document.getElementById("ingresarOTP_td");
				  var elemento6 = document.getElementById("ingresarOTP1_td");
				  var elemento7 = document.getElementById("ingresarOTP_input");
				 
				    elemento1.style.display = "table-cell";
				    elemento2.style.display = "table-cell";
				    elemento3.style.display = "table-cell";
					elemento4.style.display = "block";
				    elemento5.style.display = "table-cell";
				    elemento6.style.display = "table-cell";
				    elemento7.style.display = "table-cell";    

			 //if ((mostrar)== false) {
				 //elemento1.style.display = "none";
				   // elemento2.style.display = "none";
				    //elemento3.style.display = "none";
				    //elemento4.style.display = "bnone"		    
				    //elemento5.style.display = "none";
				    //elemento6.style.display = "none";
				    //elemento7.style.display = "none";
			// } else {
				//	     ventanaError();
				  //}
				

				window.onload = function() {
				 mostrarOcultarElementos2(false); // Oculta los elementos al cargar la página
				}
			}
			
		System.out.println(mostrarOcultarElementos2)
	</script>
</head>
<body onload="javascript:inicializar();">
	<table width="30%" align="center" cellpadding="0" cellspacing="0" border="0">
  		<tr>
  			<td width="100" height="100"><div style="width: 100;height: 100"></div></td>
  			<td></td>
  			<td width="100" height="100"></td>
  		</tr>
  		<tr>
  			<td width="100" height="100"><div style="width: 100;height: 100"></div></td>
  			<td class="portada" align="center">Portal&nbsp;Web&nbsp;Consolidado&nbsp;de&nbsp;Proveedur&iacute;a
  			<br/>de&nbsp;FIN&nbsp;Administraci&oacute;n</td>
  			<td width="20" height="50"></td>
  		</tr>   				
  		<tr>
  			<td width="100"><div style="width: 100;"></div></td>
  			<td align="center" >
  			<!--<form name="form1" METHOD="post" action="VerificaLogin.jsp" target="Oculto" >-->
			<form name="form1" method="post" action="VerificaLogin.jsp" target="_proceso">
			<input type="hidden" name="txtError" value="<%=error%>"/>
			<table  cellspacing="0" cellpadding="0" width="100%" border="0">
				<tr> 
			    	<td valign="top" width="100" height="150"></td>
				    <td valign="top" width="646" height="150" align="center">
				    	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				            <tr>
	              				<td>
	                  				<table cellspacing="1" cellpadding="2" width="100%" border="0">  
				                    	<tr > 
					                        <td class="etiqueta_formulario" width="10" height="10" align="right">Usuario:</td>
					                        <td width="150" class="etiqueta_formulario" height="30" align="center">
					                        	<input name="txtUser" type="text" class="uppercase" value="" maxlength="25"/></td>
				                     	</tr>
	                     				<tr> 
	                        				<td class="etiqueta_formulario" width="50" align="right" height="10">Clave:</td> 
	                        				<td  height="30" width="150" class="etiqueta_formulario" align="center"> 
		                          				<input name="txtPassword" type="password" class="uppercase" maxlength="40"/>
	                          				</td>
	                    				</tr>
	                    				<tr> 
	                        				<td class="etiqueta_formulario" width="10" align="right" height="10">Sociedad:</td> 
	                        				<td  height="30" width="150" class="etiqueta_formulario" align="center"> 
	                        				    <select id="cmbSociedad"  name="cmbSociedad" onchange="javascript:cambiaSociedad();">
		                          					<%
		                          					
		                          					Operacion op = new Operacion(pContext);
													List<String[]> lSociedad = op.getSociedad();
													
													
													for(String[] sociedad_u : lSociedad){	
													%>	
														<option value="<%=sociedad_u[0]%>" selected="selected"><%=sociedad_u[1]%></option>
													<%}%> 
													<%String band = op.Band_soc();
													op.cerrarSesionBD();
													if (band.equals("N")){%>
		                          					<option value="" selected="selected">Seleccionar Sociedad</option> 
		                          					<%}%>
												</select>
	                          				</td>
	                    				</tr>
	                    				<tr > 
					                        <td id="correoUsuario_td" class="etiqueta_formulario" width="10" height="10" align="right" style="display: none;"> Correo de Usuario</td> <!-- style="display: none; -->
					                        <td id="correoUsuario1_td" width="150" class="etiqueta_formulario" height="30" align="center" style="display: none;"> 
					                        	<input id="correoUsuario_input" name="txtOtp" type="text" class="LowerCase" value="" maxlength="25" style="display: none;" placeholder="sudamericana@sasf.com"> 
				                     			<button id="elemento4" style="display: none;" onclick="mostrarOcultarElementos(true);"> Enviar código </button> <!-- onclick="mostrarOcultarElementos(true) -->
				                     	</tr>
	                    				<tr > 
					                        <td id="ingresarOTP_td" class="etiqueta_formulario" width="10" height="10" align="right" style="display: none;"> Ingresar código OTP:</td>
					                        <td id="ingresarOTP1_td" width="150" class="etiqueta_formulario" height="30" align="center" style="display: none;">
					                        	<input id="ingresarOTP_input" name="txtOtp" type="text" class="uppercase" value="" maxlength="25" style="display: none;">
				                     			
				                     	</tr>
	                    				<tr>
	                        				<td width="150"><center><a href="#" onclick="ok();">
	            			  					<img src="../../imagenes/btnaceptar1.gif" name="Image148211" border="0" height="44" width="44"/></a></center></td>
		                        			<td width="150"><center><a href="#" onclick="cerrar();">
				              					<img src="../../imagenes/btncancelar1.gif" name="Image1481111" border="0" height="48" width="44"/></a></center></td>
	                   					</tr>
	                  				</table>
	                			</td>	                			
	            			</tr>
	          			</table> 
      				</td>  
      				<td valign="top" width="100" height="150"></td>    				
  				</tr>  				
			</table>
			</form>
			</td>
			<td width="100" height="150">&nbsp;</td>
		</tr>
		<tr>
			<td width="100" height="100"><div style="width: 100;height: 100">&nbsp;</div></td>
			<td height="100">&nbsp;</td>
			<td valign="middle" width="100" height="100"><img src="../../imagenes/LOGO_CLARO.JPG" width="90" height="80"></img></td>
		</tr>
	</table>
</body>
</html>


 
