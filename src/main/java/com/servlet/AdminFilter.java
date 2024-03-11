package com.servlet;

import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.FilterChain;
import javax.servlet.ServletResponse;
import javax.servlet.ServletRequest;
import javax.servlet.Filter;

public class AdminFilter implements Filter
{
    public void doFilter(final ServletRequest request, final ServletResponse response, final FilterChain chain) throws IOException, ServletException {
        final HttpServletRequest requestMod = (HttpServletRequest)request;
        if (!this.isPermited(requestMod)) {
            requestMod.getSession().setAttribute("ERROR", (Object)"Su conexion se ha cerrado");
            final RequestDispatcher noPermited = request.getRequestDispatcher("/paginas/general/error.jsp");
            noPermited.forward(request, response);
        }
        else {
            chain.doFilter(request, response);
        }
    }
    
    private boolean isPermited(final HttpServletRequest request) {
        return request.getSession().getAttribute("AUTH") != "false" && request.getSession().getAttribute("USUARIO") != null;
    }
    
    public void init(final FilterConfig filterConfig) throws ServletException {
    }
    
    public void destroy() {
    }
}