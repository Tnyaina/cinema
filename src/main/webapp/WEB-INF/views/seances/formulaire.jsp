<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="content-header">
    <h1><c:if test="${empty seance.id}">Créer une nouvelle séance</c:if><c:if test="${not empty seance.id}">Modifier la séance</c:if></h1>
    <p class="subtitle">Gérez les diffusions de vos films dans différentes salles et horaires</p>
</div>

<div class="form-container">
    <form method="POST" action="<c:url value='/seances${empty seance.id ? "" : "/".concat(seance.id)}'/>" class="form-group">
        <div class="form-section">
            <div class="section-title">
                <h3>Informations de base</h3>
                <p class="section-hint">Sélectionnez un film et une salle</p>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="filmSelect">Film <span class="required">*</span></label>
                    <select id="filmSelect" name="filmId" class="form-control" required>
                        <option value="">-- Sélectionner un film --</option>
                        <c:forEach var="film" items="${films}">
                            <option value="${film.id}" 
                                    data-duration="${film.dureeMinutes}" 
                                    <c:if test="${not empty seance.film && seance.film.id == film.id}">selected</c:if>>
                                ${film.titre} (${film.dureeMinutes} min)
                            </option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">L'heure de fin sera calculée automatiquement</small>
                </div>

                <div class="form-field">
                    <label for="salleSelect">Salle <span class="required">*</span></label>
                    <select id="salleSelect" name="salleId" class="form-control" required>
                        <option value="">-- Sélectionner une salle --</option>
                        <c:forEach var="salle" items="${salles}">
                            <option value="${salle.id}" 
                                    data-capacite="${salle.capacite}" 
                                    <c:if test="${not empty seance.salle && seance.salle.id == salle.id}">selected</c:if>>
                                ${salle.nom} - ${salle.capacite} places
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title">
                <h3>Date et heure</h3>
                <p class="section-hint">Le système vérifiera automatiquement les conflits d'horaires</p>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="debut">Date et heure de début <span class="required">*</span></label>
                    <input type="datetime-local" 
                           id="debut" 
                           name="debut" 
                           class="form-control" 
                           value="${seance.debutFormatted}" 
                           required>
                    <div id="conflictWarning" class="alert-warning" style="display:none;">
                        ⚠️ <strong>Conflit détecté :</strong> La salle est déjà occupée pendant ce créneau
                    </div>
                    <div id="successMessage" class="alert-success" style="display:none;">
                        ✅ <strong>Créneau disponible</strong>
                    </div>
                </div>

                <div class="form-field">
                    <label for="fin">Heure de fin <span class="required">*</span></label>
                    <input type="time" 
                           id="fin" 
                           name="fin" 
                           class="form-control" 
                           value="<c:if test='${not empty seance.fin}'>${seance.finFormatted}</c:if>" 
                           required>
                    <small class="form-text text-muted" id="durationInfo">Durée : -- min</small>
                </div>
            </div>

            <div id="seancesExistantes" class="seances-panel" style="display:none;">
                <h4>📺 Planning de la salle sélectionnée</h4>
                <div id="seancesContent" class="seances-timeline"></div>
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

        <div class="form-section">
            <div class="section-title">
                <h3>Tarification <span class="optional-badge">Optionnel</span></h3>
                <p class="section-hint">Définissez des tarifs spécifiques pour cette séance</p>
            </div>

            <div id="tarifificationContainer">
                <c:if test="${not empty tarifs}">
                    <c:forEach var="tarif" items="${tarifs}" varStatus="status">
                        <div class="tarif-row">
                            <div class="tarif-row-content">
                                <div class="form-row-tarif">
                                    <div class="form-field">
                                        <label>Type de place</label>
                                        <select name="tarif_typePlace_${status.index}" class="form-control">
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="typePlace" items="${typePlaces}">
                                                <option value="${typePlace.id}" 
                                                        <c:if test="${tarif.typePlace.id == typePlace.id}">selected</c:if>>
                                                    ${typePlace.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label>Catégorie</label>
                                        <select name="tarif_categorie_${status.index}" class="form-control">
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="categorie" items="${categoriesPersonne}">
                                                <option value="${categorie.id}" 
                                                        <c:if test="${tarif.categoriePersonne.id == categorie.id}">selected</c:if>>
                                                    ${categorie.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label>Prix (Ar)</label>
                                        <input type="number" 
                                               name="tarif_prix_${status.index}" 
                                               class="form-control" 
                                               step="0.01" 
                                               min="0" 
                                               value="${tarif.prix}" 
                                               required>
                                    </div>

                                    <div class="form-field-action">
                                        <button type="button" class="btn btn-sm btn-danger" onclick="removeTarifRow(this)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>

            <button type="button" class="btn btn-sm btn-outline-primary" onclick="addTarifRow()">
                <i class="fas fa-plus"></i> Ajouter un tarif
            </button>
        </div>

        <div class="form-section">
            <div class="section-title">
                <h3>Publicités <span class="optional-badge">Optionnel</span></h3>
                <p class="section-hint">Assignez des publicités à diffuser pendant cette séance</p>
            </div>

            <div id="publicitesContainer">
                <c:if test="${not empty diffusions}">
                    <c:forEach var="diffusion" items="${diffusions}" varStatus="status">
                        <div class="publicite-row">
                            <div class="publicite-row-content">
                                <div class="form-row-publicite">
                                    <div class="form-field">
                                        <label>Vidéo publicitaire</label>
                                        <select name="pub_video_${status.index}" class="form-control" onchange="updateTarifPublicite(this)">
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="video" items="${videos}">
                                                <option value="${video.id}" 
                                                        data-societe="${video.societe.id}"
                                                        data-duree="${video.duree}"
                                                        <c:if test="${diffusion.videoPublicitaire.id == video.id}">selected</c:if>>
                                                    ${video.libelle} (${video.societe.libelle} - ${video.duree}s)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label>Type de diffusion</label>
                                        <select name="pub_type_${status.index}" class="form-control" onchange="updateTarifPublicite(this)">
                                            <option value="">-- Sélectionner --</option>
                                            <c:forEach var="type" items="${typesDiffusion}">
                                                <option value="${type.id}" 
                                                        <c:if test="${diffusion.typeDiffusion.id == type.id}">selected</c:if>>
                                                    ${type.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label>Nombre de diffusions</label>
                                        <input type="number" 
                                               name="pub_nombre_${status.index}" 
                                               class="form-control" 
                                               min="1" 
                                               value="1"
                                               required>
                                    </div>

                                    <div class="form-field">
                                        <label>Montant (Ar) <span class="text-muted">(optionnel)</span></label>
                                        <input type="number" 
                                               name="pub_montant_${status.index}" 
                                               class="form-control" 
                                               step="0.01"
                                               min="0"
                                               placeholder="Tarif auto si vide">
                                    </div>

                                    <div class="form-field-action">
                                        <button type="button" class="btn btn-sm btn-danger" onclick="removePubliciteRow(this)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>

            <button type="button" class="btn btn-sm btn-outline-primary" onclick="addPubliciteRow()">
                <i class="fas fa-plus"></i> Ajouter une publicité
            </button>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary" id="submitBtn">
                <i class="fas fa-save"></i>
                <c:if test="${empty seance.id}">Créer la séance</c:if>
                <c:if test="${not empty seance.id}">Enregistrer</c:if>
            </button>
            <a href="<c:url value='/seances'/>" class="btn btn-secondary">
                <i class="fas fa-times"></i> Annuler
            </a>
        </div>
    </form>
</div>

<style>
    .content-header {
        margin-bottom: 30px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        color: #003d7a;
        font-weight: 600;
    }

    .content-header .subtitle {
        margin: 8px 0 0 0;
        font-size: 14px;
        color: #666;
    }

    .form-container {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 35px;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
        max-width: 900px;
        margin: 0 auto;
    }

    .form-section {
        margin-bottom: 30px;
        padding-bottom: 25px;
        border-bottom: 1px solid #f0f0f0;
    }

    .form-section:last-of-type {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }

    .section-title h3 {
        margin: 0 0 15px 0;
        color: #003d7a;
        font-size: 16px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .section-hint {
        margin: 0 0 15px 0;
        font-size: 13px;
        color: #666;
        font-style: italic;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 15px;
    }

    .form-field {
        display: flex;
        flex-direction: column;
    }

    .form-field label {
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }

    .required {
        color: #dc3545;
    }

    .form-control {
        padding: 10px 12px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 14px;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 0 3px rgba(0, 61, 122, 0.1);
    }

    .form-text {
        font-size: 12px;
        color: #999;
        margin-top: 5px;
    }

    .alert-warning {
        background-color: #fff3cd;
        color: #856404;
        padding: 12px 15px;
        border-left: 4px solid #ffc107;
        border-radius: 4px;
        margin-top: 8px;
        font-size: 13px;
    }

    .alert-success {
        background-color: #d4edda;
        color: #155724;
        padding: 12px 15px;
        border-left: 4px solid #28a745;
        border-radius: 4px;
        margin-top: 8px;
        font-size: 13px;
    }

    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        padding: 12px 15px;
        border-left: 4px solid #dc3545;
        border-radius: 4px;
        margin-bottom: 20px;
        font-size: 14px;
    }

    .seances-panel {
        margin-top: 20px;
        padding: 20px;
        background-color: #f8f9fa;
        border-left: 4px solid #003d7a;
        border-radius: 4px;
    }

    .seances-panel h4 {
        margin: 0 0 15px 0;
        color: #003d7a;
        font-size: 14px;
        font-weight: 600;
    }

    .seances-timeline {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .seance-item {
        background: white;
        padding: 12px 15px;
        border-left: 3px solid #6c757d;
        border-radius: 3px;
        font-size: 13px;
        transition: all 0.2s ease;
    }

    .seance-item.conflict {
        background: #ffe0e0;
        border-left-color: #dc3545;
    }

    .seance-item.available {
        border-left-color: #28a745;
    }

    .seance-item .film-name {
        font-weight: 600;
        color: #003d7a;
        margin-bottom: 3px;
    }

    .seance-item .timing {
        color: #666;
        font-size: 12px;
    }

    .optional-badge {
        background-color: #e7f3ff;
        color: #003d7a;
        padding: 3px 10px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 600;
        margin-left: 8px;
        text-transform: uppercase;
    }

    .tarif-row {
        background: #f8f9fa;
        padding: 15px;
        margin-bottom: 12px;
        border-left: 4px solid #003d7a;
        border-radius: 4px;
    }

    .publicite-row {
        background: #f0f7ff;
        padding: 15px;
        margin-bottom: 12px;
        border-left: 4px solid #0066cc;
        border-radius: 4px;
    }

    .form-row-tarif {
        display: grid;
        grid-template-columns: 1.5fr 1.5fr 1fr 0.5fr;
        gap: 12px;
        align-items: flex-end;
    }

    .form-row-publicite {
        display: grid;
        grid-template-columns: 2fr 1.5fr 1fr 0.5fr;
        gap: 12px;
        align-items: flex-end;
    }

    .form-field-action {
        display: flex;
        align-items: flex-end;
    }

    .btn {
        padding: 10px 24px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .btn:hover {
        transform: translateY(-1px);
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

    .btn-danger {
        background-color: #dc3545;
        color: white;
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

    .btn-sm {
        padding: 6px 12px;
        font-size: 12px;
    }

    .form-actions {
        display: flex;
        gap: 12px;
        margin-top: 30px;
        padding-top: 25px;
        border-top: 2px solid #f0f0f0;
    }

    @media (max-width: 768px) {
        .form-row, .form-row-tarif {
            grid-template-columns: 1fr;
        }

        .form-actions {
            flex-direction: column;
        }

        .btn {
            width: 100%;
            justify-content: center;
        }
    }
</style>

<script>
    const filmsData = {};
    const seancesParSalle = {};
    const currentSeanceId = ${not empty seance.id ? seance.id : 'null'};
    
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
            dureeMinutes: ${seance.film.dureeMinutes}
        });
    </c:forEach>

    document.addEventListener('DOMContentLoaded', function() {
        const filmSelect = document.getElementById('filmSelect');
        const salleSelect = document.getElementById('salleSelect');
        const debutInput = document.getElementById('debut');
        const finInput = document.getElementById('fin');
        const conflictWarning = document.getElementById('conflictWarning');
        const successMessage = document.getElementById('successMessage');
        const seancesExistantes = document.getElementById('seancesExistantes');
        const seancesContent = document.getElementById('seancesContent');
        const durationInfo = document.getElementById('durationInfo');
        const submitBtn = document.getElementById('submitBtn');

        function formatDateTime(date) {
            if (!date) return '';
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            return `${day}/${month}/${year} ${hours}:${minutes}`;
        }

        function getDateFromInput(value) {
            return value ? new Date(value) : null;
        }

        function calculateEndTime() {
            if (!debutInput.value || !filmSelect.value) return;

            const debut = getDateFromInput(debutInput.value);
            if (!debut || isNaN(debut.getTime())) return;
            
            const duree = filmsData[filmSelect.value].dureeMinutes || 120;
            const fin = new Date(debut.getTime() + duree * 60 * 1000);

            if (!isNaN(fin.getTime())) {
                const hours = String(fin.getHours()).padStart(2, '0');
                const minutes = String(fin.getMinutes()).padStart(2, '0');
                finInput.value = `${hours}:${minutes}`;
                durationInfo.textContent = `Durée : ${duree} min`;
            }
        }

        function checkConflicts() {
            if (!debutInput.value || !finInput.value || !filmSelect.value || !salleSelect.value) return;

            const debut = getDateFromInput(debutInput.value);
            const [heures, minutes] = finInput.value.split(':');
            const fin = new Date(debut);
            fin.setHours(parseInt(heures), parseInt(minutes), 0);
            
            const salleId = parseInt(salleSelect.value);
            let hasConflict = false;
            let html = '';

            if (seancesParSalle[salleId]) {
                seancesParSalle[salleId].forEach(seance => {
                    // Exclure la séance en cours de modification
                    if (currentSeanceId && seance.id === currentSeanceId) {
                        return;
                    }

                    const seanceDebut = new Date(seance.debut);
                    const seanceFin = new Date(seanceDebut.getTime() + seance.dureeMinutes * 60 * 1000);
                    
                    const overlap = fin > seanceDebut && debut < seanceFin;

                    const liClass = overlap ? 'seance-item conflict' : 'seance-item available';
                    html += `<div class="${liClass}">
                        <div class="film-name">🎬 \${seance.filmTitre}</div>
                        <div class="timing">\${formatDateTime(seanceDebut)} → \${formatDateTime(seanceFin)}</div>
                    </div>`;

                    if (overlap) {
                        hasConflict = true;
                    }
                });
            }

            if (!html) {
                html = '<div class="seance-item" style="color:#999;">Aucune séance existante dans cette salle</div>';
            }

            seancesContent.innerHTML = html;
            seancesExistantes.style.display = seancesParSalle[salleId]?.length ? 'block' : 'none';
            
            if (hasConflict) {
                conflictWarning.style.display = 'block';
                successMessage.style.display = 'none';
                submitBtn.style.opacity = '0.7';
            } else if (seancesParSalle[salleId]?.length) {
                conflictWarning.style.display = 'none';
                successMessage.style.display = 'block';
                submitBtn.style.opacity = '1';
            } else {
                conflictWarning.style.display = 'none';
                successMessage.style.display = 'none';
                submitBtn.style.opacity = '1';
            }
        }

        debutInput.addEventListener('change', function() {
            calculateEndTime();
            checkConflicts();
        });

        filmSelect.addEventListener('change', function() {
            calculateEndTime();
            checkConflicts();
        });

        finInput.addEventListener('change', checkConflicts);
        salleSelect.addEventListener('change', checkConflicts);

        // Initialisation
        if (debutInput.value && filmSelect.value) {
            calculateEndTime();
            checkConflicts();
        }

        // Validation avant soumission
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!finInput.value || !debutInput.value) {
                alert('⚠️ Veuillez définir une date/heure de début et de fin valide');
                e.preventDefault();
                return false;
            }
        });
    });

    // Gestion tarification
    let tarifRowCount = document.querySelectorAll('.tarif-row').length;

    function addTarifRow() {
        const container = document.getElementById('tarifificationContainer');
        const currentIndex = tarifRowCount;
        
        const rowDiv = document.createElement('div');
        rowDiv.className = 'tarif-row';
        
        let html = '<div class="tarif-row-content"><div class="form-row-tarif">';
        
        html += '<div class="form-field"><label>Type de place</label>';
        html += '<select name="tarif_typePlace_' + currentIndex + '" class="form-control">';
        html += '<option value="">-- Sélectionner --</option>';
        <c:forEach var="typePlace" items="${typePlaces}">
        html += '<option value="${typePlace.id}">${typePlace.libelle}</option>';
        </c:forEach>
        html += '</select></div>';
        
        html += '<div class="form-field"><label>Catégorie</label>';
        html += '<select name="tarif_categorie_' + currentIndex + '" class="form-control">';
        html += '<option value="">-- Sélectionner --</option>';
        <c:forEach var="categorie" items="${categoriesPersonne}">
        html += '<option value="${categorie.id}">${categorie.libelle}</option>';
        </c:forEach>
        html += '</select></div>';
        
        html += '<div class="form-field"><label>Prix (Ar)</label>';
        html += '<input type="number" name="tarif_prix_' + currentIndex + '" class="form-control" step="0.01" min="0" required>';
        html += '</div>';
        
        html += '<div class="form-field-action">';
        html += '<button type="button" class="btn btn-sm btn-danger" onclick="removeTarifRow(this)">';
        html += '<i class="fas fa-trash"></i></button></div>';
        
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

    // Gestion publicités
    let publicitesRowCount = document.querySelectorAll('.publicite-row').length;

    function addPubliciteRow() {
        const container = document.getElementById('publicitesContainer');
        const currentIndex = publicitesRowCount;
        
        const rowDiv = document.createElement('div');
        rowDiv.className = 'publicite-row';
        
        let html = '<div class="publicite-row-content"><div class="form-row-publicite">';
        
        html += '<div class="form-field"><label>Vidéo publicitaire</label>';
        html += '<select name="pub_video_' + currentIndex + '" class="form-control">';
        html += '<option value="">-- Sélectionner --</option>';
        <c:forEach var="video" items="${videos}">
        html += '<option value="${video.id}" data-societe="${video.societe.id}" data-duree="${video.duree}">${video.libelle} (${video.societe.libelle} - ${video.duree}s)</option>';
        </c:forEach>
        html += '</select></div>';
        
        html += '<div class="form-field"><label>Type de diffusion</label>';
        html += '<select name="pub_type_' + currentIndex + '" class="form-control">';
        html += '<option value="">-- Sélectionner --</option>';
        <c:forEach var="type" items="${typesDiffusion}">
        html += '<option value="${type.id}">${type.libelle}</option>';
        </c:forEach>
        html += '</select></div>';
        
        html += '<div class="form-field"><label>Nombre de diffusions</label>';
        html += '<input type="number" name="pub_nombre_' + currentIndex + '" class="form-control" min="1" value="1" required>';
        html += '</div>';
        
        html += '<div class="form-field"><label>Montant (Ar) <span class="text-muted">(optionnel)</span></label>';
        html += '<input type="number" name="pub_montant_' + currentIndex + '" class="form-control" step="0.01" min="0" placeholder="Tarif auto si vide">';
        html += '</div>';
        
        html += '<div class="form-field-action">';
        html += '<button type="button" class="btn btn-sm btn-danger" onclick="removePubliciteRow(this)">';
        html += '<i class="fas fa-trash"></i></button></div>';
        
        html += '</div></div>';
        
        rowDiv.innerHTML = html;
        container.appendChild(rowDiv);
        publicitesRowCount++;
    }

    function removePubliciteRow(button) {
        const row = button.closest('.publicite-row');
        if (row) {
            row.remove();
        }
    }

    function updateTarifPublicite(selectElement) {
        // Cette fonction sera utile si on veut afficher le tarif en temps réel
        // Pour maintenant, on la laisse vide ou on peut ajouter de la logique future
    }
</script>