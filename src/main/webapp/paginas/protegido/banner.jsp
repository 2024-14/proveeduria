<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Locale"%>
<%@ page import="com.conexion.ServiciosAdministrador"%>
<%@ page errorPage="../general/errorGral.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">
<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	//Operacion op = new Operacion(pContext);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	String ls_tipo_usuario = session.getAttribute("PS_ROL").toString();

	Date ahora = new Date();
    SimpleDateFormat formateador = new SimpleDateFormat("dd-MMMM-yyyy", new Locale("es_ES"));
    String date=formateador.format(ahora);
 %>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"></meta>
	<link href="../../css/estilo.css" rel="stylesheet"></link>
	<script type="text/javascript">
	function startTime() {
	    var today=new Date();
	    var h=today.getHours();
	    var m=today.getMinutes();
	    var s=today.getSeconds();
	    m = checkTime(m);
	    s = checkTime(s);
	    document.getElementById('txt').innerHTML = h+":"+m+":"+s;
	    var t = setTimeout(function(){startTime()},500);
	}

	function checkTime(i) {
	    if (i<10) {i = "0" + i};  // add zero in front of numbers < 10
	    return i;
	}
		function cerrarSesion(){
			/*direccion="../general/cerrarConexion.jsp";
	   		var alto = (screen.availHeight-10)/2;
	    	var ancho =(screen.availWidth-10)/2; 
	    	ventana = window.open(direccion, "_blank", "left="+ancho+",top="+alto+",width=10, height=10, status=no, scroll=NO");
	   		ventana.focus();		        
	    	top.close();
	    	ventana.close();
	    	top.open("../login/frmLogin.html","_self");   
	    	*/
			top.open("../general/cerrarConexion.jsp","_self");   
	    	
		}
		 
	</script>
	<style>
	.estilo2{font-family: "Arial, Verdana";
font-size: 12pt;
font-weight: bold;
color: graytext;}
	</style>
</head>
<body onload="startTime()">
	<table width="100%" border="0" align="center">
		<tr>
			<td width="15%" align="center"><img src="../../imagenes/LOGO_CLARO.JPG" width="80" height="80" hspace="0" vspace="0"/></td>
			<td width="85%">
				<table align="center" border="0" width="100%">
					<tr align="center">
						<td class="portada" align="right" width="12.5%">Bienvenido&nbsp;</td>
						<%
						if (ls_tipo_usuario.equals("A")){%>
						<!--<td class="estilo1" align="left" width="12.5%">&nbsp;ADMINISTRADOR</td> -->
						<td class="estilo1" align="left" width="12.5%">&nbsp;<%=session.getAttribute("PS_USER")%></td>
						<%}
						
						if (ls_tipo_usuario.equals("S")){%>
						<!--<td class="estilo1" align="left" width="12.5%">&nbsp;SUPERVISOR</td> -->
						<td class="estilo1" align="left" width="12.5%">&nbsp;<%=session.getAttribute("PS_USER")%></td>
						<%}		
						
						if (ls_tipo_usuario.equals("J")){%>
						<!--<td class="estilo1" align="left" width="12.5%">&nbsp;JEFATURA</td> -->
						<td class="estilo1" align="left" width="12.5%">&nbsp;<%=session.getAttribute("PS_USER")%></td>
						<%}
						
						if (ls_tipo_usuario.equals("G")){%>
						<!-- td class="estilo1" align="left" width="12.5%">&nbsp;GERENCIA</td> -->
						<td class="estilo1" align="left" width="12.5%">&nbsp;<%=session.getAttribute("PS_USER")%></td>
						<%}

						if (ls_tipo_usuario.equals("P")){%>
						
						<td class="estilo1" align="left" width="12.5%">&nbsp;<%=session.getAttribute("NOMBREUSUARIO")%></td>
						<%}		
						%>
						
						<!-- td class="estilo1" align="left" width="12.5%">&nbsp;<%=session.getAttribute("NOMBREUSUARIO")%></td> -->
						<!-- <td class="portada" align="right" width="12.5%">Regi&oacute;n&nbsp;</td>
						<td class="estilo1" align="left" width="12.5%">&nbsp;< %=session.getAttribute("REGION")% ></td> -->
						<td width="12.5%">&nbsp;</td>
						<td class="estilo2" align="right" width="5%"><%=date%></td>
						<td class="estilo2" align="right" width="5%"><div id="txt"></div></td>
						<td class="enlaces" align="right" width="5%"><a href="javascript:cerrarSesion();">Cerrar&nbsp;sesi&oacute;n</a></td>
					</tr>
					<tr>
						
						<td class="estilo1" align="center" colspan="4" ><%=sA.consultaSociedad(session.getAttribute("PS_SOCIEDAD").toString())+" S.A."%></td>
					
					</tr>
				</table>
			</td>	
		</tr>	
		<tr>
			<td align="center" valign="top" colspan="2"><img src="../../imagenes/ico-roja.gif" width="750"></img></td>
		</tr>	
	</table >		
	
</body>
   <%
	sA.cerrarSesionBD();
    %>
</html>