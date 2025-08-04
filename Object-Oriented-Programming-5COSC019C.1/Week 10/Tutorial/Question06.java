public class Question06 {
    
}

// 6) Testing: typical interview questions

// (1) How would you test boolean canMoveTo(int x, int y) in a chess game?
/*
- Identify all legal and illegal moves for the piece (e.g., a rook moves horizontally/vertically)
- Prepare test cases for:
    - Valid moves within the board
    - Invalid moves (diagonals for a rook, or moves off the board)
    - Edge cases (corners, edges)
    - Moves blocked by other pieces (if applicable)
    - Out-of-bounds coordinates (negative or > 7)
- For each, assert canMoveTo returns the correct value (true for valid, false for invalid)
*/

// (2) How would you test an ATM in a distributed banking system?
/*
- Functional tests: withdraw, deposit, check balance, transfer funds
- Edge cases: withdraw more than balance, deposit negative, incorrect PIN
- Concurrency: multiple transactions from different ATMs at the same time
- Network failures: simulate connection losses during transactions
- Security: unauthorized access attempts, tampering
- Recovery: verify that incomplete transactions are rolled back properly
- Integration: test communication with the central banking server and database consistency
*/
