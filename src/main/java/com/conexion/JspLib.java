package com.conexion;

import javax.servlet.http.Cookie;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletResponse;
import javax.servlet.ServletRequest;
import java.util.Vector;
import java.util.Enumeration;
import javax.servlet.ServletConfig;
import javax.servlet.jsp.JspWriter;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;

public class JspLib
{
    private HttpServletRequest m_request;
    private HttpServletResponse m_response;
    private PageContext m_pageContext;
    private HttpSession m_session;
    private ServletContext m_application;
    private JspWriter m_out;
    private ServletConfig m_config;
    private Throwable m_exception;
    private Object m_page;
    
    public JspLib(final PageContext p_pc) {
        this.m_pageContext = p_pc;
        this.m_request = (HttpServletRequest)this.m_pageContext.getRequest();
        this.m_response = (HttpServletResponse)this.m_pageContext.getResponse();
        this.m_session = this.m_pageContext.getSession();
        this.m_application = this.m_pageContext.getServletContext();
        this.m_out = this.m_pageContext.getOut();
        this.m_config = this.m_pageContext.getServletConfig();
        this.m_exception = this.m_pageContext.getException();
        this.m_page = this.m_pageContext.getPage();
    }
    
    public HttpServletResponse getResponse() {
        return this.m_response;
    }
    
    public HttpServletRequest getRequest() {
        return this.m_request;
    }
    
    public JspWriter getOut() {
        return this.m_out;
    }
    
    public PageContext getPageContext() {
        return this.m_pageContext;
    }
    
    protected HttpSession getSession() {
        return this.m_session;
    }
    
    protected ServletContext getServletContext() {
        return this.m_application;
    }
    
    protected JspWriter getJspWriter() {
        return this.m_out;
    }
    
    protected ServletConfig getServletConfig() {
        return this.m_config;
    }
    
    protected Throwable getThrowable() {
        return this.m_exception;
    }
    
    protected Object getObject() {
        return this.m_page;
    }
    
    protected void obtenerSesion() {
        this.m_session = this.m_request.getSession(true);
    }
    
    protected void invalidarSesion() {
        this.m_session.invalidate();
    }
    
    public void limpiarSesion() {
        final String[] ls_nombreObjetos = this.getObjetosSesion();
        if (ls_nombreObjetos != null) {
            for (int li_i = 0; li_i < ls_nombreObjetos.length; ++li_i) {
                this.eliminarObjeto(ls_nombreObjetos[li_i]);
            }
        }
    }
    
    public String[] getObjetosSesion() {
        final Enumeration l_objetosAlmacenados = this.m_session.getAttributeNames();
        return this.getArray(l_objetosAlmacenados);
    }
    
    public String[] getParametros() {
        final Enumeration l_parametros = this.m_request.getParameterNames();
        return this.getArray(l_parametros);
    }
    
    public String[][] getParamValores() {
        final String[] la_nombres = this.getParametros();
        String[][] la_array = null;
        if (la_nombres != null && la_nombres.length > 0) {
            la_array = new String[la_nombres.length][2];
            for (int li_i = 0; li_i < la_nombres.length; ++li_i) {
                la_array[li_i][0] = la_nombres[li_i];
                la_array[li_i][1] = this.recuperarParametro(la_nombres[li_i]);
            }
        }
        return la_array;
    }
    
    public String getParamString() {
        final StringBuffer lsb_paramString = new StringBuffer();
        final String[][] ls_params = this.getParamValores();
        if (ls_params != null && ls_params.length > 0) {
            for (int li_i = 0; li_i < ls_params.length; ++li_i) {
                lsb_paramString.append(ls_params[li_i][0]);
                lsb_paramString.append("=");
                lsb_paramString.append(ls_params[li_i][1]);
                if (li_i < ls_params.length - 1) {
                    lsb_paramString.append("&");
                }
            }
        }
        return lsb_paramString.toString();
    }
    
    private String[] getArray(final Enumeration p_enum) {
        String[] la_array = null;
        if (p_enum != null) {
            final Vector l_vector = new Vector();
            int li_cont = 0;
            while (p_enum.hasMoreElements()) {
                ++li_cont;
                final String ls_cad = (String) p_enum.nextElement();
                l_vector.addElement(ls_cad);
            }
            if (li_cont > 0) {
                la_array = new String[li_cont];
                l_vector.copyInto(la_array);
            }
        }
        return la_array;
    }
    
