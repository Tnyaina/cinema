<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Confirmer la suppression</h1>
</div>

<div class="confirmation-container">
    <div class="confirmation-message">
        <i class="fas fa-exclamation-triangle"></i>
        <p>Êtes-vous sûr de vouloir supprimer le type de place <strong>${typePlace.libelle}</strong> ?</p>
        <p class="text-muted">Cette action est irréversible.</p>
    </div>

    <div class="confirmation-actions">
        <form method="POST" action="<c:url value='/types-place/${typePlace.id}/confirmer-suppression'/>" style="display:inline;">
            <button type="submit" class="btn btn-danger">
                <i class="fas fa-trash"></i> Oui, supprimer
            </button>
        </form>
        <a href="<c:url value='/types-place/${typePlace.id}'/>" class="btn btn-secondary">
            <i class="fas fa-times"></i> Non, annuler
        </a>
    </div>
</div>
