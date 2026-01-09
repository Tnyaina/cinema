<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="content-header">
    <h1>${empty salle.id ? 'Ajouter une nouvelle salle' : 'Modifier la salle'}</h1>
</div>

<div class="form-container">
    <form method="POST" action="<c:url value='${empty salle.id ? "/salles" : "/salles/".concat(salle.id.toString())}'/>" class="salle-form">
        
        <!-- SECTION INFORMATIONS DE BASE -->
        <div class="form-section">
            <h3>Informations de base</h3>

            <div class="form-group">
                <label for="nom">Nom de la salle <span class="required">*</span></label>
                <input type="text" id="nom" name="nom" class="form-control" 
                       value="${not empty salle.nom ? salle.nom : ''}"
                       placeholder="Ex: Salle 1, IMAX, VIP, etc."
                       required maxlength="255">
                <small class="form-text text-muted">Obligatoire. Maximum 255 caractères.</small>
            </div>

            <div class="form-group">
                <label for="capacite">Capacité (nombre de places) <span class="required">*</span></label>
                <input type="number" id="capacite" name="capacite" class="form-control"
                       value="${not empty salle.capacite ? salle.capacite : ''}"
                       placeholder="Ex: 120"
                       min="1"
                       max="9999"
                       required>
                <small class="form-text text-muted">Obligatoire. Doit être supérieur à 0.</small>
            </div>
        </div>

        <!-- BOUTONS D'ACTION -->
        <div class="form-actions">
            <button type="submit" class="btn btn-success">
                <i class="fas fa-save"></i> 
                <c:choose>
                    <c:when test="${empty salle.id}">Créer la salle</c:when>
                    <c:otherwise>Enregistrer les modifications</c:otherwise>
                </c:choose>
            </button>
            <a href="<c:url value='/salles'/>" class="btn btn-secondary">
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
        font-size: 28px;
        color: #003d7a;
        font-weight: 600;
    }

    .form-container {
        max-width: 800px;
        margin: 20px auto;
    }

    .form-section {
        border: none;
        border-radius: 8px;
        overflow: hidden;
        margin-bottom: 25px;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.1);
    }

    .form-section h3 {
        margin: 0;
        padding: 18px 20px;
        background-color: #003d7a;
        color: white;
        font-size: 16px;
        font-weight: 600;
    }

    .form-section > div {
        background-color: white;
        padding: 25px 20px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group:last-child {
        margin-bottom: 0;
    }

    .form-group label {
        font-weight: 600;
        margin-bottom: 8px;
        display: block;
        color: #333;
        font-size: 14px;
    }

    .required {
        color: #dc3545;
    }

    .form-control {
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        width: 100%;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 8px rgba(0, 61, 122, 0.3);
    }

    .form-text {
        display: block;
        margin-top: 6px;
        font-size: 12px;
        color: #666;
    }

    .form-actions {
        display: flex;
        gap: 12px;
        margin-top: 35px;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        transition: all 0.2s;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    .btn-success {
        background-color: #28a745;
        color: white;
    }

    .btn-success:hover {
        background-color: #218838;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }
</style>
