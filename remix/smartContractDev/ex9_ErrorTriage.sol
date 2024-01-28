// Error Triage Exercise
// Copy the starter code into a new file in Remix.

// Debug the existing functions in the provided contract.

// contract ErrorTriageExercise {
//     /**
//      * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
//      * and returns a uint array with the absolute integer difference of each pairing.
//      */
//     function diffWithNeighbor(
//         uint _a,
//         uint _b,
//         uint _c,
//         uint _d
//     ) public pure returns (uint[] memory) {
//         uint[] memory results = new uint[](3);

//         results[0] = _a - _b;
//         results[1] = _b - _c;
//         results[2] = _c - _d;

//         return results;
//     }

//     /**
//      * Changes the _base by the value of _modifier.  Base is always >= 1000.  Modifiers can be
//      * between positive and negative 100;
//      */
//     function applyModifier(
//         uint _base,
//         int _modifier
//     ) public pure returns (uint) {
//         return _base + _modifier;
//     }

//     /**
//      * Pop the last element from the supplied array, and return the popped
//      * value (unlike the built-in function)
//      */
//     uint[] arr;

//     function popWithReturn() public returns (uint) {
//         uint index = arr.length - 1;
//         delete arr[index];
//         return arr[index];
//     }

//     // The utility functions below are working as expected
//     function addToArr(uint _num) public {
//         arr.push(_num);
//     }

//     function getArr() public view returns (uint[] memory) {
//         return arr;
//     }

//     function resetArr() public {
//         delete arr;
//     }
// }



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    // Array to store values
    uint256[] private arr;

    /**
     * @dev Calculates the absolute differences between consecutive pairs in a sequence of uints.
     * @param _a First uint in sequence
     * @param _b Second uint in sequence
     * @param _c Third uint in sequence
     * @param _d Fourth uint in sequence
     * @return Array of absolute differences between each consecutive pair (_a to _b, _b to _c, etc.)
     */
    function diffWithNeighbor(
        uint256 _a,
        uint256 _b,
        uint256 _c,
        uint256 _d
    ) public pure returns (uint256[] memory) {
        uint256[] memory results = new uint256[](3);

        // Calc absolute differences to avoid underflow errors
        results[0] = _a > _b ? _a - _b : _b - _a;
        results[1] = _b > _c ? _b - _c : _c - _b;
        results[2] = _c > _d ? _c - _d : _d - _c;

        return results;
    }

    /**
     * @dev Applies a modifier to the base value, ensuring the result stays >= 1000.
     * If a negative modifier would bring the base below 1000, the base is set to 1000.
     * If a positive modifier is applied, it is added to the base as long as the base remains >= 1000.
     * Modifiers can be positive or negative but are capped at -100 to 100.
     * @param _base Initial value, must be >= 1000.
     * @param _modifier Value to modify the base, can be positive or negative within -100 to 100.
     * @return The new base value after applying the modifier.
     */
    function applyModifier(uint256 _base, int256 _modifier)
        public
        pure
        returns (uint256)
    {
        if (_modifier < 0) {
            // Cast _modifier to uint to compare with _base and prevent underflow
            uint256 positiveModifier = uint256(-_modifier);
            // If negative _modifier is larger than _base, return 1000 to maintain base >= 1000
            if (positiveModifier > _base) {
                return 1000;
            } else {
                // Apply negative _modifier by subtracting
                return _base - positiveModifier;
            }
        } else {
            // Apply positive _modifier by adding, checking for overflows
            uint256 newBase = _base + uint256(_modifier);
            // Ensure the result is not less than 1000
            // Ternary: If newBase is greater than or equal to 1000, then the result of the operation is newBase; otherwise, the result is 1000
            return newBase >= 1000 ? newBase : 1000;
        }
    }

    /**
     * @dev Pops the last element from the contracts array and returns it.
     * @return The last value of the array before it was removed.
     */
    function popWithReturn() public returns (uint256) {
        require(arr.length > 0, "Array is empty");

        // Stores the last value to return after deletion
        uint256 poppedValue = arr[arr.length - 1];

        // Removes the last element by decreasing the arrays len
        arr.pop();

        return poppedValue;
    }

    /**
     * @dev Adds a single uint to the array.
     * @param _num The number to be added to the array.
     */
    function addToArr(uint256 _num) public {
        arr.push(_num);
    }

    /**
     * @dev Returns the current state of the array.
     * @return The array of uints.
     */
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    /**
     * @dev Resets the array to an empty state.
     */
    function resetArr() public {
        delete arr;
    }
}
