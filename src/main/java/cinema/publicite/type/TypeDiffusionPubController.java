package cinema.publicite.type;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/types-diffusion")
@RequiredArgsConstructor
public class TypeDiffusionPubController {

    private final TypeDiffusionPubRepository typeRepository;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("page", "types-diffusion");
        model.addAttribute("pageTitle", "Types de Diffusion");
        model.addAttribute("types", typeRepository.findAll());
        model.addAttribute("pageActive", "types-diffusion");
        return "layout";
    }

    @PostMapping
    public String create(@RequestParam String libelle, @RequestParam(required = false) String description) {
        typeRepository.save(new TypeDiffusionPub(libelle, description));
        return "redirect:/types-diffusion";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        typeRepository.deleteById(id);
        return "redirect:/types-diffusion";
    }
}
