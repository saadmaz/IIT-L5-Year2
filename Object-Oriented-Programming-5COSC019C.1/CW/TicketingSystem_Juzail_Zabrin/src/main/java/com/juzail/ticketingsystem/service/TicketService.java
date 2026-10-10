package com.juzail.ticketingsystem.service;

import com.juzail.ticketingsystem.model.Customer;
import com.juzail.ticketingsystem.model.SystemConfiguration;
import com.juzail.ticketingsystem.model.SystemStatus;
import com.juzail.ticketingsystem.model.TicketPool;
import com.juzail.ticketingsystem.model.Vendor;
import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Starts, stops and reports on the vendor/customer simulation.
 * Shared by the command-line interface and the REST controller.
 */
@Service
public class TicketService {
    private static final Logger log = LoggerFactory.getLogger(TicketService.class);
    private static final String EVENT_NAME = "Live Concert";
    private static final BigDecimal TICKET_PRICE = BigDecimal.valueOf(50.00);

    private final List<Thread> workers = new ArrayList<>();
    private TicketPool ticketPool;

    /** @throws IllegalStateException if a simulation is already running */
    public synchronized void start(SystemConfiguration config) {
        if (isRunning()) {
            throw new IllegalStateException("The ticketing system is already running.");
        }
        config.validate();

        workers.clear(); // drop finished threads from a previous run
        ticketPool = new TicketPool(config.getTotalTickets(), config.getMaxTicketCapacity());
        for (int i = 1; i <= config.getNumberOfVendors(); i++) {
            Vendor vendor = new Vendor(ticketPool, config.getTicketReleaseRate(), EVENT_NAME, TICKET_PRICE);
            workers.add(new Thread(vendor, "Vendor-" + i));
        }
        for (int i = 1; i <= config.getNumberOfCustomers(); i++) {
            Customer customer = new Customer(ticketPool, config.getCustomerRetrievalRate());
            workers.add(new Thread(customer, "Customer-" + i));
        }

        log.info("Starting ticketing system: {} tickets, capacity {}, {} vendors, {} customers.",
                config.getTotalTickets(), config.getMaxTicketCapacity(),
                config.getNumberOfVendors(), config.getNumberOfCustomers());
        workers.forEach(Thread::start);
    }

    /** Stops every vendor and customer and waits for them to finish. Safe to call when not running. */
    @PreDestroy
    public synchronized void stop() {
        if (workers.isEmpty()) {
            return;
        }
        ticketPool.close();
        workers.forEach(Thread::interrupt);
        for (Thread worker : workers) {
            try {
                worker.join();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
        workers.clear();
        log.info("Ticketing system stopped. {} of {} tickets sold.",
                ticketPool.getTicketsSold(), ticketPool.getTotalTickets());
    }

    public synchronized boolean isRunning() {
        return workers.stream().anyMatch(Thread::isAlive);
    }

    public synchronized SystemStatus getStatus() {
        if (ticketPool == null) {
            return SystemStatus.idle();
        }
        return new SystemStatus(
                isRunning(),
                ticketPool.getTotalTickets(),
                ticketPool.getTicketsReleased(),
                ticketPool.getTicketsSold(),
                ticketPool.getAvailableTickets(),
                ticketPool.getMaxCapacity());
    }
}
