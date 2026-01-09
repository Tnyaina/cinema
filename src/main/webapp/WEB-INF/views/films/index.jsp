<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<div class="content-header">
    <h1>Films à l'affiche</h1>
    <a href="<c:url value='/films/nouveau'/>" class="btn btn-primary">
        <i class="fas fa-plus"></i> Ajouter un film
    </a>
</div>

<!-- SECTION FILTRES -->
<div class="filters-section">
    <form method="get" action="<c:url value='/films'/>" class="filters-form">
        <div class="filter-row">
            <div class="filter-group">
                <label for="genre">Genre</label>
                <select id="genre" name="genre" class="form-control">
                    <option value="">-- Tous les genres --</option>
                    <c:forEach var="genre" items="${genres}">
                        <option value="${genre.id}" ${param.genre == genre.id ? 'selected' : ''}>
                            ${genre.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="langue">Langue originale</label>
                <select id="langue" name="langue" class="form-control">
                    <option value="">-- Toutes les langues --</option>
                    <c:forEach var="langue" items="${langues}">
                        <option value="${langue.id}" ${param.langue == langue.id ? 'selected' : ''}>
                            ${langue.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="ageMin">Âge recommandée</label>
                <select id="ageMin" name="ageMin" class="form-control">
                    <option value="" ${param.ageMin == '0' ? 'selected' : ''}>Tous publics (0+)</option>
                    <option value="6" ${param.ageMin == '6' ? 'selected' : ''}>6+</option>
                    <option value="10" ${param.ageMin == '10' ? 'selected' : ''}>10+</option>
                    <option value="12" ${param.ageMin == '12' ? 'selected' : ''}>12+</option>
                    <option value="16" ${param.ageMin == '16' ? 'selected' : ''}>16+</option>
                    <option value="18" ${param.ageMin == '18' ? 'selected' : ''}>18+</option>
                </select>
            </div>

            <div class="filter-group">
                <label for="duree">Durée max (min)</label>
                <input type="number" id="duree" name="duree" class="form-control" 
                       placeholder="ex: 120" value="${param.duree}">
            </div>

            <div class="filter-actions">
                <button type="submit" class="btn btn-info">
                    <i class="fas fa-search"></i> Filtrer
                </button>
                <a href="<c:url value='/films'/>" class="btn btn-secondary">
                    <i class="fas fa-redo"></i> Réinitialiser
                </a>
            </div>
        </div>
    </form>
</div>

<!-- GRILLE DE FILMS -->
<div class="films-grid">
    <c:forEach var="film" items="${films}">
        <div class="film-card">
            <div class="film-poster">
                <img src="<c:url value='/img/placeholder.jpg'/>" alt="${film.titre}">
                <div class="film-overlay">
                    <a href="<c:url value='/films/${film.id}'/>" class="btn btn-primary btn-sm">Voir détails</a>
                </div>
            </div>
            <div class="film-info">
                <h3>${film.titre}</h3>
                <p class="duree">
                    <i class="fas fa-clock"></i> ${film.dureeMinutes} min
                </p>
                <p class="age-min">
                    <i class="fas fa-users"></i> 
                    <span class="badge badge-${film.ageMin > 12 ? 'danger' : 'success'}">
                        ${film.ageMin != null ? film.ageMin : 0}+
                    </span>
                </p>
                <c:if test="${not empty film.description}">
                    <p class="description">
                        <c:choose>
                            <c:when test="${fn:length(film.description) > 100}">
                                ${fn:substring(film.description, 0, 100)}...
                            </c:when>
                            <c:otherwise>
                                ${film.description}
                            </c:otherwise>
                        </c:choose>
                    </p>
                </c:if>
                <div class="film-actions">
                    <a href="<c:url value='/films/${film.id}'/>" class="btn btn-sm btn-info">
                        <i class="fas fa-eye"></i> Détails
                    </a>
                    <a href="<c:url value='/films/${film.id}/modifier'/>" class="btn btn-sm btn-warning">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<!-- MESSAGE VIDE -->
<c:if test="${empty films}">
    <div class="alert alert-info text-center">
        <i class="fas fa-info-circle"></i>
        <p>Aucun film n'a été trouvé avec ces critères.</p>
    </div>
</c:if>

<style>
    .filters-section {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
    }

    .filters-form {
        display: flex;
        flex-direction: column;
    }

    .filter-row {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        align-items: flex-end;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
    }

    .filter-group label {
        font-weight: 600;
        margin-bottom: 5px;
        font-size: 0.9rem;
    }

    .filter-actions {
        display: flex;
        gap: 10px;
    }

    .films-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
        margin-top: 20px;
    }

    .film-card {
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .film-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 16px rgba(0,0,0,0.15);
    }

    .film-poster {
        position: relative;
        width: 100%;
        height: 300px;
        overflow: hidden;
        background: #e9ecef;
    }

    .film-poster img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .film-overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.7);
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .film-card:hover .film-overlay {
        opacity: 1;
    }

    .film-info {
        padding: 15px;
    }

    .film-info h3 {
        font-size: 1.1rem;
        margin: 0 0 10px 0;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .duree, .age-min {
        font-size: 0.9rem;
        color: #666;
        margin: 5px 0;
    }

    .description {
        font-size: 0.85rem;
        color: #666;
        min-height: 40px;
        margin: 10px 0;
        line-height: 1.4;
    }

    .film-actions {
        display: flex;
        gap: 5px;
        margin-top: 10px;
    }

    .btn-sm {
        padding: 5px 10px;
        font-size: 0.85rem;
    }

    .badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 0.8rem;
        font-weight: 600;
    }

    .badge-success {
        background-color: #28a745;
        color: white;
    }

    .badge-danger {
        background-color: #dc3545;
        color: white;
    }
</style>