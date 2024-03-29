// Inheritance Exercise
// Create contracts that adhere to the following specifications.

// Contracts
// Employee
// Create an abstract contract called employee. It should have:

// A public variable storing idNumber
// A public variable storing managerId
// A constructor that accepts arguments for and sets both of these variables
// A virtual function called getAnnualCost that returns a uint
// Salaried
// A contract called Salaried. It should:

// Inherit from Employee
// Have a public variable for annualSalary
// Implement an override function for getAnnualCost that returns annualSalary
// An appropriate constructor that performs any setup, including setting annualSalary
// Hourly
// Implement a contract called Hourly. It should:

// Inherit from Employee
// Have a public variable storing hourlyRate
// Include any other necessary setup and implementation
// TIP
// The annual cost of an hourly employee is their hourly rate * 2080 hours.

// Manager
// Implement a contract called Manager. It should:

// Have a public array storing employee Ids
// Include a function called addReport that can add id numbers to that array
// Include a function called resetReports that can reset that array to empty
// Salesperson
// Implement a contract called Salesperson that inherits from Hourly.

// Engineering Manager
// Implement a contract called EngineeringManager that inherits from Salaried and Manager.

// Deployments
// You'll have to do a more complicated set of deployments for this exercise.

// Deploy your Salesperson and EngineeringManager contracts. Use the following values:

// Salesperson
// Hourly rate is 20 dollars an hour
// Id number is 55555
// Manager Id number is 12345
// Manager
// Annual salary is 200,000
// Id number is 54321
// Manager Id is 11111



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// provided contract via baseCamp exercise 
// "Copy the below contract and deploy it using the addresses of your Salesperson and EngineeringManager contracts."
// deploying Salesperson or EngineeringManager effectively deploys their code and the code of all contracts they inherit from
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}