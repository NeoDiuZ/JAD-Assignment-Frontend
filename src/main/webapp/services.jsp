<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cleanify - Services</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Host+Grotesk:wght@300;400;700;800&display=swap');
        .font-host {
            font-family: "Host Grotesk", sans-serif;
        }
    </style>
</head>

<body class="font-host">
    <!-- Navbar -->
    <%@ include file="navbar.jsp" %>

    <!-- Hero Section -->
    <header class="bg-blue-500 text-white py-20">
        <div class="max-w-7xl mx-auto px-6 lg:px-8 text-center">
            <h1 class="text-4xl font-bold">Our Services</h1>
            <p class="mt-4 text-lg">Explore a wide range of professional cleaning services tailored to your needs.</p>
        </div>
    </header>

    <!-- Category Filter -->
    <div class="max-w-7xl mx-auto px-6 lg:px-8 mt-8">
        <div class="flex justify-center mb-8">
            <div class="inline-block relative">
                <select id="categoryFilter" onchange="filterServices()" 
                        class="block appearance-none bg-white border border-gray-300 text-gray-700 py-2 px-4 pr-8 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                    <option value="all">All Categories</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.name}">${category.name}</option>
                    </c:forEach>
                </select>
                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                    <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                        <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/>
                    </svg>
                </div>
            </div>
        </div>
    </div>

    <!-- Services Section -->
    <main class="py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="service" items="${services}">
                    <div class="bg-gray-50 rounded-lg overflow-hidden hover:shadow-xl transition-shadow duration-300 service-card" 
                         data-category="${service.categoryName}">
                        <img src="${service.imagePath}" 
                             alt="${service.name}" 
                             class="w-full h-48 object-cover"
                             onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
                        <div class="p-6">
                            <h3 class="text-xl font-bold text-gray-900 mb-2">${service.name}</h3>
                            <p class="text-gray-600 text-sm mb-4">${service.description}</p>
                            <p class="text-gray-700 font-semibold text-lg">Starting from <span class="text-blue-500">$${service.price}</span></p>

                            <!-- Star rating -->
                            <div class="flex items-center mt-3 space-x-1">
                                <span class="text-yellow-400 font-semibold">
                                    <c:choose>
                                        <c:when test="${service.reviewCount > 0}">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= service.averageRating}">★</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <span class="text-gray-500 text-sm ml-2">
                                                (${service.reviewCount} reviews)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-500 text-sm">No reviews yet</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <form action="service-details" method="get" class="mt-6">
                                <input type="hidden" name="serviceId" value="${service.id}">
                                <button type="submit" 
                                        class="w-full bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-md shadow-sm hover:shadow-md transition duration-200">
                                    View Details
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="footer.jsp" %>


    <script>
        // Category filtering
        function filterServices() {
            const category = document.getElementById('categoryFilter').value.toLowerCase();
            const services = document.getElementsByClassName('service-card');
            
            for (let service of services) {
                const serviceCategory = service.dataset.category.toLowerCase();
                if (category === 'all' || serviceCategory === category) {
                    service.style.display = '';
                } else {
                    service.style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>