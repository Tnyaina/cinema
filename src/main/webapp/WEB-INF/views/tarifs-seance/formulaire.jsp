<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="content-header">
    <h1>Ajouter des tarifs de séance</h1>
</div>

<c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle"></i> ${param.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="form-container">
    <form method="POST" action="<c:url value='/tarifs-seance/creerEnMasse'/>" class="tarif-form">
        <div class="form-section">
            <h3>Sélectionner une séance</h3>
            <div class="form-section-content">
                <div class="form-group">
                    <label for="seanceId">Séance <span class="required">*</span></label>
                    <select id="seanceId" name="seanceId" class="form-control" required onchange="onSeanceChange()">
                        <option value="">-- Sélectionner une séance --</option>
                        <c:forEach var="s" items="${seances}">
                            <option value="${s.id}" data-film="${s.film.titre}" data-debut="${s.debut}" data-salle="${s.salle.nom}">
                                ${s.film.titre} - ${s.debut} (${s.salle.nom})
                            </option>
                        </c:forEach>
                    </select>
                    <div id="seanceInfo" class="info-box" style="display: none;">
                        <p>Film: <strong id="filmName">-</strong></p>
                        <p>Salle: <strong id="salleName">-</strong></p>
                        <p>Vous pouvez créer plusieurs tarifs à la fois ci-dessous.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-section">
            <h3>Tarifs à créer</h3>
            <div class="form-section-content">
                <p class="section-subtitle">Créez plusieurs tarifs en même temps pour différents types de place et catégories de personne.</p>

                <div class="table-responsive">
                    <table class="tarifs-table">
                        <thead>
                            <tr>
                                <th>Type de place</th>
                                <th>Catégorie personne</th>
                                <th>Prix</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="tarifsTableBody">
                            <tr class="tarif-row">
                                <td>
                                    <select name="typePlaceIds[]" class="form-control">
                                        <option value="">-- Tous types --</option>
                                        <c:forEach var="type" items="${typesPlace}">
                                            <option value="${type.id}">${type.libelle}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select name="categoriePersonneIds[]" class="form-control">
                                        <option value="">-- Toutes catégories --</option>
                                        <c:forEach var="cat" items="${categoriesPersonne}">
                                            <option value="${cat.id}">${cat.libelle}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <div class="price-input-group">
                                        <input type="number" name="prix[]" class="form-control prix-input" 
                                               placeholder="0.00" step="0.01" min="0" required>
                                        <span class="currency">Ar</span>
                                    </div>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-danger" onclick="supprimerLigneTarif(this)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="tarifs-actions">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="ajouterLigneTarif()">
                        <i class="fas fa-plus"></i> Ajouter un tarif
                    </button>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-success" id="submitBtn" disabled>
                <i class="fas fa-save"></i> Créer les tarifs
            </button>
            <a href="<c:url value='/tarifs-seance'/>" class="btn btn-secondary">
                <i class="fas fa-times"></i> Annuler
            </a>
        </div>
    </form>
</div>

<script>
    function onSeanceChange() {
        const select = document.getElementById('seanceId');
        const seanceInfo = document.getElementById('seanceInfo');
        const filmName = document.getElementById('filmName');
        const salleName = document.getElementById('salleName');
        
        if (select.value) {
            const option = select.options[select.selectedIndex];
            filmName.textContent = option.getAttribute('data-film');
            salleName.textContent = option.getAttribute('data-salle');
            seanceInfo.style.display = 'block';
            validateForm();
        } else {
            seanceInfo.style.display = 'none';
            document.getElementById('submitBtn').disabled = true;
        }
    }

    function ajouterLigneTarif() {
        const tbody = document.getElementById('tarifsTableBody');
        const tr = document.createElement('tr');
        tr.className = 'tarif-row';
        
        let typeSelectHTML = '<select name="typePlaceIds[]" class="form-control"><option value="">-- Tous types --</option>';
        const firstTypeSelect = document.querySelector('select[name="typePlaceIds[]"]');
        if (firstTypeSelect) {
            const options = firstTypeSelect.querySelectorAll('option');
            options.forEach((opt, idx) => {
                if (idx > 0) typeSelectHTML += '<option value="' + opt.value + '">' + opt.textContent + '</option>';
            });
        }
        typeSelectHTML += '</select>';

        let catSelectHTML = '<select name="categoriePersonneIds[]" class="form-control"><option value="">-- Toutes catégories --</option>';
        const firstCatSelect = document.querySelector('select[name="categoriePersonneIds[]"]');
        if (firstCatSelect) {
            const options = firstCatSelect.querySelectorAll('option');
            options.forEach((opt, idx) => {
                if (idx > 0) catSelectHTML += '<option value="' + opt.value + '">' + opt.textContent + '</option>';
            });
        }
        catSelectHTML += '</select>';

        tr.innerHTML = '<td>' + typeSelectHTML + '</td>' +
                      '<td>' + catSelectHTML + '</td>' +
                      '<td><div class="price-input-group"><input type="number" name="prix[]" class="form-control prix-input" placeholder="0.00" step="0.01" min="0" required><span class="currency">Ar</span></div></td>' +
                      '<td><button type="button" class="btn btn-sm btn-danger" onclick="supprimerLigneTarif(this)"><i class="fas fa-trash"></i></button></td>';
        
        tbody.appendChild(tr);
        validateForm();
    }

    function supprimerLigneTarif(btn) {
        btn.closest('tr').remove();
        validateForm();
    }

    function validateForm() {
        const seanceId = document.getElementById('seanceId').value;
        const rows = document.querySelectorAll('.tarif-row');
        let hasValidRows = false;

        rows.forEach(row => {
            const prix = row.querySelector('input[name="prix[]"]').value;
            if (prix && prix > 0) {
                hasValidRows = true;
            }
        });

        document.getElementById('submitBtn').disabled = !seanceId || !hasValidRows;
    }

    document.addEventListener('DOMContentLoaded', function() {
        const tbody = document.getElementById('tarifsTableBody');
        if (tbody) {
            const rows = tbody.querySelectorAll('.tarif-row');
            rows.forEach(row => {
                const inputs = row.querySelectorAll('input');
                inputs.forEach(input => {
                    input.addEventListener('change', validateForm);
                    input.addEventListener('keyup', validateForm);
                });
            });
        }
        onSeanceChange();
    });
