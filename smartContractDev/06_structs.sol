// Structs Exercise
// Create a contract that adheres to the following specifications.

// Contract
// Create a contract called GarageManager. Add the following in storage:

// A public mapping called garage to store a list of Cars (described below), indexed by address
// Add the following types and functions.

// Car Struct
// Implement a struct called Car. It should store the following properties:

// make
// model
// color
// numberOfDoors
// Add Car Garage
// Add a function called addCar that adds a car to the user's collection in the garage. It should:

// Use msg.sender to determine the owner
// Accept arguments for make, model, color, and number of doors, and use those to create a new instance of Car
// Add that Car to the garage under the user's address
// Get All Cars for the Calling User
// Add a function called getMyCars. It should return an array with all of the cars owned by the calling user.

// Get All Cars for Any User
// Add a function called getUserCars. It should return an array with all of the cars for any given address.

// Update Car
// Add a function called updateCar. It should accept a uint for the index of the car to be updated, and arguments for all of the Car types.

// If the sender doesn't have a car at that index, it should revert with a custom error BadCarIndex and the index provided.

// Otherwise, it should update that entry to the new properties.

// Reset My Garage
// Add a public function called resetMyGarage. It should delete the entry in garage for the sender.



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @dev The `GarageManager` contract allows users to manage a collection of cars in their garage.
 * Users can add, update, retrieve, and reset their car collection.
 */
contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    /**
     * @dev Adds a new car to the user's collection in the garage.
     * @param _make The make of the car.
     * @param _model The model of the car.
     * @param _color The color of the car.
     * @param _numberOfDoors The number of doors on the car.
     */
    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint256 _numberOfDoors
    ) public {
        // Create a new Car instance
        Car memory newCar = Car(_make, _model, _color, _numberOfDoors);
        // Add the car to the user's garage using msg.sender as the owners address
        garage[msg.sender].push(newCar);
    }

    /**
     * @dev Gets all cars owned by the calling user.
     * @return Car[] An array of Car structs representing the user's cars.
     */
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    /**
     * @dev Gets all cars for any given address.
     * @param userAddress The address for which to retrieve the cars.
     * @return Car[] An array of Car structs representing the cars owned by the specified address.
     */
    function getUserCars(address userAddress) public view returns (Car[] memory) {
        return garage[userAddress];
    }

    /**
     * @dev Updates a car at a specific index.
     * @param _index The index of the car to update.
     * @param _make The new make of the car.
     * @param _model The new model of the car.
     * @param _color The new color of the car.
     * @param _numberOfDoors The new number of doors on the car.
     */
    function updateCar(
        uint256 _index,
        string memory _make,
        string memory _model,
        string memory _color,
        uint256 _numberOfDoors
    ) public {
        require(_index < garage[msg.sender].length, "BadCarIndex");
        Car storage carToUpdate = garage[msg.sender][_index];
        carToUpdate.make = _make;
        carToUpdate.model = _model;
        carToUpdate.color = _color;
        carToUpdate.numberOfDoors = _numberOfDoors;
    }

    /**
     * @dev Resets the users garage by deleting their car collection.
     */
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
