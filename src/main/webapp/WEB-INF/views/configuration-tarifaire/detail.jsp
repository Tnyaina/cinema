<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <div class="header-top">
        <h1>Configuration : ${configuration.categoriePersonne.libelle}</h1>
        <div class="action-buttons">
            <a href="<c:url value='/configuration-tarifaire/${configuration.id}/modifier'/>" class="btn btn-warning">
                <i class="fas fa-edit"></i> Modifier
            </a>
            <a href="<c:url value='/configuration-tarifaire/${configuration.id}/supprimer'/>" class="btn btn-danger">
                <i class="fas fa-trash"></i> Supprimer
            </a>
            <a href="<c:url value='/configuration-tarifaire'/>" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Retour
            </a>
        </div>
    </div>
</div>

<div class="detail-container">
    <div class="detail-card">
        <div class="card-header">
            <h3><i class="fas fa-info-circle"></i> Informations générales</h3>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item">
                    <label>Catégorie de personne :</label>
                    <div class="value">
                        <span class="badge badge-primary">
                            <i class="fas fa-user"></i>
                            ${configuration.categoriePersonne.libelle}
                        </span>
                    </div>
                </div>

                <div class="info-item">
                    <label>Type de configuration :</label>
                    <div class="value">
                        <c:choose>
                            <c:when test="${configuration.aUneReference()}">
                                <span class="badge badge-info">
                                    <i class="fas fa-calculator"></i>
                                    Catégorie Référencée
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-success">
                                    <i class="fas fa-crown"></i>
                                    Catégorie Autonome
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <c:if test="${configuration.aUneReference()}">
                    <div class="info-item">
                        <label>Référence :</label>
                        <div class="value">
                            <span class="badge badge-secondary">
                                <i class="fas fa-arrow-left"></i>
                                ${configuration.categorieReference.libelle}
                            </span>
                        </div>
                    </div>

                    <div class="info-item">
                        <label>Coefficient multiplicateur :</label>
                        <div class="value">
                            <code class="coefficient">${configuration.coefficientMultiplicateur}</code>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <c:if test="${configuration.aUneReference()}">
        <div class="detail-card">
            <div class="card-header">
                <h3><i class="fas fa-chart-line"></i> Calcul du tarif</h3>
            </div>
            <div class="card-body">
                <div class="tarif-formula">
                    <div class="formula-item">
                        <div class="formula-label">Formule :</div>
                        <div class="formula-value">
                            Tarif ${configuration.categoriePersonne.libelle} = 
                            Tarif ${configuration.categorieReference.libelle} × ${configuration.coefficientMultiplicateur}
                        </div>
                    </div>

                    <div class="formula-item">
                        <div class="formula-label">Pourcentage :</div>
                        <div class="formula-value">
                            <strong>${configuration.pourcentageParRapportReference}%</strong> 
                            du tarif ${configuration.categorieReference.libelle}
                        </div>
                    </div>

                    <div class="formula-item">
                        <div class="formula-label">Différence :</div>
                        <div class="formula-value">
                            <c:choose>
                                <c:when test="${configuration.coefficientMultiplicateur < 1}">
                                    <span class="diff-negative">
                                        <i class="fas fa-arrow-down"></i>
                                        ${-configuration.differenceEnPourcentage}% moins cher
                                    </span>
                                </c:when>
                                <c:when test="${configuration.coefficientMultiplicateur > 1}">
                                    <span class="diff-positive">
                                        <i class="fas fa-arrow-up"></i>
                                        +${configuration.differenceEnPourcentage}% plus cher
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="diff-neutral">
                                        <i class="fas fa-equals"></i>
                                        Même prix
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Exemples de calcul -->
                <div class="calculation-examples">
                    <h4>Exemples de calcul :</h4>
                    <table class="examples-table">
                        <thead>
                            <tr>
                                <th>Tarif ${configuration.categorieReference.libelle}</th>
                                <th>Calcul</th>
                                <th>Tarif ${configuration.categoriePersonne.libelle}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="exemple" items="${[5000, 10000, 15000, 20000]}">
                                <tr>
                                    <td>${exemple} Ar</td>
                                    <td>${exemple} × ${configuration.coefficientMultiplicateur}</td>
                                    <td><strong>${exemple * configuration.coefficientMultiplicateur} Ar</strong></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty configuration.description}">
        <div class="detail-card">
            <div class="card-header">
                <h3><i class="fas fa-file-alt"></i> Description</h3>
            </div>
            <div class="card-body">
                <p>${configuration.description}</p>
            </div>
        </div>
    </c:if>
</div>

<style>
.detail-container {
    max-width: 900px;
    margin: 0 auto;
}

.detail-card {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    margin-bottom: 20px;
    overflow: hidden;
}

.card-header {
    background: #f8f9fa;
    padding: 15px 20px;
    border-bottom: 2px solid #e9ecef;
}

.card-header h3 {
    margin: 0;
    display: flex;
    align-items: center;
    gap: 10px;
    color: #333;
}

.card-body {
    padding: 25px;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

.info-item {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.info-item label {
    font-weight: 600;
    color: #666;
    font-size: 0.9em;
}

.info-item .value {
    font-size: 1.1em;
}

.badge {
    padding: 8px 14px;
    border-radius: 4px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 1em;
}

.badge-primary {
    background: #007bff;
    color: white;
}

.badge-secondary {
    background: #6c757d;
    color: white;
}

.badge-info {
    background: #17a2b8;
    color: white;
}

.badge-success {
    background: #28a745;
    color: white;
}

.coefficient {
    background: #e9ecef;
    padding: 4px 12px;
    border-radius: 4px;
    font-size: 1.3em;
    font-weight: bold;
    color: #495057;
}

.tarif-formula {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 6px;
    margin-bottom: 20px;
}

.formula-item {
    display: grid;
    grid-template-columns: 150px 1fr;
    gap: 15px;
    padding: 12px 0;
    border-bottom: 1px solid #e9ecef;
}

.formula-item:last-child {
    border-bottom: none;
}

.formula-label {
    font-weight: 600;
    color: #666;
}

.formula-value {
    color: #333;
}

.diff-negative {
    color: #28a745;
    font-weight: 600;
}

.diff-positive {
    color: #dc3545;
    font-weight: 600;
}

.diff-neutral {
    color: #6c757d;
    font-weight: 600;
}

.calculation-examples h4 {
    margin-top: 0;
    margin-bottom: 15px;
    color: #495057;
}

.examples-table {
    width: 100%;
    border-collapse: collapse;
}

.examples-table th,
.examples-table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #e9ecef;
}

.examples-table th {
    background: #f8f9fa;
    font-weight: 600;
    color: #495057;
}

.examples-table tr:hover {
    background: #f8f9fa;
}

.examples-table strong {
    color: #28a745;
}
</style>
