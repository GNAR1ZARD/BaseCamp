// ERC-20 Tokens Exercise
// Create a contract that adheres to the following specifications.

// Contract
// Create a contract called WeightedVoting. Add the following:

// A maxSupply of 1,000,000
// Errors for:
// TokensClaimed
// AllTokensClaimed
// NoTokensHeld
// QuorumTooHigh, returning the quorum amount proposed
// AlreadyVoted
// VotingClosed
// A struct called Issue containing:
// An OpenZeppelin Enumerable Set storing addresses called voters
// A string issueDesc
// Storage for the number of votesFor, votesAgainst, votesAbstain, totalVotes, and quorum
// Bools storing if the issue is passed and closed
// An array of Issues called issues
// An enum for Votes containing:
// AGAINST
// FOR
// ABSTAIN
// Anything else needed to complete the tasks
// Add the following functions.

// Constructor
// Initialize the ERC-20 token and burn the zeroeth element of issues.

// Claim
// Add a public function called claim. When called, so long as a number of tokens equalling the maximumSupply have not yet been distributed, any wallet that has not made a claim previously should be able to claim 100 tokens. If a wallet tries to claim a second time, it should revert with TokensClaimed.

// Once all tokens have been claimed, this function should revert with an error AllTokensClaimed.

// CAUTION
// In our simple token, we used totalSupply to mint our tokens up front. The ERC20 implementation we're using also tracks totalSupply, but does it differently.

// Review the docs and code comments to learn how.

// Create Issue
// Implement an external function called createIssue. It should add a new Issue to issues, allowing the user to set the description of the issue, and quorum - which is how many votes are needed to close the issue.

// Only token holders are allowed to create issues, and issues cannot be created that require a quorum greater than the current total number of tokens.

// This function must return the index of the newly-created issue.

// Get Issue
// Add an external function called getIssue that can return all of the data for the issue of the provided _id.

// EnumerableSet has a mapping underneath, so it can't be returned outside of the contract. You'll have to figure something else out.

// HINT
// The return type for this function should be a struct very similar to the one that stores the issues.

// Vote
// Add a public function called vote that accepts an _issueId and the token holder's vote. The function should revert if the issue is closed, or the wallet has already voted on this issue.

// Holders must vote all of their tokens for, against, or abstaining from the issue. This amount should be added to the appropriate member of the issue and the total number of votes collected.

// If this vote takes the total number of votes to or above the quorum for that vote, then:

