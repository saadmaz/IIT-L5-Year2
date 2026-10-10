package com.example.w2051763_ticketingsystem_cli;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

/**
 * Saves vendors registered from the CLI into the same MongoDB database the REST API uses.
 * The connection string comes from the MONGODB_URI environment variable (never hard-code it).
 */
public class DatabaseConnection implements AutoCloseable {
    private static final String DEFAULT_URI = "mongodb://localhost:27017";
    private static final String DATABASE_NAME = "ticketingSystem_be";

    private MongoClient mongoClient;

    // Connects on first use, so the simulation works without a database
    private synchronized MongoDatabase database() {
        if (mongoClient == null) {
            String uri = System.getenv().getOrDefault("MONGODB_URI", DEFAULT_URI);
            MongoClientSettings settings = MongoClientSettings.builder()
                    .applyConnectionString(new ConnectionString(uri))
                    .applyToClusterSettings(cluster -> cluster.serverSelectionTimeout(5, TimeUnit.SECONDS))
                    .build();
            mongoClient = MongoClients.create(settings);
        }
        return mongoClient.getDatabase(DATABASE_NAME);
    }

    public boolean checkVendorExists(String username) {
        return vendors().countDocuments(new Document("username", username)) > 0;
    }

    /** @param passwordHash the BCrypt hash, never the plain password */
    public void saveVendor(String fullName, String username, String email, String passwordHash,
                           Configuration config, LocalDateTime dateJoined) {
        Document configDocument = new Document("totalTickets", config.getTotalTickets())
                .append("maxTicketCapacity", config.getMaxTicketCapacity())
                .append("ticketReleaseRate", config.getTicketReleaseRate())
                .append("customerRetrievalRate", config.getCustomerRetrievalRate());

        Document vendor = new Document("fullName", fullName)
                .append("username", username)
                .append("email", email)
                .append("password", passwordHash)
                .append("defaultConfig", configDocument)
                .append("dateJoined", dateJoined);

        vendors().insertOne(vendor);
    }

    private MongoCollection<Document> vendors() {
        return database().getCollection("vendors");
    }

    @Override
    public synchronized void close() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
