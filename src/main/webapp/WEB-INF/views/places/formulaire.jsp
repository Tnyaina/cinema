<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>
        <c:choose>
            <c:when test="${not empty place.id}">Modifier la place</c:when>
            <c:otherwise>Ajouter des places</c:otherwise>
        </c:choose>
    </h1>
</div>

<div class="form-container">
    <c:choose>
        <c:when test="${not empty place.id}">
            <!-- FORMULAIRE SIMPLE POUR MODIFICATION -->
            <form method="POST" action="<c:url value='/places/${place.id}'/>" class="place-form">
                <div class="form-section">
                    <h3>Localisation</h3>
                    <div class="form-section-content">
                        <div class="form-group">
                            <label for="salleId">Salle <span class="required">*</span></label>
                            <select id="salleId" name="salleId" class="form-control" required>
                                <option value="">-- Sélectionner une salle --</option>
                                <c:forEach var="salle" items="${salles}">
                                    <option value="${salle.id}" ${place.salle.id == salle.id ? 'selected' : ''}>
                                        ${salle.nom} (${salle.capacite} places)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="rangee">Rangée <span class="required">*</span></label>
                                <input type="text" id="rangee" name="rangee" class="form-control" 
                                       value="${place.rangee}" placeholder="Ex: A" required maxlength="5">
                            </div>
                            <div class="form-group">
                                <label for="numero">Numéro <span class="required">*</span></label>
                                <input type="number" id="numero" name="numero" class="form-control"
                                       value="${place.numero}" placeholder="Ex: 1" min="1" required>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>Détails</h3>
                    <div class="form-section-content">
                        <div class="form-group">
                            <label for="typePlaceId">Type de place</label>
                            <select id="typePlaceId" name="typePlaceId" class="form-control">
                                <option value="">-- Sans type spécifique --</option>
                                <c:forEach var="type" items="${typesPlace}">
                                    <option value="${type.id}" ${not empty place.typePlace && place.typePlace.id == type.id ? 'selected' : ''}>
                                        ${type.libelle}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="codePlace">Code place</label>
                            <input type="text" id="codePlace" name="codePlace" class="form-control"
                                   value="${place.codePlace}" placeholder="Auto-généré: A-1" maxlength="50">
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Enregistrer les modifications
                    </button>
                    <a href="<c:url value='/places'/>" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                </div>
            </form>
        </c:when>
        <c:otherwise>
            <!-- FORMULAIRE MULTI-LIGNE POUR CRÉATION -->
            <form method="POST" action="<c:url value='/places/creerEnMasse'/>" class="place-form">
                
                <div class="form-section">
                    <h3>Sélectionner une salle</h3>
                    <div class="form-section-content">
                        <div class="form-group">
                            <label for="salleId">Salle <span class="required">*</span></label>
                            <select id="salleId" name="salleId" class="form-control" required onchange="onSalleChange()">
                                <option value="">-- Sélectionner une salle --</option>
                                <c:forEach var="salle" items="${salles}">
                                    <option value="${salle.id}" data-capacite="${salle.capacite}" 
                                            ${not empty salleSelectionnee && salleSelectionnee.id == salle.id ? 'selected' : ''}>
                                        ${salle.nom} (${salle.capacite} places)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div id="salleInfo" class="salle-info" style="display:none;">
                            <p>Capacité totale: <strong id="capaciteSalle">-</strong> places</p>
                            <p>Vous pouvez créer plusieurs rangées à la fois ci-dessous.</p>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>Rangées à créer</h3>
                    <div class="form-section-content">
                        <p class="section-subtitle">Créez plusieurs rangées en même temps. Chaque rangée sera créée avec les numéros spécifiés.</p>

                        <div class="table-responsive">
                            <table class="rangees-table">
                                <thead>
                                    <tr>
                                        <th>Rangée</th>
                                        <th>Numéro de début</th>
                                        <th>Numéro de fin</th>
                                        <th>Places à créer</th>
                                        <th>Type de place</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="rangeesTableBody">
                                    <tr class="rangee-row">
                                        <td>
                                            <input type="text" name="rangees[]" class="form-control rangee-input" 
                                                   placeholder="Ex: A" maxlength="5" required>
                                        </td>
                                        <td>
                                            <input type="number" name="numeroDebuts[]" class="form-control numero-input" 
                                                   placeholder="1" min="1" required>
                                        </td>
                                        <td>
                                            <input type="number" name="numeroFins[]" class="form-control numero-input" 
                                                   placeholder="10" min="1" required>
                                        </td>
                                        <td>
                                            <span class="nombre-places">-</span>
                                        </td>
                                        <td>
                                            <select name="typePlaceIds[]" class="form-control">
                                                <option value="">-- Aucun --</option>
                                                <c:forEach var="type" items="${typesPlace}">
                                                    <option value="${type.id}">${type.libelle}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-danger" onclick="supprimerLigne(this)">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="rangees-actions">
                            <button type="button" class="btn btn-secondary btn-sm" onclick="ajouterLigne()">
                                <i class="fas fa-plus"></i> Ajouter une rangée
                            </button>
                        </div>

                        <div id="totalInfo" class="total-info" style="display:none;">
                            <strong>Total de places à créer:</strong> <span id="totalPlaces">0</span>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-success" id="submitBtn" disabled>
                        <i class="fas fa-save"></i> Créer les places
                    </button>
                    <a href="<c:url value='/places'/>" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</div>


