// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Hourly.sol";

/**
 * @dev The `Salesperson` contract represents an hourly employee with specific hourly rate.
 * It inherits from the `Hourly` contract and passes required arguments to its constructor.
 */
contract Salesperson is Hourly {
    /**
     * @dev Initializes a new Salesperson.
     * @param _idNumber The unique identifier of the salesperson.
     * @param _managerId The unique identifier of the manager of the salesperson.
     * @param _hourlyRate The hourly rate at which the salesperson is paid.
     */
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Hourly(_idNumber, _managerId, _hourlyRate) {}
}
