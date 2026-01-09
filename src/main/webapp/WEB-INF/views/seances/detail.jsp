<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!-- MESSAGES D'ALERTE ET DE SUCCÈS -->
<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i> ${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle"></i> ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="content-header">
    <div class="header-nav">
        <a href="<c:url value='/films'/>" class="btn btn-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Retour aux films
        </a>
    </div>
</div>

<div class="seance-reservation-container">
    <!-- EN-TÊTE SÉANCE -->
    <div class="seance-header-info">
        <div class="film-info">
            <h1>${seance.film.titre}</h1>
            <div class="seance-details">
                <span class="detail-item">
                    <i class="fas fa-calendar-alt"></i>
                    ${seance.dateSeanceFormatted}
                </span>
                <span class="detail-item">
                    <i class="fas fa-clock"></i>
                    ${seance.heureDebutFormatted}
                </span>
                <span class="detail-item">
                    <i class="fas fa-door-open"></i>
                    ${seance.salle.nom}
                </span>
                <c:if test="${not empty seance.versionLangue}">
                    <span class="detail-item">
                        <i class="fas fa-closed-captioning"></i>
                        ${seance.versionLangue.libelle}
                    </span>
                </c:if>
            </div>
        </div>
        
        <div class="occupation-stats">
            <div class="stat">
                <div class="stat-number" style="color: #10b981;">${placesDispoCount}</div>
                <div class="stat-label">Places disponibles</div>
            </div>
            <div class="stat">
                <div class="stat-number" style="color: #ef4444;">${placesReserveeCount}</div>
                <div class="stat-label">Places réservées</div>
            </div>
            <div class="stat">
                <div class="stat-number" style="color: #3b82f6;">${tauxOccupation}%</div>
                <div class="stat-label">Taux d'occupation</div>
            </div>
        </div>
    </div>

    <!-- FORMULAIRE DE RÉSERVATION -->
    <form method="POST" action="<c:url value='/tickets/acheter'/>" id="reservationForm" class="reservation-form">
        <input type="hidden" name="seanceId" value="${seance.id}">
        
        <!-- ÉCRAN -->
        <div class="seance-screen">
            <div class="screen-label">ÉCRAN</div>
        </div>

        <!-- TARIFS PAR TYPE DE PLACE -->
        <c:if test="${not empty tarifs}">
            <div class="seance-place-types">
                <h3>Tarifs par type de place</h3>
                <div class="place-types-grid">
                    <c:forEach var="tarif" items="${tarifs}">
                        <div class="place-type-card">
                            <div class="type-name">${tarif.typePlace.libelle}</div>
                            <div class="type-price">${tarif.prix}€</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- PLAN DE SALLE -->
        <div class="seance-plan">
            <div class="plan-legend">
                <div class="legend-item">
                    <span class="place-preview place-libre"></span>
                    <span>Place disponible</span>
                </div>
                <div class="legend-item">
                    <span class="place-preview place-reservee"></span>
                    <span>Place réservée</span>
                </div>
                <div class="legend-item">
                    <span class="place-preview place-selectionnee"></span>
                    <span>Place sélectionnée</span>
                </div>
            </div>

            <div class="places-grid">
                <c:forEach var="rangeeEntry" items="${placesParRangee}">
                    <div class="rangee-row">
                        <div class="rangee-label">${rangeeEntry.key}</div>
                        <div class="places-row">
                            <c:forEach var="place" items="${rangeeEntry.value}">
                                <c:set var="isReservee" value="${placesReservees.contains(place)}" />
                                <c:set var="typeLabel" value="${place.typePlace.libelle != null ? place.typePlace.libelle : 'Standard'}" />
                                <c:set var="prix" value="${prixParTypePlace[place.typePlace.id]}" />
                                
                                <c:choose>
                                    <c:when test="${isReservee}">
                                        <button type="button" class="place place-reservee" 
                                                title="${typeLabel}" disabled>
                                            ${place.numero}
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <label class="place-label" title="${typeLabel} - ${prix}€">
                                            <input type="checkbox" 
                                                   name="placeIds" 
                                                   value="${place.id}" 
                                                   class="place-checkbox"
                                                   onchange="updateSelection()"
                                                   data-price="${prix}"
                                                   data-type="${typeLabel}">
                                            <span class="place place-libre" title="Disponible">
                                                ${place.numero}
                                            </span>
                                        </label>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- RÉSUMÉ ET BOUTONS -->
        <div class="reservation-summary">
            <div class="summary-box">
                <h3>Résumé de votre sélection</h3>
                <div class="summary-item">
                    <span class="label">Places sélectionnées :</span>
                    <span class="value" id="selectedPlacesDisplay">Aucune</span>
                </div>
                <div class="summary-item">
                    <span class="label">Nombre de places :</span>
                    <span class="value" id="selectedCountDisplay">0</span>
                </div>
                <div class="summary-item total">
                    <span class="label">Montant estimé :</span>
                    <span class="value" id="estimatedTotalDisplay">0,00 €</span>
                </div>
                <p class="note-info">
                    <i class="fas fa-info-circle"></i>
                    Prix unitaire : À confirmer lors du paiement
                </p>
            </div>

            <div class="reservation-actions">
                <button type="reset" class="btn btn-secondary" onclick="resetForm()">
                    <i class="fas fa-redo"></i> Réinitialiser
                </button>
                <a href="<c:url value='/films'/>" class="btn btn-outline">
                    <i class="fas fa-times"></i> Annuler
                </a>
                <button type="button" class="btn btn-primary btn-lg" id="submitBtn" disabled onclick="showConfirmationModal()">
                    <i class="fas fa-shopping-cart"></i> Continuer <span id="submitCount"></span>
                </button>
            </div>
        </div>
    </form>
</div>

<!-- MODAL DE CONFIRMATION AVEC INFOS CLIENT -->
<div class="modal fade" id="confirmationModal" tabindex="-1" role="dialog" aria-labelledby="confirmationModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmationModalLabel">
                    <i class="fas fa-user-check"></i> Confirmer votre réservation
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="clientForm">
                    <div class="form-group mb-3">
                        <label for="nomComplet" class="form-label">
                            <i class="fas fa-user"></i> Nom complet <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="nomComplet" name="nomComplet" required placeholder="Jean Dupont">
                    </div>
                    <div class="form-group mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope"></i> Email
                        </label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="jean@example.com">
                    </div>
                    <div class="form-group mb-3">
                        <label for="telephone" class="form-label">
                            <i class="fas fa-phone"></i> Téléphone
                        </label>
                        <input type="tel" class="form-control" id="telephone" name="telephone" placeholder="+33 6 12 34 56 78">
                    </div>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> Ces informations nous permettront de vous contacter en cas de besoin.
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-primary" onclick="submitReservation()">
                    <i class="fas fa-check"></i> Confirmer la réservation
                </button>
            </div>
        </div>
    </div>
</div>

<style>
            </div>
        </div>

        <div class="detail-card">
            <div class="card-header">
                <h3>Salle et configuration</h3>
            </div>
            <div class="card-body">
                <div class="info-group">
                    <label>Salle:</label>
                    <p>
                        <a href="<c:url value='/salles/${seance.salle.id}'/>" class="link">
                            <strong>${seance.salle.nom}</strong>
                        </a>
                    </p>
                </div>
                <div class="info-group">
                    <label>Capacité:</label>
                    <p>${seance.salle.capacite} places</p>
                </div>
                <div class="info-group">
                    <label>Statut:</label>
                    <p>
                        <c:choose>
                            <c:when test="${seance.estDisponible()}">
                                <span class="badge badge-success">Disponible</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger">Passée</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <c:if test="${not empty seance.versionLangue}">
                    <div class="info-group">
                        <label>Version langue:</label>
                        <p>${seance.versionLangue.libelle}</p>
                    </div>
                </c:if>
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
                    <label>ID séance:</label>
                    <p class="text-muted">${seance.id}</p>
                </div>
                <div class="info-group">
                    <label>Créée le:</label>
                    <p class="text-muted">${createdAtFormatted}</p>
                </div>
            </div>
        </div>

        <div class="detail-card">
            <div class="card-header">
                <h3>Actions</h3>
            </div>
            <div class="card-body">
                <p>
                    <a href="<c:url value='/places?salle=${seance.salle.id}'/>" class="btn btn-sm btn-outline-primary btn-block">
                        <i class="fas fa-chair"></i> Voir les places
                    </a>
                </p>
                <p>
                    <a href="<c:url value='/films/${seance.film.id}'/>" class="btn btn-sm btn-outline-info btn-block">
                        <i class="fas fa-film"></i> Détails du film
                    </a>
                </p>
            </div>
        </div>
    </div>
</div>

<style>
    .seance-reservation-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .content-header {
        margin-bottom: 30px;
    }

    /* ALERTES */
    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 500;
        animation: slideDown 0.3s ease-out;
    }

    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .alert-success {
        background: #d1fae5;
        color: #065f46;
        border-left: 4px solid #10b981;
    }

    .alert-danger {
        background: #fee2e2;
        color: #991b1b;
        border-left: 4px solid #ef4444;
    }

    .alert i {
        font-size: 1.2rem;
    }

    .btn-close {
        background: transparent;
        border: none;
        cursor: pointer;
        font-size: 1.2rem;
        margin-left: auto;
        opacity: 0.7;
        transition: opacity 0.2s;
    }

    .btn-close:hover {
        opacity: 1;
    }

    /* TARIFS PAR TYPE */
    .seance-place-types {
        margin-bottom: 30px;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
        border-left: 4px solid #003d7a;
    }

    .seance-place-types h3 {
        margin: 0 0 15px 0;
        color: #003d7a;
        font-weight: 700;
    }

    .place-types-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 15px;
    }

    .place-type-card {
        background: white;
        padding: 15px;
        border-radius: 6px;
        border: 2px solid #e0e0e0;
        text-align: center;
        transition: all 0.2s ease;
    }

    .place-type-card:hover {
        border-color: #003d7a;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.1);
    }

    .type-name {
        font-weight: 600;
        color: #1e293b;
        font-size: 0.95rem;
        margin-bottom: 8px;
    }

    .type-price {
        font-size: 1.3rem;
        font-weight: 700;
        color: #10b981;
    }

    /* EN-TÊTE SÉANCE */
    .seance-header-info {
        display: grid;
        grid-template-columns: 1fr auto;
        gap: 30px;
        margin-bottom: 40px;
        padding-bottom: 30px;
        border-bottom: 2px solid #e2e8f0;
    }

    .film-info h1 {
        font-size: 2rem;
        margin: 0 0 15px 0;
        color: #003d7a;
        font-weight: 700;
    }

    .seance-details {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }

    .detail-item {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #1e293b;
        font-weight: 500;
    }

    .detail-item i {
        color: #003d7a;
        font-size: 1.1rem;
    }

    /* STATISTIQUES */
    .occupation-stats {
        display: flex;
        gap: 20px;
        justify-content: flex-end;
    }

    .stat {
        text-align: center;
    }

    .stat-number {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 5px;
    }

    .stat-label {
        font-size: 0.85rem;
        color: #64748b;
        font-weight: 500;
    }

    /* ÉCRAN */
    .seance-screen {
        text-align: center;
        margin-bottom: 40px;
        padding: 20px;
        background: linear-gradient(135deg, #003d7a 0%, #0055b0 100%);
        border-radius: 8px;
        color: white;
    }

    .screen-label {
        font-size: 1.3rem;
        font-weight: 700;
        letter-spacing: 2px;
    }

    /* LÉGENDE */
    .plan-legend {
        display: flex;
        justify-content: center;
        gap: 30px;
        margin-bottom: 30px;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
    }

    .legend-item {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 0.9rem;
        color: #1e293b;
    }

    .place-preview {
        width: 25px;
        height: 25px;
        border-radius: 4px;
        display: inline-block;
    }

    .place-libre {
        background: #d1fae5;
        border: 2px solid #10b981;
    }

    .place-reservee {
        background: #fee2e2;
        border: 2px solid #ef4444;
    }

    .place-selectionnee {
        background: #dbeafe;
        border: 2px solid #3b82f6;
    }

    /* PLAN DE SALLE */
    .seance-plan {
        margin-bottom: 40px;
    }

    .places-grid {
        display: flex;
        flex-direction: column;
        gap: 15px;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
    }

    .rangee-row {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .rangee-label {
        width: 40px;
        text-align: center;
        font-weight: 700;
        color: #003d7a;
        font-size: 0.95rem;
    }

    .places-row {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
        justify-content: center;
        flex-grow: 1;
    }

    /* PLACES */
    .place {
        width: 40px;
        height: 40px;
        padding: 0;
        border: 2px solid #ccc;
        border-radius: 4px;
        background: #d1fae5;
        color: #065f46;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        font-size: 0.85rem;
    }

    .place:hover:not(:disabled) {
        transform: scale(1.1);
        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        border-color: #10b981;
    }

    .place-reservee {
        background: #fee2e2;
        color: #991b1b;
        border-color: #ef4444;
        cursor: not-allowed;
        opacity: 0.6;
    }

    .place-label {
        cursor: pointer;
    }

    .place-checkbox {
        display: none;
    }

    .place-checkbox:checked + .place {
        background: #dbeafe;
        border-color: #3b82f6;
        color: #1e40af;
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }

    /* RÉSUMÉ ET BOUTONS */
    .reservation-summary {
        display: grid;
        grid-template-columns: 1fr auto;
        gap: 30px;
        padding: 25px;
        background: #f8f9fa;
        border-radius: 8px;
        border: 2px solid #e2e8f0;
    }

    .summary-box h3 {
        margin: 0 0 20px 0;
        font-size: 1.1rem;
        color: #003d7a;
        font-weight: 700;
    }

    .summary-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid #e2e8f0;
    }

    .summary-item.total {
        border-bottom: none;
        padding-top: 15px;
        border-top: 2px solid #e2e8f0;
        font-size: 1.1rem;
        font-weight: 700;
        color: #003d7a;
    }

    .summary-item .label {
        color: #64748b;
        font-weight: 600;
    }

    .summary-item .value {
        color: #1e293b;
        font-weight: 700;
        font-size: 1.05rem;
    }

    .note-info {
        margin-top: 15px;
        padding: 10px;
        background: #eff6ff;
        border-left: 4px solid #3b82f6;
        color: #1e40af;
        font-size: 0.9rem;
        border-radius: 4px;
    }

    .note-info i {
        margin-right: 5px;
    }

    .reservation-actions {
        display: flex;
        flex-direction: column;
        gap: 12px;
        justify-content: flex-end;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 0.95rem;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
        text-align: center;
        justify-content: center;
    }

    .btn:hover:not(:disabled) {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .btn-primary {
        background: #003d7a;
        color: white;
    }

    .btn-primary:hover:not(:disabled) {
        background: #002d5a;
    }

    .btn-primary:disabled {
        background: #cbd5e1;
        color: #94a3b8;
        cursor: not-allowed;
    }

    .btn-secondary {
        background: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background: #545b62;
    }

    .btn-outline {
        background: white;
        color: #003d7a;
        border: 2px solid #003d7a;
    }

    .btn-outline:hover {
        background: #f8f9fa;
    }

    .btn-lg {
        padding: 14px 28px;
        font-size: 1.05rem;
    }

    .btn-sm {
        padding: 8px 16px;
        font-size: 0.85rem;
    }

    /* MODAL */
    .modal-content {
        border-radius: 8px;
        border: 1px solid #e2e8f0;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    }

    .modal-header {
        background: linear-gradient(135deg, #003d7a 0%, #0055b0 100%);
        color: white;
        border-bottom: none;
        border-radius: 8px 8px 0 0;
    }

    .modal-header .modal-title {
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .modal-body {
        padding: 25px;
    }

    .form-group label {
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .form-group label i {
        color: #003d7a;
    }

    .form-control {
        border: 2px solid #e2e8f0;
        border-radius: 6px;
        padding: 10px 12px;
        font-size: 0.95rem;
        transition: all 0.2s ease;
    }

    .form-control:focus {
        border-color: #003d7a;
        box-shadow: 0 0 0 3px rgba(0, 61, 122, 0.1);
        outline: none;
    }

    .form-control::placeholder {
        color: #cbd5e1;
    }

    .text-danger {
        color: #ef4444;
    }

    .modal-footer {
        border-top: 1px solid #e2e8f0;
        padding: 15px 25px;
    }

    .alert-info {
        background: #eff6ff;
        border-left: 4px solid #3b82f6;
        color: #1e40af;
        margin-bottom: 0;
    }

    @media (max-width: 768px) {
        .seance-header-info {
            grid-template-columns: 1fr;
        }

        .occupation-stats {
            justify-content: flex-start;
            grid-column: 1;
        }

        .seance-details {
            flex-direction: column;
            gap: 10px;
        }

        .plan-legend {
            flex-direction: column;
            gap: 15px;
        }

        .rangee-row {
            flex-direction: column;
            gap: 10px;
        }

        .reservation-summary {
            grid-template-columns: 1fr;
        }

        .place {
            width: 35px;
            height: 35px;
            font-size: 0.75rem;
        }
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updateSelection() {
        const checkboxes = document.querySelectorAll('input[name="placeIds"]:checked');
        const selectedCount = checkboxes.length;
        const submitBtn = document.getElementById('submitBtn');
        
        // Récupérer les numéros des places sélectionnées avec leur type
        let placesSelected = [];
        let totalPrice = 0;
        
        checkboxes.forEach(cb => {
            const placeLabel = cb.closest('.place-label');
            const placeSpan = cb.nextElementSibling;
            const placeNum = placeSpan ? placeSpan.textContent.trim() : '';
            const price = parseFloat(cb.getAttribute('data-price')) || 12.0;
            const type = cb.getAttribute('data-type') || 'Standard';
            
            if (placeNum) {
                placesSelected.push(`${placeNum} (${type})`);
            }
            totalPrice += price;
        });

        // Mettre à jour l'affichage
        document.getElementById('selectedCountDisplay').textContent = selectedCount;
        document.getElementById('selectedPlacesDisplay').textContent = 
            selectedCount > 0 ? placesSelected.join(', ') : 'Aucune';
        document.getElementById('estimatedTotalDisplay').textContent = 
            totalPrice.toFixed(2) + ' €';

        // Activer/désactiver le bouton soumettre
        submitBtn.disabled = selectedCount === 0;
        document.getElementById('submitCount').textContent = 
            selectedCount > 0 ? `(${selectedCount})` : '';
    }

    function resetForm() {
        document.getElementById('reservationForm').reset();
        updateSelection();
    }

    function showConfirmationModal() {
        const checkboxes = document.querySelectorAll('input[name="placeIds"]:checked');
        if (checkboxes.length === 0) {
            alert('Veuillez sélectionner au moins une place');
            return;
        }
        // Afficher le modal Bootstrap
        const modal = new bootstrap.Modal(document.getElementById('confirmationModal'));
        modal.show();
    }

    function submitReservation() {
        // Valider le formulaire client
        const nomComplet = document.getElementById('nomComplet').value.trim();
        if (!nomComplet) {
            alert('Le nom est requis');
            return;
        }

        // Créer un formulaire caché et l'envoyer
        const form = document.getElementById('reservationForm');
        
        // Ajouter les champs du client
        const nomInput = document.createElement('input');
        nomInput.type = 'hidden';
        nomInput.name = 'nomComplet';
        nomInput.value = nomComplet;
        form.appendChild(nomInput);

        const emailInput = document.createElement('input');
        emailInput.type = 'hidden';
        emailInput.name = 'email';
        emailInput.value = document.getElementById('email').value;
        form.appendChild(emailInput);

        const telephoneInput = document.createElement('input');
        telephoneInput.type = 'hidden';
        telephoneInput.name = 'telephone';
        telephoneInput.value = document.getElementById('telephone').value;
        form.appendChild(telephoneInput);

        // Soumettre le formulaire
        form.submit();
    }

    // Initialiser à la page
    document.addEventListener('DOMContentLoaded', function() {
        updateSelection();
        
        // Charger Bootstrap CSS si nécessaire
        if (!document.querySelector('link[href*="bootstrap"]')) {
            const link = document.createElement('link');
            link.rel = 'stylesheet';
            link.href = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css';
            document.head.appendChild(link);
        }
    });
</script>
