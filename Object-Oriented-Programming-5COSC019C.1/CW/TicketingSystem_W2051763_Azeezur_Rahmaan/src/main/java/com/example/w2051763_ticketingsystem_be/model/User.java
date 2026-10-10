package com.example.w2051763_ticketingsystem_be.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * Fields shared by vendors and consumers.
 */
@Getter
@Setter
@NoArgsConstructor
public abstract class User {

    @NotNull(message = "Full name cannot be null")
    @Size(min = 2, max = 100, message = "Full name must be between 2 and 100 characters")
    private String fullName;

    @NotNull(message = "Username cannot be null")
    @Size(min = 3, max = 30, message = "Username must be between 3 and 30 characters")
    private String username;

    // Accepted in requests but never returned in responses; stored as a BCrypt hash
    @NotNull(message = "Password cannot be null")
    @Size(min = 8, max = 30, message = "Password must be between 8 and 30 characters")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @NotNull(message = "Email cannot be null")
    @Email(message = "Email should be valid")
    private String email;

    private LocalDateTime dateJoined = LocalDateTime.now();
}
