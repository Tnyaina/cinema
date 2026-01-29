<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title mb-0">
                        <i class="fas fa-box"></i> Gestion des Produits
                    </h4>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nom</th>
                                    <th>Description</th>
                                    <th>Catégorie</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="produit" items="${produits}">
                                    <tr>
                                        <td>${produit.id}</td>
                                        <td>${produit.nom}</td>
                                        <td>${produit.description}</td>
                                        <td>${produit.categorie.nom}</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-edit"></i> Modifier
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty produits}">
                                    <tr>
                                        <td colspan="5" class="text-center py-4">
                                            <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">Aucun produit trouvé</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>