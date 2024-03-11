<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.ResultSet"%>
<%@ page import="com.conexion.ServiciosAdministrador"%>
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
    <title>Preview de Costos</title>
    <script type="text/javascript">
 
  		function exportarexcel() {
  			var proveedor =  document.getElementById("cmbProveedor").value;
  			var estado1 = document.getElementById("estado");
          	var estado = "";
      		  for(i=0;i<estado1.length;i++){  
           		 if(estado1[i].selected == true){  
            		   estado=estado+"&pEstado="+estado1[i].value;  
          		  }  
     		   }  
  			
			var url = "frmPreviewsCosto.jsp?pProveedor="+proveedor+"&pImprimir=S"+estado+"&pFechaDesde=<%=fecha_desde%>&pFechaHasta=<%=fecha_hasta%>";
			//alert(url);
			window.open(url, "_self");
			//window.focus();		        
		    //top.close();
		}
		
		function mayuscula(campo){
			campo.value=campo.value.toUpperCase();
		}		
		
	
		
</script>
</head>

 <body>
 <form name="frmPreviewCosto">
   <table width="10%" align="center" cellpadding="0" cellspacing="0" border="0">
   <tr>
    <td class="etiqueta_formulario_1" align="center">Preview de Costos</td>
    </tr>
    <tr>
    	<td>
    	<table cellspacing="1" cellpadding="2" border="0" height="75">
			<tr>
				<td class="etiqueta_formulario" >Proveedor: <br></td>
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
				<!--  td align="center" class="detalle_formulario" ><%=(proveedor.equals(""))?"Todos":proveedor%>
				</td> -->
			</tr>
			<tr>
				<td class="etiqueta_formulario" >Estatus :</td>
				<td class="detalle_formulario" >
				<select id="estado" name="estados" >
					<option id="estadoND" value="'2','3','4'" >Todos</option>
					<option id="estadoDT" value="'4'" >Desapachado Total</option>
					<option id="estadoDP" value="'3'" >Desapachado Parcial</option>
					<option id="estadoND" value="'2'" >No Desapachado</option>
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
  </body>
  <script type="text/javascript">
  	document.frmPreviewCosto.cmbProveedor.value = '<%=proveedor%>';
</script>
</html>


	