<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<%
		JspFactory jspFactory = JspFactory.getDefaultFactory();
		PageContext pContext = jspFactory.getPageContext(this, request,
				response, null, true, 0, true);
		String ls_tipo_usuario = request.getSession()
				.getAttribute("PS_ROL").toString();
		String frm_admin = "../procesos/frmAdministrador.jsp";
		String frm_proveedor = "../protegido/mainProveedor.jsp";
		String url = "";
		String param = ""; 
		param=request.getParameter("Pparametro");
		System.out.println("ls_tipo_usuario: "+ls_tipo_usuario);
		if (ls_tipo_usuario.equals("A") || ls_tipo_usuario.equals("G")) {
			url = frm_admin;
		} else if (ls_tipo_usuario.equals("P")) {
			url = frm_proveedor;
		} 
	%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<!--link href="../../css/estilo.css" rel="stylesheet"></link-->
		<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
		<link href="../../css/menu.css" rel="stylesheet"></link>
		<script type="text/javascript" src="../../js/jquery-1.11.2.js"></script>
		<script type="text/javascript" src="../../js/jquery-ui.js"></script>
	
		<style type="text/css">
			#consulta,#detalle_consulta,#subdetalle {
				border: 1px solid #C81414;
				margin: 10px;
			}
			#submenu {
				margin: 10px;
				border: 1px solid black;
				padding: 10px;
			}
			.imagen {
				margin-top: 3px;
				margin-left: 3px;
				position: absolute;
			}
			#tabla_menu {
				height: auto;
				width: 100%;
				overflow: auto;
			}
			#detalle_menu {
				width: 100%;
				height: auto;
				max-height:none;
				overflow: auto;
			}
			input[type="button"], select {
				cursor:pointer;
			}
		</style>
		
		<script type="text/javascript">
			$(document).ready(function(){		
				$('a').click(function(){
					$('#detalle_menu').load(this.name);
				});
			});	
	</script>
	</head>
	<body>
		<div class="header">
			<ul class="nav" >
				<%
					if (ls_tipo_usuario.equals("A")||ls_tipo_usuario.equals("S")||ls_tipo_usuario.equals("J")||ls_tipo_usuario.equals("G")) {
				%>
				<li>
					<a name="Configuraciones">Configuraciones</a>
					<ul>
						<li>
							<a name="../configuracion/frmPortalAdministrador.jsp" >
							Administracion del Portal</a>
						</li>
						<li>
							<a  name="../configuracion/frmMantenedorUsarioUbicacion.jsp">
							Mantenedor de Usuarios y Ubicaciones</a>
						</li>
						<li>
							<a name="../configuracion/frmMetaIndicadorServicio.jsp">
							Meta Indicador de Servicio</a>
						</li>
					</ul>
				</li>
				<%
					}
				%>
				<li>
					<a name="Procesos">Procesos</a>
					<ul>
					<% if (ls_tipo_usuario.equals("P")) {%>
						<li>
							<a name="../protegido/mainProveedor.jsp" >Bandeja de Trabajo - Proveedor</a>
						</li>
						<%} %>
						<% if (ls_tipo_usuario.equals("A")||ls_tipo_usuario.equals("S")||ls_tipo_usuario.equals("J")||ls_tipo_usuario.equals("G")) {%>
						<li>
							<a name="../procesos/frmAdministrador.jsp" >Bandeja de Trabajo - Administrador</a>
						</li>
						<%} %>
						<% if (ls_tipo_usuario.equals("S")||ls_tipo_usuario.equals("J")||ls_tipo_usuario.equals("G")) {%>
						<li>
								<a name="../procesos/frmAdministrador_R.jsp" >Reversa Proceso</a>
						</li>
						<%} %>
					</ul>
				</li>
				<li>
					<a name="Consultas">Consultas</a>
					<ul>
						<li>
							<a name="../consulta/frmConsultaPreviwsCosto.jsp"
								target="_bandeja">Preview de Costos</a>
						</li>
						<%if (ls_tipo_usuario.equals("A")||ls_tipo_usuario.equals("S")||ls_tipo_usuario.equals("J")||ls_tipo_usuario.equals("G")) { %>
						<li>
							<a name="../consulta/frmConsultaPreFactura.jsp" >Pre
								Facturacion</a>
						</li>
						<%} %>
					</ul>
				</li>
				<%if (ls_tipo_usuario.equals("A")||ls_tipo_usuario.equals("S")||ls_tipo_usuario.equals("J")||ls_tipo_usuario.equals("G")) { %>
				<li>
					<a name="Reportes">Reportes</a>
					<ul>
						<li>
							<a name="../consulta/frmConsulta.jsp" >General</a>
						</li>
						<li>
							<a name="../consulta/frmIndicadores.jsp" >Indicadores de Servicio</a>
						</li>
						<!--li>
							<a href="">Indicador de Servicio</a>
						</li-->
					</ul>
				</li>
				<%} %>
			</ul>
		</div>
		<br/>
		<br/>
		<div id="detalle_menu"></div>
	</body>
		<script type="text/javascript">
			var valor="<%=param%>";
			if (valor=="S")
				{
					var ruta = "<%=request.getSession().getAttribute("RUTAS") %>";
					$('#detalle_menu').load(ruta);
				}
		</script>
</html>