package com.conexion;

import java.sql.SQLException;
import javax.servlet.jsp.PageContext;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

public class Operacion_1 extends ConectaBase
{
    private PreparedStatement pst;
    private String lsQuery;
    private ResultSet rs;
    public String[] vBandeja;
    public String lsVendorId;
    
    public Operacion_1(final PageContext pc) throws Exception, SQLException {
        super(pc);
    }
    
    public String ConsultaUser(final String Usuario, final String Password, final String Sociedad) throws Exception {
        String ls_tipo_usuario = "";
        String ls_sociedad = "";
        this.lsQuery = " select rol , sociedad   from SAP.SAP_USUARIO_PORTAL  where usuario = ?    and clave = ?    and estado = 'A'";
        try {
            if (this.m_conn == null) {
                throw new Exception("Error de conexion");
            }
            if (this.rs != null) {
                this.rs.close();
            }
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, Usuario);
            this.pst.setString(2, Password);
            this.rs = this.pst.executeQuery();
            if (this.rs.next()) {
                ls_tipo_usuario = this.rs.getString(1);
                ls_sociedad = this.rs.getString(2);
            }
            if (!ls_tipo_usuario.equals("G")) {
                System.out.println("Sociedad : " + Sociedad);
                if (Sociedad == "") {
                    this.m_session.setAttribute("ERROR", (Object)" Selecionar una Sociedad ");
                }
                else if (!Sociedad.equals(ls_sociedad)) {
                    ls_sociedad = this.consularSociedad(Sociedad);
                    this.m_session.setAttribute("ERROR", (Object)(" No puede ingrsar con la sociedad : " + ls_sociedad));
                    this.m_session.setAttribute("PS_SOCIEDAD", (Object)"");
                    this.m_session.setAttribute("PS_ROL", (Object)"");
                }
                else {
                    this.m_session.setAttribute("ERROR", (Object)"");
                    this.m_session.setAttribute("PS_SOCIEDAD", (Object)ls_sociedad);
                    this.m_session.setAttribute("PS_ROL", (Object)ls_tipo_usuario);
                }
            }
            else {
                this.m_session.setAttribute("PS_SOCIEDAD", (Object)"");
                this.m_session.setAttribute("PS_ROL", (Object)"");
                this.m_session.setAttribute("ERROR", (Object)"");
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
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
        }
        return ls_sociedad;
    }
    
    public void cerrarSesion() throws Exception {
        try {
            if (this.m_conn != null) {
                this.m_conn.close();
            }
            if (this.m_conn_sesion != null) {
                this.m_conn_sesion.close();
            }
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            this.m_session.setAttribute("PS_CONEXION", (Object)null);
            this.m_session.setAttribute("AUTH", (Object)"false");
            this.m_session.setAttribute("INTENTO", (Object)null);
            this.m_session.setAttribute("ERROR", (Object)null);
            this.m_session.setAttribute("PS_SOCIEDAD", (Object)null);
            this.m_session.setAttribute("PS_ROL", (Object)null);
            this.m_session.invalidate();
        }
        catch (Exception e) {
            e.getStackTrace();
        }
    }
    
    public ResultSet ConsultaBandeja(final String lsUsusario) throws Exception {
        this.vBandeja = new String[6];
        try {
            this.lsQuery = "select p.prheader,\t\tmin(p.deliv_date),\t\tu.area_empresa,\t\tp.costcenter,\t\tsum(p.quantity),\t\tcase\t\twhen max(p.rel_ind) = min(p.rel_ind) then\t\tdecode(max(p.rel_ind),\t\t'2',\t\t'APROBADO',\t\t'3',\t\t'PARCIAL',\t\t'4',\t\t'TOTAL')\t\telse\t\t'PARCIAL'\t\tend\t\tfrom SAP.SAP_PROVEEDURIA_REPLICA p\t\tjoin SAP.SAP_USUARIO_PORTAL sp\t\ton (sp.id_proveedor = p.stcd1)\t\tleft join SAP.SAP_USUARIOS u\t\ton (p.created_by = u.usuario)\t\twhere  sp.usuario = ? \t\tand p.rel_ind in(2,3,4)\t\tgroup by p.prheader, u.area_empresa, p.costcenter";
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, lsUsusario);
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
        return this.rs;
    }
    
