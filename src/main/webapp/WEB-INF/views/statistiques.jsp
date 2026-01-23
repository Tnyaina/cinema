<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="main-content">
    <div class="page-header">
        <div class="header-content">
            <h1>Statistiques de Trésorerie</h1>
            <p class="subtitle">Vue d'ensemble des performances financières</p>
        </div>
        <div class="header-actions">
            <a href="<c:url value='/chiffres-affaires-diffusions'/>" class="btn btn-outline-primary">
                <i class="fas fa-chart-bar me-2"></i> Détail des diffusions
            </a>
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
            <div class="stat-icon" style="background-color: #ec4899;">
                <i class="fas fa-megaphone"></i>
            </div>
            <div class="stat-content">
                <div class="stat-label">CA Publicités</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${pubCAPeriode}" type="number" maxFractionDigits="2" />Ar
                </div>
                <div class="stat-subtext">Revenu publicitaire</div>
            </div>
        </div>
    </div>

    <!-- Section Paiements par Société -->
    <div class="paiements-section card">
        <h2><i class="fas fa-handshake"></i> Suivi des paiements par société</h2>
        <div class="paiements-table-wrapper">
            <table class="paiements-table">
                <thead>
                    <tr>
                        <th>Société</th>
                        <th class="text-right">CA Publicités</th>
                        <th class="text-right">Montant payé</th>
                        <th class="text-right">Reste à payer</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="societe" items="${societesPaiements}">
                        <tr>
                            <td>
                                <i class="fas fa-building" style="color: #0066cc; margin-right: 8px;"></i>
                                ${societe.nom}
                            </td>
                            <td class="text-right">
                                <strong style="color: #3b82f6;"><fmt:formatNumber value="${societe.caPub}" type="number" maxFractionDigits="2" />Ar</strong>
                            </td>
                            <td class="text-right">
                                <strong style="color: #10b981;"><fmt:formatNumber value="${societe.montantPaye}" type="number" maxFractionDigits="2" />Ar</strong>
                            </td>
                            <td class="text-right">
                                <c:choose>
                                    <c:when test="${societe.resteAPayer > 0}">
                                        <strong style="color: #ef4444;"><fmt:formatNumber value="${societe.resteAPayer}" type="number" maxFractionDigits="2" />Ar</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #10b981;">✓ Payé</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:if test="${societe.resteAPayer > 0}">
                                    <button class="btn btn-sm btn-primary" onclick="openPaiementModal('${societe.id}', '${societe.nom}', ${societe.resteAPayer})">
                                        <i class="fas fa-money-bill-wave"></i> Payer
                                    </button>
                                </c:if>
                                <c:if test="${societe.resteAPayer <= 0}">
                                    <span class="badge bg-success">Payée</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal Paiement -->
    <div class="modal fade" id="paiementModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-warning text-white border-0">
                    <h5 class="modal-title fw-bold">
                        <i class="fas fa-money-bill-wave me-2"></i> Enregistrer un paiement
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="<c:url value='/paiements-publicite'/>">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Société</label>
                            <input type="text" class="form-control" id="societeName" disabled>
                            <input type="hidden" id="societeId" name="societeId">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Montant total dû (Ar)</label>
                            <input type="number" id="montantTotal" class="form-control" disabled step="0.01">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label" for="montantPaiement">Montant à payer (Ar) <span class="required">*</span></label>
                            <input type="number" id="montantPaiement" name="montant" class="form-control" step="0.01" min="0" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label" for="datePaiement">Date du paiement <span class="required">*</span></label>
                            <input type="date" id="datePaiement" name="datePaiement" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check"></i> Enregistrer le paiement
                        </button>
                    </div>
                </form>
            </div>
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

    /* SECTION PAIEMENTS */
    .paiements-section {
        margin-top: 2rem;
        padding: 1.5rem;
        background: white;
        border-radius: 0.75rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .paiements-section h2 {
        margin: 0 0 1.5rem 0;
        color: #003d7a;
        font-size: 1.25rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .paiements-table-wrapper {
        overflow-x: auto;
        border-radius: 0.5rem;
        border: 1px solid #e0e0e0;
    }

    .paiements-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .paiements-table thead {
        background: #f3f4f6;
        border-bottom: 2px solid #e0e0e0;
    }

    .paiements-table thead th {
        padding: 12px 15px;
        text-align: left;
        font-weight: 600;
        color: #003d7a;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .paiements-table thead th.text-right {
        text-align: right;
    }

    .paiements-table thead th.text-center {
        text-align: center;
    }

    .paiements-table tbody tr {
        border-bottom: 1px solid #e0e0e0;
        transition: background-color 0.2s;
    }

    .paiements-table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .paiements-table tbody td {
        padding: 12px 15px;
        color: #1e293b;
        vertical-align: middle;
    }

    .paiements-table tbody td.text-right {
        text-align: right;
    }

    .paiements-table tbody td.text-center {
        text-align: center;
    }

    .paiements-table .required {
        color: #dc3545;
    }

    .btn-sm {
        padding: 0.375rem 0.75rem;
        font-size: 0.875rem;
    }

    .badge {
        padding: 0.375rem 0.75rem;
        border-radius: 0.25rem;
        font-size: 0.875rem;
        font-weight: 600;
    }

    .badge.bg-success {
        background-color: #10b981 !important;
        color: white;
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

function openPaiementModal(societeId, societeName, montantReste) {
    // Vérifier que les éléments du modal existent
    const societeIdInput = document.getElementById('societeId');
    const societyNameInput = document.getElementById('societeName');
    const montantTotalInput = document.getElementById('montantTotal');
    const montantPaiementInput = document.getElementById('montantPaiement');
    const datePaiementInput = document.getElementById('datePaiement');
    
    if (!societeIdInput || !societyNameInput || !montantTotalInput || !montantPaiementInput || !datePaiementInput) {
        console.error('❌ Éléments du modal manquants!');
        return;
    }
    
    // Remplir les champs
    societeIdInput.value = societeId;
    societyNameInput.value = societeName;
    montantTotalInput.value = montantReste.toFixed(2);
    montantPaiementInput.value = '';
    datePaiementInput.valueAsDate = new Date();
    
    // Ouvrir le modal
    const modal = new bootstrap.Modal(document.getElementById('paiementModal'));
    modal.show();
}
</script>
