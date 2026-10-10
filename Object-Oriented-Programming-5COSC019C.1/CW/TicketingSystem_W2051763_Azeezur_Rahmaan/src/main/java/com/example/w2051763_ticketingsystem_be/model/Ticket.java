package com.example.w2051763_ticketingsystem_be.model;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "tickets")
@Getter
@Setter
@NoArgsConstructor
public class Ticket {
    @Id
    private String id;

    @NotNull(message = "Ticket must belong to a ticket pool")
    private String ticketPoolId;

    private double price;

    @NotNull
    private String ticketType = "GA"; // general admission

    public Ticket(String ticketPoolId, double price, String ticketType) {
        this.ticketPoolId = ticketPoolId;
        this.price = price;
        this.ticketType = ticketType;
    }
}
