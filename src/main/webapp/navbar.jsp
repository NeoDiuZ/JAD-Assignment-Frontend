<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navbar</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar -->
    <nav class="bg-transparent sticky top-0 w-full z-50 transition-colors duration-300" id="navbar">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <div class="flex items-center">
                    <a href="index.jsp" class="text-2xl font-bold text-blue-500">Cleanify</a>
                </div>

                <!-- Desktop Menu -->
                <div class="hidden sm:flex space-x-6">
                    <a href="index.jsp" class="text-blue-500 hover:text-white hover:bg-blue-500 px-3 py-2 rounded-md">Home</a>
                    <a href="services" class="text-blue-500 hover:text-white hover:bg-blue-500 px-3 py-2 rounded-md">Services</a>
                    <a href="about.jsp" class="text-blue-500 hover:text-white hover:bg-blue-500 px-3 py-2 rounded-md">About Us</a>
                    <a href="${pageContext.request.contextPath}/viewCart" 
                    class="text-gray-300 hover:bg-gray-700 hover:text-white px-3 py-2 rounded-md text-sm font-medium flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                        </svg>
                        Cart
                        <c:if test="${not empty sessionScope.cartCount}">
                            <span class="ml-1 bg-red-500 text-white px-2 py-0.5 rounded-full text-xs">
                                ${sessionScope.cartCount}
                            </span>
                        </c:if>
                    </a>
                </div>

                <!-- Auth Links -->
                <div class="hidden sm:flex space-x-4">
				    <c:choose>
				        <c:when test="${empty sessionScope.user}">
				            <a href="register.jsp" class="hover:text-white hover:bg-blue-500 px-3 py-2 rounded-md">Register</a>
				            <a href="userLogin.jsp" class="hover:text-white hover:bg-blue-500 px-3 py-2 rounded-md">Sign In →</a>
				        </c:when>
				        <c:otherwise>
				            <a href="profile" class="hover:text-white hover:bg-blue-500 px-3 py-2 rounded-md">Profile</a>
				            <form action="${pageContext.request.contextPath}/logout" method="POST" class="inline">
				                <button type="submit" class="hover:text-white hover:bg-blue-500 px-3 py-2 rounded-md">Logout →</button>
				            </form>
				        </c:otherwise>
				    </c:choose>
				</div>

                <!-- Mobile Menu Button -->
                <div class="sm:hidden flex items-center">
                    <button id="mobile-menu-button" class="p-2 rounded-md text-blue-500 hover:bg-blue-500 hover:text-white focus:outline-none">
                        <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"/>
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile Menu -->
        <div id="mobile-menu" class="hidden sm:hidden">
            <div class="space-y-1 px-2 pt-2 pb-3">
                <a href="index.jsp" class="block text-blue-500 hover:bg-blue-500 hover:text-white px-3 py-2 rounded-md">Home</a>
                <a href="services" class="block hover:bg-blue-500 hover:text-white px-3 py-2 rounded-md">Services</a>
                <a href="about.jsp" class="block hover:bg-blue-500 hover:text-white px-3 py-2 rounded-md">About Us</a>
            </div>
            <div class="pt-4 pb-3 border-t border-gray-200">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <div class="space-y-1">
                            <a href="register.jsp" class="block hover:bg-blue-500 hover:text-white px-3 py-2 rounded-md">Register</a>
                            <a href="userLogin.jsp" class="block hover:bg-blue-500 hover:text-white px-3 py-2 rounded-md">Sign In →</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-1">
                            <a href="profile" class="block hover:bg-blue-500 hover:text-white px-3 py-2 rounded-md">Profile</a>
                            <form action="logout" method="POST" class="block">
                                <button type="submit" class="w-full text-left hover:bg-blue-500 hover:text-white px-3 py-2 rounded-md">Logout →</button>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <script>
        // Mobile menu toggle
        const mobileMenuButton = document.getElementById('mobile-menu-button');
        const mobileMenu = document.getElementById('mobile-menu');

        mobileMenuButton.addEventListener('click', () => {
            mobileMenu.classList.toggle('hidden');
        });
    </script>
</body>
</html>
