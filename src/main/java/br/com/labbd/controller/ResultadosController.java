package br.com.labbd.controller;

import br.com.labbd.model.Resultado;
import br.com.labbd.persistence.JogoDao;
import br.com.labbd.persistence.ResultadoDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;

import java.sql.SQLException;
import java.util.List;

@Controller
public class ResultadosController {

    @Autowired
    private ResultadoDao dao;

    @GetMapping("resultados/geral")
    public ModelAndView getResultadosGeral(Model model) throws SQLException, ClassNotFoundException {
        ModelAndView modelAndView = new ModelAndView();
        List<Resultado> resultadoList = dao.procurarResultadosGerais();
        modelAndView.addObject("times",resultadoList);
        modelAndView.addObject("rebaixados",dao.getRebaixados());
        modelAndView.setViewName("resultadoge");
        return modelAndView;
    }

    @GetMapping("resultados/grupo")
    public String getResultadosGrupo(Model model) throws SQLException, ClassNotFoundException {
        model.addAttribute("resultadosDosGrupos", dao.procurarResultadosPorGrupo());
        model.addAttribute("rebaixados", dao.getRebaixados());
        return "resultadogr";
    }
}
