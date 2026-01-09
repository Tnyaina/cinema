<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1><c:if test="${empty seance.id}">Créer une nouvelle séance</c:if><c:if test="${not empty seance.id}">Modifier la séance</c:if></h1>
    <p class="subtitle">Gérez les diffusions de vos films dans différentes salles et horaires</p>
</div>

<div class="form-container">
    <form method="POST" action="<c:url value='/seances${empty seance.id ? "" : "/".concat(seance.id)}'/>" class="form-group" onsubmit="return validateForm()">
        <div class="form-section">
            <div class="section-title">
                <h3>Informations de base</h3>
                <p class="section-hint">Sélectionnez un film et une salle (un film peut être diffusé dans plusieurs salles en parallèle)</p>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="filmSelect">Film <span class="required">*</span></label>
                    <select id="filmSelect" name="filmId" class="form-control" required>
                        <option value="">-- Sélectionner un film --</option>
                        <c:forEach var="film" items="${films}">
                            <option value="${film.id}" data-duration="${film.dureeMinutes}" <c:if test="${seance.film.id == film.id}">selected</c:if>>
                                ${film.titre} (${film.dureeMinutes} min)
                            </option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">La durée du film sera utilisée pour calculer l'heure de fin automatiquement</small>
                </div>

                <div class="form-field">
                    <label for="salleSelect">Salle <span class="required">*</span></label>
                    <select id="salleSelect" name="salleId" class="form-control" required>
                        <option value="">-- Sélectionner une salle --</option>
                        <c:forEach var="salle" items="${salles}">
                            <option value="${salle.id}" data-capacite="${salle.capacite}" <c:if test="${seance.salle.id == salle.id}">selected</c:if>>
                                ${salle.nom} - ${salle.capacite} places
                            </option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">Règle: Un film peut être diffusé parallèlement dans plusieurs salles</small>
                </div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title">
                <h3>Date et heure</h3>
                <p class="section-hint">Un film peut être diffusé plusieurs fois par jour et sur plusieurs jours</p>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="debut">Date et heure de début <span class="required">*</span></label>
                    <input type="datetime-local" id="debut" name="debut" class="form-control" 
                           value="${seance.debutFormatted}" required>
                    <small class="form-text text-muted">Format: JJ/MM/YYYY HH:mm</small>
                    <div id="conflictWarning" class="warning" style="display:none;">
                        ⚠️ Attention: Un chevauchement est détecté dans cette salle à cette heure
                    </div>
                </div>

                <div class="form-field">
                    <label for="fin">Heure de fin <span class="required">*</span></label>
                    <input type="time" id="fin" name="fin" class="form-control" 
                           value="${seance.finFormatted}" required>
                    <small class="form-text text-muted">Calculé automatiquement d'après la durée du film</small>
                </div>
            </div>

            <!-- Affichage des séances existantes -->
            <div id="seancesExistantes" class="seances-list" style="display:none;">
                <h4>📺 Séances existantes dans cette salle</h4>
                <div id="seancesContent"></div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title">
                <h3>Configuration supplémentaire</h3>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="versionLangueSelect">Version langue</label>
                    <select id="versionLangueSelect" name="versionLangueId" class="form-control">
                        <option value="">-- Aucune sélection --</option>
                        <c:forEach var="versionLangue" items="${versionLangues}">
                            <option value="${versionLangue.id}" 
                                    <c:if test="${not empty seance.versionLangue && seance.versionLangue.id == versionLangue.id}">selected</c:if>>
                                ${versionLangue.libelle}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <!-- Section Tarification (optionnelle) -->
        <div class="form-section">
            <div class="section-title">
                <h3>Tarification pour cette séance <span class="optional-badge">Optionnel</span></h3>
                <p class="section-hint">Définissez des tarifs spécifiques pour cette séance. Si non définis, les tarifs par défaut seront utilisés.</p>
            </div>

            <div id="tarifificationContainer">
                <c:if test="${not empty tarifs}">
                    <!-- Afficher les tarifs existants -->
                    <c:forEach var="tarif" items="${tarifs}" varStatus="status">
                        <div class="tarif-row" data-tarif-id="${tarif.id}">
                            <div class="tarif-row-content">
                                <div class="form-row">
                                    <div class="form-field">
                                        <label>Type de place</label>
                                        <select name="tarif_typePlace_${status.index}" class="form-control" onchange="updateTarifDisplay(${status.index})">
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="typePlace" items="${typePlaces}">
                                                <option value="${typePlace.id}" <c:if test="${tarif.typePlace.id == typePlace.id}">selected</c:if>>
                                                    ${typePlace.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label>Catégorie personne</label>
                                        <select name="tarif_categorie_${status.index}" class="form-control" onchange="updateTarifDisplay(${status.index})">
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="categorie" items="${categoriesPersonne}">
                                                <option value="${categorie.id}" <c:if test="${tarif.categoriePersonne.id == categorie.id}">selected</c:if>>
                                                    ${categorie.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label>Prix (€)</label>
                                        <input type="number" name="tarif_prix_${status.index}" class="form-control" step="0.01" min="0" 
                                               value="${tarif.prix}" required>
                                    </div>

                                    <div class="form-field">
                                        <button type="button" class="btn btn-sm btn-danger" onclick="removeTarifRow(this)">
                                            <i class="fas fa-trash"></i> Supprimer
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>

            <button type="button" class="btn btn-sm btn-outline-primary" onclick="addTarifRow()" style="margin-top: 15px;">
                <i class="fas fa-plus"></i> Ajouter un tarif
            </button>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i>
                <c:if test="${empty seance.id}">Créer la séance</c:if>
                <c:if test="${not empty seance.id}">Enregistrer les modifications</c:if>
            </button>
            <a href="<c:url value='/seances'/>" class="btn btn-secondary">
                <i class="fas fa-times"></i> Annuler
            </a>
        </div>
    </form>
</div>

<style>
    .content-header {
        margin-bottom: 40px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 32px;
        color: #003d7a;
        font-weight: 600;
    }

    .content-header .subtitle {
        margin: 10px 0 0 0;
        font-size: 14px;
        color: #666;
        font-weight: 400;
    }

    .form-container {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 40px;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
        max-width: 800px;
        margin: 30px auto;
    }

    .form-section {
        margin-bottom: 35px;
        padding-bottom: 30px;
        border-bottom: 1px solid #f0f0f0;
    }

    .form-section:last-of-type {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }

    .section-title h3 {
        margin: 0 0 20px 0;
        color: #003d7a;
        font-size: 18px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .section-hint {
        margin: 0;
        font-size: 13px;
        color: #666;
        font-weight: 400;
        font-style: italic;
        margin-top: -15px;
        margin-bottom: 15px;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 25px;
        margin-bottom: 20px;
    }

    .form-row:last-child {
        margin-bottom: 0;
    }

    .form-field {
        display: flex;
        flex-direction: column;
    }

    .form-field label {
        font-weight: 600;
        color: #333;
        margin-bottom: 10px;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }

    .required {
        color: #dc3545;
        font-weight: bold;
    }

    .form-control {
        padding: 12px 15px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 14px;
        font-family: inherit;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 0 3px rgba(0, 61, 122, 0.1);
        background-color: #f9fbfd;
    }

    .form-control:hover {
        border-color: #003d7a;
    }

    .form-control option {
        padding: 8px;
    }

    .form-text {
        font-size: 12px;
        color: #999;
        margin-top: 5px;
    }

    .text-muted {
        color: #999;
    }

    .form-actions {
        display: flex;
        gap: 15px;
        margin-top: 40px;
        padding-top: 30px;
        border-top: 2px solid #f0f0f0;
        justify-content: flex-start;
    }

    .btn {
        padding: 12px 28px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 15px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .btn-primary {
        background-color: #003d7a;
        color: white;
    }

    .btn-primary:hover {
        background-color: #002d5a;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    @media (max-width: 768px) {
        .form-container {
            padding: 25px;
        }

        .form-row {
            grid-template-columns: 1fr;
            gap: 15px;
        }

        .form-actions {
            flex-direction: column;
        }

        .btn {
            width: 100%;
            justify-content: center;
        }
    }

    /* Styles pour validations et affichage des séances */
    .warning {
        background-color: #fff3cd;
        color: #856404;
        padding: 12px 15px;
        border-left: 4px solid #ffc107;
        border-radius: 4px;
        margin-top: 8px;
        font-size: 13px;
        font-weight: 500;
    }

    .success {
        background-color: #d4edda;
        color: #155724;
        padding: 12px 15px;
        border-left: 4px solid #28a745;
        border-radius: 4px;
        margin-top: 8px;
        font-size: 13px;
        font-weight: 500;
    }

    .seances-list {
        margin-top: 25px;
        padding: 20px;
        background-color: #f8f9fa;
        border-left: 4px solid #003d7a;
        border-radius: 4px;
    }

    .seances-list h4 {
        margin: 0 0 15px 0;
        color: #003d7a;
        font-size: 15px;
        font-weight: 600;
    }

    .seance-item {
        background: white;
        padding: 12px 15px;
        margin-bottom: 10px;
        border-left: 3px solid #003d7a;
        border-radius: 3px;
        font-size: 13px;
    }

    .seance-item.conflict {
        background: #ffe0e0;
        border-left-color: #dc3545;
    }

    .seance-item .film-name {
        font-weight: 600;
        color: #003d7a;
    }

    .seance-item .timing {
        color: #666;
        margin-top: 3px;
    }

    /* Styles pour la tarification */
    .optional-badge {
        background-color: #e7f3ff;
        color: #003d7a;
        padding: 3px 10px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        margin-left: 10px;
        text-transform: uppercase;
    }

    .tarif-row {
        background: #f8f9fa;
        padding: 20px;
        margin-bottom: 15px;
        border-left: 4px solid #003d7a;
        border-radius: 4px;
    }

    .tarif-row-content {
        margin: 0;
    }

    .tarif-row .form-row {
        grid-template-columns: 1.5fr 1.5fr 1fr 0.8fr;
        gap: 15px;
        align-items: flex-end;
    }

    .tarif-row .form-field label {
        font-size: 13px;
    }

    .tarif-row .form-control {
        font-size: 13px;
        padding: 8px 12px;
    }

    .btn-outline-primary {
        background-color: transparent;
        color: #003d7a;
        border: 2px solid #003d7a;
    }

    .btn-outline-primary:hover {
        background-color: #003d7a;
        color: white;
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
    }

    .btn-danger:hover {
        background-color: #c82333;
    }

    .btn-sm {
        padding: 6px 12px;
        font-size: 12px;
    }
</style>

<script>
    // Données des films et séances existantes
    const filmsData = {};
    const seancesParSalle = {};
    
    <c:forEach var="film" items="${films}">
        filmsData[${film.id}] = {
            titre: '${film.titre}',
            dureeMinutes: ${film.dureeMinutes}
        };
    </c:forEach>

    <c:forEach var="seance" items="${seancesExistantes}">
        if (!seancesParSalle[${seance.salle.id}]) {
            seancesParSalle[${seance.salle.id}] = [];
        }
        seancesParSalle[${seance.salle.id}].push({
            id: ${seance.id},
            filmTitre: '${seance.film.titre}',
            debut: new Date('${seance.debutISO}'),
            fin: '${seance.finFormatted}',
            dureeMinutes: ${seance.film.dureeMinutes}
        });
    </c:forEach>

    document.addEventListener('DOMContentLoaded', function() {
        const filmSelect = document.getElementById('filmSelect');
        const salleSelect = document.getElementById('salleSelect');
        const debutInput = document.getElementById('debut');
        const finInput = document.getElementById('fin');
        const conflictWarning = document.getElementById('conflictWarning');
        const seancesExistantes = document.getElementById('seancesExistantes');
        const seancesContent = document.getElementById('seancesContent');

        // Fonction pour formater une date en format local lisible
        function formatDate(date) {
            if (!date) return '';
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            return `${day}/${month}/${year} ${hours}:${minutes}`;
        }

        // Fonction pour convertir datetime-local en Date
        function getDateFromInput(value) {
            if (!value) return null;
            return new Date(value);
        }

        // Fonction pour vérifier les chevauchements
        function checkConflicts() {
            if (!debutInput.value || !filmSelect.value || !salleSelect.value) return;

            const debut = getDateFromInput(debutInput.value);
            const duree = filmsData[filmSelect.value].dureeMinutes;
            const fin = new Date(debut.getTime() + duree * 60 * 1000);
            const salleId = parseInt(salleSelect.value);

            let hasConflict = false;
            let html = '';

            // Afficher les séances existantes
            if (seancesParSalle[salleId]) {
                seancesParSalle[salleId].forEach(seance => {
                    const seanceDebut = new Date(seance.debut);
                    // Construire seanceFin en ajoutant l'heure (string HH:mm) au jour de debut
                    const [heures, minutes] = seance.fin.split(':');
                    const seanceFin = new Date(seanceDebut);
                    seanceFin.setHours(parseInt(heures), parseInt(minutes), 0);
                    
                    // Vérifier chevauchement : si fin > seanceDebut ET debut < seanceFin
                    const overlap = fin > seanceDebut && debut < seanceFin;

                    const liClass = overlap ? 'seance-item conflict' : 'seance-item';
                    html += `<div class="${liClass}">
                        <div class="film-name">🎬 \${seance.filmTitre}</div>
                        <div class="timing">\${formatDate(seanceDebut)} → \${formatDate(seanceFin)}</div>
                    </div>`;

                    if (overlap) {
                        hasConflict = true;
                    }
                });
            } else {
                html += '<div class="seance-item" style="color:#999;">Aucune séance existante dans cette salle</div>';
            }

            seancesContent.innerHTML = html;
            
            // Afficher les séances existantes seulement s'il y en a dans la salle
            if (seancesParSalle[salleId] && seancesParSalle[salleId].length > 0) {
                seancesExistantes.style.display = 'block';
            } else {
                seancesExistantes.style.display = 'none';
            }
            
            if (hasConflict) {
                conflictWarning.style.display = 'block';
            } else {
                conflictWarning.style.display = 'none';
            }
        }

        // Recalculer fin quand début change
        debutInput.addEventListener('change', function() {
            if (!this.value || !filmSelect.value) return;

            const debut = getDateFromInput(this.value);
            const duree = filmsData[filmSelect.value].dureeMinutes || 120;
            const fin = new Date(debut.getTime() + duree * 60 * 1000);

            // Convertir fin en format HH:mm pour input type="time"
            const hours = String(fin.getHours()).padStart(2, '0');
            const minutes = String(fin.getMinutes()).padStart(2, '0');

            finInput.value = `${hours}:${minutes}`;
            checkConflicts();
        });

        // Quand le film change, recalculer fin
        filmSelect.addEventListener('change', function() {
            if (debutInput.value && this.value) {
                const debut = getDateFromInput(debutInput.value);
                const duree = filmsData[this.value].dureeMinutes || 120;
                const fin = new Date(debut.getTime() + duree * 60 * 1000);

                const hours = String(fin.getHours()).padStart(2, '0');
                const minutes = String(fin.getMinutes()).padStart(2, '0');

                finInput.value = `${hours}:${minutes}`;
            }
            checkConflicts();
        });

        // Quand la salle change, vérifier les conflits
        salleSelect.addEventListener('change', function() {
            checkConflicts();
        });

        // Initialiser l'affichage au chargement
        if (debutInput.value && filmSelect.value && salleSelect.value) {
            checkConflicts();
        }
        
        // Toujours essayer de remplir fin si debut et film existent
        if (debutInput.value && filmSelect.value) {
            const debut = getDateFromInput(debutInput.value);
            const duree = filmsData[filmSelect.value]?.dureeMinutes || 120;
            const fin = new Date(debut.getTime() + duree * 60 * 1000);
            const hours = String(fin.getHours()).padStart(2, '0');
            const minutes = String(fin.getMinutes()).padStart(2, '0');
            finInput.value = `${hours}:${minutes}`;
        }

        // Valider avant soumission
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!finInput.value || !debutInput.value) {
                alert('Veuillez définir une date/heure de début et de fin valide');
                e.preventDefault();
            }
        });
    });

    // ===== GESTION DE LA TARIFICATION =====
    let tarifRowCount = document.querySelectorAll('.tarif-row').length;

    function addTarifRow() {
        const container = document.getElementById('tarifificationContainer');
        const currentIndex = tarifRowCount;
        
        // Créer le div principal
        const rowDiv = document.createElement('div');
        rowDiv.className = 'tarif-row';
        rowDiv.setAttribute('data-tarif-index', currentIndex);
        
        // Construire le HTML avec concaténation pour éviter les problèmes JSP
        let html = '<div class="tarif-row-content"><div class="form-row">';
        
        // Type de place
        html += '<div class="form-field">';
        html += '<label>Type de place</label>';
        html += '<select name="tarif_typePlace_' + currentIndex + '" class="form-control" onchange="updateTarifDisplay(' + currentIndex + ')">';
        html += '<option value="">-- Sélectionner --</option>';
        <c:forEach var="typePlace" items="${typePlaces}">
        html += '<option value="${typePlace.id}">${typePlace.libelle}</option>';
        </c:forEach>
        html += '</select></div>';
        
        // Catégorie personne
        html += '<div class="form-field">';
        html += '<label>Catégorie personne</label>';
        html += '<select name="tarif_categorie_' + currentIndex + '" class="form-control" onchange="updateTarifDisplay(' + currentIndex + ')">';
        html += '<option value="">-- Sélectionner --</option>';
        <c:forEach var="categorie" items="${categoriesPersonne}">
        html += '<option value="${categorie.id}">${categorie.libelle}</option>';
        </c:forEach>
        html += '</select></div>';
        
        // Prix
        html += '<div class="form-field">';
        html += '<label>Prix (€)</label>';
        html += '<input type="number" name="tarif_prix_' + currentIndex + '" class="form-control" step="0.01" min="0" required>';
        html += '</div>';
        
        // Bouton supprimer
        html += '<div class="form-field">';
        html += '<button type="button" class="btn btn-sm btn-danger" onclick="removeTarifRow(this)">';
        html += '<i class="fas fa-trash"></i> Supprimer';
        html += '</button></div>';
        
        html += '</div></div>';
        
        rowDiv.innerHTML = html;
        container.appendChild(rowDiv);
        tarifRowCount++;
    }

    function removeTarifRow(button) {
        const row = button.closest('.tarif-row');
        if (row) {
            row.remove();
        }
    }

    function updateTarifDisplay(index) {
        // Fonction pour mettre à jour dynamiquement si nécessaire
        // À développer selon les besoins
    }

    // Fonction de validation du formulaire
    function validateForm() {
        const debutInput = document.getElementById('debut');
        const finInput = document.getElementById('fin');
        const filmSelect = document.getElementById('filmSelect');

        // Vérifier que debut est rempli
        if (!debutInput.value) {
            alert('Veuillez sélectionner une date et heure de début');
            return false;
        }

        // Vérifier que fin est rempli
        if (!finInput.value) {
            // Essayer de la calculer automatiquement
            if (filmSelect.value) {
                const filmsData = {};
                // Récupérer les données des films depuis le formulaire
                const filmOptions = filmSelect.options;
                for (let i = 0; i < filmOptions.length; i++) {
                    const duration = filmOptions[i].getAttribute('data-duration');
                    if (duration) {
                        filmsData[filmOptions[i].value] = { dureeMinutes: parseInt(duration) };
                    }
                }

                const debut = new Date(debutInput.value);
                const duree = filmsData[filmSelect.value]?.dureeMinutes || 120;
                const fin = new Date(debut.getTime() + duree * 60 * 1000);
                const hours = String(fin.getHours()).padStart(2, '0');
                const minutes = String(fin.getMinutes()).padStart(2, '0');
                finInput.value = `${hours}:${minutes}`;
            } else {
                alert('Veuillez sélectionner un film et une heure de fin');
                return false;
            }
        }

        return true;
    }
</script>
