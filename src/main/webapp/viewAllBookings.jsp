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

                <!-- Status Tabs -->
                <div class="mb-4 border-b border-gray-200">
                    <ul class="flex flex-wrap -mb-px" role="tablist">
                        <li class="mr-2">
                            <button class="inline-block p-4 border-b-2 border-purple-600 text-purple-600 active" 
                                    onclick="showTab('pending')" id="pending-tab">
                                Pending
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
                                        <c:if test="${booking.status eq 'Pending'}">
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
                                                <td class="px-4 py-2">${booking.status}</td>
                                                <td class="px-4 py-2">
                                                    <button onclick="showStatusModal(${booking.id}, 'Confirmed')" 
                                                            class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">
                                                        Confirm
                                                    </button>
                                                </td>
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
                                        <c:if test="${booking.status eq 'Confirmed'}">
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
                                                <td class="px-4 py-2">${booking.status}</td>
                                                <td class="px-4 py-2">
                                                    <button onclick="showStatusModal(${booking.id}, 'Completed')" 
                                                            class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600">
                                                        Complete
                                                    </button>
                                                </td>
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
                                        <c:if test="${booking.status eq 'Completed'}">
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
                                                <td class="px-4 py-2">${booking.status}</td>
                                                <td class="px-4 py-2">
                                                    <span class="text-gray-500">No actions available</span>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Add this before the closing div of the bookings table section -->
                <div class="mt-4 flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
                    <div class="flex flex-1 justify-between sm:hidden">
                        <a href="?status=${currentStatus}&page=${currentPage - 1}" 
                           class="${currentPage == 1 ? 'invisible' : ''} relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
                            Previous
                        </a>
                        <a href="?status=${currentStatus}&page=${currentPage + 1}"
                           class="${currentPage == totalPages ? 'invisible' : ''} relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
                            Next
                        </a>
                    </div>
                    <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                        <div>
                            <p class="text-sm text-gray-700">
                                Showing page <span class="font-medium">${currentPage}</span> of
                                <span class="font-medium">${totalPages}</span>
                            </p>
                        </div>
                        <div>
                            <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="?status=${currentStatus}&page=${i}" 
                                       class="${currentPage == i ? 'relative z-10 inline-flex items-center bg-purple-600 px-4 py-2 text-sm font-semibold text-white focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-purple-600' : 'relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0'}">
                                        ${i}
                                    </a>
                                </c:forEach>
                            </nav>
                        </div>
                    </div>
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
                    <form id="statusForm" method="POST" action="${pageContext.request.contextPath}/updateBookingStatus" class="inline">
                        <input type="hidden" id="bookingId" name="bookingId" value="">
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
        function showStatusModal(bookingId, newStatus) {
            document.getElementById('statusModal').classList.remove('hidden');
            document.getElementById('bookingId').value = bookingId;
            document.getElementById('newStatus').value = newStatus;
            
            // Update modal text based on status
            const modalTitle = document.querySelector('#statusModal h3');
            const modalText = document.querySelector('#statusModal p');
            modalTitle.textContent = `${newStatus} Booking`;
            modalText.textContent = `Are you sure you want to update this booking's status?`;
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

        function showTab(status) {
            // Hide all tabs
            document.querySelectorAll('.booking-tab').forEach(tab => {
                tab.classList.add('hidden');
            });
            
            // Show selected tab
            document.getElementById(status + '-bookings').classList.remove('hidden');
            
            // Update tab styles
            document.querySelectorAll('[role="tablist"] button').forEach(button => {
                button.classList.remove('border-purple-600', 'text-purple-600');
                button.classList.add('border-transparent');
            });
            
            document.getElementById(status + '-tab').classList.add('border-purple-600', 'text-purple-600');
            document.getElementById(status + '-tab').classList.remove('border-transparent');
        }
    </script>
</body>
</html>