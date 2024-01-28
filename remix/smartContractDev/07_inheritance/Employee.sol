// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Employee is an abstract contract representing an employee with an ID and manager ID
abstract contract Employee {
    uint256 public idNumber; // The unique identifier for the employee
    uint256 public managerId; // The identifier of the employees manager

    /**
     * @dev Initializes an employee with the provided ID and manager ID.
     * @param _idNumber The unique identifier for the employee.
     * @param _managerId The identifier of the employees manager.
     */
    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    /**
     * @dev Abstract function to calculate the annual cost associated with the employee.
     * @return uint256 The annual cost of the employee.
     */
    function getAnnualCost() public virtual returns (uint256);
}
