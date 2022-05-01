package br.com.labbd.persistence;

import br.com.labbd.model.Grupo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Repository
public class GrupoDao {

	GenericDao gDao;
	TimeDao tDao;

	@Autowired
	public GrupoDao(GenericDao gDao, TimeDao tDao) {
		this.tDao = tDao;
		this.gDao = gDao;
	}

	public List<Grupo> gerarGrupos()  throws SQLException, ClassNotFoundException{
		List<Grupo> grupos = new ArrayList<>();
		Connection c = gDao.getConnection();
		PreparedStatement ps = c.prepareStatement("SELECT * "
				+ "FROM Grupos");
		ResultSet rs = ps.executeQuery();
		Grupo g1 = new Grupo();
		Grupo g2 = new Grupo();
		Grupo g3 = new Grupo();
		Grupo g4 = new Grupo();
		g1.setNome("A");
		g2.setNome("B");
		g3.setNome("C");
		g4.setNome("D");
		
		while(rs.next()) {
			switch(rs.getString("Grupo")) {
			case "A" :
				g1.getTimes().add(tDao.getTime(rs.getInt("CodigoTime")));
				break;
			case "B":
				g2.getTimes().add(tDao.getTime(rs.getInt("CodigoTime")));
				break;
			case "C": 
				g3.getTimes().add(tDao.getTime(rs.getInt("CodigoTime")));
				break;
			case "D":
				g4.getTimes().add(tDao.getTime(rs.getInt("CodigoTime")));
			}
		}
		grupos.addAll(Arrays.asList(g1, g2, g3, g4));
		return grupos;
	}

	public void randomizarGrupos() throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();

		CallableStatement cs = c.prepareCall("CALL gerar_grupos");
		cs.execute();
		cs.close();
		c.close();
	}

}
