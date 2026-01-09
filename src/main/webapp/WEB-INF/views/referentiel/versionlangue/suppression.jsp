<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Supprimer une version de langue</h1>
</div>

<div class="deletion-container">
    <div class="warning-card">
        <div class="warning-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <div class="warning-content">
            <h2>Confirmer la suppression</h2>
            <p>Êtes-vous sûr(e) de vouloir supprimer cette version de langue?</p>
        </div>
    </div>

    <div class="deletion-details">
        <div class="detail-section">
            <h3>Détails de la version de langue</h3>
            <div class="detail-item">
                <span class="detail-label">Code:</span>
                <span class="detail-value"><code>${versionLangue.code}</code></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Libellé:</span>
                <span class="detail-value"><strong>${versionLangue.libelle}</strong></span>
            </div>
        </div>

        <div class="warning-message">
            <p>
                <i class="fas fa-info-circle"></i>
                Cette action est irréversible. La version de langue sera supprimée définitivement de la base de données.
            </p>
        </div>

        <div class="action-buttons">
            <form method="POST" action="<c:url value='/versions-langue/${versionLangue.id}/supprimer'/>" style="display: inline;">
                <button type="submit" class="btn btn-danger btn-large">
                    <i class="fas fa-trash"></i> Oui, supprimer la version
                </button>
            </form>
            <a href="<c:url value='/versions-langue/${versionLangue.id}'/>" class="btn btn-secondary btn-large">
                <i class="fas fa-times"></i> Annuler
            </a>
        </div>
    </div>
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

    .deletion-container {
        max-width: 600px;
        margin: 30px auto;
    }

    .warning-card {
        background: linear-gradient(135deg, #fff5f5 0%, #ffe8e8 100%);
        border: 2px solid #dc3545;
        border-radius: 8px;
        padding: 30px;
        display: flex;
        gap: 20px;
        margin-bottom: 30px;
        box-shadow: 0 2px 8px rgba(220, 53, 69, 0.15);
    }

    .warning-icon {
        font-size: 48px;
        color: #dc3545;
        display: flex;
        align-items: flex-start;
        min-width: 50px;
    }

    .warning-content h2 {
        margin: 0 0 10px 0;
        color: #003d7a;
        font-size: 22px;
        font-weight: 600;
    }

    .warning-content p {
        margin: 0;
        color: #555;
        font-size: 15px;
    }

    .deletion-details {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
    }

    .detail-section {
        margin-bottom: 30px;
        padding-bottom: 25px;
        border-bottom: 1px solid #f0f0f0;
    }

    .detail-section h3 {
        margin: 0 0 20px 0;
        color: #003d7a;
        font-size: 16px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .detail-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid #f5f5f5;
    }

    .detail-item:last-child {
        border-bottom: none;
    }

    .detail-label {
        font-weight: 600;
        color: #666;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .detail-value {
        color: #333;
        font-size: 15px;
    }

    .detail-value code {
        background-color: #f5f5f5;
        padding: 3px 6px;
        border-radius: 3px;
        font-family: monospace;
    }

    .warning-message {
        background-color: #fef5e7;
        border-left: 4px solid #f39c12;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 30px;
    }

    .warning-message p {
        margin: 0;
        color: #333;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .warning-message i {
        color: #f39c12;
        font-size: 16px;
    }

    .action-buttons {
        display: flex;
        gap: 15px;
        flex-direction: column;
    }

    .btn {
        padding: 14px 24px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 15px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        font-weight: 600;
        transition: all 0.3s ease;
        width: 100%;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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

    .btn-large {
        padding: 16px 28px;
        font-size: 16px;
    }

    @media (max-width: 768px) {
        .deletion-container {
            margin: 20px 0;
        }

        .warning-card {
            flex-direction: column;
            padding: 20px;
        }

        .warning-icon {
            justify-content: center;
        }

        .deletion-details {
            padding: 20px;
        }

        .detail-item {
            flex-direction: column;
            align-items: flex-start;
            gap: 8px;
        }

        .action-buttons {
            flex-direction: column;
        }

        .btn {
            width: 100%;
        }
    }
</style>
