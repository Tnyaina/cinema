package cinema.controller;

import cinema.produit.Produit;
import cinema.produit.ProduitService;
import cinema.produit.VenteProduitService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/produits")
@RequiredArgsConstructor
public class ProduitController {

    private final ProduitService produitService;
    private final VenteProduitService venteProduitService;

    @GetMapping
    public String listeProduits(Model model) {
        model.addAttribute("page", "produits/liste-produits");
        model.addAttribute("pageTitle", "Gestion des Produits");
        model.addAttribute("pageActive", "produits");
        model.addAttribute("produits", produitService.obtenirTousProduits());
        return "layout";
    }

    @GetMapping("/vente")
    public String venteProduits(Model model, HttpSession session) {
        model.addAttribute("page", "produits/vente-produits");
        model.addAttribute("pageTitle", "Vente de Produits");
        model.addAttribute("pageActive", "vente-produits");
        model.addAttribute("produits", produitService.obtenirTousProduits());

        // Récupérer la liste des ventes depuis la session
        @SuppressWarnings("unchecked")
        List<VenteItem> ventes = (List<VenteItem>) session.getAttribute("ventes");
        if (ventes == null) {
            ventes = new ArrayList<>();
        }
        model.addAttribute("ventes", ventes);

        return "layout";
    }

    @PostMapping("/vente/ajouter")
    public String ajouterProduitVente(@RequestParam Long produitId,
                                    @RequestParam Integer quantite,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {

        @SuppressWarnings("unchecked")
        List<VenteItem> ventes = (List<VenteItem>) session.getAttribute("ventes");
        if (ventes == null) {
            ventes = new ArrayList<>();
        }

        try {
            Produit produit = produitService.obtenirProduitById(produitId);
            VenteItem item = new VenteItem(produit, quantite);
            ventes.add(item);

            session.setAttribute("ventes", ventes);
            redirectAttributes.addFlashAttribute("success", "Produit ajouté au panier");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'ajout du produit: " + e.getMessage());
        }

        return "redirect:/produits/vente";
    }

    @PostMapping("/vente/confirmer")
    public String confirmerVente(HttpSession session,
                               RedirectAttributes redirectAttributes) {

        @SuppressWarnings("unchecked")
        List<VenteItem> ventes = (List<VenteItem>) session.getAttribute("ventes");

        if (ventes == null || ventes.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Aucun produit dans le panier");
            return "redirect:/produits/vente";
        }

        try {
            for (VenteItem item : ventes) {
                venteProduitService.enregistrerVente(item.getProduit().getId(), item.getQuantite());
            }

            redirectAttributes.addFlashAttribute("success", "Vente enregistrée avec succès");
            // Vider le panier après confirmation
            session.removeAttribute("ventes");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement de la vente: " + e.getMessage());
        }

        return "redirect:/produits/vente";
    }

    @PostMapping("/vente/annuler")
    public String annulerVente(HttpSession session,
                             RedirectAttributes redirectAttributes) {
        session.removeAttribute("ventes");
        redirectAttributes.addFlashAttribute("info", "Panier vidé");
        return "redirect:/produits/vente";
    }

    // Classe interne pour représenter un item dans le panier
    public static class VenteItem {
        private Produit produit;
        private Integer quantite;

        public VenteItem() {}

        public VenteItem(Produit produit, Integer quantite) {
            this.produit = produit;
            this.quantite = quantite;
        }

        public Produit getProduit() {
            return produit;
        }

        public void setProduit(Produit produit) {
            this.produit = produit;
        }

        public Integer getQuantite() {
            return quantite;
        }

        public void setQuantite(Integer quantite) {
            this.quantite = quantite;
        }
    }
}