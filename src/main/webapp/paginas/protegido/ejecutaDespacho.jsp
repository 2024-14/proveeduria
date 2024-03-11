<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion" %>
<%@ page import="java.util.ArrayList" %>
<%@ page errorPage="../general/errorGral.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/transitional.dtd">
<html lang="es">
<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	String solicitud = request.getParameter("pSolicitud");
	//String nroOrden = request.getParameter("pNroOrden");
	//String cadena = request.getParameter("pCadena");
	ArrayList<String> listado = new ArrayList<String>();  
	String lenTamMax =request.getParameter("length"); 
	String ruc =request.getParameter("pRuc");
	String cadena = "";
	//out.println("\n Comenzar a Imprimir Cadena Length ::"+Integer.parseInt(lenTamMax));
	
	for (int i=0; i<Integer.parseInt(lenTamMax);i++){
		cadena = request.getParameter("cadena"+i);
		//out.println("cadena"+i);
		listado.add(cadena);
		System.out.println("cadena MC: "+cadena);
	}
	//out.println("\n Finalizar a Imprimir Cadena");
	
	String usuario = session.getAttribute("USUARIO").toString();
	String lsSociedad = session.getAttribute("SOCIEDAD").toString();
	Operacion op = new Operacion(pContext);
	System.out.println("llega a ejecuta_despacho");
	op.ejecutaListadoDespacho(listado,solicitud,ruc,lsSociedad);
	
	//op.ejecutaDespacho(cadena);
	
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">	
		<script type="text/javascript">
			function carga(){
				window.open("frmDespacho.jsp?pSolicitud="+"<%=solicitud%>", "_miTarget","resizable=no, menubar=no,toolbar=no,status=yes");
				//parent.location.reload();
				
			}
		window.focus();
		alert("Datos insertados correctamente");
		window.close();
		carga();
		
		</script>	
	</head>
	<body>
	  
	</body>
</html>