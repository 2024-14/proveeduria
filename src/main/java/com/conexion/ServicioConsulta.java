package com.conexion;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import javax.servlet.jsp.PageContext;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;

public class ServicioConsulta extends ConectaBase
{
    private CallableStatement cas;
    private PreparedStatement pst;
    private String lsQuery;
    private ResultSet rs;
    
    public ServicioConsulta(final PageContext pc) throws Exception, SQLException {
        super(pc);
    }
    
    public String obtieneMes(final String num) {
        String mes = null;
        switch (Integer.parseInt(num)) {
            case 1: {
                mes = "ENERO";
                break;
            }
            case 2: {
                mes = "FEBRERO";
                break;
            }
            case 3: {
                mes = "MARZO";
                break;
            }
            case 4: {
                mes = "ABRIL";
                break;
            }
            case 5: {
                mes = "MAYO";
                break;
            }
            case 6: {
                mes = "JUNIO";
                break;
            }
            case 7: {
                mes = "JULIO";
                break;
            }
            case 8: {
                mes = "AGOSTO";
                break;
            }
            case 9: {
                mes = "SEPTIEMBRE";
                break;
            }
            case 10: {
                mes = "OCTUBRE";
                break;
            }
            case 11: {
                mes = "NOVIEMBRE";
                break;
            }
            case 12: {
                mes = "DICIEMBRE";
                break;
            }
        }
        return mes;
    }
    
    public String metaIndicadores(String oficina, final String fechaDesde, final String fechaHasta) {
        String meta = "";
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            final int mes_int = Integer.parseInt(fechaHasta.substring(4, 5));
            System.out.println("desde JAVA sC.metaIndicadores ::MES:" + mes_int + " FechaInicio : " + fechaDesde + " FechaFin : " + fechaHasta);
            oficina = oficina.replaceAll("~", " ");
            this.lsQuery = "select X.ENERO, X.FEBRERO, X.MARZO, X.ABRIL, X.MAYO, X.JUNIO, X.JULIO, X.AGOSTO, X.SEPTIEMBRE, X.OCTUBRE, X.NOVIEMBRE, X.DICIEMBRE  from SAP.SAP_INDICADOR_SERVICIOS X where X.NOMBRE_OFICINA = '" + oficina + "'";
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            while (this.rs.next()) {
                meta = this.rs.getString(mes_int);
                System.out.println(meta);
            }
        }
        catch (Exception e) {
            System.out.println(this.lsQuery);
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        finally {
            try {
                this.rs.close();
            }
            catch (Exception ex) {}
        }
        try {
            this.rs.close();
        }
        catch (Exception ex2) {}
        System.out.println("QUERY: " + this.lsQuery + "META:" + meta);
        return meta;
    }
    
