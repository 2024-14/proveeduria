package com.conexion;

import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.Date;
import java.sql.Connection;
import java.util.HashMap;
import java.io.File;
import java.io.FileNotFoundException;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import java.util.Map;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperCompileManager;
import com.DAO.RespuestaSap;
import java.sql.Statement;
import java.util.Calendar;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import javax.servlet.jsp.PageContext;
import java.sql.ResultSet;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;

public class ServiciosAdministrador extends ConectaBase
{
    private PreparedStatement pst;
    private CallableStatement cas;
    private String lsQuery;
    private ResultSet rs;
    
    public ServiciosAdministrador(final PageContext pc) throws Exception, SQLException {
        super(pc);
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
    
    public String[] estadoAdministrador() {
        String estadosDatos = this.properties.getProperty("estados.datos");
        final int estadosLongitud = Integer.parseInt(this.properties.getProperty("estados.longitud"));
        String[] estados = null;
        int longitud = estadosDatos.length();
        estados = new String[estadosLongitud];
        for (int contador = 0; longitud > 1 && estadosDatos != null; estadosDatos = estadosDatos.substring(estadosDatos.indexOf("|") + 1), longitud = estadosDatos.length(), ++contador) {
            estados[contador] = estadosDatos.substring(0, estadosDatos.indexOf("|"));
        }
        return estados;
    }
    
    public List<String[]> obenterMetaIndicador(final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = " select * from SAP.SAP_INDICADOR_SERVICIOS a where a.sociedad = '" + sociedad + "'";
            System.out.println("Query obenterMetaIndicador: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4), this.rs.getString(5), this.rs.getString(6), this.rs.getString(7), this.rs.getString(8), this.rs.getString(9), this.rs.getString(10), this.rs.getString(11), this.rs.getString(12), this.rs.getString(13), this.rs.getString(14), this.rs.getString(15) };
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
    
    public String crearIndicadorServicio(String nombre_oficina, final String enero, final String febrero, final String marzo, final String abril, final String mayo, final String junio, final String julio, final String agosto, final String septiembre, final String octubre, final String noviembre, final String diciembre, String estado, final String Sociedad) {
        String resultado = "";
        try {
            this.lsQuery = "insert into SAP.SAP_INDICADOR_SERVICIOS  (nombre_oficina, enero, febrero, marzo, abril, mayo, junio, julio, agosto, septiembre, octubre, noviembre, diciembre, estado, sociedad) values  (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15) ";
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            if (estado == null) {
                estado = "N";
            }
            nombre_oficina = nombre_oficina.replaceAll("~", " ");
            this.pst.setString(1, nombre_oficina);
            this.pst.setString(2, enero);
            this.pst.setString(3, febrero);
            this.pst.setString(4, marzo);
            this.pst.setString(5, abril);
            this.pst.setString(6, mayo);
            this.pst.setString(7, junio);
            this.pst.setString(8, julio);
            this.pst.setString(9, agosto);
            this.pst.setString(10, septiembre);
            this.pst.setString(11, octubre);
            this.pst.setString(12, noviembre);
            this.pst.setString(13, diciembre);
            this.pst.setString(14, estado);
            this.pst.setString(15, Sociedad);
            final int i = this.pst.executeUpdate();
            System.out.println("ejecuta insert " + i);
            this.m_conn.commit();
            resultado = "MetaIndicador Creado Correctamente.";
        }
        catch (SQLException e2) {
            System.out.println("Error al insert");
            resultado = "Error al crear MetaIndicador.";
            try {
                this.m_conn.rollback();
            }
            catch (SQLException e1) {
                e1.printStackTrace();
                this.m_session.setAttribute("requestedPage", (Object)e1.getMessage());
            }
            e2.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e2.getMessage());
            try {
                this.pst.close();
            }
            catch (SQLException e3) {
                e3.printStackTrace();
            }
            return resultado;
        }
        finally {
            try {
                this.pst.close();
            }
            catch (SQLException e3) {
                e3.printStackTrace();
            }
        }
        try {
            this.pst.close();
        }
        catch (SQLException e3) {
            e3.printStackTrace();
        }
        return resultado;
    }
    
    public String actualizarIndicadorServicio(String nombre_oficina, final String enero, final String febrero, final String marzo, final String abril, final String mayo, final String junio, final String julio, final String agosto, final String septiembre, final String octubre, final String noviembre, final String diciembre, String estado, final String sociedad) {
        String resultado = "";
        try {
            this.lsQuery = " update SAP.SAP_INDICADOR_SERVICIOS  set enero = :v_enero,  febrero = :v_febrero,  marzo = :v_marzo,  abril = :v_abril,  mayo = :v_mayo,  junio = :v_junio,  julio = :v_julio,  agosto = :v_agosto,  septiembre = :v_septiembre,  octubre = :v_octubre,  noviembre = :v_noviembre,  diciembre = :v_diciembre,  estado = :v_estado  where nombre_oficina = :v_nombre_oficina and sociedad = :v_sociedad";
            if (this.pst != null) {
                this.pst.close();
            }
            if (this.rs != null) {
                this.rs.close();
            }
            nombre_oficina = nombre_oficina.replaceAll("~", " ");
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, enero);
            this.pst.setString(2, febrero);
            this.pst.setString(3, marzo);
            this.pst.setString(4, abril);
            this.pst.setString(5, mayo);
            this.pst.setString(6, junio);
            this.pst.setString(7, julio);
            this.pst.setString(8, agosto);
            this.pst.setString(9, septiembre);
            this.pst.setString(10, octubre);
            this.pst.setString(11, noviembre);
            this.pst.setString(12, diciembre);
            if (estado == null) {
                estado = "N";
            }
            this.pst.setString(13, estado);
            this.pst.setString(14, nombre_oficina);
            this.pst.setString(15, sociedad);
            System.out.println("Query actualizarIndicadorServicio: " + this.lsQuery);
            final int i = this.pst.executeUpdate();
            this.m_conn.commit();
            resultado = "MetaIndicador actualizado correctamente.";
        }
        catch (SQLException e2) {
            resultado = "Error al actualizar MetaIndicador.";
            System.out.println("Error al insert");
            try {
                this.m_conn.rollback();
            }
            catch (SQLException e1) {
                e1.printStackTrace();
            }
            e2.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e2.getMessage());
            try {
                this.pst.close();
            }
            catch (SQLException e3) {
                e3.printStackTrace();
            }
            return resultado;
        }
        finally {
            try {
                this.pst.close();
            }
            catch (SQLException e3) {
                e3.printStackTrace();
            }
        }
        try {
            this.pst.close();
        }
        catch (SQLException e3) {
            e3.printStackTrace();
        }
        return resultado;
    }
    
