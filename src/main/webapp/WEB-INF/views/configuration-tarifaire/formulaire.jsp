<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>
        <c:choose>
            <c:when test="${empty configuration.id}">Nouvelle Configuration Tarifaire</c:when>
            <c:otherwise>Modifier Configuration : ${configuration.categoriePersonne.libelle}</c:otherwise>
        </c:choose>
    </h1>
</div>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-triangle"></i>
        ${param.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="form-container">
    <form method="POST" action="<c:url value='${empty configuration.id ? \"/configuration-tarifaire\" : \"/configuration-tarifaire/\".concat(configuration.id)}'/>" class="config-form">
        
        <!-- Catégorie de personne -->
        <div class="form-section">
            <h3><i class="fas fa-user"></i> Catégorie de personne</h3>
            <div class="form-group">
                <label for="categoriePersonneId">Catégorie <span class="required">*</span></label>
                <select id="categoriePersonneId" name="categoriePersonneId" class="form-control" required 
                        ${not empty configuration.id ? 'disabled' : ''}>
                    <option value="">-- Sélectionner une catégorie --</option>
                    <c:forEach var="categorie" items="${categoriesPersonne}">
                        <option value="${categorie.id}" 
                                ${configuration.categoriePersonne.id == categorie.id ? 'selected' : ''}>
                            ${categorie.libelle}
                        </option>
                    </c:forEach>
                </select>
                <c:if test="${not empty configuration.id}">
                    <input type="hidden" name="categoriePersonneId" value="${configuration.categoriePersonne.id}">
                    <small class="form-text text-muted">La catégorie ne peut pas être modifiée après création</small>
                </c:if>
            </div>
        </div>

        <!-- Configuration de référence -->
        <div class="form-section">
            <h3><i class="fas fa-link"></i> Référence Tarifaire</h3>
            
            <div class="config-type-selector">
                <div class="radio-card">
                    <input type="radio" id="typeAutonome" name="typeConfig" value="autonome" 
                           ${empty configuration.categorieReference ? 'checked' : ''} 
                           onchange="toggleReferenceConfig()">
                    <label for="typeAutonome">
                        <i class="fas fa-crown"></i>
                        <strong>Catégorie Autonome</strong>
                        <small>Tarif défini manuellement pour chaque type de place</small>
                    </label>
                </div>
                
                <div class="radio-card">
                    <input type="radio" id="typeReference" name="typeConfig" value="reference" 
                           ${not empty configuration.categorieReference ? 'checked' : ''} 
                           onchange="toggleReferenceConfig()">
                    <label for="typeReference">
                        <i class="fas fa-calculator"></i>
                        <strong>Catégorie Référencée</strong>
                        <small>Tarif calculé automatiquement selon une autre catégorie</small>
                    </label>
                </div>
            </div>

            <div id="referenceConfig" style="display: ${not empty configuration.categorieReference ? 'block' : 'none'};">
                <div class="form-group">
                    <label for="categorieReferenceId">Catégorie de référence</label>
                    <select id="categorieReferenceId" name="categorieReferenceId" class="form-control">
                        <option value="">-- Sélectionner une référence --</option>
                        <c:forEach var="categorie" items="${categoriesPersonne}">
                            <option value="${categorie.id}" 
                                    ${not empty configuration.categorieReference && configuration.categorieReference.id == categorie.id ? 'selected' : ''}>
                                ${categorie.libelle}
                            </option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">
                        La catégorie qui servira de base pour calculer le tarif
                    </small>
                </div>

                <div class="form-group">
                    <label for="coefficientMultiplicateur">Coefficient multiplicateur <span class="required">*</span></label>
                    <input type="number" 
                           id="coefficientMultiplicateur" 
                           name="coefficientMultiplicateur" 
                           class="form-control" 
                           step="0.01" 
                           min="0.01" 
                           max="10" 
                           value="${not empty configuration.coefficientMultiplicateur ? configuration.coefficientMultiplicateur : 1.0}"
                           oninput="updateCoeffPreview()"
                           required>
                    <small class="form-text text-muted">
                        Multiplicateur à appliquer au tarif de référence (ex: 0.5 pour 50%, 1.5 pour 150%)
                    </small>
                    <div id="coeffPreview" class="coeff-preview"></div>
                </div>
            </div>
        </div>

        <!-- Description -->
        <div class="form-section">
            <h3><i class="fas fa-info-circle"></i> Informations complémentaires</h3>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" 
                          name="description" 
                          class="form-control" 
                          rows="3" 
                          maxlength="500"
                          placeholder="Description de cette configuration (optionnel)...">${configuration.description}</textarea>
                <small class="form-text text-muted">Maximum 500 caractères</small>
            </div>
        </div>

        <!-- Actions -->
        <div class="form-actions">
            <a href="<c:url value='/configuration-tarifaire'/>" class="btn btn-secondary">
                <i class="fas fa-times"></i> Annuler
            </a>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i>
                ${empty configuration.id ? 'Créer la configuration' : 'Enregistrer les modifications'}
            </button>
        </div>
    </form>

    <!-- Exemples de calcul -->
    <div class="example-box">
        <h4><i class="fas fa-lightbulb"></i> Exemples de coefficients</h4>
        <table class="example-table">
            <thead>
                <tr>
                    <th>Coefficient</th>
                    <th>Signification</th>
                    <th>Exemple</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>0.5</code></td>
                    <td>50% du tarif de référence</td>
                    <td>Si Adulte = 10 000 Ar, alors cette catégorie = 5 000 Ar</td>
                </tr>
                <tr>
                    <td><code>2.0</code></td>
                    <td>200% du tarif de référence</td>
                    <td>Si Adulte = 10 000 Ar, alors cette catégorie = 20 000 Ar</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<style>
:root {
    --primary-blue: #1e3a5f;
    --primary-blue-light: #2c5282;
    --accent-blue: #3b82f6;
    --bg-light: #f8fafc;
    --border-color: #e2e8f0;
    --text-dark: #1a202c;
    --text-muted: #64748b;
    --success: #10b981;
    --warning: #f59e0b;
    --danger: #ef4444;
}

.content-header h1 {
    color: var(--primary-blue);
    font-size: 1.75rem;
    font-weight: 600;
    margin-bottom: 24px;
}

.alert {
    padding: 14px 18px;
    border-radius: 8px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    border-left: 4px solid;
}

.alert-danger {
    background: #fef2f2;
    border-color: var(--danger);
    color: #991b1b;
}

.form-container {
    max-width: 900px;
    margin: 0 auto;
}

.form-section {
    background: white;
    padding: 28px;
    margin-bottom: 20px;
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.form-section h3 {
    margin: 0 0 20px 0;
    color: var(--primary-blue);
    font-size: 1.15rem;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 10px;
    padding-bottom: 12px;
    border-bottom: 2px solid var(--border-color);
}

.form-section h3 i {
    color: var(--accent-blue);
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    color: var(--text-dark);
    font-weight: 500;
    font-size: 0.95rem;
}

.required {
    color: var(--danger);
}

.form-control {
    width: 100%;
    padding: 10px 14px;
    border: 1px solid var(--border-color);
    border-radius: 6px;
    font-size: 0.95rem;
    transition: all 0.2s ease;
    background: white;
}

.form-control:focus {
    outline: none;
    border-color: var(--accent-blue);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-control:disabled {
    background: var(--bg-light);
    color: var(--text-muted);
    cursor: not-allowed;
}

.form-text {
    display: block;
    margin-top: 6px;
    font-size: 0.875rem;
}

.text-muted {
    color: var(--text-muted);
}

.config-type-selector {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
    margin-bottom: 24px;
}

.radio-card {
    position: relative;
}

.radio-card input[type="radio"] {
    position: absolute;
    opacity: 0;
}

.radio-card label {
    display: block;
    padding: 24px 20px;
    border: 2px solid var(--border-color);
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
    text-align: center;
    background: white;
}

.radio-card label:hover {
    border-color: var(--accent-blue);
    background: #eff6ff;
}

.radio-card label i {
    font-size: 2em;
    color: var(--text-muted);
    display: block;
    margin-bottom: 12px;
    transition: color 0.2s ease;
}

.radio-card label strong {
    display: block;
    margin-bottom: 8px;
    color: var(--text-dark);
    font-size: 1rem;
}

.radio-card label small {
    display: block;
    color: var(--text-muted);
    font-size: 0.875rem;
    line-height: 1.4;
}

.radio-card input[type="radio"]:checked + label {
    border-color: var(--primary-blue);
    background: #eff6ff;
}

.radio-card input[type="radio"]:checked + label i {
    color: var(--primary-blue);
}

.radio-card input[type="radio"]:checked + label strong {
    color: var(--primary-blue);
}

.coeff-preview {
    margin-top: 12px;
    padding: 16px;
    background: #f0fdf4;
    border-left: 4px solid var(--success);
    border-radius: 6px;
    display: none;
    color: var(--text-dark);
}

.coeff-preview.show {
    display: block;
}

.example-box {
    background: #fffbeb;
    border-left: 4px solid var(--warning);
    padding: 24px;
    margin-top: 20px;
    border-radius: 8px;
}

.example-box h4 {
    margin: 0 0 16px 0;
    color: #92400e;
    font-size: 1.1rem;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 10px;
}

.example-box h4 i {
    color: var(--warning);
}

.example-table {
    width: 100%;
    margin-top: 16px;
    border-collapse: collapse;
}

.example-table th,
.example-table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #fde68a;
}

.example-table th {
    background: #fef3c7;
    font-weight: 600;
    color: var(--primary-blue);
    font-size: 0.9rem;
}

.example-table td {
    color: var(--text-dark);
}

.example-table code {
    background: #fde68a;
    padding: 4px 10px;
    border-radius: 4px;
    font-weight: 600;
    color: var(--primary-blue);
    font-family: 'Courier New', monospace;
}

.form-actions {
    display: flex;
    gap: 12px;
    justify-content: flex-end;
    padding-top: 20px;
}

.btn {
    padding: 12px 24px;
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

.btn-secondary {
    background: #e2e8f0;
    color: var(--text-dark);
}

.btn-secondary:hover {
    background: #cbd5e1;
}

.btn-primary {
    background: var(--primary-blue);
    color: white;
}

.btn-primary:hover {
    background: var(--primary-blue-light);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(30, 58, 95, 0.2);
}

@media (max-width: 768px) {
    .config-type-selector {
        grid-template-columns: 1fr;
    }
    
    .form-actions {
        flex-direction: column;
    }
    
    .btn {
        width: 100%;
        justify-content: center;
    }
}
</style>

<script>
function toggleReferenceConfig() {
    const typeReference = document.getElementById('typeReference').checked;
    const referenceConfig = document.getElementById('referenceConfig');
    const categorieReferenceSelect = document.getElementById('categorieReferenceId');
    
    if (typeReference) {
        referenceConfig.style.display = 'block';
        categorieReferenceSelect.required = true;
    } else {
        referenceConfig.style.display = 'none';
        categorieReferenceSelect.required = false;
        categorieReferenceSelect.value = '';
    }
    
    updateCoeffPreview();
}

function updateCoeffPreview() {
    const coeffInput = document.getElementById('coefficientMultiplicateur');
    const preview = document.getElementById('coeffPreview');
    const referenceSelect = document.getElementById('categorieReferenceId');
    const referenceName = referenceSelect.options[referenceSelect.selectedIndex]?.text || 'référence';
    
    if (!coeffInput || !preview) return;
    
    const coefficient = parseFloat(coeffInput.value);
    
    if (coefficient && coefficient > 0 && document.getElementById('typeReference').checked) {
        const percentage = (coefficient * 100).toFixed(0);
        const diff = ((coefficient - 1) * 100).toFixed(0);
        const absDiff = Math.abs(parseFloat(diff));
        
        let message = '<strong>' + percentage + '%</strong> du tarif ' + referenceName;
        
        if (coefficient < 1) {
            message += ' <span style="color: #10b981;">(' + absDiff.toFixed(0) + '% moins cher)</span>';
        } else if (coefficient > 1) {
            message += ' <span style="color: #ef4444;">(+' + diff + '% plus cher)</span>';
        } else {
            message += ' <span style="color: #64748b;">(même prix)</span>';
        }
        
        message += '<br><small>Exemple : Si ' + referenceName + ' = 10 000 Ar, alors cette catégorie = ' + (10000 * coefficient).toLocaleString('fr-FR') + ' Ar</small>';
        
        preview.innerHTML = message;
        preview.classList.add('show');
    } else {
        preview.classList.remove('show');
    }
}

// Initialiser au chargement
document.addEventListener('DOMContentLoaded', function() {
    toggleReferenceConfig();
    updateCoeffPreview();
    
    // Écouter les changements sur la sélection de référence
    document.getElementById('categorieReferenceId').addEventListener('change', updateCoeffPreview);
});
</script>