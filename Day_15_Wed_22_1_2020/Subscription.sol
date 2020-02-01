pragma solidity >=0.5.0 <0.7.0;

/// @author Corwin van Dalen
/// @title Subscribe to a service
/// @dev could implement subscribing and/or payments for a certain amount of time

contract Subscription {
    mapping (address => bool) public subscribers;
    
    uint private amountOfSubscribers;
    
    event newSubscriber(address);
    event subscriptionEnded(address);
    
    constructor() public {
        amountOfSubscribers = 0;
    }
    
    /// @author Corwin van Dalen
    /// @notice subscribes the sender to the contract
    /// @dev the subscriber will be set to true in the subscribers mapping
    function subscribe() public payable returns(bool) {
        require(!(subscribers[msg.sender]), "This address is already subscribed");
        amountOfSubscribers++;
        subscribers[msg.sender] = true;
        emit newSubscriber(msg.sender);
        return true;
    }
    
    /// @author Corwin van Dalen
    /// @notice unsubscribes the sender to the contract
    /// @dev the (ex-)subscriber will be set to false in the subscribers mapping
    function unsubscribe() public returns(bool) {
        require(subscribers[msg.sender], "This address isn't subscribed");
        amountOfSubscribers--;
        subscribers[msg.sender] = false;
        emit subscriptionEnded(msg.sender);
        return true;
    }
    
    /// @author Corwin van Dalen
    /// @notice unsubscribes the sender to the contract
    /// @return the amount of current subscribers
    function getAmountOfSubscribers() public view returns(uint) {
        return amountOfSubscribers;
    }
    
    /// @author Corwin van Dalen
    /// @notice checks if the address is subscribed
    /// @return true if the address is subscribed
    /// @return false if the address is not subscribed
    function getSubscriptionStatus (address _subID) public view returns(bool){
        if (subscribers[_subID]) {
            return true;
        } else {
            return false;
        }
    }
    
    function getAccess() public view returns(bool){
        if(getSubscriptionStatus(msg.sender) == true) {
            return true;
        } else {
            return false;
        }
    }
}