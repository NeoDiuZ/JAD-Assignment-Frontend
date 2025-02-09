<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <%@ include file="navbar.jsp" %>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h1 class="text-2xl font-bold mb-6">Shopping Cart</h1>

            <c:if test="${not empty sessionScope.error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    ${sessionScope.error}
                    <% session.removeAttribute("error"); %>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <p class="text-gray-500 text-center py-8">Your cart is empty</p>
                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/services" 
                           class="inline-block bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700">
                            Browse Services
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead>
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Service
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Date & Time
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Duration
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Price
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Actions
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            ${item.serviceName}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <fmt:formatDate value="${item.bookingTime}" pattern="MMM d, yyyy h:mm a" />
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            ${item.timeLength} hours
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            $<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <form action="removeFromCart" method="post" class="inline">
                                                <input type="hidden" name="cartId" value="${item.cartId}">
                                                <button type="submit" 
                                                        class="text-red-600 hover:text-red-900">
                                                    Remove
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-8 flex justify-between items-center">
                        <a href="${pageContext.request.contextPath}/services" 
                           class="text-blue-600 hover:text-blue-800">
                            Continue Shopping
                        </a>
                        <a href="${pageContext.request.contextPath}/checkout" 
                           class="bg-green-600 text-white px-6 py-2 rounded-md hover:bg-green-700">
                            Proceed to Checkout
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html> 