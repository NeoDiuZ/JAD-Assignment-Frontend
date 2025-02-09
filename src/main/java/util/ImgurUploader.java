package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import org.json.JSONObject;

public class ImgurUploader {
    private static final String IMGUR_API_URL = "https://api.imgur.com/3/image";
    private static final String CLIENT_ID = "61c455afaf3a795"; // Replace with your Imgur client ID

    public static String uploadImage(byte[] imageData) throws Exception {
        // Convert image data to Base64
        String base64Image = Base64.getEncoder().encodeToString(imageData);

        // Create connection
        URL url = new URL(IMGUR_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Client-ID " + CLIENT_ID);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        // Send the request
        try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream())) {
            writer.write("image=" + java.net.URLEncoder.encode(base64Image, "UTF-8"));
            writer.flush();
        }

        // Get the response
        StringBuilder response = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
        }

        // Parse the JSON response
        JSONObject json = new JSONObject(response.toString());
        JSONObject data = json.getJSONObject("data");
        
        // Return the direct link to the uploaded image
        return data.getString("link");
    }
}
