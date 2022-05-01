package br.com.labbd.model;

public class JogoUpdateGolsDto {
    private Integer codigo;
    private Integer golsA;
    private Integer golsB;

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public Integer getGolsA() {
        return golsA;
    }

    public void setGolsA(Integer golsA) {
        this.golsA = golsA;
    }

    public Integer getGolsB() {
        return golsB;
    }

    public void setGolsB(Integer golsB) {
        this.golsB = golsB;
    }
}
