package cinema.publicite.video;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import cinema.publicite.societe.SocieteRepository;

@Controller
@RequestMapping("/videos-publicitaires")
@RequiredArgsConstructor
public class VideoPublicitaireController {

    private final VideoPublicitaireRepository videoRepository;
    private final SocieteRepository societeRepository;

    @GetMapping
    public String list(@RequestParam(required = false) Long societeId, Model model) {
        model.addAttribute("page", "videos-publicitaires");
        model.addAttribute("pageTitle", "Vidéos Publicitaires");
        model.addAttribute("pageActive", "videos-publicitaires");
        
        if (societeId != null) {
            model.addAttribute("videos", videoRepository.findBySocieteId(societeId));
            model.addAttribute("societe", societeRepository.findById(societeId).orElse(null));
        } else {
            model.addAttribute("videos", videoRepository.findAll());
        }
        
        model.addAttribute("societes", societeRepository.findAll());
        return "layout";
    }

    @PostMapping
    public String create(@RequestParam Long societeId, 
                        @RequestParam String libelle, 
                        @RequestParam Integer duree) {
        return societeRepository.findById(societeId).map(societe -> {
            videoRepository.save(new VideoPublicitaire(societe, libelle, duree));
            return "redirect:/videos-publicitaires?societeId=" + societeId;
        }).orElse("redirect:/videos-publicitaires");
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        videoRepository.findById(id).ifPresent(video -> {
            Long societeId = video.getSociete().getId();
            videoRepository.deleteById(id);
        });
        return "redirect:/videos-publicitaires";
    }
}
