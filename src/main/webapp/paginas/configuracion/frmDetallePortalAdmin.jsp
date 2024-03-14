<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador" %>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 <html>
<%
	ServiciosAdministrador sA = new  ServiciosAdministrador(pageContext);
	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	
	List<String[]> usuarioPortal = sA.adminPortal(nombreSociedad);
	int CantUsuariosPortal=usuarioPortal.size();
	System.out.println("CantUsuariosPortal: "+CantUsuariosPortal);
%> 

<head>	

<script type="text/javascript">
	$(document).ready(function(){
		$("#tbDetallePortalAdmin").tablesorter(); 
	});
	
		function verificaLogin(atributo){
			
			if (atributo == "false"){
				alert("Debe ingresar con su usuario");
			    window.open("../login/frmLogin.html", "_self");
			}
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

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<title>M&oacute;dulo&nbsp;de&nbsp;Proveedor</title>

<style type="text/css">
	.etiqueta_formulario2{
		cursor: pointer;
		font-family:"Arial, Verdana";
		font-size:12px;
		background-color:#C81414;
		color:#FFFFFF;
		font-weight: bold;
	}
	
	input{
        border: 0 none;
        background: none repeat scroll 0 0 transparent;
        outline: medium none;    
	}
</style>

</head>
<body >
	<form name="frmProv" action="despacho.jsp" method="get" target="_DESPACHO"> 
	<%
	if(CantUsuariosPortal != 0){
	%>
	<table width="100%" id="tbDetallePortalAdmin" class="tablesorter">
		<thead>
		<tr class="etiqueta_formulario">
			<th class="etiqueta_formulario2" width="20px"></th>
			<th class="etiqueta_formulario2">Usuario</th>
			<th class="etiqueta_formulario2">Clave</th>
			<th class="etiqueta_formulario2">Rol</th>
			<th class="etiqueta_formulario2">Sociedad</th>
			<th class="etiqueta_formulario2">Correo</th>
			<th class="etiqueta_formulario2">Ruc</th>
			<th class="etiqueta_formulario2">Estatus</th>
		</tr>
	</thead>
	<tbody>
	<%
	int i = 0;
	for(String[] userPortal : usuarioPortal){
	 %>						
		<tr class="detalle_formulario" align="center">
			<td  width="1px">
				<img alt="" src="../../imagenes/busqueda.png" width="30" onclick="javascript:cargar(<%=i%>);" name="botonbuscar" id="#botonbuscar"/>
			</td>
			
			<td align="center" ><%=(userPortal[0]==null)?"":userPortal[0]%>
				<input type="hidden" name="txtUsuario<%=i%>" disabled="disabled" value="<%=userPortal[0]%>"  size="15" />
			</td>
			<td align="center" >
				<input type="password" name="txtClave<%=i%>" disabled="disabled" value="<%=userPortal[1]%>"  size="10" style='text-align: center;'/>
			</td>
			<td align="center" ><%=(userPortal[2]==null)?"":userPortal[2]%>
				<input type="hidden" name="txtRol<%=i%>" disabled="disabled" value="<%=userPortal[2]%>"  size="15" />
			</td>
			<td align="center" ><%=(userPortal[3]==null)?"":userPortal[3]%>
				<input type="hidden" name="txtSociedad<%=i%>" disabled="disabled" value="<%=userPortal[3]%>"  size="15" />
			</td>
			<td align="center" ><%=(userPortal[4]==null)?"":userPortal[4]%>
				<input type="hidden" name="txtCorreo<%=i%>" disabled="disabled" value="<%=userPortal[4]%>"  size="35" />
			</td>
			<td align="center" ><%=(userPortal[6]==null)?"":userPortal[6]%>
				<input type="hidden" name="txtRuc<%=i%>" disabled="disabled" value="<%=userPortal[6]%>"  size="35" />
			</td>
			<td align="center" ><%=(userPortal[5]==null)?"":userPortal[5]%>
				<input type="hidden" name="txtEstatus<%=i%>" disabled="disabled" value="<%=userPortal[5]%>"  size="15" />
			</td>
		</tr>								
<%	i++;
	}
%>	
	</tbody>							
</table>
<%}else{ %>
<table align="center" width="100%" cellpadding="1" cellspacing="0" >
	<tr>
		<td class="titulo" align="center">No existen datos a presentar</td>
	</tr>
</table>
<%}%>
</form>
</body>
<%sA.cerrarSesionBD();%>
</html>