    public ResultSet getDetPedido(final String solicitud) {
        this.lsQuery = "   select p.preq_item,   p.material,   p.short_text,   nvl(max(h.fecha_ingresado),p.deliv_date),   p.quantity,   nvl(sum(h.cantidad_despachada),0)   from SAP.SAP_PROVEEDURIA_REPLICA p\t  left join SAP.SAP_PROVEEDURIA_DETALLE_HIS h\t  on (p.prheader = h.solicitud and p.preq_item = h.numero_linea)   where p.prheader= ?    group by p.preq_item,   p.material,   p.short_text,   p.deliv_date,   p.quantity";
        try {
            if (this.rs != null) {
                this.rs.close();
            }
            if (this.pst != null) {
                this.pst.close();
            }
            System.out.println("la solicitud es: " + solicitud);
            (this.pst = this.m_conn.prepareStatement(this.lsQuery)).setString(1, solicitud);
            this.rs = this.pst.executeQuery();
        }
        catch (SQLException e) {
            e.printStackTrace();
            this.rs = null;
        }
        return this.rs;
    }
    
    public ResultSet getHdrPedido(final String solicitud) {
        this.lsQuery = " select p.prheader as solicitud,\tcase\t    when max(p.rel_ind) = min(p.rel_ind) then\t    decode(max(p.rel_ind),\t    '2',\t    'APROBADO',\t    '3',\t    'PARCIAL',\t    '4',\t    'TOTAL')\t    else\t    'PARCIAL'\t    end as estado,\t    p.created_by as solicitante,\t    u.piso||' - '||u.nombre_oficina as departamento,\t    u.direccion||' - '||u.region as Area\tfrom SAP.SAP_PROVEEDURIA_REPLICA p\tleft join SAP.SAP_USUARIOS u\ton (p.created_by = u.usuario)\twhere p.prheader = ? \tand p.rel_ind in(2,3,4)\tgroup by p.prheader, p.created_by, u.piso,\tu.nombre_oficina, u.direccion, u.region";
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
            this.rs = this.pst.executeQuery();
            System.out.println("mensaje try");
        }
        catch (Exception e) {
            e.printStackTrace();
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
        }
        return lsVendorId;
    }
    
    public String disponibleCampoCantidad(final String cant_des, final String cant_pe) {
        final String salida = "disabled";
        return salida;
    }
    
    public ResultSet getSociedad() {
        try {
            this.lsQuery = " select a.codigo_soc_sap_ii , a.nombre_empresa from SAP.SAP_SOCIEDAD a ";
            this.pst = this.m_conn.prepareStatement(this.lsQuery);
            this.rs = this.pst.executeQuery();
        }
        catch (Exception e) {
            e.getStackTrace();
        }
        return this.rs;
    }
    
    public void ejecutaDespacho(final String setId, final String nroOrden, final String usuario, String cadena) throws Exception, SQLException {
        int liLongitud = cadena.length();
        int i = 0;
        int solicitud = 0;
        String proveedor = "";
        String pedido = "";
        int cantPedida = 0;
        int cantDespachada = 0;
        String aux = "";
        String Material = "";
        try {
            if (cadena.equals(null)) {
                throw new Exception("Error al generar cadena");
            }
            System.out.println(cadena);
            while (liLongitud > 1 && cadena != null) {
                solicitud = Integer.parseInt(cadena.substring(0, cadena.indexOf("|")));
                System.out.println("id orden " + solicitud + " - ");
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                proveedor = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("proveedor " + proveedor);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                pedido = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("pedido " + pedido);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                Material = cadena.substring(0, cadena.indexOf("|"));
                System.out.println("pedido " + Material);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                cantPedida = Integer.parseInt(cadena.substring(0, cadena.indexOf("|")));
                System.out.println("cantPedida " + cantPedida);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                aux = cadena.substring(0, cadena.indexOf("|"));
                if (!"".equals(aux)) {
                    cantDespachada = Integer.parseInt(aux);
                }
                System.out.println("cantDespachada " + cantDespachada);
                cadena = cadena.substring(cadena.indexOf("|") + 1);
                liLongitud = cadena.length();
                System.out.println("longitud " + liLongitud);
                this.lsQuery = "insert into SAP.SAP_PROVEEDURIA_DETALLE_HIS(id_solicitud, no_orden, id_proveedor, id_material, fecha_despachada, cantidad_pedida, cantidad_despachada)values(" + solicitud + ",'" + pedido + "','" + proveedor + "','" + Material + "',sysdate," + cantPedida + "," + cantDespachada + " )";
                System.out.println(this.lsQuery);
                this.m_conn.commit();
                if (cantDespachada != 0) {
                    this.pst = this.m_conn.prepareStatement(this.lsQuery);
                    i = this.pst.executeUpdate(this.lsQuery);
                    System.out.println("ejecuta update " + i);
                }
            }
            this.m_conn.commit();
        }
        catch (Exception e) {
            this.m_conn.rollback();
            e.printStackTrace();
            this.m_session.setAttribute("requestedPage", (Object)e.getMessage());
        }
    }
}