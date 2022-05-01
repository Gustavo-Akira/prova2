package br.com.labbd.model;

import java.io.Serializable;
import java.util.Objects;

public class Time implements Serializable{
	
	private static final Long serialVersionUID = 1L;
	private int codigoTime;
	private String nome;
	private String cidade;
	private String estadio;

	public Time(int codigoTime, String nome, String cidade, String estadio) {
		this.codigoTime = codigoTime;
		this.nome = nome;
		this.cidade = cidade;
		this.estadio = estadio;
	}
	
	public Time() {}

	public int getCodigoTime() {
		return codigoTime;
	}

	public void setCodigoTime(int codigoTime) {
		this.codigoTime = codigoTime;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getCidade() {
		return cidade;
	}

	public void setCidade(String cidade) {
		this.cidade = cidade;
	}

	public String getEstadio() {
		return estadio;
	}

	public void setEstadio(String estadio) {
		this.estadio = estadio;
	}

	@Override
	public int hashCode() {
		return Objects.hash(cidade, codigoTime, estadio, nome);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Time other = (Time) obj;
		return Objects.equals(cidade, other.cidade) && codigoTime == other.codigoTime
				&& Objects.equals(estadio, other.estadio) && Objects.equals(nome, other.nome);
	}

	@Override
	public String toString() {
		return this.getNome();
	}

	

}
