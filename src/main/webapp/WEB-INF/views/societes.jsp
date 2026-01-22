<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="main-content">
    <div class="page-header mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-0">Sociétés Publicitaires</h1>
                <p class="text-muted small">Gestion des sociétés de publicité</p>
            </div>
            <button class="btn btn-primary btn-lg" onclick="openAddModal()">
                <i class="fas fa-plus me-2"></i> Ajouter une société
            </button>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Libellé</th>
                            <th>Date de création</th>
                            <th class="text-end pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="societe" items="${societes}">
                            <tr>
                                <td class="ps-4">
                                    <a href="<c:url value='/societes/${societe.id}'/>" class="text-decoration-none fw-600">
                                        <i class="fas fa-building text-primary me-2"></i> ${societe.libelle}
                                    </a>
                                </td>
                                <td>
                                    <small class="text-muted">${societe.createdAt}</small>
                                </td>
                                <td class="text-end pe-4">
                                    <a href="<c:url value='/societes/${societe.id}'/>" class="btn btn-sm btn-outline-info me-2">
                                        <i class="fas fa-eye"></i> Voir
                                    </a>
                                    <form method="post" action="<c:url value='/societes/${societe.id}/delete'/>" style="display: inline;">
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
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title fw-bold">
                    <i class="fas fa-plus me-2"></i> Ajouter une Société
                </h5>
                <button type="button" class="btn-close btn-close-white" onclick="closeAddModal()"></button>
            </div>
            <form method="post" action="<c:url value='/societes'/>">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="libelle" class="form-label fw-600">Libellé :</label>
                        <input type="text" id="libelle" name="libelle" class="form-control form-control-lg" placeholder="Entrez le libellé" required>
                    </div>
                </div>
                <div class="modal-footer border-0 bg-light">
                    <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Annuler</button>
                    <button type="submit" class="btn btn-primary">Ajouter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .fw-600 { font-weight: 600; }
    .page-header { padding-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; }
    .table-hover tbody tr:hover { background-color: #f8f9fa; }
    .btn-outline-info { color: #0dcaf0; border-color: #0dcaf0; }
    .btn-outline-info:hover { background-color: #0dcaf0; color: white; }
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

