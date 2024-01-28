// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Employee.sol";

// Hourly is a contract that represents an hourly employee and inherits from the Employee contract
contract Hourly is Employee {
    uint256 public hourlyRate;

    /**
     * @dev Initializes an Hourly employee with the provided ID, manager ID, and hourly rate.
     * @param _idNumber The unique identifier for the Hourly employee.
     * @param _managerId The identifier of the Hourly employee's manager.
     * @param _hourlyRate The hourly rate at which the employee is paid.
     */
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    /**
     * @dev Calculates the annual cost of the Hourly employee based on the hourly rate and assuming 2080 working hours in a year.
     * @return The annual cost of employing the Hourly employee.
     */
    function getAnnualCost() public view override returns (uint256) {
        return hourlyRate * 2080;
    }
}
