package br.com.labbd.controller;

import br.com.labbd.model.Jogo;
import br.com.labbd.model.JogoUpdateGolsDto;
import br.com.labbd.model.Pesquisa;
import br.com.labbd.persistence.JogoDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class JogoController {

    private final JogoDao jogoDao;

    @Autowired
    public JogoController(JogoDao dao){
        jogoDao = dao;
    }

    @GetMapping("jogos")
    public String getJogos(Model model) throws SQLException, ClassNotFoundException {
        model.addAttribute("jogos",jogoDao.gerarJogos());
        return "jogos";
    }

    @GetMapping("jogos/pesquisa")
    public String getPesquisa(Model model) throws SQLException, ClassNotFoundException {
        model.addAttribute("jogos",new ArrayList<Jogo>());
        return "pesquisa";
    }

    @PostMapping("jogos/pesquisa")
    public String getJogosPorPesquisa(Model model, @ModelAttribute("pesquisa") String pesquisa) throws SQLException, ClassNotFoundException {
        model.addAttribute("jogos",jogoDao.pesquisarJogo(pesquisa));
        return "pesquisa";
    }

    @GetMapping("jogos/quartas")
    public String getQuartas(Model model) throws SQLException, ClassNotFoundException {
        model.addAttribute("jogos",jogoDao.quartas());
        return "quartas";
    }

    @PostMapping("jogos/update")
    public String updateJogo(@RequestParam Map<String, String> allParams, ModelMap map) throws SQLException, ClassNotFoundException {
        List<JogoUpdateGolsDto> dtos = new ArrayList<>();
        for (String s :
                allParams.keySet()) {
            String[] array = s.split("-");
           if(!dtos.stream().anyMatch(x->x.getCodigo().toString().equals(array[1]))){
               JogoUpdateGolsDto dto = new JogoUpdateGolsDto();
               dto.setCodigo(Integer.parseInt(array[1]));
               dto.setGolsA(Integer.parseInt(allParams.get(s)));
               dtos.add(dto);
           }else{
               JogoUpdateGolsDto dto = dtos.stream().filter(x->x.getCodigo().toString().equals(array[1])).findFirst().get();
               dto.setGolsB(Integer.parseInt(allParams.get(s)));
               dtos = dtos.stream().dropWhile(x->x.getCodigo().toString().equals(array[1])).collect(Collectors.toList());
               dtos.add(dto);
           }

        }
        for (JogoUpdateGolsDto dto:
             dtos) {
            jogoDao.updateJogo(dto.getGolsA(),dto.getGolsB(), dto.getCodigo());
        }
        return "pesquisa";
    }
}
