<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-top">
        <h1>Configuration Tarifaire</h1>
        <a href="<c:url value='/configuration-tarifaire/nouveau'/>" class="btn btn-success">
            <i class="fas fa-plus"></i> Ajouter une configuration
        </a>
    </div>
</div>

<c:if test="${not empty param.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i>
        <c:choose>
            <c:when test="${param.success == 'config_supprimee'}">Configuration supprimée avec succès</c:when>
            <c:when test="${param.success == 'config_creee'}">Configuration créée avec succès</c:when>
            <c:when test="${param.success == 'config_modifiee'}">Configuration modifiée avec succès</c:when>
            <c:otherwise>Opération réussie</c:otherwise>
        </c:choose>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-triangle"></i>
        ${param.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Information sur les catégories autonomes -->
<c:if test="${not empty categoriesAutonomes}">
    <div class="info-box">
        <div class="info-box-header">
            <i class="fas fa-info-circle"></i>
            <h3>Catégories Autonomes (Tarifs fixes)</h3>
        </div>
        <div class="info-box-content">
            <p>Les catégories suivantes ont des tarifs définis manuellement :</p>
            <div class="categories-list">
                <c:forEach var="config" items="${categoriesAutonomes}">
                    <span class="badge badge-info">
                        <i class="fas fa-tag"></i>
                        ${config.categoriePersonne.libelle}
                    </span>
                </c:forEach>
            </div>
        </div>
    </div>
</c:if>

<div class="card">
    <c:choose>
        <c:when test="${empty configurations}">
            <div class="empty-state">
                <i class="fas fa-cogs fa-3x"></i>
                <p>Aucune configuration tarifaire définie.</p>
                <a href="<c:url value='/configuration-tarifaire/nouveau'/>" class="btn btn-primary">
                    Créer la première configuration
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table">
                <thead>
                    <tr>
                        <th>Catégorie</th>
                        <th>Référence</th>
                        <th>Coefficient</th>
                        <th>Relation</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="config" items="${configurations}">
                        <tr>
                            <td>
                                <strong>${config.categoriePersonne.libelle}</strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${config.aUneReference()}">
                                        <span class="badge badge-secondary">
                                            <i class="fas fa-arrow-left"></i>
                                            ${config.categorieReference.libelle}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-primary">
                                            <i class="fas fa-crown"></i>
                                            Autonome
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <code>${config.coefficientMultiplicateur}</code>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${config.aUneReference()}">
                                        <span class="tarif-relation">
                                            ${config.pourcentageParRapportReference}% du tarif ${config.categorieReference.libelle}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Tarif fixe</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty config.description}">
                                        ${config.description}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="actions">
                                <a href="<c:url value='/configuration-tarifaire/${config.id}'/>" 
                                   class="btn btn-sm btn-info" title="Voir">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="<c:url value='/configuration-tarifaire/${config.id}/modifier'/>" 
                                   class="btn btn-sm btn-warning" title="Modifier">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="<c:url value='/configuration-tarifaire/${config.id}/supprimer'/>" 
                                   class="btn btn-sm btn-danger" title="Supprimer">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<!-- Section Appliquer la configuration -->
<c:if test="${not empty configurations}">
    <div class="apply-section">
        <div class="apply-header">
            <i class="fas fa-sync-alt"></i>
            <div>
                <h3>Appliquer la configuration</h3>
                <p>Utiliser cette configuration pour recalculer automatiquement tous les tarifs</p>
            </div>
        </div>
        
        <div class="apply-actions">
            <form method="POST" action="<c:url value='/configuration-tarifaire/appliquer'/>" 
                  class="apply-form" onsubmit="return confirm('Êtes-vous sûr de vouloir appliquer la configuration à tous les tarifs par défaut ?');">
                <button type="submit" class="btn btn-apply">
                    <i class="fas fa-sync"></i>
                    Appliquer aux tarifs par défaut
                </button>
                <small>Recalcule tous les tarifs existants selon la configuration</small>
            </form>
            
            <form method="POST" action="<c:url value='/configuration-tarifaire/appliquer-seances'/>" 
                  class="apply-form" onsubmit="return confirm('Êtes-vous sûr de vouloir appliquer la configuration aux tarifs de séance ?');">
                <button type="submit" class="btn btn-apply">
                    <i class="fas fa-calendar"></i>
                    Appliquer aux tarifs de séance
                </button>
                <small>Applique la configuration aux futures séances</small>
            </form>
        </div>
    </div>
</c:if>

<style>
/* Variables de couleur */
:root {
    --primary-blue: #1e3a5f;
    --primary-blue-light: #2c5282;
    --primary-blue-dark: #152844;
    --accent-blue: #3b82f6;
    --bg-light: #f8fafc;
    --border-color: #e2e8f0;
    --text-dark: #1a202c;
    --text-muted: #64748b;
    --success: #10b981;
    --warning: #f59e0b;
    --danger: #ef4444;
}

