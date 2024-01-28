// Mappings Exercise
// Create a contract that adheres to the following specifications.

// Contract
// Create a single contract called FavoriteRecords. It should not inherit from any other contracts. It should have the following properties:

// State Variables
// The contract should have the following state variables. It is up to you to decide if any supporting variables are useful.

// A public mapping approvedRecords, which returns true if an album name has been added as described below, and false if it has not
// A mapping called userFavorites that indexes user addresses to a mapping of string record names which returns true or false, depending if the user has marked that album as a favorite
// Loading Approved Albums
// Using the method of your choice, load approvedRecords with the following:

// Thriller
// Back in Black
// The Bodyguard
// The Dark Side of the Moon
// Their Greatest Hits (1971-1975)
// Hotel California
// Come On Over
// Rumours
// Saturday Night Fever
// Get Approved Records
// Add a function called getApprovedRecords. This function should return a list of all of the names currently indexed in approvedRecords.

// Add Record to Favorites
// Create a function called addRecord that accepts an album name as a parameter. If the album is on the approved list, add it to the list under the address of the sender. Otherwise, reject it with a custom error of NotApproved with the submitted name as an argument.

// Users' Lists
// Write a function called getUserFavorites that retrieves the list of favorites for any address.

// Reset My Favorites
// Add a function called resetUserFavorites that resets userFavorites for the sender.



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @dev The `FavoriteRecords` contract allows users to manage their favorite records (albums) from a list of approved records.
 * Users can add records to their favorites, retrieve their favorite records, and reset their favorites.
 */
contract FavoriteRecords {
    // State Variables
    mapping(string => bool) public approvedRecords;
    string[] approvedRecordsArray;
    mapping(address => mapping(string => bool)) private userFavorites;

    constructor() {
        // Loading Approved Albums
        addApprovedRecord("Thriller");
        addApprovedRecord("Back in Black");
        addApprovedRecord("The Bodyguard");
        addApprovedRecord("The Dark Side of the Moon");
        addApprovedRecord("Their Greatest Hits (1971-1975)");
        addApprovedRecord("Hotel California");
        addApprovedRecord("Come On Over");
        addApprovedRecord("Rumours");
        addApprovedRecord("Saturday Night Fever");
    }

    /**
     * @dev Adds an approved record to the list of approved records.
     * @param record The name of the approved record to add.
     */
    function addApprovedRecord(string memory record) public {
        approvedRecords[record] = true;
        approvedRecordsArray.push(record);
    }

    /**
     * @dev Retrieves the list of approved records.
     * @return string[] An array of approved record names.
     */
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordsArray;
    }

    /**
     * @dev Adds a record to the user's favorites.
     * @param record The name of the record to add to favorites.
     */
    function addRecord(string memory record) public {
        require(
            approvedRecords[record] == true,
            "NotApproved: This album is not on the approved list."
        );

        // Marks the record as a favorite for the user at `msg.sender`
        userFavorites[msg.sender][record] = true;
    }

    /**
     * @dev Retrieves the user's favorite records.
     * @param userAddress The address of the user for whom to retrieve favorites.
     * @return string[] An array of favorite record names for the specified user.
     */
    function getUserFavorites(
        address userAddress
    ) public view returns (string[] memory) {
        string[] memory favorites = new string[](approvedRecordsArray.length);
        uint256 counter = 0;
        for (uint256 i = 0; i < approvedRecordsArray.length; i++) {
            if (userFavorites[userAddress][approvedRecordsArray[i]]) {
                favorites[counter] = approvedRecordsArray[i];
                counter++;
            }
        }
        // Resize array based on the actual number of favs
        string[] memory actualFavorites = new string[](counter);
        for (uint256 i = 0; i < counter; i++) {
            actualFavorites[i] = favorites[i];
        }
        return actualFavorites;
    }

    /**
     * @dev Resets the user's favorites by deleting all their fav records.
     */
    function resetUserFavorites() public {
        for (uint256 i = 0; i < approvedRecordsArray.length; i++) {
            string memory record = approvedRecordsArray[i];
            if (userFavorites[msg.sender][record]) {
                delete userFavorites[msg.sender][record];
            }
        }
    }
}
