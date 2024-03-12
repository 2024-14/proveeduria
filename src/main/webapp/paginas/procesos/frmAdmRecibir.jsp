<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"  %>
<%@page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList" %>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% 	System.out.println("Entro en AdmRecibir");
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	String nombreSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	System.out.println("nombreSociedad: "+nombreSociedad);
	
	//Recorre array detalle de solicitudes a modificar
	ArrayList<String> listado = new ArrayList<String>();  
	String lenTamMax =request.getParameter("length"); 
	System.out.println("Longitud Update: "+lenTamMax);
	String cadena = "";	
	for (int i=0; i<Integer.parseInt(lenTamMax);i++){
		cadena = request.getParameter("cadena"+i);
		cadena = cadena.replaceAll("~"," ");
		System.out.println("cadena: "+cadena);
		listado.add(cadena);
	}
	//Fin recorre array
	
	//Recorre array detalle de solicitudes a eliminar
	ArrayList<String> listadoD = new ArrayList<String>();  
	String lenTamMaxD =request.getParameter("lengthD"); 
	System.out.println("Longitud Disabled: "+lenTamMaxD);
	System.out.println("Longitud Disabled: "+lenTamMaxD);
	String cadenaD = "";	
	for (int i=0; i<Integer.parseInt(lenTamMaxD);i++){
		cadenaD = request.getParameter("cadenaDisabled"+i);
		cadenaD = cadenaD.replaceAll("~"," ");
		System.out.println("cadenaD: "+cadenaD);
		listadoD.add(cadenaD);
	}
	//Fin recorre array
	
	String proveedor = request.getParameter("pProveedor");
	String solicitud = request.getParameter("pSolicitud");
	String usuario = request.getParameter("pUsuario");
	String ubicacion = request.getParameter("pUbicacion");
	String articulo = request.getParameter("pArticulo");
	 
	String estadoDT = request.getParameter("pEstadoDT");
	String estadoDP = request.getParameter("pEstadoDP");
	String estadoR = request.getParameter("pEstadoR");
	String estadoND = request.getParameter("pEstadoND");
	String estadoR2 = request.getParameter("pEstadoR");
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
	if (estadoR2==null){
    	estadoR2 = "'5','6','7'";
    }
	System.out.println("RECIBIR");
	System.out.println("1.-proveedor: "+proveedor);
	System.out.println("2.-solicitud: "+solicitud);
	System.out.println("3.-usuario: "+usuario);
	System.out.println("4.-articulo: "+articulo);
	System.out.println("5.-DESPACHO TOTAL: "+estadoDT);
	System.out.println("6.-DESPACHO PARCIAL: "+estadoDP);
	System.out.println("7.-RECIBIDO: "+estadoR);
	System.out.println("8.-NO DESPACHADO: "+estadoND);
	System.out.println("9.-fecha_desde: "+fecha_desde);
    System.out.println("10.-fecha_hasta: "+fecha_hasta);
    
    
    
	String rutas = "../procesos/frmAdministrador.jsp?pProveedor="+proveedor+"&pSolicitud="+solicitud+"&pUsuario="+usuario+
	"&pUbicacion="+ubicacion+"&pArticulo="+articulo+"&pEstadoDT="+estadoDT+"&pEstadoDP="+estadoDP+
	"&pEstadoR="+estadoR2+"&pEstadoND="+estadoND+"&pFechaDesde="+fecha_desde+"&pFechaHasta="+fecha_hasta+"&pPresentar=S";
	System.out.println("Ruta a cargar despues de refresh recibir: "+ rutas);
	sA.recibirV2(nombreSociedad,proveedor,solicitud,usuario,
				ubicacion,articulo,fecha_desde,fecha_hasta,
				estadoDT,estadoDP,estadoR,estadoND,false,listadoD);
	sA.recibirSolicitud(listado,nombreSociedad);
 %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Detalle de solicitud</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
<script type="text/javascript" src="../../js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="../../js/jquery-ui.js"></script>
<script type="text/javascript">
var ruta = "<%out.print(rutas);%>";

	
	window.open("../protegido/menu.jsp?Pparametro=S",target="_menu");
	<%
		request.getSession().setAttribute("RUTAS", rutas);
	%>
</script>
</head>
<body>
<br/>
<br/>
<br/>
<%sA.cerrarSesionBD();%>
</body>
</html>