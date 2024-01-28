// Basic Functions Exercise
// Each module in this course will contain exercises in which you are given a specification for a contract without being given specific instructions on how to build the contract. You must use what you've learned to figure out the best solution on your own!

// INFO
// Once you've learned how to deploy your contracts to a test network, you'll be given the opportunity to submit your contract address for review by an onchain unit test. If it passes, you'll receive an NFT pin recognizing your accomplishment.

// You'll deploy and submit this contract in the next module.

// The following exercise asks you to create a contract that adheres to the following stated specifications.

// Contract
// Create a contract called BasicMath. It should not inherit from any other contracts and does not need a constructor. It should have the following two functions:

// Adder
// A function called adder. It must:

// Accept two uint arguments, called _a and _b
// Return a uint sum and a bool error
// If _a + _b do not overflow, it should return the sum and an error of false
// If _a + _b overflow, it should return 0 as the sum, and an error of true
// Subtractor
// A function called subtractor. It must:

// Accept two uint arguments, called _a and _b
// Return a uint difference and a bool error
// If _a - _b does not underflow, it should return the difference and an error of false
// If _a - _b underflows, it should return 0 as the difference, and an error of true



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BasicMath {
    /**
     * @dev Function to perform addition with overflow check.
     * @param _a The first operand.
     * @param _b The second operand.
     * @return result The sum of _a and _b.
     * @return error A boolean indicating whether overflow occurred (true) or not (false).
     */
    function adder(uint _a, uint _b) public pure returns (uint result, bool error) {
        unchecked {
            if ((_a + _b) >= _a) {
                return (_a + _b, false);  // No overflow, return sum and false for error
            }
        }
        return (0, true); // Overflow, return 0 and true for error
    }

    /**
     * @dev Function to perform subtraction with underflow check.
     * @param _a The first operand.
     * @param _b The second operand.
     * @return result The difference between _a and _b.
     * @return error A boolean indicating whether underflow occurred (true) or not (false).
     */
    function subtractor(uint _a, uint _b) public pure returns (uint result, bool error) {
        unchecked {
            if (_a >= _b) {
                return (_a - _b, false);  // No underflow, return difference and false for error
            }
        }
        return (0, true);  // Underflow, return 0 and true for error
    }
}
