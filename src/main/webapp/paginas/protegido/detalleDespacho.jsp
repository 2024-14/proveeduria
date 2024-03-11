<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.conexion.Operacion"  %>
<%@ page errorPage="../general/errorGral.jsp" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="es">
<head>
<link href="../../css/jquery-ui.css" rel="stylesheet"></link>

<%
	JspFactory jspFactory = JspFactory.getDefaultFactory();
	PageContext pContext = jspFactory.getPageContext(this, request, response, null,true, 0, true);
	Operacion op = new Operacion(pContext);
	
	String lsUsuario = request.getSession().getAttribute("USUARIO").toString();
	String vendorId = lsUsuario;
	
	String pass = request.getSession().getAttribute("PASS").toString();
	String sociedad = request.getSession().getAttribute("SOCIEDAD").toString();
	String id_ruc = op.ConsultaRUC(lsUsuario, pass,sociedad);
	String setsolicitud = request.getParameter("pSolicitud");
	
	String setid= "", noOrden="", dept="", s_estado="";
	String cantidad = "";
	String guia_remision2;
	if(op!=null){
		System.out.println("OP no null");
	}
	request.getSession().setAttribute("RUTAS", "../protegido/mainProveedor.jsp");
	
	List<String[]> detalleDespacho = op.getDetPedido(setsolicitud, id_ruc,sociedad);
	int CantDetalleDespacho=detalleDespacho.size();
	System.out.println("CantDetalleDespacho: "+CantDetalleDespacho);
	
%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<link href="../../css/estilo.css" rel="stylesheet"></link>
<title>M&oacute;dulo&nbsp;de&nbsp;Proveedor</title>

<script type="text/javascript">
$(document).ready(function(){
	$(".datepicker").datepicker({ dateFormat: 'dd/mm/yy' }).val();
	$("#myTable").tablesorter({dateFormat: "uk"});
});

function myEventFunction(event,z,idx){
		var x = event.which || event.keyCode;
		var y = String.fromCharCode(x);      // Convert the value into a character
	    var dato ="";	    
	    if (x==38){
	    	idx=idx*1-1;
	    	dato = z.name+idx;
	    	document.getElementById(dato).focus();
	    }
		if (x==40){
			idx=idx*1+1;
			dato = z.name+idx;
			document.getElementById(dato).focus();
	    }
	}	
</script>
</head>
<body>
	<form name="frmDetOrden2">
		<%
		if(CantDetalleDespacho != 0){
		%>
		<table width="100%" border="0" align="center" id="myTable" class="tablesorter">
			<thead>
				<tr align="center">
					<th class="etiqueta_formulario2" width="1px">Nro</th>
					<th class="etiqueta_formulario2" width="1px">C&oacute;digo</th>
					<th class="etiqueta_formulario2">Producto</th>
					<th class="etiqueta_formulario2" width="100">Fecha</th>
					<th class="etiqueta_formulario2" width="1px">Cant. Pedida</th>
					<th class="etiqueta_formulario2" width="1px">Total Despachado</th>
					<th class="etiqueta_formulario2" width="1px">Cant. Despachada</th>
					<th class="etiqueta_formulario2" width="100">Estado</th>
					<th class="etiqueta_formulario2" width="1px">Guia de Remision</th>
					<th class="etiqueta_formulario2" width="1px">Fecha despacho</th>
				</tr>
			</thead>
			<tbody>
				<%
				int idx = 0;
				for(String[] registroDetalle : detalleDespacho){
				 %>						
				<tr>
					<td class="detalle_formulario"><%=registroDetalle[0]%>
						<input type="hidden"name="txtIdDet" value="<%=registroDetalle[0]%>" />
					</td>
					<td class="detalle_formulario"><%=registroDetalle[1]%>
						<input type="hidden" name="txtProducto" value="<%=registroDetalle[1]%>" /></td>
					<td class="detalle_formulario"><%=registroDetalle[2]%>
						<input type="hidden" name="txtProductoDes" value="<%=registroDetalle[2]%>" /></td>
					<td align="center" class="detalle_formulario"><%=registroDetalle[3]%>
						<input type="hidden" name="txtFecha" value="<%=registroDetalle[3]%>" /></td>
					<td align="center" class="detalle_formulario"><%=registroDetalle[4]%>
						<input type="hidden" name="txtCantPed" value="<%=registroDetalle[4]%>" /></td>
					<td align="center" class="detalle_formulario"><%=registroDetalle[5]%>
						<input type="hidden" name="txtTotDesp" value="<%=registroDetalle[5] %>" /></td>
					<td class="detalle_formulario">
					<% 
						String cant_pedida = registroDetalle[4];
						String total_desp = registroDetalle[5]; 
						String propiedad="";
						//System.out.println("cant_pe="+cant_pedida);
						//System.out.println("total_desp="+total_desp);
						if(cant_pedida.equals(total_desp)){
							propiedad="disabled=\"disabled\"";
							//System.out.println("Ingreso detalle ");
						}
					%>
						<input type="text" name="txtCantDesp" id="txtCantDesp<%=idx%>" value="" <%=propiedad%> size="5"   onkeydown="myEventFunction(event, this,'<%=idx%>');" ></td>
					<td align="center" class="detalle_formulario"><%
					if (cant_pedida.equals(total_desp))
						out.println("Despacho Total");
					else if (total_desp.equals("0"))
						out.println("No Despachado");
					else	
						out.println("Despacho Parcial");
					%>
					</td>
					<td class="detalle_formulario">
						<input type="text"	name="txtguia_remi2" id="txtguia_remi2<%=idx %>"  <%=propiedad%> value="<%=(registroDetalle[6]!=null)?registroDetalle[6]:"" %>" size="10" onkeydown="myEventFunction(event, this,'<%=idx%>');" />
					</td>
					<td class="detalle_formulario">
						<input type="text"	name="txtfechadesp2"  class="datepicker" id="txtfechadesp2<%=idx %>" <%=propiedad%>  value="<%=(registroDetalle[7]!=null)?registroDetalle[7]:"" %>"  size="10"  onkeydown="myEventFunction(event, this,'<%=idx%>');" />
					</td>				
				</tr>
				<% idx ++; 
				} %>
		
		<%}else{ %>
			<tr>
				<td class="titulo" align="center">No existen datos a presentar</td>
			</tr>
		<%} %>
			</tbody>
		</table>
	</form>
</body>
</html>