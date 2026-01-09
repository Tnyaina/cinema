<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <a href="<c:url value='/genres'/>" class="breadcrumb-link">Genres</a>
    <span class="breadcrumb-separator">/</span>
    <span class="breadcrumb-current">${genre.libelle}</span>
</div>

<div class="detail-container">
    <div class="detail-header">
        <h1>${genre.libelle}</h1>
        <div class="actions">
            <a href="<c:url value='/genres/${genre.id}/modifier'/>" class="btn btn-warning">
                <i class="fas fa-edit"></i> Modifier
            </a>
            <a href="<c:url value='/genres/${genre.id}/supprimer'/>" class="btn btn-danger">
                <i class="fas fa-trash"></i> Supprimer
            </a>
        </div>
    </div>

    <div class="info-group">
        <h3>Informations</h3>
        <div class="info-item">
            <label>ID:</label>
            <span>${genre.id}</span>
        </div>
        <div class="info-item">
            <label>Libellé:</label>
            <span>${genre.libelle}</span>
        </div>
    </div>
</div>

<style>
    .content-header {
        margin-bottom: 30px;
        font-size: 14px;
        color: #666;
    }

    .breadcrumb-link {
        color: #007bff;
        text-decoration: none;
    }

    .breadcrumb-link:hover {
        text-decoration: underline;
    }

    .breadcrumb-separator {
        margin: 0 8px;
    }

    .breadcrumb-current {
        color: #333;
        font-weight: 600;
    }

    .detail-container {
        background: white;
        border-radius: 8px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .detail-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 1px solid #e0e0e0;
    }

    .detail-header h1 {
        margin: 0;
        font-size: 28px;
        color: #003d7a;
        font-weight: 600;
    }

    .actions {
        display: flex;
        gap: 10px;
    }

    .info-group {
        margin-bottom: 30px;
    }

    .info-group h3 {
        font-size: 16px;
        color: #333;
        margin: 0 0 15px 0;
        font-weight: 600;
        padding-bottom: 10px;
        border-bottom: 2px solid #003d7a;
    }

    .info-item {
        display: flex;
        padding: 12px 0;
        border-bottom: 1px solid #f0f0f0;
    }

    .info-item label {
        font-weight: 600;
        min-width: 150px;
        color: #666;
    }

    .info-item span {
        color: #333;
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
</style>
