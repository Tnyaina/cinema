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
        <c:if test="${seance.statut == 'Disponible'}">
            <form method="POST" action="<c:url value='/seances/${seance.id}/terminer'/>" style="display: inline;">
                <button type="submit" class="btn btn-warning btn-sm" onclick="return confirm('Etes-vous sur de vouloir marquer cette seance comme terminee ?');">
                    <i class="fas fa-check-circle"></i> Terminer la seance
                </button>
            </form>
        </c:if>
        <c:if test="${seance.statut != 'Disponible'}">
            <span class="badge bg-warning text-dark">
                <i class="fas fa-info-circle"></i> Seance ${seance.statut}
            </span>
        </c:if>
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

        <!-- TARIFS PAR TYPE DE PLACE ET CATÉGORIE PERSONNE -->
        <c:if test="${not empty tarifsCombines}">
            <div class="seance-place-types">
                <h3><i class="fas fa-tags"></i> Tarifs par type de place et catégorie</h3>
                <div class="tariffs-table-wrapper">
                    <table class="tariffs-table">
                        <thead>
                            <tr>
                                <th>Type de place</th>
                                <c:forEach var="cat" items="${categoriesPersonne}">
                                    <th>${cat.libelle}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entry" items="${tarifsCombines}">
                                <tr>
                                    <td class="type-label">${entry.key}</td>
                                    <c:forEach var="cat" items="${categoriesPersonne}">
                                        <td class="price-cell">${entry.value[cat.libelle]}€</td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
                                        <button type="button" 
                                                class="place place-libre place-type-${typeLabel} place-button" 
                                                data-place-id="${place.id}"
                                                data-place-numero="${place.numero}"
                                                data-place-rangee="${place.rangee}"
                                                data-place-type="${typeLabel}"
                                                onclick="openCategoryModal(this)">
                                            <span class="place-numero">${place.numero}</span>
                                            <span class="place-type-label">${typeLabel}</span>
                                        </button>
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
                <div id="summaryDetails" class="summary-details">
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

