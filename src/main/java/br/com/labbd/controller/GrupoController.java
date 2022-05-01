package br.com.labbd.controller;

import br.com.labbd.persistence.GrupoDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.sql.SQLException;

@Controller
public class GrupoController {

    private final GrupoDao dao;

    @Autowired
    public GrupoController(GrupoDao grupoDao){
        this.dao = grupoDao;
    }

    @GetMapping("grupos")
    public String getGrupos(Model model) throws SQLException, ClassNotFoundException {
        model.addAttribute("grupos",dao.gerarGrupos());
        return "index";
    }

    @PostMapping("/grupos")
    public ModelAndView gerarGrupos() throws SQLException, ClassNotFoundException {
        ModelAndView modelAndView = new ModelAndView();
        dao.randomizarGrupos();
        modelAndView.setViewName("index.jsp");
        modelAndView.addObject("grupos",dao.gerarGrupos());
        return modelAndView;
    }
}
