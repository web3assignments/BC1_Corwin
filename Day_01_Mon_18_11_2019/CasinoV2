// Load in remix: remix.loadurl("https://github.com/web3examples/ethereum/solidity_examples/Casino.sol")
pragma solidity >=0.5.0 <0.7.0;

/** @author Gerard Persoon, Corwin van Dalen
    @title A simple casino to gamble on a 6 sided dice

contract CasinoV2 {

    event Won(bool win);   // declaring event  
    uint public dice;	     // saves the number picked to roll for
    uint public roll;      // number rolled

    // Setup an intial amount for the bank, supplied during the creation of the contract.    
    constructor() public payable {
    }

    /** Perform the bet and pay out if you win
        @dev several temporary variables are created to make debugging easier
        Need to pick a number before playing
    */
    function betAndWin() public payable returns (bool) { // returning value isn't easy to retreive
        address payable betPlacer = address(msg.sender);
        uint bet = msg.value;
        uint payout = bet * 5;
        uint balance = getBankBalance();    
        require(bet > 0, "No money added to bet.");
        require(payout <= balance, "Not enough money in bank for this bet."); // bet has already been added to bank balance
        roll = getRandom()%6 + 1;
        bool win = bool (roll == dice);
        if (win)
            betPlacer.transfer(payout);        
        emit Won(win);// logging event
        return win;
    }
    
    /** Pick your number from 1 to 6
    */
    function pickNumber(uint dicenumber) public {
        require(dicenumber > 0 && dicenumber < 7, "number must be between 1 and 6.");
        dice = dicenumber;
    }   

    /** Check the balance of the bank
        @return the balance
    */
    function getBankBalance() public view returns(uint256 ret) {
        return address(this).balance;
    }
    
    /** Draw a random number
        @dev this is not secure but only to demonstrate
        @return a pseudo random number
    */
    function getRandom() public view returns(uint256) { 
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.coinbase, block.timestamp)));  
    }    

    /** Deposit more funds for bank
        @dev used when the bank runs out of money
    */
    function () external payable { 
    }
}
      
