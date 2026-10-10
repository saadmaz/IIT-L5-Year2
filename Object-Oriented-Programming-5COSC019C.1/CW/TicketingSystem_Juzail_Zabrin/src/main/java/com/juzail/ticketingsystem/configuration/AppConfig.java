package com.juzail.ticketingsystem.configuration;

import com.juzail.ticketingsystem.cli.TicketingCli;
import com.juzail.ticketingsystem.service.TicketService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Scanner;

@Configuration
public class AppConfig {

    /**
     * Opens the console alongside the REST API. Typing "exit" shuts the whole application down.
     * Disable with {@code ticketing.cli.enabled=false} to run the REST API only.
     */
    @Bean
    @ConditionalOnProperty(name = "ticketing.cli.enabled", havingValue = "true", matchIfMissing = true)
    public CommandLineRunner ticketingCli(TicketService ticketService, ConfigurableApplicationContext context) {
        return args -> {
            new TicketingCli(ticketService, new Scanner(System.in)).run();
            System.exit(SpringApplication.exit(context));
        };
    }
}
