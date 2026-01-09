<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Personnes</h1>
    <a href="<c:url value='/personnes/nouveau'/>" class="btn btn-primary">
        <i class="fas fa-plus"></i> Ajouter une personne
    </a>
</div>

<c:if test="${not empty param.success}">
    <div class="alert alert-success">
        <c:choose>
            <c:when test="${param.success == 'personne_supprimee'}">Personne supprimée avec succès</c:when>
            <c:when test="${param.success == 'personne_creee'}">Personne créée avec succès</c:when>
            <c:when test="${param.success == 'personne_modifiee'}">Personne modifiée avec succès</c:when>
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
        <c:when test="${empty personnes}">
            <div class="empty-state">
                <p>Aucune personne enregistrée.</p>
                <a href="<c:url value='/personnes/nouveau'/>">Ajouter la première personne</a>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                    <tr>
                        <th>Nom complet</th>
                        <th>Email</th>
                        <th>Téléphone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="personne" items="${personnes}">
                        <tr>
                            <td><strong>${personne.nomComplet}</strong></td>
                            <td>${personne.email}</td>
                            <td>${personne.telephone}</td>
                            <td>
                                <div class="actions">
                                    <a href="<c:url value='/personnes/${personne.id}'/>" class="btn-icon" title="Voir">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="<c:url value='/personnes/${personne.id}/modifier'/>" class="btn-icon" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<c:url value='/personnes/${personne.id}/supprimer'/>" class="btn-icon" title="Supprimer">
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
        border-bottom: 2px solid #1e3a5f;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        font-weight: 700;
        color: #1e3a5f;
    }

    .btn {
        padding: 10px 18px;
        border-radius: 6px;
        text-decoration: none;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border: none;
        transition: all 0.2s ease;
        font-weight: 500;
    }

    .btn-primary {
        background: linear-gradient(135deg, #1e3a5f 0%, #2d5a8f 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(30, 58, 95, 0.2);
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, #152a45 0%, #1e3a5f 100%);
        box-shadow: 0 4px 12px rgba(30, 58, 95, 0.3);
        transform: translateY(-2px);
    }

    .btn-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        border-radius: 4px;
        color: #2d5a8f;
        text-decoration: none;
        transition: all 0.2s ease;
        font-size: 16px;
    }

    .btn-icon:hover {
        background-color: #e8f0f8;
        color: #1e3a5f;
    }

    .card {
        background: white;
        border-radius: 8px;
        border: 1px solid #d1dce6;
        overflow: hidden;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
    }

    .table {
        width: 100%;
        border-collapse: collapse;
    }

    .table thead th {
        background: linear-gradient(135deg, #1e3a5f 0%, #2d5a8f 100%);
        color: white;
        font-weight: 600;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 14px 16px;
        text-align: left;
        border: none;
    }

    .table tbody td {
        padding: 14px 16px;
        border-bottom: 1px solid #e8f0f8;
        color: #374151;
        font-size: 14px;
    }

    .table tbody tr:last-child td {
        border-bottom: none;
    }

    .table tbody tr:hover {
        background-color: #f0f6fc;
    }

    .actions {
        display: flex;
        gap: 6px;
    }

    .alert {
        padding: 14px 16px;
        border-radius: 6px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 14px;
        border-left: 4px solid;
    }

    .alert-success {
        background-color: #ecfdf5;
        color: #065f46;
        border-left-color: #10b981;
    }

    .alert-error {
        background-color: #fef2f2;
        color: #991b1b;
        border-left-color: #ef4444;
    }

    .btn-close {
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: inherit;
        opacity: 0.6;
        padding: 0;
        width: 20px;
        height: 20px;
        transition: opacity 0.2s;
    }

    .btn-close:hover {
        opacity: 1;
    }

    .btn-close::before {
        content: "×";
    }

    .empty-state {
        padding: 60px 24px;
        text-align: center;
        color: #6b7280;
    }

    .empty-state p {
        margin: 0 0 16px 0;
        font-size: 15px;
    }

    .empty-state a {
        color: #1e3a5f;
        text-decoration: underline;
        font-size: 14px;
        font-weight: 500;
        transition: color 0.2s;
    }

    .empty-state a:hover {
        color: #2d5a8f;
    }
</style>