<style>
    .content-header {
        margin-bottom: 40px;
    }

    .content-header h1 {
        margin: 0;
        font-size: 28px;
        color: #003d7a;
        font-weight: 600;
    }

    .form-container {
        background: white;
        border-radius: 8px;
        padding: 0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .form-section {
        border: none;
        border-radius: 0;
        overflow: hidden;
        margin-bottom: 0;
        box-shadow: none;
    }

    .form-section:first-of-type {
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;
    }

    .form-section:not(:last-of-type) {
        border-bottom: 1px solid #e0e0e0;
    }

    .form-section h3 {
        margin: 0;
        padding: 18px 30px;
        background-color: #003d7a;
        color: white;
        font-size: 16px;
        font-weight: 600;
    }

    .form-section-content {
        background-color: white;
        padding: 25px 30px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group:last-child {
        margin-bottom: 0;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .form-group label {
        font-weight: 600;
        margin-bottom: 8px;
        display: block;
        color: #333;
        font-size: 14px;
    }

    .required {
        color: #dc3545;
    }

    .form-control {
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 14px;
        width: 100%;
        transition: all 0.3s ease;
        font-family: inherit;
    }

    .form-control:focus {
        outline: none;
        border-color: #003d7a;
        box-shadow: 0 0 8px rgba(0, 61, 122, 0.3);
    }

    .form-text {
        display: block;
        margin-top: 6px;
        font-size: 12px;
        color: #666;
    }

    .salle-info {
        background-color: #f0f7ff;
        border: 1px solid #003d7a;
        border-radius: 5px;
        padding: 15px;
        margin-top: 15px;
    }

    .salle-info p {
        margin: 8px 0;
        color: #003d7a;
        font-size: 14px;
    }

    .section-subtitle {
        margin: 0 0 20px 0;
        color: #666;
        font-size: 13px;
    }

    /* TABLE DES RANGEES */
    .table-responsive {
        overflow-x: auto;
        margin-bottom: 20px;
    }

    .rangees-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .rangees-table thead {
        background-color: #f5f5f5;
        border-bottom: 2px solid #ddd;
    }

    .rangees-table thead th {
        padding: 12px;
        text-align: left;
        font-weight: 600;
        color: #333;
        font-size: 13px;
    }

    .rangees-table tbody tr {
        border-bottom: 1px solid #e0e0e0;
    }

    .rangees-table tbody tr:hover {
        background-color: #f9f9f9;
    }

    .rangees-table tbody td {
        padding: 12px;
        vertical-align: middle;
    }

    .rangee-row td:nth-child(4) {
        text-align: center;
        font-weight: 600;
        color: #003d7a;
    }

    .numero-input {
        width: 100%;
    }

    .rangees-actions {
        text-align: left;
        margin-bottom: 20px;
    }

    .total-info {
        background-color: #e8f5e9;
        border-left: 4px solid #4caf50;
        padding: 15px;
        border-radius: 4px;
        margin-top: 20px;
    }

    .total-info strong {
        color: #2e7d32;
    }

    .total-info span {
        color: #2e7d32;
        font-size: 16px;
        font-weight: bold;
    }

    .form-actions {
        display: flex;
        gap: 12px;
        margin-top: 30px;
        padding: 0 30px 30px 30px;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        transition: all 0.2s;
        text-decoration: none;
    }

    .btn:hover:not(:disabled) {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    .btn-success {
        background-color: #28a745;
        color: white;
    }

    .btn-success:hover:not(:disabled) {
        background-color: #218838;
    }

    .btn-success:disabled {
        background-color: #ccc;
        color: #999;
        cursor: not-allowed;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
    }

    .btn-danger:hover {
        background-color: #c82333;
    }

    .btn-sm {
        padding: 8px 12px;
        font-size: 12px;
    }

    @media (max-width: 768px) {
        .form-row {
            grid-template-columns: 1fr;
        }

        .form-section h3,
        .form-section-content,
        .form-actions {
            padding-left: 15px;
            padding-right: 15px;
        }

        .table-responsive {
            font-size: 12px;
        }

        .rangees-table thead th,
        .rangees-table tbody td {
            padding: 8px;
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
    let typesPlaceOptions = '';

    function onSalleChange() {
        const select = document.getElementById('salleId');
        const salleInfo = document.getElementById('salleInfo');
        const capaciteSalle = document.getElementById('capaciteSalle');
        
        if (select.value) {
            const option = select.options[select.selectedIndex];
            capaciteSalle.textContent = option.getAttribute('data-capacite');
            salleInfo.style.display = 'block';
        } else {
            salleInfo.style.display = 'none';
        }
    }

    function ajouterLigne() {
        const tbody = document.getElementById('rangeesTableBody');
        const tr = document.createElement('tr');
        tr.className = 'rangee-row';
        
        tr.innerHTML = `
            <td>
                <input type="text" name="rangees[]" class="form-control rangee-input" 
                       placeholder="Ex: A" maxlength="5" required>
            </td>
            <td>
                <input type="number" name="numeroDebuts[]" class="form-control numero-input" 
                       placeholder="1" min="1" required>
            </td>
            <td>
                <input type="number" name="numeroFins[]" class="form-control numero-input" 
                       placeholder="10" min="1" required>
            </td>
            <td>
                <span class="nombre-places">-</span>
            </td>
            <td>
                <select name="typePlaceIds[]" class="form-control">
                    ${typesPlaceOptions}
                </select>
            </td>
            <td>
                <button type="button" class="btn btn-sm btn-danger" onclick="supprimerLigne(this)">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        `;
        
        tbody.appendChild(tr);
        attachInputListeners(tr);
        updateTotal();
    }

    function supprimerLigne(btn) {
        btn.closest('tr').remove();
        updateTotal();
    }

    function attachInputListeners(row) {
        const inputs = row.querySelectorAll('.numero-input');
        inputs.forEach(input => {
            input.addEventListener('change', updateTotal);
            input.addEventListener('keyup', updateTotal);
        });
    }

    function updateTotal() {
        const rows = document.querySelectorAll('.rangee-row');
        let totalPlaces = 0;
        
        rows.forEach(row => {
            const debut = parseInt(row.querySelector('[name="numeroDebuts[]"]').value) || 0;
            const fin = parseInt(row.querySelector('[name="numeroFins[]"]').value) || 0;
            const nombre = debut > 0 && fin >= debut ? fin - debut + 1 : 0;
            
            row.querySelector('.nombre-places').textContent = nombre;
            totalPlaces += nombre;
        });
        
        const totalInfo = document.getElementById('totalInfo');
        const totalPlacesSpan = document.getElementById('totalPlaces');
        const submitBtn = document.getElementById('submitBtn');
        
        totalPlacesSpan.textContent = totalPlaces;
        totalInfo.style.display = totalPlaces > 0 ? 'block' : 'none';
        submitBtn.disabled = totalPlaces === 0;
    }

    // Initialiser les listeners au chargement
    document.addEventListener('DOMContentLoaded', function() {
        // Récupérer les options des types de place depuis le select original
        const typeSelectOriginal = document.querySelector('select[name="typePlaceIds[]"]');
        if (typeSelectOriginal) {
            typesPlaceOptions = '<option value="">-- Aucun --</option>';
            const options = typeSelectOriginal.querySelectorAll('option');
            options.forEach(opt => {
                if (opt.value) {
                    typesPlaceOptions += `<option value="${opt.value}">${opt.textContent}</option>`;
                }
            });
        }
        
        const rows = document.querySelectorAll('.rangee-row');
        rows.forEach(attachInputListeners);
        updateTotal();
        
        // Trigger salle change si une salle est préselectionnée
        onSalleChange();
    });
</script>
