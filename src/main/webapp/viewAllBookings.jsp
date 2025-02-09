<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bookings</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-purple-600 text-white py-4">
            <div class="container mx-auto flex justify-between items-center px-4">
                <h1 class="text-xl font-bold">All Bookings</h1>
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

            <!-- Bookings Table Section -->
            <div class="bg-white shadow-md rounded-lg p-6">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-lg font-bold">Booking Management</h2>
                </div>
                <div class="overflow-x-auto">
                    <c:if test="${not empty allBookings}">
                        <table class="w-full table-auto">
                            <thead>
                                <tr class="bg-gray-50">
                                    <th class="px-4 py-2 text-left">ID</th>
                                    <th class="px-4 py-2 text-left">Customer</th>
                                    <th class="px-4 py-2 text-left">Service</th>
                                    <th class="px-4 py-2 text-left">Duration</th>
                                    <th class="px-4 py-2 text-left">Total Cost</th>
                                    <th class="px-4 py-2 text-left">Address</th>
                                    <th class="px-4 py-2 text-left">Date</th>
                                    <th class="px-4 py-2 text-left">Status</th>
                                    <th class="px-4 py-2 text-left">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${allBookings}">
                                    <tr class="border-b hover:bg-gray-50">
                                        <td class="px-4 py-2">${booking.id}</td>
                                        <td class="px-4 py-2">${booking.userName}</td>
                                        <td class="px-4 py-2">${booking.serviceName}</td>
                                        <td class="px-4 py-2">${booking.timeLength} hours</td>
                                        <td class="px-4 py-2">
										    <fmt:formatNumber value="${booking.totalCost}" type="currency" currencySymbol="$" maxFractionDigits="2" minFractionDigits="2"/>
										</td>
										<td class="px-4 py-2">
										    <c:out value="${booking.address}" default="No address specified"/>
										</td>
                                        <td class="px-4 py-2">
                                            <fmt:formatDate value="${booking.bookingTime}" pattern="MMM d, yyyy h:mm a" />
                                        </td>
                                        <td class="px-4 py-2">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                                                ${booking.status eq 'Pending' ? 'bg-yellow-100 text-yellow-800' : ''}
                                                ${booking.status eq 'Confirmed' ? 'bg-green-100 text-green-800' : ''}
                                                ${booking.status eq 'Completed' ? 'bg-blue-100 text-blue-800' : ''}">
                                                ${booking.status}
                                            </span>
                                        </td>
                                        <td class="px-4 py-2">
                                            <div class="flex space-x-2">
                                                <button onclick="confirmStatusUpdate(${booking.id}, 'Confirmed')" 
                                                        class="text-green-600 hover:text-green-900 ${booking.status eq 'Confirmed' || booking.status eq 'Completed' ? 'hidden' : ''}">
                                                    Confirm
                                                </button>
                                                <button onclick="confirmStatusUpdate(${booking.id}, 'Completed')" 
                                                        class="text-blue-600 hover:text-blue-900 ${booking.status ne 'Confirmed' ? 'hidden' : ''}">
                                                    Complete
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                    <c:if test="${empty allBookings}">
                        <div class="text-center py-4">
                            <p class="text-gray-500">No bookings found.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Status Update Confirmation Modal -->
    <div id="statusModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <h3 class="text-lg leading-6 font-medium text-gray-900">Update Booking Status</h3>
                <div class="mt-2 px-7 py-3">
                    <p class="text-sm text-gray-500">
                        Are you sure you want to update this booking's status?
                    </p>
                </div>
                <div class="items-center px-4 py-3">
                    <button id="statusCancel" 
                            class="px-4 py-2 bg-gray-500 text-white text-base font-medium rounded-md shadow-sm hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-300">
                        Cancel
                    </button>
					<form id="statusForm" method="POST" action="${pageContext.request.contextPath}/updateBookingStatus" class="inline">                        <input type="hidden" id="bookingId" name="bookingId" value="">
                        <input type="hidden" id="newStatus" name="newStatus" value="">
                        <button type="submit" 
                                class="px-4 py-2 ml-2 bg-blue-600 text-white text-base font-medium rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300">
                            Update
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

        // Status update confirmation handling
        function confirmStatusUpdate(bookingId, newStatus) {
            document.getElementById('statusModal').classList.remove('hidden');
            document.getElementById('bookingId').value = bookingId;
            document.getElementById('newStatus').value = newStatus;
        }

        document.getElementById('statusCancel').addEventListener('click', function() {
            document.getElementById('statusModal').classList.add('hidden');
        });

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('statusModal');
            if (event.target == modal) {
                modal.classList.add('hidden');
            }
        }
    </script>
</body>
</html>