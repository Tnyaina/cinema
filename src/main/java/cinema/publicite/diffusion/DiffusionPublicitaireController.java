package cinema.publicite.diffusion;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.publicite.video.VideoPublicitaireRepository;
import cinema.publicite.type.TypeDiffusionPubRepository;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
@RequestMapping("/diffusions-publicitaires")
@RequiredArgsConstructor
public class DiffusionPublicitaireController {

    private final DiffusionPublicitaireRepository diffusionRepository;
    private final VideoPublicitaireRepository videoRepository;
    private final TypeDiffusionPubRepository typeRepository;

    @GetMapping
    public String list(@RequestParam(required = false) Long seanceId, Model model) {
        model.addAttribute("page", "diffusions-publicitaires");
        model.addAttribute("pageTitle", "Diffusions Publicitaires");
        model.addAttribute("pageActive", "diffusions-publicitaires");
        
        if (seanceId != null) {
            model.addAttribute("diffusions", diffusionRepository.findBySeanceId(seanceId));
        } else {
            model.addAttribute("diffusions", diffusionRepository.findAll());
        }
        
        model.addAttribute("videos", videoRepository.findAll());
        model.addAttribute("types", typeRepository.findAll());
        return "layout";
    }

    @PostMapping
    public String create(@RequestParam Long videoId, 
                        @RequestParam Long seanceId,
                        @RequestParam Long typeId,
                        @RequestParam Double tarif,
                        @RequestParam String dateDiffusion) {
        try {
            LocalDateTime dateTime = LocalDateTime.parse(dateDiffusion, DateTimeFormatter.ISO_DATE_TIME);
            
            return videoRepository.findById(videoId).flatMap(video -> 
                typeRepository.findById(typeId).map(type -> {
                    diffusionRepository.save(new DiffusionPublicitaire(video, seanceId, type, tarif, dateTime));
                    return "redirect:/diffusions-publicitaires";
                })
            ).orElse("redirect:/diffusions-publicitaires");
        } catch (Exception e) {
            return "redirect:/diffusions-publicitaires";
        }
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        diffusionRepository.deleteById(id);
        return "redirect:/diffusions-publicitaires";
    }
}
