<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Services</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-purple-600 text-white py-4">
            <div class="container mx-auto flex justify-between items-center px-4">
                <h1 class="text-xl font-bold">All Services</h1>
                <div class="space-x-4">
                    <a href="addService" class="bg-white text-purple-600 py-1 px-4 rounded hover:bg-gray-100">
                        Add New Service
                    </a>
                    <a href="dashboard" class="bg-white text-purple-600 py-1 px-4 rounded hover:bg-gray-100">
                        Back to Dashboard
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <div class="container mx-auto flex-grow px-4 py-8">
            <div class="bg-white rounded-lg shadow-md">
                <!-- Category Filter -->
                <div class="p-4 border-b">
                    <select id="categoryFilter" onchange="filterServices()" 
                            class="rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                        <option value="">All Categories</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}"><c:out value="${category.name}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Services Table -->
                <div class="overflow-x-auto">
                    <table class="w-full table-auto">
                        <thead>
                            <tr class="bg-gray-50">
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Description</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach var="service" items="${services}">
                                <tr class="service-row" data-category="${service.categoryId}">
                                    <td class="px-6 py-4 whitespace-nowrap"><c:out value="${service.id}"/></td>
                                    <td class="px-6 py-4 whitespace-nowrap"><c:out value="${service.name}"/></td>
                                    <td class="px-6 py-4"><c:out value="${service.description}"/></td>
                                    <td class="px-6 py-4 whitespace-nowrap">$<c:out value="${service.price}"/></td>
                                    <td class="px-6 py-4 whitespace-nowrap"><c:out value="${service.categoryName}"/></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex space-x-4">
                                            <a href="editService?serviceId=${service.id}" 
                                               class="text-blue-600 hover:text-blue-900">Edit</a>
                                            <button onclick="confirmDelete(${service.id})" 
                                                    class="text-red-600 hover:text-red-900">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <h3 class="text-lg leading-6 font-medium text-gray-900">
                    <h3 class="text-lg leading-6 font-medium text-gray-900">Delete Service</h3>
                <div class="mt-2 px-7 py-3">
                    <p class="text-sm text-gray-500">
                        Are you sure you want to delete this service? This action cannot be undone.
                    </p>
                </div>
                <div class="items-center px-4 py-3">
                    <button id="deleteCancel" 
                            class="px-4 py-2 bg-gray-500 text-white text-base font-medium rounded-md shadow-sm hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-300">
                        Cancel
                    </button>
                    <form id="deleteForm" method="POST" action="deleteService" class="inline">
                        <input type="hidden" id="deleteServiceId" name="serviceId" value="">
                        <button type="submit" 
                                class="px-4 py-2 ml-2 bg-red-600 text-white text-base font-medium rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-300">
                        Delete
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty successMessage}">
        <div id="successAlert" class="fixed bottom-4 right-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded">
            <c:out value="${successMessage}"/>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div id="errorAlert" class="fixed bottom-4 right-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
            <c:out value="${errorMessage}"/>
        </div>
    </c:if>

    <script>
    // Function to handle category filtering
    function filterServices() {
        const categoryId = document.getElementById('categoryFilter').value;
        const rows = document.getElementsByClassName('service-row');
        
        for (let row of rows) {
            if (!categoryId || row.dataset.category === categoryId) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        }
    }

    // Delete confirmation handling
    function confirmDelete(serviceId) {
        document.getElementById('deleteModal').classList.remove('hidden');
        document.getElementById('deleteServiceId').value = serviceId;
    }

    document.getElementById('deleteCancel').addEventListener('click', function() {
        document.getElementById('deleteModal').classList.add('hidden');
    });

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('deleteModal');
        if (event.target == modal) {
            modal.classList.add('hidden');
        }
    }

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        const successAlert = document.getElementById('successAlert');
        const errorAlert = document.getElementById('errorAlert');
        if (successAlert) successAlert.style.display = 'none';
        if (errorAlert) errorAlert.style.display = 'none';
    }, 5000);
    </script>
</body>
</html>