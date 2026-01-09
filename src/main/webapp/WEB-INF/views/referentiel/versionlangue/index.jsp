<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Versions de langue</h1>
    <a href="<c:url value='/versions-langue/nuevo'/>" class="btn btn-primary">
        <i class="fas fa-plus"></i> Ajouter une version de langue
    </a>
</div>

<div class="list-container">
    <c:if test="${not empty versionsLangue}">
        <div class="stats-card">
            <div class="stat-value">${nombreVersionsLangue}</div>
            <div class="stat-label">version(s) de langue</div>
        </div>

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Libellé</th>
                        <th style="width: 200px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="versionLangue" items="${versionsLangue}">
                        <tr>
                            <td>
                                <code>${versionLangue.code}</code>
                            </td>
                            <td>
                                <a href="<c:url value='/versions-langue/${versionLangue.id}'/>" class="link">
                                    <strong>${versionLangue.libelle}</strong>
                                </a>
                            </td>
                            <td>
                                <a href="<c:url value='/versions-langue/${versionLangue.id}'/>" class="btn btn-sm btn-info" title="Voir">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="<c:url value='/versions-langue/${versionLangue.id}/modifier'/>" class="btn btn-sm btn-warning" title="Modifier">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="<c:url value='/versions-langue/${versionLangue.id}/supprimer'/>" class="btn btn-sm btn-danger" title="Supprimer">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <c:if test="${empty versionsLangue}">
        <div class="empty-state">
            <i class="fas fa-inbox"></i>
            <h3>Aucune version de langue</h3>
            <p>Commencez par créer votre première version de langue.</p>
            <a href="<c:url value='/versions-langue/nuevo'/>" class="btn btn-primary">
                <i class="fas fa-plus"></i> Créer une version de langue
            </a>
        </div>
    </c:if>
</div>

<style>
    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
        gap: 20px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 32px;
        color: #003d7a;
        font-weight: 600;
    }

    .list-container {
        margin: 30px 0;
    }

    .stats-card {
        background: white;
        border-left: 5px solid #003d7a;
        padding: 25px;
        border-radius: 8px;
        margin-bottom: 30px;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .stat-value {
        font-size: 36px;
        font-weight: 700;
        color: #003d7a;
    }

    .stat-label {
        font-size: 14px;
        color: #666;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .table-responsive {
        overflow-x: auto;
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
    }

    .table {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
    }

    .table thead {
        background-color: #003d7a;
        color: white;
    }

    .table thead th {
        padding: 15px 20px;
        text-align: left;
        font-weight: 600;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .table tbody td {
        padding: 15px 20px;
        border-bottom: 1px solid #f0f0f0;
    }

    .table tbody tr:hover {
        background-color: #f9fbfd;
    }

    .table code {
        background-color: #f5f5f5;
        padding: 4px 8px;
        border-radius: 3px;
        font-family: monospace;
        color: #333;
    }

    .link {
        color: #003d7a;
        text-decoration: none;
    }

    .link:hover {
        text-decoration: underline;
    }

    .btn {
        padding: 8px 14px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 13px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-weight: 500;
        transition: all 0.2s ease;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    .btn-primary {
        background-color: #003d7a;
        color: white;
    }

    .btn-primary:hover {
        background-color: #002d5a;
    }

    .btn-sm {
        padding: 6px 10px;
        font-size: 12px;
    }

    .btn-info {
        background-color: #17a2b8;
        color: white;
    }

    .btn-info:hover {
        background-color: #117a8b;
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

    .empty-state {
        text-align: center;
        padding: 60px 40px;
        background: white;
        border: 2px dashed #e0e0e0;
        border-radius: 8px;
        color: #999;
    }

    .empty-state i {
        font-size: 48px;
        color: #ccc;
        display: block;
        margin-bottom: 20px;
    }

    .empty-state h3 {
        color: #666;
        font-size: 20px;
        margin-bottom: 10px;
    }

    .empty-state p {
        color: #999;
        margin-bottom: 30px;
        font-size: 14px;
    }

    @media (max-width: 768px) {
        .content-header {
            flex-direction: column;
        }

        .stats-card {
            flex-direction: column;
            align-items: flex-start;
        }

        .table {
            font-size: 12px;
        }

        .table thead th,
        .table tbody td {
            padding: 10px;
        }

        .btn {
            padding: 6px 10px;
            font-size: 11px;
        }
    }
</style>
