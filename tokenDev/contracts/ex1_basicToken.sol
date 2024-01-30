// Minimal Tokens Exercise
// Create a contract that adheres to the following specifications.

// Contract
// Create a contract called UnburnableToken. Add the following in storage:

// A public mapping called balances to store how many tokens are owned by each address
// A public uint to hold totalSupply
// A public uint to hold totalClaimed
// Other variables as necessary to complete the task
// Add the following functions.

// Constructor
// Add a constructor that sets the total supply of tokens to 100,000,000.

// Claim
// Add a public function called claim. When called, so long as a number of tokens equalling the totalSupply have not yet been distributed, any wallet that has not made a claim previously should be able to claim 1000 tokens. If a wallet tries to claim a second time, it should revert with TokensClaimed.

// The totalClaimed should be incremented by the claim amount.

// Once all tokens have been claimed, this function should revert with an error AllTokensClaimed. (We won't be able to test this, but you'll know if it's there!)

// Safe Transfer
// Implement a public function called safeTransfer that accepts an address _to and an _amount. It should transfer tokens from the sender to the _to address, only if:

// That address is not the zero address
// That address has a balance of greater than zero Base Goerli Eth
// A failure of either of these checks should result in a revert with an UnsafeTransfer error, containing the address.



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UnburnableToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 100000000; // Total supply of tokens
    uint256 public totalClaimed; // Total tokens that have been claimed

    // Define custom errors
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address to);

    /**
     * @dev Claims 1000 tokens for the sender if they haven't claimed before and if tokens are still available.
     */
    function claim() public {
        if (totalClaimed + 1000 > totalSupply) revert AllTokensClaimed();
        if (balances[msg.sender] > 0) revert TokensClaimed();

        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    /**
     * @dev Transfers `_amount` tokens from the caller's address to address `_to`.
     * Reverts if `_to` is the zero address or if `_to` does not have a Goerli ETH balance.
     * @param _to The recipient address.
     * @param _amount The number of tokens to transfer.
     */
    function safeTransfer(address _to, uint256 _amount) public {
        if (_to == address(0) || !hasGoerliETH(_to)) revert UnsafeTransfer(_to);
        if (balances[msg.sender] < _amount) revert UnsafeTransfer(msg.sender);

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    /**
     * @dev Checks if an address has a Goerli ETH balance.
     * @param _address The address to check for a Goerli ETH balance.
     * @return True if the address has Goerli ETH, false otherwise.
     */
   function hasGoerliETH(address _address) public view returns (bool) {
        return _address.balance > 0;
    }
}

