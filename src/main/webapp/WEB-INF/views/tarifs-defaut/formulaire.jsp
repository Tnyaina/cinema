<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>
        <c:choose>
            <c:when test="${not empty tarifDefaut.id}">Modifier le tarif par défaut</c:when>
            <c:otherwise>Ajouter un tarif par défaut</c:otherwise>
        </c:choose>
    </h1>
</div>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle"></i> ${param.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="form-container">
    <form method="POST" action="<c:url value='/tarifs-defaut${not empty tarifDefaut.id ? "/" : ""}${tarifDefaut.id}'/>" class="tarif-form">
        <div class="form-section">
            <h3>Informations générales</h3>
            <div class="form-section-content">
                <div class="form-row">
                    <div class="form-group">
                        <label for="typePlaceId">Type de place</label>
                        <select id="typePlaceId" name="typePlaceId" class="form-control">
                            <option value="">-- Tous types --</option>
                            <c:forEach var="type" items="${typesPlace}">
                                <option value="${type.id}" ${not empty tarifDefaut.typePlace && tarifDefaut.typePlace.id == type.id ? 'selected' : ''}>
                                    ${type.libelle}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="categoriePersonneId">Catégorie personne</label>
                        <select id="categoriePersonneId" name="categoriePersonneId" class="form-control">
                            <option value="">-- Toutes catégories --</option>
                            <c:forEach var="categorie" items="${categoriesPersonne}">
                                <option value="${categorie.id}" ${not empty tarifDefaut.categoriePersonne && tarifDefaut.categoriePersonne.id == categorie.id ? 'selected' : ''}>
                                    ${categorie.libelle}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="prix">Prix <span class="required">*</span></label>
                    <div class="price-input-group">
                        <input type="number" id="prix" name="prix" class="form-control" 
                               value="${tarifDefaut.prix}" placeholder="0.00" step="0.01" min="0" required>
                        <span class="currency">€</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-success">
                <i class="fas fa-save"></i>
                <c:choose>
                    <c:when test="${not empty tarifDefaut.id}">Enregistrer les modifications</c:when>
                    <c:otherwise>Créer le tarif</c:otherwise>
                </c:choose>
            </button>
            <a href="<c:url value='/tarifs-defaut'/>" class="btn btn-secondary">
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
        background: white;
        border-radius: 8px;
        padding: 0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .form-section {
        border: none;
        border-radius: 0;
        overflow: hidden;
        margin-bottom: 0;
        box-shadow: none;
    }

    .form-section:first-of-type {
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;
    }

    .form-section:not(:last-of-type) {
        border-bottom: 1px solid #e0e0e0;
    }

    .form-section h3 {
        margin: 0;
        padding: 18px 30px;
        background-color: #003d7a;
        color: white;
        font-size: 16px;
        font-weight: 600;
    }

    .form-section-content {
        background-color: white;
        padding: 25px 30px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group:last-child {
        margin-bottom: 0;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
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
        font-family: inherit;
    }

    .form-control:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 8px rgba(0, 61, 122, 0.3);
    }

    .price-input-group {
        position: relative;
        display: flex;
        align-items: center;
    }

    .price-input-group input {
        flex: 1;
        padding-right: 45px;
    }

    .currency {
        position: absolute;
        right: 15px;
        font-weight: 600;
        color: #666;
        pointer-events: none;
    }

    .form-actions {
        display: flex;
        gap: 12px;
        margin-top: 30px;
        padding: 0 30px 30px 30px;
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
        text-decoration: none;
    }

    .btn:hover:not(:disabled) {
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

    .alert {
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
    }

    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    @media (max-width: 768px) {
        .form-row {
            grid-template-columns: 1fr;
        }

        .form-section h3,
        .form-section-content,
        .form-actions {
            padding-left: 15px;
            padding-right: 15px;
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