// The issue should be set so that closed is true
// If there are more votes for than against, set passed to true



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
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

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 */
library EnumerableSet {
    struct Set {
        bytes32[] _values;
        mapping(bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;
            bytes32 lastValue = set._values[lastIndex];

            set._values[toDeleteIndex] = lastValue;
            set._indexes[lastValue] = toDeleteIndex + 1;
            set._values.pop();
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value)
        private
        view
        returns (bool)
    {
        return set._indexes[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index)
        private
        view
        returns (bytes32)
    {
        require(
            set._values.length > index,
            "EnumerableSet: index out of bounds"
        );
        return set._values[index];
    }

    struct Bytes32Set {
        Set _inner;
    }

    function add(Bytes32Set storage set, bytes32 value)
        internal
        returns (bool)
    {
        return _add(set._inner, value);
    }

    function remove(Bytes32Set storage set, bytes32 value)
        internal
        returns (bool)
    {
        return _remove(set._inner, value);
    }

    function contains(Bytes32Set storage set, bytes32 value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, value);
    }

    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(Bytes32Set storage set, uint256 index)
        internal
        view
        returns (bytes32)
    {
        return _at(set._inner, index);
    }

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    function remove(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    function contains(AddressSet storage set, address value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index)
        internal
        view
        returns (address)
    {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    struct UintSet {
        Set _inner;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    function remove(UintSet storage set, uint256 value)
        internal
        returns (bool)
    {
        return _remove(set._inner, bytes32(value));
    }

    function contains(UintSet storage set, uint256 value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, bytes32(value));
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(UintSet storage set, uint256 index)
        internal
        view
        returns (uint256)
    {
        return uint256(_at(set._inner, index));
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

event IssueCreated(uint256 indexed issueId);

/**
 * @title WeightedVoting
 * @dev A smart contract for weighted voting on issues using a simulated ERC20 token system.
 */
contract WeightedVoting is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Maximum token supply allowed for voting
    uint256 public constant maxSupply = 1_000_000 * 1e18;
    uint256 public totalSupply;

    // Custom error messages
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    // Token balance mapping
    mapping(address => uint256) public balances;

    // Enumeration for vote choices
    enum Votes {
        AGAINST,
        FOR,
        ABSTAIN
    }

    // Structure to represent an issue for voting
    struct Issue {
        EnumerableSet.AddressSet voters; // Addresses of voters for this issue
        string issueDesc; // Description of the issue
        uint256 votesFor; // Total votes in favor
        uint256 votesAgainst; // Total votes against
        uint256 votesAbstain; // Total abstain votes
        uint256 totalVotes; // Total number of votes
        uint256 quorum; // Number of votes needed to close the issue
        bool isPassed; // Whether the issue passed
        bool isClosed; // Whether the issue is closed
    }

    // Array to store all issues
    Issue[] private issues;

    /**
     * @dev Constructor to initialize the contract.
     */
    constructor() Ownable(msg.sender) {
        issues.push(); // Burn the zeroeth element of issues
    }

    /**
     * @dev Allows an address to claim tokens for voting.
     * The address should not have claimed tokens before, and there should be tokens available to claim.
     */
    function claim() public {
        uint256 claimAmount = 100 * 1e18;
        if (balances[msg.sender] > 0) revert TokensClaimed();
        if (totalSupply + claimAmount > maxSupply) revert AllTokensClaimed();

        balances[msg.sender] = claimAmount;
        totalSupply += claimAmount;
    }

    /**
     * @dev Creates a new voting issue with a given description and quorum.
     * Only token holders can create issues, and issues cannot be created that require a quorum greater than the current total number of tokens.
     * @param _issueDesc Description of the issue
     * @param _quorum Number of votes needed to close the issue
     * @return The index of the newly created issue
     */
   function createIssue(string memory _issueDesc, uint256 _quorum)
    external
    returns (uint256)
    {
        require(balances[msg.sender] > 0, "NoTokensHeld");
        require(_quorum <= totalSupply, "QuorumTooHigh");

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;

        uint256 issueId = issues.length - 1;
        emit IssueCreated(issueId); // Emit the event with the new issue ID

        return issueId;
    }


    /**
     * @dev Gets information about a specific issue by its ID.
     * @param _id ID of the issue
     * @return issueDesc Description of the issue
     * @return votesFor Total votes in favor
     * @return votesAgainst Total votes against
     * @return votesAbstain Total abstain votes
     * @return totalVotes Total number of votes
     * @return quorum Number of votes needed to close the issue
     * @return isPassed Whether the issue passed
     * @return isClosed Whether the issue is closed
     */
    function getIssue(uint256 _id)
        public
        view
        returns (
            string memory issueDesc,
            uint256 votesFor,
            uint256 votesAgainst,
            uint256 votesAbstain,
            uint256 totalVotes,
            uint256 quorum,
            bool isPassed,
            bool isClosed
        )
    {
        require(_id < issues.length, "Issue does not exist");
        Issue storage issue = issues[_id];

        issueDesc = issue.issueDesc;
        votesFor = issue.votesFor;
        votesAgainst = issue.votesAgainst;
        votesAbstain = issue.votesAbstain;
        totalVotes = issue.totalVotes;
        quorum = issue.quorum;
        isPassed = issue.isPassed;
        isClosed = issue.isClosed;
    }

    /**
     * @dev Allows an address to vote on a specific issue.
     * Holders must vote all of their tokens for, against, or abstaining from the issue.
     * The function reverts if the issue is closed or the wallet has already voted on this issue.
     * @param _issueId ID of the issue to vote on
     * @param _vote The vote choice (AGAINST, FOR, ABSTAIN)
     */
    function vote(uint256 _issueId, Votes _vote) public {
        require(_issueId < issues.length, "Issue does not exist");
        Issue storage issue = issues[_issueId];

        require(!issue.voters.contains(msg.sender), "AlreadyVoted");
        require(!issue.isClosed, "VotingClosed");

        uint256 userBalance = balances[msg.sender];
        require(userBalance > 0, "NoTokensHeld");

        issue.voters.add(msg.sender);

        if (_vote == Votes.FOR) {
            issue.votesFor += userBalance;
        } else if (_vote == Votes.AGAINST) {
            issue.votesAgainst += userBalance;
        } else if (_vote == Votes.ABSTAIN) {
            issue.votesAbstain += userBalance;
        }

        issue.totalVotes += userBalance;

        // If the total votes reach or exceed the quorum, close the issue and set the pass status
        if (issue.totalVotes >= issue.quorum) {
            issue.isClosed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.isPassed = true;
            }
        }
    }
}