    public boolean existeObjetoAplicacion(final String ps_nombreObjeto) {
        return this.m_application.getAttribute(ps_nombreObjeto) != null;
    }
    
    public void eliminarObjetoAplicacion(final String ps_nombreObjeto) {
        this.m_application.removeAttribute(ps_nombreObjeto);
    }
    
    public void guardarObjetoAplicacion(final String ps_nombreObjeto, final Object p_o) {
        try {
            this.guardarObjetoAplicacion(ps_nombreObjeto, p_o, true);
        }
        catch (Exception ex) {}
    }
    
    public void guardarObjetoAplicacion(final String ps_nombreObjeto, final Object p_o, final boolean pb_siempre) throws Exception {
        if (!pb_siempre && this.existeObjetoAplicacion(ps_nombreObjeto)) {
            throw new Exception("Variable " + ps_nombreObjeto + " ya existente en entorno");
        }
        this.m_application.setAttribute(ps_nombreObjeto, p_o);
    }
    
    public Object recuperarObjetoAplicacion(final String ps_nombreObjeto) {
        return this.m_application.getAttribute(ps_nombreObjeto);
    }
    
    public String recuperarStringAplicacion(final String ps_nombreObjeto) {
        return (String)this.recuperarObjetoAplicacion(ps_nombreObjeto);
    }
    
    public void guardarIntAplicacion(final String ps_nombreObjeto, final int pi_i) throws Exception {
        this.guardarIntAplicacion(ps_nombreObjeto, pi_i, true);
    }
    
    public void guardarIntAplicacion(final String ps_nombreObjeto, final int pi_i, final boolean pb_siempre) throws Exception {
        final Integer l_iObj = new Integer(pi_i);
        this.guardarObjetoAplicacion(ps_nombreObjeto, l_iObj, pb_siempre);
    }
    
    public int recuperarIntAplicacion(final String ps_nombreObjeto) throws Exception {
        final Integer l_iObj = (Integer)this.recuperarObjetoAplicacion(ps_nombreObjeto);
        if (l_iObj == null) {
            throw new Exception("Objeto no existente");
        }
        return l_iObj;
    }
    
    public boolean existeObjeto(final String ps_nombreObjeto) {
        return this.m_session.getAttribute(ps_nombreObjeto) != null;
    }
    
    public void eliminarObjeto(final String ps_nombreObjeto) {
        this.m_session.removeAttribute(ps_nombreObjeto);
    }
    
    public void guardarObjeto(final String ps_nombreObjeto, final Object p_o) {
        try {
            this.guardarObjeto(ps_nombreObjeto, p_o, true);
        }
        catch (Exception ex) {}
    }
    
    public void guardarObjeto(final String ps_nombreObjeto, final Object p_o, final boolean pb_siempre) throws Exception {
        if (!pb_siempre && this.existeObjeto(ps_nombreObjeto)) {
            throw new Exception("Variable " + ps_nombreObjeto + " ya existente en entorno");
        }
        this.m_session.setAttribute(ps_nombreObjeto, p_o);
    }
    
    public Object recuperarObjeto(final String ps_nombreObjeto) {
        return this.m_session.getAttribute(ps_nombreObjeto);
    }
    
    public String recuperarString(final String ps_nombreObjeto) {
        return (String)this.recuperarObjeto(ps_nombreObjeto);
    }
    
    public void guardarInt(final String ps_nombreObjeto, final int pi_i) throws Exception {
        this.guardarInt(ps_nombreObjeto, pi_i, true);
    }
    
    public void guardarInt(final String ps_nombreObjeto, final int pi_i, final boolean pb_siempre) throws Exception {
        final Integer l_iObj = new Integer(pi_i);
        this.guardarObjeto(ps_nombreObjeto, l_iObj, pb_siempre);
    }
    
    public int recuperarInt(final String ps_nombreObjeto) throws Exception {
        final Integer l_iObj = (Integer)this.recuperarObjeto(ps_nombreObjeto);
        if (l_iObj == null) {
            throw new Exception("Objeto no existente");
        }
        return l_iObj;
    }
    
    public String recuperarParametro(final String ps_nombreParametro) {
        return this.m_request.getParameter(ps_nombreParametro);
    }
    
