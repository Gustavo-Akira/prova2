package br.com.labbd.model;

import java.util.ArrayList;
import java.util.List;

public class Grupo {
	
	private String nome;
	private List<Time> times = new ArrayList<>();
	private Long id;
	
	public Grupo(Time time) {
		this.times.add(time);
	}
	
	public Grupo() {}

	public List<Time> getTimes() {
		return times;
	}

	public void setTimes(List<Time> times) {
		this.times = times;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public String toString() {
		return "Grupo [times=" + times + ", id=" + id + "]";
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}
	
	

}
