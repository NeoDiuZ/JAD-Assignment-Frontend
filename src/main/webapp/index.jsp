<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cleanify - Home</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Host+Grotesk:wght@300;400;700;800&display=swap')
	;

.font-host {
	font-family: "Host Grotesk", sans-serif;
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.animate-fadeIn {
	animation: fadeIn 1s ease-in-out;
}
</style>
</head>

<body class="m-0 p-0 overflow font-host">
	<!-- Navbar -->
	<%@ include file="navbar.jsp"%>



	<!-- Video Background Section -->
	<section
		class="relative w-full h-screen flex items-center justify-center">
		<img
			src="https://images.unsplash.com/photo-1686178827149-6d55c72d81df?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
			alt="Relax and clean environment"
			class="absolute inset-0 w-full h-full object-cover">

		<div class="absolute inset-0 bg-gray-900 bg-opacity-50"></div>

		<div class="relative z-10 text-center">
			<h1 class="text-white text-5xl md:text-8xl font-bold uppercase">
				Relax this weekend.<br>We'll take care of the cleaning.
			</h1>
			<p class="text-white text-lg md:text-2xl mt-4">Don't worry. We
				are available on weekdays too.</p>
			<div class="mt-10">
				<c:choose>
					<c:when test="${empty sessionScope.user}">
						<a href="userLogin.jsp"
							class="bg-blue-500 hover:bg-blue-400 text-white px-6 py-3 rounded-md">Get
							Started</a>
					</c:when>
					<c:otherwise>
						<a href="services"
							class="bg-blue-500 hover:bg-blue-400 text-white px-6 py-3 rounded-md">Book
							Now</a>
					</c:otherwise>
				</c:choose>
				<a href="services" class="text-white text-lg ml-4">Our Services →</a>
			</div>
		</div>
	</section>

	<!-- Section 2: Media showcases -->
	<section id="" class="bg-white p-10">
		<div class="section2A mb-16 text-center">
			<p class="text-lg sm:text-xl md:text-2xl lg:text-3xl font-bold">
				We are Proudly Showcased On</p>
			<div class="flex flex-wrap justify-center gap-9 mt-6">
				<a href="#"><img
					class="w-24 md:w-40 transition-transform duration-300 hover:scale-110"
					src="https://cdn.prod.website-files.com/63b394265bacadc142387b91/63da13c610fd5e839b1b16b1_Group%201000001277.webp"
					alt="yahoo"></a> <a href="#"><img
					class="w-24 md:w-40 transition-transform duration-300 hover:scale-110"
					src="https://cdn.prod.website-files.com/63b394265bacadc142387b91/63da13c642072597da30d530_Group%201000001278.webp"
					alt="CNA"></a> <a href="#"><img
					class="w-24 md:w-40 transition-transform duration-300 hover:scale-110"
					src="https://cdn.prod.website-files.com/63b394265bacadc142387b91/63da13c65859f403eb765562_Group%201000001279.webp"
					alt="TechInAsia"></a> <a href="#"><img
					class="w-24 md:w-40 transition-transform duration-300 hover:scale-110"
					src="https://cdn.prod.website-files.com/63b394265bacadc142387b91/63da13c649434bb212a2718c_Group%201000001280.webp"
					alt="Singapore Business Review"></a> <a href="#"><img
					class="w-24 md:w-40 transition-transform duration-300 hover:scale-110"
					src="https://cdn.prod.website-files.com/63b394265bacadc142387b91/63da13c64a5c00f2745ca28d_Group%201000001281.webp"
					alt="The Business Times"></a> <a href="#"><img
					class="w-24 md:w-40 transition-transform duration-300 hover:scale-110"
					src="https://cdn.prod.website-files.com/63b394265bacadc142387b91/63da13c6b6f7147e3b553463_Group%201000001282.webp"
					alt="Group"></a>
			</div>
		</div>

		<!-- Section 2B Description -->
		<div
			class="flex flex-col lg:flex-row items-start lg:items-center lg:gap-10 md:px-10 animate-fadeIn my-8">
			<div class="flex flex-col space-y-6 w-full lg:w-1/2 md:pl-10">
				<div class="relative border-l-4 pl-4 border-blue-500 animate-fadeIn">
					<button
						class="text-3xl md:text-5xl font-bold focus:outline-none toggle-heading"
						data-target="#section1">Trusted expertise</button>
					<p id="section1" class="mt-2">Our certified team of experts are
						equipped with deepened sanitation knowledge, bringing extensive
						experience and professionalism to support your needs.</p>
				</div>
				<div class="relative border-l-4 pl-4 border-blue-500 animate-fadeIn">
					<button
						class="text-3xl md:text-5xl font-bold focus:outline-none toggle-heading"
						data-target="#section2">A one-stop solution</button>
					<p id="section2" class="mt-2 ">From upholstery maintenance to
						cleaning offices and rental properties — we do it all.</p>
				</div>
				<div class="relative border-l-4 pl-4 border-blue-500 animate-fadeIn">
					<button
						class="text-3xl md:text-5xl font-bold focus:outline-none toggle-heading"
						data-target="#section3">Transparent pricing</button>
					<p id="section3" class="mt-2">Everyone deserves a clean and
						healthy environment, which is why we believe in making our
						services accessible and affordable.</p>
				</div>
			</div>

			<div class="mt-6 lg:mt-0 w-full lg:w-1/2 flex justify-center">
				<img
					src="https://www.cleaningbusinessacademy.com/wp-content/uploads/2012/08/types-of-house-cleaning-services-to-offer.jpg"
					alt="a cleaner"
					class="md:w-2/3 h-auto rounded-lg shadow-lg transform transition-transform duration-500 ease-in-out hover:scale-105 animate-fadeIn">
			</div>
		</div>
	</section>

	<!-- Section 3: Commercial Cleaning -->
	<div
		class="mx-auto px-6 lg:px-8 py-16 flex flex-col lg:flex-row items-center gap-12 bg-black text-white">
		<div class="w-full lg:w-1/2">
			<img
				src="https://thebetterguys.sg/wp-content/uploads/2023/07/TBG_LD_05.jpg"
				alt="Commercial Cleaning" class="rounded-lg shadow-lg w-full h-auto">
		</div>
		<div class="w-full lg:w-1/2">
			<p class="text-sm uppercase tracking-wide text-gray-400">Commercial
				Cleaning</p>
			<h2 class="text-4xl font-bold text-white mt-4">A premier
				provider of commercial cleaning services.</h2>
			<p class="text-lg text-gray-300 mt-4">Offices, gyms, schools,
				cafes — No matter where or what commercial spaces you own, we've got
				you covered. More than just a Commercial Cleaning Service company,
				we're a partner in facility rejuvenation.</p>
			<button
				class="bg-blue-500 hover:bg-blue-400 text-white px-6 py-3 rounded-md mt-6">
				
				<a href="services">Learn More →</a>
				</button>
		</div>
	</div>

	<!-- Section 5: Customer Reviews -->
	<div class="bg-blue-50 py-12">
		<div class="max-w-6xl mx-auto px-6 relative overflow-hidden">
			<!-- Carousel Container -->
			<div id="carousel" class="flex transition-transform duration-500">
				<!-- Review 1 -->
				<div
					class="flex-shrink-0 w-full md:flex md:items-center md:justify-between">
					<div class="md:w-2/3">
						<h2 class="text-sm font-semibold text-gray-700 uppercase mb-4">What
							Our Customers Are Saying</h2>
						<blockquote class="text-3xl font-bold text-gray-900">
							"Absolutely top-notch service. Was about to throw out the sofa
							but it was like new after these guys. They came by the same day I
							contacted them and finished in an hour. Great service!"</blockquote>
						<p class="mt-4 text-gray-600">Mick Bowens</p>
					</div>
					<div class="mt-8 md:mt-0 md:w-1/3 flex justify-center">
						<img
							src="https://www.gilgalproperties.com/wp-content/uploads/2018/11/black-businessman-happy-expression_1194-2542.jpg"
							alt="Happy customer with the cleaning team"
							class="rounded-lg shadow-lg" />
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer -->
	<%@ include file="footer.jsp"%>


	<!-- JavaScript -->
	<script>
        // Mobile menu functionality
        const mobileMenuButton = document.getElementById('mobile-menu-button');
        const mobileMenu = document.getElementById('mobile-menu');

        mobileMenuButton.addEventListener('click', () => {
            mobileMenu.classList.toggle('hidden');
        });

        // Section toggle functionality
        document.querySelectorAll('.toggle-heading').forEach(button => {
            button.addEventListener('click', () => {
                const targetId = button.getAttribute('data-target');
                document.querySelectorAll('.toggle-heading + p').forEach(section => {
                    section.classList.add('hidden');
                });
                document.querySelector(targetId).classList.remove('hidden');
            });
        });

        // Keep first section open initially
        document.querySelector('#section1').classList.remove('hidden');

        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) {
                navbar.classList.remove('bg-transparent');
                navbar.classList.add('bg-white', 'shadow-md');
            } else {
                navbar.classList.add('bg-transparent');
                navbar.classList.remove('bg-white', 'shadow-md');
            }
        });

    </script>
</body>
</html>