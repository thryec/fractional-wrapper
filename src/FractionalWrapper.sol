// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/yield-utils-v2/contracts/token/IERC20.sol";
import "lib/yield-utils-v2/contracts/token/ERC20Permit.sol";

contract FractionalWrapper is ERC20Permit {
    IERC20 public immutable underlying;
    uint256 internal exchangeRate;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address erc20Address,
        uint256 exchangeRate_
    ) ERC20Permit(name_, symbol_, decimals_) {
        underlying = IERC20(erc20Address);
        exchangeRate = exchangeRate_;
    }
}
