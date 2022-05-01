package br.com.labbd.persistence;

import br.com.labbd.model.Resultado;
import br.com.labbd.model.ResultadoGrupo;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@Repository
public class ResultadoDao {
    private Connection connection;

    public ResultadoDao(Connection connection) {
        this.connection = connection;
    }

    public ResultadoDao() {
        GenericDao genericDao = new GenericDao();
        try {
            this.connection = genericDao.getConnection();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private List<Resultado> mapearLinhasEmResultados(ResultSet linhas) {
        var resultados = new ArrayList<Resultado>();
        try {
            while (linhas.next()) {
                resultados.add(
                        new Resultado(
                                linhas.getString("nome_time"),
                                linhas.getInt("num_jogos_disputados"),
                                linhas.getInt("vitorias"),
                                linhas.getInt("derrotas"),
                                linhas.getInt("empates"),
                                linhas.getInt("gols_marcados"),
                                linhas.getInt("gols_sofridos"),
                                linhas.getInt("saldo_gols"),
                                linhas.getInt("pontos")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultados;
    }

    public List<Resultado> procurarResultadosGerais() {
        var sql = "SELECT * FROM dbo.fn_tabela_geral() ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC";
        try (var stmt = connection.prepareStatement(sql)) {
            return mapearLinhasEmResultados(stmt.executeQuery());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>();
    }

    public List<Resultado> procurarResultados(String grupo) {
        var sql = "SELECT * FROM dbo.fn_tabela_grupos(?) ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC";
        try (var stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, grupo);
            return mapearLinhasEmResultados(stmt.executeQuery());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    public List<ResultadoGrupo> procurarResultadosPorGrupo() {
        Function<String, ResultadoGrupo> paraResultados = g -> {
            return new ResultadoGrupo(g, this.procurarResultados(g));
        };

        return List
                .of("A", "B", "C", "D")
                .stream()
                .map(paraResultados)
                .collect(Collectors.toList());
    }

    public List<String> getRebaixados(){
        var resultados = procurarResultadosGerais();
        var size = resultados.size();
        return resultados
                .subList(size - 2, size)
                .stream()
                .map(Resultado::getTime)
                .collect(Collectors.toList());
    }
}
