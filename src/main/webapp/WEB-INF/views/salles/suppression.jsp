<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Confirmer la suppression</h1>
</div>

<div class="confirmation-container">
    <div class="alert alert-warning">
        <i class="fas fa-exclamation-triangle"></i>
        <strong>Attention!</strong> Vous êtes sur le point de supprimer une salle.
    </div>

    <div class="confirmation-card">
        <h3>Salle à supprimer</h3>
        <div class="info-block">
            <p><strong>Nom:</strong> ${salle.nom}</p>
            <p><strong>Capacité:</strong> ${salle.capacite} places</p>
        </div>

        <div class="warning-text">
            <p><strong>⚠️ Cette action est irréversible!</strong></p>
            <p>La suppression de cette salle supprimera également toutes les données associées (séances, réservations, etc.)</p>
        </div>

        <div class="confirmation-actions">
            <form method="POST" action="<c:url value='/salles/${salle.id}/supprimer'/>" style="display: inline;">
                <button type="submit" class="btn btn-danger btn-lg">
                    <i class="fas fa-trash"></i> Confirmer la suppression
                </button>
            </form>
            <a href="<c:url value='/salles/${salle.id}'/>" class="btn btn-secondary btn-lg">
                <i class="fas fa-times"></i> Annuler
            </a>
        </div>
    </div>
</div>

<style>
    .confirmation-container {
        max-width: 600px;
        margin: 30px auto;
    }

    .alert {
        padding: 15px;
        border-radius: 4px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .alert-warning {
        background-color: #fff3cd;
        color: #856404;
        border: 1px solid #ffeeba;
    }

    .confirmation-card {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 30px;
    }

    .confirmation-card h3 {
        margin-top: 0;
        color: #333;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
    }

    .info-block {
        background-color: #f9f9f9;
        padding: 15px;
        border-radius: 4px;
        margin: 15px 0;
    }

    .info-block p {
        margin: 10px 0;
    }

    .warning-text {
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        border-radius: 4px;
        padding: 15px;
        margin: 15px 0;
        color: #721c24;
    }

    .warning-text p {
        margin: 10px 0;
    }

    .confirmation-actions {
        display: flex;
        gap: 10px;
        margin-top: 30px;
        justify-content: center;
    }

    .btn {
        padding: 12px 30px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .btn-lg {
        padding: 12px 30px;
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }
</style>
