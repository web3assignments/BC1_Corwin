pragma solidity >=0.5.0 <0.7.0;
import "github.com/provable-things/ethereum-api/provableAPI.sol";

/** @author Gerard Persoon, Corwin van Dalen
    @title A simple casino to gamble on a 6 sided dice
    @dev This currently works in the play editor, but not in Remix
*/

contract CasinoV3 is usingProvable{

    event Won(bool win);   // declaring event
    uint public dice;	     // saves the number picked to roll for
    uint public roll;      // number rolled
    bytes public result;
    bytes32 public queryId;

    // Setup an intial amount for the bank, supplied during the creation of the contract.
    constructor() public payable {
        provable_setProof(proofType_Ledger);
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
        getRandom();
        roll = (uint(queryId)%6) + 1;
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

    /** callback for provable function
    */
    function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
        require(msg.sender == provable_cbAddress(), "Nope");
        if (provable_randomDS_proofVerify__returnCode(
            _queryId,_result,_proof) == 0)
        result = bytes(_result);
    }

    /** Draw a random number
    */
    function getRandom() public {
        queryId=provable_newRandomDSQuery(
            0,      // Query_Execution delay
            2,      // Num of Random bytes requested
            200000  // Gas for callback
        );
    }

    /** Deposit more funds for bank
        @dev used when the bank runs out of money
    */
    function () external payable {
    }
}
