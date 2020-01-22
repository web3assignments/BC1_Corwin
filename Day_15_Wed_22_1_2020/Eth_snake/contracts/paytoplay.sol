pragma solidity >=0.5.0 <0.7.0;

/** @author Corwin van Dalen
    @title Pay x amount of eth to start a game of snake
    @dev requires a function for gambling
*/

contract PayToPlay {
    
    function startGame() public payable returns(bool) {
        return true;
    }
    
}