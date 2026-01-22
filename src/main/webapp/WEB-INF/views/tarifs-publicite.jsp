<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="main-content">
    <div class="page-header mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-0">Tarifs Publicité</h1>
                <p class="text-muted small">Gestion des tarifs publicitaires</p>
            </div>
            <div class="btn-group" role="group">
                <button class="btn btn-primary btn-lg" onclick="openDefautModal()">
                    <i class="fas fa-plus me-2"></i> Tarif par défaut
                </button>
                <button class="btn btn-primary btn-lg" onclick="openPersonnaliseModal()">
                    <i class="fas fa-plus me-2"></i> Tarif personnalisé
                </button>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Type Diffusion</th>
                            <c:if test="${typeFiltre == 'personnalise'}">
                                <th>Société</th>
                            </c:if>
                            <th>Prix (€)</th>
                            <th>Date Début</th>
                            <th class="text-end pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${typeFiltre == 'personnalise'}">
                                <c:forEach var="tarif" items="${tarifPersonnalises}">
                                    <tr>
                                        <td class="ps-4">
                                            <i class="fas fa-tag text-warning me-2"></i>
                                            <span class="fw-600">${tarif.typeDiffusion.libelle}</span>
                                        </td>
                                        <td>${tarif.societe.libelle}</td>
                                        <td><strong class="text-success">${tarif.prixUnitaire}€</strong></td>
                                        <td><small class="text-muted">${tarif.dateDebut}</small></td>
                                        <td class="text-end pe-4">
                                            <form method="post" action="<c:url value='/tarifs-publicite/${tarif.id}/delete'/>" style="display: inline;">
                                                <input type="hidden" name="type" value="${typeFiltre}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Êtes-vous sûr ?')">
                                                    <i class="fas fa-trash"></i> Supprimer
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="tarif" items="${tarifDefauts}">
                                    <tr>
                                        <td class="ps-4">
                                            <i class="fas fa-tag text-info me-2"></i>
                                            <span class="fw-600">${tarif.typeDiffusion.libelle}</span>
                                        </td>
                                        <td><strong class="text-success">${tarif.prixUnitaire}€</strong></td>
                                        <td><small class="text-muted">${tarif.dateDebut}</small></td>
                                        <td class="text-end pe-4">
                                            <form method="post" action="<c:url value='/tarifs-publicite/${tarif.id}/delete'/>" style="display: inline;">
                                                <input type="hidden" name="type" value="${typeFiltre}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Êtes-vous sûr ?')">
                                                    <i class="fas fa-trash"></i> Supprimer
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Tarif Défaut -->
<div class="modal fade" id="defautModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-info text-white border-0">
                <h5 class="modal-title fw-bold">
                    <i class="fas fa-plus me-2"></i> Ajouter un Tarif par Défaut
                </h5>
                <button type="button" class="btn-close btn-close-white" onclick="closeDefautModal()"></button>
            </div>
            <form method="post" action="<c:url value='/tarifs-publicite/defaut'/>">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="typeId" class="form-label fw-600">Type Diffusion :</label>
                        <select id="typeId" name="typeId" class="form-select form-select-lg" required>
                            <option value="">Sélectionner un type</option>
                            <c:forEach var="type" items="${types}">
                                <option value="${type.id}">${type.libelle}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="prix" class="form-label fw-600">Prix (€) :</label>
                        <input type="number" id="prix" name="prix" step="0.01" class="form-control form-control-lg" placeholder="Montant du tarif" required>
                    </div>
                    <div class="mb-3">
                        <label for="dateDebut" class="form-label fw-600">Date Début :</label>
                        <input type="date" id="dateDebut" name="dateDebut" class="form-control form-control-lg" required>
                    </div>
                </div>
                <div class="modal-footer border-0 bg-light">
                    <button type="button" class="btn btn-secondary" onclick="closeDefautModal()">Annuler</button>
                    <button type="submit" class="btn btn-info">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Tarif Personnalisé -->
<div class="modal fade" id="personnaliseModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-warning text-white border-0">
                <h5 class="modal-title fw-bold">
                    <i class="fas fa-plus me-2"></i> Ajouter un Tarif Personnalisé
                </h5>
                <button type="button" class="btn-close btn-close-white" onclick="closePersonnaliseModal()"></button>
            </div>
            <form method="post" action="<c:url value='/tarifs-publicite/personnalise'/>">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="societeId" class="form-label fw-600">Société :</label>
                        <select id="societeId" name="societeId" class="form-select form-select-lg" required>
                            <option value="">Sélectionner une société</option>
                            <c:forEach var="societe" items="${societes}">
                                <option value="${societe.id}">${societe.libelle}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="typeId2" class="form-label fw-600">Type Diffusion :</label>
                        <select id="typeId2" name="typeId" class="form-select form-select-lg" required>
                            <option value="">Sélectionner un type</option>
                            <c:forEach var="type" items="${types}">
                                <option value="${type.id}">${type.libelle}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="prix2" class="form-label fw-600">Prix (€) :</label>
                        <input type="number" id="prix2" name="prix" step="0.01" class="form-control form-control-lg" placeholder="Montant du tarif" required>
                    </div>
                    <div class="mb-3">
                        <label for="dateDebut2" class="form-label fw-600">Date Début :</label>
                        <input type="date" id="dateDebut2" name="dateDebut" class="form-control form-control-lg" required>
                    </div>
                </div>
                <div class="modal-footer border-0 bg-light">
                    <button type="button" class="btn btn-secondary" onclick="closePersonnaliseModal()">Annuler</button>
                    <button type="submit" class="btn btn-warning">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .fw-600 { font-weight: 600; }
    .page-header { padding-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; }
    .table-hover tbody tr:hover { background-color: #f8f9fa; }
    .btn-outline-danger { color: #dc3545; border-color: #dc3545; }
    .btn-outline-danger:hover { background-color: #dc3545; color: white; }
    .btn-group { gap: 0.5rem; }
</style>

<script>
function openDefautModal() {
    const modal = new bootstrap.Modal(document.getElementById('defautModal'), {});
    modal.show();
}
function closeDefautModal() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('defautModal'));
    if (modal) modal.hide();
}
function openPersonnaliseModal() {
    const modal = new bootstrap.Modal(document.getElementById('personnaliseModal'), {});
    modal.show();
}
function closePersonnaliseModal() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('personnaliseModal'));
    if (modal) modal.hide();
}
</script>
