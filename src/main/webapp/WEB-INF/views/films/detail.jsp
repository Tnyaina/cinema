<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="content-header">
    <div class="header-nav">
        <a href="<c:url value='/films'/>" class="btn btn-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="film-detail-container">
    <!-- AFFICHE ET INFO PRINCIPALE -->
    <div class="film-detail-header">
        <div class="film-poster-large">
            <img src="<c:url value='/img/placeholder.jpg'/>" alt="${film.titre}" class="poster-img">
            <div class="age-badge-overlay">
                <c:choose>
                    <c:when test="${film.ageMin >= 18}">
                        <span class="age-badge badge-18">18+</span>
                    </c:when>
                    <c:when test="${film.ageMin >= 16}">
                        <span class="age-badge badge-16">16+</span>
                    </c:when>
                    <c:when test="${film.ageMin >= 12}">
                        <span class="age-badge badge-12">12+</span>
                    </c:when>
                    <c:otherwise>
                        <span class="age-badge badge-all">Tous publics</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="film-detail-info">
            <h1>${film.titre}</h1>
            
            <div class="film-metadata">
                <div class="metadata-row">
                    <span class="label">Durée :</span>
                    <span class="value">
                        <i class="fas fa-clock"></i> ${film.dureeMinutes} minutes
                    </span>
                </div>

                <div class="metadata-row">
                    <span class="label">Date de sortie :</span>
                    <span class="value">
                        <i class="fas fa-calendar"></i>
                        ${film.dateSortieFormatted}
                    </span>
                </div>

                <div class="metadata-row">
                    <span class="label">Âge minimum :</span>
                    <span class="value">
                        <span class="badge badge-${film.ageMin > 12 ? 'danger' : 'success'}">
                            ${film.ageMin}+
                        </span>
                    </span>
                </div>

                <c:if test="${not empty film.langueOriginale}">
                    <div class="metadata-row">
                        <span class="label">Langue originale :</span>
                        <span class="value">
                            <i class="fas fa-language"></i> ${film.langueOriginale.libelle}
                        </span>
                    </div>
                </c:if>

                <c:if test="${not empty film.genres}">
                    <div class="metadata-row">
                        <span class="label">Genres :</span>
                        <span class="value">
                            <c:forEach var="genre" items="${film.genres}" varStatus="status">
                                <span class="badge badge-info">${genre.libelle}</span>
                                <c:if test="${not status.last}"></c:if>
                            </c:forEach>
                        </span>
                    </div>
                </c:if>
            </div>

            <div class="film-actions-detail">
                <a href="<c:url value='/films/${film.id}/modifier'/>" class="btn btn-warning btn-lg">
                    <i class="fas fa-edit"></i> Modifier
                </a>
                <button type="button" class="btn btn-danger btn-lg" onclick="openDeleteModal()">
                    <i class="fas fa-trash"></i> Supprimer
                </button>
            </div>
        </div>
    </div>

    <!-- DESCRIPTION -->
    <div class="film-description-section">
        <h2>Résumé</h2>
        <p class="description-text">
            ${not empty film.description ? film.description : 'Aucune description disponible'}
        </p>
    </div>

    <!-- SEANCES DISPONIBLES -->
    <div class="film-seances-section">
        <h2>Séances disponibles</h2>
        <c:choose>
            <c:when test="${not empty seances}">
                <div class="seances-list">
                    <c:forEach var="seance" items="${seances}">
                        <div class="seance-card">
                            <div class="seance-header">
                                <div class="seance-date-time">
                                    <p class="seance-date">
                                        <i class="fas fa-calendar-alt"></i>
                                        <strong>${seance.dateSeanceFormatted}</strong>
                                    </p>
                                    <p class="seance-hour">
                                        <i class="fas fa-clock"></i>
                                        <strong>${seance.heureDebutFormatted}</strong>
                                        <c:if test="${not empty seance.fin}">
                                            - ${seance.heureFin}
                                        </c:if>
                                    </p>
                                </div>
                                <div class="seance-room">
                                    <p class="seance-salle">
                                        <i class="fas fa-door-open"></i>
                                        <strong>${seance.salle.nom}</strong>
                                    </p>
                                    <c:if test="${not empty seance.versionLangue}">
                                        <p class="seance-version">
                                            <i class="fas fa-closed-captioning"></i>
                                            ${seance.versionLangue.libelle}
                                        </p>
                                    </c:if>
                                </div>
                            </div>
                            <div class="seance-footer">
                                <div class="seance-places">
                                    <c:choose>
                                        <c:when test="${seance.placesDisponibles > 0}">
                                            <span class="badge badge-success">
                                                <i class="fas fa-chair"></i>
                                                ${seance.placesDisponibles} place<c:if test="${seance.placesDisponibles > 1}">s</c:if> disponible<c:if test="${seance.placesDisponibles > 1}">s</c:if>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">
                                                <i class="fas fa-ban"></i>
                                                Complet
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${seance.placesDisponibles > 0}">
                                    <a href="<c:url value='/seances/${seance.id}'/>" class="btn btn-primary btn-sm">
                                        <i class="fas fa-eye"></i> Voir les places
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    Aucune séance disponible pour ce film actuellement.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- MODAL SUPPRESSION - CACHÉ PAR DÉFAUT -->
<div class="modal-overlay" id="deleteModal" style="display: none;" onclick="closeDeleteModal()">
    <div class="modal-dialog" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h5 class="modal-title">
                <i class="fas fa-exclamation-triangle"></i> Supprimer le film
            </h5>
            <button type="button" class="modal-close" onclick="closeDeleteModal()">
                <span>&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <p>Êtes-vous sûr de vouloir supprimer le film <strong>${film.titre}</strong> ?</p>
            <p class="text-danger">
                <i class="fas fa-exclamation-triangle"></i>
                Cette action ne peut pas être annulée.
            </p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Annuler</button>
            <form method="POST" action="<c:url value='/films/${film.id}/supprimer'/>" style="display:inline;">
                <button type="submit" class="btn btn-danger">Supprimer</button>
            </form>
        </div>
    </div>
