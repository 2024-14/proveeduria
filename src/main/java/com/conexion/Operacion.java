package com.conexion;

import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import javax.servlet.jsp.PageContext;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

public class Operacion extends ConectaBase
{
    private PreparedStatement pst;
    private String lsQuery;
    private ResultSet rs;
    public String[] vBandeja;
    public String lsVendorId;
    
    public Operacion(final PageContext pc) throws Exception, SQLException {
        super(pc);
    }
    
    public String ConsultaRUC(final String Usuario, final String Password, final String Sociedad) throws Exception {
    	//abrir sesion
        String ls_tipo_usuario = "";
        this.lsQuery = " select id_proveedor   from SAP.SAP_USUARIO_PORTAL  where usuario = ?    and clave = ?    and sociedad = '" + Sociedad + "'" + "    and estado = 'A'";
        try {
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, Usuario);
            this.pst.setString(2, Password);
            System.out.println("Sociedad de consulta  " + this.lsQuery);
            this.rs = this.pst.executeQuery();
            if (this.rs.next()) {
                ls_tipo_usuario = this.rs.getString(1);
                System.out.println("Sociedad de consulta  " + ls_tipo_usuario);
            }
        }
        catch (SQLException e) {
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
        return ls_tipo_usuario;
    }
    
    public String ConsultaUser(final String Usuario, final String Password, final String Sociedad) throws Exception {
        String ls_tipo_usuario = "";
        String ls_sociedad = "";
        String ls_nombre_proveedor = "";
        String ls_usuario_proveedor = "";
        this.lsQuery = " select rol , sociedad , NOMBRE_PROVEEDOR,  USUARIO     from SAP.SAP_USUARIO_PORTAL  where usuario = '" + Usuario + "'" + "    and clave = '" + Password + "'" + "    and sociedad = '" + Sociedad + "'" + "    and estado = 'A'";
        System.out.println("ConsultaUser: " + this.lsQuery);
        try {
            if (this.m_conn == null) {
                throw new Exception("Error de conexion");
            }
            if (this.rs != null) {
                this.rs.close();
            }
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            if (this.rs.next()) {
                ls_tipo_usuario = this.rs.getString(1);
                ls_sociedad = this.rs.getString(2);
                ls_nombre_proveedor = this.rs.getString(3);
                ls_usuario_proveedor = this.rs.getString(4);
                this.m_session.setAttribute("NOMBREUSUARIO", (Object)ls_nombre_proveedor);
            }
            if (!ls_tipo_usuario.equals("G")) {
                System.out.println("Sociedad : " + Sociedad);
                if (Sociedad == "") {
                    this.m_session.setAttribute("ERROR", (Object)" Selecionar una Sociedad ");
                }
                else if (!Sociedad.equals(ls_sociedad)) {
                    ls_sociedad = this.consularSociedad(Sociedad);
                    this.m_session.setAttribute("ERROR", (Object)(" No puede ingresar con la sociedad : " + ls_sociedad));
                    this.m_session.setAttribute("PS_SOCIEDAD", (Object)"");
                    this.m_session.setAttribute("PS_ROL", (Object)"");
                    this.m_session.setAttribute("PS_USER", (Object)"");
                }
                else {
                    this.m_session.setAttribute("ERROR", (Object)"");
                    this.m_session.setAttribute("PS_SOCIEDAD", (Object)ls_sociedad);
                    this.m_session.setAttribute("PS_ROL", (Object)ls_tipo_usuario);
                    this.m_session.setAttribute("PS_USER", (Object)ls_usuario_proveedor);
                }
            }
            else {
                this.m_session.setAttribute("PS_SOCIEDAD", (Object)"");
                this.m_session.setAttribute("PS_ROL", (Object)"");
                this.m_session.setAttribute("ERROR", (Object)"");
                this.m_session.setAttribute("PS_USER", (Object)"");
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return ls_tipo_usuario;
    }
    
    public String consularSociedad(final String sociedad) {
        String ls_sociedad = sociedad;
        this.lsQuery = " select a.nombre_empresa    from SAP.SAP_SOCIEDAD a   where a.codigo_soc_sap_ii = ? ";
        try {
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, sociedad);
            this.rs = this.pst.executeQuery();
            if (this.rs.next()) {
                ls_sociedad = this.rs.getString(1);
                System.out.println("Sociedad de consulta  " + ls_sociedad);
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return ls_sociedad;
    }
    
    public void cerrarSesionUsuario() {
    	this.m_session.setAttribute("AUTH", (Object)"false");
        this.m_session.setAttribute("INTENTO", (Object)null);
        this.m_session.invalidate();
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
    
    public List<String[]> bandejaProveedor(final String lsUsusario, final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = " Select * from (select p.prheader,\t\tmin(p.ch_on),\t\tnvl((Select descripcion from SAP.SAP_AREA s where id_area = u.area_empresa),'-'),\t\tp.costcenter,\t\tsum(p.value_item),\t\tcase\t\twhen max(p.rel_ind) = min(p.rel_ind) then\t\tdecode(max(p.rel_ind),\t\t'2',\t\t'APROBADO',\t\t'3',\t\t'DESPACHO PARCIAL',\t\t'4',\t\t'DESPACHO TOTAL')\t\telse\t\t'DESPACHO PARCIAL'\t\tend as estado \t\tfrom SAP.SAP_PROVEEDURIA_REPLICA p\t\tjoin SAP.SAP_USUARIO_PORTAL sp\t\ton (sp.id_proveedor = p.stcd1)\t\tleft join SAP.SAP_USUARIOS u\t\ton (p.created_by = u.codigo_usuario)\t\twhere  sp.usuario = '" + lsUsusario + "' " + "\t\tand p.rel_ind in('2','3','4')" + "\t\tand p.bukrs = '" + sociedad + "'" + "\t\tgroup by p.prheader, u.area_empresa, p.costcenter) dato order by dato.estado ";
            System.out.println("Query bandejaProveedor: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), String.valueOf(this.rs.getDate(2)), this.rs.getString(3), this.rs.getString(4), String.format("%.02f", this.rs.getFloat(5)).replace(".", ","), this.rs.getString(6) };
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
    
    public ResultSet ConsultaBandeja_old(final String lsUsusario) throws Exception {
        this.vBandeja = new String[6];
        System.out.println("holisss " + lsUsusario);
        try {
            this.lsQuery = " Select * from (select p.prheader,\t\tmin(p.ch_on),\t\tnvl((Select descripcion from SAP.SAP_AREA s where id_area = u.area_empresa),'-'),\t\tp.costcenter,\t\tsum(p.value_item),\t\tcase\t\twhen max(p.rel_ind) = min(p.rel_ind) then\t\tdecode(max(p.rel_ind),\t\t'2',\t\t'APROBADO',\t\t'3',\t\t'DESPACHO PARCIAL',\t\t'4',\t\t'DESPACHO TOTAL')\t\telse\t\t'DESPACHO PARCIAL'\t\tend as estado \t\tfrom SAP.SAP_PROVEEDURIA_REPLICA p\t\tjoin SAP.SAP_USUARIO_PORTAL sp\t\ton (sp.id_proveedor = p.stcd1)\t\tleft join SAP.SAP_USUARIOS u\t\ton (p.created_by = u.codigo_usuario)\t\twhere  sp.usuario = ? \t\tand p.rel_ind in('2','3','4')\t\tgroup by p.prheader, u.area_empresa, p.costcenter) dato order by dato.estado ";
            System.out.println("query: " + this.lsQuery);
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, lsUsusario);
            this.rs = this.pst.executeQuery();
            System.out.println(this.rs.getRow());
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return this.rs;
    }
    
    public List<String[]> getDetPedido(final String solicitud, final String ruc, final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = "   select distinct(p.preq_item),          p.material,          p.short_text,   \t\t max(p.Ch_On),   \t\t p.quantity,   \t\t nvl(sum(h.cantidad_despachada),0),   \t     max(h.guia_remision),\t\t\t to_char(max(h.fecha_despachada),'dd/mm/yyyy')    \t \t      from SAP.SAP_PROVEEDURIA_REPLICA p\t    left join SAP.SAP_PROVEEDURIA_DETALLE_HIS h\t      on (p.prheader = h.solicitud and p.preq_item = h.numero_linea)    where p.prheader= '" + solicitud + "' " + "\t     and p.rel_ind in (2,3,4)" + "      and p.stcd1 = '" + ruc + "' " + "\t and p.bukrs = '" + sociedad + "' " + "    group by p.preq_item," + "             p.material," + "             p.short_text," + "             p.Ch_On," + "             p.quantity";
            System.out.println("Query getDetPedido: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), String.valueOf(this.rs.getDate(4)), this.rs.getString(5), this.rs.getString(6), this.rs.getString(7), this.rs.getString(8) };
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
    
    public ResultSet getDetPedido_old(final String solicitud, final String ruc) {
        this.lsQuery = "   select distinct(p.preq_item),          p.material,          p.short_text,   \t\t max(p.Ch_On),   \t\t p.quantity,   \t\t nvl(sum(h.cantidad_despachada),0),   \t     max(h.guia_remision),\t\t\t to_char(max(h.fecha_despachada),'dd/mm/yyyy')    \t \t      from SAP.SAP_PROVEEDURIA_REPLICA p\t    left join SAP.SAP_PROVEEDURIA_DETALLE_HIS h\t      on (p.prheader = h.solicitud and p.preq_item = h.numero_linea)    where p.prheader= ? \t     and p.rel_ind in (2,3,4)      and p.stcd1 = ? \t and p.bukrs = ?     group by p.preq_item,             p.material,             p.short_text,             p.Ch_On,             p.quantity\t\t\t\t ";
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            System.out.println("la solicitud es: " + solicitud);
            System.out.println("la ruc es: " + ruc);
            System.out.println("el query: " + this.lsQuery);
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, solicitud);
            this.pst.setString(2, ruc);
            this.rs = this.pst.executeQuery();
            System.out.println(this.rs);
        }
        catch (SQLException e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            this.rs = null;
        }
        return this.rs;
    }
    
    public List<String[]> getHdrPedido(final String solicitud, final String usuario, final String sociedad) throws Exception {
        List<String[]> resultado = null;
        try {
            this.lsQuery = " select p.prheader as solicitud,\tcase\t    when max(p.rel_ind) = min(p.rel_ind) then\t    decode(max(p.rel_ind),\t    '2',\t    'APROBADO',\t    '3',\t    'DESPACHO PARCIAL',\t    '4',\t    'DESPACHO TOTAL')\t    else\t    'PARCIAL'\t    end as estado,\t    p.created_by ||' - '|| p.name as solicitante,\t    u.region||' - '||u.nombre_oficina||' - '||u.direccion||' - '||u.piso as departamento,\t    nvl((Select descripcion from SAP.SAP_AREA s where id_area = u.area_empresa),'-') as Area,      p.created_by \tfrom SAP.SAP_PROVEEDURIA_REPLICA p\tleft join SAP.SAP_USUARIOS u\t  on (p.created_by = u.codigo_usuario)  join SAP.SAP_USUARIO_PORTAL sp    on (sp.id_proveedor = p.stcd1) \twhere p.prheader = '" + solicitud + "' " + "   AND SP.USUARIO = '" + usuario + "' " + "\tand p.rel_ind in(2,3,4) " + "\tand p.bukrs = '" + sociedad + "'" + "\tgroup by p.prheader, p.created_by, u.piso," + "\tu.nombre_oficina, u.direccion, u.region , u.area_empresa ,p.name ";
            System.out.println("Query getHdrPedido: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            resultado = new ArrayList<String[]>();
            String[] fila = null;
            while (this.rs.next()) {
                fila = new String[] { this.rs.getString(1), this.rs.getString(2), this.rs.getString(3), this.rs.getString(4), this.rs.getString(5), this.rs.getString(6) };
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
    
    public ResultSet getHdrPedido_old(final String solicitud, final String usuario) {
        this.lsQuery = " select p.prheader as solicitud,\tcase\t    when max(p.rel_ind) = min(p.rel_ind) then\t    decode(max(p.rel_ind),\t    '2',\t    'APROBADO',\t    '3',\t    'DESPACHO PARCIAL',\t    '4',\t    'DESPACHO TOTAL')\t    else\t    'PARCIAL'\t    end as estado,\t    p.created_by ||' - '|| p.name as solicitante,\t    u.region||' - '||u.nombre_oficina||' - '||u.direccion||' - '||u.piso as departamento,\t    nvl((Select descripcion from SAP.SAP_AREA s where id_area = u.area_empresa),'-') as Area,      p.created_by \tfrom SAP.SAP_PROVEEDURIA_REPLICA p\tleft join SAP.SAP_USUARIOS u\t  on (p.created_by = u.codigo_usuario)  join SAP.SAP_USUARIO_PORTAL sp    on (sp.id_proveedor = p.stcd1) \twhere p.prheader = ?    AND SP.USUARIO = ?\tand p.rel_ind in(2,3,4)\tgroup by p.prheader, p.created_by, u.piso,\tu.nombre_oficina, u.direccion, u.region , u.area_empresa ,p.name ";
        System.out.println("Consultas Query ::::>>>" + this.lsQuery);
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            System.out.println(solicitud);
            System.out.println(this.lsQuery);
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setInt(1, Integer.parseInt(solicitud));
            this.pst.setString(2, usuario);
            this.rs = this.pst.executeQuery();
            System.out.println("mensaje try");
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            this.rs = null;
        }
        return this.rs;
    }
    
    public String CantidadDespachada(final String solicitud, final String noOrden, final String proveedor, final String material) {
        this.lsQuery = "   select p.preq_item,   p.material,   p.short_text,   nvl(max(h.fecha_ingresado),p.deliv_date),   p.quantity,   sum(h.cantidad_despachada)   from SAP.SAP_PROVEEDURIA_REPLICA p\t  join SAP.SAP_PROVEEDURIA_DETALLE_HIS h\t  on (p.prheader = h.solicitud and p.preq_item = h.numero_linea)   where p.prheader= ?    group by p.preq_item,   p.material,   p.short_text,   p.deliv_date,   p.quantity";
        String lsVendorId = "0";
        try {
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, solicitud);
            this.pst.setString(2, noOrden);
            this.pst.setString(3, proveedor);
            this.pst.setString(4, material);
            this.rs = this.pst.executeQuery();
            this.m_conn.commit();
            if (this.rs.next()) {
                lsVendorId = this.rs.getString(1);
            }
        }
        catch (Exception e) {
            e.getStackTrace();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return lsVendorId;
    }
    
    public String disponibleCampoCantidad(final String cant_des, final String cant_pe) {
        final String salida = "disabled";
        return salida;
    }
    
    public String getUsuarioGuiaRemision(final String usuario, final String sociedad) {
        String result = "";
        try {
            this.lsQuery = " Select GUIA_REMISION from SAP.SAP_USUARIOS  where codigo_usuario = '" + usuario + "' " + " and estatus = 'A' " + " and sociedad = '" + sociedad + "'";
            System.out.println("Query getUsuarioGuiaRemision: " + this.lsQuery);
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            while (this.rs.next()) {
                result = this.rs.getString(1);
            }
        }
        catch (Exception e) {
            result = "N";
            e.getStackTrace();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
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
        return result;
    }
    
    public String Band_soc() {
        String resultado_str = "";
        try {
            final String lsQuerycon = " select a.valor from scp_Dat.scp_parametros_procesos a where a.id_parametro='BAND_PROVEEDURIA' ";
            System.out.println("Query bandera: " + lsQuerycon);
            final PreparedStatement band_con = this.m_conn.prepareStatement(lsQuerycon);
            System.out.println("Query bandera: " + band_con);
            final ResultSet rsban = band_con.executeQuery();
            System.out.println("Query bandera: " + rsban);
            try {
                if (rsban.next()) {
                    resultado_str = rsban.getString("valor");
                    System.out.println("Query bandera: " + resultado_str);
                }
                rsban.close();
            }
            catch (Exception exc) {
                throw new RuntimeException(exc);
            }
        }
        catch (Exception ex) {}
        return resultado_str;
    }
    
    public List<String[]> getSociedad() throws Exception {
        List<String[]> resultado = null;
        try {
            final String resultado_str = this.Band_soc();
            System.out.println("Query getSociedad: " + resultado_str);
            if (resultado_str.equals("S")) {
                this.lsQuery = " select a.codigo_soc_sap_ii , a.nombre_empresa from SAP.SAP_SOCIEDAD a where a.codigo_soc_sap_ii='EC02' ";
            }
            else {
                this.lsQuery = " select a.codigo_soc_sap_ii , a.nombre_empresa from SAP.SAP_SOCIEDAD a ";
            }
            System.out.println("Query getSociedad: " + this.lsQuery);
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
    
    public ResultSet getSociedad_old() {
        try {
            this.lsQuery = " select a.codigo_soc_sap_ii , a.nombre_empresa from SAP.SAP_SOCIEDAD a ";
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            e.getStackTrace();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return this.rs;
    }
    
    public ResultSet adminPortal(final String sociedad) throws Exception {
        try {
            this.lsQuery = "select up.usuario, up.clave, DECODE(up.rol, 'P', 'PROVEEDOR',     'A', 'ADMINISTRADOR',     'S', 'SUPERVISOR',     'G', 'GERENTE',     'J', 'JEFATURA') rol,up.sociedad,up.email as correo,DECODE(up.estado, 'A', 'ACTIVO','I', 'INACTIVO') estado, up.id_proveedor from SAP.SAP_USUARIO_PORTAL up where up.sociedad = '" + sociedad + "'";
            System.out.println(this.lsQuery);
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
        }
        return this.rs;
    }
    
    public String deletePortalAdmin(final String usuario, final String sociedad) throws Exception, SQLException {
        int i = 0;
        String error = "";
        System.out.println("el usario: " + usuario);
        try {
            if (usuario.equals(null)) {
                error = "Error, debe ingresar usuario para eliminar.";
            }
            else {
                final int status = this.validaInsertPortal(usuario, sociedad, "0");
                System.out.println("Existe en base: " + status);
                if (status != 0) {
                    this.lsQuery = "delete from SAP.SAP_USUARIO_PORTAL up where up.usuario = '" + usuario + "' " + "and up.sociedad = '" + sociedad + "'";
                    System.out.println("query: " + this.lsQuery);
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    i = this.pst.executeUpdate(this.lsQuery);
                    System.out.println("delete " + i);
                    this.m_conn.commit();
                    error = "Registro Eliminado Correctamente...";
                }
                else {
                    error = "Error al Eliminar, el Usuario " + usuario + " con Sociedad " + sociedad + " NO existe!";
                }
            }
        }
        catch (Exception e) {
            this.m_conn.rollback();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            error = "Error al ingresar datos: " + e.getCause();
        }
        return error;
    }
    
    public String actualizaPortalAdmin(String cadena) throws Exception, SQLException {
        int liLongitud = cadena.length();
        int i = 0;
        String usuario = "";
        String clave = "";
        String correo = "";
        String rol = "";
        String sociedad = "";
        String estado = "";
        String ruc = "";
        String error = "";
        try {
            if (cadena.equals(null)) {
                throw new Exception("Error al generar cadena");
            }
            System.out.println(cadena);
            while (liLongitud > 1) {
                if (cadena == null) {
                    break;
                }
                usuario = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("usuario " + usuario);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                clave = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("clave " + clave);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                rol = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("rol " + rol);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                sociedad = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("sociedad " + sociedad);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                correo = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("correo " + correo);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                estado = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("estado " + estado);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                ruc = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("ruc " + ruc);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                final int status = this.validaInsertPortal(usuario, sociedad, ruc);
                System.out.println("Existe en base: " + status);
                if (status != 0) {
                    this.lsQuery = "update  SAP.SAP_USUARIO_PORTAL\tset clave    = '" + clave + "'," + "\t    rol      = '" + rol + "'," + "\t    sociedad = '" + sociedad + "'," + "\t    email   = '" + correo + "'," + "\t    estado   = '" + estado + "'," + "\t    id_proveedor   = '" + ruc + "'" + "\twhere usuario = '" + usuario + "'";
                    System.out.println("query: " + this.lsQuery);
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    i = this.pst.executeUpdate(this.lsQuery);
                    System.out.println("insert " + i);
                    this.m_conn.commit();
                    error = "Datos Ingresados correctamente";
                }
                else {
                    error = "Error!! El Usuario " + usuario + " con Sociedad " + sociedad + " y RUC " + ruc + " NO existe!";
                }
                liLongitud = cadena.length();
            }
        }
        catch (Exception e) {
            this.m_conn.rollback();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            error = "Error al ingresar datos: " + e.getCause();
        }
        return error;
    }
    
    public int validaInsertPortal(final String Usuario, final String Sociedad, final String id) throws SQLException {
        int resultado = 0;
        try {
            this.lsQuery = " select count(*) from SAP.SAP_USUARIO_PORTAL up  where up.usuario = '" + Usuario + "'" + "  and up.sociedad = '" + Sociedad + "'";
            System.out.println("Query ValidaInsertPortal: " + this.lsQuery);
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
            while (this.rs.next()) {
                resultado = this.rs.getInt(1);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            System.out.println(e.getMessage());
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
    
    public String insertPortalAdmin(String cadena) throws Exception, SQLException {
        int liLongitud = cadena.length();
        int i = 0;
        String usuario = "";
        String clave = "";
        String correo = "";
        String rol = "";
        String sociedad = "";
        String estado = "";
        String ruc = "";
        String error = "";
        try {
            if (cadena.equals(null)) {
                throw new Exception("Error al generar cadena");
            }
            System.out.println(cadena);
            while (liLongitud > 1) {
                if (cadena == null) {
                    break;
                }
                usuario = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("usuario " + usuario);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                clave = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("clave " + clave);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                rol = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("rol " + rol);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                sociedad = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("sociedad " + sociedad);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                correo = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("correo " + correo);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                estado = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("estado " + estado);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                ruc = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("ruc " + ruc);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                final int status = this.validaInsertPortal(usuario, sociedad, ruc);
                System.out.println("Existe en base: " + status);
                if (status == 0) {
                    this.lsQuery = "insert into SAP.SAP_USUARIO_PORTAL(setid, nombre_proveedor, usuario, clave, email, rol, sociedad, estado, id_proveedor) values('PORTA','" + usuario + "','" + usuario + "','" + clave + "','" + correo + "','" + rol + "','" + sociedad + "','" + estado + "','" + ruc + "')";
                    System.out.println("query insertPortalAdmin: " + this.lsQuery);
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    i = this.pst.executeUpdate(this.lsQuery);
                    System.out.println("insert " + i);
                    this.m_conn.commit();
                    error = "Datos Ingresados correctamente";
                }
                else {
                    error = "Error el Usuario " + usuario + " con Sociedad " + sociedad + " y RUC " + ruc + " ya existe!";
                }
                liLongitud = cadena.length();
            }
        }
        catch (Exception e) {
            this.m_conn.rollback();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
            error = "Error al ingresar datos: " + e.getCause();
            this.pst.close();
        }
        this.pst.close();
        return error;
    }
    
    public void ejecutaListadoDespacho(final ArrayList<String> listado, final String idSolicitud, final String ruc, final String sociedad) {
        try {
            int idx = 0;
            for (final String lis : listado) {
                ++idx;
                final String[] detalle = lis.split("\\|");
                System.out.println("Indice::" + idx);
                int solicitud = 0;
                int numero_linea = 0;
                String usuario = "";
                int cantOrigen = 0;
                int cantDespachada = 0;
                String aux = "";
                String material = "";
                String descripcion = "";
                String fechaIngreso = "";
                String estado = "";
                String guiaRemi = "";
                String proveedor = "";
                String valEstado = "";
                String rucProveedor = "";
                solicitud = Integer.parseInt(detalle[0]);
                System.out.println("solicitud " + solicitud);
                numero_linea = Integer.parseInt(detalle[1]);
                System.out.println("numero_linea " + numero_linea);
                usuario = detalle[2];
                System.out.println("usuario " + usuario);
                proveedor = detalle[3];
                System.out.println("proveedor " + proveedor);
                material = detalle[4];
                System.out.println("material " + material);
                descripcion = detalle[5];
                System.out.println("descripcion " + descripcion);
                cantOrigen = Integer.parseInt(detalle[6]);
                System.out.println("cantOrigen " + cantOrigen);
                aux = detalle[7];
                if (!"".equals(aux)) {
                    cantDespachada = Integer.parseInt(aux);
                }
                System.out.println("cantDespachada " + cantDespachada);
                valEstado = detalle[8];
                System.out.println("estado " + valEstado);
                if (valEstado.indexOf("APROBADO") != 0) {
                    estado = "2";
                }
                else if (valEstado.indexOf("PARCIAL") != 0) {
                    estado = "3";
                }
                else if (valEstado.indexOf("TOTAL") != 0) {
                    estado = "4";
                }
                guiaRemi = detalle[9];
                System.out.println("guiaRemi " + guiaRemi);
                fechaIngreso = detalle[10];
                System.out.println("fechaIngreso " + fechaIngreso);
                rucProveedor = detalle[11];
                System.out.println("rucProveedor " + rucProveedor);
                System.out.println("-----------------------------------------------------------------------------------");
                this.lsQuery = "insert into SAP.SAP_PROVEEDURIA_DETALLE_HIS(solicitud, numero_linea, usuario, proveedor, material, descripcion, cantidad_origen, cantidad_despachada, fecha_ingresado, estado, guia_remision, fecha_despachada, STCD1)values(" + solicitud + "," + numero_linea + ",'" + usuario + "','" + proveedor + "','" + material + "','" + descripcion + "'," + cantOrigen + "," + cantDespachada + ",sysdate,'" + estado + "'" + ",'" + guiaRemi + "',to_date('" + fechaIngreso + "', 'dd/mm/yyyy'),'" + rucProveedor + "')";
                System.out.println(this.lsQuery);
                this.pst = this.m_conn.prepareStatement(this.lsQuery);
                int i = this.pst.executeUpdate(this.lsQuery);
                System.out.println("ejecuta insert " + i);
                this.m_conn.commit();
                String ls_estado = "";
                this.lsQuery = " Select case when (datos.quantity=datos.cantidad_desp) then 1 else 0 end as diferencia, preq_item  from (select p.quantity,  nvl(sum(h.cantidad_despachada),0) as cantidad_desp, p.preq_item  from SAP.SAP_PROVEEDURIA_REPLICA p  inner join SAP.SAP_PROVEEDURIA_DETALLE_HIS h  on (p.prheader = h.solicitud and p.preq_item = h.numero_linea)  where p.prheader=?  and p.rel_ind in (2,3,4)  and p.stcd1 = ?  and p.bukrs = ?  group by p.preq_item, p.material, p.short_text, p.Ch_On, p.quantity, p.preq_item) datos ";
                (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, idSolicitud);
                this.pst.setString(2, ruc);
                this.pst.setString(3, sociedad);
                this.rs = this.pst.executeQuery();
                int lb_flag = 0;
                while (this.rs.next()) {
                    numero_linea = this.rs.getInt(2);
                    if (this.rs.getInt(1) == 0) {
                        lb_flag = 1;
                        System.out.println("ejecuta insert " + lb_flag);
                        ls_estado = "3";
                    }
                    else {
                        ls_estado = "4";
                    }
                    this.lsQuery = "Update SAP.SAP_PROVEEDURIA_REPLICA p Set p.rel_ind = '" + ls_estado + "' " + " where p.prheader = " + solicitud + " and p.bukrs = '" + sociedad + "' " + " and p.preq_item = " + numero_linea + " and p.stcd1 = '" + ruc + "'";
                    System.out.println(this.lsQuery);
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    i = this.pst.executeUpdate(this.lsQuery);
                    System.out.println("ejecuta update SAP.SAP_PROVEEDURIA_REPLICA " + i);
                    System.out.println("ejecuta update 2 " + i);
                    this.lsQuery = "Update SAP.SAP_PROVEEDURIA_DETALLE_HIS pd Set pd.estado = '" + ls_estado + "'" + " where pd.solicitud = " + solicitud + " and pd.numero_linea = " + numero_linea + " and pd.stcd1 = '" + ruc + "'";
                    System.out.println(this.lsQuery);
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    i = this.pst.executeUpdate(this.lsQuery);
                    System.out.println("ejecuta update SAP.SAP_PROVEEDURIA_DETALLE_HIS " + i);
                }
            }
            this.m_conn.commit();
        }
        catch (Exception e2) {
            try {
                this.m_conn.rollback();
            }
            catch (SQLException e1) {
                e1.printStackTrace();
                e2.printStackTrace();
                this.m_session.setAttribute("requestedPage", (Object)e2.getMessage());
            }
            e2.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e2.getMessage());
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
    
    public void ejecutaDespacho(String cadena) throws Exception, SQLException {
        int liLongitud = cadena.length();
        int i = 0;
        int solicitud = 0;
        int numero_linea = 0;
        String usuario = "";
        int cantOrigen = 0;
        int cantDespachada = 0;
        String aux = "";
        String material = "";
        String descripcion = "";
        String fechaIngreso = "";
        String estado = "";
        String valEstado = "";
        String proveedor = "";
        String valEstado2 = "";
        String guiaRemi = "";
        try {
            if (cadena.equals(null)) {
                throw new Exception("Error al generar cadena");
            }
            System.out.println(cadena);
            while (liLongitud > 1 && cadena != null) {
                solicitud = Integer.parseInt(cadena.substring(0, cadena.indexOf("|")));
                System.out.println("solicitud " + solicitud);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                numero_linea = Integer.parseInt(cadena.substring(0, cadena.indexOf("|")));
                System.out.println("numero_linea " + numero_linea);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                usuario = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("usuario " + usuario);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                proveedor = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("proveedor " + proveedor);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                material = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("material " + material);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                descripcion = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("descripcion " + descripcion);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                cantOrigen = Integer.parseInt(cadena.substring(0, cadena.indexOf("|")));
                System.out.println("cantOrigen " + cantOrigen);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                aux = cadena.substring(0, cadena.indexOf("|"));
                if (!"".equals(aux)) {
                    cantDespachada = Integer.parseInt(aux);
                }
                System.out.println("cantDespachada " + cantDespachada);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                valEstado = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("estado " + valEstado);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                if (valEstado.equals("APROBADO")) {
                    estado = "2";
                }
                else if (valEstado.equals("PARCIAL")) {
                    estado = "3";
                }
                else if (valEstado.equals("TOTAL")) {
                    estado = "4";
                }
                guiaRemi = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("guiaRemi " + guiaRemi);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                fechaIngreso = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("estado " + fechaIngreso);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                liLongitud = cadena.length();
                System.out.println("longitud " + liLongitud);
                this.lsQuery = "insert into SAP.SAP_PROVEEDURIA_DETALLE_HIS(solicitud, numero_linea, usuario, proveedor, material, descripcion, cantidad_origen, cantidad_despachada, fecha_ingresado, estado, guia_remision, fecha_despachada)values(" + solicitud + "," + numero_linea + ",'" + usuario + "','" + proveedor + "','" + material + "','" + descripcion + "'," + cantOrigen + "," + cantDespachada + ",sysdate,'" + estado + "'" + ",'" + guiaRemi + "',to_date('" + fechaIngreso + "', 'dd/mm/yyyy'))";
                System.out.println(this.lsQuery);
                this.m_conn.commit();
                if (cantDespachada != 0) {
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    i = this.pst.executeUpdate(this.lsQuery);
                    System.out.println("ejecuta update " + i);
                }
                if (cantOrigen > cantDespachada) {
                    valEstado2 = "3";
                }
                if (cantOrigen == cantDespachada) {
                    valEstado2 = "4";
                }
                System.out.println("valor_estado: " + valEstado2);
                this.lsQuery = "Update SAP.SAP_PROVEEDURIA_DETALLE_HIS pd Set pd.estado = '" + valEstado2 + "'" + " where pd.solicitud = " + solicitud + " and pd.numero_linea = " + numero_linea;
                System.out.println(this.lsQuery);
                this.pst = this.m_conn.prepareStatement(this.lsQuery);
                i = this.pst.executeUpdate(this.lsQuery);
                System.out.println("ejecuta update " + i);
                this.lsQuery = "Update SAP.SAP_PROVEEDURIA_REPLICA p Set p.rel_ind = '" + valEstado2 + "'" + " where p.prheader = " + solicitud + " and p.preq_item = " + numero_linea;
                System.out.println(this.lsQuery);
                this.pst = this.m_conn.prepareStatement(this.lsQuery);
                i = this.pst.executeUpdate(this.lsQuery);
                System.out.println("ejecuta update 2 " + i);
            }
            this.m_conn.commit();
        }
        catch (Exception e) {
            this.m_conn.rollback();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
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
            respuesta = sociedad;
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return respuesta;
    }
}