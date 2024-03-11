<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	//Operacion op = new Operacion(pContext);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	ResultSet detalle = null;
	
	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	List<String[]> usuariosNuevos = sA.consultarUsuariosNuevosv2(nombreSociedad);
	int CantUsuariosNuevos=usuariosNuevos.size();
	System.out.println("CantUsuariosNuevos: "+CantUsuariosNuevos);
	 
 %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle de solicitud</title>
<script type="text/javascript">

$(document).ready(function(){
		$("#tbMantenedorUsuarioUbicacion").tablesorter(); 
	});	
	</script>
</head>
<body>
<%
if(CantUsuariosNuevos != 0){
%>
<table id="tbMantenedorUsuarioUbicacion" width="100%" class="tablesorter">
	<thead>
		<tr class="etiqueta_formulario2">
			<td align="center" ></td>
			<td align="center" >Codigo Usuario</td>	
			<td align="center" >Usuario</td>
			<td align="center">Ceco</td>
			<td align="center">Sociedad</td>
		</tr>
	</thead>
	<tbody>
		<%
		int i = 0;
		for(String[] userNew : usuariosNuevos){
		 %>
		<tr class="detalle_formulario" >
			<td width="1px"><img alt="" src="../../imagenes/busqueda.png" width="30" onclick="javascript:cargarN(<%=i%>);" name="botonbuscar" id="#botonbuscarN"/></td>
			<td align="justify"><%=(userNew[0]==null)?"":userNew[0]%><input id="txtCodUsuarioN<%=i%>" name="txtCodUsuarioN<%=i%>" disabled="disabled" type="hidden" value="<%=userNew[0]%>"></td>
			<td align="justify"><%=(userNew[1]==null)?"":userNew[1]%><input id="txtUsuarioN<%=i%>" name="txtUsuarioN<%=i%>" disabled="disabled" type="hidden" value="<%=userNew[1]%>"></td>
			<td align="center" ><%=(userNew[2]==null)?"":userNew[2]%><input id="txtCecoN<%=i%>" name="txtCecoN<%=i%>" disabled="disabled" type="hidden" value="<%=(userNew[2]==null)?"":userNew[2].trim()%>"></td>
			<td align="center" ><%=(userNew[3]==null)?"":userNew[3].trim()%><input id="txtSociedadN<%=i%>" name="txtSociedadN<%=i%>" type="hidden" value="<%=(userNew[3]==null)?"":userNew[3].trim()%>"></td>
		</tr>
		<%	 i++;
		}
		%>
	</tbody>
</table>
<%}else{ %>
<table align="center" width="100%" cellpadding="1" cellspacing="0" >
	<tr>
		<td class="titulo" align="center">No existen Usuarios Nuevos</td>
	</tr>
</table>
<%} %>		
	</body>
</html>