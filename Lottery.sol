// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender; // global variable
    }

    receive() external payable { 
        require(msg.value == 1 ether);
        require(msg.sender != manager, "Manager cannot participate in the lottery."); // Optional
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length >= 3);
        
        uint r = random();
        uint idx = r % participants.length;
        address payable winner = participants[idx];
        winner.transfer(getBalance());

        // Reset the participants array
        participants = new address payable[](0) ;
    }
}
