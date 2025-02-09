<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Page</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <%@ include file="navbar.jsp" %>

    <div class="max-w-6xl mx-auto p-6">
        <!-- Messages Section -->
        <c:if test="${not empty sessionScope.message}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                ${sessionScope.message}
                <% session.removeAttribute("message"); %>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${sessionScope.error}
                <% session.removeAttribute("error"); %>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty requestScope.userData}">
                <div class="text-center text-red-600">
                    <p>Error loading user profile. Please try logging in again.</p>
                    <a href="userLogin.jsp" class="text-blue-500 underline">Login</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Profile Information Section -->
                <div class="bg-white shadow-md rounded-lg p-6 mb-6">
                    <h1 class="text-2xl font-bold text-gray-700 mb-4">Profile Information</h1>
                    <div class="space-y-3">
                        <p class="text-lg"><span class="font-medium">Name:</span> ${requestScope.userData.name}</p>
                        <p class="text-lg"><span class="font-medium">Email:</span> ${requestScope.userData.email}</p>
                        <p class="text-lg"><span class="font-medium">Phone:</span> ${requestScope.userData.phone}</p>
                    </div>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/profile/edit" 
                           class="inline-block px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                            Edit Profile
                        </a>
                    </div>
                </div>

                <!-- Addresses Section -->
                <div class="bg-white shadow-md rounded-lg p-6 mb-6">
                    <h2 class="text-xl font-bold text-gray-700 mb-4">Your Addresses</h2>
                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <div class="space-y-3">
                                <c:forEach var="address" items="${addresses}">
                                    <div class="p-3 bg-gray-50 rounded">
                                        <p>${address.address}</p>
                                        <p class="text-sm text-gray-600">Postal Code: ${address.postalCode}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-gray-600">No addresses found.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Booking History Section -->
                <div class="bg-white shadow-md rounded-lg p-6">
                    <h2 class="text-xl font-bold text-gray-700 mb-4">Booking History</h2>
                    <c:choose>
                        <c:when test="${not empty bookings}">
                            <!-- Status Tabs -->
                            <div class="mb-4 border-b border-gray-200">
                                <ul class="flex flex-wrap -mb-px" role="tablist">
                                    <li class="mr-2">
                                        <button class="inline-block p-4 border-b-2 border-blue-600 text-blue-600 active" 
                                                onclick="showTab('pending')" id="pending-tab">
                                            Upcoming
                                            <span class="ml-2 bg-yellow-100 text-yellow-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                                                ${pendingCount}
                                            </span>
                                        </button>
                                    </li>
                                    <li class="mr-2">
                                        <button class="inline-block p-4 border-b-2 border-transparent hover:border-gray-300" 
                                                onclick="showTab('confirmed')" id="confirmed-tab">
                                            Confirmed
                                            <span class="ml-2 bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                                                ${confirmedCount}
                                            </span>
                                        </button>
                                    </li>
                                    <li class="mr-2">
                                        <button class="inline-block p-4 border-b-2 border-transparent hover:border-gray-300" 
                                                onclick="showTab('completed')" id="completed-tab">
                                            Completed
                                            <span class="ml-2 bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                                                ${completedCount}
                                            </span>
                                        </button>
                                    </li>
                                </ul>
                            </div>

                            <!-- Booking Tables -->
                            <div class="tab-content">
                                <!-- Pending Bookings -->
                                <div id="pending-bookings" class="booking-tab">
                                    <div class="overflow-x-auto">
                                        <table class="min-w-full divide-y divide-gray-200">
                                            <thead class="bg-gray-50">
                                                <tr>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Service</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date & Time</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Duration</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Cost</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Address</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="booking" items="${bookings}">
                                                    <c:if test="${booking.status eq 'Pending'}">
                                                        <tr class="hover:bg-gray-50">
                                                            <td class="px-6 py-4">${booking.serviceName}</td>
                                                            <td class="px-6 py-4">
                                                                <fmt:formatDate value="${booking.bookingTime}" pattern="MMM d, yyyy h:mm a" />
                                                            </td>
                                                            <td class="px-6 py-4">${booking.timeLength} hours</td>
                                                            <td class="px-6 py-4">
                                                                <fmt:formatNumber value="${booking.totalCost}" type="currency" currencySymbol="$" />
                                                            </td>
                                                            <td class="px-6 py-4">${booking.address}</td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Confirmed Bookings -->
                                <div id="confirmed-bookings" class="booking-tab hidden">
                                    <div class="overflow-x-auto">
                                        <table class="min-w-full divide-y divide-gray-200">
                                            <thead class="bg-gray-50">
                                                <tr>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Service</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date & Time</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Duration</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Cost</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Address</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="booking" items="${bookings}">
                                                    <c:if test="${booking.status eq 'Confirmed'}">
                                                        <tr class="hover:bg-gray-50">
                                                            <td class="px-6 py-4">${booking.serviceName}</td>
                                                            <td class="px-6 py-4">
                                                                <fmt:formatDate value="${booking.bookingTime}" pattern="MMM d, yyyy h:mm a" />
                                                            </td>
                                                            <td class="px-6 py-4">${booking.timeLength} hours</td>
                                                            <td class="px-6 py-4">
                                                                <fmt:formatNumber value="${booking.totalCost}" type="currency" currencySymbol="$" />
                                                            </td>
                                                            <td class="px-6 py-4">${booking.address}</td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Completed Bookings -->
                                <div id="completed-bookings" class="booking-tab hidden">
                                    <div class="overflow-x-auto">
                                        <table class="min-w-full divide-y divide-gray-200">
                                            <thead class="bg-gray-50">
                                                <tr>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Service</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date & Time</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Duration</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Cost</th>
                                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Address</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="booking" items="${bookings}">
                                                    <c:if test="${booking.status eq 'Completed'}">
                                                        <tr class="hover:bg-gray-50">
                                                            <td class="px-6 py-4">${booking.serviceName}</td>
                                                            <td class="px-6 py-4">
                                                                <fmt:formatDate value="${booking.bookingTime}" pattern="MMM d, yyyy h:mm a" />
                                                            </td>
                                                            <td class="px-6 py-4">${booking.timeLength} hours</td>
                                                            <td class="px-6 py-4">
                                                                <fmt:formatNumber value="${booking.totalCost}" type="currency" currencySymbol="$" />
                                                            </td>
                                                            <td class="px-6 py-4">${booking.address}</td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <p class="text-gray-500 mb-4">No booking history found.</p>
                                <a href="${pageContext.request.contextPath}/services" 
                                   class="inline-block px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                                    Book a Service
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function showTab(status) {
            // Hide all tabs
            document.querySelectorAll('.booking-tab').forEach(tab => {
                tab.classList.add('hidden');
            });
            
            // Show selected tab
            document.getElementById(status + '-bookings').classList.remove('hidden');
            
            // Update tab styles
            document.querySelectorAll('[role="tablist"] button').forEach(button => {
                button.classList.remove('border-blue-600', 'text-blue-600');
                button.classList.add('border-transparent');
            });
            
            document.getElementById(status + '-tab').classList.add('border-blue-600', 'text-blue-600');
            document.getElementById(status + '-tab').classList.remove('border-transparent');
        }
    </script>
</body>
</html>