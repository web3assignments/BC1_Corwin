pragma solidity >=0.4.0 <0.6.0;
      import "remix_tests.sol"; // this import is automatically injected by Remix.
      import "./Subscription.sol";

      // file name has to end with '_test.sol'
      contract Subscription_test {
        
        Subscription sub;

        function beforeAll() public {
          sub = new Subscription();
        }

        function initialSubscriberCountShouldBe0() public returns(bool) {
          Assert.equal(sub.getAmountOfSubscribers(), uint(0), "Initial value is incorrect");
        }

        function initialSubscriberCountShouldNotBeMoreOrLessThan0() public view returns (bool) {
          if (sub.getAmountOfSubscribers() > 0 || sub.getAmountOfSubscribers() < 0) {
              return false; 
          } else {
              return true;
          }
        }
        
        function subscriberAmountShouldBe1() public returns(bool) {
          sub.subscribe();
          Assert.equal(sub.getAmountOfSubscribers(), uint(1), "Value is incorrect");
        }
        
        function senderShouldBeSubscribed() public view returns(bool) {
          if (sub.getSubscriptionStatus(address(this)) == true) {
              return true;
          } else {
              return false;
          }
        }
        
        //address unsubscriber = sub.unsubscribe();
        
        function subscriberCountShouldBe0() public returns(bool) {
          sub.unsubscribe();
          Assert.equal(sub.getAmountOfSubscribers(), uint(0), "Initial value is incorrect");
        }
      }

    
