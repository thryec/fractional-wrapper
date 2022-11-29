// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/FractionalWrapper.sol";
import "../src/Token.sol";

contract FractionalWrapperTest is Test {
    FractionalWrapper internal wrapper;
    Token internal underlying;

    address alice;

    function setUp() public virtual {
        underlying = new Token();
        wrapper = new FractionalWrapper(
            "UND",
            "Underlying",
            18,
            address(underlying)
        );
    }
}
