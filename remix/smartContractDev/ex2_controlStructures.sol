// Control Structures Exercise
// Create a contract that adheres to the following specifications:

// Contract
// Create a single contract called ControlStructures. It should not inherit from any other contracts and does not need a constructor. It should have the following functions:

// Smart Contract FizzBuzz
// Create a function called fizzBuzz that accepts a uint called _number and returns a string memory. The function should return:

// "Fizz" if the _number is divisible by 3
// "Buzz" if the _number is divisible by 5
// "FizzBuzz" if the _number is divisible by 3 and 5
// "Splat" if none of the above conditions are true
// Do Not Disturb
// Create a function called doNotDisturb that accepts a uint called _time, and returns a string memory. It should adhere to the following properties:

// If _time is greater than or equal to 2400, trigger a panic
// If _time is greater than 2200 or less than 800, revert with a custom error of AfterHours, and include the time provided
// If _time is between 1200 and 1259, revert with a string message "At lunch!"
// If _time is between 800 and 1199, return "Morning!"
// If _time is between 1300 and 1799, return "Afternoon!"
// If _time is between 1800 and 2200, return "Evening!"



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Custom error for after hours
error AfterHours(uint time);

contract ControlStructures {
    /**
     * @dev Function to implement the FizzBuzz logic.
     * @param _number The number to evaluate for FizzBuzz.
     * @return string The result of FizzBuzz for the given number.
     */
    function fizzBuzz(uint _number) public pure returns (string memory) {
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz";
        }
        if (_number % 3 == 0) {
            return "Fizz";
        }
        if (_number % 5 == 0) {
            return "Buzz";
        }
        return "Splat";
    }

    /**
     * @dev Function to determine the activity based on the time of day.
     * @param _time The time to evaluate.
     * @return string The activity or message based on the time.
     */
    function doNotDisturb(uint _time) public pure returns (string memory) {
        // If the time is greater than or equal to 2400, trigger a panic via an assert statement
        assert(_time < 2400);

        if (_time > 2200 || _time < 800) {
            // Throws an AfterHours error if the time is outside of the range 800-2200
            revert AfterHours(_time);
        }
        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }
        if (_time >= 800 && _time < 1200) {
            return "Morning!";
        }
        if (_time >= 1300 && _time < 1800) {
            return "Afternoon!";
        }
        if (_time >= 1800 && _time <= 2199) {
            return "Evening!";
        }
        revert("Invalid time input.");
    }
}