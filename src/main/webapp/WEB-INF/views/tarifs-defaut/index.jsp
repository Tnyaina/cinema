<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Tarifs par défaut</h1>
    <a href="<c:url value='/tarifs-defaut/nouveau'/>" class="btn btn-primary">
        <i class="fas fa-plus"></i> Ajouter un tarif
    </a>
</div>

<c:if test="${not empty param.success}">
    <div class="alert alert-success">
        <c:choose>
            <c:when test="${param.success == 'tarif_supprime'}">Tarif supprimé avec succès</c:when>
            <c:when test="${param.success == 'tarif_cree'}">Tarif créé avec succès</c:when>
            <c:when test="${param.success == 'tarif_modifie'}">Tarif modifié avec succès</c:when>
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

<div class="card">
    <c:choose>
        <c:when test="${empty tarifDefauts}">
            <div class="empty-state">
                <p>Aucun tarif par défaut configuré.</p>
                <a href="<c:url value='/tarifs-defaut/nouveau'/>">Créer le premier tarif</a>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                    <tr>
                        <th>Type de place</th>
                        <th>Catégorie personne</th>
                        <th>Prix</th>
                        <th>Créé le</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="tarif" items="${tarifDefauts}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty tarif.typePlace}">
                                        ${tarif.typePlace.libelle}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Tous types</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty tarif.categoriePersonne}">
                                        ${tarif.categoriePersonne.libelle}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Toutes catégories</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong>${tarif.prix} €</strong></td>
                            <td class="text-muted">${tarif.createdAt}</td>
                            <td>
                                <div class="actions">
                                    <a href="<c:url value='/tarifs-defaut/${tarif.id}'/>" class="btn-icon" title="Voir">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="<c:url value='/tarifs-defaut/${tarif.id}/modifier'/>" class="btn-icon" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<c:url value='/tarifs-defaut/${tarif.id}/supprimer'/>" class="btn-icon" title="Supprimer">
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
    }

    .table tbody tr:last-child td {
        border-bottom: none;
    }

    .table tbody tr:hover {
        background-color: #f9fafb;
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
</style>