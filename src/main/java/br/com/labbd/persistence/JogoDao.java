package br.com.labbd.persistence;

import br.com.labbd.model.Jogo;
import br.com.labbd.model.Quartas;
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
public class JogoDao {
	
	GenericDao gDao;
	TimeDao tDao;
	
	public JogoDao() {
		this.gDao = new GenericDao();
		this.tDao = new TimeDao(this.gDao);
	}

	public List<Jogo> gerarJogos() throws SQLException, ClassNotFoundException{
		List<Jogo> jogos = new ArrayList<>();
		Connection c = gDao.getConnection();
		PreparedStatement ps = c.prepareStatement("SELECT * FROM Jogos WHERE DiaDoJogo IS NOT NULL");
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			Jogo jogo = new Jogo();
			jogo.setTimeA(tDao.getTime(rs.getInt("CodigoTimeA")));
			jogo.setTimeB(tDao.getTime(rs.getInt("CodigoTimeB")));
			jogo.setGolsTimeA(rs.getInt("GolsTimeA"));
			jogo.setGolsTimeB(rs.getInt("GolsTimeB"));
			jogo.setDiaDoJogo(rs.getString("DiaDoJogo"));
			jogos.add(jogo);
		}
		rs.close();
		ps.close();
		c.close();
		return jogos;
	}
	
	public void randomizarJogos() throws SQLException, ClassNotFoundException{
		Connection c = gDao.getConnection();
		CallableStatement cs = c.prepareCall("CALL pr_g ");
		cs.execute();
		cs.close();
		c.close();
	}
	
	public List<Jogo> pesquisarJogo(String date) throws SQLException, ClassNotFoundException{
		List<Jogo> jogos = new ArrayList<>();
		Connection c = gDao.getConnection();
		PreparedStatement ps = c.prepareStatement("SELECT top 4 * "
				+ "FROM Jogos "
				+ "WHERE DiaDoJogo = ?");
		ps.setString(1, date);
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			Jogo jogo = new Jogo();
			jogo.setCodigoJogo(rs.getInt("CodigoJogo"));
			jogo.setTimeA(tDao.getTime(rs.getInt("CodigoTimeA")));
			jogo.setTimeB(tDao.getTime(rs.getInt("CodigoTimeB")));
			jogo.setGolsTimeA(rs.getInt("GolsTimeA"));
			jogo.setGolsTimeB(rs.getInt("GolsTimeB"));
			jogo.setDiaDoJogo(rs.getString("DiaDoJogo"));
			jogos.add(jogo);
		}
		rs.close();
		ps.close();
		c.close();
		return jogos;
	}

	public List<Quartas> quartas() throws SQLException, ClassNotFoundException {
		List<Quartas> jogos = new ArrayList<>();
		Connection c = gDao.getConnection();
		PreparedStatement statement = c.prepareStatement("SELECT * FROM fn_quartas()");
		ResultSet set = statement.executeQuery();
		Quartas quartas = new Quartas();

		Quartas quartas1 = new Quartas();
		Quartas quartas2 = new Quartas();
		Quartas quartas3 = new Quartas();
		quartas.setNomeGrupo("A");
		quartas1.setNomeGrupo("B");
		quartas2.setNomeGrupo("C");
		quartas3.setNomeGrupo("D");
		while (set.next()){
			switch (set.getString("nome_grupo")){
				case "A":
					quartas.getNome().add(set.getString("nome_time"));
					break;
				case "B":
					quartas1.getNome().add(set.getString("nome_time"));
					break;
				case "C":
					quartas2.getNome().add(set.getString("nome_time"));
					break;
				case "D":
					quartas3.getNome().add(set.getString("nome_time"));
					break;
			}
		}
		statement.close();
		set.close();
		c.close();
		jogos.addAll(Arrays.asList(quartas, quartas1, quartas2, quartas3));
		return jogos;
	}
	public void updateJogo(Integer golsA, Integer golsB, Integer codigo) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		PreparedStatement statement = c.prepareStatement("UPDATE Jogos SET GolsTimeA=?, GolsTimeB=? WHERE CodigoJogo=?");
		statement.setInt(1,golsA);
		statement.setInt(2,golsB);
		statement.setInt(3,codigo);
		statement.executeUpdate();
	}
}
