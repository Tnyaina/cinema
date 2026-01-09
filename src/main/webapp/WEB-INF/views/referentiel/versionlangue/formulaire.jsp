<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1><c:if test="${empty versionLangue.id}">Créer une version de langue</c:if><c:if test="${not empty versionLangue.id}">Modifier la version de langue</c:if></h1>
</div>

<div class="form-container">
    <form method="POST" action="<c:url value='/versions-langue${empty versionLangue.id ? "" : "/".concat(versionLangue.id)}'/>" class="form-group">
        <div class="form-section">
            <div class="section-title">
                <h3>Informations générales</h3>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="code">Code <span class="required">*</span></label>
                    <input type="text" id="code" name="code" class="form-control" 
                           value="${versionLangue.code}" 
                           placeholder="ex: VF, VO, VOSTFR"
                           maxlength="10"
                           required>
                    <small class="form-text text-muted">Code unique (max 10 caractères, sera converti en majuscules)</small>
                </div>

                <div class="form-field">
                    <label for="libelle">Libellé <span class="required">*</span></label>
                    <input type="text" id="libelle" name="libelle" class="form-control" 
                           value="${versionLangue.libelle}" 
                           placeholder="ex: Version Française"
                           maxlength="100"
                           required>
                    <small class="form-text text-muted">Nom descriptif de la version</small>
                </div>
            </div>
        <div class="form-section">
            <div class="section-title">
                <h3>Langues</h3>
            </div>

            <div class="form-row">
                <div class="form-field">
                    <label for="langueAudio">Langue audio</label>
                    <select id="langueAudio" name="langueAudioId" class="form-control">
                        <option value="">-- Aucune sélection --</option>
                        <c:forEach var="langue" items="${langues}">
                            <option value="${langue.id}" 
                                    <c:if test="${not empty versionLangue.langueAudio && versionLangue.langueAudio.id == langue.id}">selected</c:if>>
                                ${langue.libelle} (${langue.code})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-field">
                    <label for="langueSousTitre">Langue sous-titre</label>
                    <select id="langueSousTitre" name="langueSousTitreId" class="form-control">
                        <option value="">-- Aucune sélection --</option>
                        <c:forEach var="langue" items="${langues}">
                            <option value="${langue.id}" 
                                    <c:if test="${not empty versionLangue.langueSousTitre && versionLangue.langueSousTitre.id == langue.id}">selected</c:if>>
                                ${langue.libelle} (${langue.code})
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i>
                <c:if test="${empty versionLangue.id}">Créer la version</c:if>
                <c:if test="${not empty versionLangue.id}">Enregistrer les modifications</c:if>
            </button>
            <a href="<c:url value='/versions-langue'/>" class="btn btn-secondary">
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
        max-width: 700px;
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
