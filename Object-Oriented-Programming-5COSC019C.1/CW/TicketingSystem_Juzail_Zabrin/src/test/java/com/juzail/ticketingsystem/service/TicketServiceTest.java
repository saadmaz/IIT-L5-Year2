package com.juzail.ticketingsystem.service;

import com.juzail.ticketingsystem.model.SystemConfiguration;
import com.juzail.ticketingsystem.model.SystemStatus;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertTimeoutPreemptively;

import java.time.Duration;

class TicketServiceTest {

    @Test
    void sellsExactlyTheConfiguredNumberOfTickets() {
        TicketService service = new TicketService();
        SystemConfiguration config = new SystemConfiguration(25, 0, 0, 3);

        assertTimeoutPreemptively(Duration.ofSeconds(10), () -> {
            service.start(config);
            while (service.isRunning()) {
                Thread.sleep(10);
            }
        });

        SystemStatus status = service.getStatus();
        assertEquals(25, status.ticketsReleased());
        assertEquals(25, status.ticketsSold());
        assertEquals(0, status.availableTickets());
    }

    @Test
    void canStartAgainAfterSellingOut() {
        TicketService service = new TicketService();
        assertTimeoutPreemptively(Duration.ofSeconds(10), () -> {
            for (int run = 0; run < 2; run++) {
                service.start(new SystemConfiguration(5, 0, 0, 2));
                while (service.isRunning()) {
                    Thread.sleep(10);
                }
                assertEquals(5, service.getStatus().ticketsSold());
            }
        });
    }

    @Test
    void stopDoesNotHangWhenThreadsAreWaiting() {
        TicketService service = new TicketService();
        // One customer buying slowly: vendors fill the pool and block waiting for space.
        SystemConfiguration config = new SystemConfiguration(100, 0, 1000, 2);
        config.setNumberOfCustomers(1);
        service.start(config);

        assertTimeoutPreemptively(Duration.ofSeconds(5), service::stop);
        assertFalse(service.isRunning());
    }

    @Test
    void rejectsInvalidConfiguration() {
        TicketService service = new TicketService();
        assertThrows(IllegalArgumentException.class, () -> service.start(new SystemConfiguration(0, 100, 100, 5)));
    }

    @Test
    void cannotStartTwice() {
        TicketService service = new TicketService();
        service.start(new SystemConfiguration(100, 1000, 1000, 5));
        try {
            assertTrue(service.isRunning());
            assertThrows(IllegalStateException.class, () -> service.start(new SystemConfiguration()));
        } finally {
            service.stop();
        }
    }
}
