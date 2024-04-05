package com.servlet;

import java.util.TimerTask;
import java.util.Timer;
import com.conexion.Operacion;
import javax.servlet.ServletResponse;
import javax.servlet.ServletRequest;
import javax.servlet.Servlet;
import java.io.IOException;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
import java.util.Date;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.JspFactory;
import com.conexion.ConectaBase;
import java.text.DateFormat;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServlet;
import java.sql.CallableStatement;



public class Login extends HttpServlet
{
    private static final long serialVersionUID = 1L;
    private static RequestDispatcher rd;
    private DateFormat ldFormat;
    private ConectaBase cb;
    public JspFactory jspFactory;
    public PageContext pageContext;
    public Date ldFecha;
    public HttpSession session;
    public Cookie cookie;
    
    public Login() {
        this.ldFormat = DateFormat.getDateInstance();
        this.jspFactory = null;
        this.ldFecha = new Date();
    }
    
    public void init(final ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    
    public void doPost(final HttpServletRequest request, final HttpServletResponse response) throws ServletException, 
    IOException {
        final String lsFecha = this.ldFormat.format(this.ldFecha).toString();
        (this.session = request.getSession(true)).setAttribute("DATE", (Object)lsFecha);
        try {
            this.verificaLogin(request, response);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        catch (Throwable e2) {
            e2.printStackTrace();
        }
    }
    
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
    
    
    public void verificaLogin(final HttpServletRequest request, final HttpServletResponse response) 
    		throws Throwable, Exception {
        int liIntento = 0;
        final String ls_usuario = request.getParameter("txtUser");
        final String ls_contrasena = request.getParameter("txtPassword");
        final String ls_sociedad = request.getParameter("cmbSociedad");
        
        final String ls_codigo = request.getParameter("txtOtp");
        
        String lsIntento = "";
        String lsError = "";
        
        //Agregar variables nuevos
        String ls_correo = "";
        int lnErrorSP = 1;
        String lsErrorSP = "";
        
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
            (Login.rd = request.getRequestDispatcher("../general/cerrarConexion.jsp")).forward((ServletRequest)request, (ServletResponse)response);
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
                //Login.rd = request.getRequestDispatcher("../protegido/frmMain.jsp"); //"../protegido/frmMain.jsp"
                
               
                //verificar codigo OTP
                
                if(!ls_codigo.trim().isEmpty()) {
                	
                	//CREAR EL PROCEDURE PARA SOLO LLENAR EL CORREO, EL CORREO DEBES GRABARLO EN ls_correo
                	// Llamada al procedimiento almacenado
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
                           (Login.rd = request.getRequestDispatcher("../general/error.jsp")).forward((ServletRequest)request, (ServletResponse)response);
                      }else {
                    	  Login.rd = request.getRequestDispatcher("../protegido/frmMain.jsp"); //"../protegido/frmMain.jsp"
                      }
                    
                   
                }else {
                	
                	// Llamada al procedimiento almacenado
                  /*  CallableStatement cst_codigo = this.cb.getConnection().prepareCall("{call SAP.SAP_PORTAL_PROV.SWP_GENERA_CODIGO_OTP (?,?,?,?)}");
                    cst_codigo.setString(1, ls_usuario);
                    cst_codigo.setString(2, ls_correo);
                    
                    // Definimos los tipos de los parametros de salida del procedimiento almacenado
                    cst_codigo.registerOutParameter(3, java.sql.Types.INTEGER);
                    cst_codigo.registerOutParameter(4, java.sql.Types.VARCHAR);
                    
                    // Ejecuta el procedimiento almacenado
                    cst_codigo.execute();*/
                    
                	
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
                    
                    /*if(lnErrorSP != 0) {
         
                     }else {
                    	 Login.rd = request.getRequestDispatcher("../login/login.jsp?pv_validarpin=S");
                     }*/
                  
                	
                	 
                	if(lnErrorSP == 1) {
                		
                   	    this.session.setAttribute("AUTH", (Object)"false");
                        this.session.setAttribute("ERROR", (Object)lsErrorSP);
                        this.session.setAttribute("MOSTRAR_BTN_REENVIAR", (Object)"true"); 
                        (Login.rd = request.getRequestDispatcher("../general/error.jsp")).forward((ServletRequest)request, (ServletResponse)response);
                    }else {
                   	this.session.setAttribute("CORREO", (Object)ls_correo);
                   	 Login.rd = request.getRequestDispatcher("../login/login.jsp");	
                   }
                }
                   
               
            } 
            else {
                Login.rd = request.getRequestDispatcher("../login/login.jsp");
            }
            Login.rd.forward((ServletRequest)request, (ServletResponse)response);
        }
        else {
            if (liIntento >= 3) {
                if (this.cb.m_conn != null) {
                    this.cb.m_conn.close();
                }
                if (this.cb.m_conn_sesion != null) {
                    this.cb.m_conn_sesion.close();
                }
                (Login.rd = request.getRequestDispatcher("../general/cerrarConexion.jsp")).forward((ServletRequest)request, (ServletResponse)response);
                return;
            }
            lsIntento = Integer.toString(++liIntento);
            this.session.setAttribute("AUTH", (Object)"false");
            this.session.setAttribute("INTENTO", (Object)lsIntento);
            this.session.setAttribute("ERROR", (Object)"Usuario y/o contrase\u00f1a incorrecto.");
            (Login.rd = request.getRequestDispatcher("../general/error.jsp")).forward((ServletRequest)request, (ServletResponse)response);
        }
    }
    
    
    /*public void verificarLoginGen(final HttpServletRequest request, final HttpServletResponse response) 
    		throws Throwable, Exception {
        int liIntento = 0;
        final String ls_usuario = request.getParameter("txtUser");
        final String ls_contrasena = request.getParameter("txtPassword");
        final String ls_sociedad = request.getParameter("cmbSociedad");
        String lsIntento = "";
        String lsError = "";
        this.jspFactory = JspFactory.getDefaultFactory();
        this.pageContext = this.jspFactory.getPageContext((Servlet)this, (ServletRequest)request, (ServletResponse)response, (String)null, true, 0, true);
        this.cb = new ConectaBase(this.pageContext);
        boolean lb_existe = false;
        
        lsIntento = this.session.getAttribute("INTENTO").toString();
        liIntento = Integer.parseInt(lsIntento);
        
        if (liIntento >= 3) {
            if (this.cb.m_conn != null) {
                this.cb.m_conn.close();
            }
            if (this.cb.m_conn_sesion != null) {
                this.cb.m_conn_sesion.close();
            }
            (Login.rd = request.getRequestDispatcher("../general/cerrarConexion.jsp")).forward((ServletRequest)request, (ServletResponse)response);
            return;
        }
        
       
    	
    }*/
    
    
    protected void starTimer(final HttpSession sesion) {
        final TimerTask timerTask = new TimerTask() {

			@Override
			public void run() {
				// TODO Auto-generated method stub
				session.invalidate();
			}
        	
        };
        final Timer timer = new Timer();
        timer.schedule(timerTask, 600000L);
    }
    
    public void destroy() {
        super.destroy();
    }
}