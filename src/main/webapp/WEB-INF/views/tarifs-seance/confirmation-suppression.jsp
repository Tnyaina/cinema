<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Confirmer la suppression</h1>
</div>

<div class="confirmation-card">
    <div class="confirmation-icon">
        <i class="fas fa-exclamation-triangle"></i>
    </div>
    
    <h2>Êtes-vous sûr de vouloir supprimer ce tarif ?</h2>
    
    <div class="tarif-preview">
        <div class="preview-item">
            <span class="label">Film:</span>
            <span class="value">${tarifSeance.seance.film.titre}</span>
        </div>
        <div class="preview-item">
            <span class="label">Séance:</span>
            <span class="value">${tarifSeance.seance.debut}</span>
        </div>
        <div class="preview-item">
            <span class="label">Salle:</span>
            <span class="value">${tarifSeance.seance.salle.nom}</span>
        </div>
        <div class="preview-item">
            <span class="label">Type de place:</span>
            <span class="value">
                <c:choose>
                    <c:when test="${not empty tarifSeance.typePlace}">
                        ${tarifSeance.typePlace.libelle}
                    </c:when>
                    <c:otherwise>
                        Tous types
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
        <div class="preview-item">
            <span class="label">Catégorie:</span>
            <span class="value">
                <c:choose>
                    <c:when test="${not empty tarifSeance.categoriePersonne}">
                        ${tarifSeance.categoriePersonne.libelle}
                    </c:when>
                    <c:otherwise>
                        Toutes catégories
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
        <div class="preview-item">
            <span class="label">Prix:</span>
            <span class="value">${tarifSeance.prix} Ar</span>
        </div>
    </div>

    <div class="warning-message">
        <i class="fas fa-info-circle"></i>
        Cette action est irréversible.
    </div>

    <form method="POST" action="<c:url value='/tarifs-seance/${tarifSeance.id}/supprimer'/>" class="confirmation-form">
        <button type="submit" class="btn btn-danger btn-large">
            <i class="fas fa-trash"></i> Supprimer ce tarif
        </button>
        <a href="<c:url value='/tarifs-seance/${tarifSeance.id}'/>" class="btn btn-secondary btn-large">
            <i class="fas fa-times"></i> Annuler
        </a>
    </form>
</div>

<style>
    .content-header {
        margin-bottom: 40px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        color: #003d7a;
        font-weight: 600;
    }

    .confirmation-card {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
        padding: 40px;
        max-width: 550px;
        margin: 0 auto;
        text-align: center;
    }

    .confirmation-icon {
        font-size: 48px;
        color: #dc3545;
        margin-bottom: 20px;
    }

    .confirmation-card h2 {
        margin: 0 0 30px 0;
        font-size: 20px;
        color: #333;
        font-weight: 600;
    }

    .tarif-preview {
        background-color: #f9f9f9;
        border: 1px solid #e0e0e0;
        border-radius: 5px;
        padding: 20px;
        margin-bottom: 25px;
        text-align: left;
        max-height: 300px;
        overflow-y: auto;
    }

    .preview-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
        border-bottom: 1px solid #e0e0e0;
    }

    .preview-item:last-child {
        border-bottom: none;
    }

    .preview-item .label {
        font-weight: 600;
        color: #666;
    }

    .preview-item .value {
        color: #333;
    }

    .warning-message {
        background-color: #fff3cd;
        color: #856404;
        padding: 12px;
        border-radius: 4px;
        margin-bottom: 25px;
        font-size: 14px;
        border: 1px solid #ffeaa7;
    }

    .warning-message i {
        margin-right: 8px;
    }

    .confirmation-form {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-weight: 500;
        transition: all 0.2s;
        text-decoration: none;
    }

    .btn-large {
        padding: 14px 28px;
        font-size: 16px;
    }

    .btn:hover:not(:disabled) {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
    }

    .btn-danger:hover {
        background-color: #c82333;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    @media (max-width: 768px) {
        .confirmation-card {
            padding: 30px 20px;
        }

        .btn-large {
            padding: 12px 20px;
            font-size: 14px;
        }
    }
</style>
