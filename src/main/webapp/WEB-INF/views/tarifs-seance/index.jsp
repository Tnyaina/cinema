<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="content-header">
    <h1>Tarifs de séance</h1>
    <a href="<c:url value='/tarifs-seance/nouveau'/>" class="btn btn-primary">
        <i class="fas fa-plus"></i> Ajouter un tarif
    </a>
</div>

<c:if test="${not empty param.success}">
    <div class="alert alert-success">
        <c:choose>
            <c:when test="${param.success == 'tarif_supprime'}">Tarif supprimé avec succès</c:when>
            <c:when test="${param.success == 'tarif_cree'}">Tarif créé avec succès</c:when>
            <c:when test="${param.success == 'tarif_modifie'}">Tarif modifié avec succès</c:when>
            <c:when test="${param.success == 'tarifs_crees'}">Tarifs créés avec succès</c:when>
            <c:otherwise>Opération réussie</c:otherwise>
        </c:choose>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="alert alert-error">
        ${param.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- FILTRES -->
<div class="filters-card">
    <div class="filters-header">
        <h3>Filtres</h3>
    </div>
    <div class="filters-content">
        <form method="GET" action="<c:url value='/tarifs-seance'/>" class="filters-form">
            <div class="filter-group">
                <label for="seanceFilter">Séance</label>
                <select id="seanceFilter" name="seance" class="form-control" onchange="this.form.submit()">
                    <option value="">-- Toutes séances --</option>
                    <c:forEach var="s" items="${seances}">
                        <option value="${s.id}" ${not empty seanceSelectionnee && seanceSelectionnee.id == s.id ? 'selected' : ''}>
                            ${s.film.titre} - ${s.debut} (Salle ${s.salle.nom})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="typePlaceFilter">Type de place</label>
                <select id="typePlaceFilter" name="typePlace" class="form-control" onchange="this.form.submit()">
                    <option value="">-- Tous types --</option>
                    <c:forEach var="type" items="${typesPlace}">
                        <option value="${type.id}" ${not empty typePlaceSelectionnee && typePlaceSelectionnee.id == type.id ? 'selected' : ''}>
                            ${type.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="categorieFilter">Catégorie personne</label>
                <select id="categorieFilter" name="categoriePersonne" class="form-control" onchange="this.form.submit()">
                    <option value="">-- Toutes catégories --</option>
                    <c:forEach var="cat" items="${categoriesPersonne}">
                        <option value="${cat.id}" ${not empty categoriePersonneSelectionnee && categoriePersonneSelectionnee.id == cat.id ? 'selected' : ''}>
                            ${cat.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-actions">
                <a href="<c:url value='/tarifs-seance'/>" class="btn btn-secondary">
                    <i class="fas fa-redo"></i> Réinitialiser
                </a>
            </div>
        </form>
    </div>
</div>

<!-- RÉSULTATS -->
<div class="results-info">
    Affichage de <strong>${fn:length(tarifSeances)}</strong> tarif(s)
    <c:if test="${not empty seanceSelectionnee}">
        pour la séance <strong>${seanceSelectionnee.film.titre}</strong>
    </c:if>
    <c:if test="${not empty typePlaceSelectionnee}">
        de type <strong>${typePlaceSelectionnee.libelle}</strong>
    </c:if>
    <c:if test="${not empty categoriePersonneSelectionnee}">
        pour la catégorie <strong>${categoriePersonneSelectionnee.libelle}</strong>
    </c:if>
</div>

<div class="card">
    <c:choose>
        <c:when test="${empty tarifSeances}">
            <div class="empty-state">
                <p>Aucun tarif de séance trouvé.</p>
                <a href="<c:url value='/tarifs-seance/nouveau'/>">Créer un nouveau tarif</a>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                    <tr>
                        <th>Séance</th>
                        <th>Type de place</th>
                        <th>Catégorie personne</th>
                        <th>Prix</th>
                        <th>Créé le</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="tarif" items="${tarifSeances}">
                        <tr>
                            <td>
                                <div class="seance-info">
                                    <div class="film-title">${tarif.seance.film.titre}</div>
                                    <div class="seance-details">${tarif.seance.debut} - ${tarif.seance.salle.nom}</div>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty tarif.typePlace}">
                                        ${tarif.typePlace.libelle}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty tarif.categoriePersonne}">
                                        ${tarif.categoriePersonne.libelle}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong>${tarif.prix} €</strong></td>
                            <td class="text-muted">${tarif.createdAt}</td>
                            <td>
                                <div class="actions">
                                    <a href="<c:url value='/tarifs-seance/${tarif.id}'/>" class="btn-icon" title="Voir">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="<c:url value='/tarifs-seance/${tarif.id}/modifier'/>" class="btn-icon" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<c:url value='/tarifs-seance/${tarif.id}/supprimer'/>" class="btn-icon" title="Supprimer">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<style>
    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid #e5e7eb;
    }

    .content-header h1 {
        margin: 0;
        font-size: 24px;
        font-weight: 600;
        color: #111827;
    }

    .btn {
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        border: none;
        transition: all 0.15s;
    }

    .btn-primary {
        background-color: #111827;
        color: white;
    }

    .btn-primary:hover {
        background-color: #374151;
    }

    .btn-secondary {
        background-color: #6b7280;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #4b5563;
    }

    .btn-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        border-radius: 4px;
        color: #6b7280;
        text-decoration: none;
        transition: all 0.15s;
    }

    .btn-icon:hover {
        background-color: #f3f4f6;
        color: #111827;
    }

    .filters-card {
        background: white;
        border-radius: 8px;
        border: 1px solid #e5e7eb;
        margin-bottom: 20px;
        overflow: hidden;
    }

    .filters-header {
        background-color: #f9fafb;
        padding: 12px 16px;
        border-bottom: 1px solid #e5e7eb;
    }

    .filters-header h3 {
        margin: 0;
        font-size: 14px;
        color: #111827;
        font-weight: 500;
    }

    .filters-content {
        padding: 16px;
    }

    .filters-form {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 12px;
        align-items: end;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
    }

    .filter-group label {
        font-weight: 500;
        margin-bottom: 6px;
        color: #374151;
        font-size: 13px;
    }

    .form-control {
        padding: 8px 12px;
        border: 1px solid #d1d5db;
        border-radius: 6px;
        font-size: 14px;
        width: 100%;
        background-color: white;
        color: #111827;
    }

    .form-control:focus {
        outline: none;
        border-color: #9ca3af;
    }

    .filter-actions {
        display: flex;
        gap: 8px;
    }

    .results-info {
        background-color: #f9fafb;
        border-left: 3px solid #111827;
        padding: 12px 16px;
        border-radius: 4px;
        margin-bottom: 20px;
        font-size: 14px;
        color: #374151;
    }

    .card {
        background: white;
        border-radius: 8px;
        border: 1px solid #e5e7eb;
        overflow: hidden;
    }

    .table {
        width: 100%;
        border-collapse: collapse;
    }

    .table thead th {
        background-color: #f9fafb;
        color: #6b7280;
        font-weight: 500;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 12px 16px;
        text-align: left;
        border-bottom: 1px solid #e5e7eb;
    }

    .table tbody td {
        padding: 16px;
        border-bottom: 1px solid #f3f4f6;
        color: #111827;
        font-size: 14px;
        vertical-align: middle;
    }

    .table tbody tr:last-child td {
        border-bottom: none;
    }

    .table tbody tr:hover {
        background-color: #f9fafb;
    }

    .seance-info {
        min-width: 200px;
    }

    .film-title {
        font-weight: 500;
        color: #111827;
        margin-bottom: 4px;
    }

    .seance-details {
        font-size: 13px;
        color: #6b7280;
    }

    .text-muted {
        color: #9ca3af;
    }

    .actions {
        display: flex;
        gap: 4px;
    }

    .alert {
        padding: 12px 16px;
        border-radius: 6px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 14px;
    }

    .alert-success {
        background-color: #f0fdf4;
        color: #166534;
        border: 1px solid #bbf7d0;
    }

    .alert-error {
        background-color: #fef2f2;
        color: #991b1b;
        border: 1px solid #fecaca;
    }

    .btn-close {
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: inherit;
        opacity: 0.5;
        padding: 0;
        width: 20px;
        height: 20px;
    }

    .btn-close:hover {
        opacity: 1;
    }

    .btn-close::before {
        content: "×";
    }

    .empty-state {
        padding: 48px 24px;
        text-align: center;
        color: #6b7280;
    }

    .empty-state p {
        margin: 0 0 12px 0;
        font-size: 15px;
    }

    .empty-state a {
        color: #111827;
        text-decoration: underline;
        font-size: 14px;
    }

    .empty-state a:hover {
        color: #374151;
    }

    @media (max-width: 768px) {
        .filters-form {
            grid-template-columns: 1fr;
        }

        .table {
            font-size: 13px;
        }

        .table thead th,
        .table tbody td {
            padding: 10px;
        }

        .seance-info {
            min-width: 150px;
        }
    }
</style>