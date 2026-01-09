<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="cinema.shared.DateUtils" %>

<c:set var="createdAtFormatted" value="<%= DateUtils.formatDateTime(((cinema.referentiel.versionlangue.VersionLangue)pageContext.findAttribute(\"versionLangue\")).getCreatedAt()) %>" />

<div class="content-header">
    <h1>${versionLangue.libelle}</h1>
    <div class="header-actions">
        <a href="<c:url value='/versions-langue/${versionLangue.id}/modifier'/>" class="btn btn-warning">
            <i class="fas fa-edit"></i> Modifier
        </a>
        <a href="<c:url value='/versions-langue/${versionLangue.id}/supprimer'/>" class="btn btn-danger">
            <i class="fas fa-trash"></i> Supprimer
        </a>
        <a href="<c:url value='/versions-langue'/>" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="detail-container">
    <div class="detail-row">
        <div class="detail-card">
            <div class="card-header">
                <h3>Informations généales</h3>
            </div>
            <div class="card-body">
                <div class="info-group">
                    <label>Code:</label>
                    <p><code>${versionLangue.code}</code></p>
                </div>
                <div class="info-group">
                    <label>Libellé:</label>
                    <p><strong>${versionLangue.libelle}</strong></p>
                </div>
            </div>
        </div>

        <div class="detail-card">
            <div class="card-header">
                <h3>Langues associées</h3>
            </div>
            <div class="card-body">
                <div class="info-group">
                    <label>Langue audio:</label>
                    <p>
                        <c:if test="${not empty versionLangue.langueAudio}">
                            <strong>${versionLangue.langueAudio.libelle}</strong> (${versionLangue.langueAudio.code})
                        </c:if>
                        <c:if test="${empty versionLangue.langueAudio}">
                            <span class="text-muted">Non spécifiée</span>
                        </c:if>
                    </p>
                </div>
                <div class="info-group">
                    <label>Langue sous-titre:</label>
                    <p>
                        <c:if test="${not empty versionLangue.langueSousTitre}">
                            <strong>${versionLangue.langueSousTitre.libelle}</strong> (${versionLangue.langueSousTitre.code})
                        </c:if>
                        <c:if test="${empty versionLangue.langueSousTitre}">
                            <span class="text-muted">Non spécifiée</span>
                        </c:if>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="detail-row">
        <div class="detail-card">
            <div class="card-header">
                <h3>Métadonnées</h3>
            </div>
            <div class="card-body">
                <div class="info-group">
                    <label>ID:</label>
                    <p class="text-muted">${versionLangue.id}</p>
                </div>
                <div class="info-group">
                    <label>Créée le:</label>
                    <p class="text-muted">${createdAtFormatted}</p>
                </div>
            </div>
        </div>
    </div>
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

    .header-actions {
        display: flex;
        gap: 10px;
    }

    .detail-container {
        margin: 30px 0;
    }

    .detail-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 25px;
        margin-bottom: 25px;
    }

    .detail-card {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
    }

    .detail-card:hover {
        box-shadow: 0 4px 12px rgba(0, 61, 122, 0.15);
    }

    .card-header {
        background-color: #003d7a;
        color: white;
        padding: 20px;
    }

    .card-header h3 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
    }

    .card-body {
        padding: 25px;
    }

    .info-group {
        margin-bottom: 20px;
    }

    .info-group:last-child {
        margin-bottom: 0;
    }

    .info-group label {
        font-weight: 600;
        color: #555;
        display: block;
        margin-bottom: 8px;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-group p {
        margin: 0;
        color: #333;
        font-size: 15px;
        padding: 8px 0;
    }

    .info-group code {
        background-color: #f5f5f5;
        padding: 4px 8px;
        border-radius: 3px;
        font-family: monospace;
    }

    .text-muted {
        color: #999;
    }

    .btn {
        padding: 10px 18px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        transition: all 0.2s ease;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
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

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    @media (max-width: 768px) {
        .content-header {
            flex-direction: column;
        }

        .detail-row {
            grid-template-columns: 1fr;
        }

        .header-actions {
            width: 100%;
            flex-wrap: wrap;
        }
    }
</style>
