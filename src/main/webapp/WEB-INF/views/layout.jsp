<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion de Cinéma - ${pageTitle}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/cinema-style.css'/>">
</head>
<body>
    <div class="wrapper">
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <a href="<c:url value='/'/>" class="logo">
                    <i class="fas fa-film"></i>
                    <span>Ciné-Hub</span>
                </a>
                <button class="sidebar-toggle" id="sidebarToggle">
                    <i class="fas fa-bars"></i>
                </button>
            </div>

            <nav class="sidebar-nav">
                <!-- DASHBOARD -->
                <div class="nav-section">
                    <div class="nav-section-title">Dashboard</div>
                    <a href="<c:url value='/'/>" class="nav-item ${pageActive == 'dashboard' ? 'active' : ''}">
                        <i class="fas fa-home"></i>
                        <span>Tableau de bord</span>
                    </a>
                </div>

                <!-- PROGRAMMATION -->
                <div class="nav-section">
                    <div class="nav-section-title">Programmation</div>
                    <a href="<c:url value='/films'/>" class="nav-item ${pageActive == 'films' ? 'active' : ''}">
                        <i class="fas fa-video"></i>
                        <span>Films</span>
                    </a>
                    <a href="<c:url value='/seances'/>" class="nav-item ${pageActive == 'seances' ? 'active' : ''}">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Séances</span>
                        <span class="nav-badge">${nbSeancesJour}</span>
                    </a>
                    <a href="<c:url value='/genres'/>" class="nav-item ${pageActive == 'genres' ? 'active' : ''}">
                        <i class="fas fa-tags"></i>
                        <span>Genres</span>
                    </a>
                    <a href="<c:url value='/versions-langue'/>" class="nav-item ${pageActive == 'versionslangue' ? 'active' : ''}">
                        <i class="fas fa-language"></i>
                        <span>Versions de langue</span>
                    </a>
                </div>

                <!-- GESTION SALLES -->
                <div class="nav-section">
                    <div class="nav-section-title">Infrastructure</div>
                    <a href="<c:url value='/salles'/>" class="nav-item ${pageActive == 'salles' ? 'active' : ''}">
                        <i class="fas fa-door-open"></i>
                        <span>Salles</span>
                    </a>
                    <a href="<c:url value='/places'/>" class="nav-item ${pageActive == 'places' ? 'active' : ''}">
                        <i class="fas fa-chair"></i>
                        <span>Places & Sièges</span>
                    </a>
                    <a href="<c:url value='/types-place'/>" class="nav-item ${pageActive == 'types-place' ? 'active' : ''}">
                        <i class="fas fa-couch"></i>
                        <span>Types de place</span>
                    </a>
                </div>

                <!-- RESERVATIONS & VENTES -->
                <div class="nav-section">
                    <div class="nav-section-title">Billetterie</div>
                    <a href="<c:url value='/reservations'/>" class="nav-item ${pageActive == 'reservations' ? 'active' : ''}">
                        <i class="fas fa-ticket-alt"></i>
                        <span>Réservations</span>
                        <span class="nav-badge warning">${nbReservationsEnAttente}</span>
                    </a>
                    <a href="<c:url value='/tickets'/>" class="nav-item ${pageActive == 'tickets' ? 'active' : ''}">
                        <i class="fas fa-receipt"></i>
                        <span>Tickets</span>
                    </a>
                </div>

                <!-- CLIENTS -->
                <div class="nav-section">
                    <div class="nav-section-title">Clients</div>
                    <a href="<c:url value='/personnes'/>" class="nav-item ${pageActive == 'personnes' ? 'active' : ''}">
                        <i class="fas fa-users"></i>
                        <span>Personnes</span>
                    </a>
                    <a href="<c:url value='/categories-personne'/>" class="nav-item ${pageActive == 'categories-personne' ? 'active' : ''}">
                        <i class="fas fa-user-tag"></i>
                        <span>Catégories de personne</span>
                    </a>
                </div>

                <!-- TARIFICATION -->
                <div class="nav-section">
                    <div class="nav-section-title">Tarification</div>
                    <a href="<c:url value='/configuration-tarifaire'/>" class="nav-item ${pageActive == 'configuration-tarifaire' ? 'active' : ''}">
                        <i class="fas fa-cogs"></i>
                        <span>Configuration tarifaire</span>
                    </a>
                    <a href="<c:url value='/tarifs-defaut'/>" class="nav-item ${pageActive == 'tarifs-defaut' ? 'active' : ''}">
                        <i class="fas fa-euro-sign"></i>
                        <span>Tarifs par défaut</span>
                    </a>
                    <a href="<c:url value='/tarifs-seance'/>" class="nav-item ${pageActive == 'tarifs-seance' ? 'active' : ''}">
                        <i class="fas fa-money-bill-wave"></i>
                        <span>Tarifs par séance</span>
                    </a>
                </div>

                <!-- RAPPORTS & ANALYSES -->
                <div class="nav-section">
                    <div class="nav-section-title">Analyses</div>
                    <a href="<c:url value='/recherche-avancee'/>" class="nav-item ${pageActive == 'rechercheAvancee' ? 'active' : ''}">
                        <i class="fas fa-search"></i>
                        <span>Recherche avancée</span>
                    </a>
                    <a href="<c:url value='/disponibilites'/>" class="nav-item ${pageActive == 'disponibilites' ? 'active' : ''}">
                        <i class="fas fa-clipboard-check"></i>
                        <span>Disponibilités</span>
                    </a>
                    <a href="<c:url value='/statistiques'/>" class="nav-item ${pageActive == 'statistiques' ? 'active' : ''}">
                        <i class="fas fa-chart-line"></i>
                        <span>Statistiques</span>
                    </a>
                    <a href="<c:url value='/rapports'/>" class="nav-item ${pageActive == 'rapports' ? 'active' : ''}">
                        <i class="fas fa-file-alt"></i>
                        <span>Rapports</span>
                    </a>
                    <a href="<c:url value='/historiques'/>" class="nav-item ${pageActive == 'historiques' ? 'active' : ''}">
                        <i class="fas fa-history"></i>
                        <span>Historiques</span>
                    </a>
                </div>

                <!-- PARAMETRES -->
                <div class="nav-section">
                    <div class="nav-section-title">Système</div>
                    <a href="<c:url value='/status'/>" class="nav-item ${pageActive == 'status' ? 'active' : ''}">
                        <i class="fas fa-flag"></i>
                        <span>Status</span>
                    </a>
                    <a href="<c:url value='/parametres'/>" class="nav-item ${pageActive == 'parametres' ? 'active' : ''}">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
                    </a>
                    <a href="<c:url value='/aide'/>" class="nav-item ${pageActive == 'aide' ? 'active' : ''}">
                        <i class="fas fa-question-circle"></i>
                        <span>Aide</span>
                    </a>
                    <a href="<c:url value='/logout'/>" class="nav-item">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Déconnexion</span>
                    </a>
                </div>
            </nav>

            <div class="sidebar-footer">
                <div class="user-info">
                    <img src="<c:url value='/img/default-user.jpg'/>" alt="User" class="user-avatar">
                    <div class="user-details">
                        <div class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Utilisateur'}</div>
                        <div class="user-role">${sessionScope.userRole != null ? sessionScope.userRole : 'Gestionnaire'}</div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content Wrapper -->
        <div class="main-wrapper" id="mainWrapper">
            <!-- Top Header -->
            <header class="header">
                <div class="header-left">
                    <button class="mobile-toggle" id="mobileToggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div class="header-title">
                        <h1>${pageTitle != null ? pageTitle : 'Tableau de bord'}</h1>
                        <p class="header-subtitle">
                            <i class="far fa-calendar"></i>
                            <span id="currentDate"></span>
                        </p>
                    </div>
                </div>

                <div class="header-right">
                    <!-- Recherche rapide -->
                    <div class="search-bar">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchGlobal" placeholder="Rechercher film, séance, client...">
                    </div>

                    <!-- Filtres rapides -->
                    <div class="quick-filters">
                        <button class="btn-icon" title="Séances aujourd'hui" onclick="location.href='<c:url value="/seances?date=today"/>'">
                            <i class="fas fa-calendar-day"></i>
                        </button>
                        <button class="btn-icon" title="Séances demain" onclick="location.href='<c:url value="/seances?date=tomorrow"/>'">
                            <i class="fas fa-calendar-plus"></i>
                        </button>
                    </div>

                    <!-- Notifications -->
                    <button class="btn-icon notification-btn" title="Notifications">
                        <i class="fas fa-bell"></i>
                        <c:if test="${nbNotifications > 0}">
                            <span class="notification-dot"></span>
                        </c:if>
                    </button>

                    <!-- Profil utilisateur -->
                    <div class="user-profile">
                        <img src="<c:url value='/img/default-user.jpg'/>" alt="User">
                        <div class="user-dropdown">
                            <i class="fas fa-chevron-down"></i>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Main Content Area -->
            <main class="main-content">
                <!-- Messages flash -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                <c:if test="${not empty warningMessage}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${warningMessage}
                    </div>
                </c:if>

                <!-- Contenu de la page -->
                <jsp:include page="${page}.jsp" />
            </main>

            <!-- Footer -->
            <footer class="footer">
                <div class="footer-content">
                    <p>&copy; 2026 CinémaHub - Système de gestion de cinéma</p>
                    <div class="footer-links">
                        <a href="#">Documentation</a>
                        <a href="#">Support technique</a>
                        <a href="#">Version 1.0.0</a>
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <!-- Overlay for mobile -->
    <div class="overlay" id="overlay"></div>

    <script>
        // Date actuelle dans le header
        function updateCurrentDate() {
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            const date = new Date().toLocaleDateString('fr-FR', options);
            const dateEl = document.getElementById('currentDate');
            if (dateEl) {
                dateEl.textContent = date.charAt(0).toUpperCase() + date.slice(1);
            }
        }
        updateCurrentDate();

        // Toggle sidebar
        const sidebar = document.getElementById('sidebar');
        const mainWrapper = document.getElementById('mainWrapper');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const mobileToggle = document.getElementById('mobileToggle');
        const overlay = document.getElementById('overlay');

        sidebarToggle?.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
            mainWrapper.classList.toggle('expanded');
            localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
        });

        // Restaurer l'état de la sidebar
        if (localStorage.getItem('sidebarCollapsed') === 'true') {
            sidebar.classList.add('collapsed');
            mainWrapper.classList.add('expanded');
        }

        // Mobile menu
        mobileToggle?.addEventListener('click', function() {
            sidebar.classList.toggle('mobile-active');
            overlay.classList.toggle('active');
        });

        overlay?.addEventListener('click', function() {
            sidebar.classList.remove('mobile-active');
            overlay.classList.remove('active');
        });

        // Recherche globale
        const searchInput = document.getElementById('searchGlobal');
        searchInput?.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                const query = this.value.trim();
                if (query) {
                    window.location.href = '<c:url value="/recherche"/>?q=' + encodeURIComponent(query);
                }
            }
        });

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            document.querySelectorAll('.alert').forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() { alert.remove(); }, 500);
            });
        }, 5000);
    </script>
</body>
</html>