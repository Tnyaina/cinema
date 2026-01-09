<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<div class="content-header">
    <div class="header-title">
        <h1><i class="fas fa-film"></i> Séances</h1>
        <p class="subtitle">Programmation des projections</p>
    </div>
    <a href="<c:url value='/seances/nouveau'/>" class="btn btn-primary btn-lg">
        <i class="fas fa-plus-circle"></i> Ajouter une séance
    </a>
</div>

<!-- FILTRES -->
<div class="filters-section">
    <form method="get" action="<c:url value='/seances'/>" class="filters-form">
        <div class="filter-group">
            <label for="film">Film</label>
            <select id="film" name="film" class="form-control" onchange="this.form.submit()">
                <option value="">-- Tous les films --</option>
                <c:forEach var="f" items="${films}">
                    <option value="${f.id}" ${param.film == f.id ? 'selected' : ''}>
                        ${f.titre}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="filter-group">
            <label for="salle">Salle</label>
            <select id="salle" name="salle" class="form-control" onchange="this.form.submit()">
                <option value="">-- Toutes les salles --</option>
                <c:forEach var="s" items="${salles}">
                    <option value="${s.id}" ${param.salle == s.id ? 'selected' : ''}>
                        ${s.nom}
                    </option>
                </c:forEach>
            </select>
        </div>

        <c:if test="${not empty param.film || not empty param.salle}">
            <a href="<c:url value='/seances'/>" class="btn btn-outline-secondary">
                <i class="fas fa-redo-alt"></i> Réinitialiser
            </a>
        </c:if>
    </form>
</div>

<!-- STATISTIQUES -->
<c:if test="${not empty seances}">
    <div class="stats-section">
        <div class="stat-card">
            <div class="stat-value">${fn:length(seances)}</div>
            <div class="stat-label">Séance(s)</div>
        </div>
    </div>
</c:if>

<!-- LISTE DES SEANCES -->
<c:choose>
    <c:when test="${empty seances}">
        <div class="empty-state">
            <div class="empty-icon">
                <i class="fas fa-film"></i>
            </div>
            <h2>Aucune séance trouvée</h2>
            <p>
                <a href="<c:url value='/seances/nouveau'/>">Créez votre première séance</a>.
            </p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Film</th>
                        <th>Salle</th>
                        <th>Date</th>
                        <th>Horaire</th>
                        <th>Statut</th>
                        <th class="text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="seance" items="${seances}">
                        <tr>
                            <td>
                                <a href="<c:url value='/seances/${seance.id}'/>" class="link">
                                    <strong>${seance.film.titre}</strong>
                                </a>
                            </td>
                            <td>${seance.salle.nom}</td>
                            <td>${seance.getDateSeanceFormatted()}</td>
                            <td>
                                <span class="horaire-badge">
                                    ${seance.getHeureDebutFormatted()} 
                                    <c:if test="${not empty seance.fin}">
                                        - ${seance.getHeureFin()}
                                    </c:if>
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${seance.estDisponible()}">
                                        <span class="badge badge-success">Disponible</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Passée</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-right">
                                <a href="<c:url value='/seances/${seance.id}'/>" class="btn btn-sm btn-info" title="Voir détails">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="<c:url value='/seances/${seance.id}/modifier'/>" class="btn btn-sm btn-warning" title="Modifier">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="<c:url value='/seances/${seance.id}/supprimer'/>" class="btn btn-sm btn-danger" title="Supprimer">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>

<style>
    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
        gap: 20px;
    }

    .header-title h1 {
        margin: 0;
        font-size: 32px;
        color: #003d7a;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .header-title h1 i {
        color: #003d7a;
    }

    .subtitle {
        margin: 8px 0 0 0;
        color: #666;
        font-size: 14px;
    }

    .filters-section {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        border: 1px solid #e0e0e0;
    }

    .filters-form {
        display: flex;
        gap: 15px;
        align-items: flex-end;
        flex-wrap: wrap;
    }

    .filter-group {
        flex: 1;
        min-width: 200px;
    }

    .filter-group label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-weight: 600;
        font-size: 13px;
    }

    .form-control {
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        width: 100%;
    }

    .form-control:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 5px rgba(0, 61, 122, 0.2);
    }

    .stats-section {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 15px;
        margin-bottom: 30px;
    }

    .stat-card {
        background-color: #003d7a;
        color: white;
        padding: 25px;
        border-radius: 8px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0, 61, 122, 0.15);
    }

    .stat-value {
        font-size: 32px;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .stat-label {
        font-size: 14px;
        opacity: 0.9;
    }

    .table-responsive {
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .table {
        margin: 0;
        width: 100%;
        border-collapse: collapse;
    }

    .table thead {
        background-color: #003d7a;
        color: white;
    }

    .table thead th {
        padding: 15px;
        font-weight: 600;
        font-size: 14px;
    }

    .table tbody td {
        padding: 12px 15px;
        border-bottom: 1px solid #e0e0e0;
    }

    .table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .link {
        color: #003d7a;
        text-decoration: none;
        font-weight: 500;
    }

    .link:hover {
        text-decoration: underline;
    }

    .horaire-badge {
        background-color: #e8f1ff;
        color: #003d7a;
        padding: 5px 10px;
        border-radius: 3px;
        font-size: 13px;
        font-weight: 500;
    }

    .badge {
        padding: 5px 10px;
        border-radius: 3px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }

    .badge-success {
        background-color: #28a745;
        color: white;
    }

    .badge-danger {
        background-color: #dc3545;
        color: white;
    }

    .text-right {
        text-align: right;
    }

    .btn {
        padding: 8px 12px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 12px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-weight: 500;
        transition: all 0.2s;
    }

    .btn:hover {
        transform: translateY(-2px);
    }

    .btn-sm {
        padding: 6px 10px;
    }

    .btn-info {
        background-color: #17a2b8;
        color: white;
    }

    .btn-info:hover {
        background-color: #138496;
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

    .btn-primary {
        background-color: #003d7a;
        color: white;
    }

    .btn-primary:hover {
        background-color: #002d5a;
    }

    .btn-outline-secondary {
        border: 1px solid #6c757d;
        color: #6c757d;
        background-color: transparent;
    }

    .btn-outline-secondary:hover {
        background-color: #6c757d;
        color: white;
    }

    .btn-lg {
        padding: 12px 24px;
        font-size: 14px;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background-color: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #e0e0e0;
    }

    .empty-icon {
        font-size: 64px;
        color: #ccc;
        margin-bottom: 20px;
    }

    .empty-state h2 {
        color: #333;
        margin-bottom: 10px;
        font-weight: 600;
    }

    .empty-state p {
        color: #666;
        font-size: 14px;
    }

    .empty-state a {
        color: #003d7a;
        text-decoration: none;
        font-weight: 500;
    }

    .empty-state a:hover {
        text-decoration: underline;
    }

    @media (max-width: 768px) {
        .content-header {
            flex-direction: column;
        }

        .header-title h1 {
            font-size: 24px;
        }

        .filters-form {
            flex-direction: column;
        }

        .filter-group {
            width: 100%;
        }

        .table {
            font-size: 13px;
        }

        .table thead th,
        .table tbody td {
            padding: 10px;
        }

        .text-right {
            text-align: left;
        }
    }
</style>
