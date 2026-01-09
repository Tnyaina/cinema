<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Confirmer la suppression</h1>
</div>

<div class="confirmation-container">
    <div class="warning-box">
        <i class="fas fa-exclamation-triangle"></i>
        <h2>Êtes-vous sûr de vouloir supprimer ce genre ?</h2>
        <p>Cette action est irréversible.</p>
    </div>

    <div class="item-details">
        <strong>Genre :</strong> ${genre.libelle}
    </div>

    <div class="form-actions">
        <form method="POST" action="<c:url value='/genres/${genre.id}/supprimer'/>" style="display: inline;">
            <button type="submit" class="btn btn-danger">
                <i class="fas fa-trash"></i> Supprimer définitivement
            </button>
        </form>
        <a href="<c:url value='/genres/${genre.id}'/>" class="btn btn-secondary">
            <i class="fas fa-times"></i> Annuler
        </a>
    </div>
</div>

<style>
    .content-header {
        margin-bottom: 30px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        color: #dc3545;
        font-weight: 600;
    }

    .confirmation-container {
        background: white;
        border-radius: 8px;
        padding: 40px 30px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        max-width: 500px;
    }

    .warning-box {
        text-align: center;
        margin-bottom: 30px;
        padding: 30px;
        background-color: #fff3cd;
        border: 1px solid #ffc107;
        border-radius: 8px;
    }

    .warning-box i {
        font-size: 48px;
        color: #ffc107;
        display: block;
        margin-bottom: 15px;
    }

    .warning-box h2 {
        margin: 15px 0 10px 0;
        color: #333;
        font-size: 18px;
    }

    .warning-box p {
        margin: 0;
        color: #666;
        font-size: 14px;
    }

    .item-details {
        background-color: #f5f5f5;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 30px;
        font-size: 14px;
    }

    .form-actions {
        display: flex;
        gap: 10px;
        flex-direction: column;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-weight: 500;
        transition: all 0.2s;
        text-decoration: none;
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
    }

    .btn-danger:hover {
        background-color: #c82333;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }
</style>
