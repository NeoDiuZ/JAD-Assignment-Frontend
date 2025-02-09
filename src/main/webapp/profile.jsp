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
					            <div class="overflow-x-auto">
					                <table class="min-w-full divide-y divide-gray-200">
					                    <thead class="bg-gray-50">
					                        <tr>
					                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
					                                Service
					                            </th>
					                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
					                                Booking Time
					                            </th>
					                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
					                                Duration
					                            </th>
					                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
					                                Status
					                            </th>
					                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
					                                Total Cost
					                            </th>
					                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
					                                Address
					                            </th>
					                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
					                                Special Requests
					                            </th>
					                        </tr>
					                    </thead>
					                    <tbody class="bg-white divide-y divide-gray-200">
					                        <c:forEach var="booking" items="${bookings}">
					                            <tr>
					                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
					                                    ${booking.serviceName}
					                                </td>
					                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
					                                    <fmt:formatDate value="${booking.bookingTime}" pattern="MMM d, yyyy h:mm a" />
					                                </td>
					                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
					                                    ${booking.timeLength} hours
					                                </td>
					                                <td class="px-6 py-4 whitespace-nowrap">
													    <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full 
													        ${booking.status eq 'Pending' ? 'bg-yellow-100 text-yellow-800' : 
													          booking.status eq 'Confirmed' ? 'bg-green-100 text-green-800' : 
													          booking.status eq 'Completed' ? 'bg-blue-100 text-blue-800' : 
													          'bg-gray-100 text-gray-800'}">
													        ${booking.status}
													    </span>
													</td>
					                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
					                                    <fmt:formatNumber value="${booking.totalCost}" type="currency" currencySymbol="$" />
					                                </td>
					                                <td class="px-6 py-4 text-sm text-gray-900">
					                                    ${booking.address}
					                                </td>
					                                <td class="px-6 py-4 text-sm text-gray-900">
					                                    <c:out value="${booking.specialRequests}" default="-" />
					                                </td>
					                            </tr>
					                        </c:forEach>
					                    </tbody>
					                </table>
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
</body>
</html>