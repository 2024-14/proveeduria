<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.ServiciosAdministrador"%>
<%@page import="java.sql.ResultSet"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	ServiciosAdministrador sA = new ServiciosAdministrador(pContext); 
	ResultSet rSProveedor=null; 
	String fecha_desde	= request.getParameter("pFechaDesde");
	String fecha_hasta 	= request.getParameter("pFechaHasta");
	String proveedor 	= request.getParameter("pProveedor");
	String lsSociedad 	= request.getSession().getAttribute("PS_SOCIEDAD").toString();

%>

  <head>
    <link href="../../../css/estilo.css" rel="stylesheet"></link>
    <title>Pre-Facturación</title>
    <script type="text/javascript">
    
    function exportarexcel() {
  			var proveedor =  document.getElementById("cmbProveedor").value;
  			var estado = document.getElementById("estado").value;
          	var estado1 = "";
      		  /*for(i=0;i<estado1.length;i++){  
           		 if(estado1[i].selected == true){  
            		   estado=estado+"&pEstado="+estado1[i].value;  
          		  }  
     		   }*/  
  			
     		var url = "frmPreFactura.jsp?pProveedor="+proveedor+"&pImprimir=S&pEstado="+estado+
     				   "&pFechaDesde=<%=fecha_desde%>&pFechaHasta=<%=fecha_hasta%>";
   			//alert(url);
   			//var url = "frmPreFactura.jsp?pProveedor="+proveedor+"&pImprimir=S&pEstado="+estado;
			window.open(url, "_self");
			//window.focus();		        
		    //top.close();
		}
		
    	
	</script>
  </head>
  
  <body>
  <form name="frmPreFactura">
   <table width="10%" align="center" cellpadding="0" cellspacing="0" border="0">
   <tr>
    <td class="etiqueta_formulario_1" align="center">Pre-Facturación</td>
    </tr>
    <tr>
    	<td>
    	<table cellspacing="1" cellpadding="2" border="0" height="75">
			<tr>
				<td class="etiqueta_formulario" >Proveedor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br></td>
				<td class="detalle_formulario" >
					<select id="cmbProveedor" style="width: 100%;" name="cmbProveedor">
			           <%
						List<String[]> lproveedor = sA.consultaProveedor(lsSociedad);
						for(String[] proveedor_u : lproveedor){
						%>	
						<option value="<%=proveedor_u[0]%>"><%=proveedor_u[0]%></option>
						<%}%> 
						<option value="" >Todos</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="etiqueta_formulario" >Estatus </td>
				<td class="detalle_formulario" >
				<select id="estado" name="estados" >
					<option id="estadoND" value="'5','6','7'" >Todos</option>
					<option id="estadoDT" value="'7'" >Recibido Total</option>
					<option id="estadoDP" value="'6'" >Recibido Parcial</option>
					<option id="estadoND" value="'10'" >Despachado Denegado</option>
					<option id="estadoND" value="'11'" >No Recibido</option>
				</select>
				</td>
			</tr>
			
	   </table>
    	</td>
    </tr>
    <tr>
		<td align="center" class="detalle_formulario" ><input type="button" value="Procesar" onclick="exportarexcel()"> </td>
	</tr>
   </table>
  </form>
  <%sA.cerrarSesionBD();%>
   </body>
  <script type="text/javascript">
  	document.frmPreFactura.cmbProveedor.value = '<%=proveedor%>';
</script>
</html>
