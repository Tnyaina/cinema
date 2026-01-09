<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-nav">
        <a href="<c:url value='/films'/>" class="btn btn-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Retour
        </a>
    </div>
</div>

<div class="tickets-management-container">
    <div class="page-title">
        <h1><i class="fas fa-ticket-alt"></i> Gestion des Tickets Vendus</h1>
        <p class="subtitle">Visualisez tous les tickets vendus et les clients</p>
    </div>

    <c:if test="${empty tickets}">
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> Aucun ticket vendu pour le moment.
        </div>
    </c:if>

    <c:if test="${not empty tickets}">
        <!-- Filtres -->
        <div class="filters-section">
            <div class="filters-header">
                <h3><i class="fas fa-filter"></i> Filtrer les résultats</h3>
                <button class="btn-reset" onclick="resetFilters()">
                    <i class="fas fa-redo"></i> Réinitialiser
                </button>
            </div>
            
            <div class="filters-grid">
                <div class="filter-group">
                    <label for="filterFilm"><i class="fas fa-film"></i> Film</label>
                    <select id="filterFilm" class="filter-select" onchange="applyFilters()">
                        <option value="">Tous les films</option>
                        <option value="">-- Chargement --</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label for="filterClient"><i class="fas fa-user"></i> Client</label>
                    <select id="filterClient" class="filter-select" onchange="applyFilters()">
                        <option value="">Tous les clients</option>
                        <option value="">-- Chargement --</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label for="filterStatus"><i class="fas fa-check-circle"></i> Statut</label>
                    <select id="filterStatus" class="filter-select" onchange="applyFilters()">
                        <option value="">Tous les statuts</option>
                        <option value="RESERVEE">RESERVEE</option>
                        <option value="PAYE">PAYE</option>
                        <option value="CONFIRMEE">CONFIRMEE</option>
                        <option value="ANNULEE">ANNULEE</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label for="filterType"><i class="fas fa-tag"></i> Type de place</label>
                    <select id="filterType" class="filter-select" onchange="applyFilters()">
                        <option value="">Tous les types</option>
                        <option value="">-- Chargement --</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label for="filterSearch"><i class="fas fa-search"></i> Recherche libre</label>
                    <input type="text" id="filterSearch" class="filter-input" placeholder="Nom, email, film..." onkeyup="applyFilters()">
                </div>
            </div>

            <div class="filters-info">
                <span id="filterInfo">Tous les tickets (${tickets.size()})</span>
            </div>
        </div>

        <!-- Statistiques -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <div class="stat-content">
                    <span class="stat-value">${tickets.size()}</span>
                    <span class="stat-label">Tickets vendus</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-friends"></i>
                </div>
                <div class="stat-content">
                    <span class="stat-value" id="clientCount">-</span>
                    <span class="stat-label">Clients uniques</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-money-bill-wave"></i>
                </div>
                <div class="stat-content">
                    <span class="stat-value" id="totalRevenue">-</span>
                    <span class="stat-label">Revenu total</span>
                </div>
            </div>
        </div>

        <!-- Tableau des tickets -->
        <div class="tickets-table-card">
            <div class="card-header">
                <h2><i class="fas fa-list"></i> Détail des tickets</h2>
                <span class="count-badge">${tickets.size()} tickets</span>
            </div>

            <div class="table-wrapper">
                <table class="tickets-table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> ID</th>
                            <th><i class="fas fa-user"></i> Client</th>
                            <th><i class="fas fa-envelope"></i> Email</th>
                            <th><i class="fas fa-film"></i> Film</th>
                            <th><i class="fas fa-calendar-alt"></i> Date</th>
                            <th><i class="fas fa-clock"></i> Heure</th>
                            <th><i class="fas fa-door-open"></i> Salle</th>
                            <th><i class="fas fa-chair"></i> Place</th>
                            <th><i class="fas fa-tag"></i> Type</th>
                            <th><i class="fas fa-money-bill-wave"></i> Prix</th>
                            <th><i class="fas fa-check-circle"></i> Statut</th>
                            <th><i class="fas fa-hashtag"></i> Réservation</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ticket" items="${tickets}">
                            <tr class="ticket-row" data-reservation-id="${ticket.reservation.id}" data-client-id="${ticket.reservation.personne.id}">
                                <td class="ticket-id">#${ticket.id}</td>
                                <td class="client-name">
                                    <c:choose>
                                        <c:when test="${not empty ticket.reservation.personne.nomComplet}">
                                            ${ticket.reservation.personne.nomComplet}
                                        </c:when>
                                        <c:otherwise>
                                            <em>Client anonyme</em>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="client-email">
                                    <c:if test="${not empty ticket.reservation.personne.email}">
                                        ${ticket.reservation.personne.email}
                                    </c:if>
                                    <c:if test="${empty ticket.reservation.personne.email}">
                                        <em>-</em>
                                    </c:if>
                                </td>
                                <td class="film-title">${ticket.seance.film.titre}</td>
                                <td class="film-date">
                                    ${ticket.seance.dateSeanceFormatted}
                                </td>
                                <td class="film-time">
                                    ${ticket.seance.heureDebutFormatted}
                                </td>
                                <td class="salle-name">${ticket.seance.salle.nom}</td>
                                <td class="place-info">
                                    <span class="place-rangee">${ticket.place.rangee}</span>
                                    <span class="place-numero">${ticket.place.numero}</span>
                                </td>
                                <td class="place-type">
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
                                <td class="price">${ticket.prix}€</td>
                                <td class="status-cell">
                                    <span class="status-badge" style="background-color: 
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
                                <td class="reservation-id">
                                    <a href="<c:url value='/reservations/${ticket.reservation.id}'/>" class="link">
                                        #${ticket.reservation.id}
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Synthèse par client -->
        <div class="summary-card">
            <div class="card-header">
                <h2><i class="fas fa-chart-bar"></i> Résumé par client</h2>
            </div>
            <div class="summary-content" id="summaryContent">
                <div class="loading"><i class="fas fa-spinner fa-spin"></i> Calcul en cours...</div>
            </div>
        </div>
    </c:if>
