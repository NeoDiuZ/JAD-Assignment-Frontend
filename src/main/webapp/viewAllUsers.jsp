<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Users</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-purple-600 text-white py-4">
            <div class="container mx-auto flex justify-between items-center px-4">
                <h1 class="text-xl font-bold">All Users</h1>
                <div class="flex items-center space-x-4">
                    <a href="dashboard" class="text-white hover:text-gray-200">
                        Back to Dashboard
                    </a>
                    <form action="logout" method="POST">
                        <button type="submit" class="bg-white text-purple-600 py-1 px-4 rounded hover:bg-gray-100">
                            Logout
                        </button>
                    </form>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <div class="container mx-auto flex-grow px-4 py-8">
            <!-- Success/Error Messages -->
            <c:if test="${not empty param.success}">
                <div id="successAlert" class="mb-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative">
                    <span class="block sm:inline">User successfully deleted.</span>
                    <button onclick="this.parentElement.style.display='none'" class="absolute top-0 right-0 px-4 py-3">
                        <span class="text-green-700">&times;</span>
                    </button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div id="errorAlert" class="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
                    <span class="block sm:inline">Error deleting user.</span>
                    <button onclick="this.parentElement.style.display='none'" class="absolute top-0 right-0 px-4 py-3">
                        <span class="text-red-700">&times;</span>
                    </button>
                </div>
            </c:if>

            <!-- Users Table -->
            <div class="bg-white shadow-md rounded-lg p-6">
                <div class="overflow-x-auto">
                    <table class="w-full table-auto">
                        <thead>
                            <tr class="bg-gray-50">
                                <th class="px-4 py-2 text-left">Name</th>
                                <th class="px-4 py-2 text-left">Email</th>
                                <th class="px-4 py-2 text-left">Phone</th>
                                <th class="px-4 py-2 text-left">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${allUsers}">
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="px-4 py-2">${user.name}</td>
                                    <td class="px-4 py-2">${user.email}</td>
                                    <td class="px-4 py-2">${user.phone}</td>
                                    <td class="px-4 py-2">
                                        <button onclick="confirmUserDelete(${user.id}, '${user.name}')" 
                                                class="text-red-600 hover:text-red-900">
                                            Delete
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete User Confirmation Modal -->
    <div id="deleteUserModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <h3 class="text-lg leading-6 font-medium text-gray-900">Delete User</h3>
                <div class="mt-2 px-7 py-3">
                    <p class="text-sm text-gray-500">
                        Are you sure you want to delete this user? This action cannot be undone.
                    </p>
                    <p class="text-sm font-medium mt-2" id="deleteUserName"></p>
                </div>
                <div class="items-center px-4 py-3">
                    <button id="deleteUserCancel" 
                            class="px-4 py-2 bg-gray-500 text-white text-base font-medium rounded-md shadow-sm hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-300">
                        Cancel
                    </button>
                    <form id="deleteUserForm" method="POST" action="${pageContext.request.contextPath}/deleteUser" class="inline">
                        <input type="hidden" id="deleteUserId" name="userId" value="">
                        <button type="submit" 
                                class="px-4 py-2 ml-2 bg-red-600 text-white text-base font-medium rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-300">
                            Delete
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Delete user confirmation handling
        function confirmUserDelete(userId, userName) {
            document.getElementById('deleteUserModal').classList.remove('hidden');
            document.getElementById('deleteUserId').value = userId;
            document.getElementById('deleteUserName').textContent = `User: ${userName}`;
        }

        document.getElementById('deleteUserCancel').addEventListener('click', function() {
            document.getElementById('deleteUserModal').classList.add('hidden');
        });

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('deleteUserModal');
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