<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="main-content">
    <div class="page-header mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-0">${societe.libelle}</h1>
                <p class="text-muted small">Détail de la société publicitaire</p>
            </div>
            <a href="<c:url value='/societes'/>" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i> Retour
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-info-circle me-2"></i> Informations générales
                    </h5>
                </div>
                <div class="card-body">
                    <dl class="row">
                        <dt class="col-sm-4 fw-600">Libellé :</dt>
                        <dd class="col-sm-8">${societe.libelle}</dd>
                        <dt class="col-sm-4 fw-600">ID :</dt>
                        <dd class="col-sm-8"><code>${societe.id}</code></dd>
                        <dt class="col-sm-4 fw-600">Créée le :</dt>
                        <dd class="col-sm-8"><small class="text-muted">${societe.createdAt}</small></dd>
                    </dl>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="row">
                <div class="col-12 mb-4">
                    <div class="card shadow-sm border-0 bg-light">
                        <div class="card-body text-center">
                            <i class="fas fa-video text-primary" style="font-size: 2rem;"></i>
                            <h6 class="mt-3 mb-0">Vidéos Publicitaires</h6>
                            <p class="text-muted small">Gérer les vidéos</p>
                            <a href="<c:url value='/videos-publicitaires?societeId=${societe.id}'/>" class="btn btn-sm btn-primary mt-2">
                                <i class="fas fa-arrow-right me-1"></i> Accéder
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 mb-4">
                    <div class="card shadow-sm border-0 bg-light">
                        <div class="card-body text-center">
                            <i class="fas fa-tag text-success" style="font-size: 2rem;"></i>
                            <h6 class="mt-3 mb-0">Tarifs Personnalisés</h6>
                            <p class="text-muted small">Gérer les tarifs</p>
                            <a href="<c:url value='/tarifs-publicite?type=personnalise&societeId=${societe.id}'/>" class="btn btn-sm btn-success mt-2">
                                <i class="fas fa-arrow-right me-1"></i> Accéder
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="card shadow-sm border-0 bg-light">
                        <div class="card-body text-center">
                            <i class="fas fa-money-bill text-warning" style="font-size: 2rem;"></i>
                            <h6 class="mt-3 mb-0">Paiements</h6>
                            <p class="text-muted small">Enregistrer les paiements</p>
                            <a href="<c:url value='/paiements-publicite?societeId=${societe.id}'/>" class="btn btn-sm btn-warning mt-2">
                                <i class="fas fa-arrow-right me-1"></i> Accéder
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .fw-600 { font-weight: 600; }
    .page-header { padding-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; }
    .card-header { border-bottom: none; }
    dl { margin-bottom: 0; }
    dt, dd { padding: 0.5rem 0; }
</style>
