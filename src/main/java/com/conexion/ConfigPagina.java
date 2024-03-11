package com.conexion;

import java.sql.SQLException;
import java.io.IOException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.JspWriter;

public class ConfigPagina
{
    private JspWriter m_out;
    
    public ConfigPagina(final PageContext p_pageContext) throws IOException, SQLException {
    }
    
    public void lov() throws IOException {
        this.m_out.println("<!--/******* LOV *******/-->");
        final String ls_dir = "/proveeduria";
        this.m_out.println("<script type=\"text/javascript\" language=\"JavaScript\">");
        this.m_out.println("function lov(ps_select,ps_from,ps_where,ps_groupBy,ps_having,ps_orderBy,ps_columnaCond,ps_tituloLov,ps_destino1,ps_destino2,ps_posX,ps_posY,ps_ancho, ps_alto, ps_script){");
        this.m_out.println("var ventana_variable =\"" + ls_dir + "\";");
        this.m_out.println("var arreglo1 = window.location.pathname.split('/');");
        this.m_out.println("var tameb =\"/\"+arreglo1[1];");
        this.m_out.println("if(tameb != ventana_variable){");
        this.m_out.println("ventana_variable = tameb  + ventana_variable;");
        this.m_out.println("}");
        this.m_out.println("var ls_parametros=ventana_variable+\"/paginas/general/gef_dialogo.jsp?titulo=\"+ps_tituloLov+\"&nombreDialogo=gep_lov.jsp?&\";");
        this.m_out.println("if(ps_posX==null){");
        this.m_out.println("ps_posX='400px';");
        this.m_out.println("}");
        this.m_out.println("if(ps_posY==null){");
        this.m_out.println("ps_posY='180px';");
        this.m_out.println("}");
        this.m_out.println("if(ps_ancho==null){");
        this.m_out.println("ps_ancho='215px';");
        this.m_out.println("}");
        this.m_out.println("if(ps_alto==null){");
        this.m_out.println("ps_alto='180px';");
        this.m_out.println("}");
        this.m_out.println("if(ps_select!=null && ps_select.length>0){");
        this.m_out.println("ls_parametros=ls_parametros + \"ps_select=\"+ps_select;");
        this.m_out.println("}");
        this.m_out.println("if(ps_from!=null && ps_from.length>0){");
        this.m_out.println("ls_parametros=ls_parametros + \"&ps_from=\"+ps_from;");
        this.m_out.println("}");
        this.m_out.println("if(ps_where!=null && ps_where.length>0){");
        this.m_out.println("var ls_where = ps_where;");
        this.m_out.println("ls_where = ls_where.replace(\"%\",new String(\"!\"));");
        this.m_out.println("ls_parametros=ls_parametros + \"&ps_where=\"+ls_where;");
        this.m_out.println("}");
        this.m_out.println("if(ps_script!=null && ps_script.length>0){");
        this.m_out.println("var ls_script = ps_script;}");
        this.m_out.println("else{");
        this.m_out.println("var ls_script= 'ninguno'}");
        this.m_out.println("ls_parametros=ls_parametros + \"&ps_script=\"+ls_script;");
        this.m_out.println("ls_parametros=ls_parametros+\"&ps_groupBy=\"+ps_groupBy+\"&ps_having=\"+ps_having+\"&ps_orderBy=\"+ps_orderBy;");
        this.m_out.println("if(ps_columnaCond!=null && ps_columnaCond.length>0){");
        this.m_out.println("ls_parametros=ls_parametros + \"&ps_columnaCond=\"+ps_columnaCond;");
        this.m_out.println("}");
        this.m_out.println("if(ps_tituloLov!=null && ps_tituloLov.length>0){");
        this.m_out.println("ls_parametros=ls_parametros + \"&ps_tituloLov=\"+ps_tituloLov;");
        this.m_out.println("}");
        this.m_out.println("if(ps_destino1!=null && ps_destino1.length>0){");
        this.m_out.println("ls_parametros=ls_parametros + \"&ps_destino1=\"+ps_destino1;");
        this.m_out.println("}");
        this.m_out.println("ls_parametros=ls_parametros+ \"&ps_destino2=\"+ps_destino2;");
        this.m_out.println("window.showModalDialog(ls_parametros, window,\"dialogTop=\"+ps_posY+\"; dialogLeft=\"+ps_posX+\"; dialogWidth=\"+ps_ancho+\"; dialogHeight=\"+ps_alto+\"; help=no; status=no; scrolling=NO\");");
        this.m_out.println("}");
        this.m_out.println("</script>");
    }
}