</script>

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

    .info-box {
        background-color: #e7f3ff;
        border-left: 4px solid #003d7a;
        padding: 12px 15px;
        border-radius: 4px;
        margin-top: 8px;
        font-size: 13px;
        color: #003d7a;
    }

    .info-box p {
        margin: 5px 0;
    }

    .section-subtitle {
        margin: 0 0 20px 0;
        color: #666;
        font-size: 13px;
    }

    /* TABLE DES TARIFS */
    .table-responsive {
        overflow-x: auto;
        margin-bottom: 20px;
    }

    .tarifs-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .tarifs-table thead {
        background-color: #f5f5f5;
        border-bottom: 2px solid #ddd;
    }

    .tarifs-table thead th {
        padding: 12px;
        text-align: left;
        font-weight: 600;
        color: #333;
        font-size: 13px;
    }

    .tarifs-table tbody tr {
        border-bottom: 1px solid #e0e0e0;
    }

    .tarifs-table tbody tr:hover {
        background-color: #f9f9f9;
    }

    .tarifs-table tbody td {
        padding: 12px;
        vertical-align: middle;
    }

    .price-input-group {
        position: relative;
        display: flex;
        align-items: center;
    }

    .price-input-group input {
        flex: 1;
        padding-right: 45px;
    }

    .currency {
        position: absolute;
        right: 15px;
        font-weight: 600;
        color: #666;
        pointer-events: none;
    }

    .tarifs-actions {
        text-align: left;
        margin-bottom: 20px;
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

    .alert {
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
    }

    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    @media (max-width: 768px) {
        .form-section h3,
        .form-section-content,
        .form-actions {
            padding-left: 15px;
            padding-right: 15px;
        }

        .table-responsive {
            font-size: 12px;
        }

        .tarifs-table thead th,
        .tarifs-table tbody td {
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
    function onSeanceChange() {
        const select = document.getElementById('seanceId');
        const seanceInfo = document.getElementById('seanceInfo');
        const filmName = document.getElementById('filmName');
        const salleName = document.getElementById('salleName');
        
        if (select.value) {
            const option = select.options[select.selectedIndex];
            filmName.textContent = option.getAttribute('data-film');
            salleName.textContent = option.getAttribute('data-salle');
            seanceInfo.style.display = 'block';
            validateForm();
        } else {
            seanceInfo.style.display = 'none';
            document.getElementById('submitBtn').disabled = true;
        }
    }

    function ajouterLigneTarif() {
        const tbody = document.getElementById('tarifsTableBody');
        const tr = document.createElement('tr');
        tr.className = 'tarif-row';
        
        let typeSelectHTML = '<select name="typePlaceIds[]" class="form-control"><option value="">-- Tous types --</option>';
        const firstTypeSelect = document.querySelector('select[name="typePlaceIds[]"]');
        if (firstTypeSelect) {
            const options = firstTypeSelect.querySelectorAll('option');
            options.forEach((opt, idx) => {
                if (idx > 0) typeSelectHTML += '<option value="' + opt.value + '">' + opt.textContent + '</option>';
            });
        }
        typeSelectHTML += '</select>';

        let catSelectHTML = '<select name="categoriePersonneIds[]" class="form-control"><option value="">-- Toutes catégories --</option>';
        const firstCatSelect = document.querySelector('select[name="categoriePersonneIds[]"]');
        if (firstCatSelect) {
            const options = firstCatSelect.querySelectorAll('option');
            options.forEach((opt, idx) => {
                if (idx > 0) catSelectHTML += '<option value="' + opt.value + '">' + opt.textContent + '</option>';
            });
        }
        catSelectHTML += '</select>';

        tr.innerHTML = '<td>' + typeSelectHTML + '</td>' +
                      '<td>' + catSelectHTML + '</td>' +
                      '<td><div class="price-input-group"><input type="number" name="prix[]" class="form-control prix-input" placeholder="0.00" step="0.01" min="0" required><span class="currency">Ar</span></div></td>' +
                      '<td><button type="button" class="btn btn-sm btn-danger" onclick="supprimerLigneTarif(this)"><i class="fas fa-trash"></i></button></td>';
        
        tbody.appendChild(tr);
        validateForm();
    }

    function supprimerLigneTarif(btn) {
        btn.closest('tr').remove();
        validateForm();
    }

    function validateForm() {
        const seanceId = document.getElementById('seanceId').value;
        const rows = document.querySelectorAll('.tarif-row');
        let hasValidRows = false;

        rows.forEach(row => {
            const prix = row.querySelector('input[name="prix[]"]').value;
            if (prix && prix > 0) {
                hasValidRows = true;
            }
        });

        document.getElementById('submitBtn').disabled = !seanceId || !hasValidRows;
    }

    document.addEventListener('DOMContentLoaded', function() {
        const tbody = document.getElementById('tarifsTableBody');
        if (tbody) {
            const rows = tbody.querySelectorAll('.tarif-row');
            rows.forEach(row => {
                const inputs = row.querySelectorAll('input');
                inputs.forEach(input => {
                    input.addEventListener('change', validateForm);
                    input.addEventListener('keyup', validateForm);
                });
            });
        }
        onSeanceChange();
    });
</script>