    public String eliminarIndicadorServicio(String nombre_oficina, final String Sociedad) {
        String resultado = "";
        try {
            this.lsQuery = " delete SAP.SAP_INDICADOR_SERVICIOS  where nombre_oficina = :v_nombre_oficina and sociedad = '" + Sociedad + "'";
            if (this.pst != null) {
                this.pst.close();
            }
            if (this.rs != null) {
                this.rs.close();
            }
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            nombre_oficina = nombre_oficina.replaceAll("~", " ");
            System.out.println(nombre_oficina);
            this.pst.setString(1, nombre_oficina);
            final int i = this.pst.executeUpdate();
            System.out.println("ejecuta insert " + i);
            this.m_conn.commit();
            resultado = "MetaIndicador Eliminado Correctamente";
        }
        catch (SQLException e) {
            System.out.println("Error al Eliminar MetaIndicador");
            resultado = "Error al eliminar el MetaIndicador. " + e.getMessage();
            try {
                this.m_conn.rollback();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            try {
                this.pst.close();
            }
            catch (SQLException e3) {
                e3.printStackTrace();
            }
            return resultado;
        }
        finally {
            try {
                this.pst.close();
            }
            catch (SQLException e3) {
                e3.printStackTrace();
            }
        }
        try {
            this.pst.close();
        }
        catch (SQLException e3) {
            e3.printStackTrace();
        }
        return resultado;
    }
    
    public String fechaInicio() {
        String fechaInicio = "";
        String dia = "";
        String mes = "";
        final Calendar cal = Calendar.getInstance();
        cal.set(cal.get(1), cal.get(2), cal.getActualMinimum(5), cal.getMinimum(11), cal.getMinimum(12), cal.getMinimum(13));
        dia = String.valueOf(cal.getActualMinimum(5));
        if (dia.length() == 1) {
            dia = "0" + dia;
        }
        mes = String.valueOf(cal.get(2) + 1);
        if (mes.length() == 1) {
            mes = "0" + mes;
        }
        fechaInicio = String.valueOf(dia) + "/" + mes + "/" + cal.get(1);
        return fechaInicio;
    }
    
    public String fechaFin() {
        String fechaFin = "";
        String dia = "";
        String mes = "";
        final Calendar cal = Calendar.getInstance();
        cal.set(cal.get(1), cal.get(2), cal.getActualMaximum(5), cal.getMaximum(11), cal.getMaximum(12), cal.getMaximum(13));
        dia = String.valueOf(cal.getActualMaximum(5));
        if (dia.length() == 1) {
            dia = "0" + dia;
        }
        mes = String.valueOf(cal.get(2) + 1);
        if (mes.length() == 1) {
            mes = "0" + mes;
        }
        fechaFin = String.valueOf(dia) + "/" + mes + "/" + cal.get(1);
        return fechaFin;
    }
    
    public String fechaFin2() {
        String fechaFin = "";
        String dia = "";
        String mes = "";
        final Calendar cal = Calendar.getInstance();
        cal.set(cal.get(1), cal.get(2), cal.getActualMaximum(5), cal.getMaximum(11), cal.getMaximum(12), cal.getMaximum(13));
        dia = "20";
        mes = String.valueOf(cal.get(2) + 1);
        if (mes.length() == 1) {
            mes = "0" + mes;
        }
        fechaFin = String.valueOf(dia) + "/" + mes + "/" + cal.get(1);
        return fechaFin;
    }
    
    public String[][] consultaPreviwesCosto(String Proveedor, final String[] Estado, final String Sociedad, final String fechaDesde, final String fechaHasta) {
        final int columna = 6;
        String[][] detalle = null;
        Statement stm = null;
        double sumatoria = 0.0;
        String lsQuery = "";
        String auxEstado = "0";
        try {
            if (Estado.length > 0) {
                for (int i = 0; i < Estado.length; ++i) {
                    if (i == 0) {
                        auxEstado = Estado[i];
                    }
                    else if (i > 0) {
                        auxEstado = String.valueOf(Estado[i]) + "," + auxEstado;
                    }
                }
            }
            if (Proveedor != null) {
                if (Proveedor.equals("todos")) {
                    Proveedor = "null";
                }
                else {
                    Proveedor = "'" + Proveedor + "'";
                }
            }
            else {
                Proveedor = "null";
            }
            lsQuery = "    select a.material, MAX(a.short_text) , a.preq_price , nvl(sum(b.cantidad_despachada),0), nvl(sum(b.cantidad_despachada)*a.preq_price,0) \t     from SAP.SAP_USUARIO_PORTAL c \t     join SAP.SAP_PROVEEDURIA_REPLICA a \t       on ( a.Stcd1=c.id_proveedor and a.bukrs ='" + Sociedad + "' ) " + " left join SAP.SAP_PROVEEDURIA_DETALLE_HIS b " + "        on (b.solicitud = a.prheader  and b.numero_linea = a.preq_item) " + "     where c.usuario = nvl(" + Proveedor + ",c.usuario) " + " \t  and a.rel_ind in (" + auxEstado + ")   " + " \t  and c.sociedad ='" + Sociedad + "'" + " \t  and c.estado = 'A'" + " \t  and a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy')  " + "     Group by a.material, a.preq_price ";
            System.out.println("Query consultaPreviwesCosto: " + lsQuery);
            stm = this.m_conn.createStatement(1004, 1008);
            (this.rs = stm.executeQuery(lsQuery)).last();
            final int fila = this.rs.getRow();
            System.out.println(" ROW : " + fila + " COLUMNA : " + columna);
            this.rs.beforeFirst();
            if (fila == 0) {
                return null;
            }
            detalle = new String[columna][fila];
            int contador = 0;
            while (this.rs.next()) {
                detalle[0][contador] = this.rs.getString(1);
                detalle[1][contador] = this.rs.getString(2);
                detalle[2][contador] = String.format("%.02f", this.rs.getFloat(3)).replace(".", ",");
                detalle[3][contador] = this.rs.getString(4);
                detalle[4][contador] = String.format("%.02f", this.rs.getFloat(5)).replace(".", ",");
                ++contador;
            }
            sumatoria = this.sumatoriaTotal(detalle[4]);
            detalle[5][0] = String.format("%.02f", sumatoria).replace(".", ",");
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            return null;
        }
        finally {
            try {
                this.rs.close();
                stm.close();
            }
            catch (Exception ex) {}
        }
        try {
            this.rs.close();
            stm.close();
        }
        catch (Exception ex2) {}
        return detalle;
    }
    
    public String[][] consultaPreFactura(String Proveedor, final String[] Estado, final String Sociedad, final String fechaDesde, final String fechaHasta) {
        final int columna = 6;
        String[][] detalle = null;
        Statement stm = null;
        double sumatoria = 0.0;
        String sentencia = "";
        String auxEstado = "0";
        try {
            if (Estado.length > 0) {
                for (int i = 0; i < Estado.length; ++i) {
                    if (i == 0) {
                        auxEstado = Estado[i];
                    }
                    else if (i > 0) {
                        auxEstado = String.valueOf(Estado[i]) + "," + auxEstado;
                    }
                }
            }
            if (Proveedor != null) {
                if (Proveedor.equals("todos")) {
                    Proveedor = "null";
                }
                else {
                    Proveedor = "'" + Proveedor + "'";
                }
            }
            else {
                Proveedor = "null";
            }
            sentencia = "    select a.material, MAX(a.short_text) , nvl(a.preq_price,0), nvl(sum(b.cantidad_recibida), 0), nvl(sum(b.cantidad_recibida)*a.preq_price,0) \t     from SAP.SAP_USUARIO_PORTAL c \t     join SAP.SAP_PROVEEDURIA_REPLICA a \t       on ( a.Stcd1=c.id_proveedor and a.bukrs='" + Sociedad + "') " + " left join SAP.SAP_PROVEEDURIA_DETALLE_HIS b " + "        on (b.solicitud = a.prheader  and b.numero_linea = a.preq_item) " + "     where c.usuario = nvl(" + Proveedor + ",c.usuario) " + "       and a.rel_ind in (" + auxEstado + ")  " + " \t  and b.cantidad_recibida is not null  " + "       and c.sociedad ='" + Sociedad + "' " + "       and c.estado ='A' " + "\t\t  and a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy')\t" + "     Group by a.material, a.preq_price ";
            System.out.println("Query consultaPreFactura: " + sentencia);
            stm = this.m_conn.createStatement(1004, 1008);
            (this.rs = stm.executeQuery(sentencia)).last();
            final int fila = this.rs.getRow();
            System.out.println(" ROW : " + fila + " COLUMNA : " + columna);
            this.rs.beforeFirst();
            if (fila == 0) {
                return null;
            }
            detalle = new String[columna][fila];
            int contador = 0;
            while (this.rs.next()) {
                detalle[0][contador] = this.rs.getString(1);
                detalle[1][contador] = this.rs.getString(2);
                detalle[2][contador] = String.format("%.02f", this.rs.getFloat(3)).replace(".", ",");
                detalle[3][contador] = this.rs.getString(4);
                detalle[4][contador] = String.format("%.02f", this.rs.getFloat(5)).replace(".", ",");
                ++contador;
            }
            sumatoria = this.sumatoriaTotal(detalle[4]);
            detalle[5][0] = String.format("%.02f", sumatoria).replace(".", ",");
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            return null;
        }
        finally {
            try {
                stm.close();
                this.rs.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
        try {
            stm.close();
            this.rs.close();
        }
        catch (SQLException e2) {
            e2.printStackTrace();
        }
        return detalle;
    }
    
    public double sumatoriaTotal(final String[] Arreglo) {
        double suma = 0.0;
        double aux = 0.0;
        try {
            for (int i = 0; i < Arreglo.length; ++i) {
                final String dato = Arreglo[i].replace(",", ".");
                aux = Double.parseDouble(dato);
                suma += aux;
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            suma = 0.0;
        }
        return suma;
    }
    
    public RespuestaSap generaPedidoSap(final String contrato) throws Exception, SQLException {
        int salidaEntero = 0;
        String salidaCaracterer = "";
        String cadena = "";
        String cadenaEnviada = "";
        try {
            this.lsQuery = "begin spk_consume_ws.generar_pedido_sap(pn_num_colicitud => ?,                                    pv_cadena => ?,                                    PV_CADENA_ENVIADA => ?,                                     pn_error => ?,                                    pv_error => ?); end;";
            cadena = "contrato=" + contrato + "|";
            System.out.println("cadena: " + cadena);
            (this.cas = this.m_conn.prepareCall(this.lsQuery)).setInt(1, 2);
            this.cas.setString(2, cadena);
            this.cas.registerOutParameter(3, 2005);
            this.cas.registerOutParameter(4, 2);
            this.cas.registerOutParameter(5, 12);
            this.cas.execute();
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.getStackTrace();
            e.printStackTrace();
        }
        cadenaEnviada = this.cas.getString(3);
        salidaEntero = this.cas.getInt(4);
        salidaCaracterer = this.cas.getString(5);
        final RespuestaSap respSap = new RespuestaSap(cadenaEnviada, salidaEntero, salidaCaracterer, contrato);
        return respSap;
    }
    
    public ResultSet detalleGeneraPedido(final String proveedor, final String sociedad, final String fechaDesde, final String fechaHasta) throws Exception {
        ResultSet rscab = null;
        PreparedStatement pst = null;
        try {
            if (proveedor.equals("")) {
                this.lsQuery = "SELECT DISTINCT (T.AGREEMENT), T.STCD1 FROM SAP.SAP_PROVEEDURIA_REPLICA T WHERE T.STCD1 IN (select A.ID_PROVEEDOR from SAP.SAP_USUARIO_PORTAL A where A.ROL='P' AND A.ESTADO='A') AND T.BUKRS = '" + sociedad + "' " + "AND T.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy')";
            }
            else {
                this.lsQuery = "SELECT DISTINCT (T.AGREEMENT), T.STCD1 FROM SAP.SAP_PROVEEDURIA_REPLICA T WHERE T.STCD1 IN (select T.ID_PROVEEDOR from SAP.SAP_USUARIO_PORTAL t where t.usuario = '" + proveedor + "'" + "and t.estado = 'A')" + "AND T.BUKRS = '" + sociedad + "' " + "AND T.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy')";
            }
            System.out.println("Detalle genera pedido: " + this.lsQuery);
            pst = this.m_conn.prepareStatement(this.lsQuery);
            rscab = pst.executeQuery();
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
        }
        return rscab;
    }
    
    public void previewCostoPdf(String stado, final String usuario, final String proveedor, final String mes, final String sociedad, final String NSociedad, final String fechaDesde, final String fechaHasta) throws FileNotFoundException {
        System.out.println(String.valueOf(stado) + "|" + usuario + "|" + proveedor + "|" + mes + "|" + sociedad + "|" + NSociedad + "|" + fechaDesde + "|" + fechaHasta);
        String urlReporte;
        String path = urlReporte = this.m_pageContext.getServletContext().getRealPath("");
        String estado1 = "";
        String estado2 = "";
        String estado3 = "";
        int cont = 0;
        stado = stado.replace("'", "");
        final String[] c = stado.split(",");
        String[] array;
        for (int length = (array = c).length, i = 0; i < length; ++i) {
            final String string = array[i];
            if (!string.equals(null)) {
                c[cont] = string;
                ++cont;
            }
        }
        if (cont == 3) {
            estado1 = c[0];
            estado2 = c[1];
            estado3 = c[2];
        }
        else if (cont == 2) {
            estado1 = c[0];
            estado2 = c[1];
        }
        else if (cont == 1) {
            estado3 = c[0];
        }
        try {
            final String rutajasper = "/paginas/Pdf/previewcosto.jrxml";
            final String[] cantidad = path.split("proveeduria");
            if (cantidad.length == 3) {
                path = String.valueOf(cantidad[0]) + "proveeduria" + cantidad[2];
                System.out.println(rutajasper);
            }
            urlReporte = String.valueOf(path) + "/paginas/Pdf/previewcosto.pdf";
            System.out.println("ruta_completa: " + urlReporte);
            final JasperReport jasperReport = JasperCompileManager.compileReport(String.valueOf(path) + rutajasper);
            System.out.println("-------------1-----------");
            final JasperPrint reporte_view = JasperFillManager.fillReport(jasperReport, (Map)this.obtenerPreviewCostos(estado1, estado2, estado3, usuario, proveedor, mes, sociedad, NSociedad, this.dateYear(), fechaDesde, fechaHasta), this.m_conn);
            System.out.println("-------------2-----------");
            JasperExportManager.exportReportToPdfFile(reporte_view, urlReporte);
            System.out.println("-------------3-----------");
        }
        catch (JRException ex) {
            ex.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)ex.getMessage());
        }
    }
    
    public void PreFacturaPdf(String stado, final String usuario, final String proveedor, final String mes, final String sociedad, final String NSociedad, final String fechaDesde, final String fechaHasta) throws FileNotFoundException {
        System.out.println(String.valueOf(stado) + "|" + usuario + "|" + proveedor + "|" + mes + "|" + sociedad + "|" + NSociedad + "|" + fechaDesde + "|" + fechaHasta);
        String urlReporte;
        String path = urlReporte = this.m_pageContext.getServletContext().getRealPath("");
        String estado1 = "";
        String estado2 = "";
        String estado3 = "";
        int cont = 0;
        stado = stado.replace("'", "");
        final String[] c = stado.split(",");
        String[] array;
        for (int length = (array = c).length, i = 0; i < length; ++i) {
            final String string = array[i];
            if (!string.equals(null)) {
                c[cont] = string;
                ++cont;
            }
        }
        if (cont == 3) {
            estado1 = c[0];
            estado2 = c[1];
            estado3 = c[2];
        }
        else if (cont == 2) {
            estado1 = c[0];
            estado2 = c[1];
        }
        else if (cont == 1) {
            estado3 = c[0];
        }
        try {
            final String rutajasper = "/paginas/Pdf/preFacturaV2.jrxml";
            final String[] cantidad = path.split("proveeduria");
            if (cantidad.length == 3) {
                path = String.valueOf(cantidad[0]) + "proveeduria" + cantidad[2];
            }
            urlReporte = String.valueOf(path) + "/paginas/Pdf/prefactura.pdf";
            System.out.println("ruta_completa: " + urlReporte);
            final JasperReport jasperReport = JasperCompileManager.compileReport(String.valueOf(path) + rutajasper);
            System.out.println("-------------1-----------");
            final JasperPrint reporte_view = JasperFillManager.fillReport(jasperReport, (Map)this.obtenerPreviewCostos(estado1, estado2, estado3, usuario, proveedor, mes, sociedad, NSociedad, this.dateYear(), fechaDesde, fechaHasta), this.m_conn);
            System.out.println("-------------2-----------");
            JasperExportManager.exportReportToPdfFile(reporte_view, urlReporte);
            System.out.println("-------------3-----------");
        }
        catch (JRException ex) {
            ex.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)ex.getMessage());
        }
    }
    
