<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="cinema.shared.DateUtils" %>

<c:set var="createdAtFormatted" value="<%= DateUtils.formatDateTime(((cinema.salle.Salle)pageContext.findAttribute(\"salle\")).getCreatedAt()) %>" />

<div class="content-header">
    <h1>${salle.nom}</h1>
    <div class="header-actions">
        <a href="<c:url value='/salles/${salle.id}/modifier'/>" class="btn btn-warning">
            <i class="fas fa-edit"></i> Modifier
        </a>
        <a href="<c:url value='/salles/${salle.id}/supprimer'/>" class="btn btn-danger">
            <i class="fas fa-trash"></i> Supprimer
        </a>
        <a href="<c:url value='/salles'/>" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="detail-container">
    <div class="detail-row">
        <div class="detail-card">
            <div class="card-header">
                <h3>Informations</h3>
            </div>
            <div class="card-body">
                <div class="info-group">
                    <label>Nom de la salle:</label>
                    <p>${salle.nom}</p>
                </div>
                <div class="info-group">
                    <label>Capacité:</label>
                    <p><strong>${salle.capacite}</strong> places</p>
                </div>
                <div class="info-group">
                    <label>ID:</label>
                    <p class="text-muted">${salle.id}</p>
                </div>
                <div class="info-group">
                    <label>Créé le:</label>
                    <p class="text-muted">
                        ${createdAtFormatted}
                    </p>
                </div>
            </div>
        </div>

        <div class="detail-card">
            <div class="card-header">
                <h3>Actions liées</h3>
            </div>
            <div class="card-body">
                <p>
                    <a href="<c:url value='/places?salle=${salle.id}'/>" class="btn btn-sm btn-outline-primary btn-block">
                        <i class="fas fa-chairs"></i> Gérer les places
                    </a>
                </p>
                <p>
                    <a href="<c:url value='/seances?salle=${salle.id}'/>" class="btn btn-sm btn-outline-success btn-block">
                        <i class="fas fa-calendar-alt"></i> Voir les séances
                    </a>
                </p>
            </div>
        </div>
    </div>
</div>

<!-- PLAN DE SALLE -->
<c:if test="${not empty placesParRangee && placesParRangee.size() > 0}">
    <div class="plan-container">
        <div class="plan-header">
            <h3>Plan de la salle</h3>
            <p class="plan-subtitle">${nombrePlaces} place(s) configurée(s) / ${salle.capacite} capacité totale</p>
        </div>
        
        <div class="plan-content">
            <c:forEach var="entry" items="${placesParRangee}">
                <div class="rangee-plan">
                    <div class="rangee-label">Rangée ${entry.key}</div>
                    <div class="places-row">
                        <c:forEach var="place" items="${entry.value}">
                            <a href="<c:url value='/places/${place.id}'/>" class="place-seat" title="${place.codePlace}">
                                <span class="seat-numero">${place.numero}</span>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <div class="plan-legend">
            <div class="legend-item">
                <span class="legend-seat seat-example"></span>
                <span>Place disponible</span>
            </div>
        </div>
    </div>
</c:if>

<style>
    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
        gap: 20px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 32px;
        color: #003d7a;
        font-weight: 600;
    }

    .header-actions {
        display: flex;
        gap: 10px;
    }

    .detail-container {
        margin: 30px 0;
    }

    .detail-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 25px;
    }

    .detail-card {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
    }

    .detail-card:hover {
        box-shadow: 0 4px 12px rgba(0, 61, 122, 0.15);
    }

    .card-header {
        background-color: #003d7a;
        color: white;
        padding: 20px;
    }

    .card-header h3 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
    }

    .card-body {
        padding: 25px;
    }

    .info-group {
        margin-bottom: 20px;
    }

    .info-group:last-child {
        margin-bottom: 0;
    }

    .info-group label {
        font-weight: 600;
        color: #555;
        display: block;
        margin-bottom: 8px;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-group p {
        margin: 0;
        color: #333;
        font-size: 15px;
        padding: 8px 0;
    }

    .text-muted {
        color: #999;
    }

    .btn {
        padding: 10px 18px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        transition: all 0.2s ease;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    .btn-warning {
        background-color: #ffc107;
        color: white;
    }

    .btn-warning:hover {
        background-color: #e0a800;
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

    .btn-sm {
        padding: 8px 12px;
        font-size: 12px;
    }

    .btn-outline-primary {
        border: 2px solid #003d7a;
        color: #003d7a;
        background-color: transparent;
        padding: 8px 14px;
    }

    .btn-outline-primary:hover {
        background-color: #003d7a;
        color: white;
    }

    .btn-outline-success {
        border: 2px solid #28a745;
        color: #28a745;
        background-color: transparent;
        padding: 8px 14px;
    }

    .btn-outline-success:hover {
        background-color: #28a745;
        color: white;
    }

    .btn-block {
        width: 100%;
        justify-content: center;
        margin-bottom: 10px;
    }

    /* PLAN DE SALLE */
    .plan-container {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 30px;
        margin-top: 30px;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.08);
    }

    .plan-header {
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #003d7a;
    }

    .plan-header h3 {
        margin: 0 0 8px 0;
        font-size: 18px;
        font-weight: 600;
        color: #003d7a;
    }

    .plan-subtitle {
        margin: 0;
        color: #666;
        font-size: 13px;
    }

    .plan-content {
        margin-bottom: 25px;
    }

    .rangee-plan {
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 20px;
        padding: 15px;
        background-color: #f9f9f9;
        border-radius: 6px;
    }

    .rangee-label {
        min-width: 80px;
        font-weight: 600;
        color: #003d7a;
        font-size: 14px;
        text-align: center;
        padding: 8px;
        background-color: #e8f1ff;
        border-radius: 4px;
    }

    .places-row {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
    }

    .place-seat {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #28a745;
        color: white;
        border-radius: 4px;
        text-decoration: none;
        font-weight: 600;
        font-size: 12px;
        border: 2px solid #28a745;
        transition: all 0.2s ease;
        cursor: pointer;
    }

    .place-seat:hover {
        background-color: #218838;
        border-color: #218838;
        transform: scale(1.1);
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
    }

    .seat-numero {
        display: block;
    }

    .plan-legend {
        display: flex;
        gap: 30px;
        padding: 15px;
        background-color: #f0f7ff;
        border-left: 4px solid #003d7a;
        border-radius: 4px;
    }

    .legend-item {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 13px;
        color: #333;
    }

    .legend-seat {
        width: 32px;
        height: 32px;
        border-radius: 3px;
        display: block;
    }

    .seat-example {
        background-color: #28a745;
    }

    @media (max-width: 768px) {
        .plan-container {
            padding: 20px;
        }

        .rangee-plan {
            flex-direction: column;
            align-items: flex-start;
        }

        .rangee-label {
            width: 100%;
        }

        .place-seat {
            width: 36px;
            height: 36px;
            font-size: 11px;
        }

        .plan-legend {
            flex-direction: column;
            gap: 10px;
        }
    }
</style>
