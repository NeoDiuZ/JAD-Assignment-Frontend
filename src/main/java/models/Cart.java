package models;

import java.sql.Timestamp;

public class Cart {
    private int cartId;
    private int userId;
    private int serviceId;
    private Timestamp bookingTime;
    private float timeLength;
    private String serviceName;
    private double price;
    private Timestamp createdAt;

    // Getters and Setters
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    
    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }
    
    public float getTimeLength() { return timeLength; }
    public void setTimeLength(float timeLength) { this.timeLength = timeLength; }
    
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public double getTotalPrice() {
        return price * timeLength;
    }
}