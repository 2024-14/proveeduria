<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page errorPage="../general/errorGral.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%String Solicitud = request.getParameter("pSolicitud");
String nroOrden = request.getParameter("pNroOrden"); %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Despacho&nbsp;de&nbsp;Pedido</title>	
		<script type="text/javascript">
			top.window.moveTo(0, 0);
			if (document.all) {
				top.window.resizeTo(screen.availWidth, screen.availHeight);
			} else {
				if (document.layers || document.getElementById) {
					if (top.window.outerHeight < screen.availHeight
							|| top.window.outerWidth < screen.availWidth) {
						top.window.outerHeight = screen.availHeight;
						top.window.outerWidth = screen.availWidth;
					}
				}
			}
		</script>	
	</head>

	<frameset rows="*">
		<frame src="../protegido/despacho.jsp?pSolicitud=<%=Solicitud%>" id="_despacho" name="_despacho" scrolling="auto" frameborder="0"></frame>
	  </frameset>
 
</html>