package com.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.PageContext;

import com.conexion.ConectaBase;

/**
 * Servlet implementation class RevisarCodigo
 */
//@WebServlet(name = "RevisarCodigo", urlPatterns = {"/RevisarCodigo"})
public class RevisarCodigo extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
	 private ConectaBase cb;
	 private DateFormat ldFormat;
	    public JspFactory jspFactory;
	    public PageContext pageContext;
	    public Date ldFecha;
	    public HttpSession session;
	    private static RequestDispatcher rd;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RevisarCodigo() {
    	super();
    }
    public void init(final ServletConfig config) throws ServletException {
        super.init(config);
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ldFormat = DateFormat.getDateInstance();
        jspFactory = null;
        ldFecha = new Date();
		final String lsFecha = this.ldFormat.format(this.ldFecha).toString();
        (this.session = request.getSession(true)).setAttribute("DATE", (Object)lsFecha);
        try {
            this.processRequest(request, response);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        catch (Throwable e2) {
            e2.printStackTrace();
        }
}
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    		throws IOException{
    	/*final String lsFecha = this.ldFormat.format(this.ldFecha).toString();
        (this.session = request.getSession(true)).setAttribute("DATE", (Object)lsFecha);
        try {
            this.verificaLogin(request, response);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        catch (Throwable e2) {
            e2.printStackTrace();
        }	*/
    		}
    
	
	protected void processRequest (HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception {
		//response. setContentType("text/html;charsetsUTF=8");
		
		  int lnErrorSP = 1;
	      String lsErrorSP = "";
	        
	final String ls_usuario = request.getParameter("usuario");
	final String ls_codigo = request.getParameter("codigo");
    String ls_correo ="";
	PrintWriter out = response.getWriter();
	
	 this.jspFactory = JspFactory.getDefaultFactory();
        this.pageContext = this.jspFactory.getPageContext((Servlet)this, (ServletRequest)request, (ServletResponse)response, (String)null, true, 0, true);
        this.cb = new ConectaBase(this.pageContext);
        boolean lb_existe = false;
        
     	        
        CallableStatement cst = this.cb.getConnection().prepareCall("{call SAP.SAP_PORTAL_PROV.SWP_CONSULTA_CORREO2 (?,?,?,?)}");
        cst.setString(1, ls_usuario);
        
        // Definimos los tipos de los parametros de salida del procedimiento almacenado
        cst.registerOutParameter(2, java.sql.Types.VARCHAR);
        cst.registerOutParameter(3, java.sql.Types.INTEGER);
        cst.registerOutParameter(4, java.sql.Types.VARCHAR);
        
        // Ejecuta el procedimiento almacenado
        cst.executeQuery();
        
        // Se obtienen la salida del procedimineto almacenado
        ls_correo = cst.getString(2);
        
	// Llamada al procedimiento almacenado
    CallableStatement cst_validarfinal = this.cb.getConnection().prepareCall("{call SAP.SAP_PORTAL_PROV.SWP_CONSULTAR_CODIGO_OTP (?,?,?,?,?)}");
    cst_validarfinal.setString(1, ls_usuario);
    cst_validarfinal.setString(2, ls_correo);
    cst_validarfinal.setString(3, ls_codigo);
    
    // Definimos los tipos de los parametros de salida del procedimiento almacenado
    cst_validarfinal.registerOutParameter(4, java.sql.Types.INTEGER);
    cst_validarfinal.registerOutParameter(5, java.sql.Types.VARCHAR);
    
    // Ejecuta el procedimiento almacenado
    cst_validarfinal.execute();
    
    lnErrorSP = cst_validarfinal.getInt(4);
    lsErrorSP = cst_validarfinal.getString(5);
    
    if(lnErrorSP == 1) {
      	   this.session.setAttribute("AUTH", (Object)"false");
           this.session.setAttribute("ERROR", (Object)lsErrorSP);
           //(revisiones.rd = request.getRequestDispatcher("../general/error.jsp")).forward((ServletRequest)request, (ServletResponse)response);
           out.print(lsErrorSP);
      }else {
    	//  revisiones.rd = request.getRequestDispatcher("../protegido/frmMain.jsp"); //"../protegido/frmMain.jsp"
    	  out.print("exito");
      }
	
	
}
}
