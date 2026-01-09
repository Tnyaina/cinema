<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-nav">
        <a href="<c:url value='/films'/>" class="btn btn-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Retour aux films
        </a>
    </div>
</div>

<div class="reservations-container">
    <div class="page-title">
        <h1><i class="fas fa-list"></i> Mes Réservations</h1>
        <p class="subtitle">Visualisez toutes vos réservations et leurs détails</p>
    </div>

    <c:if test="${empty reservations}">
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> Aucune réservation pour le moment.
            <a href="<c:url value='/films'/>" class="alert-link">Commencez à réserver des places</a>
        </div>
    </c:if>

    <c:if test="${not empty reservations}">
        <div class="reservations-grid">
            <c:forEach var="reservation" items="${reservations}">
                <div class="reservation-card">
                    <!-- En-tête de la réservation -->
                    <div class="card-header">
                        <div class="header-left">
                            <h3>Réservation #${reservation.id}</h3>
                            <p class="client-name">
                                <i class="fas fa-user"></i>
                                <c:choose>
                                    <c:when test="${not empty reservation.personne.nomComplet}">
                                        ${reservation.personne.nomComplet}
                                    </c:when>
                                    <c:otherwise>
                                        Client anonyme
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="header-right">
                            <span class="status-badge" style="background-color: 
                                <c:choose>
                                    <c:when test="${reservation.status.code == 'CREE'}">hsl(59, 89%, 43%)</c:when>
                                    <c:when test="${reservation.status.code == 'EN_ATTENTE'}">hsl(38, 92%, 50%)</c:when>
                                    <c:when test="${reservation.status.code == 'PAYE'}">hsl(142, 72%, 29%)</c:when>
                                    <c:when test="${reservation.status.code == 'CONFIRMEE'}">hsl(142, 76%, 36%)</c:when>
                                    <c:when test="${reservation.status.code == 'ANNULEE'}">hsl(0, 84%, 60%)</c:when>
                                    <c:otherwise>hsl(210, 40%, 50%)</c:otherwise>
                                </c:choose>;">
                                ${reservation.status.libelle}
                            </span>
                        </div>
                    </div>

                    <!-- Infos séance -->
                    <div class="card-body">
                        <div class="seance-info">
                            <h4><i class="fas fa-film"></i> ${reservation.seance.film.titre}</h4>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="label"><i class="fas fa-calendar-alt"></i> Date</span>
                                    <span class="value">
                                        ${reservation.seance.dateSeanceFormatted}
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="label"><i class="fas fa-clock"></i> Heure</span>
                                    <span class="value">
                                        ${reservation.seance.heureDebutFormatted}
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="label"><i class="fas fa-door-open"></i> Salle</span>
                                    <span class="value">${reservation.seance.salle.nom}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label"><i class="fas fa-money-bill-wave"></i> Total</span>
                                    <span class="value price">${reservation.montantTotal}€</span>
                                </div>
                            </div>
                        </div>

                        <!-- Client info -->
                        <c:if test="${not empty reservation.personne}">
                            <div class="client-info">
                                <h5><i class="fas fa-contact-card"></i> Informations client</h5>
                                <div class="info-grid">
                                    <c:if test="${not empty reservation.personne.email}">
                                        <div class="info-item">
                                            <span class="label"><i class="fas fa-envelope"></i> Email</span>
                                            <span class="value">${reservation.personne.email}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty reservation.personne.telephone}">
                                        <div class="info-item">
                                            <span class="label"><i class="fas fa-phone"></i> Téléphone</span>
                                            <span class="value">${reservation.personne.telephone}</span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Bouton détail -->
                    <div class="card-footer">
                        <a href="<c:url value='/reservations/${reservation.id}'/>" class="btn btn-primary btn-sm">
                            <i class="fas fa-eye"></i> Voir les détails
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>

<style>
    .reservations-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .page-title {
        margin-bottom: 30px;
        border-bottom: 2px solid #e2e8f0;
        padding-bottom: 20px;
    }

    .page-title h1 {
        font-size: 2rem;
        color: #003d7a;
        margin: 0 0 8px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .page-title h1 i {
        font-size: 2.2rem;
    }

    .subtitle {
        color: #64748b;
        margin: 0;
        font-size: 0.95rem;
    }

    .reservations-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 20px;
    }

    .reservation-card {
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        overflow: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .reservation-card:hover {
        border-color: #003d7a;
        box-shadow: 0 4px 16px rgba(0, 61, 122, 0.15);
        transform: translateY(-2px);
    }

    .card-header {
        background: linear-gradient(135deg, #f8f9fa 0%, #f0f1f3 100%);
        padding: 18px;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 15px;
    }

    .header-left {
        flex: 1;
    }

    .card-header h3 {
        font-size: 1.1rem;
        color: #003d7a;
        font-weight: 700;
        margin: 0 0 8px 0;
    }

    .client-name {
        color: #64748b;
        margin: 0;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .header-right {
        display: flex;
        align-items: center;
    }

    .status-badge {
        color: white;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .card-body {
        padding: 20px;
    }

    .seance-info h4 {
        margin: 0 0 15px 0;
        color: #1e293b;
        font-size: 1.05rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .seance-info h4 i {
        color: #003d7a;
    }

    .info-grid {
        display: grid;
        gap: 12px;
    }

    .info-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
        border-bottom: 1px solid #e2e8f0;
    }

    .info-item:last-child {
        border-bottom: none;
    }

    .info-item .label {
        color: #64748b;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 0.9rem;
    }

    .info-item .label i {
        color: #003d7a;
    }

    .info-item .value {
        color: #1e293b;
        font-weight: 600;
        text-align: right;
    }

    .info-item .value.price {
        font-size: 1.1rem;
        color: #10b981;
    }

    .client-info {
        margin-top: 20px;
        padding-top: 20px;
        border-top: 2px solid #e2e8f0;
    }

    .client-info h5 {
        margin: 0 0 12px 0;
        color: #1e293b;
        font-size: 0.95rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .client-info h5 i {
        color: #003d7a;
    }

    .card-footer {
        padding: 15px 20px;
        background: #f8f9fa;
        border-top: 1px solid #e2e8f0;
        display: flex;
        gap: 10px;
    }

    .btn {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 0.9rem;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-weight: 600;
        transition: all 0.2s ease;
        text-align: center;
    }

    .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }

    .btn-primary {
        background: #003d7a;
        color: white;
        flex: 1;
    }

    .btn-primary:hover {
        background: #002d5a;
    }

    .btn-secondary {
        background: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background: #545b62;
    }

    .btn-sm {
        padding: 6px 12px;
        font-size: 0.85rem;
    }

    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 500;
    }

    .alert-info {
        background: #eff6ff;
        color: #1e40af;
        border-left: 4px solid #3b82f6;
    }

    .alert-link {
        color: #1e40af;
        text-decoration: underline;
        font-weight: 700;
    }

    @media (max-width: 768px) {
        .reservations-grid {
            grid-template-columns: 1fr;
        }

        .card-header {
            flex-direction: column;
            gap: 12px;
        }

        .page-title h1 {
            font-size: 1.5rem;
        }
    }
</style>