    public ResultSet detalleEnvioSap(final String contrato) {
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            this.lsQuery = "select  p.prheader as SOLICITUD, p.preq_item as POSICION_SOLICITUD, p.agreement as CONTRATO, p.agmt_item as POSICION_CONTRATO, p.plant as CENTRO, nvl(ph.cantidad_recibida,0) as CANTIDAD_RECIBIDA, p.preq_price * ph.cantidad_recibida as PRECIO from SAP.SAP_PROVEEDURIA_REPLICA p, SAP.SAP_PROVEEDURIA_DETALLE_HIS ph where p.prheader = ph.solicitud and P.PREQ_ITEM=PH.NUMERO_LINEA and p.agreement = ?  and rel_ind in ('6','7')  and ph.cantidad_recibida > 0";
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, contrato);
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            System.out.println("error java2");
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            this.rs = null;
        }
        return this.rs;
    }
    
    public List<String> proveedorIndicador(final String sociedad, final String proveedor) {
        List<String> resultado = null;
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            this.lsQuery = "select usuario from SAP.SAP_USUARIO_PORTAL up where up.rol = 'P' and up.estado='A' and up.sociedad = '" + sociedad + "'" + " and up.usuario = nvl('" + proveedor + "', up.usuario)";
            System.out.println(this.lsQuery);
            resultado = new ArrayList<String>();
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            while (this.rs.next()) {
                resultado.add(this.rs.getString(1));
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            this.rs = null;
        }
        finally {
            try {
                this.rs.close();
                this.pst.close();
            }
            catch (Exception ex) {}
        }
        try {
            this.rs.close();
            this.pst.close();
        }
        catch (Exception ex2) {}
        return resultado;
    }
    
    public List<String> obtieneIndicadoresv2(final String proveedor, final String fechaDesde, final String fechaHasta, final String sociedad) {
        List<String> resultado = null;
        try {
            final List<String[]> ind1 = this.reporteIndicadores(sociedad, proveedor, fechaDesde, fechaHasta, "11");
            final float f1 = (float)ind1.size();
            final List<String[]> ind2 = this.reporteIndicadores(sociedad, proveedor, fechaDesde, fechaHasta, "22");
            final float f2 = (float)ind2.size();
            final List<String[]> ind3 = this.reporteIndicadores(sociedad, proveedor, fechaDesde, fechaHasta, "33");
            final float f3 = (float)ind3.size();
            final List<String[]> base = this.reporteIndicadores(sociedad, proveedor, fechaDesde, fechaHasta, "0");
            final float f4 = (float)base.size();
            System.out.println("Indicador 1 :" + f1);
            System.out.println("Indicador 2 :" + f2);
            System.out.println("Indicador 3 :" + f3);
            System.out.println("Base: " + f4);
            resultado = new ArrayList<String>();
            if (f4 == 0.0f) {
                resultado.add("0,00");
                resultado.add("0,00");
                resultado.add("0,00");
            }
            else {
                final float r1 = f1 / f4 * 100.0f;
                final float r2 = f2 / f4 * 100.0f;
                final float r3 = f3 / f4 * 100.0f;
                resultado.add(String.format("%.02f", r1));
                resultado.add(String.format("%.02f", r2));
                resultado.add(String.format("%.02f", r3));
                System.out.println(String.valueOf(r1) + "%");
                System.out.println(String.valueOf(r2) + "%");
                System.out.println(String.valueOf(r3) + "%");
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return resultado;
    }
    
    public int obtieneTotalIndicadores(final String proveedor, final String fechaDesde, final String fechaHasta, final String sociedad) throws SQLException {
        int resultado = 0;
        List<String[]> base = null;
        try {
            base = this.reporteIndicadores(sociedad, proveedor, fechaDesde, fechaHasta, "0");
            resultado = base.size();
            System.out.println(resultado);
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return resultado;
    }
    
    public int obtieneIndicadores(final String proveedor, final String fechaDesde, final String fechaHasta, final StringBuffer pv_error, final String sociedad) {
        int i = 3;
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.cas != null) {
                this.cas.close();
            }
            this.lsQuery = "{call sap.sak_trx_proveeduria_Ind.saf_Ind_proceso(?,?,?,?,?)}";
            (this.cas = this.m_conn.prepareCall(this.lsQuery)).setString(1, proveedor);
            this.cas.setString(2, fechaDesde);
            this.cas.setString(3, fechaHasta);
            this.cas.registerOutParameter(4, 2);
            this.cas.registerOutParameter(5, 12);
            this.cas.execute();
            i = this.cas.getInt(4);
            pv_error.append(this.cas.getString(5));
            System.out.println("obtuvo ok? := " + i);
        }
        catch (Exception e) {
            i = -4;
            pv_error.append(e.getMessage());
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        finally {
            try {
                this.cas.close();
            }
            catch (Exception ex) {}
        }
        try {
            this.cas.close();
        }
        catch (Exception ex2) {}
        return i;
    }
    
    public ResultSet consultaIndicadores() {
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            this.lsQuery = "select x.proveedor, x.indicador_1, x.indicador_2, x.indicador_3 from SAP.SAP_INDICADORES_TMP x";
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            System.out.println("error java2");
            e.printStackTrace();
            this.rs = null;
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return this.rs;
    }
    
    public List<String[]> consultaReporteGeneral(final String sociedad, final String proveedor, final String solicitud, final String area, final String usuario, final String ceco, final String fechaDesde, final String fechaHasta) throws SQLException {
        String compl = "";
        if (!area.equals("")) {
            compl = "\t\t   and  b.area_empresa = nvl('" + area + "', b.area_empresa) ";
        }
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select s.nombre_empresa, \t\t   d.nombre_proveedor, \t\t   a.prheader, \t\t   b.region, \t\t   nvl(b.nombre_oficina, ' - '), \t\t   a.name, \t\t   decode(a.rel_ind, \t\t\t\t  '2', \t\t\t\t  'No Despachado', \t\t\t\t  '3', \t\t\t\t  'Despachado Parcial', \t\t\t\t  '4', \t\t\t\t  'Despachado Total', \t\t\t\t  '10', \t\t\t\t  'Despachado Denegado', \t\t\t\t  '6', \t\t\t\t  'Recibido Parcial', \t\t\t\t  '7', \t\t\t\t  'Recibido Total', \t\t\t\t  '11', \t\t\t\t  'No Recibido', \t\t\t\t  a.rel_ind) as Estado, \t\t   a.costcenter, \t\t   b.area_empresa, \t\t   to_char(nvl(max(c.fecha_despachada), max(a.deliv_date)), \t\t\t\t   'dd/mm/yyyy') as Fecha_Despacho, \t\t   to_char(nvl(max(c.fecha_recibido), max(a.deliv_date)),  \t\t\t\t  'dd/mm/yyyy') as Fecha_Recibido, \t\t   a.material,        \t\t   a.short_text, \t\t   nvl(desp.guia_remision, ' '),                 \t\t   a.Quantity as Cant_Solicitada, \t\t   nvl(sum(desp.cantidad_despachada), 0) as Cant_Despachada, \t\t   nvl(sum(c.cantidad_recibida), 0) as Cant_Recibida, \t\t   nvl(a.preq_price, 0) as Costo_Unitario, \t\t   nvl( nvl(sum(c.cantidad_recibida),0 )  *  a.preq_price , 0 ) as Costo_Total \t\t  from SAP.SAP_PROVEEDURIA_REPLICA a \t\t  left join SAP.SAP_USUARIOS b \t\t    on (b.codigo_usuario = a.created_by and b.sociedad = a.bukrs) \t\t  left join SAP.SAP_PROVEEDURIA_DETALLE_HIS c \t\t    on (c.solicitud = a.prheader and c.numero_linea = a.preq_item and c.estado = a.rel_ind) \t\t  left join SAP.SAP_PROVEEDURIA_DETALLE_HIS desp \t\t    on (desp.solicitud = a.prheader and desp.numero_linea = a.preq_item and desp.estado in ('2','3','4','10')) \t\t  left join SAP.SAP_USUARIO_PORTAL d \t\t    on (a.stcd1 = d.id_proveedor and d.sociedad = nvl('" + sociedad + "', d.sociedad)) " + "\t\t  left join SAP.SAP_SOCIEDAD s " + "\t\t    on (s.codigo_soc_sap_ii = a.bukrs) " + "\t\t where a.bukrs = nvl('" + sociedad + "', a.bukrs) " + "\t\t   and d.usuario = nvl('" + proveedor + "', d.usuario) " + "\t\t   and a.prheader = nvl('" + solicitud + "', a.prheader) " + "\t\t   and ( a.created_by = nvl('" + usuario + "', a.created_by) " + "\t\t   \t\tor  upper(a.name) like nvl(upper('%" + usuario + "%'),  a.name) ) " + "\t\t   and a.costcenter = nvl('" + ceco + "', a.costcenter) " + "\t\t\t" + compl + "\t\t " + "\t\t Group by s.nombre_empresa, " + "\t\t          d.nombre_proveedor, " + "\t\t          a.prheader, " + "\t\t          b.region, " + "\t\t          b.nombre_oficina, " + "\t\t          a.name, " + "\t\t          a.rel_ind, " + "\t\t          a.costcenter, " + "\t\t          b.area_empresa, " + "\t\t          a.deliv_date, " + "\t\t          a.material, " + "\t\t          a.short_text, " + "\t\t          desp.guia_remision, " + "\t\t          a.Quantity, " + "\t\t          a.preq_price, " + "\t\t\t      a.preq_item " + "\t\thaving a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy') and a.rel_ind in('2', " + "\t\t                                                     '3', " + "\t\t                                                     '4', " + "\t\t                                                     '10', " + "\t\t                                                     '6', " + "\t\t                                                     '7', " + "\t\t                                                     '11') " + "\t\t Order by d.nombre_proveedor, prheader desc ";
            System.out.println("Query consultaReporteGeneral: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4), this.rs.getString(5), this.rs.getString(6), this.rs.getString(7), this.rs.getString(8), this.rs.getString(9), this.rs.getString(10), this.rs.getString(11), this.rs.getString(12), this.rs.getString(13), this.rs.getString(14), this.rs.getString(15), this.rs.getString(16), this.rs.getString(17), String.format("%.02f", this.rs.getFloat(18)).replace(".", ","), String.format("%.02f", this.rs.getFloat(19)).replace(".", ",") };
                resultado.add(fila);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
            return resultado;
        }
        finally {
            this.rs.close();
            this.pst.close();
        }
        this.rs.close();
        this.pst.close();
        return resultado;
    }
    
    public List<String[]> reporteIndicadores(final String sociedad, final String proveedor, final String fechaDesde, final String fechaHasta, final String tipoInd) {
        System.out.println("\nReporteIndicadoresV2\nIndicador # " + tipoInd + "\nproveedor:" + proveedor);
        String detalleRep = " ";
        if (tipoInd.equals("1")) {
            detalleRep = "  and a.rel_ind in ('2','10','11')";
        }
        else if (tipoInd.equals("2")) {
            detalleRep = "  \tand ((desp.estado in ('3','4') and desp.fecha_despachada > a.deliv_date ) \t\tor  a.rel_ind in ('2','11') )  ";
        }
        else if (tipoInd.equals("3")) {
            detalleRep = " and (rec.estado not in ('7')  or rec.estado is null)";
        }
        else if (tipoInd.equals("11")) {
            detalleRep = " and desp.estado in ('3','4')\t and a.rel_ind not in ('10')";
        }
        else if (tipoInd.equals("22")) {
            detalleRep = "  and  desp.estado in ('3', '4')  and desp.fecha_despachada <= a.deliv_date ";
        }
        else if (tipoInd.equals("33")) {
            detalleRep = " and rec.estado in ('7')";
        }
        List<String[]> resultado = null;
        try {
            this.lsQuery = "\t\tselect \t\t   d.nombre_proveedor,\t\t\t\t       a.prheader as Solicitud,\t\t\t\t       a.short_text as Detalle,\t\t\t\t       b.nombre_oficina as Sitio,\t\t\t\t       desp.fecha_despachada as Fecha_Desp, \t\t\t\t       decode(desp.estado,\t\t\t\t              '',    'No Despachado',\t\t\t\t              '3',   'Despachado Parcial',\t\t\t\t              '4',   'Despachado Total') as Estad_Desp,\t\t\t\t       rec.fecha_recibido as Fech_Reciv,\t\t\t\t       decode(rec.estado,\t\t\t\t              '6',   'Recibido Parcial',\t\t\t\t              '7',   'Recibido Total',\t\t\t\t              '10',  'Despacho Denegado',\t\t\t\t              '11',  'No Recibido',\t\t\t\t              '',    ' ') as Estad_Reciv,\t\t\t\t       rec.observacion,\t\t\t\t       a.rel_ind as EstadoActual\t\t\t\t\t\t\t\tfrom SAP.SAP_PROVEEDURIA_REPLICA a\t\t\t\tleft join ( select * from SAP.SAP_PROVEEDURIA_DETALLE_HIS p\t\t\t\t               where p.fecha_ingresado = ( select max(fecha_ingresado)\t\t\t\t                                           from SAP.SAP_PROVEEDURIA_DETALLE_HIS px\t\t\t\t                                           where p.solicitud = px.solicitud\t\t\t\t                                           and p.numero_linea = px.numero_linea\t\t\t\t                                           and p.stcd1 = px.stcd1\t\t\t\t                                          )\t\t\t\t            ) desp\t\t\t\ton (\t\t\t\t        desp.solicitud = a.prheader and \t\t\t\t        desp.numero_linea = a.preq_item and\t\t\t\t        desp.material = a.material\t\t\t\t   )\t\t\t\t\t\t\t\t  left join SAP.SAP_PROVEEDURIA_DETALLE_HIS rec\t\t\t\t    on (rec.solicitud = a.prheader and \t\t\t\t       rec.numero_linea = a.preq_item and\t\t\t\t       rec.proveedor = a.stcd1)\t\t\t\t       \t\t\t\t left join SAP.SAP_USUARIOS b\t\t\t\t    on (b.codigo_usuario = a.created_by and b.sociedad = a.bukrs)\t\t\t\t  left join SAP.SAP_USUARIO_PORTAL d\t\t\t\t    on (a.stcd1 = d.id_proveedor and d.sociedad = nvl('" + sociedad + "', d.sociedad))" + "\t\t\t\t  left join SAP.SAP_SOCIEDAD s" + "\t\t\t\t    on (s.codigo_soc_sap_ii = a.bukrs)" + "\t\t\t\t  " + "\t\t\t\twhere a.bukrs = nvl('" + sociedad + "', a.bukrs)" + "\t\t\t\tand d.usuario = nvl('" + proveedor + "', d.usuario)" + "\t\t\t\tand a.deliv_date between to_date('" + fechaDesde + "', 'dd/mm/yyyy') and" + "\t\t\t\tto_date('" + fechaHasta + "', 'dd/mm/yyyy')" + "\t\t\t\t" + detalleRep + " \t" + "\t\t\t\t order by d.nombre_proveedor, a.prheader desc";
            System.out.println("Query reporteIndicadores: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4), String.valueOf(this.rs.getDate(5)), this.rs.getString(6), String.valueOf(this.rs.getDate(7)), this.rs.getString(8), this.rs.getString(9) };
                resultado.add(fila);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
            try {
                this.rs.close();
                this.pst.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
            return resultado;
        }
        finally {
            try {
                this.rs.close();
                this.pst.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
        try {
            this.rs.close();
            this.pst.close();
        }
        catch (SQLException e2) {
            e2.printStackTrace();
        }
        return resultado;
    }
    public void cerrarSesionBD() throws Exception {
        try {
            if (this.m_conn != null) {
                this.m_conn.close();
            }
            if (this.m_conn_sesion != null) {
                this.m_conn_sesion.close();
            }
            this.m_session.setAttribute("PS_CONEXION", (Object)null);
        }
        catch (Exception e) {
            e.getStackTrace();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
    }
    
    public void AbrirArchivo(final String Archivo, final String direccion) {
        try {
            final String Documento = String.valueOf(direccion) + Archivo;
            Documento.replace("/", "\"");
            final File ficheroXLS = new File(Documento);
            final FileInputStream fis = new FileInputStream(ficheroXLS);
            final byte[] bytes = new byte[1000];
            int read = 0;
            final String fileName = ficheroXLS.getName();
            final String contentType = "application/" + (Archivo.contains(".pdf") ? "pdf" : "xml");
            final HttpServletResponse response = this.m_response;
            response.setContentType(contentType);
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
            final ServletOutputStream out = response.getOutputStream();
            while ((read = fis.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
            out.flush();
            out.close();
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
        }
    }
}