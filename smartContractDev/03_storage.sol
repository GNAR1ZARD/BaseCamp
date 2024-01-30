// Storage Exercise
// Create a contract that adheres to the following specifications:

// Contract
// Create a single contract called EmployeeStorage. It should not inherit from any other contracts. It should have the following functions:

// State Variables
// The contract should have the following state variables, optimized to minimize storage:

// A private variable shares storing the employee's number of shares owned
// Employees with more than 5,000 shares count as directors and are stored in another contract
// Public variable name which stores the employee's name
// A private variable salary storing the employee's salary
// Salaries range from 0 to 1,000,000 dollars
// A public variable idNumber storing the employee's ID number
// Employee numbers are not sequential, so this field should allow any number up to 2^256-1
// Constructor
// When deploying the contract, utilize the constructor to set:

// shares
// name
// salary
// idNumber
// For the purposes of the test, you must deploy the contract with the following values:

// shares - 1000
// name - Pat
// salary - 50000
// idNumber - 112358132134
// View Salary and View Shares
// DANGER
// In the world of blockchain, nothing is ever secret!* private variables prevent other contracts from reading the value. You should use them as a part of clean programming practices, but marking a variable as private does not hide the value. All data is trivially available to anyone who knows how to fetch data from the chain.

// *You can make clever use of encryption though!

// Write a function called viewSalary that returns the value in salary.

// Write a function called viewShares that returns the value in shares.

// Grant Shares
// Add a public function called grantShares that increases the number of shares allocated to an employee by _newShares. It should:

// Add the provided number of shares to the shares
// If this would result in more than 5000 shares, revert with a custom error called TooManyShares that returns the number of shares the employee would have with the new amount added
// If the number of _newShares is greater than 5000, revert with a string message, "Too many shares"
// Check for Packing and Debug Reset Shares



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Custom error to handle too many shares
error TooManyShares(uint shares);

contract EmployeeStorage {
    // State variables
    uint public idNumber;
    uint24 private salary;
    uint16 private shares;
    string public name;

    // Initialization
    constructor(
        uint16 _shares,
        string memory _name,
        uint24 _salary,
        uint _idNumber
    ) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    /**
     * @dev View function to retrieve the salary of the employee.
     * @return uint The salary of the employee.
     */
    function viewSalary() public view returns (uint) {
        return salary;
    }

    /**
     * @dev View function to retrieve the number of shares owned by the employee.
     * @return uint The number of shares owned.
     */
    function viewShares() public view returns (uint) {
        return shares;
    }

    /**
     * @dev Function to grant additional shares to the employee.
     * @param _newShares The number of new shares to grant.
     */
    function grantShares(uint16 _newShares) public {
        uint16 updatedShares = shares + _newShares;

        require(_newShares <= 5000, "Too many shares");

        if (updatedShares >= 5000) {
            revert TooManyShares(updatedShares);
        }

        shares = updatedShares;
    }

    //provided
    /**
     * Do not modify this function.  It is used to enable the unit test for this pin
     * to check whether or not you have configured your storage variables to make
     * use of packing.
     *
     * If you wish to cheat, simply modify this function to always return `0`
     * I'm not your boss ¯\_(ツ)_/¯
     *
     * Fair warning though, if you do cheat, it will be on the blockchain having been
     * deployed by you wallet....FOREVER!
     */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    /**
     * Warning: Anyone can use this function at any time!
     */
    function debugResetShares() public {
        shares = 1000;
    }
} //end contract
