package com.conexion;

import java.io.InputStream;
import java.io.FileInputStream;
import java.net.URL;
import java.util.Properties;

public class PropertiesPortal
{
    private String ruta;
    public Properties properties;
    
    public PropertiesPortal() {
        this.ruta = null;
        this.properties = null;
    }
    
    public void cargaResources() {
        try {
            final URL ulr = this.getClass().getClassLoader().getResource("/resource/");
            this.ruta = ulr.getPath();
        }
        catch (Throwable ex) {
            ex.printStackTrace();
        }
    }
    
    private void cargaProperties() {
        try {
            final FileInputStream f = new FileInputStream(String.valueOf(this.ruta) + "portal.properties");
            (this.properties = new Properties()).load(f);
            f.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}