<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<div class="content-header">
    <h1>${empty film.id ? 'Ajouter un nouveau film' : 'Modifier le film'}</h1>
</div>

<div class="form-container">
    <form method="POST" action="<c:url value='${empty film.id ? "/films" : "/films/".concat(film.id.toString())}'/>" class="film-form">
        
        <!-- SECTION INFORMATIONS DE BASE -->
        <div class="form-section">
            <h3>Informations de base</h3>

            <div class="form-group">
                <label for="titre">Titre du film <span class="required">*</span></label>
                <input type="text" id="titre" name="titre" class="form-control" 
                       value="${not empty film.titre ? film.titre : ''}"
                       placeholder="Ex: Avatar"
                       required maxlength="255">
                <small class="form-text text-muted">Obligatoire. Maximum 255 caractères.</small>
            </div>

            <div class="form-group">
                <label for="dureeMinutes">Durée (minutes) <span class="required">*</span></label>
                <input type="number" id="dureeMinutes" name="dureeMinutes" class="form-control"
                       value="${not empty film.dureeMinutes ? film.dureeMinutes : ''}"
                       placeholder="Ex: 162"
                       min="1"
                       max="999"
                       required>
                <small class="form-text text-muted">Obligatoire. Doit être supérieur à 0.</small>
            </div>

            <div class="form-group">
                <label for="dateSortie">Date de sortie</label>
                <c:set var="dateValue" value="" />
                <c:if test="${not empty film.dateSortie}">
                    <c:set var="dateValue" value="${film.dateSortie}" />
                </c:if>
                <input type="date" id="dateSortie" name="dateSortie" class="form-control"
                       value="${dateValue}"
                       min="1900-01-01">
                <small class="form-text text-muted">Date de sortie officielle du film.</small>
            </div>
        </div>

        <!-- SECTION INFORMATIONS COMPLEMENTAIRES -->
        <div class="form-section">
            <h3>Informations complémentaires</h3>

            <div class="form-group">
                <label for="ageMin">Âge minimum</label>
                <select id="ageMin" name="ageMin" class="form-control">
                    <option value="">-- Sélectionner un âge --</option>
                    <option value="0" ${film.ageMin == 0 ? 'selected' : ''}>Tous publics (0+)</option>
                    <option value="6" ${film.ageMin == 6 ? 'selected' : ''}>6+</option>
                    <option value="10" ${film.ageMin == 10 ? 'selected' : ''}>10+</option>
                    <option value="12" ${film.ageMin == 12 ? 'selected' : ''}>12+</option>
                    <option value="16" ${film.ageMin == 16 ? 'selected' : ''}>16+</option>
                    <option value="18" ${film.ageMin == 18 ? 'selected' : ''}>18+</option>
                </select>
                <small class="form-text text-muted">Classification d'âge recommandée.</small>
            </div>

            <div class="form-group">
                <label for="langueOriginaleId">Langue originale</label>
                <select id="langueOriginaleId" name="langueOriginaleId" class="form-control">
                    <option value="">-- Sélectionner une langue --</option>
                    <c:forEach var="langue" items="${langues}">
                        <option value="${langue.id}" 
                                ${not empty film.langueOriginale && film.langueOriginale.id == langue.id ? 'selected' : ''}>
                            ${langue.libelle}
                        </option>
                    </c:forEach>
                </select>
                <small class="form-text text-muted">Langue de la version originale du film.</small>
            </div>

            <div class="form-group">
                <label>Genres</label>
                <div class="genres-checkboxes">
                    <c:forEach var="genre" items="${genres}">
                        <div class="checkbox-group">
                            <input type="checkbox" id="genre_${genre.id}" name="genreIds" value="${genre.id}"
                                   ${film.contientGenre(genre) ? 'checked' : ''}>
                            <label for="genre_${genre.id}" class="checkbox-label">${genre.libelle}</label>
                        </div>
                    </c:forEach>
                </div>
                <small class="form-text text-muted">Sélectionnez les genres du film (optionnel).</small>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" class="form-control" rows="5"
                          placeholder="Résumé du film...">${not empty film.description ? film.description : ''}</textarea>
                <small class="form-text text-muted">Synopsis ou description du film. Maximum 2000 caractères.</small>
            </div>
        </div>

        <!-- SECTION ACTIONS -->
        <div class="form-section form-actions">
            <a href="<c:url value='/films'/>" class="btn btn-secondary">
                <i class="fas fa-times"></i> Annuler
            </a>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> ${empty film.id ? 'Créer le film' : 'Enregistrer les modifications'}
            </button>
        </div>
    </form>
</div>

<style>
    .form-container {
        max-width: 800px;
        margin: 30px auto;
        background: white;
        border-radius: 8px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .form-section {
        margin-bottom: 30px;
    }

    .form-section:last-of-type {
        margin-bottom: 0;
    }

    .form-section h3 {
        font-size: 1.3rem;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid #007bff;
        color: #333;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        color: #333;
    }

    .form-group label .required {
        color: #dc3545;
    }

    .form-control {
        width: 100%;
        padding: 10px 15px;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        font-size: 1rem;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
    }

    textarea.form-control {
        resize: vertical;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }

    .form-text {
        display: block;
        margin-top: 5px;
    }

    .text-muted {
        color: #6c757d;
        font-size: 0.875rem;
    }

    .genres-checkboxes {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 15px;
        margin-top: 10px;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 4px;
    }

    .checkbox-group {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .checkbox-group input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
        margin: 0;
    }

    .checkbox-label {
        margin: 0;
        cursor: pointer;
        user-select: none;
    }

    .form-actions {
        display: flex;
        gap: 15px;
        justify-content: flex-end;
        padding-top: 20px;
        border-top: 1px solid #dee2e6;
        margin-top: 30px;
    }

    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 600;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }

    .btn-primary:hover {
        background-color: #0056b3;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,123,255,0.3);
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #5a6268;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(108,117,125,0.3);
    }

    @media (max-width: 768px) {
        .form-container {
            padding: 20px;
        }

        .form-actions {
            flex-direction: column-reverse;
        }

        .btn {
            justify-content: center;
        }
    }
</style>

<script>
    // Validation client douce (non-bloquante)
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('.film-form');
        const titreInput = document.getElementById('titre');
        const dureeInput = document.getElementById('dureeMinutes');
        
        // Validation du titre en temps réel
        if (titreInput) {
            titreInput.addEventListener('blur', function() {
                if (this.value.trim().length === 0) {
                    this.style.borderColor = '#dc3545';
                    this.setAttribute('aria-invalid', 'true');
                } else {
                    this.style.borderColor = '#28a745';
                    this.setAttribute('aria-invalid', 'false');
                }
            });
        }
        
        // Validation de la durée
        if (dureeInput) {
            dureeInput.addEventListener('blur', function() {
                const value = parseInt(this.value);
                if (value <= 0 || isNaN(value)) {
                    this.style.borderColor = '#dc3545';
                    this.setAttribute('aria-invalid', 'true');
                } else {
                    this.style.borderColor = '#28a745';
                    this.setAttribute('aria-invalid', 'false');
                }
            });
        }
        
        // Permet la soumission même avec des champs vides (validation serveur en charge)
        if (form) {
            form.addEventListener('submit', function(e) {
                // Validation basique - laisse le serveur valider complètement
                if (!titreInput?.value.trim() || !dureeInput?.value) {
                    console.warn('Champs obligatoires vides');
                    // Ne pas empêcher la soumission, laisser le serveur valider
                }
            });
        }
    });
</script>
</style>