// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console2.sol";
import "lib/yield-utils-v2/contracts/token/IERC20.sol";
import "lib/yield-utils-v2/contracts/token/ERC20Permit.sol";
import "lib/solmate/src/utils/FixedPointMathLib.sol";

contract FractionalWrapper is ERC20Permit {
    using FixedPointMathLib for uint256;

    IERC20 public immutable underlying;
    address internal immutable _underlyingAddress;
    uint256 internal _maxDeposit;

    uint256 internal constant exchangeRate = 0.5 * 1e27;

    event Deposit(
        address indexed caller,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );
    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    error InsufficientBalance();
    error TransferFailed();

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address erc20Address
    ) ERC20Permit(name_, symbol_, decimals_) {
        _underlyingAddress = erc20Address;
        underlying = IERC20(erc20Address);
    }

    function deposit(uint256 assets) public returns (uint256 shares) {
        uint256 _shares = convertToShares(assets);
        bool success = _mint(msg.sender, _shares);
        if (!success) {
            revert TransferFailed();
        }
        emit Deposit(msg.sender, msg.sender, assets, _shares);
        return _shares;
    }

    function withdraw(uint256 shares) public returns (uint256 assets) {
        if (this.balanceOf(msg.sender) < shares) {
            {
                revert InsufficientBalance();
            }
        }
        uint256 _assets = convertToAssets(shares);
        _burn(msg.sender, shares);
        bool success = underlying.transferFrom(
            address(this),
            msg.sender,
            _assets
        );
        if (!success) {
            revert TransferFailed();
        }
        emit Withdraw(msg.sender, msg.sender, msg.sender, _assets, shares);
        return _assets;
    }

    //------------------ View Functions ------------------//

    function convertToShares(uint256 assets)
        public
        view
        virtual
        returns (uint256 shares)
    {
        return shares = (assets * exchangeRate) / 1e27;
    }

    function convertToAssets(uint256 _shares)
        public
        view
        virtual
        returns (uint256 assets)
    {
        return _shares.mulDivDown(1e27, exchangeRate);
    }

    function asset() public view returns (address _underlying) {
        return _underlyingAddress;
    }

    function totalAsset() public view returns (uint256 amount) {
        return underlying.balanceOf(address(this));
    }

    function maxDeposit(address receiver) public view {}
}
