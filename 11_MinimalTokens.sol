// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract UnburnableToken {
    string private salt = "value";

    mapping(address => uint256) public balances;

    uint256 public totalSupply; 
    uint256 public totalClaimed; 
    mapping(address => bool) private claimed; 

    error TokensClaimed(); 
    error AllTokensClaimed(); 
    error UnsafeTransfer(address _to); 

    constructor() {
        totalSupply = 100000000; 
    }

    function claim() public {
        if (totalClaimed >= totalSupply) revert AllTokensClaimed();

        if (claimed[msg.sender]) revert TokensClaimed();

        balances[msg.sender] += 1000;
        totalClaimed += 1000;
        claimed[msg.sender] = true;
    }

    function safeTransfer(address _to, uint256 _amount) public {
        if (_to == address(0) || _to.balance == 0) revert UnsafeTransfer(_to);

        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
