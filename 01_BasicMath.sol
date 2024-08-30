// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract BasicMath {
    uint256 constant MAX = type(uint256).max;
    function adder(uint256 _a, uint256 _b) external pure returns (uint256 sum, bool error) {
        if (_a > MAX - _b) {
            return (0, true);
        }

        return (_a + _b, false);

    }

    function subtractor(uint256 _a, uint256 _b) external pure returns (uint256 difference, bool error) {
        if (_b > _a) {
            return (0, true);
        }
        return (_a - _b, false);
    }
    
}