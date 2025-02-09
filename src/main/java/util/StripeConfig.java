package util;

public class StripeConfig {
    // Stripe test keys (replace with your test keys)
    public static final String STRIPE_PUBLIC_KEY = "pk_test_51QqSadQexy8XpkhDmu2FY9dIebHUW3tEAksrJaeKtab6OyLLg0CGVFeeAT4ThLVIjC8TFB07ghsMkYNvG2dDGb7d00h5nHvXnQ";
    public static final String STRIPE_SECRET_KEY = "sk_test_51QqSadQexy8XpkhDq7CtLnaHR1UPSUQsyNimXZ8JUgfZUjit1fO2xlz92zB3bTCJJYWANiT8hW133aTP5AavnvWD00X9ZYHcYs";
    
    // For simulation purposes
    public static boolean simulatePaymentSuccess() {
        // Simulate 90% success rate
        return Math.random() < 0.9;
    }
}