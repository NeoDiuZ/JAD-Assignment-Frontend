<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Login</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
	<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
		<div class="sm:mx-auto sm:w-full sm:max-w-sm">
			
			<h2
				class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">Sign
				in to your admin account</h2>
		</div>

		<c:if test="${not empty sessionScope.message}">
		    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4">
		        ${sessionScope.message}
		        <% session.removeAttribute("message"); %>
		    </div>
		</c:if>
		<div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
			<c:if test="${not empty error}">
				<div
					class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative"
					role="alert">
					<strong class="font-bold">Error:</strong> <span
						class="block sm:inline">${error}</span>
				</div>
			</c:if>

			<form class="space-y-6" action="${pageContext.request.contextPath}/login" method="POST">
				<input type="hidden" name="loginType" value="admin">
				<div>
					<label for="email"
						class="block text-sm font-medium leading-6 text-gray-900">Email
						address</label> <input id="email" name="email" type="email" required
						class="block w-full rounded-md py-1.5 px-2 ring-1 ring-inset ring-gray-300">
				</div>
				<div>
					<label for="password"
						class="block text-sm font-medium leading-6 text-gray-900">Password</label>
					<input id="password" name="password" type="password" required
						class="block w-full rounded-md py-1.5 px-2 ring-1 ring-inset ring-gray-300">
				</div>
				<button type="submit"
					class="w-full bg-purple-500 text-white py-1.5 rounded-md">Sign
					in</button>
			</form>
		</div>
	</div>
</body>
</html>
