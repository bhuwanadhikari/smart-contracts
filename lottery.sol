pragma solidity ^0.5.11;

contract Lottery {
    address[] public players; // dynamic array with address of players
    address public manager;
    constructor() public{
        manager = msg.sender; //deployer of contract is msg.sender
    }
    function () external payable {
        require(msg.value >= 0.01 ether);
        players.push(msg.sender); //addr of ether sender is msg.sender
    }
    
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    
    function random() private view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length)))%251);
    } 
    
    //function that selects the winner
    function selectWinner () public  {
        require(msg.sender == manager);
        uint r = random();
        address payable winner;
        winner = address(uint160(players[r % players.length]));
        winner.transfer(address(this).balance); //transfer contract balance to winner
        //reset the players array
        players = new address[](0); // array of length 0
    }
}
