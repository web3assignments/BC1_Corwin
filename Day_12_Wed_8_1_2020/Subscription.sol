pragma solidity >=0.5.0 <0.7.0;

/** @author Corwin van Dalen
    @title Subscribe to a service
*/

contract Subscription {
    mapping (address => bool) public subscribers;
    
    uint private amountOfSubscribers;
    
    event newSubscriber(address);
    event subscriptionEnded(address);
    
    constructor() public {
        amountOfSubscribers = 0;
    }
    
    function subscribe() public {
        require(!(subscribers[msg.sender]), "This address is already subscribed");
        amountOfSubscribers++;
        subscribers[msg.sender] = true;
        emit newSubscriber(msg.sender);
    }
    
    function unsubscribe() public {
        require(subscribers[msg.sender], "This address isn't subscribed");
        amountOfSubscribers--;
        subscribers[msg.sender] = false;
        emit subscriptionEnded(msg.sender);
    }
    
    function getAmountOfSubscribers() public view returns(uint) {
        return amountOfSubscribers;
    }
    
    function getSubscriptionStatus (address _subID) public view returns(bool){
        if (subscribers[_subID]) {
            return true;
        } else {
            return false;
        }
    }
}
