// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Salaried.sol";
import "./Manager.sol";

// EngineeringManager inherits from both Salaried and Manager contracts
contract EngineeringManager is Salaried, Manager {
    /**
     * @dev Initializes an Engineering Manager with the provided ID, manager ID, and annual salary.
     * @param _idNumber The unique identifier for the Engineering Manager.
     * @param _managerId The identifier of the Engineering Manager's manager.
     * @param _annualSalary The annual salary of the Engineering Manager.
     */
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Salaried(_idNumber, _managerId, _annualSalary) {} // init list that calls the Salaried constructor
}
