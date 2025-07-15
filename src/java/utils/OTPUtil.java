package utils;

import java.security.SecureRandom;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class OTPUtil {
    private static final ConcurrentHashMap<String, OTPData> otpStorage = new ConcurrentHashMap<>();
    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private static final int OTP_EXPIRY_MINUTES = 5;
    
    private static class OTPData {
        String otp;
        long expiryTime;
        
        OTPData(String otp, long expiryTime) {
            this.otp = otp;
            this.expiryTime = expiryTime;
        }
    }
    
    /**
     * Generate a 6-digit OTP
     */
    public static String generateOTP() {
        SecureRandom random = new SecureRandom();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    /**
     * Store OTP with expiry time
     */
    public static void storeOTP(String email, String otp) {
        long expiryTime = System.currentTimeMillis() + (OTP_EXPIRY_MINUTES * 60 * 1000);
        otpStorage.put(email, new OTPData(otp, expiryTime));
        
        // Schedule cleanup
        scheduler.schedule(() -> otpStorage.remove(email), OTP_EXPIRY_MINUTES, TimeUnit.MINUTES);
    }
    
    /**
     * Validate OTP
     */
    public static boolean validateOTP(String email, String inputOTP) {
        OTPData otpData = otpStorage.get(email);
        if (otpData == null) {
            return false;
        }
        
        // Check if OTP is expired
        if (System.currentTimeMillis() > otpData.expiryTime) {
            otpStorage.remove(email);
            return false;
        }
        
        // Validate OTP
        boolean isValid = otpData.otp.equals(inputOTP);
        if (isValid) {
            otpStorage.remove(email); // Remove OTP after successful validation
        }
        
        return isValid;
    }
    
    /**
     * Clear OTP for email
     */
    public static void clearOTP(String email) {
        otpStorage.remove(email);
    }
}
