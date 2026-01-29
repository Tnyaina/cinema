<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title mb-0">
                        <i class="fas fa-shopping-cart"></i> Vente de Produits
                    </h4>
                </div>
                <div class="card-body">
                    <!-- Messages d'alerte -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty info}">
                        <div class="alert alert-info alert-dismissible fade show" role="alert">
                            <i class="fas fa-info-circle"></i> ${info}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="row">
                        <!-- Sélection de produit -->
                        <div class="col-md-4">
                            <div class="card border-primary">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-plus-circle"></i> Ajouter un produit
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form action="<c:url value='/produits/vente/ajouter'/>" method="post">
                                        <div class="mb-3">
                                            <label for="produitId" class="form-label">Produit</label>
                                            <select class="form-select" id="produitId" name="produitId" required>
                                                <option value="">Choisir un produit...</option>
                                                <c:forEach var="produit" items="${produits}">
                                                    <option value="${produit.id}" data-prix="0">
                                                        ${produit.nom}
                                                        <c:if test="${not empty produit.description}">
                                                            - ${produit.description}
                                                        </c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="quantite" class="form-label">Quantité</label>
                                            <input type="number" class="form-control" id="quantite" name="quantite"
                                                   min="1" value="1" required>
                                        </div>
                                        <div class="mb-3">
                                            <div class="row">
                                                <div class="col-6">
                                                    <label class="form-label">Prix unitaire</label>
                                                    <input type="text" class="form-control" id="prixUnitaire" readonly>
                                                </div>
                                                <div class="col-6">
                                                    <label class="form-label">Total</label>
                                                    <input type="text" class="form-control" id="totalProduit" readonly>
                                                </div>
                                            </div>
                                        </div>
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="fas fa-cart-plus"></i> Ajouter au panier
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Panier -->
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-shopping-basket"></i> Panier
                                        <span class="badge bg-primary ms-2" id="nbArticles">
                                            <c:out value="${ventes.size()}" default="0"/>
                                        </span>
                                    </h5>
                                    <div>
                                        <form action="<c:url value='/produits/vente/annuler'/>" method="post" class="d-inline">
                                            <button type="submit" class="btn btn-outline-danger btn-sm">
                                                <i class="fas fa-trash"></i> Vider
                                            </button>
                                        </form>
                                        <form action="<c:url value='/produits/vente/confirmer'/>" method="post" class="d-inline ms-2">
                                            <button type="submit" class="btn btn-success btn-sm"
                                                    <c:if test="${empty ventes}">disabled</c:if>>
                                                <i class="fas fa-check"></i> Confirmer la vente
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty ventes}">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Produit</th>
                                                            <th class="text-center">Quantité</th>
                                                            <th class="text-end">Prix unitaire</th>
                                                            <th class="text-end">Total</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:set var="totalGeneral" value="0"/>
                                                        <c:forEach var="vente" items="${ventes}">
                                                            <tr>
                                                                <td>
                                                                    <strong>${vente.produit.nom}</strong>
                                                                    <c:if test="${not empty vente.produit.description}">
                                                                        <br><small class="text-muted">${vente.produit.description}</small>
                                                                    </c:if>
                                                                </td>
                                                                <td class="text-center">${vente.quantite}</td>
                                                                <td class="text-end">
                                                                    <fmt:formatNumber value="10000" pattern="#,##0"/> Ar
                                                                </td>
                                                                <td class="text-end">
                                                                    <fmt:formatNumber value="${vente.quantite * 10000}" pattern="#,##0"/> Ar
                                                                </td>
                                                            </tr>
                                                            <c:set var="totalGeneral" value="${totalGeneral + (vente.quantite * 10000)}"/>
                                                        </c:forEach>
                                                    </tbody>
                                                    <tfoot class="table-light">
                                                        <tr>
                                                            <th colspan="3" class="text-end">Total général :</th>
                                                            <th class="text-end">
                                                                <strong>
                                                                    <fmt:formatNumber value="${totalGeneral}" pattern="#,##0"/> Ar
                                                                </strong>
                                                            </th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                                                <h5 class="text-muted">Panier vide</h5>
                                                <p class="text-muted">Ajoutez des produits pour commencer une vente</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Calcul automatique du total lors de la sélection du produit
document.getElementById('produitId').addEventListener('change', function() {
    const quantite = document.getElementById('quantite').value;
    const prixUnitaire = 10000; // Pour l'instant, prix fixe pour le pop corn
    const total = quantite * prixUnitaire;

    document.getElementById('prixUnitaire').value = prixUnitaire.toLocaleString() + ' Ar';
    document.getElementById('totalProduit').value = total.toLocaleString() + ' Ar';
});

document.getElementById('quantite').addEventListener('input', function() {
    const quantite = this.value;
    const prixUnitaire = 10000; // Pour l'instant, prix fixe pour le pop corn
    const total = quantite * prixUnitaire;

    document.getElementById('prixUnitaire').value = prixUnitaire.toLocaleString() + ' Ar';
    document.getElementById('totalProduit').value = total.toLocaleString() + ' Ar';
});

// Initialisation au chargement
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('produitId').dispatchEvent(new Event('change'));
});
</script>