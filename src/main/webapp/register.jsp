<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - CleanIt</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
	<div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
		<div class="sm:mx-auto sm:w-full sm:max-w-sm">
			<h2
				class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">Create
				an account</h2>
		</div>

		<div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
			<!-- show error message if there's an error  -->
			<c:if test="${not empty error}">
				<div
					class="bg-red-100 border border-red-400 text-red-700 px-2 py-1.5 mb-2 text-sm rounded relative"
					role="alert">
					<strong class="font-bold">Error!</strong> <span
						class="block sm:inline">${error}</span>
				</div>
			</c:if>

			<form class="space-y-6" action="${pageContext.request.contextPath}/register" method="POST">
				<div>
					<label for="name"
						class="block text-sm font-medium leading-6 text-gray-900">Full
						Name</label>
					<div class="mt-2">
						<input id="name" name="name" type="text" autocomplete="name"
							required value="${param.name != null ? param.name : ''}"
							class="block w-full rounded-md border-0 py-1.5 px-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-purple-600 sm:text-sm sm:leading-6">
					</div>
				</div>

				<div>
					<label for="email"
						class="block text-sm font-medium leading-6 text-gray-900">Email
						Address</label>
					<div class="mt-2">
						<input id="email" name="email" type="email" autocomplete="email"
							required value="${param.email != null ? param.email : ''}"
							class="block w-full rounded-md border-0 py-1.5 px-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-purple-600 sm:text-sm sm:leading-6">
					</div>
				</div>

				<div>
					<label for="phone"
						class="block text-sm font-medium leading-6 text-gray-900">Phone
						Number</label>
					<div class="mt-2">
						<input id="phone" name="phone" type="text" autocomplete="tel"
							value="${param.phone != null ? param.phone : ''}"
							class="block w-full rounded-md border-0 py-1.5 px-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-purple-600 sm:text-sm sm:leading-6">
					</div>
				</div>

				<div>
					<label for="password"
						class="block text-sm font-medium leading-6 text-gray-900">Password</label>
					<div class="mt-2">
						<input id="password" name="password" type="password"
							autocomplete="new-password" required
							class="block w-full rounded-md border-0 py-1.5 px-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-purple-600 sm:text-sm sm:leading-6">
					</div>
				</div>

				<div>
					<label for="confirmPassword"
						class="block text-sm font-medium leading-6 text-gray-900">Confirm
						Password</label>
					<div class="mt-2">
						<input id="confirmPassword" name="confirmPassword" type="password"
							autocomplete="new-password" required
							class="block w-full rounded-md border-0 py-1.5 px-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-purple-600 sm:text-sm sm:leading-6">
					</div>
				</div>

				<div>
					<button type="submit"
						class="flex w-full justify-center rounded-md bg-purple-500 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-purple-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-purple-600">
						Register</button>
				</div>
			</form>
		

			<p class="mt-10 text-center text-sm text-gray-500">
				Already have an account? <a href="${pageContext.request.contextPath}/userLogin.jsp"
					class="font-semibold leading-6 text-purple-600 hover:text-purple-500">Sign
					in here</a>
			</p>
		</div>
	</div>
</body>
</html>