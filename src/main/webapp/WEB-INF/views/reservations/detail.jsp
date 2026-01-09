<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-nav">
        <a href="<c:url value='/reservations'/>" class="btn btn-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
    </div>
</div>

<div class="detail-container">
    <!-- En-tête de la réservation -->
    <div class="reservation-header">
        <div class="header-main">
            <h1><i class="fas fa-ticket-alt"></i> Réservation #${reservation.id}</h1>
            <p class="status-line">
                <span class="status-label">Statut :</span>
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
            </p>
        </div>
        <div class="header-summary">
            <div class="summary-item">
                <span class="label">Montant total</span>
                <span class="value">${reservation.montantTotal}€</span>
            </div>
            <div class="summary-item">
                <span class="label">Nombre de places</span>
                <span class="value">${tickets.size()}</span>
            </div>
        </div>
    </div>

    <!-- Infos film et séance -->
    <div class="card">
        <div class="card-header">
            <h2><i class="fas fa-film"></i> ${reservation.seance.film.titre}</h2>
        </div>
        <div class="card-body">
            <div class="seance-details">
                <div class="detail-row">
                    <span class="label"><i class="fas fa-calendar-alt"></i> Date</span>
                    <span class="value">${reservation.seance.dateSeanceFormatted}</span>
                </div>
                <div class="detail-row">
                    <span class="label"><i class="fas fa-clock"></i> Heure</span>
                    <span class="value">${reservation.seance.heureDebutFormatted}</span>
                </div>
                <div class="detail-row">
                    <span class="label"><i class="fas fa-door-open"></i> Salle</span>
                    <span class="value">${reservation.seance.salle.nom}</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Infos client -->
    <div class="card">
        <div class="card-header">
            <h2><i class="fas fa-contact-card"></i> Informations client</h2>
        </div>
        <div class="card-body">
            <div class="client-details">
                <div class="detail-row">
                    <span class="label"><i class="fas fa-user"></i> Nom</span>
                    <span class="value">
                        <c:choose>
                            <c:when test="${not empty reservation.personne.nomComplet}">
                                ${reservation.personne.nomComplet}
                            </c:when>
                            <c:otherwise>
                                Non renseigné
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <c:if test="${not empty reservation.personne.email}">
                    <div class="detail-row">
                        <span class="label"><i class="fas fa-envelope"></i> Email</span>
                        <span class="value">${reservation.personne.email}</span>
                    </div>
                </c:if>
                <c:if test="${not empty reservation.personne.telephone}">
                    <div class="detail-row">
                        <span class="label"><i class="fas fa-phone"></i> Téléphone</span>
                        <span class="value">${reservation.personne.telephone}</span>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Liste des tickets -->
    <div class="card">
        <div class="card-header">
            <h2><i class="fas fa-list"></i> Détail des places réservées</h2>
            <span class="ticket-count">${tickets.size()} place(s)</span>
        </div>
        <div class="card-body">
            <c:if test="${empty tickets}">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    Aucun ticket trouvé pour cette réservation.
                </div>
            </c:if>

            <c:if test="${not empty tickets}">
                <div class="tickets-table-wrapper">
                    <table class="tickets-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> ID Ticket</th>
                                <th><i class="fas fa-chair"></i> Rangée</th>
                                <th><i class="fas fa-chair"></i> Numéro</th>
                                <th><i class="fas fa-tag"></i> Type</th>
                                <th><i class="fas fa-user-tag"></i> Catégorie</th>
                                <th><i class="fas fa-money-bill-wave"></i> Prix</th>
                                <th><i class="fas fa-check-circle"></i> Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ticket" items="${tickets}">
                                <tr class="ticket-row">
                                    <td class="ticket-id">#${ticket.id}</td>
                                    <td>${ticket.place.rangee}</td>
                                    <td class="text-center">${ticket.place.numero}</td>
                                    <td>
                                        <span class="type-badge" style="background-color: 
                                            <c:choose>
                                                <c:when test="${ticket.place.typePlace.libelle == 'Normal'}">hsl(210, 100%, 50%)</c:when>
                                                <c:when test="${ticket.place.typePlace.libelle == 'VIP'}">hsl(50, 100%, 50%)</c:when>
                                                <c:when test="${ticket.place.typePlace.libelle == 'Handicap'}">hsl(142, 72%, 29%)</c:when>
                                                <c:otherwise>hsl(210, 40%, 50%)</c:otherwise>
                                            </c:choose>;">
                                            ${ticket.place.typePlace.libelle}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ticket.categoriePersonne}">
                                                ${ticket.categoriePersonne.libelle}
                                            </c:when>
                                            <c:otherwise>
                                                <em>-</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="price">${ticket.prix}€</td>
                                    <td>
                                        <span class="status-small" style="background-color: 
                                            <c:choose>
                                                <c:when test="${ticket.status.code == 'RESERVEE'}">hsl(142, 72%, 29%)</c:when>
                                                <c:when test="${ticket.status.code == 'PAYE'}">hsl(142, 76%, 36%)</c:when>
                                                <c:when test="${ticket.status.code == 'CONFIRMEE'}">hsl(210, 100%, 50%)</c:when>
                                                <c:when test="${ticket.status.code == 'ANNULEE'}">hsl(0, 84%, 60%)</c:when>
                                                <c:otherwise>hsl(210, 40%, 50%)</c:otherwise>
                                            </c:choose>;">
                                            ${ticket.status.libelle}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Résumé financier -->
                <div class="financial-summary">
                    <div class="summary-row">
                        <span class="label">Total des places</span>
                        <span class="value">${tickets.size()}</span>
                    </div>
                    <div class="summary-row total">
                        <span class="label">Montant total</span>
                        <span class="value">${reservation.montantTotal}€</span>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Actions -->
    <div class="actions-footer">
        <a href="<c:url value='/reservations'/>" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
        <c:if test="${reservation.status.code == 'CREE'}">
            <button class="btn btn-danger" onclick="if(confirm('Êtes-vous sûr de vouloir annuler cette réservation ?')) { /* TODO: implémentation annulation */ }">
                <i class="fas fa-times"></i> Annuler la réservation
            </button>
        </c:if>
    </div>
