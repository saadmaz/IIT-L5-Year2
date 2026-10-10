package com.example.w2051763_ticketingsystem_be.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "vendors")
@Getter
@Setter
@NoArgsConstructor
public class Vendor extends User {
    @Id
    private String id;

    // Default ticket pool settings used when this vendor creates an event
    private Configuration defaultConfig;
}
