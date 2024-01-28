// New Exercise
// For this exercise, we're challenging you to build a solution requiring you to use a number of the concepts you've learned so far. Have fun and enjoy!

// Contracts
// Build a contract that can deploy copies of an address book contract on demand, which allows users to add, remove, and view their contacts.

// You'll need to develop two contracts for this exercise and import at least one additional contract.

// Imported Contracts
// Review the Ownable contract from OpenZeppelin. You'll need to use it to solve this exercise.

// You may wish to use another familiar contract to help with this challenge.

// AddressBook
// Create an Ownable contract called AddressBook. In it include:

// A struct called Contact with properties for:
// id
// firstName
// lastName
// a uint array of phoneNumbers
// Additional storage for contacts
// Any other necessary state variables
// It should include the following functions:

// Add Contact
// The addContact function should be usable only by the owner of the contract. It should take in the necessary arguments to add a given contact's information to contacts.

// Delete Contact
// The deleteContact function should be usable only by the owner and should delete the contact under the supplied _id number.

// If the _id is not found, it should revert with an error called ContactNotFound with the supplied id number.

// Get Contact
// The getContact function returns the contact information of the supplied _id number. It reverts with ContactNotFound if the contact isn't present.

// QUESTION
// For bonus points (that only you will know about), explain why we can't just use the automatically generated getter for contacts?

// Get All Contacts
// The getAllContacts function returns an array with all of the user's current, non-deleted contacts.

// CAUTION
// You shouldn't use onlyOwner for the two get functions. Doing so won't prevent a third party from accessing the information, because all information on the blockchain is public. However, it may give the mistaken impression that information is hidden, which could lead to a security incident.

// AddressBookFactory
// The AddressBookFactory contains one function, deploy. It creates an instance of AddressBook and assigns the caller as the owner of that instance.



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Context is an abstract contract that provides information about the current execution context
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// Ownable is an abstract contract that provides a basic access control 
// It allows an account (the owner) to have exclusive access to specific functions
abstract contract Ownable is Context {
    address private _owner;

    // Custom error messages for access control.
    error OwnableUnauthorizedAccount(address account);
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    // Initializes the contract with the specified initialOwner
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    // Modifier to restrict functions to only the owner
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    // Returns the address of the current owner
    function owner() public view virtual returns (address) {
        return _owner;
    }

    // Internal function to check if the sender is the owner
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    // Renounce ownership of the contract, leaving it without an owner
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    // Transfer ownership of the contract to a new account
    // Can only be called by the current owner
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    // Internal function to transfer ownership to a new account
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// AddressBook is a contract that allows the owner to manage a list of contacts
contract AddressBook is Ownable {
    // Struct to store contact details
    struct Contact {
        uint256 id; // The unique identifier for the contact
        string firstName; // The first name of the contact
        string lastName; // The last name of the contact
        uint256[] phoneNumbers; // An array of phone numbers associated with the contact
    }

    mapping(uint256 => Contact) private contacts; // Mapping from contact ID to contact details
    uint256[] private contactIds; // Array to keep track of all contact IDs for iteration

    // Constructor that sets the deployer as the initial owner
    constructor(address initialOwner) Ownable(initialOwner) {}

    /**
     * @dev Adds a new contact to the address book.
     * @param _id The unique identifier for the contact.
     * @param _firstName The first name of the contact.
     * @param _lastName The last name of the contact.
     * @param _phoneNumbers An array of phone numbers associated with the contact.
     */
    function addContact(
        uint256 _id,
        string memory _firstName,
        string memory _lastName,
        uint256[] memory _phoneNumbers
    ) public onlyOwner {
        require(contacts[_id].id == 0, "Contact ID already exists");
        contacts[_id] = Contact(_id, _firstName, _lastName, _phoneNumbers);
        contactIds.push(_id);
    }

    /**
     * @dev Deletes a contact from the address book.
     * @param _id The unique identifier for the contact to be deleted.
     */
    function deleteContact(uint256 _id) public onlyOwner {
        require(contacts[_id].id != 0, "ContactNotFound");
        delete contacts[_id];

        for (uint256 i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
                break;
            }
        }
    }

    /**
     * @dev Retrieves a contacts information by ID.
     * @param _id The unique identifier of the contact to retrieve.
     * @return Contact The contact's details as a Contact struct.
     */
    function getContact(uint256 _id) public view returns (Contact memory) {
        require(contacts[_id].id != 0, "ContactNotFound");
        return contacts[_id];
    }

    /**
     * @dev Retrieves all contacts in the address book.
     * @return Contact[] An array of all contacts stored in the address book.
     */
    function getAllContacts() public view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);
        for (uint256 i = 0; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }
        return allContacts;
    }
}

// AddressBookFactory is a contract that allows the owner to deploy new AddressBook contracts
contract AddressBookFactory {
    event AddressBookDeployed(address indexed owner, address addressBook);

    /**
     * @dev Deploys a new AddressBook contract and transfers ownership to the caller.
     * @return AddressBook The newly deployed AddressBook contract.
     */
    function deploy() public returns (AddressBook) {
        AddressBook newAddressBook = new AddressBook(msg.sender); // Pass the callers address as the initial owner
        emit AddressBookDeployed(msg.sender, address(newAddressBook));
        return newAddressBook;
    }
}
