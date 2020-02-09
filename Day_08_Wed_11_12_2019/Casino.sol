pragma solidity >=0.5.0 <0.7.0;
import "github.com/provable-things/ethereum-api/provableAPI.sol";
import "https://github.com/OpenZeppelin/openzeppelin-sdk/blob/master/packages/lib/contracts/Initializable.sol";

/** @author Corwin van Dalen
    @title Roll 5 dice
    @dev requires a function for gambling
*/

contract Casino is usingProvable, Initializable {

    uint[5] public rolls;
    bytes public result;
    bytes32 public queryId;
    uint[5] diceModulus = [10 ** 2, 10 ** 6, 10 ** 10, 10 ** 14, 10 ** 20];
    uint temp = 0;

    // Setup an intial amount for the bank, supplied during the creation of the contract.
    function initialize () initializer public payable {
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

    string public name="Initial";

    function SetName(string memory NewName) public {
        name = NewName;
    }
    function destroy() public  {
        selfdestruct(msg.sender);
    }
    function destroyAndSend(address payable recipient) public  {
        selfdestruct(recipient);
    }    
}

contract Factory {
    bytes mmcode= type(Casino).creationCode;
    Casino public deployedMortal;

    function NameDeployedMortal() public view returns (string memory) {
        return deployedMortal.name();
    }
    function DestroyDeployedMortal() public {
        deployedMortal.destroy();
    }
    function DeployViaCreate() public returns (Casino){
        deployedMortal=Casino(Create(mmcode));
        deployedMortal.SetName("Created via create");
        return deployedMortal;
    }
    function Create(bytes memory code) private returns(address addr) {   
        assembly {
            addr := create(0, add(code, 0x20), mload(code))
            if iszero(extcodesize(addr)) { revert(0, 0) }
        }
    }
    function DeployViaCreate2() public returns (Casino){
        deployedMortal=Casino(Create2(mmcode,0x00));
        deployedMortal.SetName("Created via create2");
        return deployedMortal;
    }
    function Create2(bytes memory code, bytes32 salt) 
        private returns(address addr) {
        assembly {
            addr := create2(0, add(code, 0x20), mload(code), salt)
            if iszero(extcodesize(addr)) { revert(0, 0) }
        }
    }
}
