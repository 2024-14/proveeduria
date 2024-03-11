<%@page import="java.awt.print.PrinterException"%>
<%@page import="java.util.List"%>
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
	//Operacion op = new Operacion(pContext);
	ServiciosAdministrador sA = new  ServiciosAdministrador(pContext);
	String solicitudes = ""; 
	String lsUsuario = request.getSession().getAttribute("USUARIO").toString();
	String lsSociedad = request.getSession().getAttribute("PS_SOCIEDAD").toString();
	  
	
	
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
	System.out.println("fecha desde:"+fecha_desde);
	System.out.println("fecha hasta:"+fecha_hasta);
	
	String presentar = "";
	try{
		presentar = request.getParameter("pPresentar");
		System.out.println("presentar : "+presentar);
		if(presentar==null){
			presentar = "N";
		}
	}catch(Exception e){
		presentar = "";
	}
	
	System.out.println("Datos Generar Pedido: "+proveedor+" | "+solicitud
						+ " | "+usuario+" | "+ubicacion+" | "+articulo
						+ " | "+fecha_desde+" | "+fecha_hasta);
						
  	ResultSet vBandeja = null;
	String [][] resultado = null;
 %>
 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="../../css/estilo.css" rel="stylesheet"></link>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>
<script type="text/javascript" src="../../js/jquery-1.11.2.js"></script>
<script type="text/javascript" src="../../js/jquery-ui.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Generar Pedido</title>
<link href="../../css/estilo.css" rel="stylesheet"></link>

<script type="text/javascript">
	function enviaPedido(index){
		var i=0;
		var solicitud;
		var contrato;
		var length = document.frmDetAdministrador.elements.length;
		for (i=0; i < length; i++ ){
			if (document.frmDetAdministrador.elements[i].name=="txtSolicitud"+index){
				solicitud = document.frmDetAdministrador.elements[i].value;
				}	
			
			if (document.frmDetAdministrador.elements[i].name=="txtContrato"+index){
				contrato = document.frmDetAdministrador.elements[i].value;
				}
		
		}
		var ruta = "../procesos/enviaSap.jsp?pContrato="+contrato;
	    var ancho = 400;
	    var alto  = 200;
		var posicion_x; 
		var posicion_y; 
		posicion_x=(screen.width/2)-(ancho/2); 
		posicion_y=(screen.height/2)-(alto/2);
		window.open(ruta, "popup1", "width="+ancho+", height="+alto+", menubar=no, scroll=no, status=no, location=no, toolbar=0, left="+posicion_x+", top="+posicion_y+"");
	}
</script>

</head>
<body>
	<form name="frmDetAdministrador" >

<% 
	try{
		if(presentar.equals("S")){ 
			resultado = sA.genererPedido(lsSociedad,proveedor,solicitud,usuario,ubicacion,articulo,fecha_desde,fecha_hasta,estadoDT,estadoDP,estadoR,estadoND);
			System.out.println("GENERAR PEDIDO mc: "+resultado.length);
			for (int k = 0; k < resultado[3].length; k++) {
				if (resultado[3][k]!=null){
					solicitudes = solicitudes+"'"+resultado[3][k]+"',";
					//System.out.println("Solicitudes: "+solicitudes);
				}
			} 
			solicitudes=solicitudes+"''";
			System.out.println("Solicitudes_final: "+solicitudes);
		}
		int i=0;
		vBandeja = sA.detalleGeneraPedido(proveedor,lsSociedad,fecha_desde,fecha_hasta);
		int conGeneral=0;
		while (vBandeja.next()){
			conGeneral++;
		}
		if ( conGeneral == 0 ){
			System.out.println("No hay solicitudes para generar pedido.");
			request.getSession().setAttribute("DATOS", "N");
		}else{
			System.out.println("SI hay solicitudes para generar pedido.");
			request.getSession().setAttribute("DATOS", "S");
		}
		if (request.getSession().getAttribute("DATOS").equals("S"))
		{
			vBandeja.close();
			vBandeja = sA.detalleGeneraPedido(proveedor,lsSociedad,fecha_desde,fecha_hasta);
       		System.out.println("entra en IF de no estar vacio");
       		int contadoGeneral2=0;
	        int j=0;		
			while (vBandeja.next())
			{ 
				contadoGeneral2++;
				System.out.println(" - valor_vandeja: "+vBandeja.getString(1));
				String ruc = null;
				ruc = vBandeja.getString(2);
		 		List<String[]> lista_ruc = sA.usuario_proveedor(ruc,lsSociedad);
				System.out.println("valor tabla: "+lista_ruc.size());
				String usuario_ruc = "";
				for(String[] fila_ruc : lista_ruc){
					usuario_ruc = fila_ruc[0];
				}
				String contrato = "";
   				contrato = vBandeja.getString(1);
   				List<String[]> tabla = sA.detalletab_gen_pedido(contrato,lsSociedad);
   				System.out.println("valor tabla: "+tabla.size());
		   				
%>
		<table>
			<tr>
				<td class="etiqueta_formulario" >Contrato #: </td><td class="detalle_formulario"><%=vBandeja.getString(1)%></td>		 
			</tr>
			<tr>
				<td class="etiqueta_formulario" >Proveedor: # </td><td class="detalle_formulario"><%=usuario_ruc%></td>		
     		</tr>
 
     		<tr>
     			<td class="etiqueta_formulario">Envios</td>
     			<td class="etiqueta_formulario">Costo Total</td>
     			<td class="etiqueta_formulario">Confirmar Envio</td>	
     		</tr>
     		<tr>
<%			 	for(String[] fila : tabla)
   				{
   					j=j+1;
   					System.out.println("Columna 1 : "+ fila[0] + " Columna 2 : "+ fila[1] );
    				if (fila[1]!=null)
    				{
%>				<td class="detalle_formulario"><%=fila[0]%></td> 
  					<td class="detalle_formulario"><%=fila[1]%></td> 
    			<td align="center" >
	    			<input type="button" value="Enviar A Sap" class="enviaSap" id="enviaSap<%=j%>" onclick ="javascript:enviaPedido(<%=j%>)"/>
		    		<input type="hidden" name="txtContrato<%=j%>" disabled="disabled" value="<%=contrato%>"  size="15" />
   				</td>

<%	     			}
	     		}
%>			</tr>
		</table>
<%			}	
		}else
		{
%>		<table align="center" width="100%" cellpadding="1" cellspacing="0" >
	    	 <tr> 
	    	  	<td class="titulo" align="center">No existen datos a presentar</td>
	    	 </tr>
	  	</table>	  	
<%		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		vBandeja.close();
	}			
%>
	</form>		
</body>
</html>