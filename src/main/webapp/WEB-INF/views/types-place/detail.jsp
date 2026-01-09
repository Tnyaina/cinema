<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Détail du type de place</h1>
</div>

<div class="detail-container">
    <div class="detail-section">
        <h3>Informations générales</h3>
        <div class="detail-section-content">
            <div class="detail-group">
                <label>Libellé</label>
                <p>${typePlace.libelle}</p>
            </div>
        </div>
    </div>

    <div class="detail-actions">
        <a href="<c:url value='/types-place/${typePlace.id}'/>" class="btn btn-primary">
            <i class="fas fa-edit"></i> Modifier
        </a>
        <a href="<c:url value='/types-place/${typePlace.id}/supprimer'/>" class="btn btn-danger">
            <i class="fas fa-trash"></i> Supprimer
        </a>
        <a href="<c:url value='/types-place'/>" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>
</div>
