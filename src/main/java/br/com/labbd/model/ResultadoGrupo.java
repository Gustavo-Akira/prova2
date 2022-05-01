package br.com.labbd.model;

import java.util.List;

public class ResultadoGrupo {
    private final String grupo;
    private final List<Resultado> resultados;

    public ResultadoGrupo(final String grupo, final List<Resultado> resultados) {
        this.grupo = grupo;
        this.resultados = resultados;
    }

    public String getGrupo() {
        return grupo;
    }

    public List<Resultado> getResultados() {
        return resultados;
    }
}
