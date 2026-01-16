<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1><i class="fas fa-exclamation-triangle"></i> Confirmation de suppression</h1>
</div>

<div class="confirmation-container">
    <div class="warning-card">
        <div class="warning-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        
        <div class="warning-content">
            <h2>Êtes-vous sûr de vouloir supprimer cette configuration ?</h2>
            
            <div class="config-info">
                <div class="info-row">
                    <span class="label">Catégorie :</span>
                    <span class="value badge badge-primary">
                        ${configuration.categoriePersonne.libelle}
                    </span>
                </div>
                
                <c:if test="${configuration.aUneReference()}">
                    <div class="info-row">
                        <span class="label">Référence :</span>
                        <span class="value badge badge-secondary">
                            ${configuration.categorieReference.libelle}
                        </span>
                    </div>
                    
                    <div class="info-row">
                        <span class="label">Coefficient :</span>
                        <span class="value">
                            <code>${configuration.coefficientMultiplicateur}</code>
                        </span>
                    </div>
                </c:if>
            </div>

            <!-- Avertissement si utilisée comme référence -->
            <c:if test="${not empty configurationsDependantes}">
                <div class="alert alert-danger">
                    <div class="alert-header">
                        <i class="fas fa-exclamation-circle"></i>
                        <strong>Attention : Cette catégorie est utilisée comme référence !</strong>
                    </div>
                    <p>Les configurations suivantes dépendent de cette catégorie :</p>
                    <ul class="dependants-list">
                        <c:forEach var="dependante" items="${configurationsDependantes}">
                            <li>
                                <span class="badge badge-warning">
                                    ${dependante.categoriePersonne.libelle}
                                </span>
                                <i class="fas fa-arrow-left"></i>
                                <span class="badge badge-secondary">
                                    ${dependante.categorieReference.libelle}
                                </span>
                                (coeff: ${dependante.coefficientMultiplicateur})
                            </li>
                        </c:forEach>
                    </ul>
                    <p class="warning-message">
                        <i class="fas fa-info-circle"></i>
                        Ces configurations devront être reconfigurées après la suppression.
                    </p>
                </div>
            </c:if>

            <!-- Information sur les catégories autonomes -->
            <c:if test="${not configuration.aUneReference()}">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <strong>Note :</strong> Cette catégorie est autonome (sans référence). 
                    Ses tarifs devront être définis manuellement après la suppression de cette configuration.
                </div>
            </c:if>

            <div class="consequences">
                <h3>Conséquences de la suppression :</h3>
                <ul>
                    <li>
                        <i class="fas fa-times-circle"></i>
                        La configuration pour <strong>${configuration.categoriePersonne.libelle}</strong> sera supprimée définitivement
                    </li>
                    <c:if test="${not empty configurationsDependantes}">
                        <li>
                            <i class="fas fa-exclamation-triangle"></i>
                            Les <strong>${configurationsDependantes.size()} configuration(s) dépendante(s)</strong> devront être modifiées
                        </li>
                    </c:if>
                    <c:if test="${configuration.aUneReference()}">
                        <li>
                            <i class="fas fa-calculator"></i>
                            Le calcul automatique des tarifs pour cette catégorie ne sera plus appliqué
                        </li>
                    </c:if>
                    <li>
                        <i class="fas fa-undo"></i>
                        Cette action peut être annulée en recréant une configuration similaire
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="action-section">
        <form method="POST" action="<c:url value='/configuration-tarifaire/${configuration.id}/supprimer'/>" class="delete-form">
            <button type="submit" class="btn btn-danger btn-lg">
                <i class="fas fa-trash"></i>
                Oui, supprimer cette configuration
            </button>
        </form>
        
        <a href="<c:url value='/configuration-tarifaire/${configuration.id}'/>" class="btn btn-secondary btn-lg">
            <i class="fas fa-times"></i>
            Non, annuler
        </a>
    </div>
</div>

<style>
.confirmation-container {
    max-width: 700px;
    margin: 0 auto;
}

.warning-card {
    background: white;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    overflow: hidden;
    margin-bottom: 30px;
}

.warning-icon {
    background: #dc3545;
    color: white;
    padding: 30px;
    text-align: center;
    font-size: 3em;
}

.warning-content {
    padding: 30px;
}

.warning-content h2 {
    color: #333;
    margin-top: 0;
    margin-bottom: 25px;
    text-align: center;
}

.config-info {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 6px;
    margin-bottom: 25px;
}

.info-row {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 10px 0;
    border-bottom: 1px solid #e9ecef;
}

.info-row:last-child {
    border-bottom: none;
}

.info-row .label {
    font-weight: 600;
    color: #666;
    min-width: 120px;
}

.info-row .value {
    flex: 1;
}

.badge {
    padding: 6px 12px;
    border-radius: 4px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 0.95em;
}

.badge-primary {
    background: #007bff;
    color: white;
}

.badge-secondary {
    background: #6c757d;
    color: white;
}

.badge-warning {
    background: #ffc107;
    color: #333;
}

.info-row code {
    background: #e9ecef;
    padding: 4px 10px;
    border-radius: 4px;
    font-size: 1.1em;
    font-weight: bold;
}

.alert {
    padding: 20px;
    border-radius: 6px;
    margin-bottom: 20px;
    border-left: 4px solid;
}

.alert-danger {
    background: #f8d7da;
    border-color: #dc3545;
    color: #721c24;
}

.alert-info {
    background: #d1ecf1;
    border-color: #17a2b8;
    color: #0c5460;
}

.alert-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 15px;
    font-size: 1.05em;
}

.alert p {
    margin: 10px 0;
}

.dependants-list {
    list-style: none;
    padding: 0;
    margin: 15px 0;
}

.dependants-list li {
    padding: 12px;
    background: white;
    border-radius: 4px;
    margin-bottom: 10px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.warning-message {
    margin-top: 15px;
    padding-top: 15px;
    border-top: 1px solid #dc3545;
    font-weight: 600;
}

.consequences {
    margin-top: 25px;
    padding-top: 25px;
    border-top: 2px solid #e9ecef;
}

.consequences h3 {
    color: #495057;
    margin-bottom: 15px;
}

.consequences ul {
    list-style: none;
    padding: 0;
}

.consequences li {
    padding: 12px;
    margin-bottom: 10px;
    display: flex;
    align-items: flex-start;
    gap: 12px;
    background: #f8f9fa;
    border-radius: 4px;
}

.consequences li i {
    color: #dc3545;
    margin-top: 2px;
    font-size: 1.1em;
}

.action-section {
    display: flex;
    gap: 15px;
    justify-content: center;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
}

.delete-form {
    margin: 0;
}

.btn-lg {
    padding: 14px 30px;
    font-size: 1.1em;
    border-radius: 6px;
    border: none;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    text-decoration: none;
    transition: all 0.3s ease;
}

.btn-danger {
    background: #dc3545;
    color: white;
}

.btn-danger:hover {
    background: #c82333;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(220,53,69,0.3);
}

.btn-secondary {
    background: #6c757d;
    color: white;
}

.btn-secondary:hover {
    background: #5a6268;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(108,117,125,0.3);
}
</style>
