pragma solidity >=0.5.0 <0.7.0;

/**
 * @author Corwin van Dalen
 * @title a contract to create a character for a simple rpg
 */
contract CharacterFactory {
    
    event NewCharacter(uint charId, string name, string class, uint level);
    
    struct Character {
        string name;
        string class;
        uint level;
    }
    
    Character[] public characters;
    
    mapping(uint => address) public characterToOwner;
    
    //Create a new character at level one, gets linked to owner
    function createCharacter(string memory _name, string memory _class) internal {
        uint id = characters.push(Character(_name, _class, 1)) - 1;
        characterToOwner[id] = msg.sender;
        emit NewCharacter(id, _name, _class, 1);
    }
}
