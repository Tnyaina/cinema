<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="content-header">
    <a href="<c:url value='/films'/>" class="btn btn-back">
        <i class="fas fa-arrow-left"></i> Retour
    </a>
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
                    <span class="label">Durée</span>
                    <span class="value">
                        <i class="fas fa-clock"></i> ${film.dureeMinutes} minutes
                    </span>
                </div>

                <div class="metadata-row">
                    <span class="label">Date de sortie</span>
                    <span class="value">
                        <i class="fas fa-calendar"></i> ${film.dateSortieFormatted}
                    </span>
                </div>

                <div class="metadata-row">
                    <span class="label">Âge minimum</span>
                    <span class="value">
                        ${film.ageMin}+
                    </span>
                </div>

                <c:if test="${not empty film.langueOriginale}">
                    <div class="metadata-row">
                        <span class="label">Langue originale</span>
                        <span class="value">
                            <i class="fas fa-language"></i> ${film.langueOriginale.libelle}
                        </span>
                    </div>
                </c:if>

                <c:if test="${not empty film.genres}">
                    <div class="metadata-row">
                        <span class="label">Genres</span>
                        <span class="value genres-list">
                            <c:forEach var="genre" items="${film.genres}" varStatus="status">
                                <span class="genre-tag">${genre.libelle}</span>
                            </c:forEach>
                        </span>
                    </div>
                </c:if>
            </div>

            <div class="film-actions-detail">
                <a href="<c:url value='/films/${film.id}/modifier'/>" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Modifier
                </a>
                <button type="button" class="btn btn-danger" onclick="openDeleteModal()">
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
                                        ${seance.dateSeanceFormatted}
                                    </p>
                                    <p class="seance-hour">
                                        <i class="fas fa-clock"></i>
                                        ${seance.heureDebutFormatted}
                                        <c:if test="${not empty seance.fin}">
                                            - ${seance.heureFin}
                                        </c:if>
                                    </p>
                                </div>
                                <div class="seance-room">
                                    <p class="seance-salle">
                                        <i class="fas fa-door-open"></i>
                                        ${seance.salle.nom}
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
                                            <span class="badge-places available">
                                                <i class="fas fa-chair"></i>
                                                ${seance.placesDisponibles} place<c:if test="${seance.placesDisponibles > 1}">s</c:if>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-places full">
                                                <i class="fas fa-ban"></i>
                                                Complet
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${seance.placesDisponibles > 0}">
                                    <a href="<c:url value='/seances/${seance.id}'/>" class="btn btn-view">
                                        <i class="fas fa-eye"></i> Voir
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-info-circle"></i>
                    Aucune séance disponible pour ce film actuellement.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- MODAL SUPPRESSION -->
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
            <p class="warning-text">
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
    .content-header {
        margin-bottom: 24px;
    }

    .btn {
        padding: 10px 20px;
        border-radius: 6px;
        text-decoration: none;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border: none;
        transition: all 0.15s;
        font-weight: 500;
    }

    .btn-back {
        background-color: #f3f4f6;
        color: #374151;
    }

    .btn-back:hover {
        background-color: #e5e7eb;
    }

    .btn-primary {
        background-color: #003d7a;
        color: white;
    }

    .btn-primary:hover {
        background-color: #002952;
    }

    .btn-danger {
        background-color: #dc2626;
        color: white;
    }

    .btn-danger:hover {
        background-color: #b91c1c;
    }

    .btn-secondary {
        background-color: #6b7280;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #4b5563;
    }

    .btn-view {
        background-color: #003d7a;
        color: white;
        padding: 8px 14px;
        font-size: 13px;
    }

    .btn-view:hover {
        background-color: #002952;
    }

    .film-detail-container {
        background: white;
        border-radius: 8px;
        padding: 32px;
        border: 1px solid #e5e7eb;
    }

    .film-detail-header {
        display: grid;
        grid-template-columns: 280px 1fr;
        gap: 32px;
        margin-bottom: 32px;
    }

    .film-poster-large {
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
        top: 12px;
        right: 12px;
    }

    .age-badge {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 6px;
        font-weight: 600;
        font-size: 13px;
        color: white;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }

    .badge-all { background: #10b981; }
    .badge-12 { background: #f59e0b; }
    .badge-16 { background: #ef4444; }
    .badge-18 { background: #991b1b; }

    .film-detail-info h1 {
        font-size: 32px;
        margin: 0 0 24px 0;
        color: #111827;
        font-weight: 600;
    }

    .film-metadata {
        background: #f9fafb;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 24px;
    }

    .metadata-row {
        display: flex;
        align-items: flex-start;
        padding: 10px 0;
        border-bottom: 1px solid #e5e7eb;
    }

    .metadata-row:last-child {
        border-bottom: none;
        padding-bottom: 0;
    }

    .metadata-row:first-child {
        padding-top: 0;
    }

    .metadata-row .label {
        font-weight: 500;
        width: 150px;
        color: #6b7280;
        font-size: 14px;
    }

    .metadata-row .value {
        flex: 1;
        color: #111827;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
    }

    .metadata-row .value i {
        color: #003d7a;
        width: 16px;
        flex-shrink: 0;
    }

    .genres-list {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
    }

    .genre-tag {
        background: #dbeafe;
        color: #003d7a;
        padding: 4px 10px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: 500;
    }

    .film-actions-detail {
        display: flex;
        gap: 12px;
        margin-top: 24px;
    }

    .film-description-section {
        margin-bottom: 32px;
        padding: 20px;
        background: #f9fafb;
        border-radius: 8px;
    }

    .film-description-section h2 {
        font-size: 20px;
        margin-bottom: 12px;
        color: #111827;
        font-weight: 600;
    }

    .description-text {
        color: #374151;
        line-height: 1.6;
        font-size: 15px;
        margin: 0;
    }

    .film-seances-section h2 {
        font-size: 20px;
        margin-bottom: 20px;
        color: #111827;
        font-weight: 600;
    }

    .seances-list {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
        gap: 16px;
    }

    .seance-card {
        background: white;
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        padding: 16px;
        transition: all 0.2s ease;
        display: flex;
        flex-direction: column;
        height: 100%;
    }

    .seance-card:hover {
        border-color: #003d7a;
        box-shadow: 0 4px 12px rgba(0, 61, 122, 0.1);
    }

    .seance-header {
        flex-grow: 1;
        margin-bottom: 12px;
    }

    .seance-date-time,
    .seance-room {
        margin-bottom: 10px;
    }

    .seance-date-time p,
    .seance-room p {
        margin: 6px 0;
        color: #111827;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
    }

    .seance-date-time i,
    .seance-room i {
        color: #003d7a;
        width: 16px;
        text-align: center;
        flex-shrink: 0;
    }

    .seance-date {
        font-weight: 600;
        color: #003d7a;
    }

    .seance-hour {
        font-weight: 500;
        color: #374151;
    }

    .seance-salle {
        font-weight: 500;
        color: #111827;
    }

    .seance-version {
        font-size: 13px;
        color: #6b7280;
        font-weight: 400;
    }

    .seance-footer {
        border-top: 1px solid #e5e7eb;
        padding-top: 12px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 10px;
    }

    .badge-places {
        padding: 6px 10px;
        border-radius: 4px;
        font-weight: 500;
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 6px;
        white-space: nowrap;
    }

    .badge-places.available {
        background: #d1fae5;
        color: #065f46;
    }

    .badge-places.full {
        background: #fee2e2;
        color: #991b1b;
    }

    .empty-state {
        padding: 32px 24px;
        text-align: center;
        color: #6b7280;
        background: #f9fafb;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    /* Modal styles */
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(2px);
    }

    .modal-dialog {
        background: white;
        border-radius: 8px;
        max-width: 500px;
        width: 90%;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }

    .modal-header {
        padding: 20px 24px;
        border-bottom: 1px solid #e5e7eb;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-title {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        color: #dc2626;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .modal-close {
        background: none;
        border: none;
        font-size: 24px;
        color: #6b7280;
        cursor: pointer;
        padding: 4px 8px;
        line-height: 1;
        border-radius: 4px;
        transition: all 0.15s;
    }

    .modal-close:hover {
        background: #f3f4f6;
        color: #111827;
    }

    .modal-body {
        padding: 24px;
    }

    .modal-body p {
        margin-bottom: 12px;
        color: #374151;
        line-height: 1.5;
    }

    .warning-text {
        color: #dc2626;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .modal-footer {
        padding: 16px 24px;
        border-top: 1px solid #e5e7eb;
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }

    @media (max-width: 768px) {
        .film-detail-header {
            grid-template-columns: 1fr;
        }

        .film-poster-large {
            max-width: 280px;
            margin: 0 auto;
        }

        .film-detail-info h1 {
            font-size: 24px;
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