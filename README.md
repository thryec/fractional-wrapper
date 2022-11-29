# Fractional Wrapper

https://github.com/yieldprotocol/mentorship2022/issues/4

## Objectives

1. Users can send a pre-specified ERC-20 token (underlying) to another contract that is also an ERC-20, called Fractional Wrapper.
2. The Fractional Wrapper contract issues a number of Wrapper tokens to the sender equal to the deposit multiplied by a fractional number, called exchange rate, set by the contract owner. This number is in the range of [0, 1000000000000000000], and available in increments of 10\*\*-27.
3. At any point, a holder of Wrapper tokens can burn them to recover an amount of underlying equal to the amount of Wrapper tokens burned, divided by the exchange rate.

## Functions

`deposit()`

`withdraw()`

## References

https://github.com/yieldprotocol/yield-utils-v2/tree/main/contracts/math
https://eips.ethereum.org/EIPS/eip-4626