</div>

<style>
    .tickets-management-container {
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

    /* Statistiques */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: linear-gradient(135deg, #f8f9fa 0%, #f0f1f3 100%);
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        padding: 20px;
        display: flex;
        align-items: center;
        gap: 20px;
        transition: all 0.3s ease;
    }

    .stat-card:hover {
        border-color: #003d7a;
        box-shadow: 0 4px 12px rgba(0, 61, 122, 0.1);
        transform: translateY(-2px);
    }

    .stat-icon {
        font-size: 2.5rem;
        color: #003d7a;
        width: 70px;
        height: 70px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: white;
        border-radius: 8px;
    }

    .stat-content {
        display: flex;
        flex-direction: column;
    }

    .stat-value {
        font-size: 1.8rem;
        font-weight: 700;
        color: #003d7a;
    }

    .stat-label {
        font-size: 0.9rem;
        color: #64748b;
        font-weight: 500;
    }

    /* Tableau */
    .tickets-table-card {
        margin-bottom: 30px;
        border: 2px solid #e2e8f0;
        border-radius: 8px;
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

    .count-badge {
        background: #003d7a;
        color: white;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
    }

    .table-wrapper {
        overflow-x: auto;
    }

    .tickets-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.9rem;
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
        white-space: nowrap;
        border-right: 1px solid #e2e8f0;
    }

    .tickets-table th:last-child {
        border-right: none;
    }

    .tickets-table th i {
        margin-right: 6px;
        opacity: 0.7;
    }

    .tickets-table td {
        padding: 12px;
        border-bottom: 1px solid #e2e8f0;
        color: #1e293b;
    }

    .tickets-table tbody tr:hover {
        background: #f8f9fa;
    }

    .ticket-id {
        font-weight: 700;
        color: #003d7a;
    }

    .client-name {
        font-weight: 600;
    }

    .client-email {
        font-size: 0.85rem;
        color: #64748b;
    }

    .film-title {
        font-weight: 600;
        color: #003d7a;
    }

    .film-date,
    .film-time {
        font-size: 0.85rem;
        color: #64748b;
    }

    .place-info {
        display: flex;
        gap: 8px;
        align-items: center;
    }

    .place-rangee {
        background: #e2e8f0;
        padding: 4px 8px;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.85rem;
    }

    .place-numero {
        background: #e2e8f0;
        padding: 4px 8px;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.85rem;
    }

    .type-badge {
        display: inline-block;
        color: white;
        padding: 6px 10px;
        border-radius: 4px;
        font-size: 0.8rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .price {
        font-weight: 700;
        color: #10b981;
        font-size: 0.95rem;
    }

    .status-badge {
        display: inline-block;
        color: white;
        padding: 6px 10px;
        border-radius: 4px;
        font-size: 0.8rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .reservation-id {
        text-align: center;
    }

    .link {
        color: #003d7a;
        text-decoration: none;
        font-weight: 600;
        border-bottom: 2px solid #003d7a;
        transition: all 0.2s ease;
    }

    .link:hover {
        color: #002d5a;
    }

    /* Synthèse */
    .summary-card {
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        overflow: hidden;
    }

    .summary-content {
        padding: 20px;
        background: white;
    }

    .loading {
        text-align: center;
        padding: 40px;
        color: #64748b;
    }

    .summary-table {
        width: 100%;
        border-collapse: collapse;
    }

    .summary-table th {
        background: #f8f9fa;
        padding: 12px;
        text-align: left;
        color: #003d7a;
        font-weight: 700;
        border-bottom: 2px solid #e2e8f0;
    }

    .summary-table td {
        padding: 12px;
        border-bottom: 1px solid #e2e8f0;
    }

    .summary-table tbody tr:hover {
        background: #f8f9fa;
    }

    .alert {
        padding: 15px 20px;
        border-radius: 8px;
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
    }

    .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
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

    @media (max-width: 1200px) {
        .tickets-table th,
        .tickets-table td {
            padding: 8px;
            font-size: 0.85rem;
        }

        .stats-grid {
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        }
    }

    @media (max-width: 768px) {
        .tickets-management-container {
            padding: 15px;
        }

        .page-title h1 {
            font-size: 1.5rem;
        }

        .stats-grid {
            grid-template-columns: 1fr;
        }

        .stat-card {
            flex-direction: column;
            text-align: center;
        }

        .tickets-table {
            font-size: 0.8rem;
        }

        .tickets-table th,
        .tickets-table td {
            padding: 6px;
        }

        .card-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
        }
    }
</style>

<style>
    /* Filtres */
    .filters-section {
        background: linear-gradient(135deg, #f8f9fa 0%, #f0f1f3 100%);
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 30px;
    }

    .filters-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .filters-header h3 {
        margin: 0;
        color: #003d7a;
        font-size: 1.1rem;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .filters-header h3 i {
        font-size: 1.3rem;
    }

    .btn-reset {
        background: #6c757d;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 600;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: all 0.2s ease;
    }

    .btn-reset:hover {
        background: #545b62;
    }

    .filters-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-bottom: 15px;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .filter-group label {
        color: #003d7a;
        font-weight: 600;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .filter-group label i {
        font-size: 1rem;
    }

    .filter-select,
    .filter-input {
        padding: 8px 12px;
        border: 1px solid #cbd5e1;
        border-radius: 6px;
        font-size: 0.9rem;
        color: #1e293b;
        background: white;
        transition: all 0.2s ease;
    }

    .filter-select:focus,
    .filter-input:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 0 3px rgba(0, 61, 122, 0.1);
    }

    .filters-info {
        text-align: right;
        color: #64748b;
        font-size: 0.9rem;
        font-weight: 600;
        padding-top: 10px;
        border-top: 1px solid #e2e8f0;
    }

    .hidden-row {
        display: none !important;
    }
</style>

<script>
    let allTickets = [];
    
    document.addEventListener('DOMContentLoaded', function() {
        buildFilters();
        initializeFiltering();
    });

    function buildFilters() {
        const tickets = document.querySelectorAll('.ticket-row');
        const films = new Set();
        const clients = new Set();
        const types = new Set();

        tickets.forEach(function(row) {
            const filmTitle = row.querySelector('.film-title').textContent.trim();
            const clientName = row.querySelector('.client-name').textContent.trim();
            const typeText = row.querySelector('.type-badge').textContent.trim();

            films.add(filmTitle);
            clients.add(clientName);
            types.add(typeText);
        });

        // Remplir film
        const filmSelect = document.getElementById('filterFilm');
        Array.from(films).sort().forEach(function(film) {
            if (film && film !== '-- Chargement --') {
                const option = document.createElement('option');
                option.value = film;
                option.textContent = film;
                filmSelect.appendChild(option);
            }
        });

        // Remplir client
        const clientSelect = document.getElementById('filterClient');
        Array.from(clients).sort().forEach(function(client) {
            if (client && client !== '-- Chargement --') {
                const option = document.createElement('option');
                option.value = client;
                option.textContent = client;
                clientSelect.appendChild(option);
            }
        });

        // Remplir type
        const typeSelect = document.getElementById('filterType');
        Array.from(types).sort().forEach(function(type) {
            if (type && type !== '-- Chargement --') {
                const option = document.createElement('option');
                option.value = type;
                option.textContent = type;
                typeSelect.appendChild(option);
            }
        });
    }

    function initializeFiltering() {
        const rows = document.querySelectorAll('.ticket-row');
        allTickets = Array.from(rows);
    }

    function applyFilters() {
        const filmFilter = document.getElementById('filterFilm').value.toLowerCase();
        const clientFilter = document.getElementById('filterClient').value.toLowerCase();
        const statusFilter = document.getElementById('filterStatus').value.toLowerCase();
        const typeFilter = document.getElementById('filterType').value.toLowerCase();
        const searchFilter = document.getElementById('filterSearch').value.toLowerCase();

        let visibleCount = 0;

        allTickets.forEach(function(row) {
            const film = row.querySelector('.film-title').textContent.trim().toLowerCase();
            const client = row.querySelector('.client-name').textContent.trim().toLowerCase();
            const status = row.querySelector('.status-badge').textContent.trim().toLowerCase();
            const type = row.querySelector('.type-badge').textContent.trim().toLowerCase();
            const email = row.querySelector('.client-email').textContent.trim().toLowerCase();

            let show = true;

            if (filmFilter && !film.includes(filmFilter)) show = false;
            if (clientFilter && !client.includes(clientFilter)) show = false;
            if (statusFilter && !status.includes(statusFilter)) show = false;
            if (typeFilter && !type.includes(typeFilter)) show = false;
            
            if (searchFilter) {
                const searchFields = [film, client, email, status, type];
                if (!searchFields.some(field => field.includes(searchFilter))) {
                    show = false;
                }
            }

            if (show) {
                row.classList.remove('hidden-row');
                visibleCount++;
            } else {
                row.classList.add('hidden-row');
            }
        });

        // Mettre à jour les infos
        const totalTickets = allTickets.length;
        const infoText = searchFilter || filmFilter || clientFilter || statusFilter || typeFilter
            ? `Résultats filtrés : ${visibleCount} / ${totalTickets}`
            : `Tous les tickets (${totalTickets})`;
        document.getElementById('filterInfo').textContent = infoText;
    }

    function resetFilters() {
        document.getElementById('filterFilm').value = '';
        document.getElementById('filterClient').value = '';
        document.getElementById('filterStatus').value = '';
        document.getElementById('filterType').value = '';
        document.getElementById('filterSearch').value = '';
        applyFilters();
    }
</script>

<script>
    // Calculer les statistiques
    document.addEventListener('DOMContentLoaded', function() {
        const tickets = document.querySelectorAll('.ticket-row');
        const clientMap = new Map();
        let totalRevenue = 0;

        // Traiter les tickets
        tickets.forEach(function(row) {
            const clientId = row.dataset.clientId;
            const clientName = row.querySelector('.client-name').textContent.trim();
            const email = row.querySelector('.client-email').textContent.trim();
            const price = parseFloat(row.querySelector('.price').textContent);
            
            totalRevenue += price;

            if (!clientMap.has(clientId)) {
                clientMap.set(clientId, {
                    name: clientName,
                    email: email,
                    count: 0,
                    total: 0
                });
            }

            const client = clientMap.get(clientId);
            client.count += 1;
            client.total += price;
        });

        // Mettre à jour les statistiques
        document.getElementById('clientCount').textContent = clientMap.size;
        document.getElementById('totalRevenue').textContent = totalRevenue.toFixed(2) + '€';

        // Générer la table de synthèse
        let html = '<table class="summary-table"><thead><tr><th><i class="fas fa-user"></i> Client</th><th><i class="fas fa-envelope"></i> Email</th><th><i class="fas fa-ticket-alt"></i> Tickets</th><th><i class="fas fa-money-bill-wave"></i> Total dépensé</th></tr></thead><tbody>';

        // Trier par total dépensé décroissant
        const sortedClients = Array.from(clientMap.entries())
            .sort((a, b) => b[1].total - a[1].total);

        sortedClients.forEach(function([id, client]) {
            html += '<tr>';
            html += '<td>' + client.name + '</td>';
            html += '<td>' + client.email + '</td>';
            html += '<td style="text-align: center; font-weight: 700;">' + client.count + '</td>';
            html += '<td style="color: #10b981; font-weight: 700;">' + client.total.toFixed(2) + '€</td>';
            html += '</tr>';
        });

        html += '</tbody></table>';
        document.getElementById('summaryContent').innerHTML = html;
    });
</script>
