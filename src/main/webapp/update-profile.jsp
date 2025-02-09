<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="max-w-4xl mx-auto p-6 bg-white shadow-md rounded-md mt-10">
        <h1 class="text-2xl font-bold text-center text-gray-700">Update Profile</h1>
        
        <!-- Messages -->
        <c:if test="${not empty sessionScope.error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
                ${sessionScope.error}
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.message}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4">
                ${sessionScope.message}
            </div>
        </c:if>
        
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- User Profile Section -->
            <div class="space-y-6">
                <h2 class="text-xl font-semibold">Personal Information</h2>
                <form action="${pageContext.request.contextPath}/profile/update" method="post" class="space-y-4">
                    <div>
                        <label for="name" class="block text-gray-700">Name:</label>
                        <input type="text" id="name" name="name" value="${userData.name}" 
                               class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
                    </div>
                    <div>
                        <label for="email" class="block text-gray-700">Email:</label>
                        <input type="email" id="email" name="email" value="${userData.email}" 
                               class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
                    </div>
                    <div>
                        <label for="phone" class="block text-gray-700">Phone:</label>
                        <input type="text" id="phone" name="phone" value="${userData.phone}" 
                               class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
                    </div>
                    <div class="pt-2">
                        <button type="submit" 
                                class="w-full px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
                            Update Profile
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Addresses Section -->
            <div class="space-y-6">
                <h2 class="text-xl font-semibold">Manage Addresses</h2>
                
                <!-- Add New Address Form -->
                <form action="${pageContext.request.contextPath}/address/add" method="post" class="space-y-4">
                    <div>
                        <label for="newAddress" class="block text-gray-700">Address:</label>
                        <input type="text" id="newAddress" name="address" 
                               class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
                    </div>
                    <div>
                        <label for="postalCode" class="block text-gray-700">Postal Code:</label>
                        <input type="text" id="postalCode" name="postalCode" pattern="[0-9]{6}" 
                               class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" 
                               required title="Please enter a valid 6-digit postal code" />
                    </div>
                    <button type="submit" 
                            class="w-full px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors">
                        Add Address
                    </button>
                </form>

                <!-- Existing Addresses List -->
                <div class="mt-6">
                    <h3 class="text-lg font-semibold mb-3">Your Addresses</h3>
                    <div class="space-y-3">
                        <c:choose>
                            <c:when test="${not empty addresses}">
                                <c:forEach var="address" items="${addresses}">
                                    <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                                        <p class="text-gray-700">${address.address}</p>
                                        <p class="text-gray-600 text-sm">Postal Code: ${address.postalCode}</p>
                                        <div class="flex justify-end space-x-2 mt-2">
                                            <form action="${pageContext.request.contextPath}/address/delete" method="post" class="inline">
                                                <input type="hidden" name="addressId" value="${address.addressId}" />
                                                <button type="submit" 
                                                        class="px-3 py-1 text-sm bg-red-500 text-white rounded hover:bg-red-600 transition-colors"
                                                        onclick="return confirm('Are you sure you want to delete this address?')">
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-gray-500 italic">No addresses added yet.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Clear session messages -->
    <% session.removeAttribute("error"); %>
    <% session.removeAttribute("message"); %>
</body>
</html>