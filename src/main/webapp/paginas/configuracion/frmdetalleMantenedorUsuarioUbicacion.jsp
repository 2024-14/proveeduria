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
	//ResultSet detalle = null;
	
	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	List<String[]> usuarioUbicacion = sA.consultarUsuarioUbicacionv2(nombreSociedad);
	int CantUsuarios=usuarioUbicacion.size();
	System.out.println("CantUsuarios: "+CantUsuarios);
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
if(CantUsuarios != 0){
%>
<table id="tbMantenedorUsuarioUbicacion" width="100%" class="tablesorter">
	<thead>
		<tr class="etiqueta_formulario2">
			<td align="center" ></td>
			<td align="center" >Codigo Usuario</td>	
			<td align="center" >Usuario</td>
			<td align="center">Nombre de Oficina</td>
			<td align="center">Piso</td>
			<td align="center">Dirección</td>
			<td align="center">Región</td>
			<td align="center">Ceco</td>
			<td align="center">Área de empresa</td>
			<td align="center">Estatus</td>
			<td align="center">Sociedad</td>
			<td align="center">Guia de Remisión</td>
		</tr>
		</thead>
		<tbody>
		<%
		int i = 0;
		for(String[] userUbic : usuarioUbicacion){
		 %>
		<tr class="detalle_formulario" >
			<td width="1px"><img alt="" src="../../imagenes/busqueda.png" width="30" onclick="javascript:cargar(<%=i%>);" name="botonbuscar" id="#botonbuscar"/></td>
			<td align="justify"><%=(userUbic[0]==null)?"":userUbic[0]%><input id="txtCodUsuario<%=i%>" name="txtCodUsuario<%=i%>" disabled="disabled" type="hidden" value="<%=userUbic[0]%>"></td>
			<td align="justify"><%=(userUbic[1]==null)?"":userUbic[1]%><input id="txtUsuario<%=i%>" name="txtUsuario<%=i%>" disabled="disabled" type="hidden" value="<%=userUbic[1]%>"></td>
			<td align="center" ><%=(userUbic[2]==null)?"":userUbic[2]%><input id="txtOficina<%=i%>" name="txtOficina<%=i%>" type="hidden" value="<%= (userUbic[2]==null)?"":userUbic[2]%>"></td>
			<td align="center" ><%=(userUbic[3]==null)?"":userUbic[3]%><input id="txtPiso<%=i%>" name="txtPiso<%=i%>" type="hidden" value="<%= (userUbic[3]==null)?"":userUbic[3]%>"></td>
			<td align="center" ><%=(userUbic[4]==null)?"":userUbic[4]%><input id="txtDireccion<%=i%>" name="txtDireccion<%=i%>" type="hidden" value="<%= (userUbic[4]==null)?"":userUbic[4]%>"></td>
			<td align="center" ><%=(userUbic[5]==null)?"":userUbic[5]%><input id="txtRegion<%=i%>" name="txtRegion<%=i%>" type="hidden" size="15" value="<%=(userUbic[5]==null)?"":userUbic[5]%>"></td>
			<td align="center" ><%=(userUbic[6]==null)?"":userUbic[6]%><input id="txtCeco<%=i%>" name="txtCeco<%=i%>" disabled="disabled" type="hidden" value="<%=(userUbic[6]==null)?"":userUbic[6].trim()%>"></td>
			<td align="center" ><%=(userUbic[7]==null)?"":userUbic[7]%><input id="txtArea<%=i%>" name="txtArea<%=i%>" type="hidden"  value="<%= (userUbic[7]==null)?"":userUbic[7]%>"></td>
			<td align="center" ><%=(userUbic[8]==null)?"":userUbic[8]%><input id="txtEstado<%=i%>" name="txtEstado<%=i%>" type="hidden" onchange="mayuscula(this);" onkeypress="mayuscula(this);" value="<%= (userUbic[8]==null)?"":userUbic[8]%>"></td>
			<td align="center" ><%=(userUbic[9]==null)?"":userUbic[9].trim()%><input id="txtSociedad<%=i%>" name="txtSociedad<%=i%>" type="hidden" value="<%=(userUbic[9]==null)?"":userUbic[9].trim()%>"></td>
			<%
			String checked = userUbic[10];
		  	String dato = ""; 
		   	if(checked==null){dato = ""; }else if(checked.equals("S")){dato = "checked=\"checked\"";}
		 	%>
			<td align="center"><input id="txtGuia<%=i%>" name="txtGuia<%=i%>" type="checkbox" id="guiaRemision"  disabled="disabled" <%=dato%> name="guiaRemision" value="S"/></td>
		</tr>
		<% 
		i++;
		}
		%>
							
	</tbody>
	 <%sA.cerrarSesionBD();%>
</table>
<%}else{ %>
<table align="center" width="100%" cellpadding="1" cellspacing="0" >
	<tr>
		<td class="titulo" align="center">No existen Usuarios</td>
	</tr>
</table>
<%} %>		
</body>
</html>