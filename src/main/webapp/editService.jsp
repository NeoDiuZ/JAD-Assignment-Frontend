<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Service</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-purple-600 text-white py-4">
            <div class="container mx-auto flex justify-between items-center px-4">
                <h1 class="text-xl font-bold">Edit Service</h1>
                <a href="dashboard" class="bg-white text-purple-600 py-1 px-4 rounded">Back to Dashboard</a>
            </div>
        </header>

        <!-- Main Content -->
        <div class="container mx-auto flex-grow px-4 py-8">
            <div class="max-w-2xl mx-auto bg-white rounded-lg shadow-md p-6">
                <form action="updateService" method="POST" class="space-y-6">
                    <input type="hidden" name="serviceId" value="${service.id}">
                    
                    <!-- Service Name -->
                    <div>
                        <label for="serviceName" class="block text-sm font-medium text-gray-700">Service Name</label>
                        <input type="text" id="serviceName" name="serviceName" 
                               value="<c:out value="${service.name}"/>"
                               required
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                    </div>

                    <!-- Description -->
                    <div>
                        <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                        <textarea id="description" name="description" rows="3" required
                                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500"><c:out value="${service.description}"/></textarea>
                    </div>

                    <!-- Price -->
                    <div>
                        <label for="price" class="block text-sm font-medium text-gray-700">Price ($)</label>
                        <input type="number" id="price" name="price" 
                               value="<c:out value="${service.price}"/>"
                               step="0.01" min="0" required
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                    </div>

                    <!-- Image Path -->
                    <div>
                        <label for="imagePath" class="block text-sm font-medium text-gray-700">Image Path</label>
                        <input type="text" id="imagePath" name="imagePath" 
                               value="<c:out value="${service.imagePath}"/>"
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                    </div>

                    <!-- Category Selection -->
                    <div>
                        <label for="categoryId" class="block text-sm font-medium text-gray-700">Category</label>
                        <select id="categoryId" name="categoryId" required
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}" 
                                        <c:if test="${category.id == service.categoryId}">selected</c:if>>
                                    <c:out value="${category.name}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Form Buttons -->
                    <div class="flex justify-end space-x-4 pt-4">
                        <a href="dashboard" 
                           class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600">
                            Cancel
                        </a>
                        <button type="submit" 
                                class="px-4 py-2 bg-purple-600 text-white rounded hover:bg-purple-700">
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Error Message Display -->
    <c:if test="${not empty errorMessage}">
    <div class="fixed bottom-4 right-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
        <c:out value="${errorMessage}"/>
    </div>
    </c:if>
</body>
</html>