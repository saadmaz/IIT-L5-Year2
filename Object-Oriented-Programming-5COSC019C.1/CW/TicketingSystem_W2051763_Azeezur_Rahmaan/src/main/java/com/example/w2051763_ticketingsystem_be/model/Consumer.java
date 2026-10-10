package com.example.w2051763_ticketingsystem_be.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "consumers")
@Getter
@Setter
@NoArgsConstructor
public class Consumer extends User {
    @Id
    private String id;

    private Priority priority = Priority.GENERAL;

    public enum Priority {
        VIP,
        GENERAL
    }
}
