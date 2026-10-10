package com.example.w2051763_ticketingsystem_cli;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class TicketPoolTest {

    @Test
    void neverReleasesMoreThanMaxCapacity() {
        TicketPool pool = new TicketPool(new Event("TEST", 10), new Configuration(3, 5, 5, 10));
        assertEquals(3, pool.getAvailableTickets());
        assertEquals(5, pool.addTickets(5));
        assertEquals(2, pool.addTickets(5)); // only 2 left before reaching 10
        assertEquals(0, pool.addTickets(5));
    }

    @Test
    void concurrentVendorsAndConsumersSellEveryTicketExactlyOnce() throws InterruptedException {
        TicketPool pool = new TicketPool(new Event("TEST", 10), new Configuration(0, 50, 50, 200));
        Set<Integer> boughtIds = ConcurrentHashMap.newKeySet();

        List<Thread> threads = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            threads.add(new Thread(() -> {
                while (pool.addTickets(10) > 0) {
                    Thread.onSpinWait();
                }
            }));
        }
        for (int i = 0; i < 4; i++) {
            threads.add(new Thread(() -> {
                while (!pool.isSoldOut()) {
                    Ticket ticket = pool.removeTicket();
                    if (ticket != null) {
                        assertTrue(boughtIds.add(ticket.getTicketId()), "ticket sold twice");
                    }
                }
            }));
        }
        threads.forEach(Thread::start);
        for (Thread thread : threads) {
            thread.join(10_000);
        }

        assertEquals(200, pool.getTotalTicketsSold());
        assertEquals(200, boughtIds.size());
        assertEquals(0, pool.getAvailableTickets());
    }
}