</div>

<style>
    .film-detail-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .film-detail-header {
        display: grid;
        grid-template-columns: 300px 1fr;
        gap: 40px;
        margin-bottom: 40px;
    }

    .film-poster-large {
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        height: fit-content;
        position: relative;
    }

    .poster-img {
        width: 100%;
        height: auto;
        display: block;
    }

    .age-badge-overlay {
        position: absolute;
        top: 15px;
        right: 15px;
    }

    .age-badge {
        display: inline-block;
        padding: 8px 16px;
        border-radius: 8px;
        font-weight: 700;
        font-size: 0.875rem;
        color: white;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }

    .badge-all { background: #10b981; }
    .badge-12 { background: #f59e0b; }
    .badge-16 { background: #ef4444; }
    .badge-18 { background: #991b1b; }

    .film-detail-info h1 {
        font-size: 2.5rem;
        margin: 0 0 30px 0;
        color: #1e293b;
        font-weight: 700;
    }

    .film-metadata {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 24px;
        margin-bottom: 30px;
    }

    .metadata-row {
        display: flex;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid #e9ecef;
    }

    .metadata-row:last-child {
        border-bottom: none;
    }

    .metadata-row .label {
        font-weight: 600;
        width: 170px;
        color: #64748b;
        font-size: 0.95rem;
    }

    .metadata-row .value {
        flex: 1;
        color: #1e293b;
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
    }

    .metadata-row .badge-info {
        background: #dbeafe;
        color: #1e40af;
        padding: 4px 12px;
        border-radius: 6px;
        font-size: 0.875rem;
        font-weight: 600;
        margin-right: 6px;
    }

    .film-actions-detail {
        display: flex;
        gap: 15px;
        margin-top: 30px;
    }

    .btn-lg {
        padding: 14px 28px;
        font-size: 1rem;
        font-weight: 600;
        border-radius: 8px;
    }

    .film-description-section {
        margin-bottom: 40px;
        padding: 24px;
        background: #f8f9fa;
        border-radius: 12px;
    }

    .film-description-section h2 {
        font-size: 1.5rem;
        margin-bottom: 15px;
        color: #1e293b;
        font-weight: 700;
    }

    .description-text {
        color: #475569;
        line-height: 1.7;
        font-size: 1.05rem;
    }

    .film-seances-section h2 {
        font-size: 1.5rem;
        margin-bottom: 24px;
        color: #1e293b;
        font-weight: 700;
    }

    .seances-list {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 18px;
    }

    .seance-card {
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 20px;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        height: 100%;
    }

    .seance-card:hover {
        border-color: #3b82f6;
        box-shadow: 0 8px 16px rgba(59,130,246,0.15);
        transform: translateY(-2px);
    }

    .seance-header {
        flex-grow: 1;
        margin-bottom: 15px;
    }

    .seance-date-time,
    .seance-room {
        margin-bottom: 12px;
    }

    .seance-date-time p,
    .seance-room p {
        margin: 8px 0;
        color: #1e293b;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 0.95rem;
    }

    .seance-date-time i,
    .seance-room i {
        color: #003d7a;
        width: 18px;
        text-align: center;
        font-size: 1.05rem;
        flex-shrink: 0;
    }

    .seance-date {
        font-weight: 700;
        color: #003d7a;
        font-size: 1rem;
    }

    .seance-hour {
        font-weight: 600;
        color: #0f172a;
    }

    .seance-salle {
        font-weight: 600;
        color: #1e293b;
    }

    .seance-version {
        font-size: 0.9rem;
        color: #64748b;
        font-weight: 500;
    }

    .seance-footer {
        border-top: 1px solid #e2e8f0;
        padding-top: 12px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
    }

    .seance-places {
        display: flex;
        align-items: center;
    }

    .seance-places .badge {
        padding: 6px 12px;
        border-radius: 6px;
        font-weight: 600;
        font-size: 0.85rem;
        display: flex;
        align-items: center;
        gap: 6px;
        white-space: nowrap;
    }

    .badge-success {
        background: #d1fae5;
        color: #065f46;
    }

    .badge-danger {
        background: #fee2e2;
        color: #991b1b;
    }

    .btn-primary.btn-sm {
        padding: 6px 12px;
        font-size: 0.85rem;
        font-weight: 600;
        border-radius: 6px;
        white-space: nowrap;
        flex-shrink: 0;
    }

    /* Modal styles - CACHÉ PAR DÉFAUT */
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.6);
        z-index: 9999;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(4px);
    }

    .modal-dialog {
        background: white;
        border-radius: 12px;
        max-width: 500px;
        width: 90%;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }

    .modal-header {
        padding: 20px 24px;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-title {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 700;
        color: #dc2626;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .modal-close {
        background: none;
        border: none;
        font-size: 1.5rem;
        color: #64748b;
        cursor: pointer;
        padding: 4px 8px;
        line-height: 1;
        border-radius: 4px;
        transition: all 0.2s;
    }

    .modal-close:hover {
        background: #f1f5f9;
        color: #1e293b;
    }

    .modal-body {
        padding: 24px;
    }

    .modal-body p {
        margin-bottom: 16px;
        color: #1e293b;
        line-height: 1.6;
    }

    .text-danger {
        color: #dc2626;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .modal-footer {
        padding: 16px 24px;
        border-top: 1px solid #e2e8f0;
        display: flex;
        gap: 12px;
        justify-content: flex-end;
    }

    @media (max-width: 768px) {
        .film-detail-header {
            grid-template-columns: 1fr;
        }

        .film-poster-large {
            max-width: 300px;
            margin: 0 auto;
        }

        .film-detail-info h1 {
            font-size: 2rem;
            text-align: center;
        }

        .film-actions-detail {
            flex-direction: column;
        }

        .seances-list {
            grid-template-columns: 1fr;
        }
    }
</style>

<script>
function openDeleteModal() {
    document.getElementById('deleteModal').style.display = 'flex';
}

function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
}

// Fermer avec Escape
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeDeleteModal();
    }
});
</script>