</div>

<style>
    .detail-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .reservation-header {
        background: linear-gradient(135deg, #f8f9fa 0%, #f0f1f3 100%);
        padding: 25px;
        border-radius: 8px;
        margin-bottom: 30px;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 20px;
        flex-wrap: wrap;
    }

    .header-main {
        flex: 1;
        min-width: 300px;
    }

    .reservation-header h1 {
        font-size: 1.8rem;
        color: #003d7a;
        margin: 0 0 12px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .reservation-header h1 i {
        font-size: 2rem;
    }

    .status-line {
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .status-label {
        color: #64748b;
        font-weight: 600;
    }

    .status-badge {
        color: white;
        padding: 8px 16px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.9rem;
    }

    .header-summary {
        display: flex;
        gap: 30px;
        flex-wrap: wrap;
    }

    .summary-item {
        text-align: center;
        min-width: 150px;
    }

    .summary-item .label {
        display: block;
        color: #64748b;
        font-size: 0.9rem;
        font-weight: 600;
        margin-bottom: 6px;
    }

    .summary-item .value {
        font-size: 1.8rem;
        font-weight: 700;
        color: #003d7a;
    }

    .card {
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        margin-bottom: 20px;
        overflow: hidden;
    }

    .card-header {
        background: linear-gradient(135deg, #f8f9fa 0%, #f0f1f3 100%);
        padding: 18px;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .card-header h2 {
        margin: 0;
        color: #003d7a;
        font-size: 1.2rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .card-header h2 i {
        font-size: 1.4rem;
    }

    .ticket-count {
        background: #003d7a;
        color: white;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
    }

    .card-body {
        padding: 20px;
    }

    .seance-details,
    .client-details {
        display: grid;
        gap: 15px;
    }

    .detail-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid #e2e8f0;
    }

    .detail-row:last-child {
        border-bottom: none;
    }

    .detail-row .label {
        color: #64748b;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 0.95rem;
    }

    .detail-row .label i {
        color: #003d7a;
        font-size: 1.1rem;
    }

    .detail-row .value {
        color: #1e293b;
        font-weight: 600;
        text-align: right;
    }

    .tickets-table-wrapper {
        overflow-x: auto;
        margin-bottom: 20px;
    }

    .tickets-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.95rem;
    }

    .tickets-table thead {
        background: #f8f9fa;
        border-bottom: 2px solid #e2e8f0;
    }

    .tickets-table th {
        padding: 12px;
        text-align: left;
        color: #003d7a;
        font-weight: 700;
        border-right: 1px solid #e2e8f0;
    }

    .tickets-table th:last-child {
        border-right: none;
    }

    .tickets-table th i {
        margin-right: 6px;
    }

    .tickets-table td {
        padding: 12px;
        border-bottom: 1px solid #e2e8f0;
        color: #1e293b;
    }

    .tickets-table tr:last-child td {
        border-bottom: none;
    }

    .tickets-table tbody tr:hover {
        background: #f8f9fa;
    }

    .ticket-id {
        font-weight: 700;
        color: #003d7a;
    }

    .text-center {
        text-align: center;
    }

    .type-badge {
        display: inline-block;
        color: white;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 0.85rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .status-small {
        display: inline-block;
        color: white;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 0.85rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .price {
        font-weight: 700;
        color: #10b981;
        font-size: 1rem;
    }

    .financial-summary {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-top: 20px;
        border-left: 4px solid #003d7a;
    }

    .summary-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
    }

    .summary-row.total {
        font-size: 1.1rem;
        font-weight: 700;
        color: #003d7a;
        border-top: 2px solid #e2e8f0;
        padding-top: 15px;
    }

    .summary-row .label {
        color: #64748b;
        font-weight: 600;
    }

    .summary-row .value {
        color: #1e293b;
        font-weight: 600;
    }

    .summary-row.total .value {
        font-size: 1.3rem;
        color: #003d7a;
    }

    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 500;
    }

    .alert-warning {
        background: #fffbeb;
        color: #b45309;
        border-left: 4px solid #f59e0b;
    }

    .actions-footer {
        display: flex;
        gap: 12px;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 2px solid #e2e8f0;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 0.95rem;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        transition: all 0.2s ease;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .btn-secondary {
        background: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background: #545b62;
    }

    .btn-danger {
        background: #dc2626;
        color: white;
        margin-left: auto;
    }

    .btn-danger:hover {
        background: #b91c1c;
    }

    @media (max-width: 768px) {
        .detail-container {
            padding: 15px;
        }

        .reservation-header {
            flex-direction: column;
        }

        .header-summary {
            width: 100%;
            justify-content: space-around;
        }

        .card-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
        }

        .tickets-table {
            font-size: 0.85rem;
        }

        .tickets-table th,
        .tickets-table td {
            padding: 8px;
        }

        .actions-footer {
            flex-direction: column;
        }

        .btn-danger {
            margin-left: 0;
        }
    }
</style>
