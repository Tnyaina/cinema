<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="main-content">
    <div class="page-header">
        <div class="header-content">
            <h1>Statistiques de Trésorerie</h1>
            <p class="subtitle">Vue d'ensemble des performances financières</p>
        </div>
    </div>

    <!-- Filtres -->
    <div class="filters-section card">
        <div class="filters-wrapper">
            <form method="get" action="/statistiques" class="filter-form">
                <div class="filter-group">
                    <label for="periode">Filtrer par :</label>
                    <select id="periode" name="periode" onchange="updateFilters(this.value)">
                        <option value="mois" ${periode == 'mois' ? 'selected' : ''}>Par mois</option>
                        <option value="annee" ${periode == 'annee' ? 'selected' : ''}>Par année</option>
                    </select>
                </div>

                <div class="filter-group" id="mois-group" style="display: ${periode == 'mois' ? 'block' : 'none'}">
                    <label for="mois">Mois :</label>
                    <select id="mois" name="mois">
                        <option value="01" ${mois == '01' ? 'selected' : ''}>Janvier</option>
                        <option value="02" ${mois == '02' ? 'selected' : ''}>Février</option>
                        <option value="03" ${mois == '03' ? 'selected' : ''}>Mars</option>
                        <option value="04" ${mois == '04' ? 'selected' : ''}>Avril</option>
                        <option value="05" ${mois == '05' ? 'selected' : ''}>Mai</option>
                        <option value="06" ${mois == '06' ? 'selected' : ''}>Juin</option>
                        <option value="07" ${mois == '07' ? 'selected' : ''}>Juillet</option>
                        <option value="08" ${mois == '08' ? 'selected' : ''}>Août</option>
                        <option value="09" ${mois == '09' ? 'selected' : ''}>Septembre</option>
                        <option value="10" ${mois == '10' ? 'selected' : ''}>Octobre</option>
                        <option value="11" ${mois == '11' ? 'selected' : ''}>Novembre</option>
                        <option value="12" ${mois == '12' ? 'selected' : ''}>Décembre</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label for="annee">Année :</label>
                    <select id="annee" name="annee">
                        <option value="2024" ${annee == 2024 ? 'selected' : ''}>2024</option>
                        <option value="2025" ${annee == 2025 ? 'selected' : ''}>2025</option>
                        <option value="2026" ${annee == 2026 ? 'selected' : ''}>2026</option>
                        <option value="2027" ${annee == 2027 ? 'selected' : ''}>2027</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Filtrer
                </button>
            </form>
        </div>
    </div>

    <!-- Statistiques principales -->
    <div class="stats-grid">
        <!-- Chiffre d'affaires -->
        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #3b82f6;">
                <i class="fas fa-money-bill-wave"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Chiffre d'affaires</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${stats.CATotal}" type="number" maxFractionDigits="2" />Ar
                </div>
                <div class="stat-subtext">Revenu total</div>
            </div>
        </div>

        <!-- Nombre de séances -->
        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #10b981;">
                <i class="fas fa-film"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Séances</div>
                <div class="stat-value">${stats.nombreSeances}</div>
                <div class="stat-subtext">Projections organisées</div>
            </div>
        </div>

        <!-- Nombre de tickets vendus -->
        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #f59e0b;">
                <i class="fas fa-ticket-alt"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Tickets vendus</div>
                <div class="stat-value">${stats.nombreTicketsVendus}</div>
                <div class="stat-subtext">Total des ventes</div>
            </div>
        </div>

        <!-- Prix moyen -->
        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #a78bfa;">
                <i class="fas fa-euro-sign"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Prix moyen</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${stats.prixMoyenTicket}" type="number" maxFractionDigits="2" />Ar
                </div>
                <div class="stat-subtext">Par ticket</div>
            </div>
        </div>
    </div>

    <!-- Deuxième ligne de statistiques -->
    <div class="stats-grid">
        <!-- Taux d'occupation -->
        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #06b6d4;">
                <i class="fas fa-chart-pie"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Taux d'occupation</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${stats.tauxOccupationMoyen}" type="number" maxFractionDigits="1" />%
                </div>
                <div class="stat-subtext">Moyenne des salles</div>
            </div>
        </div>

        <!-- Tickets annulés -->
        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #ef4444;">
                <i class="fas fa-ban"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Annulations</div>
                <div class="stat-value">${stats.nombreTicketsAnnules}</div>
                <div class="stat-subtext">Tickets annulés</div>
            </div>
        </div>

        <!-- Ratio réussite -->
        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #8b5cf6;">
                <i class="fas fa-percent"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Taux de réussite</div>
                <c:set var="tauxReussite" value="0"/>
                <c:if test="${stats.nombreTicketsVendus + stats.nombreTicketsAnnules > 0}">
                    <c:set var="tauxReussite" value="${(stats.nombreTicketsVendus * 100) / (stats.nombreTicketsVendus + stats.nombreTicketsAnnules)}"/>
                </c:if>
                <div class="stat-value">
                    <fmt:formatNumber value="${tauxReussite}" type="number" maxFractionDigits="1" />%
                </div>
                <div class="stat-subtext">Confirmations</div>
            </div>
        </div>

        <!-- Nombre de jours avec activité -->
        <c:set var="dureeStats" value="0"/>
        <c:if test="${periode == 'mois'}">
            <c:set var="dureeStats" value="30 jours"/>
        </c:if>
        <c:if test="${periode == 'annee'}">
            <c:set var="dureeStats" value="365 jours"/>
        </c:if>

        <div class="stat-card card">
            <div class="stat-icon" style="background-color: #ec4899;">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">Période analysée</div>
                <div class="stat-value">${dureeStats}</div>
                <div class="stat-subtext">
                    <c:if test="${periode == 'mois'}">
                        ${mois}/${annee}
                    </c:if>
                    <c:if test="${periode == 'annee'}">
                        Année ${annee}
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Détails supplémentaires -->
    <div class="details-section card">
        <h2>Résumé détaillé</h2>
        <div class="details-table">
            <table>
                <thead>
                    <tr>
                        <th>Indicateur</th>
                        <th>Valeur</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="indicator-name">Chiffre d'affaires</td>
                        <td class="value-cell"><fmt:formatNumber value="${stats.CATotal}" type="number" maxFractionDigits="2" />Ar</td>
                        <td>Somme des revenus de tickets confirmés/payés</td>
                    </tr>
                    <tr>
                        <td class="indicator-name">Nombre de séances</td>
                        <td class="value-cell">${stats.nombreSeances}</td>
                        <td>Total des projections programmées</td>
                    </tr>
                    <tr>
                        <td class="indicator-name">Tickets vendus</td>
                        <td class="value-cell">${stats.nombreTicketsVendus}</td>
                        <td>Nombre de tickets confirmés/payés</td>
                    </tr>
                    <tr>
                        <td class="indicator-name">Tickets annulés</td>
                        <td class="value-cell">${stats.nombreTicketsAnnules}</td>
                        <td>Nombre de tickets annulés</td>
                    </tr>
                    <tr>
                        <td class="indicator-name">Prix moyen par ticket</td>
                        <td class="value-cell"><fmt:formatNumber value="${stats.prixMoyenTicket}" type="number" maxFractionDigits="2" />Ar</td>
                        <td>Revenu moyen par ticket vendu</td>
                    </tr>
                    <tr>
                        <td class="indicator-name">Taux d'occupation</td>
                        <td class="value-cell"><fmt:formatNumber value="${stats.tauxOccupationMoyen}" type="number" maxFractionDigits="1" />%</td>
                        <td>Pourcentage moyen de places occupées</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
    .filters-section {
        margin-bottom: 2rem;
        padding: 1.5rem;
        background-color: #f8fafc;
    }

    .filter-form {
        display: flex;
        flex-wrap: wrap;
        gap: 1.5rem;
        align-items: flex-end;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .filter-group label {
        font-weight: 600;
        font-size: 0.875rem;
        color: #475569;
    }

    .filter-group select {
        padding: 0.625rem 1rem;
        border: 1px solid #e2e8f0;
        border-radius: 0.5rem;
        background-color: white;
        font-size: 0.875rem;
        cursor: pointer;
        min-width: 150px;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .stat-card {
        display: flex;
        align-items: center;
        gap: 1.5rem;
        padding: 1.5rem;
        background-color: #ffffff;
        border-radius: 0.75rem;
        border: 1px solid #e2e8f0;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .stat-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        border-color: #cbd5e1;
    }

    .stat-icon {
        width: 70px;
        height: 70px;
        border-radius: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.75rem;
        flex-shrink: 0;
    }

    .stat-content {
        flex: 1;
    }

    .stat-label {
        font-size: 0.875rem;
        color: #64748b;
        font-weight: 500;
        margin-bottom: 0.5rem;
    }

    .stat-value {
        font-size: 1.875rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 0.25rem;
    }

    .stat-subtext {
        font-size: 0.8125rem;
        color: #94a3b8;
    }

    .details-section {
        padding: 2rem;
        background-color: #ffffff;
        border-radius: 0.75rem;
        border: 1px solid #e2e8f0;
    }

    .details-section h2 {
        margin-bottom: 1.5rem;
        color: #1e293b;
        font-size: 1.25rem;
    }

    .details-table table {
        width: 100%;
        border-collapse: collapse;
    }

    .details-table th {
        background-color: #f1f5f9;
        padding: 1rem;
        text-align: left;
        font-weight: 600;
        color: #475569;
        border-bottom: 2px solid #e2e8f0;
        font-size: 0.875rem;
    }

    .details-table td {
        padding: 1rem;
        border-bottom: 1px solid #e2e8f0;
        color: #1e293b;
    }

    .details-table tbody tr:hover {
        background-color: #f8fafc;
    }

    .indicator-name {
        font-weight: 600;
        width: 30%;
    }

    .value-cell {
        font-weight: 700;
        color: #1e40af;
        width: 25%;
    }

    .btn {
        padding: 0.625rem 1.5rem;
        border-radius: 0.5rem;
        border: none;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-primary {
        background-color: #3b82f6;
        color: white;
    }

    .btn-primary:hover {
        background-color: #2563eb;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }
</style>

<script>
function updateFilters(value) {
    const moisGroup = document.getElementById('mois-group');
    if (value === 'mois') {
        moisGroup.style.display = 'block';
    } else {
        moisGroup.style.display = 'none';
    }
}
</script>
