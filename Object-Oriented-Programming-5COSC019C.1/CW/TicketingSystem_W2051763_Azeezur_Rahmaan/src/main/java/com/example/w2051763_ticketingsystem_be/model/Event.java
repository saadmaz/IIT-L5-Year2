package com.example.w2051763_ticketingsystem_be.model;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "events")
@Getter
@Setter
@NoArgsConstructor
public class Event {
    @Id
    private String id;

    @NotNull(message = "Event name cannot be null")
    private String eventName;

    private String description;

    @NotNull(message = "Event location cannot be null")
    private String location;

    private String[] tags;

    @NotNull(message = "Event start time cannot be null")
    private LocalDateTime startTime;

    @NotNull(message = "Event end time cannot be null")
    private LocalDateTime endTime;

    @NotNull(message = "Event must belong to a vendor")
    private String vendorId;
}
