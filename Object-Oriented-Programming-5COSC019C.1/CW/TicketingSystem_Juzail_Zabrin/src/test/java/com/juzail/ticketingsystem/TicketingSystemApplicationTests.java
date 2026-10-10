package com.juzail.ticketingsystem;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = "ticketing.cli.enabled=false")
class TicketingSystemApplicationTests {

	@Test
	void contextLoads() {
	}

}
