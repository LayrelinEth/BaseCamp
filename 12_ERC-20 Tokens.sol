// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    string private salt = "value"; 
    using EnumerableSet for EnumerableSet.AddressSet;

    error TokensClaimed(); 
    error AllTokensClaimed(); 
    error NoTokensHeld(); 
    error QuorumTooHigh(); 
    error AlreadyVoted(); 
    error VotingClosed(); 

    struct Issue {
        EnumerableSet.AddressSet voters; // Set of voters
        string issueDesc; // Description of the issue
        uint256 quorum; // Quorum required to close the issue
        uint256 totalVotes; // Total number of votes casted
        uint256 votesFor; // Total number of votes in favor
        uint256 votesAgainst; // Total number of votes against
        uint256 votesAbstain; // Total number of abstained votes
        bool passed; // Flag indicating if the issue passed
        bool closed; // Flag indicating if the issue is closed
    }

    struct SerializedIssue {
        address[] voters; // Array of voters
        string issueDesc; // Description of the issue
        uint256 quorum; // Quorum required to close the issue
        uint256 totalVotes; // Total number of votes casted
        uint256 votesFor; // Total number of votes in favor
        uint256 votesAgainst; // Total number of votes against
        uint256 votesAbstain; // Total number of abstained votes
        bool passed; // Flag indicating if the issue passed
        bool closed; // Flag indicating if the issue is closed
    }

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    Issue[] internal issues;

    mapping(address => bool) public tokensClaimed;

    uint256 public maxSupply = 1000000; // Maximum supply of tokens
    uint256 public claimAmount = 100; // Amount of tokens to be claimed

    string saltt = "any"; // Another string variable

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        issues.push(); // Pushing an empty issue to start from index 1
    }

    function claim() public {
        // Check if all tokens have been claimed
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed();
        }
        // Check if the caller has already claimed tokens
        if (tokensClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        // Mint tokens to the caller
        _mint(msg.sender, claimAmount);
        tokensClaimed[msg.sender] = true; // Mark tokens as claimed
    }

    function createIssue(string calldata _issueDesc, uint256 _quorum)
        external
        returns (uint256)
    {
        // Check if the caller holds any tokens
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        // Check if the specified quorum is higher than total supply
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh();
        }
        // Create a new issue and return its index
        Issue storage _issue = issues.push();
        _issue.issueDesc = _issueDesc;
        _issue.quorum = _quorum;
        return issues.length - 1;
    }

    function getIssue(uint256 _issueId)
        external
        view
        returns (SerializedIssue memory)
    {
        Issue storage _issue = issues[_issueId];
        return
            SerializedIssue({
                voters: _issue.voters.values(),
                issueDesc: _issue.issueDesc,
                quorum: _issue.quorum,
                totalVotes: _issue.totalVotes,
                votesFor: _issue.votesFor,
                votesAgainst: _issue.votesAgainst,
                votesAbstain: _issue.votesAbstain,
                passed: _issue.passed,
                closed: _issue.closed
            });
    }

    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage _issue = issues[_issueId];
        if (_issue.closed) {
            revert VotingClosed();
        }
        if (_issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 nTokens = balanceOf(msg.sender);
        // Check if the caller holds any tokens
        if (nTokens == 0) {
            revert NoTokensHeld();
        }

        if (_vote == Vote.AGAINST) {
            _issue.votesAgainst += nTokens;
        } else if (_vote == Vote.FOR) {
            _issue.votesFor += nTokens;
        } else {
            _issue.votesAbstain += nTokens;
        }

        _issue.voters.add(msg.sender);
        _issue.totalVotes += nTokens;

        if (_issue.totalVotes >= _issue.quorum) {
            _issue.closed = true;
            if (_issue.votesFor > _issue.votesAgainst) {
                _issue.passed = true;
            }
        }
    }
}