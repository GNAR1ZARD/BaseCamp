// Imports Exercise
// Create a contract that adheres to the following specifications.

// Contract
// Create a contract called ImportsExercise. It should import a copy of SillyStringUtils

// library SillyStringUtils {

//     struct Haiku {
//         string line1;
//         string line2;
//         string line3;
//     }

//     function shruggie(string memory _input) internal pure returns (string memory) {
//         return string.concat(_input, unicode" 🤷");
//     }
// }

// Add a public instance of Haiku called haiku.

// Add the following two functions.

// Save Haiku
// saveHaiku should accept three strings and save them as the lines of haiku.

// Get Haiku
// getHaiku should return the haiku as a Haiku type.

// INFO
// Remember, the compiler will automatically create a getter for public structs, but these return each member individually. Create your own getters to return the type.

// Shruggie Haiku
// shruggieHaiku should use the library to add 🤷 to the end of line3. It must not modify the original haiku.



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Def the SillyStringUtils library directly in the same file
library SillyStringUtils {

    struct Haiku {
        string line1;
        string line2;
        string line3;
    }

    function shruggie(string memory _input) 
    internal 
    pure 
    returns (string memory){
        return string.concat(_input, unicode" 🤷");
    }
}

// The ImportsExercise contract contains the SillyStringUtils library code
// Flattend the code for verification purposes
contract ImportsExercise {
    // Utilize functions from SillyStringUtils library on Haiku struct
    using SillyStringUtils for SillyStringUtils.Haiku;

    // Public variable to store an instance of Haiku
    SillyStringUtils.Haiku public haiku;

    /**
     * @dev Saves a Haiku poem.
     * The function takes three strings as input and assigns them
     * to the Haiku struct, thus storing a new Haiku.
     *
     * @param line1 The first line of the Haiku.
     * @param line2 The second line of the Haiku.
     * @param line3 The third line of the Haiku.
     */
    function saveHaiku(
        string memory line1,
        string memory line2,
        string memory line3
    ) public {
        haiku = SillyStringUtils.Haiku(line1, line2, line3);
    }

    /**
     * @dev Retrieves the stored Haiku.
     * This function returns the current Haiku stored in the contract.
     * It returns all three lines of the Haiku together as a Haiku struct.
     *
     * @return The Haiku struct containing the three lines of the stored Haiku.
    */
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    /**
     * @dev Gets a modified version of the stored Haiku with a shruggie on the last line.
     * This function creates a temporary copy of the current Haiku,
     * modifies the third line by appending a shruggie emoji using the SillyStringUtils library,
     * and returns this modified Haiku. The original Haiku remains unchanged.
     *
     * @return A Haiku struct representing the modified Haiku with a shruggie on the third line.
     */
    function shruggieHaiku()
    public
    view
    returns (SillyStringUtils.Haiku memory)
    {
        SillyStringUtils.Haiku memory modifiedHaiku = haiku;
        modifiedHaiku.line3 = SillyStringUtils.shruggie(haiku.line3);
        return modifiedHaiku;
    }
}