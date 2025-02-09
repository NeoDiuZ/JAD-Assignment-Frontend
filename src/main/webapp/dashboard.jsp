<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
			<header class="bg-purple-600 text-white py-4">
			    <div class="container mx-auto flex justify-between items-center px-4">
			        <h1 class="text-xl font-bold">Admin Dashboard</h1>
			        <div class="flex items-center space-x-4">
			            <span class="text-sm">Welcome, Admin</span>
			            <form action="${pageContext.request.contextPath}/logout" method="POST">
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
            <c:if test="${not empty successMessage}">
                <div id="successAlert" class="mb-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative">
                    <span class="block sm:inline"><c:out value="${successMessage}"/></span>
                    <button onclick="this.parentElement.style.display='none'" class="absolute top-0 right-0 px-4 py-3">
                        <span class="text-green-700">&times;</span>
                    </button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div id="errorAlert" class="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
                    <span class="block sm:inline"><c:out value="${errorMessage}"/></span>
                    <button onclick="this.parentElement.style.display='none'" class="absolute top-0 right-0 px-4 py-3">
                        <span class="text-red-700">&times;</span>
                    </button>
                </div>
            </c:if>

            <!-- Statistics Cards -->
			<div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
			    <!-- Total Services Card -->
			    <div class="bg-white rounded-lg shadow-md p-6">
			        <div class="flex items-center justify-between">
			            <div>
			                <h2 class="text-sm font-medium text-gray-600">Total Services</h2>
			                <p class="text-2xl font-bold text-gray-900">${totalServices}</p>
			            </div>
			            <div class="p-3 bg-blue-100 rounded-full">
			                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
			                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
			                          d="M13 10V3L4 14h7v7l9-11h-7z"></path>
			                </svg>
			            </div>
			        </div>
			    </div>
			
			    <!-- Total Bookings Card -->
			    <div class="bg-white rounded-lg shadow-md p-6">
			        <div class="flex items-center justify-between">
			            <div>
			                <h2 class="text-sm font-medium text-gray-600">Total Bookings</h2>
			                <p class="text-2xl font-bold text-gray-900">${totalBookings}</p>
			            </div>
			            <div class="p-3 bg-green-100 rounded-full">
			                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
			                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
			                          d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z">
			                    </path>
			                </svg>
			            </div>
			        </div>
			    </div>
			</div>

            <!-- Main Content Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Recent Bookings Section -->
                <div class="bg-white shadow-md rounded-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-bold">Recent Bookings</h2>
                        <a href="viewBookings" class="text-purple-600 hover:text-purple-800">View All</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full table-auto">
                            <thead>
                                <tr class="bg-gray-50">
                                    <th class="px-4 py-2 text-left">ID</th>
                                    <th class="px-4 py-2 text-left">Customer</th>
                                    <th class="px-4 py-2 text-left">Service</th>
                                    <th class="px-4 py-2 text-left">Date</th>
                                    <th class="px-4 py-2 text-left">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentBookings}">
                                        <c:forEach var="booking" items="${recentBookings}">
                                            <tr class="border-b">
                                                <td class="px-4 py-2">${booking.id}</td>
                                                <td class="px-4 py-2">${booking.userName}</td>
                                                <td class="px-4 py-2">${booking.serviceName}</td>
                                                <td class="px-4 py-2">${booking.bookingTime}</td>
                                                <td class="px-4 py-2">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                                                        ${booking.status eq 'Pending' ? 'bg-yellow-100 text-yellow-800' : ''}
                                                        ${booking.status eq 'Confirmed' ? 'bg-green-100 text-green-800' : ''}
                                                        ${booking.status eq 'Completed' ? 'bg-blue-100 text-blue-800' : ''}">
                                                        ${booking.status}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="px-4 py-2 text-center text-gray-500">
                                                No recent bookings found
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Services Management Section -->
                <div class="bg-white shadow-md rounded-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-bold">Manage Services</h2>
                        <div class="space-x-2">
                            <a href="addService" class="bg-green-600 text-white py-2 px-4 rounded hover:bg-green-700">
                                Add Service
                            </a>
                            <a href="viewServices" class="bg-purple-600 text-white py-2 px-4 rounded hover:bg-purple-700">
                                View All
                            </a>
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full table-auto">
                            <thead>
                                <tr class="bg-gray-50">
                                    <th class="px-4 py-2 text-left">Name</th>
                                    <th class="px-4 py-2 text-left">Price</th>
                                    <th class="px-4 py-2 text-left">Category</th>
                                    <th class="px-4 py-2 text-left">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="service" items="${services}" begin="0" end="4">
                                    <tr class="border-b">
                                        <td class="px-4 py-2">${service.name}</td>
                                        <td class="px-4 py-2">$${service.price}</td>
                                        <td class="px-4 py-2">${service.categoryName}</td>
                                        <td class="px-4 py-2">
                                            <div class="flex space-x-2">
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
            
            <!-- Users Management Section -->
			<div class="bg-white shadow-md rounded-lg p-6 mt-6">
			    <div class="flex justify-between items-center mb-4">
			        <h2 class="text-lg font-bold">Registered Users</h2>
			        <div class="space-x-2">
			            <a href="viewUsers" class="bg-purple-600 text-white py-2 px-4 rounded hover:bg-purple-700">
			                View All Users
			            </a>
			        </div>
			    </div>
			</div>

            <!-- Sales Report Section -->
            <div class="bg-white shadow-md rounded-lg p-6 mt-6">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-lg font-bold">Sales Reports</h2>
                    <a href="downloadSalesReport" class="bg-purple-600 text-white py-2 px-4 rounded hover:bg-purple-700">
                        Download Sales Report
                    </a>
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
	                <form id="deleteUserForm" method="POST" action="deleteUser" class="inline">
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

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
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

    <!-- JavaScript -->
    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const successAlert = document.getElementById('successAlert');
            const errorAlert = document.getElementById('errorAlert');
            if (successAlert) successAlert.style.display = 'none';
            if (errorAlert) errorAlert.style.display = 'none';
        }, 5000);

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

        // Format currency
        function formatCurrency(amount) {
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD'
            }).format(amount);
        }

        // Format dates
        function formatDate(dateString) {
            const options = { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric', 
                hour: '2-digit', 
                minute: '2-digit' 
            };
            return new Date(dateString).toLocaleDateString('en-US', options);
        }

        // Update status badge colors
        function updateStatusBadges() {
            const statusBadges = document.querySelectorAll('.status-badge');
            statusBadges.forEach(badge => {
                const status = badge.textContent.trim().toLowerCase();
                switch(status) {
                    case 'pending':
                        badge.classList.add('bg-yellow-100', 'text-yellow-800');
                        break;
                    case 'confirmed':
                        badge.classList.add('bg-green-100', 'text-green-800');
                        break;
                    case 'completed':
                        badge.classList.add('bg-blue-100', 'text-blue-800');
                        break;
                    case 'cancelled':
                        badge.classList.add('bg-red-100', 'text-red-800');
                        break;
                }
            });
        }

        // Initialize tooltips
        function initTooltips() {
            const tooltips = document.querySelectorAll('[data-tooltip]');
            tooltips.forEach(element => {
                element.addEventListener('mouseenter', e => {
                    const tooltip = document.createElement('div');
                    tooltip.className = 'absolute z-50 px-2 py-1 text-sm text-white bg-gray-900 rounded-lg';
                    tooltip.textContent = element.getAttribute('data-tooltip');
                    tooltip.style.top = e.pageY + 'px';
                    tooltip.style.left = e.pageX + 'px';
                    document.body.appendChild(tooltip);
                });

                element.addEventListener('mouseleave', () => {
                    const tooltips = document.querySelectorAll('.tooltip');
                    tooltips.forEach(t => t.remove());
                });
            });
        }

        // Handle form validation
        function validateForm(formId) {
            const form = document.getElementById(formId);
            if (!form) return true;

            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.classList.add('border-red-500');
                    
                    // Add error message if it doesn't exist
                    if (!field.nextElementSibling?.classList.contains('error-message')) {
                        const errorMessage = document.createElement('p');
                        errorMessage.className = 'text-red-500 text-xs mt-1 error-message';
                        errorMessage.textContent = 'This field is required';
                        field.parentNode.insertBefore(errorMessage, field.nextSibling);
                    }
                } else {
                    field.classList.remove('border-red-500');
                    const errorMessage = field.nextElementSibling;
                    if (errorMessage?.classList.contains('error-message')) {
                        errorMessage.remove();
                    }
                }
            });

            return isValid;
        }

        // Initialize event listeners
        document.addEventListener('DOMContentLoaded', function() {
            updateStatusBadges();
            initTooltips();

            // Initialize form validation
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    if (!validateForm(this.id)) {
                        e.preventDefault();
                    }
                });
            });

            // Format all currency values
            document.querySelectorAll('.currency').forEach(element => {
                const value = parseFloat(element.textContent);
                if (!isNaN(value)) {
                    element.textContent = formatCurrency(value);
                }
            });

            // Format all dates
            document.querySelectorAll('.date').forEach(element => {
                const dateString = element.textContent;
                if (dateString) {
                    element.textContent = formatDate(dateString);
                }
            });
        });
        
        // Add these functions to your existing JavaScript
		function confirmUserDelete(userId, userName) {
		    document.getElementById('deleteUserModal').classList.remove('hidden');
		    document.getElementById('deleteUserId').value = userId;
		    document.getElementById('deleteUserName').textContent = `User: ${userName}`;
		}
		
		document.getElementById('deleteUserCancel').addEventListener('click', function() {
		    document.getElementById('deleteUserModal').classList.add('hidden');
		});
		
		// Update your existing window.onclick function to include the new modal
		window.onclick = function(event) {
		    const deleteModal = document.getElementById('deleteModal');
		    const deleteUserModal = document.getElementById('deleteUserModal');
		    if (event.target == deleteModal) {
		        deleteModal.classList.add('hidden');
		    }
		    if (event.target == deleteUserModal) {
		        deleteUserModal.classList.add('hidden');
		    }
		}
    </script>
</body>
</html>