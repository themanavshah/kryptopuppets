// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 r = x + y;
        require(r >= x, "SafeMath: Addition overflow!");
        return r;
    }

    function subtract(uint256 x, uint256 y) internal pure returns (uint256) {
        require(x >= y, "SafeMath: Signed assigned to unsigned!");
        uint256 r = x - y;
        return r;
    }

    function multiply(uint256 x, uint256 y) internal pure returns (uint256) {
        if (x == 0) {
            return 0;
        }
        uint256 r = x * y;
        require(r / x == y, "SafeMath: Multiplication overflow!");
        return r;
    }

    function divide(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y > 0, "SafeMath: Divison overflow!");
        uint256 r = x / y;
        return r;
    }

    function modulo(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "SafeMath: modulo error!");
        return x % y;
    }
}
