<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${service.name} - Cleanify</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .star-rating input {
            display: none;
        }
        .star-rating label {
            cursor: pointer;
            color: #ddd;
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #ffd700;
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Include your navbar here -->
    <%@ include file="navbar.jsp" %>

    <!-- Success/Error Messages -->
    <c:if test="${param.rated == 'true'}">
        <div class="max-w-4xl mx-auto mt-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative">
            <span class="block sm:inline">Thank you for your rating!</span>
        </div>
    </c:if>
    <c:if test="${param.error == 'true'}">
        <div class="max-w-4xl mx-auto mt-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
            <span class="block sm:inline">There was an error submitting your rating. Please try again.</span>
        </div>
    </c:if>

    <!-- Service Details -->
    <div class="max-w-4xl mx-auto mt-8 px-4">
        <div class="bg-white rounded-lg shadow-lg overflow-hidden">
            <img src="${service.imagePath}" 
                 alt="${service.name}" 
                 class="w-full h-64 object-cover"
                 onerror="this.src='https://via.placeholder.com/800x400?text=No+Image'">
            
            <div class="p-6">
                <h1 class="text-3xl font-bold text-gray-900">${service.name}</h1>
                <p class="text-gray-600 mt-2">${service.description}</p>
                
                <div class="mt-4 flex items-center">
                    <span class="text-2xl font-bold text-blue-600">$${service.price}</span>
                    <span class="ml-2 text-gray-500">per service</span>
                </div>

                <!-- Rating display using averageRating -->
                <div class="mt-4">
                    <span class="text-yellow-400 text-xl">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= service.averageRating}">★</c:when>
                                <c:otherwise>☆</c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </span>
                    <span class="ml-2 text-gray-600">
                        <fmt:formatNumber value="${service.averageRating}" maxFractionDigits="1"/> / 5 
                        (${service.reviewCount} reviews)
                    </span>
                </div>

                <form action="booking" method="get" class="mt-6">
                    <input type="hidden" name="serviceId" value="${service.id}">
                    <button type="submit" 
                            class="w-full bg-blue-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-blue-700 transition duration-200">
                        Book Now
                    </button>
                </form>

                <form action="${pageContext.request.contextPath}/addToCart" method="post" class="mt-6">
                    <input type="hidden" name="serviceId" value="${service.id}">
                    <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700">Select Date and Time</label>
                        <input type="datetime-local" name="bookingTime" required 
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                    </div>
                    <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700">Duration (hours)</label>
                        <select name="timeLength" required
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            <option value="1">1 hour</option>
                            <option value="1.5">1.5 hours</option>
                            <option value="2">2 hours</option>
                            <option value="2.5">2.5 hours</option>
                            <option value="3">3 hours</option>
                        </select>
                    </div>
                    <button type="submit" 
                            class="w-full bg-green-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-green-700 transition duration-200">
                        Add to Cart
                    </button>
                </form>
            </div>
        </div>

        <!-- Rating Form -->
        <div class="mt-8 bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-2xl font-bold text-gray-900 mb-4">Leave a Review</h2>
            
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    <form action="service-details" method="post" class="space-y-4">
                        <input type="hidden" name="action" value="submitRating">
                        <input type="hidden" name="serviceId" value="${service.id}">
                        
                        <div class="star-rating text-3xl flex justify-center space-x-2">
                            <input type="radio" id="star5" name="rating" value="5" required>
                            <label for="star5" class="fas fa-star"></label>
                            <input type="radio" id="star4" name="rating" value="4">
                            <label for="star4" class="fas fa-star"></label>
                            <input type="radio" id="star3" name="rating" value="3">
                            <label for="star3" class="fas fa-star"></label>
                            <input type="radio" id="star2" name="rating" value="2">
                            <label for="star2" class="fas fa-star"></label>
                            <input type="radio" id="star1" name="rating" value="1">
                            <label for="star1" class="fas fa-star"></label>
                        </div>
                        
                        <div>
                            <label for="comment" class="block text-gray-700 font-medium mb-2">Your Review</label>
                            <textarea id="comment" name="comment" rows="4" 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                    required></textarea>
                        </div>
                        
                        <button type="submit" 
                                class="w-full bg-green-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-green-700 transition duration-200">
                            Submit Review
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <p class="text-center text-gray-600">
                        Please <a href="login" class="text-blue-600 hover:underline">login</a> to leave a review.
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Reviews List -->
        <div class="mt-8 bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-2xl font-bold text-gray-900 mb-4">Customer Reviews</h2>
            
            <div class="space-y-6">
                <c:forEach var="review" items="${reviews}">
                    <div class="border-b border-gray-200 pb-6 last:border-b-0">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="font-medium text-gray-900">${review.userName}</p>
                                <div class="text-yellow-400">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= review.rating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>
                            <span class="text-sm text-gray-500">
                                <fmt:formatDate value="${review.createdAt}" pattern="MMM dd, yyyy"/>
                            </span>
                        </div>
                        <p class="mt-2 text-gray-600">${review.comment}</p>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>