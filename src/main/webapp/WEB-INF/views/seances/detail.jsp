<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<link rel="stylesheet" href="<c:url value='/css/cinema-detail.css'/>">

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
            <div class="stat">
                <div class="stat-number" style="color: #f59e0b;"><fmt:formatNumber value="${chiffresAffaires}" type="number" maxFractionDigits="2"/>€</div>
                <div class="stat-label">Chiffre d'affaires</div>
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
                <h3><i class="fas fa-tags"></i> Tarifs par type de place</h3>
                <div class="place-types-grid">
                    <c:forEach var="tarif" items="${tarifs}">
                        <div class="place-type-card" data-type="${tarif.typePlace.libelle}">
                            <div class="type-icon">
                                <c:choose>
                                    <c:when test="${tarif.typePlace.libelle == 'VIP'}">
                                        <i class="fas fa-star"></i>
                                    </c:when>
                                    <c:when test="${tarif.typePlace.libelle == 'Premium'}">
                                        <i class="fas fa-crown"></i>
                                    </c:when>
                                    <c:when test="${tarif.typePlace.libelle == 'Handicapé'}">
                                        <i class="fas fa-wheelchair"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-chair"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="type-name">${tarif.typePlace.libelle}</div>
                            <div class="type-price">${tarif.prix}€</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- PLAN DE SALLE AMÉLIORÉ -->
        <div class="seance-plan">
            <h3 class="plan-title"><i class="fas fa-th"></i> Plan de la salle</h3>
            
            <div class="plan-legend">
                <div class="legend-item">
                    <span class="place-preview place-libre"></span>
                    <span>Disponible</span>
                </div>
                <div class="legend-item">
                    <span class="place-preview place-reservee"></span>
                    <span>Réservée</span>
                </div>
                <div class="legend-item">
                    <span class="place-preview place-selectionnee"></span>
                    <span>Sélectionnée</span>
                </div>
                
                <!-- Légende par type de place -->
                <div class="legend-separator"></div>
                <c:if test="${not empty tarifs}">
                    <c:forEach var="tarif" items="${tarifs}">
                        <div class="legend-item legend-type" data-type="${tarif.typePlace.libelle}">
                            <span class="place-preview place-type-${tarif.typePlace.libelle}"></span>
                            <span>${tarif.typePlace.libelle}</span>
                        </div>
                    </c:forEach>
                </c:if>
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
                                        <button type="button" 
                                                class="place place-reservee place-type-${typeLabel}" 
                                                title="${typeLabel} - Réservée" 
                                                disabled>
                                            <span class="place-numero">${place.numero}</span>
                                            <span class="place-type-label">${typeLabel}</span>
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
                                                   data-type="${typeLabel}"
                                                   data-numero="${place.numero}"
                                                   data-rangee="${place.rangee}">
                                            <span class="place place-libre place-type-${typeLabel}">
                                                <span class="place-numero">${place.numero}</span>
                                                <span class="place-type-label">${typeLabel}</span>
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
                <h3><i class="fas fa-receipt"></i> Résumé de votre sélection</h3>
                <div class="summary-item">
                    <span class="label">Places sélectionnées :</span>
                    <span class="value" id="selectedPlacesDisplay">Aucune</span>
                </div>
                <div class="summary-item">
                    <span class="label">Nombre de places :</span>
                    <span class="value" id="selectedCountDisplay">0</span>
                </div>
                <div class="summary-details" id="summaryDetails">
                    <!-- Les détails par type seront ajoutés ici dynamiquement -->
                </div>
                <div class="summary-item total">
                    <span class="label">Montant total :</span>
                    <span class="value" id="estimatedTotalDisplay">0,00 €</span>
                </div>
                <p class="note-info">
                    <i class="fas fa-info-circle"></i>
                    Le montant sera confirmé lors du paiement
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
                <div class="reservation-recap">
                    <h6><i class="fas fa-ticket-alt"></i> Récapitulatif</h6>
                    <div id="modalRecapContent"></div>
                </div>
                <hr>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let selectedPlaces = [];

    function updateSelection() {
        const checkboxes = document.querySelectorAll('input[name="placeIds"]:checked');
        const selectedCount = checkboxes.length;
        const submitBtn = document.getElementById('submitBtn');
        
        selectedPlaces = [];
        let totalPrice = 0;
        let placesByType = {};
        
        checkboxes.forEach(cb => {
            const placeNum = cb.getAttribute('data-numero');
            const rangee = cb.getAttribute('data-rangee');
            const price = parseFloat(cb.getAttribute('data-price')) || 12.0;
            const type = cb.getAttribute('data-type') || 'Standard';
            
            const placeInfo = {
                numero: placeNum,
                rangee: rangee,
                type: type,
                price: price
            };
            
            selectedPlaces.push(placeInfo);
            totalPrice += price;
            
            // Grouper par type
            if (!placesByType[type]) {
                placesByType[type] = {
                    count: 0,
                    total: 0,
                    places: []
                };
            }
            placesByType[type].count++;
            placesByType[type].total += price;
            placesByType[type].places.push(`${rangee}${placeNum}`);
        });

        // Affichage des places sélectionnées
        const placesDisplay = selectedPlaces.map(p => `${p.rangee}${p.numero}`).join(', ');
        document.getElementById('selectedCountDisplay').textContent = selectedCount;
        document.getElementById('selectedPlacesDisplay').textContent = 
            selectedCount > 0 ? placesDisplay : 'Aucune';
        
        // Affichage des détails par type
        const summaryDetails = document.getElementById('summaryDetails');
        if (selectedCount > 0) {
            let detailsHtml = '';
            for (const [type, info] of Object.entries(placesByType)) {
                detailsHtml += `
                    <div class="summary-detail-item">
                        <span class="label">${type} (${info.count}x):</span>
                        <span class="value">${info.total.toFixed(2)} €</span>
                    </div>
                `;
            }
            summaryDetails.innerHTML = detailsHtml;
        } else {
            summaryDetails.innerHTML = '';
        }
        
        document.getElementById('estimatedTotalDisplay').textContent = 
            totalPrice.toFixed(2) + ' €';

        // Activer/désactiver le bouton soumettre
        submitBtn.disabled = selectedCount === 0;
        document.getElementById('submitCount').textContent = 
            selectedCount > 0 ? `(${selectedCount})` : '';
    }

    function resetForm() {
        document.getElementById('reservationForm').reset();
        selectedPlaces = [];
        updateSelection();
    }

    function showConfirmationModal() {
        const checkboxes = document.querySelectorAll('input[name="placeIds"]:checked');
        if (checkboxes.length === 0) {
            alert('Veuillez sélectionner au moins une place');
            return;
        }
        
        // Créer le récapitulatif pour le modal
        let totalPrice = 0;
        let recapHtml = '';
        let placesByType = {};
        
        selectedPlaces.forEach(place => {
            totalPrice += place.price;
            if (!placesByType[place.type]) {
                placesByType[place.type] = {
                    count: 0,
                    total: 0,
                    places: []
                };
            }
            placesByType[place.type].count++;
            placesByType[place.type].total += place.price;
            placesByType[place.type].places.push(`${place.rangee}${place.numero}`);
        });
        
        for (const [type, info] of Object.entries(placesByType)) {
            recapHtml += `
                <div class="recap-item">
                    <span><strong>${type}</strong> (${info.count}x): ${info.places.join(', ')}</span>
                    <span>${info.total.toFixed(2)} €</span>
                </div>
            `;
        }
        
        recapHtml += `
            <div class="recap-item">
                <span><strong>Total</strong></span>
                <span><strong>${totalPrice.toFixed(2)} €</strong></span>
            </div>
        `;
        
        document.getElementById('modalRecapContent').innerHTML = recapHtml;
        
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