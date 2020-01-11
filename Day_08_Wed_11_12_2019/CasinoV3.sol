pragma solidity >=0.5.0 <0.7.0;
import "github.com/provable-things/ethereum-api/provableAPI.sol";

/** @author Corwin van Dalen
    @title Roll 5 dice
    @dev requires a function for gambling
*/

contract CasinoV3 is usingProvable, Ownable{

    uint[5] public rolls;
    bytes public result;
    bytes32 public queryId;
    uint[5] diceModulus = [10 ** 2, 10 ** 6, 10 ** 10, 10 ** 14, 10 ** 20];
    uint temp = 0;

    // Setup an intial amount for the bank, supplied during the creation of the contract.
    constructor() public payable {
        provable_setProof(proofType_Ledger);
    }

    /** Get 5 dice rolls
        @dev was initially done with a for loop, but gas cost too high
        @dev uses a random seed which is cut into 5 parts
    */
    function roll() public {
        temp = uint(queryId) % diceModulus[4];
        getRandom();
        rolls[0] = temp % 6 + 1;
        rolls[1] = (((uint(queryId) - temp) % diceModulus[3]) % 6 + 1);
        temp += uint(queryId) % diceModulus[3];
        rolls[2] = (((uint(queryId) - temp) % diceModulus[2]) % 6 + 1);
        temp += uint(queryId) % diceModulus[2];
        rolls[3] = (((uint(queryId) - temp) % diceModulus[1]) % 6 + 1);
        temp += uint(queryId) % diceModulus[1];
        rolls[4] = (((uint(queryId) - temp) % diceModulus[0]) % 6 + 1);
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

    /** Withdraw funds from the bank, only the owner can do this
    */
    function withdraw(uint amount) external onlyOwner returns(bool) {
        require(amount < this.balance);
        msg.sender.transfer(amount);
        return true;
    }
}