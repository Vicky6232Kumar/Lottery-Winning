# Lottery Smart Contract on Ethereum

This project implements a simple lottery game using a smart contract on the Ethereum blockchain. The smart contract is written in Solidity and allows participants to enter the lottery by sending 1 ether to the contract. Once a minimum of three participants has entered, the contract owner (manager) can select a random winner, who will receive the entire balance of the contract.

## Features

- **Decentralized Lottery**: The lottery is run entirely on the Ethereum blockchain, ensuring transparency and security.
- **Random Winner Selection**: A pseudo-random number generator is used to select a winner from the pool of participants.
- **Simple Participation**: Anyone can enter the lottery by sending exactly 1 ether to the contract address.
- **Manager Control**: Only the manager (the contract deployer) can trigger the winner selection process.
- **Automatic Funds Transfer**: The winner's address is automatically credited with the entire balance of the contract.

## How It Works

1. **Manager Initialization**: The contract is deployed by a manager who controls the lottery.
2. **Participants Enter**: Participants join the lottery by sending 1 ether to the contract.
3. **Winner Selection**: Once there are at least three participants, the manager can call the `selectWinner` function to pick a winner.
4. **Prize Distribution**: The winner is selected using a pseudo-random number generator, and the entire balance of the contract is transferred to the winner's address.
5. **Reset**: After the winner is selected and the prize is distributed, the lottery resets, and new participants can join.

## Prerequisites

- **Solidity**: The smart contract is written in Solidity, so you'll need to be familiar with this language.
- **Ethereum Wallet**: Participants must have an Ethereum wallet with at least 1 ether to participate.
- **Ethereum Network**: The contract can be deployed on the Ethereum mainnet or any Ethereum testnet (e.g., Rinkeby, Ropsten).

## Contract Overview

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable { 
        require(msg.value == 1 ether, "Must send exactly 1 ether");
        require(msg.sender != manager, "Manager cannot participate in the lottery");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "Only manager can check balance");
        return address(this).balance;
    }

    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager, "Only manager can select winner");
        require(participants.length >= 3, "At least 3 participants required");
        
        uint r = random();
        uint idx = r % participants.length;
        address payable winner = participants[idx];
        winner.transfer(getBalance());

        // Reset the participants array
        participants = new address payable ;
    }
}
