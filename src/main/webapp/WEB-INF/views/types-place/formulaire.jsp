<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>
        <c:choose>
            <c:when test="${not empty typePlace.id}">Modifier le type de place</c:when>
            <c:otherwise>Ajouter un type de place</c:otherwise>
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
    <form method="POST" action="<c:url value='/types-place${not empty typePlace.id ? "/" : ""}${typePlace.id}'/>" class="form">
        <div class="form-section">
            <h3>Informations générales</h3>
            <div class="form-section-content">
                <div class="form-group">
                    <label for="libelle">Libellé <span class="required">*</span></label>
                    <input type="text" id="libelle" name="libelle" class="form-control" 
                           value="${typePlace.libelle}" placeholder="Ex: Standard" required>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-success">
                <i class="fas fa-save"></i>
                <c:choose>
                    <c:when test="${not empty typePlace.id}">Enregistrer les modifications</c:when>
                    <c:otherwise>Créer le type de place</c:otherwise>
                </c:choose>
            </button>
            <a href="<c:url value='/types-place'/>" class="btn btn-secondary">
                <i class="fas fa-times"></i> Annuler
            </a>
        </div>
    </form>
</div>
