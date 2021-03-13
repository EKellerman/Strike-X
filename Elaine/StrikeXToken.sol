pragma solidity ^0.5.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

contract StrikeXToken {
    using SafeMath for uint;
    
    address payable owner = msg.sender;
    string public symbol = "STRX";
    uint public exchangeRate = 1;
    
    mapping(address => uint) balances;
    
    function balance() public view returns(uint){
        return balances[msg.sender];
    }
    
    
    function transfer(address recipient, uint value) public {
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[recipient] = balances[recipient].add(value);
    }
    
    function purchase(uint buyAmount) public payable {
        uint amount = buyAmount.mul(exchangeRate);
        owner.transfer(buyAmount);
        balances[msg.sender] = balances[msg.sender].add(amount);
        
    }
    function mint(address recipient, uint value) public {
        require(msg.sender == owner, "You do not own this token!");
        balances[recipient] = balances[recipient].add(value);
    }
    
}


