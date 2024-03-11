<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@page import="java.sql.ResultSet"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	String respuesta="";	
	String cadena = request.getParameter("pCadena");
	try{
	cadena = cadena.replaceAll("~"," ");
	}catch(Exception e){
		e.printStackTrace();
	}
	System.out.println("Cadena "+cadena);
	
	String proveedor = request.getParameter("pProveedor");
	String solicitud = request.getParameter("pSolicitud");
	String usuario = request.getParameter("pUsuario");
	String ubicacion = request.getParameter("pUbicacion");
	String articulo = request.getParameter("pArticulo");
	 
	String estadoDT = request.getParameter("pEstadoDT");
	String estadoDP = request.getParameter("pEstadoDP");
	String estadoR = request.getParameter("pEstadoR");
	String estadoND = request.getParameter("pEstadoND");

	String fecha_desde = request.getParameter("pFechaDesde");
	String fecha_hasta = request.getParameter("pFechaHasta");
	try{
	usuario = usuario.replaceAll("~"," ");
	}catch(Exception e){
	}
	try{
	ubicacion = ubicacion.replaceAll("~"," ");
	}catch(Exception e){
	}
	try{
	articulo = articulo.replaceAll("~"," ");
	}catch(Exception e){
	}
	if (estadoR==null){
    	estadoR = "'5','6','7'";
    }
	System.out.println("1.-"+proveedor);
	System.out.println("2.-"+solicitud);
	System.out.println("3.-"+usuario);
	System.out.println("4.-"+articulo);
	System.out.println("5.-"+estadoDT);
	System.out.println("6.-"+estadoDP);
	System.out.println("7.-"+estadoR);
	System.out.println("8.-"+estadoND);
	System.out.println("9.-"+fecha_desde);
    System.out.println("10.-"+fecha_hasta);	
	String rutas = "../procesos/frmAdministrador.jsp?pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="+usuario+
	"&pUbicacion="+ubicacion+"&pArticulo="+articulo+"&pEstadoDT="+estadoDT+"&pEstadoDP="+estadoDP+
	"&pEstadoR="+estadoR+"&pEstadoND="+estadoND+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta+"&pPresentar=S";
	System.out.println("Ruta a cargar despues de refresh Reversa: "+ rutas);
	
	respuesta=sA.reversa(cadena);
 %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle de solicitud</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
<script type="text/javascript" src="../../js/jquery-1.11.2.js"></script>
<script type="text/javascript" src="../../js/jquery-ui.js"></script>
</head>
<body>
<br/>
<br/>
<br/>
<p align="center">
Actualizando ...  <img src="../../imagenes/loading (1).gif" width="15"></img>
</p>
</body>
<script type="text/javascript">
	var ruta = "<%=rutas%>";
	var resp = "<%=respuesta%>";
	alert(resp);
	window.open("../protegido/menu.jsp?Pparametro=S",target="_menu");
	<%
		request.getSession().setAttribute("RUTAS", rutas);
	%>
	//});
    
	//window.close();
</script>

</html>