    public int recuperarParametroInt(final String ps_nombreParametro) throws Exception {
        final String ls_par = this.recuperarParametro(ps_nombreParametro);
        if (ls_par == null) {
            throw new Exception("Parametro no existente");
        }
        return Integer.parseInt(ls_par);
    }
    
    public void incluirPagina(final String ps_pagina) throws ServletException, IOException {
        final RequestDispatcher l_rd = this.m_application.getRequestDispatcher(ps_pagina);
        l_rd.include((ServletRequest)this.m_request, (ServletResponse)this.m_response);
    }
    
    public void redirigirPagina(final String ps_pagina) {
        try {
            this.m_response.sendRedirect(ps_pagina);
        }
        catch (IOException ex) {}
    }
    
    public String getURIPagina() {
        final String ls_URI = String.valueOf(this.getURLRaiz()) + this.m_request.getServletPath();
        return ls_URI;
    }
    
    public String getURLPadre() {
        return this.m_request.getHeader("Referer");
    }
    
    public static String concatenarParametro(String ps_URL, final String ps_parametro) {
        if (ps_URL.indexOf("?") == -1) {
            ps_URL = String.valueOf(ps_URL) + "?";
        }
        else if (!ps_URL.endsWith("&") && !ps_URL.endsWith("?")) {
            ps_URL = String.valueOf(ps_URL) + "&";
        }
        ps_URL = String.valueOf(ps_URL) + ps_parametro;
        return ps_URL;
    }
    
    public String getIP() {
        String ip = this.m_request.getHeader("CLIENTIP");
        final Enumeration enumeration = this.m_request.getHeaderNames();
        while (enumeration.hasMoreElements()) {
            final String string = (String) enumeration.nextElement();
            if (string.equals("IV-REMOTE-ADDRESS")) {
                ip = this.m_request.getHeader(string);
            }
        }
        if (ip == null) {
            ip = this.m_request.getRemoteAddr();
        }
        return ip;
    }
    
    public String getHostRemoto() {
        return this.m_request.getRemoteHost();
    }
    
    public String getHostServidor() {
        return this.m_request.getHeader("Host");
    }
    
    public String getSessionId() {
        return this.m_session.getId();
    }
    
    public String getPathRaiz() {
        return this.m_application.getRealPath("");
    }
    
    public String getURLRaiz() {
        return this.m_request.getContextPath();
    }
    
    public String getPathSO(final String ps_path) {
        return String.valueOf(this.getPathRaiz()) + ps_path;
    }
    
    public void p(final String ps_textoHtml) {
        try {
            this.m_out.println(ps_textoHtml);
        }
        catch (IOException ex) {}
    }
    
    public String getPathTipoConexion() {
        return this.getPathTipoConexion(this.getPathRaiz());
    }
    
    public String getPathTipoConexion(final String ps_raizAplicacion) {
        final String ls_sep = File.separator;
        final String ls_nombreArchivo = String.valueOf(ps_raizAplicacion) + this.subPathConfig() + ls_sep + "info_conexion.txt";
        return ls_nombreArchivo;
    }
    
    public void setCookie(final String ps_nombreCookie, final String ps_valor) {
        final int li_duracion = -1;
        this.setCookie(ps_nombreCookie, ps_valor, li_duracion);
    }
    
    public void setCookie(final String ps_nombreCookie, final String ps_valor, final int pi_duracion) {
        final Cookie l_cookie = new Cookie(ps_nombreCookie, ps_valor);
        l_cookie.setMaxAge(pi_duracion);
        this.m_response.addCookie(l_cookie);
    }
    
    public String getCookie(final String ps_nombreCookie) {
        final Cookie[] l_cookies = this.m_request.getCookies();
        final String ls_valorCookie = getValorCookie(l_cookies, ps_nombreCookie, null);
        return ls_valorCookie;
    }
    
    public static String getValorCookie(final Cookie[] p_cookies, final String ps_nombreCookie, final String ps_valorDefecto) {
        for (int li_i = 0; li_i < p_cookies.length; ++li_i) {
            if (ps_nombreCookie.equals(p_cookies[li_i].getName())) {
                return p_cookies[li_i].getValue();
            }
        }
        return ps_valorDefecto;
    }
    
    private String subPathConfig() {
        final String ls_sep = File.separator;
        final String ls_subPath = String.valueOf(ls_sep) + "configuracion";
        return ls_subPath;
    }
}