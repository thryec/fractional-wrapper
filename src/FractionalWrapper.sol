// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/yield-utils-v2/contracts/token/IERC20.sol";
import "lib/yield-utils-v2/contracts/token/ERC20Permit.sol";

contract FractionalWrapper is ERC20Permit {
    IERC20 public immutable underlying;
    address immutable _underlyingAddress;
    uint256 immutable maxDeposit;

    uint256 internal constant exchangeRate = 1e27;

    event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);

    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address erc20Address,
        uint256 exchangeRate_
    ) ERC20Permit(name_, symbol_, decimals_) {
        _underlyingAddress = erc20Address;
        underlying = IERC20(erc20Address);
    }

    function deposit(uint assets) public returns (uint shares) {
        uint shares = convertToShares(assets); 
        _mint(msg.sender, shares); 
        emit Deposit(msg.sender, msg.sender, assets, shares); 
    }

    function withdraw(uint shares) public returns (uint assets) {
        uint assets = convertToAssets(shares); 
        _burn(msg.sender, shares);
        underlying.transferFrom(address(this),msg.sender, assets); 
        emit Withdraw(msg.sender, msg.sender, msg.sender, assets, shares); 
    }

    //------------------ View Functions ------------------//

    function convertToShares(uint256 assets)
        public
        view
        virtual
        returns (uint256 shares)
    {}

    function convertToAssets(uint256 shares)
        public
        view
        virtual
        returns (uint256 assets)
    {}

    function asset() public view returns (address underlying) {
        return _underlyingAddress;
    }

    function totalAsset() public view returns (uint256 amount) {
        return underlying.balanceOf(address(this));
    }

    function maxDeposit(address receiver) public view 
}
