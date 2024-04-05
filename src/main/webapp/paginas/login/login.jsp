<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page errorPage="/paginas/general/error.jsp" %>
<%@ page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page import="com.conexion.Operacion"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xmlns:lang="es">

<!--
Creado por: CLS Viviana Estupi�an
Fecha: 13/06/2012
Comentario: JSP que realiza validaciones del login
Proyecto: [7336]-Inventario de Proveeduria
-->
<!--
Modificado por: CLS Viviana Estupi�an
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
	String correo = "";
	
	/*try{
		conn = request.getSession().getAttribute("PS_CONEXION").toString();
		System.out.println("Conexion? "+conn);
	}catch(Exception e){
		conn="false";
		System.out.println("No hay conexion!!" + e.getMessage());
	}*/
	
	try{
		logon=request.getSession().getAttribute("AUTH").toString();
		correo=request.getSession().getAttribute("CORREO").toString();
	 	System.out.println("Logoneado? "+logon);
	}catch(Exception e){
		logon="false";
		System.out.println("No esta logoneado." + logon);
	}
	
	
%>
	<head>
 		<title>Portal&nbsp;de&nbsp;Proveedores</title>
 		<link href="../../css/estilo.css" rel="stylesheet"></link>
 		<script src="jquery-3.7.1.min.js"> </script>
 		
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
				revisar_logon();
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
				
			function mostrarOcultarElementos2() { //mostrar  
				  
				var sociedad= document.form1.cmbSociedad.value;
				if (sociedad==""){
					alert("Debe escoger Sociedad.");
					return;
				
				}
				
				document.form1.txtUser.value = document.form1.txtUser.value.toUpperCase();
				document.form1.txtPassword.value = document.form1.txtPassword.value.toUpperCase();
				//document.form1.submit();
				
								
				  var elemento5 = document.getElementById("ingresarOTP_td");
				  var elemento6 = document.getElementById("ingresarOTP1_td");
				  var elemento7 = document.getElementById("ingresarOTP_input");
				  var elemento8 = document.getElementById("elemento8");
				  var elemento9 = document.getElementById("elemento9");
	  			   
				    elemento5.style.display = "table-cell";
				    elemento6.style.display = "table-cell";
				    elemento7.style.display = "table-cell"; 
				    elemento8.style.display = "block";
				    elemento9.style.display = "block";

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
			 
				 document.getElementById("btnaceptar").hidden = true;
				 //document.getElementById("btnReenviar").hidden;
				
			     ingresarOTP_input.value = "";
				
			}
			
			
			
			
			function valideKey(evt){	
				// El c�digo es la representaci�n decimal ASCII de la tecla presionada.
				var code = (evt.which) ? evt.which : evt.keyCode;
				
				if(code==8) { // retroceso.
				  return true;
				} else if(code>=48 && code<=57) { // is a number.
				  return true;
				} else{ // other keys.
					 alert("Solo se permiten n�meros");
				  return false;
				}
			}
			
			function validarBoton() {
				  var input = document.getElementById("ingresarOTP_input");
				  var button = document.getElementById("elemento8");

				  
				  // Verifica si el input tiene 6 n�meros
				    if (input.value.length === 6) {
				    	 //button.disabled = false;
				        document.getElementById("elemento8").disabled = false;
				  } else{
				    	 //button.disabled = false;
				        document.getElementById("elemento8").disabled = true;
				  }
				    //document.form1.submit();
			}
			
			
			
			function holas(){
				var h = $("#txtUser").val();
				alert(h);
			}
			
			
			function validarBoton2(){
				 
				    var ls_usuario = $("#txtUser").val(); // Reemplace con su l�gica para obtener valor para el usuario
				    var ls_correo = $("#txtCorreo").val(); // Reemplace con su l�gica para obtener valor de correo 
				    var ls_codigo = $("#txtPass").val(); // Obtener c�digo del valor de entrada
				   
				    console.log(ls_correo);

				    $.ajax({
				      url: "RevisarCodigo.jsp", // Reemplace con la URL de su servlet
				      type: "POST",
				      data: {
				        usuario: ls_usuario,
				        correo: ls_correo,
				        codigo: ls_codigo,
				        //procedimiento: "SAP.SAP_PORTAL_PROV.SWP_CONSULTAR_CODIGO_OTP"
				      },
				      success: function(respuesta) {
				        // Respuesta del proceso del servlet
				        if (respuesta.resultado === "success") {
				          // Redirigir a p�gina protegida
							alert("entro a la pagina");
//				          window.location.href = "../protegido/frmMain.jsp";
				        } else {
				          // Mostrar mensaje de error
							alert("entro a la pagina de error");
				          alert("Error: " + respuesta.error);
				        }
				        //button.clicked = false; // Bot�n de reinicio hecho clic en la bandera para el pr�ximo uso
				      },
				      error: function(error) {
				        console.error("Error calling stored procedure:", error);
				      }
				    });
				  
				}
			

				
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
					                        	<input id="txtUser" name="txtUser" type="text" class="uppercase" value="" maxlength="25"/></td>
					                        	
					                        	<input id="txtCorreo" name="txtCorreo" type="hidden" />
				                     	</tr>
	                     				<tr> 
	                        				<td class="etiqueta_formulario" width="50" align="right" height="10">Clave:</td> 
	                        				<td  height="30" width="150" class="etiqueta_formulario" align="center"> 
		                          				<input id="txtPass" name="txtPassword" type="password" class="uppercase" maxlength="40"/>
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
													if (band.equals("N")){%>
		                          					<option value="" selected="selected">Seleccionar Sociedad</option> 
		                          					<%}%>
												</select>
	                          				</td>
	                    				</tr>
	                    			        	<%op.cerrarSesionBD();%>         			                 			
	                    				<tr > 
					                        <td id="ingresarOTP_td" class="etiqueta_formulario" width="10" height="10" align="right" style="display: none;"> Ingresar c�digo OTP:</td>
					                        <td id="ingresarOTP1_td" width="150" class="etiqueta_formulario" height="30" align="center" style="display: none;">
					                        	<input style="margin-top:10px;" id="ingresarOTP_input" name="txtOtp" type="text"  pattern="[0-9]+" class="uppercase" value="" maxlength="6" style="display: none;" onkeyup="validarBoton()" onkeypress="return valideKey(event); ">
				                     		     <br />
				                     			<button style="margin-top:10px; margin-bottom:10px; " id="elemento8" type="button"  name="btnValidar" style="display: none;"  onclick="validarBoton2();" disabled>Validar C�digo</button>			              
				                     			</td>

				                     	</tr>
				                     					                    
	                    				<tr>
	                    				
	                        				<td width="150" ><center>
	                        					<a href="#" id="btnaceptar" onclick="ok();"> 
	            			  						<img src="../../imagenes/btnaceptar1.gif" name="Image148211" border="0" height="44" width="44" />
	            			  					</a>
	            			  					
	            			  					<a href="#" id="btnReenviar" onclick="holas();" hidden>
				              						<img src="../../imagenes/btnReenviar.jpg" name="Image15000" border="0" height="44" width="44" />
				              					</a>
	            			  					
	            			  					
	            			  					</center>
	            			  				</td>		                  			
		                        			   
		                        			<td width="150"><center><a href="#" onclick="cerrar();">
				              					<img src="../../imagenes/btncancelar1.gif" name="Image1481111" border="0" height="48" width="44"/></a></center></td>
	                   					    
	                   					</tr>                   			
	                   					<tr>
	                   					
	                   					<td width="150" style="margin-top:15px;" id="" ><center><a href="#" id="btnReenviar">
				              					<img src="../../imagenes/btnReenviar.jpg" name="Image15000" border="0" height="50" width="50" style="display: none;"/></a></center></td>
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
	
	<script type="text/javascript">
	
	
 	function revisar_logon(){
 		if("<%=logon%>" == "true"){ 
 			 
 			//alert("ya esta logueado");
 			//alert(correos);
 			//mostrarOcultarElementos2();
 			
 			//window.open("../protegido/frmMain.jsp",target="_self");
 		    
 			var sociedad= document.form1.cmbSociedad.value;
 			if (sociedad==""){
 				alert("Debe escoger Sociedad.");
 				return;
 			}
 			
 			document.form1.txtUser.value = document.form1.txtUser.value.toUpperCase();
 			document.form1.txtPassword.value = document.form1.txtPassword.value.toUpperCase();
 			//document.form1.submit();
 			
 							
 			  var elemento5 = document.getElementById("ingresarOTP_td");
 			  var elemento6 = document.getElementById("ingresarOTP1_td");
 			  var elemento7 = document.getElementById("ingresarOTP_input");
 			  var elemento8 = document.getElementById("elemento8");
 			  var elemento9 = document.getElementById("btnReenviar");
 				   
 			    elemento5.style.display = "table-cell";
 			    elemento6.style.display = "table-cell";
 			    elemento7.style.display = "table-cell"; 
 			    elemento8.style.display = "block";
 			    elemento9.style.display = "block";
 			    
 			 $("#txtCorreo").val("<%=correo%>");
 			   

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
 		  
 			 document.getElementById("btnaceptar").hidden = true;
 			document.getElementById("btnReenviar").hidden = false;
 			 //document.getElementById("btnReenviar").hidden = true;
 		     ingresarOTP_input.value = "";
 		}
 		
 	}
	
	

</script>
	
</body>



</html>


 
