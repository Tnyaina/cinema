<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-title">
        <h1><i class="fas fa-chair"></i> Places et Sièges</h1>
        <p class="subtitle">Gestion des places par salle</p>
    </div>
    <a href="<c:url value='/places/nouveau'/>" class="btn btn-primary btn-lg">
        <i class="fas fa-plus-circle"></i> Ajouter une place
    </a>
</div>

<!-- FILTRES -->
<div class="filters-section">
    <form method="get" action="<c:url value='/places'/>" class="filters-form">
        <div class="filter-group">
            <label for="salle">Salle</label>
            <select id="salle" name="salle" class="form-control" onchange="this.form.submit()">
                <option value="">-- Toutes les salles --</option>
                <c:forEach var="s" items="${salles}">
                    <option value="${s.id}" ${param.salle == s.id ? 'selected' : ''}>
                        ${s.nom} (${s.capacite} places)
                    </option>
                </c:forEach>
            </select>
        </div>

        <c:if test="${not empty param.salle}">
            <div class="filter-group">
                <label for="recherche">Rechercher</label>
                <input type="text" id="recherche" name="recherche" class="form-control" 
                       placeholder="Code place..." 
                       value="${param.recherche}">
            </div>
            <button type="submit" class="btn btn-secondary">
                <i class="fas fa-search"></i> Rechercher
            </button>
            <a href="<c:url value='/places'/>" class="btn btn-outline-secondary">
                <i class="fas fa-redo-alt"></i> Réinitialiser
            </a>
        </c:if>
    </form>
</div>

<!-- LISTE DES PLACES -->
<c:choose>
    <c:when test="${empty places}">
        <div class="empty-state">
            <div class="empty-icon">
                <i class="fas fa-chair"></i>
            </div>
            <h2>Aucune place trouvée</h2>
            <p>
                <c:if test="${not empty param.salle}">
                    Cette salle n'a pas encore de places configurées.
                    <a href="<c:url value='/places/nouveau?salle=${param.salle}'/>">Créer une place</a>.
                </c:if>
                <c:if test="${empty param.salle}">
                    <a href="<c:url value='/places/nouveau'/>">Créer votre première place</a>.
                </c:if>
            </p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Code Place</th>
                        <th>Salle</th>
                        <th>Rangée</th>
                        <th>Numéro</th>
                        <th>Type</th>
                        <th class="text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="place" items="${places}">
                        <tr>
                            <td>
                                <a href="<c:url value='/places/${place.id}'/>" class="link">
                                    <strong>${place.codePlace}</strong>
                                </a>
                            </td>
                            <td>${place.salle.nom}</td>
                            <td><span class="badge badge-info">${place.rangee}</span></td>
                            <td>${place.numero}</td>
                            <td>
                                <c:if test="${not empty place.typePlace}">
                                    <span class="badge badge-secondary">${place.typePlace.libelle}</span>
                                </c:if>
                                <c:if test="${empty place.typePlace}">
                                    <span class="text-muted">-</span>
                                </c:if>
                            </td>
                            <td class="text-right">
                                <a href="<c:url value='/places/${place.id}'/>" class="btn btn-sm btn-info" title="Voir détails">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="<c:url value='/places/${place.id}/modifier'/>" class="btn btn-sm btn-warning" title="Modifier">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="<c:url value='/places/${place.id}/supprimer'/>" class="btn btn-sm btn-danger" title="Supprimer">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>

<style>
    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
        gap: 20px;
    }

    .header-title h1 {
        margin: 0;
        font-size: 32px;
        color: #003d7a;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .header-title h1 i {
        color: #003d7a;
    }

    .subtitle {
        margin: 8px 0 0 0;
        color: #666;
        font-size: 14px;
    }

    .filters-section {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        border: 1px solid #e0e0e0;
    }

    .filters-form {
        display: flex;
        gap: 10px;
        align-items: flex-end;
        flex-wrap: wrap;
    }

    .filter-group {
        flex: 1;
        min-width: 200px;
    }

    .filter-group label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-weight: 600;
        font-size: 13px;
    }

    .form-control {
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        width: 100%;
    }

    .form-control:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 5px rgba(0, 61, 122, 0.2);
    }

    .table-responsive {
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .table {
        margin: 0;
        width: 100%;
        border-collapse: collapse;
    }

    .table thead {
        background-color: #003d7a;
        color: white;
    }

    .table thead th {
        padding: 15px;
        font-weight: 600;
        font-size: 14px;
    }

    .table tbody td {
        padding: 12px 15px;
        border-bottom: 1px solid #e0e0e0;
    }

    .table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .link {
        color: #003d7a;
        text-decoration: none;
        font-weight: 500;
    }

    .link:hover {
        text-decoration: underline;
    }

    .badge {
        padding: 5px 10px;
        border-radius: 3px;
        font-size: 12px;
        font-weight: 500;
    }

    .badge-info {
        background-color: #17a2b8;
        color: white;
    }

    .badge-secondary {
        background-color: #6c757d;
        color: white;
    }

    .text-muted {
        color: #999;
    }

    .text-right {
        text-align: right;
    }

    .btn {
        padding: 8px 12px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 12px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-weight: 500;
        transition: all 0.2s;
    }

    .btn:hover {
        transform: translateY(-2px);
    }

    .btn-sm {
        padding: 6px 10px;
    }

    .btn-info {
        background-color: #17a2b8;
        color: white;
    }

    .btn-info:hover {
        background-color: #138496;
    }

    .btn-warning {
        background-color: #ffc107;
        color: white;
    }

    .btn-warning:hover {
        background-color: #e0a800;
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
    }

    .btn-danger:hover {
        background-color: #c82333;
    }

    .btn-primary {
        background-color: #003d7a;
        color: white;
    }

    .btn-primary:hover {
        background-color: #002d5a;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    .btn-outline-secondary {
        border: 1px solid #6c757d;
        color: #6c757d;
        background-color: transparent;
    }

    .btn-outline-secondary:hover {
        background-color: #6c757d;
        color: white;
    }

    .btn-lg {
        padding: 12px 24px;
        font-size: 14px;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background-color: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #e0e0e0;
    }

    .empty-icon {
        font-size: 64px;
        color: #ccc;
        margin-bottom: 20px;
    }

    .empty-state h2 {
        color: #333;
        margin-bottom: 10px;
        font-weight: 600;
    }

    .empty-state p {
        color: #666;
        font-size: 14px;
    }

    .empty-state a {
        color: #003d7a;
        text-decoration: none;
        font-weight: 500;
    }

    .empty-state a:hover {
        text-decoration: underline;
    }
</style>
