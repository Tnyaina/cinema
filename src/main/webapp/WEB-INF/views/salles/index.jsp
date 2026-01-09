<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<div class="content-header">
    <div class="header-title">
        <h1><i class="fas fa-door-open"></i> Salles de Cinéma</h1>
        <p class="subtitle">Gestion des salles et de leur configuration</p>
    </div>
    <a href="<c:url value='/salles/nouveau'/>" class="btn btn-primary btn-lg">
        <i class="fas fa-plus-circle"></i> Ajouter une salle
    </a>
</div>

<!-- SECTION RECHERCHE ET FILTRES -->
<div class="search-section">
    <form method="get" action="<c:url value='/salles'/>" class="search-form">
        <div class="search-group">
            <div class="search-input-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" name="recherche" class="form-control" 
                       placeholder="Rechercher par nom..." 
                       value="${param.recherche}">
            </div>
            <button type="submit" class="btn btn-secondary">
                <i class="fas fa-search"></i> Rechercher
            </button>
            <c:if test="${not empty param.recherche}">
                <a href="<c:url value='/salles'/>" class="btn btn-outline-secondary">
                    <i class="fas fa-redo-alt"></i> Réinitialiser
                </a>
            </c:if>
        </div>
    </form>
</div>

<!-- STATISTIQUES -->
<c:if test="${not empty salles}">
    <div class="stats-section">
        <div class="stat-card">
            <div class="stat-value">${fn:length(salles)}</div>
            <div class="stat-label">Salle(s)</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <c:set var="totalCapacity" value="0" />
                <c:forEach var="salle" items="${salles}">
                    <c:set var="totalCapacity" value="${totalCapacity + salle.capacite}" />
                </c:forEach>
                ${totalCapacity}
            </div>
            <div class="stat-label">Places totales</div>
        </div>
    </div>
</c:if>

<!-- LISTE DES SALLES -->
<c:choose>
    <c:when test="${empty salles}">
        <div class="empty-state">
            <div class="empty-icon">
                <i class="fas fa-door-open"></i>
            </div>
            <h2>Aucune salle trouvée</h2>
            <p>
                <c:if test="${not empty param.recherche}">
                    Votre recherche n'a retourné aucun résultat. 
                    <a href="<c:url value='/salles'/>">Consultez toutes les salles</a> ou 
                    <a href="<c:url value='/salles/nouveau'/>">créez une nouvelle salle</a>.
                </c:if>
                <c:if test="${empty param.recherche}">
                    Commencez par <a href="<c:url value='/salles/nouveau'/>">créer votre première salle</a>.
                </c:if>
            </p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="salles-grid">
            <c:forEach var="salle" items="${salles}">
                <div class="salle-card">
                    <div class="salle-header">
                        <h3>
                            <a href="<c:url value='/salles/${salle.id}'/>" class="salle-link">
                                ${salle.nom}
                            </a>
                        </h3>
                        <span class="capacity-badge">${salle.capacite} places</span>
                    </div>
                    <div class="salle-info">
                        <div class="info-item">
                            <i class="fas fa-chair"></i>
                            <span>Capacité: <strong>${salle.capacite}</strong> places</span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-calendar"></i>
                            <span>ID: <code>${salle.id}</code></span>
                        </div>
                    </div>
                    <div class="salle-actions">
                        <a href="<c:url value='/salles/${salle.id}'/>" class="btn btn-sm btn-info" title="Voir détails">
                            <i class="fas fa-eye"></i> Détails
                        </a>
                        <a href="<c:url value='/salles/${salle.id}/modifier'/>" class="btn btn-sm btn-warning" title="Modifier">
                            <i class="fas fa-edit"></i> Modifier
                        </a>
                        <a href="<c:url value='/salles/${salle.id}/supprimer'/>" class="btn btn-sm btn-danger" title="Supprimer">
                            <i class="fas fa-trash"></i> Supprimer
                        </a>
                    </div>
                </div>
            </c:forEach>
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

    .search-section {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        border: 1px solid #e0e0e0;
    }

    .search-form {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }

    .search-group {
        display: flex;
        gap: 10px;
        flex: 1;
        min-width: 300px;
        align-items: center;
    }

    .search-input-wrapper {
        flex: 1;
        position: relative;
        display: flex;
        align-items: center;
    }

    .search-input-wrapper i {
        position: absolute;
        left: 12px;
        color: #999;
        pointer-events: none;
    }

    .search-input-wrapper .form-control {
        padding-left: 35px;
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

    /* STATISTIQUES */
    .stats-section {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

    /* EMPTY STATE */
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

    /* GRID DE SALLES */
    .salles-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 20px;
    }

    .salle-card {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .salle-card:hover {
        box-shadow: 0 4px 12px rgba(0, 61, 122, 0.15);
        border-color: #003d7a;
        transform: translateY(-3px);
    }

    .salle-header {
        background-color: #003d7a;
        color: white;
        padding: 18px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .salle-header h3 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
    }

    .salle-link {
        color: white;
        text-decoration: none;
    }

    .salle-link:hover {
        text-decoration: underline;
    }

    .capacity-badge {
        background-color: rgba(255, 255, 255, 0.25);
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 12px;
        white-space: nowrap;
        font-weight: 500;
    }

    .salle-info {
        padding: 18px;
        border-bottom: 1px solid #f0f0f0;
    }

    .info-item {
        display: flex;
        align-items: center;
        gap: 10px;
        color: #666;
        font-size: 14px;
        margin-bottom: 8px;
    }

    .info-item:last-child {
        margin-bottom: 0;
    }

    .info-item i {
        color: #003d7a;
        width: 16px;
    }

    .info-item code {
        background-color: #f5f5f5;
        padding: 2px 6px;
        border-radius: 3px;
        font-family: monospace;
        font-size: 12px;
    }

    .salle-actions {
        padding: 15px;
        display: flex;
        gap: 8px;
    }

    .btn {
        padding: 10px 15px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 13px;
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
        padding: 8px 12px;
        font-size: 12px;
        flex: 1;
        justify-content: center;
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

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
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

    @media (max-width: 768px) {
        .content-header {
            flex-direction: column;
        }

        .header-title h1 {
            font-size: 24px;
        }

        .salles-grid {
            grid-template-columns: 1fr;
        }

        .search-form {
            flex-direction: column;
        }

        .search-group {
            flex-direction: column;
        }

        .btn-block {
            flex: 1;
            min-width: 150px;
        }
    }
</style>

