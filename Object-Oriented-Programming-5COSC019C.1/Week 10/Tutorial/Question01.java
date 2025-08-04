// 1) Why do you get the error when accessing myArray[5] in an array of size 5?
// Explanation:
// In Java, arrays are zero-indexed. myArray[5] tries to access the sixth element (indices go from 0 to 4).
// This throws an ArrayIndexOutOfBoundsException at runtime, not at compile time.