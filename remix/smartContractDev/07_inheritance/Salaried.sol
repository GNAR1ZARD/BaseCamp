// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Employee.sol";

// Salaried is a contract that represents a salaried employee
contract Salaried is Employee {
    uint256 public annualSalary;

    /**
     * @dev Initializes a new Salaried employee.
     * @param _idNumber The unique identifier of the employee.
     * @param _managerId The unique identifier of the manager of the employee.
     * @param _annualSalary The annual salary of the employee.
     */
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    /**
     * @dev Calculates and returns the annual cost of the salaried employee.
     * @return The annual salary of the employee.
     */
    function getAnnualCost() public view override returns (uint256) {
        return annualSalary;
    }
}
