<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>
        <c:choose>
            <c:when test="${not empty categoriePersonne.id}">Modifier la catégorie de personne</c:when>
            <c:otherwise>Ajouter une catégorie de personne</c:otherwise>
        </c:choose>
    </h1>
</div>

<c:if test="${not empty param.error}">
    <div class="alert alert-error">
        ${param.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="form-container">
    <form method="POST" action="<c:url value='/categories-personne${not empty categoriePersonne.id ? "/" : ""}${categoriePersonne.id}'/>" class="form">
        <div class="form-card">
            <div class="card-header">
                <h3>Informations générales</h3>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label for="libelle">Libellé <span class="required">*</span></label>
                    <input type="text" id="libelle" name="libelle" class="form-control" 
                           value="${categoriePersonne.libelle}" placeholder="Ex: Client" required>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i>
                <c:choose>
                    <c:when test="${not empty categoriePersonne.id}">Enregistrer les modifications</c:when>
                    <c:otherwise>Créer la catégorie</c:otherwise>
                </c:choose>
            </button>
            <a href="<c:url value='/categories-personne'/>" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Retour
            </a>
        </div>
    </form>
</div>

<style>
    .content-header {
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 2px solid #1e3a5f;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        font-weight: 700;
        color: #1e3a5f;
    }

    .form-container {
        max-width: 700px;
    }

    .form-card {
        background: white;
        border-radius: 8px;
        border: 1px solid #d1dce6;
        overflow: hidden;
        margin-bottom: 20px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
    }

    .card-header {
        background: linear-gradient(135deg, #1e3a5f 0%, #2d5a8f 100%);
        padding: 16px;
        border-bottom: 1px solid #d1dce6;
    }

    .card-header h3 {
        margin: 0;
        font-size: 16px;
        font-weight: 600;
        color: white;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .card-body {
        padding: 24px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group:last-child {
        margin-bottom: 0;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: #374151;
        font-size: 14px;
    }

    .required {
        color: #ef4444;
        font-weight: bold;
    }

    .form-control {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #d1dce6;
        border-radius: 6px;
        font-size: 14px;
        transition: all 0.2s ease;
        font-family: inherit;
    }

    .form-control:focus {
        outline: none;
        border-color: #2d5a8f;
        box-shadow: 0 0 0 3px rgba(45, 90, 143, 0.1);
    }

    .form-actions {
        display: flex;
        gap: 12px;
        justify-content: flex-start;
    }

    .btn {
        padding: 10px 18px;
        border-radius: 6px;
        text-decoration: none;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border: none;
        transition: all 0.2s ease;
        font-weight: 500;
    }

    .btn-primary {
        background: linear-gradient(135deg, #1e3a5f 0%, #2d5a8f 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(30, 58, 95, 0.2);
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, #152a45 0%, #1e3a5f 100%);
        box-shadow: 0 4px 12px rgba(30, 58, 95, 0.3);
        transform: translateY(-2px);
    }

    .btn-secondary {
        background-color: #e5e7eb;
        color: #374151;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .btn-secondary:hover {
        background-color: #d1d5db;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .alert {
        padding: 14px 16px;
        border-radius: 6px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 14px;
        border-left: 4px solid;
    }

    .alert-error {
        background-color: #fef2f2;
        color: #991b1b;
        border-left-color: #ef4444;
    }

    .btn-close {
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: inherit;
        opacity: 0.6;
        padding: 0;
        width: 20px;
        height: 20px;
        transition: opacity 0.2s;
    }

    .btn-close:hover {
        opacity: 1;
    }

    .btn-close::before {
        content: "×";
    }
</style>