<!-- MODAL DE SÉLECTION DE CATÉGORIE PERSONNE -->
<div class="modal fade" id="categoryModal" tabindex="-1" role="dialog" aria-labelledby="categoryModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="categoryModalLabel">
                    <i class="fas fa-user"></i> Sélectionner la catégorie
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="placeInfoDisplay" style="margin-bottom: 20px; font-weight: 600; color: #003d7a;"></p>
                <div id="categoriesContainer" style="display: flex; flex-direction: column; gap: 10px;">
                    <!-- Les catégories seront ajoutées dynamiquement -->
                </div>
            </div>
        </div>
    </div>
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
    let currentPlaceForCategory = null;
    
    // Convertir tarifsCombines en JSON proper pour JavaScript
    let tarifsCombines = {};
    let categorieLabels = {};  // Mapper les IDs aux labels
    <c:forEach var="entry" items="${tarifsCombines}">
        tarifsCombines['${entry.key}'] = {};
        <c:forEach var="cat" items="${categoriesPersonne}">
            <c:set var="prix" value="${entry.value[cat.libelle]}" />
            <c:if test="${not empty prix}">
                tarifsCombines['${entry.key}']['${cat.id}'] = ${prix};
                categorieLabels['${cat.id}'] = '${cat.libelle}';
            </c:if>
        </c:forEach>
    </c:forEach>

    function openCategoryModal(placeButton) {
        const placeId = placeButton.getAttribute('data-place-id');
        const placeNumero = placeButton.getAttribute('data-place-numero');
        const placeRangee = placeButton.getAttribute('data-place-rangee');
        const placeType = placeButton.getAttribute('data-place-type');
        
        currentPlaceForCategory = {
            element: placeButton,
            placeId: placeId,
            placeNumero: placeNumero,
            placeRangee: placeRangee,
            placeType: placeType
        };
        
        document.getElementById('placeInfoDisplay').textContent = 
            'Place ' + placeRangee + placeNumero + ' - ' + placeType;
        
        const container = document.getElementById('categoriesContainer');
        container.innerHTML = '';
        
        const typeTarifs = tarifsCombines[placeType];
        
        if (!typeTarifs || Object.keys(typeTarifs).length === 0) {
            container.innerHTML = '<p style="color: #ef4444;">Pas de tarif disponible pour ' + placeType + '</p>';
            const modal = new bootstrap.Modal(document.getElementById('categoryModal'));
            modal.show();
            return;
        }
        
        Object.entries(typeTarifs).forEach(([catId, prix]) => {
            const catLabel = categorieLabels[catId] || 'Catégorie inconnue';
            
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn btn-outline-primary w-100';
            btn.style.cssText = 'text-align: left; padding: 12px; margin-bottom: 5px; border: 2px solid #0d6efd; background: white; color: #0d6efd; font-weight: 500;';
            
            const prixFormate = parseFloat(prix).toFixed(2);
            
            // Créer les éléments enfants pour éviter les problèmes d'interpolation
            const strongEl = document.createElement('strong');
            strongEl.style.cssText = 'display: block; margin-bottom: 2px;';
            strongEl.textContent = catLabel;
            
            const spanEl = document.createElement('span');
            spanEl.textContent = prixFormate + '€';
            
            btn.appendChild(strongEl);
            btn.appendChild(spanEl);
            
            // Capturer les variables correctement pour la closure
            btn.onclick = ((id, label, p) => (e) => {
                e.preventDefault();
                selectCategory(id, label, p);
            })(catId, catLabel, prix);
            
            container.appendChild(btn);
        });
        
        if (container.children.length === 0) {
            container.innerHTML = '<p style="color: #ef4444;">Aucune catégorie trouvée</p>';
        }
        
        const modal = new bootstrap.Modal(document.getElementById('categoryModal'));
        modal.show();
    }
    
    function findCategorieIdByLabel(label) {
        <c:forEach var="cat" items="${categoriesPersonne}">
            if (label === '${cat.libelle}') return '${cat.id}';
        </c:forEach>
        return '1';
    }

    function selectCategory(categorieId, categorieLabel, prix) {
        if (!currentPlaceForCategory) {
            console.error('currentPlaceForCategory est null');
            return;
        }
        
        const placeId = currentPlaceForCategory.placeId;
        const placeNumero = currentPlaceForCategory.placeNumero;
        const placeRangee = currentPlaceForCategory.placeRangee;
        const placeType = currentPlaceForCategory.placeType;
        const placeElement = currentPlaceForCategory.element;
        
        const existingIndex = selectedPlaces.findIndex(p => p.placeId === placeId);
        
        const placeInfo = {
            placeId: placeId,
            placeNumero: placeNumero,
            placeRangee: placeRangee,
            placeType: placeType,
            categorieId: categorieId,
            categorieLabel: categorieLabel,
            prix: parseFloat(prix)
        };
        
        if (existingIndex >= 0) {
            selectedPlaces[existingIndex] = placeInfo;
        } else {
            selectedPlaces.push(placeInfo);
        }
        
        if (placeElement) {
            placeElement.classList.add('place-selectionnee');
            placeElement.classList.remove('place-libre');
        }
        
        updateSelection();
        
        const modal = bootstrap.Modal.getInstance(document.getElementById('categoryModal'));
        if (modal) modal.hide();
    }

    function updateSelection() {
        const selectedCount = selectedPlaces.length;
        const submitBtn = document.getElementById('submitBtn');
        
        let totalPrice = 0;
        let placesByTypeCat = {};
        
        selectedPlaces.forEach(place => {
            totalPrice += place.prix;
            
            const key = place.placeType + ' (' + place.categorieLabel + ')';
            if (!placesByTypeCat[key]) {
                placesByTypeCat[key] = {
                    count: 0,
                    total: 0,
                    places: []
                };
            }
            placesByTypeCat[key].count++;
            placesByTypeCat[key].total += place.prix;
            placesByTypeCat[key].places.push(place.placeRangee + place.placeNumero);
        });

        const placesDisplay = selectedPlaces.map(p => p.placeRangee + p.placeNumero).join(', ');
        
        document.getElementById('selectedCountDisplay').textContent = selectedCount;
        const placesText = selectedCount > 0 ? placesDisplay : 'Aucune';
        document.getElementById('selectedPlacesDisplay').textContent = placesText;
        
        const summaryDetails = document.getElementById('summaryDetails');
        summaryDetails.innerHTML = '';
        
        if (selectedCount > 0) {
            for (const [key, info] of Object.entries(placesByTypeCat)) {
                const detailDiv = document.createElement('div');
                detailDiv.className = 'summary-detail-item';
                
                const labelSpan = document.createElement('span');
                labelSpan.className = 'label';
                labelSpan.textContent = key + ' (' + info.count + 'x):';
                
                const valueSpan = document.createElement('span');
                valueSpan.className = 'value';
                valueSpan.textContent = info.total.toFixed(2) + ' €';
                
                detailDiv.appendChild(labelSpan);
                detailDiv.appendChild(valueSpan);
                summaryDetails.appendChild(detailDiv);
            }
        }
        
        document.getElementById('estimatedTotalDisplay').textContent = 
            totalPrice.toFixed(2) + ' €';

        submitBtn.disabled = selectedCount === 0;
        document.getElementById('submitCount').textContent = 
            selectedCount > 0 ? `(${selectedCount})` : '';
    }

    function resetForm() {
        selectedPlaces = [];
        
        document.querySelectorAll('.place-button').forEach(btn => {
            btn.classList.remove('place-selectionnee');
            btn.classList.add('place-libre');
        });
        
        updateSelection();
    }

    function showConfirmationModal() {
        if (selectedPlaces.length === 0) {
            alert('Veuillez sélectionner au moins une place');
            return;
        }
        
        let totalPrice = 0;
        let recapHtml = '';
        let placesByTypeCat = {};
        
        selectedPlaces.forEach(place => {
            totalPrice += place.prix;
            const key = place.placeType + ' (' + place.categorieLabel + ')';
            if (!placesByTypeCat[key]) {
                placesByTypeCat[key] = {
                    count: 0,
                    total: 0,
                    places: []
                };
            }
            placesByTypeCat[key].count++;
            placesByTypeCat[key].total += place.prix;
            placesByTypeCat[key].places.push(place.placeRangee + place.placeNumero);
        });
        
        for (const [key, info] of Object.entries(placesByTypeCat)) {
            recapHtml += '<div class="recap-item">' +
                '<span><strong>' + key + '</strong> (' + info.count + 'x): ' + info.places.join(', ') + '</span>' +
                '<span>' + info.total.toFixed(2) + ' €</span>' +
                '</div>';
        }
        
        recapHtml += '<div class="recap-item">' +
            '<span><strong>Total</strong></span>' +
            '<span><strong>' + totalPrice.toFixed(2) + ' €</strong></span>' +
            '</div>';
        
        document.getElementById('modalRecapContent').innerHTML = recapHtml;
        
        const modal = new bootstrap.Modal(document.getElementById('confirmationModal'));
        modal.show();
    }

    function submitReservation() {
        const nomComplet = document.getElementById('nomComplet').value.trim();
        if (!nomComplet) {
            alert('Le nom est requis');
            return;
        }

        const form = document.getElementById('reservationForm');
        
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

        selectedPlaces.forEach((place, index) => {
            const placeInput = document.createElement('input');
            placeInput.type = 'hidden';
            placeInput.name = 'placeIds';
            placeInput.value = place.placeId;
            form.appendChild(placeInput);

            const categorieInput = document.createElement('input');
            categorieInput.type = 'hidden';
            categorieInput.name = 'categorieIds';
            categorieInput.value = place.categorieId;
            form.appendChild(categorieInput);
        });

        form.submit();
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateSelection();
        
        if (!document.querySelector('link[href*="bootstrap"]')) {
            const link = document.createElement('link');
            link.rel = 'stylesheet';
            link.href = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css';
            document.head.appendChild(link);
        }
        
        const categoryModal = document.getElementById('categoryModal');
        const confirmModal = document.getElementById('confirmationModal');
        
        if (categoryModal) {
            categoryModal.addEventListener('hide.bs.modal', function() {
                if (document.activeElement && document.activeElement !== document.body) {
                    document.activeElement.blur();
                }
            });
        }
        
        if (confirmModal) {
            confirmModal.addEventListener('hide.bs.modal', function() {
                if (document.activeElement && document.activeElement !== document.body) {
                    document.activeElement.blur();
                }
            });
        }
    });
</script>