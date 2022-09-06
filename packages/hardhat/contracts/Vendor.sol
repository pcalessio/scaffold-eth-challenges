pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);


  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;


  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountOfTokens = tokensPerEth * msg.value;
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
      payable(msg.sender).transfer(address(this).balance);
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public payable {
    uint256 amountOfEther = _amount / tokensPerEth;
    yourToken.transferFrom(msg.sender, address(this), _amount);
    payable(msg.sender).transfer(amountOfEther);
    emit SellTokens(msg.sender, amountOfEther, _amount);
  }

  fallback() external payable {
      // send / transfer (forwards 2300 gas to this fallback function)
      // call (forwards all of the gas)
    }
  receive() external payable {
      // send / transfer (forwards 2300 gas to this fallback function)
      // call (forwards all of the gas)
  }
}
