package cinema.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("page", "index");
        model.addAttribute("pageTitle", "Accueil");
        return "layout";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("page", "dashboard");
        model.addAttribute("pageTitle", "Tableau de bord");
        return "layout";
    }
}

