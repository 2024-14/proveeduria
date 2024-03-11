package com.DAO;

public class RespuestaSap
{
    private String cadenaRespuestaSap;
    private int numRespuestaSap;
    private String cadenaEnviadaSap;
    private String contrato;
    
    public RespuestaSap(final String cadenaRespuestaSap, final int numRespuestaSap, final String cadenaEnviadaSap, final String contrato) {
        this.cadenaRespuestaSap = cadenaRespuestaSap;
        this.numRespuestaSap = numRespuestaSap;
        this.cadenaEnviadaSap = cadenaEnviadaSap;
        this.contrato = contrato;
    }
    
    public String getCadenaRespuestaSap() {
        return this.cadenaRespuestaSap;
    }
    
    public void setCadenaRespuestaSap(final String cadenaRespuestaSap) {
        this.cadenaRespuestaSap = cadenaRespuestaSap;
    }
    
    public int getNumRespuestaSap() {
        return this.numRespuestaSap;
    }
    
    public void setNumRespuestaSap(final int numRespuestaSap) {
        this.numRespuestaSap = numRespuestaSap;
    }
    
    public String getCadenaEnviadaSap() {
        return this.cadenaEnviadaSap;
    }
    
    public void setCadenaEnviadaSap(final String cadenaEnviadaSap) {
        this.cadenaEnviadaSap = cadenaEnviadaSap;
    }
    
    public String getContrato() {
        return this.contrato;
    }
    
    public void setContrato(final String contrato) {
        this.contrato = contrato;
    }
}