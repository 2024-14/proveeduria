package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.Date;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.PageContext;

import com.conexion.ConectaBase;
import com.conexion.Operacion;

/**
 * Servlet implementation class ReenviarCodigo
 */
@WebServlet("/ReenviarCodigo")
public class ReenviarCodigo extends HttpServlet {
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
    public ReenviarCodigo() {
        super();
        // TODO Auto-generated constructor stub
        
        
        
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

        		}
        
        
        protected void processRequest (HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception {
    		//response.setContentType("text/html;charsetsUTF=8");
    		
    		  int lnErrorSP = 1;
    	      String lsErrorSP = "";
    	      String ls_correo ="";
    	      String lsIntento = "";
    	        String lsError = "";
    	            int liIntento = 0;
    	        
    	final String ls_usuario = request.getParameter("usuario");
        final String ls_contrasena = request.getParameter("clave");
       final String ls_sociedad = request.getParameter("sociedad");
           
        
    	PrintWriter out = response.getWriter();
    	
    	 this.jspFactory = JspFactory.getDefaultFactory();
            this.pageContext = this.jspFactory.getPageContext((Servlet)this, (ServletRequest)request, (ServletResponse)response, (String)null, true, 0, true);
            this.cb = new ConectaBase(this.pageContext);
            boolean lb_existe = false;
            String ls_tipo_usuario = null;
            lsIntento = this.session.getAttribute("INTENTO").toString();
            liIntento = Integer.parseInt(lsIntento);
            
            if (liIntento >= 3) {
                if (this.cb.m_conn != null) {
                    this.cb.m_conn.close();
                }
                if (this.cb.m_conn_sesion != null) {
                    this.cb.m_conn_sesion.close();
                }
                (this.rd = request.getRequestDispatcher("../general/cerrarConexion.jsp")).forward((ServletRequest)request, (ServletResponse)response);
                return;
            }
            
            final Operacion op = new Operacion(this.pageContext);
            ls_tipo_usuario = op.ConsultaUser(ls_usuario, ls_contrasena, ls_sociedad);
            lb_existe = (ls_tipo_usuario != "");
            
            if (lb_existe) {
                lsError = this.session.getAttribute("ERROR").toString();
                if (lsError.equals("")) {
                    this.session.setAttribute("AUTH", (Object)"true");
                    this.session.setAttribute("USUARIO", (Object)ls_usuario);
                    this.session.setAttribute("PASS", (Object)ls_contrasena);
                    this.session.setAttribute("SOCIEDAD", (Object)ls_sociedad);
                    
                 // Llamada al procedimiento almacenado
                    CallableStatement cst = this.cb.getConnection().prepareCall("{call SAP.SAP_PORTAL_PROV.SWP_CONSULTA_CORREO (?,?,?,?)}");
                    cst.setString(1, ls_usuario);
                    
                    // Definimos los tipos de los parametros de salida del procedimiento almacenado
                    cst.registerOutParameter(2, java.sql.Types.VARCHAR);
                    cst.registerOutParameter(3, java.sql.Types.INTEGER);
                    cst.registerOutParameter(4, java.sql.Types.VARCHAR);
                    
                    // Ejecuta el procedimiento almacenado
                    cst.executeQuery();
                    
                    // Se obtienen la salida del procedimineto almacenado
                    ls_correo = cst.getString(2);
                    lnErrorSP = cst.getInt(3);
                    lsErrorSP = cst.getString(4);

                	 
                	if(lnErrorSP == 1) {
                		 out.println(lsErrorSP);
                    }else {
                    	out.print("exito");
                   } 
                    
                }else {
                	out.println("Error");
                }
               // this.rd.forward((ServletRequest)request, (ServletResponse)response);
         	          
         
            } else {
	            if (liIntento >= 3) {
	                if (this.cb.m_conn != null) {
	                    this.cb.m_conn.close();
	                }
	                if (this.cb.m_conn_sesion != null) {
	                    this.cb.m_conn_sesion.close();
	                }
	                (this.rd = request.getRequestDispatcher("../general/cerrarConexion.jsp")).forward((ServletRequest)request, (ServletResponse)response);
	                return;
	            }
	            lsIntento = Integer.toString(++liIntento);
	            
	            out.println("Usuario y/o contraseña incorrecto.");
	            
            }
        }
}

