package br.com.labbd.model;

import java.util.ArrayList;
import java.util.List;

public class Quartas {
    private List<String> nome = new ArrayList<>();
    private String nomeGrupo;

    public List<String> getNome() {
        return nome;
    }

    public void setNome(List<String> nome) {
        this.nome = nome;
    }

    public String getNomeGrupo() {
        return nomeGrupo;
    }

    public void setNomeGrupo(String nomeGrupo) {
        this.nomeGrupo = nomeGrupo;
    }
}
