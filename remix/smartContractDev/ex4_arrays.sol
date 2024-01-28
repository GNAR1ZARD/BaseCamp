// Arrays Exercise
// Create a contract that adheres to the following specifications.

// Contract
// Review the contract in the starter snippet called ArraysExercise. It contains an array called numbers that is initialized with the numbers 1–10. Copy and paste this into your file.

// contract ArraysExercise {
//     uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
// }

// Add the following functions:

// Return a Complete Array
// The compiler automatically adds a getter for individual elements in the array, but it does not automatically provide functionality to retrieve the entire array.

// Write a function called getNumbers that returns the entire numbers array.

// Reset Numbers
// Write a public function called resetNumbers that resets the numbers array to its initial value, holding the numbers from 1-10.

// NOTE
// We'll award the pin for any solution that works, but one that doesn't use .push() is more gas-efficient!

// CAUTION
// Remember, anyone can call a public function! You'll learn how to protect functionality in another lesson.

// Append to an Existing Array
// Write a function called appendToNumbers that takes a uint[] calldata array called _toAppend, and adds that array to the storage array called numbers, already present in the starter.

// Timestamp Saving
// At the contract level, add an address array called senders and a uint array called timestamps.

// Write a function called saveTimestamp that takes a uint called _unixTimestamp as an argument. When called, it should add the address of the caller to the end of senders and the _unixTimeStamp to timestamps.

// TIP
// You'll need to research on your own to discover the correct Special Variables and Functions that can help you with this challenge!

// Timestamp Filtering
// Write a function called afterY2K that takes no arguments. When called, it should return two arrays.

// The first should return all timestamps that are more recent than January 1, 2000, 12:00am. To save you a click, the Unix timestamp for this date and time is 946702800.

// The second should return a list of senders addresses corresponding to those timestamps.

// Resets
// Add public functions called resetSenders and resetTimestamps that reset those storage variables.



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @dev The `ArraysExercise` contract allows manipulation of various arrays, including numbers, timestamps, and senders.
 */
contract ArraysExercise {
    // State variables
    uint[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; // Fixed-size array
    uint[] public timestamps; // Dynamic array
    address[] public senders;

    /**
     * @dev Retrieves the entire 'numbers' array.
     * @return uint[] An array of integers.
     */
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    /**
     * @dev Resets the 'numbers' array to its initial values (1-10).
     */
    function resetNumbers() public {
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    /**
     * @dev Appends an array of integers to the 'numbers' array.
     * @param _toAppend An array of integers to append.
     */
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    /**
     * @dev Saves a timestamp and the address of the caller.
     * @param _unixTimestamp The Unix timestamp to save.
     */
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    /**
     * @dev Retrieves timestamps and sender addresses for all records created after January 1, 2000.
     * @return uint[] An array of recent Unix timestamps.
     * @return address[] An array of sender addresses corresponding to recent timestamps.
     */
    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint[] memory recentTimestamps;
        address[] memory recentSenders;

        uint y2kTimestamp = 946702800; // January 1, 2000, 12:00am

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > y2kTimestamp) {
                recentTimestamps = appendUint(recentTimestamps, timestamps[i]);
                recentSenders = appendAddress(recentSenders, senders[i]);
            }
        }
        return (recentTimestamps, recentSenders);
    }

    /**
     * @dev Resets the 'senders' array by deleting all entries.
     */
    function resetSenders() public {
        delete senders;
    }

    /**
     * @dev Resets the 'timestamps' array by deleting all entries.
     */
    function resetTimestamps() public {
        delete timestamps;
    }

    /**
     * @dev Internal function to append uint elements to an array.
     * @param array The original array to which elements will be appended.
     * @param element The uint element to append.
     * @return uint[] The updated array with the new element added.
     */
    function appendUint(
        uint[] memory array,
        uint element
    ) private pure returns (uint[] memory) {
        // Create a new array with an additional slot to hold the new element
        uint[] memory newArray = new uint[](array.length + 1);

        // Copy elements from the original array to the new array
        for (uint i = 0; i < array.length; i++) {
            newArray[i] = array[i];
        }

        // Add the new element to the end of the new array
        newArray[array.length] = element;

        // Return the updated array
        return newArray;
    }

    /**
     * @dev Internal function to append address elements to an array.
     * @param array The original array to which elements will be appended.
     * @param element The address element to append.
     * @return address[] The updated array with the new element added.
     */
    function appendAddress(
        address[] memory array,
        address element
    ) private pure returns (address[] memory) {
        // Create a new array with an additional slot to hold the new element
        address[] memory newArray = new address[](array.length + 1);

        // Copy elements from the original array to the new array
        for (uint i = 0; i < array.length; i++) {
            newArray[i] = array[i];
        }

        // Add the new element to the end of the new array
        newArray[array.length] = element;

        // Return the updated array
        return newArray;
    }
}
