package br.com.labbd.model;

import java.io.Serializable;

public class Jogo implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private int codigoJogo;
	private Time timeA;
	private Time timeB;
	private int golsTimeA;
	private int golsTimeB;
	private String diaDoJogo;
	
	public Jogo() {}

	public Jogo(int codigoJogo,Time timeA, Time timeB, int golsTimeA, int golsTimeB, String diaDoJogo) {
		super();
		this.codigoJogo = codigoJogo;
		this.timeA = timeA;
		this.timeB = timeB;
		this.golsTimeA = golsTimeA;
		this.golsTimeB = golsTimeB;
		this.diaDoJogo = diaDoJogo;
	}

	public int getCodigoJogo() {
		return codigoJogo;
	}

	public void setCodigoJogo(int codigoJogo) {
		this.codigoJogo = codigoJogo;
	}

	public int getGolsTimeA() {
		return golsTimeA;
	}

	public void setGolsTimeA(int golsTimeA) {
		this.golsTimeA = golsTimeA;
	}

	public int getGolsTimeB() {
		return golsTimeB;
	}

	public void setGolsTimeB(int golsTimeB) {
		this.golsTimeB = golsTimeB;
	}

	public String getDiaDoJogo() {
		return diaDoJogo;
	}

	public void setDiaDoJogo(String diaDoJogo) {
		this.diaDoJogo = diaDoJogo;
	}

	public Time getTimeA() {
		return timeA;
	}

	public void setTimeA(Time timeA) {
		this.timeA = timeA;
	}

	public Time getTimeB() {
		return timeB;
	}

	public void setTimeB(Time timeB) {
		this.timeB = timeB;
	}

	@Override
	public String toString() {
		return timeA.getNome() + " X " + timeB.getNome();
	}

	
	
}
