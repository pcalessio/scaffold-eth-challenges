pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
         _mint( msg.sender , 1000 * 10 ** 18);
        // transferFrom(0x4D78f2C1067459e9D0d7dd25CC893db16C59799b, msg.sender, 1000 * 10 ** 18);
    }
}
