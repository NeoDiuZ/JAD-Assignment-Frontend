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
                <form action="addService" method="POST" enctype="multipart/form-data" class="space-y-6">
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

                    <!-- Image Upload -->
                    <div>
                        <label for="imageFile" class="block text-sm font-medium text-gray-700">Service Image</label>
                        <div class="mt-1 flex flex-col items-center">
                            <!-- Image Preview -->
                            <div id="imagePreview" class="hidden mb-4">
                                <img id="preview" src="#" alt="Preview" 
                                     class="max-w-xs h-48 object-cover rounded-lg shadow-md">
                                <button type="button" onclick="removeImage()" 
                                        class="mt-2 text-red-600 hover:text-red-800 text-sm">
                                    Remove Image
                                </button>
                            </div>
                            
                            <!-- File Input -->
                            <div class="w-full">
                                <input type="file" id="imageFile" name="imageFile" accept="image/*"
                                       onchange="previewImage(this)"
                                       class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 
                                              file:rounded-md file:border-0 file:text-sm file:font-semibold
                                              file:bg-purple-50 file:text-purple-700 hover:file:bg-purple-100">
                            </div>
                            <p class="mt-1 text-sm text-gray-500">PNG, JPG, GIF up to 10MB</p>
                            <div id="imageError" class="mt-1 text-sm text-red-600 hidden"></div>
                        </div>
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

    <script>
    function previewImage(input) {
        const preview = document.getElementById('preview');
        const previewDiv = document.getElementById('imagePreview');
        const errorDiv = document.getElementById('imageError');
        
        // Reset error message
        errorDiv.textContent = '';
        errorDiv.classList.add('hidden');
        
        if (input.files && input.files[0]) {
            const file = input.files[0];
            
            // Validate file size (10MB max)
            if (file.size > 10 * 1024 * 1024) {
                errorDiv.textContent = 'File size must be less than 10MB';
                errorDiv.classList.remove('hidden');
                input.value = '';
                return;
            }
            
            // Validate file type
            const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
            if (!validTypes.includes(file.type)) {
                errorDiv.textContent = 'Please upload a valid image file (PNG, JPG, or GIF)';
                errorDiv.classList.remove('hidden');
                input.value = '';
                return;
            }
            
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                previewDiv.classList.remove('hidden');
            }
            reader.readAsDataURL(file);
        }
    }

    function removeImage() {
        const input = document.getElementById('imageFile');
        const preview = document.getElementById('preview');
        const previewDiv = document.getElementById('imagePreview');
        const errorDiv = document.getElementById('imageError');
        
        input.value = '';
        preview.src = '#';
        previewDiv.classList.add('hidden');
        errorDiv.classList.add('hidden');
    }

    // Form validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const imageFile = document.getElementById('imageFile');
        const errorDiv = document.getElementById('imageError');
        
        if (imageFile.files.length === 0) {
            errorDiv.textContent = 'Please select an image';
            errorDiv.classList.remove('hidden');
            e.preventDefault();
            return;
        }
    });
    </script>
</body>
</html>