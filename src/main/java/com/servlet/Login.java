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
    
    public void verificaLogin(final HttpServletRequest request, final HttpServletResponse response) 
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
                Login.rd = request.getRequestDispatcher("../login/login.jsp?pv_validarpin=S");
            } 
            else {
                Login.rd = request.getRequestDispatcher("../login/login.jsp?pv_validarpin=N");
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