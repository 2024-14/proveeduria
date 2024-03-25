package com.conexion;
 
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;
import javax.sql.DataSource;
import oracle.jdbc.driver.OracleDriver;

public class ConectaBase extends PropertiesPortal {
  public PageContext m_pageContext;
  
  public HttpServletResponse m_response;
  public Connection m_conn;
  public Connection m_conn_sesion;
  
  public HttpServletRequest m_request;
  
  public HttpSession m_session;
  	
  private DataSource dsconxionDB;
  
  public ConectaBase(PageContext pc) throws Exception, SQLException {
    this.m_conn = null;
    this.m_conn_sesion = null;
    this.m_pageContext = pc;
    this.m_response = (HttpServletResponse)pc.getResponse();
    this.m_request = (HttpServletRequest)this.m_pageContext.getRequest();
    this.m_session = this.m_pageContext.getSession();
    InitialContext initContext = null;
    try {
      this.m_conn_sesion = (Connection)this.m_session.getAttribute("PS_CONEXION");	
      if (this.m_conn_sesion == null) {
        initContext = new InitialContext();
        System.out.println("Contexto: " + initContext);
        try {
          this.dsconxionDB = (DataSource)initContext.lookup("jdbc/proveeduriaSAPD");
          System.out.println("JDBC: " + this.dsconxionDB);
          this.m_conn = this.dsconxionDB.getConnection();
        } catch (Exception e) {
          System.out.println("ERROR CONEXION PRODUCCION jdbc: " + this.m_conn);
          this.m_conn = null;
        } 
        if (this.m_conn == null)
          getConexion(); 
        initContext.close();
        initContext = null;
        this.m_conn.setAutoCommit(false);
        this.m_session.setAttribute("INTENTO", "1");
        this.m_session.setAttribute("PS_CONEXION", this.m_conn);
      } else {
        this.m_conn = this.m_conn_sesion;
      } 
    } catch (Throwable e) {
      System.out.println("JAVA BEAN : " + e);
      this.m_session.setAttribute("ERROR", e.getMessage());
    } 
  }
  
  public Connection getConnection() {
    return this.m_conn;
  }
  
  public void getConexion() {
    try {
      DriverManager.registerDriver((Driver)new OracleDriver());
      String cadena = "jdbc:oracle:thin:@//10.31.33.35:1521/SAP";
      this.m_conn = DriverManager.getConnection(cadena, "SAP", "W3f9Z5oPxw7H");
      this.m_conn.setAutoCommit(false);
      System.out.println("Conexion Desarrollo Correcta");
    } catch (SQLException e) {
      System.out.println("ERROR DE CONEXION DESA: " + e.getMessage());
      this.m_session.setAttribute("ERROR", e.getMessage());
      this.m_session.setAttribute("requestedPage", e.getMessage());
    } 
  }
}
