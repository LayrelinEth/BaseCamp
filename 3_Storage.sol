// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract EmployeeStorage {
    uint16 private shares; // Number of shares owned by the employee (private to contract)
    uint32 private salary; // Monthly salary of the employee (private to contract)
    uint256 public idNumber; // Unique identification number of the employee (publicly accessible)
    string public name; // Name of the employee (publicly accessible)

    constructor(uint16 _shares, string memory _name, uint32 _salary, uint _idNumber) {
        shares = _shares; // Initialize shares
        name = _name; // Initialize name
        salary = _salary; // Initialize salary
        idNumber = _idNumber; // Initialize idNumber
    }

    function viewShares() public view returns (uint16) {
        return shares;
    }
    
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    error TooManyShares(uint16 _shares);
    
    function grantShares(uint16 _newShares) public {
        // Check if the requested shares exceed the limit
        if (_newShares > 5000) {
            revert("Too many shares"); // Revert with error message
        } else if (shares + _newShares > 5000) {
            revert TooManyShares(shares + _newShares); // Revert with custom error message
        }
        shares += _newShares; // Grant the new shares
    }

    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000; // Reset shares to 1000
    }
}