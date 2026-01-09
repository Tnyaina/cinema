<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-top">
        <h1>Genres</h1>
        <a href="<c:url value='/genres/nouveau'/>" class="btn btn-success">
            <i class="fas fa-plus"></i> Ajouter un genre
        </a>
    </div>
</div>

<c:if test="${not empty param.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i>
        <c:choose>
            <c:when test="${param.success == 'genre_supprime'}">Genre supprimé avec succès</c:when>
            <c:when test="${param.success == 'genre_cree'}">Genre créé avec succès</c:when>
            <c:when test="${param.success == 'genre_modifie'}">Genre modifié avec succès</c:when>
            <c:otherwise>Opération réussie</c:otherwise>
        </c:choose>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle"></i> ${param.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="table-container">
    <c:choose>
        <c:when test="${empty genres}">
            <div class="empty-state">
                <i class="fas fa-film"></i>
                <p>Aucun genre trouvé</p>
                <a href="<c:url value='/genres/nouveau'/>" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Créer le premier genre
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Libellé</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="genre" items="${genres}">
                        <tr>
                            <td>
                                <a href="<c:url value='/genres/${genre.id}'/>" class="link">
                                    ${genre.libelle}
                                </a>
                            </td>
                            <td class="actions-cell">
                                <a href="<c:url value='/genres/${genre.id}/modifier'/>" class="btn btn-sm btn-warning" title="Modifier">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="<c:url value='/genres/${genre.id}/supprimer'/>" class="btn btn-sm btn-danger" title="Supprimer">
                                    <i class="fas fa-trash"></i>
                                </a>
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
        margin-bottom: 30px;
    }

    .header-top {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        color: #003d7a;
        font-weight: 600;
    }

    .table-container {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        padding: 30px;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #666;
    }

    .empty-state i {
        font-size: 48px;
        color: #ccc;
        display: block;
        margin-bottom: 15px;
    }

    .empty-state p {
        font-size: 16px;
        margin-bottom: 20px;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
    }

    .data-table thead {
        background-color: #f5f5f5;
        border-bottom: 2px solid #ddd;
    }

    .data-table thead th {
        padding: 15px;
        text-align: left;
        font-weight: 600;
        color: #333;
    }

    .data-table tbody tr {
        border-bottom: 1px solid #e0e0e0;
    }

    .data-table tbody tr:hover {
        background-color: #f9f9f9;
    }

    .data-table tbody td {
        padding: 15px;
        vertical-align: middle;
    }

    .actions-cell {
        display: flex;
        gap: 8px;
    }

    .link {
        color: #003d7a;
        text-decoration: none;
        font-weight: 500;
    }

    .link:hover {
        text-decoration: underline;
    }

    .btn {
        padding: 10px 16px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-weight: 500;
        transition: all 0.2s;
        text-decoration: none;
    }

    .btn-success {
        background-color: #28a745;
        color: white;
    }

    .btn-success:hover {
        background-color: #218838;
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }

    .btn-warning {
        background-color: #ffc107;
        color: #333;
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

    .btn-sm {
        padding: 6px 10px;
        font-size: 12px;
    }

    .alert {
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
    }

    .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
</style>