/* Header */
.content-header {
    margin-bottom: 24px;
}

.header-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 0;
}

.header-top h1 {
    color: var(--primary-blue);
    font-size: 1.75rem;
    font-weight: 600;
    margin: 0;
}

.btn {
    padding: 10px 20px;
    border-radius: 6px;
    border: none;
    font-size: 0.95rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.btn-success {
    background: var(--success);
    color: white;
}

.btn-success:hover {
    background: #059669;
    transform: translateY(-1px);
}

.btn-primary {
    background: var(--primary-blue);
    color: white;
}

.btn-primary:hover {
    background: var(--primary-blue-light);
}

/* Alertes */
.alert {
    padding: 14px 18px;
    border-radius: 8px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    border-left: 4px solid;
}

.alert-success {
    background: #f0fdf4;
    border-color: var(--success);
    color: #166534;
}

.alert-danger {
    background: #fef2f2;
    border-color: var(--danger);
    color: #991b1b;
}

/* Info Box */
.info-box {
    background: #eff6ff;
    border-left: 4px solid var(--accent-blue);
    padding: 18px 20px;
    margin-bottom: 24px;
    border-radius: 8px;
}

.info-box-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;
}

.info-box-header i {
    color: var(--accent-blue);
    font-size: 1.2em;
}

.info-box-header h3 {
    margin: 0;
    font-size: 1.05rem;
    color: var(--primary-blue);
    font-weight: 600;
}

.info-box-content p {
    margin: 0 0 12px 0;
    color: var(--text-muted);
}

.categories-list {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.badge {
    padding: 6px 14px;
    border-radius: 6px;
    font-size: 0.875rem;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-weight: 500;
}

.badge-info {
    background: var(--accent-blue);
    color: white;
}

.badge-primary {
    background: var(--primary-blue);
    color: white;
}

.badge-secondary {
    background: var(--text-muted);
    color: white;
}

/* Card et Table */
.card {
    background: white;
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    margin-bottom: 24px;
}

.table {
    width: 100%;
    border-collapse: collapse;
}

.table thead {
    background: var(--primary-blue);
}

.table thead th {
    padding: 14px 16px;
    text-align: left;
    font-weight: 600;
    font-size: 0.875rem;
    color: white;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.table tbody tr {
    border-bottom: 1px solid var(--border-color);
    transition: background 0.15s ease;
}

.table tbody tr:hover {
    background: var(--bg-light);
}

.table tbody td {
    padding: 14px 16px;
    color: var(--text-dark);
}

.table tbody td strong {
    color: var(--primary-blue);
    font-weight: 600;
}

.table tbody td code {
    background: #f1f5f9;
    padding: 4px 10px;
    border-radius: 4px;
    color: var(--primary-blue);
    font-family: 'Courier New', monospace;
    font-size: 0.9rem;
}

.tarif-relation {
    color: var(--success);
    font-weight: 500;
}

.text-muted {
    color: var(--text-muted);
}

.actions {
    display: flex;
    gap: 6px;
}

.btn-sm {
    padding: 6px 12px;
    font-size: 0.875rem;
}

.btn-info {
    background: var(--accent-blue);
    color: white;
}

.btn-info:hover {
    background: #2563eb;
}

.btn-warning {
    background: var(--warning);
    color: white;
}

.btn-warning:hover {
    background: #d97706;
}

.btn-danger {
    background: var(--danger);
    color: white;
}

.btn-danger:hover {
    background: #dc2626;
}

/* Section Appliquer */
.apply-section {
    background: white;
    border: 2px solid var(--primary-blue-light);
    border-radius: 10px;
    padding: 28px;
    box-shadow: 0 2px 8px rgba(30, 58, 95, 0.1);
}

.apply-header {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    margin-bottom: 24px;
    padding-bottom: 20px;
    border-bottom: 2px solid var(--border-color);
}

.apply-header i {
    color: var(--primary-blue);
    font-size: 1.8em;
    margin-top: 4px;
}

.apply-header h3 {
    margin: 0 0 6px 0;
    color: var(--primary-blue);
    font-size: 1.25rem;
    font-weight: 600;
}

.apply-header p {
    color: var(--text-muted);
    font-size: 0.95rem;
    margin: 0;
}

.apply-actions {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 16px;
}

.apply-form {
    background: var(--bg-light);
    border: 1px solid var(--border-color);
    padding: 20px;
    border-radius: 8px;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.btn-apply {
    background: var(--primary-blue);
    color: white;
    padding: 12px 20px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
}

.btn-apply:hover {
    background: var(--primary-blue-light);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(30, 58, 95, 0.2);
}

.apply-form small {
    color: var(--text-muted);
    font-size: 0.875rem;
    line-height: 1.4;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 60px 20px;
}

.empty-state i {
    color: var(--border-color);
    margin-bottom: 20px;
}

.empty-state p {
    color: var(--text-muted);
    font-size: 1.05rem;
    margin-bottom: 24px;
}
</style>