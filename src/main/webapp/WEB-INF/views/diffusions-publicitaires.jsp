<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="main-content">
    <div class="page-header mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-0">Diffusions Publicitaires</h1>
                <p class="text-muted small">Gestion des diffusions publicitaires</p>
            </div>
            <button class="btn btn-primary btn-lg" onclick="openAddModal()">
                <i class="fas fa-plus me-2"></i> Ajouter une diffusion
            </button>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Vidéo</th>
                            <th>Société</th>
                            <th>Type</th>
                            <th>Tarif (€)</th>
                            <th>Date</th>
                            <th class="text-end pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="diffusion" items="${diffusions}">
                            <tr>
                                <td class="ps-4">
                                    <i class="fas fa-satellite-dish text-purple me-2"></i>
                                    <span class="fw-600">${diffusion.videoPublicitaire.libelle}</span>
                                </td>
                                <td>${diffusion.videoPublicitaire.societe.libelle}</td>
                                <td><span class="badge bg-info">${diffusion.typeDiffusion.libelle}</span></td>
                                <td><strong class="text-success">${diffusion.tarifApplique}€</strong></td>
                                <td>
                                    <small class="text-muted">${diffusion.dateDiffusion}</small>
                                </td>
                                <td class="text-end pe-4">
                                    <form method="post" action="<c:url value='/diffusions-publicitaires/${diffusion.id}/delete'/>" style="display: inline;">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Êtes-vous sûr ?')">
                                            <i class="fas fa-trash"></i> Supprimer
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Ajouter -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-danger text-white border-0">
                <h5 class="modal-title fw-bold">
                    <i class="fas fa-plus me-2"></i> Ajouter une Diffusion
                </h5>
                <button type="button" class="btn-close btn-close-white" onclick="closeAddModal()"></button>
            </div>
            <form method="post" action="<c:url value='/diffusions-publicitaires'/>">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="videoId" class="form-label fw-600">Vidéo :</label>
                        <select id="videoId" name="videoId" class="form-select form-select-lg" required>
                            <option value="">Sélectionner une vidéo</option>
                            <c:forEach var="video" items="${videos}">
                                <option value="${video.id}">${video.libelle} (${video.societe.libelle})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="seanceId" class="form-label fw-600">Séance ID :</label>
                        <input type="number" id="seanceId" name="seanceId" class="form-control form-control-lg" placeholder="Entrez le numéro de séance" required>
                    </div>
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
                        <label for="tarif" class="form-label fw-600">Tarif (€) :</label>
                        <input type="number" id="tarif" name="tarif" step="0.01" class="form-control form-control-lg" placeholder="Montant du tarif" required>
                    </div>
                    <div class="mb-3">
                        <label for="dateDiffusion" class="form-label fw-600">Date/Heure :</label>
                        <input type="datetime-local" id="dateDiffusion" name="dateDiffusion" class="form-control form-control-lg" required>
                    </div>
                </div>
                <div class="modal-footer border-0 bg-light">
                    <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Annuler</button>
                    <button type="submit" class="btn btn-danger">Ajouter</button>
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
    .text-purple { color: #9333ea; }
    .badge { font-weight: 500; }
</style>

<script>
function openAddModal() {
    const modal = new bootstrap.Modal(document.getElementById('addModal'), {});
    modal.show();
}
function closeAddModal() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('addModal'));
    if (modal) modal.hide();
}
</script>
