package br.com.labbd.model;

public class Resultado {
    private final String time;
    private final int jogosDisputados;
    private final int vitorias;
    private final int derrotas;
    private final int empates;
    private final int golsMarcados;
    private final int golsSofridos;
    private final int saldoDeGols;
    private final int pontos;

    public Resultado(final String time, final int jogosDisputados, final int vitorias, final int derrotas,
                     final int empates, final int golsMarcados,
                     final int golsSofridos, final int saldoDeGols, final int pontos) {
        this.time = time;
        this.jogosDisputados = jogosDisputados;
        this.vitorias = vitorias;
        this.derrotas = derrotas;
        this.empates = empates;
        this.golsMarcados = golsMarcados;
        this.golsSofridos = golsSofridos;
        this.saldoDeGols = saldoDeGols;
        this.pontos = pontos;
    }

    public String getTime() {
        return time;
    }

    public int getJogosDisputados() {
        return jogosDisputados;
    }

    public int getVitorias() {
        return vitorias;
    }

    public int getDerrotas() {
        return derrotas;
    }

    public int getEmpates() {
        return empates;
    }

    public int getGolsMarcados() {
        return golsMarcados;
    }

    public int getGolsSofridos() {
        return golsSofridos;
    }

    public int getSaldoDeGols() {
        return saldoDeGols;
    }

    public int getPontos() {
        return pontos;
    }
}
