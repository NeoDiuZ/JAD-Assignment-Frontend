package models;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private int userId;
    private int serviceId;
    private Timestamp bookingTime;
    private String status;
    private String specialRequests;
    private float timeLength;
    private String userName;
    private String serviceName;
    private float totalCost;
    private String address;
    
    public int getId() { 
        return id; 
        }
        
    public void setId(int id) { 
        this.id = id; 
    	}
    
    public int getUserId() { 
        return userId; 
        }
        
    public void setUserId(int userId) { 
        this.userId = userId; 
        }
    
    public int getServiceId() { 
        return serviceId; 
        }
        
    public void setServiceId(int serviceId) { 
        this.serviceId = serviceId; 
        }
    
    public Timestamp getBookingTime() { 
        return bookingTime; 
        }
        
    public void setBookingTime(Timestamp bookingTime) { 
        this.bookingTime = bookingTime; 
        }
    
    public String getStatus() { 
        return status; 
        }
        
    public void setStatus(String status) { 
        this.status = status; 
        }
    
    public String getSpecialRequests() { 
        return specialRequests; 
        }
        
    public void setSpecialRequests(String specialRequests) { 
        this.specialRequests = specialRequests; 
        }
    
    public float getTimeLength() { 
        return timeLength; 
        }
        
    public void setTimeLength(float timeLength) { 
        this.timeLength = timeLength; 
        }
    
    public String getUserName() { 
        return userName; 
        }
        
    public void setUserName(String userName) { 
        this.userName = userName; 
        }
    
    public String getServiceName() { 
        return serviceName; 
        }
        
    public void setServiceName(String serviceName) { 
        this.serviceName = serviceName; 
        }
    
    public float getTotalCost() {
        return totalCost;
    }
    
    public void setTotalCost(float totalCost) {
        this.totalCost = totalCost;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
}