    public void borra_archivo(final String ruta_preview) {
        String urlReporte;
        final String path = urlReporte = this.m_pageContext.getServletContext().getRealPath("");
        urlReporte = String.valueOf(path) + ruta_preview;
        try {
            final File fichero = new File(urlReporte);
            System.out.println("------- ****" + urlReporte);
            if (fichero.delete()) {
                System.out.println("El fichero ha sido borrado satisfactoriamente");
            }
            else {
                System.out.println("El fichero no puede ser borrado");
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
        }
    }
    
    public Map<String, Object> obtenerPreviewCostos(final String estado1, final String estado2, final String estado3, final String usuario, final String proveedor, final String mes, final String sociedad, final String Nsociedad, final int anio, final String fechaDesde, final String fechaHasta) {
        final Map<String, Object> param = new HashMap<String, Object>();
        param.put("ESTADO1", estado1);
        param.put("ESTADO2", estado2);
        param.put("ESTADO3", estado3);
        param.put("USUARIO", usuario);
        param.put("proveedor", proveedor);
        param.put("mes", mes);
        param.put("sociedad", sociedad);
        param.put("Nsociedad", Nsociedad);
        param.put("anio", anio);
        param.put("fechaDesde", fechaDesde);
        param.put("fechaHasta", fechaHasta);
        System.out.println("Fin PArametros");
        return param;
    }
    
    public Map<String, Object> obtenerPreFactura(final String estado1, final String estado2, final String estado3, final String usuario, final String proveedor, final String mes, final String sociedad, final String Nsociedad, final int anio, final String fechaDesde, final String fechaHasta) {
        final Map<String, Object> param = new HashMap<String, Object>();
        param.put("ESTADO1", estado1);
        param.put("ESTADO2", estado2);
        param.put("ESTADO3", estado3);
        param.put("USUARIO", usuario);
        param.put("proveedor", proveedor);
        param.put("mes", mes);
        param.put("sociedad", sociedad);
        param.put("Nsociedad", Nsociedad);
        param.put("anio", anio);
        param.put("fechaDesde", fechaDesde);
        param.put("fechaHasta", fechaHasta);
        System.out.println("Fin PArametros");
        return param;
    }
    
    public List<String[]> usuario_proveedor(final String ruc, final String sociedad) throws Exception {
        ResultSet rsdeta2 = null;
        PreparedStatement pst2 = null;
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select up.usuario from SAP.SAP_USUARIO_PORTAL up where up.id_proveedor = " + ruc + " and up.sociedad = '" + sociedad + "'" + "and up.estado = 'A'";
            System.out.println("Query usuario_proveedor: " + this.lsQuery);
            pst2 = this.m_conn.prepareStatement(this.lsQuery);
            rsdeta2 = pst2.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (rsdeta2.next()) {
                fila = new String[] { rsdeta2.getString(1) };
                resultado.add(fila);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
        }
        System.out.println(rsdeta2.next());
        return resultado;
    }
    
    public String ruc_proveedor(final String usuario, final String sociedad) throws Exception {
        ResultSet rsdeta2 = null;
        PreparedStatement pst2 = null;
        String resultado = null;
        try {
            this.lsQuery = "select up.id_proveedor from SAP.SAP_USUARIO_PORTAL up where up.usuario = '" + usuario + "' and up.sociedad = '" + sociedad + "' and up.estado = 'A'";
            System.out.println("Query ruc_proveedor: " + this.lsQuery);
            pst2 = this.m_conn.prepareStatement(this.lsQuery);
            rsdeta2 = pst2.executeQuery();
            while (rsdeta2.next()) {
                resultado = rsdeta2.getString(1);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
            try {
                rsdeta2.close();
                pst2.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
            return resultado;
        }
        finally {
            try {
                rsdeta2.close();
                pst2.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
        try {
            rsdeta2.close();
            pst2.close();
        }
        catch (SQLException e2) {
            e2.printStackTrace();
        }
        return resultado;
    }
    
    public List<String[]> detalletab_gen_pedido(final String agreement, final String sociedad) throws Exception {
        ResultSet rsdeta2 = null;
        PreparedStatement pst2 = null;
        Connection m_conn2 = null;
        this.lsQuery = "";
        List<String[]> resultado = null;
        try {
            m_conn2 = this.m_conn;
            if (agreement.equals("")) {
                this.lsQuery = " select count(*), sum((p.preq_price * ph.cantidad_recibida))   from SAP.SAP_PROVEEDURIA_REPLICA p, SAP.SAP_PROVEEDURIA_DETALLE_HIS ph  where p.prheader = ph.solicitud    and p.preq_item = ph.numero_linea    and p.rel_ind in ('5','6','7') \t   and p.bukrs = '" + sociedad + "'" + "    and ph.cantidad_recibida is not null";
            }
            else {
                this.lsQuery = "select count(*), sum((p.preq_price * ph.cantidad_recibida))  from SAP.SAP_PROVEEDURIA_REPLICA p, SAP.SAP_PROVEEDURIA_DETALLE_HIS ph   where p.prheader = ph.solicitud     and p.preq_item = ph.numero_linea    and p.agreement = '" + agreement + "' " + "    and p.rel_ind in ('5','6','7')  " + "\t   and p.bukrs = '" + sociedad + "'" + "    and ph.cantidad_recibida is not null ";
            }
            System.out.println(this.lsQuery);
            pst2 = m_conn2.prepareStatement(this.lsQuery);
            rsdeta2 = pst2.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (rsdeta2.next()) {
                fila = new String[] { rsdeta2.getString(1), rsdeta2.getString(2) };
                resultado.add(fila);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
            try {
                rsdeta2.close();
                pst2.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
            return resultado;
        }
        finally {
            try {
                rsdeta2.close();
                pst2.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
        try {
            rsdeta2.close();
            pst2.close();
        }
        catch (SQLException e2) {
            e2.printStackTrace();
        }
        return resultado;
    }
    
    public List<String[]> consultaDetalleAdministrador(final String sociedad, final String proveedor, final String solicitud, final String usuario, final String nombreOficina, final String material, final String fechaDesde, final String fechaHasta, final String EstadoDT, final String EstadoDP, final String EstadoR, final String EstadoNR, final boolean conteo) {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "         \t\tselect d.nombre_proveedor, \t\t\t\t\t   d.id_proveedor,\t\t\t\t\t\t   a.prheader,\t\t  \t\t\t\t   a.preq_item, \t\t\t\t\t   a.name,  \t\t\t\t\t   nvl(b.nombre_oficina,' - '), \t\t\t\t\t   a.short_text,  \t\t\t\t\t   nvl(a.preq_price,0),  \t\t\t\t\t   a.Quantity,  \t\t\t\t\t   nvl(sum(c.cantidad_despachada),0),  \t\t\t\t\t   to_char(nvl(max(c.fecha_despachada), max(a.deliv_date)), 'dd/mm/yyyy'),  \t\t\t\t\t   nvl( nvl(sum(c.cantidad_recibida), nvl(sum(c.cantidad_despachada), 0)) * a.preq_price, 0),  \t\t\t\t\t   decode(a.rel_ind, \t\t\t\t\t\t\t  '2', \t\t\t\t\t\t\t  'No Despachado', \t\t\t\t\t\t\t  '3', \t\t\t\t\t\t\t  'Despachado Parcial', \t\t\t\t\t\t\t  '4', \t\t\t\t\t\t\t  'Despachado Total', \t\t\t\t\t\t\t  '10', \t\t\t\t\t\t\t  'Despachado Denegado', \t\t\t\t\t\t\t  '6', \t\t\t\t\t\t\t  'Recibido Parcial', \t\t\t\t\t\t\t  '7', \t\t\t\t\t\t\t  'Recibido Total', \t\t\t\t\t\t\t  '11', \t\t\t\t\t\t\t  'No Recibido', \t\t\t\t\t\t\t  a.rel_ind),\t\t\t\t\t   a.rel_ind,\t\t\t\t\t   nvl(sum(c.cantidad_recibida), nvl(sum(c.cantidad_despachada), 0)) ,\t\t\t\t\t   to_char(nvl(max(c.fecha_recibido), max(a.deliv_date)), 'dd/mm/yyyy'),\t\t\t\t\t   a.agreement, c.observacion                 from SAP.SAP_PROVEEDURIA_REPLICA a            left join SAP.SAP_USUARIOS b                   on (b.codigo_usuario = a.created_by                        and b.sociedad = a.bukrs)            left join SAP.SAP_PROVEEDURIA_DETALLE_HIS c \t\t\t\t\ton (c.solicitud = a.prheader  and c.numero_linea = a.preq_item )           left join SAP.SAP_USUARIO_PORTAL d                  on (a.stcd1 = d.id_proveedor and d.sociedad = nvl('" + sociedad + "',a.bukrs) ) " + "               where a.bukrs = nvl('" + sociedad + "',a.bukrs) " + "   \t\t\t   and d.usuario = nvl('" + proveedor + "',d.usuario) " + "\t\t\t\t   and a.prheader = nvl('" + solicitud + "',a.prheader) " + "\t\t\t\t   and a.name like nvl(upper('%" + usuario + "%'),a.name) " + "\t\t\t\t   and nvl(b.nombre_oficina,'-') like nvl(upper('%" + nombreOficina + "%'),nvl(b.nombre_oficina,'-')) " + "\t\t\t\t   and a.short_text like nvl(upper('%" + material + "%'),a.short_text) " + "\t\t\t\t   and d.estado = 'A' " + "            Group by d.nombre_proveedor, " + "\t\t\t\t\t   d.id_proveedor, " + "\t\t\t\t\t   a.prheader, " + "\t \t\t\t\t   a.preq_item," + "\t\t\t\t\t   a.name, " + "\t\t\t\t\t   b.nombre_oficina, " + "\t\t\t\t\t   a.short_text, " + "\t\t\t\t\t   a.preq_price, " + "\t\t\t\t\t   a.Quantity," + "\t\t\t\t\t   a.deliv_date, " + "\t\t\t\t\t   a.rel_ind," + "\t\t\t\t\t   a.agreement,c.observacion " + "              having a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy') " + "and a.rel_ind in('" + EstadoDT + "', '" + EstadoDP + "', '" + EstadoNR + "', " + ((EstadoR == null) ? "0" : EstadoR) + ",'11','6') " + "            Order by d.nombre_proveedor ,prheader, preq_item desc ";
            System.out.println("Query consultaDetalleAdministrador: " + this.lsQuery);
            final Date date1 = new Date();
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            final Date date2 = new Date();
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4), this.rs.getString(5), this.rs.getString(6), this.rs.getString(7), String.format("%.02f", this.rs.getFloat(8)).replace(".", ","), this.rs.getString(9), this.rs.getString(10), this.rs.getString(11), String.format("%.02f", this.rs.getFloat(12)).replace(".", ","), this.rs.getString(13), this.rs.getString(14), this.rs.getString(15), this.rs.getString(16), this.rs.getString(18) };
                resultado.add(fila);
            }
            final Date date3 = new Date();
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
    
    public ResultSet consultaDetalleAdministrador_old(final String sociedad, final String proveedor, final String solicitud, final String usuario, final String nombreOficina, final String material, final String fechaDesde, final String fechaHasta, final String EstadoDT, final String EstadoDP, final String EstadoR, final String EstadoNR, final boolean conteo) {
        try {
            this.lsQuery = "         \t\tselect d.nombre_proveedor, \t\t\t\t\t   d.id_proveedor,\t\t\t\t\t\t   a.prheader,\t\t  \t\t\t\t   a.preq_item, \t\t\t\t\t   a.name,  \t\t\t\t\t   nvl(b.nombre_oficina,' - '), \t\t\t\t\t   a.short_text,  \t\t\t\t\t   nvl(a.preq_price,0),  \t\t\t\t\t   a.Quantity,  \t\t\t\t\t   nvl(sum(c.cantidad_despachada),0),  \t\t\t\t\t   to_char(nvl(max(c.fecha_despachada), max(a.deliv_date)), 'dd/mm/yyyy'),  \t\t\t\t\t   nvl( nvl(sum(c.cantidad_recibida), nvl(sum(c.cantidad_despachada), 0)) * a.preq_price, 0),  \t\t\t\t\t   decode(a.rel_ind, \t\t\t\t\t\t\t  '2', \t\t\t\t\t\t\t  'No Despachado', \t\t\t\t\t\t\t  '3', \t\t\t\t\t\t\t  'Despachado Parcial', \t\t\t\t\t\t\t  '4', \t\t\t\t\t\t\t  'Despachado Total', \t\t\t\t\t\t\t  '10', \t\t\t\t\t\t\t  'Despachado Denegado', \t\t\t\t\t\t\t  '6', \t\t\t\t\t\t\t  'Recibido Parcial', \t\t\t\t\t\t\t  '7', \t\t\t\t\t\t\t  'Recibido Total', \t\t\t\t\t\t\t  '11', \t\t\t\t\t\t\t  'No Recibido', \t\t\t\t\t\t\t  a.rel_ind),\t\t\t\t\t   a.rel_ind,\t\t\t\t\t   nvl(sum(c.cantidad_recibida), nvl(sum(c.cantidad_despachada), 0)) ,\t\t\t\t\t   to_char(nvl(max(c.fecha_recibido), max(a.deliv_date)), 'dd/mm/yyyy'),\t\t\t\t\t   a.agreement                 from SAP.SAP_PROVEEDURIA_REPLICA a            left join SAP.SAP_USUARIOS b                   on (b.codigo_usuario = a.created_by                        and b.sociedad = a.bukrs)            left join SAP.SAP_PROVEEDURIA_DETALLE_HIS c \t\t\t\t\ton (c.solicitud = a.prheader  and c.numero_linea = a.preq_item )           left join SAP.SAP_USUARIO_PORTAL d                  on (a.stcd1 = d.id_proveedor)                where a.bukrs = nvl('" + sociedad + "',a.bukrs) " + "   \t\t\t   and d.usuario = nvl('" + proveedor + "',d.usuario) " + "\t\t\t\t   and a.prheader = nvl('" + solicitud + "',a.prheader) " + "\t\t\t\t   and a.created_by = nvl('" + usuario + "',a.created_by) " + "\t\t\t\t   and nvl(b.nombre_oficina,'-') = nvl('" + nombreOficina + "',nvl(b.nombre_oficina,'-')) " + "\t\t\t\t   and a.short_text = nvl('" + material + "',a.short_text) " + "\t\t\t\t   and d.estado = 'A'" + "            Group by d.nombre_proveedor, " + "\t\t\t\t\t   d.id_proveedor, " + "\t\t\t\t\t   a.prheader, " + "\t \t\t\t\t   a.preq_item," + "\t\t\t\t\t   a.name, " + "\t\t\t\t\t   b.nombre_oficina, " + "\t\t\t\t\t   a.short_text, " + "\t\t\t\t\t   a.preq_price, " + "\t\t\t\t\t   a.Quantity," + "\t\t\t\t\t   a.deliv_date, " + "\t\t\t\t\t   a.rel_ind," + "\t\t\t\t\t   a.agreement " + "              having a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy') " + "and a.rel_ind in('" + EstadoDT + "', '" + EstadoDP + "', '" + EstadoNR + "', " + ((EstadoR == null) ? "0" : EstadoR) + ",'11','6') " + "            Order by d.nombre_proveedor ,prheader, preq_item desc ";
            System.out.println("Query Bandeja Administrador:" + this.lsQuery);
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            if (conteo) {
                this.pst = this.m_conn.prepareStatement(this.lsQuery, 1004, 1008);
            }
            else {
                this.pst = this.m_conn.prepareStatement(this.lsQuery);
            }
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            this.rs = null;
        }
        return this.rs;
    }
    
    public ResultSet consultaDetalleGenerarPedido(final String sociedad, final String proveedor, final String solicitud, final String usuario, final String nombreOficina, final String material, final String fechaDesde, final String fechaHasta, final String EstadoDT, final String EstadoDP, final String EstadoR, final String EstadoNR, final boolean conteo) {
        try {
            this.lsQuery = "         \t\tselect d.nombre_proveedor, \t\t\t\t\t   d.id_proveedor,\t\t\t\t\t\t   a.prheader,\t\t  \t\t\t\t   a.preq_item, \t\t\t\t\t   a.name,  \t\t\t\t\t   nvl(b.nombre_oficina,' - '), \t\t\t\t\t   a.short_text,  \t\t\t\t\t   nvl(a.preq_price,0),  \t\t\t\t\t   a.Quantity,  \t\t\t\t\t   nvl(sum(c.cantidad_despachada),0),  \t\t\t\t\t   to_char(nvl(max(c.fecha_despachada), max(a.deliv_date)), 'dd/mm/yyyy'),  \t\t\t\t\t   nvl( nvl(sum(c.cantidad_recibida), nvl(sum(c.cantidad_despachada), 0)) * a.preq_price, 0),  \t\t\t\t\t   decode(a.rel_ind, \t\t\t\t\t\t\t  '2', \t\t\t\t\t\t\t  'No Despachado', \t\t\t\t\t\t\t  '3', \t\t\t\t\t\t\t  'Despachado Parcial', \t\t\t\t\t\t\t  '4', \t\t\t\t\t\t\t  'Despachado Total', \t\t\t\t\t\t\t  '10', \t\t\t\t\t\t\t  'Despachado Denegado', \t\t\t\t\t\t\t  '6', \t\t\t\t\t\t\t  'Recibido Parcial', \t\t\t\t\t\t\t  '7', \t\t\t\t\t\t\t  'Recibido Total', \t\t\t\t\t\t\t  '11', \t\t\t\t\t\t\t  'No Recibido', \t\t\t\t\t\t\t  a.rel_ind),\t\t\t\t\t   a.rel_ind,\t\t\t\t\t   nvl(sum(c.cantidad_recibida), nvl(sum(c.cantidad_despachada), 0)) ,\t\t\t\t\t   to_char(nvl(max(c.fecha_recibido), max(a.deliv_date)), 'dd/mm/yyyy'),\t\t\t\t\t   a.agreement                 from SAP.SAP_PROVEEDURIA_REPLICA a            left join SAP.SAP_USUARIOS b                   on (b.codigo_usuario = a.created_by                        and b.sociedad = a.bukrs)            left join SAP.SAP_PROVEEDURIA_DETALLE_HIS c \t\t\t\t\ton (c.solicitud = a.prheader  and c.numero_linea = a.preq_item )           left join SAP.SAP_USUARIO_PORTAL d                  on (a.stcd1 = d.id_proveedor)                where a.bukrs = nvl(?,a.bukrs)    \t\t\t   and d.usuario = nvl(?,d.usuario) \t\t\t\t   and a.prheader = nvl(?,a.prheader) \t\t\t\t   and a.created_by = nvl(?,a.created_by) \t\t\t\t   and nvl(b.nombre_oficina,'-') = nvl(?,nvl(b.nombre_oficina,'-')) \t\t\t\t   and a.short_text = nvl(?,a.short_text) \t\t\t\t   and d.estado = 'A'             Group by d.nombre_proveedor, \t\t\t\t\t   d.id_proveedor, \t\t\t\t\t   a.prheader, \t \t\t\t\t   a.preq_item,\t\t\t\t\t   a.name, \t\t\t\t\t   b.nombre_oficina, \t\t\t\t\t   a.short_text, \t\t\t\t\t   a.preq_price, \t\t\t\t\t   a.Quantity,\t\t\t\t\t   a.deliv_date, \t\t\t\t\t   a.rel_ind,\t\t\t\t\t   a.agreement               having a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy') " + "\t\t\t\t and a.rel_ind in('7','6') " + "            Order by d.nombre_proveedor ,prheader, preq_item desc ";
            System.out.println(this.lsQuery);
            System.out.println("Consulta");
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            if (conteo) {
                this.pst = this.m_conn.prepareStatement(this.lsQuery, 1004, 1008);
            }
            else {
                this.pst = this.m_conn.prepareStatement(this.lsQuery);
            }
            this.pst.setString(1, (sociedad == "") ? null : sociedad);
            this.pst.setString(2, (proveedor == "") ? null : proveedor);
            this.pst.setString(3, (solicitud == "") ? null : solicitud);
            this.pst.setString(4, (usuario == "") ? null : usuario);
            this.pst.setString(5, (nombreOficina == "") ? null : nombreOficina);
            this.pst.setString(6, (material == "") ? null : material);
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
        }
        return this.rs;
    }
    
    public String[][] genererPedido(final String sociedad, final String proveedor, final String solicitud, final String usuario, final String nombreOficina, final String material, final String fechaDesde, final String fechaHasta, final String EstadoDT, final String EstadoDP, final String EstadoR, final String EstadoNR) {
        ResultSet consulta = null;
        String[][] resultado = null;
        final int columna = 5;
        try {
            consulta = this.consultaDetalleGenerarPedido(sociedad, proveedor, solicitud, usuario, nombreOficina, material, fechaDesde, fechaHasta, "", "", EstadoR, "", true);
            consulta.last();
            final int fila = consulta.getRow();
            System.out.println(" ROW : " + fila + " COLUMNA : " + columna);
            consulta.beforeFirst();
            resultado = new String[columna][fila];
            boolean nuevaSolicitud = false;
            int i = 0;
            while (consulta.next()) {
                final String solicituds = consulta.getString(3);
                System.out.println("SOLICITUDS:" + solicituds);
                if (i == 0) {
                    resultado[3][i] = solicituds;
                    ++i;
                }
                else {
                    for (int j = 0; j < resultado[3].length && resultado[3][j] != null; ++j) {
                        nuevaSolicitud = !solicituds.equals(resultado[3][j]);
                    }
                    if (!nuevaSolicitud) {
                        continue;
                    }
                    nuevaSolicitud = false;
                    resultado[3][i] = solicituds;
                    ++i;
                }
            }
            for (int k = 0; k < resultado[3].length; ++k) {
                System.out.println("resultado : " + resultado[3][k]);
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            try {
                consulta.close();
                this.pst.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
            return resultado;
        }
        finally {
            try {
                consulta.close();
                this.pst.close();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
        try {
            consulta.close();
            this.pst.close();
        }
        catch (SQLException e2) {
            e2.printStackTrace();
        }
        return resultado;
    }
    
    public HashMap<String, String> ObtieneAreas_old() {
        final HashMap<String, String> listArea = new HashMap<String, String>();
        try {
            this.lsQuery = "select a.ID_AREA, \t\t\t\t\t\ta.DESCRIPCION \t\t  from SAP.SAP_AREA a\t\t where a.ESTADO = 'A' ";
            System.out.println("Query ObtieneAreas: " + this.lsQuery);
            if (this.pst != null) {
                this.pst.close();
            }
            if (this.rs != null) {
                this.rs.close();
            }
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            while (this.rs.next()) {
                listArea.put(this.rs.getString(1), this.rs.getString(2));
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
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
        return listArea;
    }
    
    public List<String[]> ObtieneAreas() {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select a.ID_AREA, \t\t\t\t\t\ta.DESCRIPCION \t\t  from SAP.SAP_AREA a\t\t where a.ESTADO = 'A' ";
            System.out.println("Query ObtieneAreas: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2) };
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
    
    public List<String[]> consultarUsuariosNuevosv2(final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select a.created_by, \t\t\t\t\t\ta.name,\t\t\t\t \t\t\t\ta.costcenter,\t\t\t\t\t\ta.bukrs\t\t\t\t\t\t  from SAP.SAP_PROVEEDURIA_REPLICA a\t\t\t  left join SAP.SAP_USUARIOS b\t\t    on ( b.codigo_usuario = a.created_by)\t where b.codigo_usuario is null\t and a.bukrs = '" + sociedad + "'      " + " Group by\ta.created_by,\t\t\t" + "\t\t\ta.name,\t\t\t\t\t" + "\t\t\ta.costcenter,\t\t\t" + "\t\t\ta.bukrs\t\t\t\t\t";
            System.out.println("Query consultarUsuariosNuevos: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4) };
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
    
    public List<String[]> consultarUsuarioUbicacionv2(final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select * from  SAP.SAP_USUARIOS su where su.sociedad = '" + sociedad + "'";
            System.out.println("Query UsuarioUbicacion: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4), this.rs.getString(5), this.rs.getString(6), this.rs.getString(7), this.rs.getString(8), this.rs.getString(9), this.rs.getString(10), this.rs.getString(11) };
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
    
    public List<String[]> adminPortal(final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select up.usuario, up.clave, DECODE(up.rol, 'P', 'PROVEEDOR',     'A', 'ADMINISTRADOR',     'S', 'SUPERVISOR',     'G', 'GERENTE',     'J', 'JEFATURA') rol,up.sociedad,up.email as correo,DECODE(up.estado, 'A', 'ACTIVO','I', 'INACTIVO') estado, up.id_proveedor from SAP.SAP_USUARIO_PORTAL up where up.sociedad = '" + sociedad + "'" + "and up.estado = 'A' ";
            System.out.println("Query adminPortal: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4), this.rs.getString(5), this.rs.getString(6), this.rs.getString(7), null, null, null, null };
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
    
    public String actualizarUsuarioUbicacion(String cadena) {
        System.out.println("Metodo actualizarUsuarioUbicacion");
        try {
            int liLongitud = cadena.length();
            String codigoUsuario = "";
            String usuario = "";
            String oficina = "";
            String piso = "";
            String direccion = "";
            String region = "";
            String ceco = "";
            String area = "";
            String estado = "";
            String sociedad = "";
            String guia = "";
            while (liLongitud > 1) {
                if (cadena == null) {
                    break;
                }
                codigoUsuario = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("codigoUsuario " + codigoUsuario + " - ");
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                usuario = cadena.substring(0, cadena.indexOf("|"));
                usuario = usuario.replaceAll("~", " ");
                System.out.println("usuario " + usuario + " - ");
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                oficina = cadena.substring(0, cadena.indexOf("|"));
                oficina = oficina.replaceAll("~", " ");
                System.out.println("oficina " + oficina);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                piso = cadena.substring(0, cadena.indexOf("|"));
                piso = piso.replaceAll("~", " ");
                System.out.println("piso " + piso);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                direccion = cadena.substring(0, cadena.indexOf("|"));
                direccion = direccion.replaceAll("~", " ");
                System.out.println("direccion " + direccion);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                region = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("region " + region);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                ceco = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("ceco " + ceco);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                area = cadena.substring(0, cadena.indexOf("|"));
                area = area.replaceAll("~", " ");
                System.out.println("area " + area);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                estado = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("estado " + estado);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                sociedad = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("sociedad " + sociedad);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                guia = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("guia " + guia);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                liLongitud = cadena.length();
                System.out.println("longitud " + liLongitud);
                this.mergeUsuarioUbicacion(codigoUsuario, usuario, oficina, piso, direccion, region, ceco, area, estado, sociedad, guia);
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            return "ERROR AL ACTUALIZAR MANTENEDOR USUARIO UBICACION";
        }
        return "USUARIO ACTUALIZADO CORRECTAMENTE.";
    }
    
    public void recibirV2(final String sociedad, final String proveedor, final String solicitud, final String usuario, final String nombreOficina, final String material, final String fechaDesde, final String fechaHasta, final String EstadoDT, final String EstadoDP, final String EstadoR, final String EstadoNR, final boolean conteo, final ArrayList<String> listadoD) {
        int insert = 0;
        int update = 0;
        String omitir = "";
        String addQuery = "";
        int idx = 0;
        for (final String lis : listadoD) {
            ++idx;
            System.out.println("cadena: " + lis);
            final String[] detalle = lis.split("\\|");
            System.out.println("Indice::" + idx);
            String proveedorD = "";
            String solicitudD = "";
            String numeroLineaD = "";
            String usuarioD = "";
            String descArticuloD = "";
            String cantidadSoliD = "";
            String fechaDespachadoD = "";
            String fechaRecepcionD = "";
            String cantidadRecibidaD = "";
            String estadoD = "";
            String observacionD = "";
            int estadoActualizadoD = 0;
            proveedorD = detalle[0];
            solicitudD = detalle[1];
            numeroLineaD = detalle[2];
            usuarioD = detalle[3];
            descArticuloD = detalle[4];
            cantidadSoliD = detalle[5];
            fechaDespachadoD = detalle[6];
            fechaRecepcionD = detalle[8];
            cantidadRecibidaD = detalle[9];
            estadoD = detalle[10];
            try {
                observacionD = detalle[11];
                estadoD = "10";
            }
            catch (Exception e) {
                this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
                observacionD = "";
            }
            observacionD = observacionD.replaceAll("~", " ");
            if (estadoD.equals("") | estadoD == null) {
                estadoD = "0";
            }
            estadoActualizadoD = Integer.parseInt(estadoD);
            if (estadoActualizadoD == 2) {
                estadoActualizadoD = 5;
            }
            else if (estadoActualizadoD == 3) {
                estadoActualizadoD = 6;
            }
            else if (estadoActualizadoD == 4) {
                estadoActualizadoD = 7;
            }
            if (idx == 1) {
                omitir = "('" + solicitudD + "','" + numeroLineaD + "')";
            }
            else {
                omitir = String.valueOf(omitir) + ",('" + solicitudD + "','" + numeroLineaD + "')";
            }
            addQuery = "   and (a.prheader,a.preq_item)  not in (" + omitir + ") ";
            System.out.println("addQuery:" + addQuery);
        }
        System.out.println("ENTRA EN recibirV2");
        try {
            this.lsQuery = "insert into SAP.SAP_PROVEEDURIA_DETALLE_HIS select a.prheader as solicitud,       a.preq_item as numero_linea,       a.name as usuario,       d.id_proveedor as proveedor,null,       a.short_text as descripcion,       a.Quantity as cantidad_origen,       '0' as cantidad_despachada,       sysdate as fecha_ingresado,       to_date(nvl(max(c.fecha_despachada), max(a.deliv_date)),'dd/mm/yyyy') as fecha_despachada,null,       decode(a.rel_ind,'2','11','3','6','4','7',a.rel_ind) as estado,       nvl(sum(c.cantidad_recibida), nvl(sum(c.cantidad_despachada), 0)) as cantidad_recibida,       to_date(nvl(max(c.fecha_recibido), max(a.deliv_date)), 'dd/mm/yyyy') as fecha_recibido,null,null,       c.observacion                from SAP.SAP_PROVEEDURIA_REPLICA a            left join SAP.SAP_USUARIOS b                   on (b.codigo_usuario = a.created_by                        and b.sociedad = a.bukrs)            left join SAP.SAP_PROVEEDURIA_DETALLE_HIS c \t\t\t\t\ton (c.solicitud = a.prheader  and c.numero_linea = a.preq_item )           left join SAP.SAP_USUARIO_PORTAL d                  on (a.stcd1 = d.id_proveedor and d.sociedad = nvl('" + sociedad + "',a.bukrs) ) " + "               where a.bukrs = nvl('" + sociedad + "',a.bukrs) " + "   \t\t\t   and d.usuario = nvl('" + proveedor + "',d.usuario) " + "\t\t\t\t   and a.prheader = nvl('" + solicitud + "',a.prheader) " + "\t\t\t\t   and a.name like nvl(upper('%" + usuario + "%'),a.name) " + "\t\t\t\t   and nvl(b.nombre_oficina,'-') like nvl(upper('%" + nombreOficina + "%'),nvl(b.nombre_oficina,'-')) " + "\t\t\t\t   and a.short_text like nvl(upper('%" + material + "%'),a.short_text) " + "\t\t\t\t" + addQuery + " \t\t\t " + "            Group by  " + "\t\t\t\t\t   d.id_proveedor, " + "\t\t\t\t\t   a.prheader, " + "\t \t\t\t\t   a.preq_item," + "\t\t\t\t\t   a.name, " + "\t\t\t\t\t   b.nombre_oficina, " + "\t\t\t\t\t   a.short_text, " + "\t\t\t\t\t   a.preq_price, " + "\t\t\t\t\t   a.Quantity," + "\t\t\t\t\t   a.deliv_date, " + "\t\t\t\t\t   a.rel_ind," + "\t\t\t\t\t   c.observacion " + "              having a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy') " + "and a.rel_ind in('" + EstadoDT + "', '" + EstadoDP + "', '" + EstadoNR + "' ) " + "            Order by prheader, preq_item desc ";
            System.out.println("Query insert: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            insert = this.pst.executeUpdate();
            System.out.println("ejecuta insert " + insert);
            this.m_conn.commit();
            String ruc_Prov = this.ruc_proveedor(proveedor, sociedad);
            if (ruc_Prov == null) {
                ruc_Prov = "";
            }
            this.lsQuery = "update SAP.SAP_PROVEEDURIA_REPLICA a set a.rel_ind = DECODE(rel_ind,'2','11','3','6','4','7',a.rel_ind)                 where a.bukrs = nvl('" + sociedad + "',a.bukrs) " + "   \t\t\t and a.stcd1 = nvl('" + ruc_Prov + "',a.stcd1) " + "\t\t\t\t and a.prheader = nvl('" + solicitud + "',a.prheader) " + "\t\t\t\t and a.name like nvl(upper('%" + usuario + "%'),a.name) " + "\t\t\t\t and nvl(a.mctxt,'-') like nvl(upper('%" + nombreOficina + "%'),nvl(a.mctxt,'-')) " + "\t\t\t\t and a.short_text like nvl(upper('%" + material + "%'),a.short_text) " + "\t\t \t and a.deliv_date between to_date('" + fechaDesde + "','dd/mm/yyyy') and to_date('" + fechaHasta + "','dd/mm/yyyy') " + "\t\t\t and a.rel_ind in('" + EstadoDT + "', '" + EstadoDP + "', '" + EstadoNR + "' )" + "\t\t\t" + addQuery + "\t ";
            System.out.println("Query update: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            update = this.pst.executeUpdate();
            System.out.println("ejecuta update " + update);
            this.m_conn.commit();
        }
        catch (Exception e2) {
            this.m_session.setAttribute("requestedPage", (Object)e2.getMessage());
            System.out.println("Error al update");
            try {
                this.m_conn.rollback();
            }
            catch (SQLException e3) {
                e3.printStackTrace();
            }
            e2.printStackTrace();
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
    }
    
    public String recibirSolicitud(final ArrayList<String> listado, final String sociedad) {
        System.out.println("ENTRA EN recibirSolicitud");
        try {
            int idx = 0;
            for (final String lis : listado) {
                ++idx;
                final String[] detalle = lis.split("\\|");
                System.out.println("Indice::" + idx);
                String proveedor = "";
                String solicitud = "";
                String numeroLinea = "";
                String usuario = "";
                String descArticulo = "";
                String cantidadSoli = "";
                String fechaDespachado = "";
                String fechaRecepcion = "";
                String cantidadRecibida = "";
                String estado = "";
                String observacion = "";
                int estadoActualizado = 0;
                proveedor = detalle[0];
                solicitud = detalle[1];
                numeroLinea = detalle[2];
                usuario = detalle[3];
                descArticulo = detalle[4];
                cantidadSoli = detalle[5];
                fechaDespachado = detalle[6];
                fechaRecepcion = detalle[8];
                cantidadRecibida = detalle[9];
                estado = detalle[10];
                try {
                    observacion = detalle[11];
                    estado = "10";
                }
                catch (Exception e) {
                    this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
                    observacion = "";
                }
                observacion = observacion.replaceAll("~", " ");
                if (estado.equals("") | estado == null) {
                    estado = "0";
                }
                estadoActualizado = Integer.parseInt(estado);
                if (estadoActualizado == 2) {
                    estadoActualizado = 5;
                }
                else if (estadoActualizado == 3) {
                    estadoActualizado = 6;
                }
                else if (estadoActualizado == 4) {
                    estadoActualizado = 7;
                }
                try {
                    this.lsQuery = "update SAP.SAP_PROVEEDURIA_DETALLE_HIS a \tset a.cantidad_recibida='" + cantidadRecibida + "', " + " \ta.fecha_recibido=to_date('" + fechaRecepcion + "','dd/MM/yyyy'), " + "   a.estado='" + estadoActualizado + "'," + "   a.observacion='" + observacion + "' " + "where a.proveedor='" + proveedor + "' " + "\tand a.solicitud='" + solicitud + "' " + "\tand a.numero_linea='" + numeroLinea + "' ";
                    System.out.println("Query update SAP_PROVEEDURIA_DETALLE_HIS: " + this.lsQuery);
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    final int i = this.pst.executeUpdate();
                    System.out.println("ejecuta insert " + i);
                }
                catch (Exception e) {
                    this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
                    System.out.println("Error al insert");
                    this.m_conn.rollback();
                    e.printStackTrace();
                }
                try {
                    if (this.pst != null) {
                        this.pst.close();
                    }
                    if (this.rs != null) {
                        this.rs.close();
                    }
                    this.lsQuery = "update SAP.SAP_PROVEEDURIA_REPLICA a set a.rel_ind = '" + estadoActualizado + "' " + "               where a.bukrs = '" + sociedad + "' " + "   \t\t\t and a.stcd1 = '" + proveedor + "' " + "\t\t\t\t and a.prheader = '" + solicitud + "' " + "\t\t\t\t and a.preq_item = '" + numeroLinea + "' ";
                    System.out.println("Query update SAP_PROVEEDURIA_REPLICA: " + this.lsQuery);
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    final int i = this.pst.executeUpdate();
                    System.out.println("ejecuta update " + i);
                }
                catch (Exception e) {
                    this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
                    System.out.println("Error al update");
                    this.m_conn.rollback();
                    e.printStackTrace();
                }
            }
            this.m_conn.commit();
        }
        catch (Exception e3) {
            try {
                this.m_conn.rollback();
            }
            catch (SQLException e2) {
                e2.printStackTrace();
            }
            e3.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e3.getMessage());
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
        return "Se Actualizo con exito";
    }
    
    public String recibirSolicitud(String cadena) {
        int liLongitud = cadena.length();
        String proveedor = "";
        String solicitud = "";
        String numeroLinea = "";
        String usuario = "";
        String descArticulo = "";
        String cantidadSoli = "";
        String fechaDespachado = "";
        String cantidadDesp = "";
        String fechaRecepcion = "";
        String cantidadRecibida = "";
        String estado = "";
        int estadoActualizado = 0;
        System.out.println(cadena);
        try {
            while (liLongitud > 1) {
                if (cadena == null) {
                    break;
                }
                proveedor = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("proveedor " + proveedor + " - ");
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                solicitud = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("solicitud " + solicitud);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                numeroLinea = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("numeroLinea " + numeroLinea);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                usuario = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("usuario " + usuario);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                descArticulo = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("descArticulo " + descArticulo);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                cantidadSoli = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("cantidadSoli" + cantidadSoli);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                fechaDespachado = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("fechaDespachado " + fechaDespachado);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                cantidadDesp = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("cantidadDesp " + cantidadDesp);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                fechaRecepcion = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("fechaRecepcion " + fechaRecepcion);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                cantidadRecibida = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("cantidadRecibida " + cantidadRecibida);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                estado = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("estado " + estado);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                liLongitud = cadena.length();
                System.out.println("longitud " + liLongitud);
                if (estado.equals("") | estado == null) {
                    estado = "0";
                }
                estadoActualizado = Integer.parseInt(estado);
                if (estadoActualizado == 2) {
                    estadoActualizado = 5;
                }
                else if (estadoActualizado == 3) {
                    estadoActualizado = 6;
                }
                else if (estadoActualizado == 4) {
                    estadoActualizado = 7;
                }
                try {
                    this.lsQuery = "insert into SAP.SAP_PROVEEDURIA_DETALLE_HIS (solicitud, numero_linea, usuario, proveedor, descripcion, cantidad_origen, cantidad_despachada, fecha_ingresado, fecha_despachada, estado, cantidad_recibida,fecha_recibido) values (:1,:2,:3,:4,:5,:6,:7,sysdate,:8,:9,:10,:11)";
                    if (this.pst != null) {
                        this.pst.close();
                    }
                    if (this.rs != null) {
                        this.rs.close();
                    }
                    (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, solicitud);
                    this.pst.setInt(2, Integer.parseInt(numeroLinea));
                    this.pst.setString(3, usuario);
                    this.pst.setString(4, proveedor);
                    this.pst.setString(5, descArticulo);
                    this.pst.setInt(6, Integer.parseInt(cantidadSoli));
                    this.pst.setInt(7, 0);
                    Date fecha = new Date();
                    final SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
                    java.sql.Date fecha_despacho = null;
                    try {
                        fecha = formatter.parse(fechaDespachado);
                        fecha_despacho = new java.sql.Date(fecha.getTime());
                        System.out.println(fecha_despacho.toString());
                    }
                    catch (Exception e2) {
                        fecha_despacho = null;
                    }
                    this.pst.setDate(8, fecha_despacho);
                    this.pst.setInt(9, estadoActualizado);
                    this.pst.setInt(10, Integer.parseInt(cantidadRecibida));
                    java.sql.Date fecha_recepcion = null;
                    try {
                        fecha = formatter.parse(fechaRecepcion);
                        fecha_recepcion = new java.sql.Date(fecha.getTime());
                        System.out.println(fecha_recepcion.toString());
                    }
                    catch (Exception e3) {
                        fecha_recepcion = null;
                    }
                    this.pst.setDate(11, fecha_recepcion);
                    final int i = this.pst.executeUpdate();
                    System.out.println("ejecuta insert " + i);
                    this.m_conn.commit();
                }
                catch (Exception e) {
                    System.out.println("Error al insert");
                    this.m_conn.rollback();
                    e.printStackTrace();
                }
                try {
                    if (this.pst != null) {
                        this.pst.close();
                    }
                    if (this.rs != null) {
                        this.rs.close();
                    }
                    this.lsQuery = "update SAP.SAP_PROVEEDURIA_REPLICA    set rel_ind = ?  where prheader = ?    and preq_item = ? ";
                    (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setInt(1, estadoActualizado);
                    this.pst.setString(2, solicitud);
                    this.pst.setInt(3, Integer.parseInt(numeroLinea));
                    final int j = this.pst.executeUpdate();
                    System.out.println("ejecuta update " + j);
                    this.m_conn.commit();
                }
                catch (Exception e) {
                    this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
                    System.out.println("Error al update");
                    this.m_conn.rollback();
                    e.printStackTrace();
                }
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
        }
        return "Se Actualizo con exito";
    }
    
    public void mergeUsuarioUbicacion(final String codigoUsuario, final String usuario, final String oficina, final String piso, final String direccion, final String region, final String ceco, final String area, String estado, final String sociedad, String guia) {
        try {
            if (guia == null | "".equals(guia)) {
                guia = "N";
            }
            if (estado == null | estado.equals("")) {
                estado = "A";
            }
            this.lsQuery = "   MERGE INTO SAP.SAP_USUARIOS a    USING dual b       ON ( a.codigo_usuario = '" + codigoUsuario + "') " + "    WHEN MATCHED THEN " + "  UPDATE set " + "    a.usuario= '" + usuario + "' , " + "    a.nombre_oficina = '" + oficina + "', " + "    a.piso = '" + piso + "', " + "    a.direccion = '" + direccion + "', " + "    a.region = '" + region + "', " + "    a.area_empresa = '" + area + "', " + "    a.estatus = '" + estado + "', " + "    a.sociedad = '" + sociedad + "', " + "    a.guia_remision = '" + guia + "' " + "  WHEN NOT MATCHED THEN " + "    insert " + "      (a.codigo_usuario,a.usuario, a.nombre_oficina, a.piso, a.direccion, a.region, a.ceco, a.area_empresa," + " \t  a.estatus, a.sociedad, a.guia_remision) " + "    values " + "      ('" + codigoUsuario + "','" + usuario + "', '" + oficina + "', '" + piso + "', '" + direccion + "', '" + region + "', '" + ceco + "', '" + area + "'," + "       '" + estado + "', '" + sociedad + "', '" + guia + "') ";
            System.out.println(this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            final int i = this.pst.executeUpdate(this.lsQuery);
            System.out.println(i);
            this.m_conn.commit();
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
        }
    }
    
    public String consultaSociedad(final String sociedad) {
        String respuesta = "";
        try {
            this.lsQuery = "select nombre_empresa from SAP.SAP_SOCIEDAD where codigo_soc_sap_ii = ?";
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, sociedad);
            this.rs = this.pst.executeQuery();
            if (this.rs.next()) {
                respuesta = this.rs.getString(1);
            }
            else {
                respuesta = sociedad;
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            respuesta = sociedad;
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
        return respuesta;
    }
    
    public void mergeProveeduria() {
        try {
            this.lsQuery = "insert into SAP.SAP_PROVEEDURIA_REPLICA select a.* from sap_replica.SAP_PROVEEDURIA a left join SAP.SAP_PROVEEDURIA_REPLICA b on (a.prheader = b.prheader  and  a.preq_item = b.preq_item  and  a.bukrs = b.bukrs ) where b.prheader is null";
            System.out.println("Query MergeProveeduia: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            final int i = this.pst.executeUpdate(this.lsQuery);
            System.out.println(i);
            this.m_conn.commit();
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
        }
    }
    
    public String reversa(final String trama) {
        String respuesta = "";
        int liLongitud = trama.length();
        String cadena = trama;
        String solicitud = "";
        String numeroLinea = "";
        System.out.println("AQUI REVERSA");
        try {
            while (liLongitud > 1) {
                if (cadena == null) {
                    break;
                }
                solicitud = cadena.substring(0, cadena.indexOf("|"));
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                numeroLinea = cadena.substring(0, cadena.indexOf("|"));
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                liLongitud = cadena.length();
                respuesta = this.reversaOK(solicitud, Integer.parseInt(numeroLinea));
            }
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            respuesta = "Error al realizar reversa." + e.getMessage();
        }
        return respuesta;
    }
    
    public String reversaOK(final String solicitud, final int numeroLinea) {
        String respuesta = "";
        System.out.println("Solicitud : " + solicitud + " NumeroLinea : " + numeroLinea);
        try {
            this.lsQuery = "begin  ? := sak_trx_proveeduria_Ind.saf_reversaItem(?,?);  end;";
            (this.cas = this.m_conn.prepareCall(this.lsQuery)).setString(2, solicitud);
            this.cas.setInt(3, numeroLinea);
            this.cas.registerOutParameter(1, 2);
            this.cas.execute();
            final int i = this.cas.getInt(1);
            System.out.println("reversa: " + i);
            respuesta = "Reversa Correcta";
        }
        catch (Exception e) {
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            e.printStackTrace();
            respuesta = "ERROR: " + e.getMessage();
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
        return respuesta;
    }
    
    public List<String[]> consultaProveedor(final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select usuario from SAP.SAP_USUARIO_PORTAL where rol = 'P' and estado='A' and sociedad = '" + sociedad + "'";
            System.out.println("Query consultaProveedor: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1) };
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
    
    public List<String[]> consultaOficinaMetaIndicador(final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "select x.nombre_oficina from SAP.SAP_INDICADOR_SERVICIOS x";
            System.out.println("Query consultaOficinaMetaIndicador: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1) };
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
    
    public int dateYear() {
        final Calendar calendar = Calendar.getInstance();
        final Date now = calendar.getTime();
        calendar.setTime(now);
        int year = 0;
        year = calendar.get(1);
        return year;
    }
    
    public String dateMonth() {
        String result = "";
        final Calendar calendar = Calendar.getInstance();
        final Date now = calendar.getTime();
        calendar.setTime(now);
        int month = 0;
        try {
            month = calendar.get(2);
        }
        catch (Exception ex) {
            this.m_session.setAttribute("requestedPage", (Object)ex.getMessage());
        }
        switch (month) {
            case 0: {
                result = "Enero";
                break;
            }
            case 1: {
                result = "Febrero";
                break;
            }
            case 2: {
                result = "Marzo";
                break;
            }
            case 3: {
                result = "Abril";
                break;
            }
            case 4: {
                result = "Mayo";
                break;
            }
            case 5: {
                result = "Junio";
                break;
            }
            case 6: {
                result = "Julio";
                break;
            }
            case 7: {
                result = "Agosto";
                break;
            }
            case 8: {
                result = "Septiembre";
                break;
            }
            case 9: {
                result = "Octubre";
                break;
            }
            case 10: {
                result = "Noviembre";
                break;
            }
            case 11: {
                result = "Diciembre";
                break;
            }
            default: {
                result = "Error";
                break;
            }
        }
        return result;
    }
}