<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Service</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-purple-600 text-white py-4">
            <div class="container mx-auto flex justify-between items-center px-4">
                <h1 class="text-xl font-bold">Add New Service</h1>
                <a href="dashboard" class="bg-white text-purple-600 py-1 px-4 rounded">Back to Dashboard</a>
            </div>
        </header>

        <!-- Main Content -->
        <div class="container mx-auto flex-grow px-4 py-6">
            <div class="bg-white shadow-md rounded-lg p-6 max-w-2xl mx-auto">
                <form action="addService" method="POST" class="space-y-6">
                    <!-- Service Name -->
                    <div>
                        <label for="serviceName" class="block text-sm font-medium text-gray-700">Service Name</label>
                        <input type="text" id="serviceName" name="serviceName" required
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                    </div>

                    <!-- Description -->
                    <div>
                        <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                        <textarea id="description" name="description" rows="3" required
                                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500"></textarea>
                    </div>

                    <!-- Price -->
                    <div>
                        <label for="price" class="block text-sm font-medium text-gray-700">Price ($)</label>
                        <input type="number" id="price" name="price" step="0.01" min="0" required
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                    </div>

                    <!-- Image Path -->
                    <div>
                        <label for="imagePath" class="block text-sm font-medium text-gray-700">Image Path</label>
                        <input type="text" id="imagePath" name="imagePath"
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                    </div>

                    <!-- Category Selection -->
                    <div>
                        <label for="categoryId" class="block text-sm font-medium text-gray-700">Category</label>
                        <select id="categoryId" name="categoryId" required
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-purple-500 focus:ring-purple-500">
                            <option value="">Select a category</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Form Buttons -->
                    <div class="flex justify-end space-x-4">
                        <a href="dashboard" class="bg-gray-500 text-white py-2 px-4 rounded hover:bg-gray-600">Cancel</a>
                        <button type="submit" class="bg-purple-600 text-white py-2 px-4 rounded hover:bg-purple-700">
                            Add Service
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>