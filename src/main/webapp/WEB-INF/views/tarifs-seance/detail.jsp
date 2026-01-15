<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-top">
        <div>
            <h1>Tarif de séance</h1>
        </div>
        <div class="action-buttons">
            <a href="<c:url value='/tarifs-seance/${tarifSeance.id}/modifier'/>" class="btn btn-warning">
                <i class="fas fa-edit"></i> Modifier
            </a>
            <a href="<c:url value='/tarifs-seance/${tarifSeance.id}/supprimer'/>" class="btn btn-danger">
                <i class="fas fa-trash"></i> Supprimer
            </a>
            <a href="<c:url value='/tarifs-seance'/>" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Retour
            </a>
        </div>
    </div>
</div>

<div class="card-container">
    <div class="card">
        <div class="card-header">
            <h3>Séance</h3>
        </div>
        <div class="card-body">
            <div class="info-group">
                <label>Film:</label>
                <p><strong>${tarifSeance.seance.film.titre}</strong></p>
            </div>

            <div class="info-group">
                <label>Date et heure:</label>
                <p>${tarifSeance.seance.debut}</p>
            </div>

            <div class="info-group">
                <label>Salle:</label>
                <p>${tarifSeance.seance.salle.nom}</p>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h3>Tarif</h3>
        </div>
        <div class="card-body">
            <div class="info-group">
                <label>Type de place:</label>
                <p>
                    <c:choose>
                        <c:when test="${not empty tarifSeance.typePlace}">
                            <span class="badge badge-primary">${tarifSeance.typePlace.libelle}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">Tous types</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="info-group">
                <label>Catégorie personne:</label>
                <p>
                    <c:choose>
                        <c:when test="${not empty tarifSeance.categoriePersonne}">
                            <span class="badge badge-secondary">${tarifSeance.categoriePersonne.libelle}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">Toutes catégories</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="info-group">
                <label>Prix:</label>
                <p>
                    <span class="price-badge">${tarifSeance.prix} Ar</span>
                </p>
            </div>

            <div class="info-group">
                <label>ID:</label>
                <p class="text-muted">${tarifSeance.id}</p>
            </div>

            <div class="info-group">
                <label>Créé le:</label>
                <p class="text-muted">${tarifSeance.createdAt}</p>
            </div>

            <c:if test="${not empty tarifSeance.updatedAt}">
                <div class="info-group">
                    <label>Modifié le:</label>
                    <p class="text-muted">${tarifSeance.updatedAt}</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<style>
    .content-header {
        margin-bottom: 30px;
    }

    .header-top {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 20px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        color: #003d7a;
        font-weight: 600;
    }

    .action-buttons {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        justify-content: flex-end;
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

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
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

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    .card-container {
        margin-bottom: 30px;
    }

    .card {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        margin-bottom: 20px;
    }

    .card-header {
        background-color: #f5f5f5;
        padding: 18px 25px;
        border-bottom: 1px solid #e0e0e0;
    }

    .card-header h3 {
        margin: 0;
        font-size: 16px;
        color: #003d7a;
        font-weight: 600;
    }

    .card-body {
        padding: 25px;
    }

    .info-group {
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px solid #e0e0e0;
    }

    .info-group:last-child {
        margin-bottom: 0;
        padding-bottom: 0;
        border-bottom: none;
    }

    .info-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        color: #333;
        font-size: 14px;
    }

    .info-group p {
        margin: 0;
        color: #555;
    }

    .badge {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
    }

    .badge-primary {
        background-color: #003d7a;
        color: white;
    }

    .badge-secondary {
        background-color: #6c757d;
        color: white;
    }

    .price-badge {
        display: inline-block;
        padding: 8px 16px;
        background-color: #e8f5e9;
        border-left: 4px solid #4caf50;
        border-radius: 4px;
        font-weight: 600;
        color: #2e7d32;
        font-size: 16px;
    }

    .text-muted {
        color: #999;
    }

    @media (max-width: 768px) {
        .action-buttons {
            flex-direction: column;
            width: 100%;
        }

        .btn {
            width: 100%;
            justify-content: center;
        }
    }
</style>
