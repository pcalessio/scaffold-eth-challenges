// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  mapping(address => uint) public balances;
  event Stake(address indexed sender, uint256 value);

  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 30 seconds;
  bool public openForWithdraw = false;

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Build a Staker.sol contract that collects ETH from numerous addresses using a payable stake() 
  // function and keeps track of balances. After some deadline if it has at least some threshold of ETH, 
  // it sends it to an ExampleExternalContract and triggers the complete() action sending the full balance. 
  // If not enough ETH is collected, allow users to withdraw().



  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public  {
    if ( address(this).balance > threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
    }
    if (block.timestamp > deadline && address(this).balance < threshold) {
      openForWithdraw = true;
    }
  }


  // If the `threshold` was not met, allow everyone to call a `withdraw()` function
  // Add a `withdraw()` function to let users withdraw their balance
  function withdraw() public  {

    if (openForWithdraw) {
      if (balances[msg.sender]>0) {
        payable(msg.sender).transfer(balances[msg.sender]);
      }
    }
  }




  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256){
    if (block.timestamp >= deadline) {
      return 0;
    }
    return deadline - block.timestamp;

  }

  // Add the `receive()` special function that receives eth and calls stake()

  receive() external payable {
    stake();
  }
}
