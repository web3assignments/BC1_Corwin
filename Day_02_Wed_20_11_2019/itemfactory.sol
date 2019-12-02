pragma solidity >=0.5.0 <0.7.0;
/**
 * @author Corwin van Dalen
 * @title add items to the game.
 */
contract ItemFactory{
    event NewItem(uint itemId, string itemType, uint itemStats);
    
    struct Item {
        uint itemId;
        string itemType;
        uint itemStats;
    }
    
    Item[] public items;
    
    mapping (string => uint) typeToId;
    
    //Create a new item, every unique item can only be added a single time.
    function createItem(uint _itemId, string memory _itemType, uint _itemStats) internal {
        require(_itemId != typeToId[_itemType]);
        items.push(Item(_itemId, _itemType, _itemStats));
        typeToId[_itemType] = _itemId;
        emit NewItem(_itemId, _itemType, _itemStats);
    }
}
