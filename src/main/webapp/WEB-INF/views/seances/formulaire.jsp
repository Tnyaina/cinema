<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1><c:if test="${empty seance.id}">Créer une nouvelle séance</c:if><c:if test="${not empty seance.id}">Modifier la séance</c:if></h1>
</div>

<div class="form-container">
    <form method="POST" action="<c:url value='/seances${empty seance.id ? "" : "/".concat(seance.id)}'/>" class="form-group">
        <div class="form-section">
            <div class="section-title">
                <h3>Informations de base</h3>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="filmSelect">Film <span class="required">*</span></label>
                    <select id="filmSelect" name="filmId" class="form-control" required>
                        <option value="">-- Sélectionner un film --</option>
                        <c:forEach var="film" items="${films}">
                            <option value="${film.id}" <c:if test="${seance.film.id == film.id}">selected</c:if>>
                                ${film.titre}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-field">
                    <label for="salleSelect">Salle <span class="required">*</span></label>
                    <select id="salleSelect" name="salleId" class="form-control" required>
                        <option value="">-- Sélectionner une salle --</option>
                        <c:forEach var="salle" items="${salles}">
                            <option value="${salle.id}" <c:if test="${seance.salle.id == salle.id}">selected</c:if>>
                                ${salle.nom} (${salle.capacite} places)
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title">
                <h3>Date et heure</h3>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="debut">Date et heure de début <span class="required">*</span></label>
                    <input type="datetime-local" id="debut" name="debut" class="form-control" 
                           value="${not empty seance.debut ? seance.debut : ''}" required>
                    <small class="form-text text-muted">Format: YYYY-MM-DD HH:mm</small>
                </div>

                <div class="form-field">
                    <label for="fin">Heure de fin</label>
                    <input type="time" id="fin" name="fin" class="form-control" 
                           value="${not empty seance.fin ? seance.fin : ''}">
                    <small class="form-text text-muted">Optionnel (calculé automatiquement si vide)</small>
                </div>
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
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const filmSelect = document.getElementById('filmSelect');
        const salleSelect = document.getElementById('salleSelect');
        const debutInput = document.getElementById('debut');

        // Auto-calculate fin time when debut is selected
        debutInput.addEventListener('change', function() {
            if (!this.value) return;
            const debut = new Date(this.value);
            // Assume standard movie duration (estimate from film selected)
            // For now, set to 2 hours after debut
            const fin = new Date(debut.getTime() + 2 * 60 * 60 * 1000);
            const finTime = String(fin.getHours()).padStart(2, '0') + ':' + 
                            String(fin.getMinutes()).padStart(2, '0');
            document.getElementById('fin').value = finTime;
        });
    });
</script>
