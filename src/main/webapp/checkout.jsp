<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Cleanify</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://js.stripe.com/v3/"></script>
</head>
<body class="bg-gray-50">
    <%@ include file="navbar.jsp" %>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <!-- Order Summary -->
            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-2xl font-bold mb-6">Order Summary</h2>
                
                <div class="space-y-4">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="flex justify-between items-center border-b pb-4">
                            <div>
                                <h3 class="font-semibold">${item.serviceName}</h3>
                                <p class="text-sm text-gray-600">
                                    <fmt:formatDate value="${item.bookingTime}" pattern="MMM d, yyyy h:mm a" />
                                </p>
                                <p class="text-sm text-gray-600">${item.timeLength} hours</p>
                            </div>
                            <div class="text-right">
                                <p class="font-semibold">
                                    $<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/>
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="mt-6 border-t pt-4">
                    <div class="flex justify-between items-center">
                        <span class="font-bold text-lg">Total</span>
                        <span class="font-bold text-lg">
                            $<fmt:formatNumber value="${total}" pattern="#,##0.00"/>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Checkout Form -->
            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-2xl font-bold mb-6">Complete Your Booking</h2>

                <c:if test="${not empty sessionScope.error}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                        ${sessionScope.error}
                        <% session.removeAttribute("error"); %>
                    </div>
                </c:if>

                <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="POST">
                    <div class="space-y-6">
                        <!-- Payment Method -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Payment Method</h3>
                            <div class="space-y-4">
                                <!-- Payment Options -->
                                <div class="space-y-4">
                                    <!-- Cash Option -->
                                    <div class="flex items-center space-x-3">
                                        <input type="radio" id="cash" name="paymentMethod" value="cash" checked
                                               class="h-4 w-4 text-blue-600 focus:ring-blue-500">
                                        <label for="cash" class="text-gray-700">Cash on Service</label>
                                    </div>
                                    
                                    <!-- Card Option -->
                                    <div class="flex items-center space-x-3">
                                        <input type="radio" id="card" name="paymentMethod" value="card"
                                               class="h-4 w-4 text-blue-600 focus:ring-blue-500">
                                        <label for="card" class="text-gray-700">Credit/Debit Card</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Address Selection -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Select Service Address</h3>
                            <div class="flex justify-between items-center mb-2">
                                <select name="addressId" id="addressId" required
                                        class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                                    <c:forEach var="address" items="${addresses}">
                                        <option value="${address.addressId}">
                                            ${address.address} (${address.postalCode})
                                        </option>
                                    </c:forEach>
                                </select>
                                <button type="button" onclick="showAddressModal()"
                                        class="ml-2 text-blue-600 hover:text-blue-800 text-sm whitespace-nowrap">
                                    + Add New Address
                                </button>
                            </div>
                        </div>

                        <!-- Special Requests -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Special Requests</h3>
                            <textarea name="specialRequests" rows="3" 
                                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                                    placeholder="Any special instructions for the service provider?"></textarea>
                        </div>

                        <div class="mt-6">
                            <button type="submit"
                                    class="w-full bg-blue-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-blue-700 transition duration-200">
                                Confirm Booking
                            </button>
                        </div>
                    </div>
                </form>
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
        // Initialize Stripe
        const stripe = Stripe('${stripePublicKey}');

        // Address Modal Functions
        function showAddressModal() {
            document.getElementById('addressModal').classList.remove('hidden');
        }

        function hideAddressModal() {
            document.getElementById('addressModal').classList.add('hidden');
        }

        // Handle checkout form submission
        document.addEventListener('DOMContentLoaded', function() {
            const checkoutForm = document.getElementById('checkoutForm');
            if (checkoutForm) {
                checkoutForm.addEventListener('submit', async function(e) {
                    e.preventDefault();
                    
                    const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                    
                    if (paymentMethod === 'cash') {
                        this.submit();
                        return;
                    }

                    // Disable submit button
                    const submitButton = this.querySelector('button[type="submit"]');
                    submitButton.disabled = true;
                    submitButton.textContent = 'Processing...';

                    try {
                        console.log('Creating checkout session...'); // Debug log
                        const response = await fetch('${pageContext.request.contextPath}/stripe-checkout', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({
                                amount: ${total},
                                addressId: document.getElementById('addressId').value,
                                specialRequests: document.querySelector('textarea[name="specialRequests"]').value
                            })
                        });

                        console.log('Response received:', response.status); // Debug log

                        if (!response.ok) {
                            const errorData = await response.json();
                            throw new Error(errorData.error || 'Failed to create checkout session');
                        }

                        const data = await response.json();
                        console.log('Session created:', data); // Debug log

                        // Redirect to Stripe Checkout
                        const result = await stripe.redirectToCheckout({
                            sessionId: data.sessionId
                        });

                        if (result.error) {
                            throw new Error(result.error.message);
                        }

                    } catch (error) {
                        console.error('Payment error:', error);
                        alert('Payment processing error: ' + error.message);
                        submitButton.disabled = false;
                        submitButton.textContent = 'Proceed to Payment';
                    }
                });
            }

            // Handle payment method change
            const paymentMethodInputs = document.querySelectorAll('input[name="paymentMethod"]');
            paymentMethodInputs.forEach(input => {
                input.addEventListener('change', (e) => {
                    const submitButton = document.querySelector('#checkoutForm button[type="submit"]');
                    if (e.target.value === 'card') {
                        submitButton.textContent = 'Proceed to Payment';
                    } else {
                        submitButton.textContent = 'Confirm Booking';
                    }
                });
            });

            // Handle address form submission
            const addressForm = document.getElementById('addressForm');
            if (addressForm) {
                addressForm.addEventListener('submit', function(e) {
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
                        if (data.success) {
                            hideAddressModal();
                            addressForm.reset();
                            window.location.reload();
                        } else {
                            alert('Failed to add address: ' + (data.message || 'Unknown error'));
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Failed to add address. Please try again.');
                    });
                });
            }
        });

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('addressModal');
            if (event.target === modal) {
                hideAddressModal();
            }
        }

        // Check URL parameters for success/failure
        const urlParams = new URLSearchParams(window.location.search);
        const isSuccess = urlParams.get('success');
        const sessionId = urlParams.get('session_id');

        if (isSuccess === 'true' && sessionId) {
            // Payment was successful, submit the form to complete the booking
            const form = document.getElementById('checkoutForm');
            if (form) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'session_id';
                input.value = sessionId;
                form.appendChild(input);
                form.submit();
            }
        } else if (isSuccess === 'false') {
            alert('Payment was cancelled or failed. Please try again.');
        }
    </script>
</body>
</html>