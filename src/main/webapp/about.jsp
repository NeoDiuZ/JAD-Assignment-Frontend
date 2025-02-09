<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body class="font-host bg-white">
	<%@ include file="navbar.jsp" %>

    <!-- Hero Section -->
    <header class="bg-blue-500 text-white py-20">
        <div class="max-w-7xl mx-auto px-6 lg:px-8 text-center">
            <h1 class="text-4xl font-bold">About Us</h1>
            <p class="mt-4 text-lg">Learn more about Cleanify, our mission, and the values that drive us.</p>
        </div>
    </header>

    <!-- About Us Content -->
    <main class="py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Section: Who We Are -->
            <section class="mb-16">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
                    <!-- Text Content -->
                    <div>
                        <h2 class="text-3xl font-bold text-gray-900 mb-6">Who We Are</h2>
                        <p class="text-gray-700 text-lg">
                            At Cleanify, we believe a clean environment is a happy environment. Founded in 2015, our team of
                            experienced professionals has been providing top-notch cleaning services to homes, offices, and
                            businesses across the region.
                        </p>
                        <p class="text-gray-700 text-lg mt-4">
                            We take pride in delivering consistent, reliable, and eco-friendly cleaning solutions tailored to
                            your unique needs. Our mission is to make your life easier and your space cleaner.
                        </p>
                    </div>
                    <!-- Image -->
                    <div>
                        <img src="https://koala.sh/api/image/v2-4dcq1-hx0nk.jpg?width=1344&height=768&dream" alt="Our Team" class="rounded-lg shadow-md w-full h-auto">
                    </div>
                </div>
            </section>

            <!-- Section: Our Values -->
            <section class="mb-16">
                <h2 class="text-3xl font-bold text-gray-900 mb-6 text-center">Our Values</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <!-- Value 1 -->
                    <div class="bg-gray-50 p-6 rounded-lg  text-center">
                        <h3 class="text-xl font-bold text-gray-900">Excellence</h3>
                        <p class="text-gray-700 mt-4">We strive to exceed expectations with every service we provide.</p>
                    </div>
                    <!-- Value 2 -->
                    <div class="bg-gray-50 p-6 rounded-lg  text-center">
                        <h3 class="text-xl font-bold text-gray-900">Sustainability</h3>
                        <p class="text-gray-700 mt-4">We use eco-friendly products and methods to protect the planet.</p>
                    </div>
                    <!-- Value 3 -->
                    <div class="bg-gray-50 p-6 rounded-lg  text-center">
                        <h3 class="text-xl font-bold text-gray-900">Trust</h3>
                        <p class="text-gray-700 mt-4">We build lasting relationships with clients based on transparency and reliability.</p>
                    </div>
                </div>
            </section>

            <!-- Section: Why Choose Us -->
            <section class="mb-16">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
                    <!-- Image -->
                    <div>
                        <img src="https://koala.sh/api/image/v2-4dcqf-vcomi.jpg?width=1344&height=768&dream" alt="Why Choose Us" class="rounded-lg shadow-md w-full h-auto">
                    </div>
                    <!-- Text Content -->
                    <div>
                        <h2 class="text-3xl font-bold text-gray-900 mb-6">Why Choose Us</h2>
                        <ul class="space-y-4 text-gray-700 text-lg">
                            <li>✔️ Highly trained and certified cleaning experts.</li>
                            <li>✔️ Personalized cleaning solutions tailored to your needs.</li>
                            <li>✔️ Affordable, transparent pricing with no hidden fees.</li>
                            <li>✔️ Reliable, punctual service every time.</li>
                        </ul>
                        <button class="mt-6 bg-blue-500 hover:bg-blue-400 text-white px-6 py-3 rounded-md">
                            <a href="services">Learn More About Our Services</a>
                        </button>
                    </div>
                </div>
            </section>
        </div>
    </main>
	<%@ include file="footer.jsp" %>
	

</body>
</html>