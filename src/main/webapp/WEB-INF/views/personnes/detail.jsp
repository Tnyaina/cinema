<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Détail de la personne</h1>
</div>

<div class="detail-container">
    <div class="detail-card">
        <div class="card-header">
            <h3>Informations générales</h3>
        </div>
        <div class="card-body">
            <div class="detail-group">
                <label>Nom complet</label>
                <p>${personne.nomComplet}</p>
            </div>
            <div class="detail-group">
                <label>Email</label>
                <p>${personne.email}</p>
            </div>
            <div class="detail-group">
                <label>Téléphone</label>
                <p>${personne.telephone}</p>
            </div>
        </div>
    </div>

    <div class="detail-actions">
        <a href="<c:url value='/personnes/${personne.id}/modifier'/>" class="btn btn-primary">
            <i class="fas fa-edit"></i> Modifier
        </a>
        <a href="<c:url value='/personnes/${personne.id}/supprimer'/>" class="btn btn-danger">
            <i class="fas fa-trash"></i> Supprimer
        </a>
        <a href="<c:url value='/personnes'/>" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>
</div>

<style>
    .content-header {
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

    .detail-container {
        max-width: 700px;
    }

    .detail-card {
        background: white;
        border-radius: 8px;
        border: 1px solid #d1dce6;
        overflow: hidden;
        margin-bottom: 20px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
    }

    .card-header {
        background: linear-gradient(135deg, #1e3a5f 0%, #2d5a8f 100%);
        padding: 16px;
        border-bottom: 1px solid #d1dce6;
    }

    .card-header h3 {
        margin: 0;
        font-size: 16px;
        font-weight: 600;
        color: white;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .card-body {
        padding: 24px;
    }

    .detail-group {
        margin-bottom: 20px;
    }

    .detail-group:last-child {
        margin-bottom: 0;
    }

    .detail-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #1e3a5f;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .detail-group p {
        margin: 0;
        color: #374151;
        font-size: 15px;
        padding: 12px;
        background-color: #f9fafb;
        border-radius: 4px;
        border-left: 3px solid #2d5a8f;
    }

    .detail-actions {
        display: flex;
        gap: 12px;
        justify-content: flex-start;
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

    .btn-danger {
        background-color: #ef4444;
        color: white;
        box-shadow: 0 2px 8px rgba(239, 68, 68, 0.2);
    }

    .btn-danger:hover {
        background-color: #dc2626;
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        transform: translateY(-2px);
    }

    .btn-secondary {
        background-color: #e5e7eb;
        color: #374151;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .btn-secondary:hover {
        background-color: #d1d5db;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
</style>
