// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Manager is a contract that represents a manager and keeps track of employee IDs reporting to them
contract Manager {
    uint256[] public employeeIds;

    /**
     * @dev Adds an employee's ID to the list of employees reporting to the manager.
     * @param _idNumber The unique identifier of the employee to be added as a report.
     */
    function addReport(uint256 _idNumber) public {
        employeeIds.push(_idNumber);
    }

    /**
     * @dev Resets the list of employee IDs reporting to the manager, removing all reports.
     */
    function resetReports() public {
        delete employeeIds;
    }
}
