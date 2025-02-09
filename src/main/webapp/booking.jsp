<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Service</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <%@ include file="navbar.jsp" %>

    <div class="max-w-4xl mx-auto p-6">
        <div class="bg-white rounded-lg shadow-md p-6">
            <h1 class="text-2xl font-bold mb-6">Book Service</h1>

            <!-- Service Details -->
            <div class="mb-6">
                <h2 class="text-xl font-semibold mb-2">Service Details</h2>
                <p><strong>Service:</strong> ${service.name}</p>
                <p><strong>Price:</strong> $${service.price}/hour</p>
                <p><strong>Description:</strong> ${service.description}</p>
            </div>

            <!-- Booking Form -->
            <form id="bookingForm" method="POST" action="${pageContext.request.contextPath}/booking" class="space-y-4">
                <input type="hidden" name="serviceId" value="${service.id}">
                
                <!-- Date and Time Selection -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Date</label>
                        <input type="date" name="bookingDate" required 
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Time</label>
                        <input type="time" name="bookingTime" required 
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                    </div>
                </div>

                <!-- Duration Selection -->
                <div>
                    <label class="block text-sm font-medium text-gray-700">Duration (hours)</label>
                    <select name="timeLength" id="timeLength" required onchange="calculateTotal()"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        <option value="1">1 hour</option>
                        <option value="1.5">1.5 hours</option>
                        <option value="2">2 hours</option>
                        <option value="2.5">2.5 hours</option>
                        <option value="3">3 hours</option>
                    </select>
                </div>

                <!-- Address Selection -->
                <div>
                    <div class="flex justify-between items-center mb-2">
                        <label class="block text-sm font-medium text-gray-700">Service Address</label>
                        <button type="button" onclick="showAddressModal()"
                                class="text-blue-600 hover:text-blue-800 text-sm">
                            + Add New Address
                        </button>
                    </div>
                    <select name="addressId" id="addressId" required
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        <c:forEach var="address" items="${addresses}">
                            <option value="${address.addressId}">${address.address} (${address.postalCode})</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Special Requests -->
                <div>
                    <label class="block text-sm font-medium text-gray-700">Special Requests</label>
                    <textarea name="specialRequests" rows="3" 
                              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"></textarea>
                </div>

                <!-- Total Cost Display -->
                <div class="bg-gray-50 p-4 rounded-md">
                    <p class="text-lg font-semibold">Total Cost: <span id="totalCost">$${service.price}</span></p>
                    <p class="text-sm text-gray-600">Base rate: $${service.price}/hour</p>
                </div>

                <!-- Submit Button -->
                <div class="flex justify-end">
                    <button type="button" onclick="showConfirmation()" 
                            class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                        Book Now
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div id="confirmationModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <h3 class="text-lg leading-6 font-medium text-gray-900">Confirm Booking</h3>
                <div class="mt-2 px-7 py-3">
                    <p class="text-sm text-gray-500">Please review your booking details:</p>
                    <div class="mt-4 text-left">
                        <p><strong>Service:</strong> <span id="confirmService"></span></p>
                        <p><strong>Date & Time:</strong> <span id="confirmDateTime"></span></p>
                        <p><strong>Duration:</strong> <span id="confirmDuration"></span></p>
                        <p><strong>Address:</strong> <span id="confirmAddress"></span></p>
                        <p><strong>Total Cost:</strong> <span id="confirmCost"></span></p>
                    </div>
                </div>
                <div class="items-center px-4 py-3">
                    <button id="confirmButton" 
                            class="px-4 py-2 bg-blue-600 text-white text-base font-medium rounded-md w-full shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        Confirm Booking
                    </button>
                    <button onclick="hideConfirmation()" 
                            class="mt-3 px-4 py-2 bg-gray-100 text-gray-700 text-base font-medium rounded-md w-full shadow-sm hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-400">
                        Cancel
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Address Modal -->
    <div id="addressModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3">
                <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Add New Address</h3>
                <form id="addressForm" class="space-y-4">
                    <div>
                        <label for="newAddress" class="block text-sm font-medium text-gray-700">Address</label>
                        <input type="text" id="newAddress" name="address" required
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                    </div>
                    <div>
                        <label for="postalCode" class="block text-sm font-medium text-gray-700">Postal Code</label>
                        <input type="text" id="postalCode" name="postalCode" pattern="[0-9]{6}" required
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                               title="Please enter a valid 6-digit postal code">
                    </div>
                    <div class="flex justify-end space-x-3 mt-4">
                        <button type="button" onclick="hideAddressModal()"
                                class="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300">
                            Cancel
                        </button>
                        <button type="submit"
                                class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                            Add Address
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function calculateTotal() {
            const basePrice = ${service.price};
            const hours = parseFloat(document.getElementById('timeLength').value);
            const total = basePrice * hours;
            document.getElementById('totalCost').textContent = '$' + total.toFixed(2);
        }

        function showConfirmation() {
            const form = document.getElementById('bookingForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const dateInput = document.querySelector('input[name="bookingDate"]');
            const timeInput = document.querySelector('input[name="bookingTime"]');
            const addressSelect = document.getElementById('addressId');
            const addressText = addressSelect.options[addressSelect.selectedIndex].text;
            const duration = document.getElementById('timeLength').value;
            const totalCost = document.getElementById('totalCost').textContent;

            document.getElementById('confirmService').textContent = '${service.name}';
            document.getElementById('confirmDateTime').textContent = `${dateInput.value} ${timeInput.value}`;
            document.getElementById('confirmDuration').textContent = `${duration} hours`;
            document.getElementById('confirmAddress').textContent = addressText;
            document.getElementById('confirmCost').textContent = totalCost;

            document.getElementById('confirmationModal').classList.remove('hidden');
        }

        function hideConfirmation() {
            document.getElementById('confirmationModal').classList.add('hidden');
        }

        function showAddressModal() {
            document.getElementById('addressModal').classList.remove('hidden');
        }

        function hideAddressModal() {
            document.getElementById('addressModal').classList.add('hidden');
        }

        document.getElementById('confirmButton').addEventListener('click', function() {
            document.getElementById('bookingForm').submit();
        });

        // Add this function to refresh the address dropdown
        function refreshAddressDropdown(newAddressId, addressData) {
            const addressSelect = document.getElementById('addressId');
            const option = document.createElement('option');
            option.value = newAddressId;
            option.text = `${addressData.address} (${addressData.postalCode})`;
            option.selected = true;
            addressSelect.appendChild(option);
        }

        // Update the address form submission handler
        document.getElementById('addressForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new URLSearchParams(new FormData(this));
            
            fetch('${pageContext.request.contextPath}/address/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                console.log('Server response:', data);
                if (data.success) {
                    hideAddressModal();
                    document.getElementById('addressForm').reset();
                    window.location.reload(); // Add page refresh
                } else {
                    alert('Failed to add address: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to add address. Please try again.');
            });
        });

        // Calculate initial total on page load
        calculateTotal();
    </script>
</body>
</html>