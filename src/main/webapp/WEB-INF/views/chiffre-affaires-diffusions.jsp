<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid mt-4">
    <div class="row mb-4">
        <div class="col-md-8">
            <h1 class="h3 fw-bold">
                <i class="fas fa-chart-line text-primary me-2"></i> Chiffres d'affaires par diffusion
            </h1>
            <p class="text-muted">Analyse détaillée des revenus par séance (tickets + publicités)</p>
        </div>
    </div>

    <!-- Filtres -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form method="get" action="<c:url value='/chiffres-affaires-diffusions'/>" class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label for="periode" class="form-label fw-bold">Période</label>
                    <select name="periode" id="periode" class="form-select" onchange="updatePeriode()">
                        <option value="mois" <c:if test="${periode == 'mois'}">selected</c:if>>Par mois</option>
                        <option value="annee" <c:if test="${periode == 'annee'}">selected</c:if>>Par année</option>
                    </select>
                </div>

                <div class="col-md-3" id="moisDiv" <c:if test="${periode == 'annee'}">style="display:none;"</c:if>>
                    <label for="mois" class="form-label fw-bold">Mois</label>
                    <select name="mois" id="mois" class="form-select">
                        <option value="01" <c:if test="${mois == '01'}">selected</c:if>>Janvier</option>
                        <option value="02" <c:if test="${mois == '02'}">selected</c:if>>Février</option>
                        <option value="03" <c:if test="${mois == '03'}">selected</c:if>>Mars</option>
                        <option value="04" <c:if test="${mois == '04'}">selected</c:if>>Avril</option>
                        <option value="05" <c:if test="${mois == '05'}">selected</c:if>>Mai</option>
                        <option value="06" <c:if test="${mois == '06'}">selected</c:if>>Juin</option>
                        <option value="07" <c:if test="${mois == '07'}">selected</c:if>>Juillet</option>
                        <option value="08" <c:if test="${mois == '08'}">selected</c:if>>Août</option>
                        <option value="09" <c:if test="${mois == '09'}">selected</c:if>>Septembre</option>
                        <option value="10" <c:if test="${mois == '10'}">selected</c:if>>Octobre</option>
                        <option value="11" <c:if test="${mois == '11'}">selected</c:if>>Novembre</option>
                        <option value="12" <c:if test="${mois == '12'}">selected</c:if>>Décembre</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label for="annee" class="form-label fw-bold">Année</label>
                    <select name="annee" id="annee" class="form-select">
                        <c:forEach begin="2020" end="${anneeActuelle}" var="y">
                            <option value="${y}" <c:if test="${annee == y}">selected</c:if>>${y}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-filter me-2"></i> Appliquer le filtre
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Résumé des totaux -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm bg-light">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <p class="text-muted mb-1">CA Tickets</p>
                            <h4 class="text-success fw-bold mb-0">
                                <fmt:formatNumber value="${caTotalTickets}" type="currency" currencySymbol=""/>
                                <span class="text-muted fs-6">Ar</span>
                            </h4>
                        </div>
                        <div class="text-success fs-1 opacity-25">
                            <i class="fas fa-ticket-alt"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card border-0 shadow-sm bg-light">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <p class="text-muted mb-1">CA Publicités</p>
                            <h4 class="text-info fw-bold mb-0">
                                <fmt:formatNumber value="${caTotalPublicites}" type="currency" currencySymbol=""/>
                                <span class="text-muted fs-6">Ar</span>
                            </h4>
                        </div>
                        <div class="text-info fs-1 opacity-25">
                            <i class="fas fa-megaphone"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card border-0 shadow-sm bg-light">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <p class="text-muted mb-1">CA Pub. Payé</p>
                            <h4 class="text-warning fw-bold mb-0">
                                <fmt:formatNumber value="${caTotalPublicitesPaye}" type="currency" currencySymbol=""/>
                                <span class="text-muted fs-6">Ar</span>
                            </h4>
                        </div>
                        <div class="text-warning fs-1 opacity-25">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card border-0 shadow-sm bg-light">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <p class="text-muted mb-1">CA Total</p>
                            <h4 class="text-primary fw-bold mb-0">
                                <fmt:formatNumber value="${caTotalGlobal}" type="currency" currencySymbol=""/>
                                <span class="text-muted fs-6">Ar</span>
                            </h4>
                        </div>
                        <div class="text-primary fs-1 opacity-25">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tableau des diffusions -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom">
            <h5 class="card-title mb-0 fw-bold">
                <i class="fas fa-table me-2"></i> Détail des diffusions
            </h5>
        </div>
        <div class="card-body p-0">
            <c:if test="${empty diffusionsData}">
                <div class="alert alert-info m-3 mb-0">
                    <i class="fas fa-info-circle me-2"></i> Aucune diffusion trouvée pour la période sélectionnée.
                </div>
            </c:if>

            <c:if test="${not empty diffusionsData}">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light border-bottom">
                            <tr>
                                <th colspan="4" class="bg-light border-end">
                                    <i class="fas fa-info-circle text-primary me-2"></i> Informations
                                </th>
                                <th colspan="4" class="bg-light border-end">
                                    <i class="fas fa-money-bill-wave text-success me-2"></i> Chiffres d'affaires
                                </th>
                                <th class="bg-light">
                                    <i class="fas fa-chart-bar text-primary me-2"></i> Total
                                </th>
                            </tr>
                            <tr>
                                <th class="text-center" style="width: 5%; border-right: 2px solid #dee2e6;">
                                    <i class="fas fa-film text-primary"></i>
                                </th>
                                <th style="border-right: 2px solid #dee2e6;">Film</th>
                                <th class="text-center" style="border-right: 2px solid #dee2e6;">Date</th>
                                <th class="text-center" style="border-right: 2px solid #dee2e6;">Heure / Nb Diff.</th>
                                <th class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <i class="fas fa-ticket-alt text-success"></i> Tickets
                                </th>
                                <th class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <i class="fas fa-megaphone text-info"></i> Publicités
                                </th>
                                <th class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <i class="fas fa-check-circle text-warning"></i> Payé
                                </th>
                                <th class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <i class="fas fa-exclamation-circle text-danger"></i> Reste
                                </th>
                                <th class="text-end fw-bold">
                                    <i class="fas fa-sum"></i> Total
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="diffusion" items="${diffusionsData}">
                                <tr class="align-middle">
                                    <td class="text-center" style="border-right: 2px solid #dee2e6;">
                                        <span class="badge bg-primary">
                                            <i class="fas fa-film"></i>
                                        </span>
                                    </td>
                                    <td style="border-right: 2px solid #dee2e6;">
                                        <span class="fw-bold text-dark">${diffusion.film}</span>
                                    </td>
                                    <td class="text-center" style="border-right: 2px solid #dee2e6;">
                                        <small>${diffusion.dateDiffusion}</small>
                                    </td>
                                    <td class="text-center" style="border-right: 2px solid #dee2e6;">
                                        <small class="d-block">${diffusion.heureDiffusion}</small>
                                        <span class="badge bg-info">${diffusion.nbDiffusions}</span>
                                    </td>
                                    <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                        <div class="text-success fw-bold">
                                            <fmt:formatNumber value="${diffusion.caTickets}" type="currency" currencySymbol=""/>
                                        </div>
                                        <small class="text-muted">Ar</small>
                                    </td>
                                    <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                        <div class="text-info fw-bold">
                                            <fmt:formatNumber value="${diffusion.caPublicites}" type="currency" currencySymbol=""/>
                                        </div>
                                        <small class="text-muted">Ar</small>
                                    </td>
                                    <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                        <div class="text-warning fw-bold">
                                            <fmt:formatNumber value="${diffusion.caPublicitesPaye}" type="currency" currencySymbol=""/>
                                        </div>
                                        <small class="text-muted">Ar</small>
                                    </td>
                                    <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                        <div class="text-danger fw-bold">
                                            <fmt:formatNumber value="${diffusion.resteAPayer}" type="currency" currencySymbol=""/>
                                        </div>
                                        <small class="text-muted">Ar</small>
                                    </td>
                                    <td class="text-end">
                                        <div class="text-primary fw-bold fs-5">
                                            <fmt:formatNumber value="${diffusion.caTotal}" type="currency" currencySymbol=""/>
                                        </div>
                                        <small class="text-muted">Ar</small>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot class="table-light border-top fw-bold">
                            <tr>
                                <td colspan="4" class="text-end pe-3 border-end" style="border-right: 2px solid #dee2e6;">TOTAL</td>
                                <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <div class="text-success">
                                        <fmt:formatNumber value="${caTotalTickets}" type="currency" currencySymbol=""/>
                                    </div>
                                    <small class="text-muted">Ar</small>
                                </td>
                                <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <div class="text-info">
                                        <fmt:formatNumber value="${caTotalPublicites}" type="currency" currencySymbol=""/>
                                    </div>
                                    <small class="text-muted">Ar</small>
                                </td>
                                <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <div class="text-warning">
                                        <fmt:formatNumber value="${caTotalPublicitesPaye}" type="currency" currencySymbol=""/>
                                    </div>
                                    <small class="text-muted">Ar</small>
                                </td>
                                <td class="text-end" style="border-right: 2px solid #dee2e6;">
                                    <div class="text-danger">
                                        <fmt:formatNumber value="${caTotalResteAPayer}" type="currency" currencySymbol=""/>
                                    </div>
                                    <small class="text-muted">Ar</small>
                                </td>
                                <td class="text-end">
                                    <div class="text-primary fs-5">
                                        <fmt:formatNumber value="${caTotalGlobal}" type="currency" currencySymbol=""/>
                                    </div>
                                    <small class="text-muted">Ar</small>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </c:if>
        </div>
    </div>
</div>

<style>
    .fs-7 {
        font-size: 0.75rem !important;
    }

    .table-hover tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }
</style>

<script>
    function updatePeriode() {
        const periode = document.getElementById('periode').value;
        const moisDiv = document.getElementById('moisDiv');
        
        if (periode === 'annee') {
            moisDiv.style.display = 'none';
        } else {
            moisDiv.style.display = 'block';
        }
    }
</script>
