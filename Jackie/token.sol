pragma solidity ^0.5.0;

import "./oracle.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";

contract StrikeToken is ERC20, ERC20Detailed {
    
    using SafeMath for uint;
    
    address payable owner = msg.sender;
    
    uint public exchangeRate = 1;
    
    //mapping(address => uint) balances;
    
    event Bought(uint amount);
    event Sold(uint amount);
    
    constructor() ERC20Detailed("StrikeToken", "STRX", 18) public {
        owner = msg.sender;
    }
    
    function buy() payable public {
        uint amountTobuy = msg.value;
        require (amountTobuy > 0, "Purchase amount has to be more than zero");
        _mint(msg.sender, amountTobuy);
    
        emit Bought(amountTobuy);
    }
    
    function withdraw(uint amount) internal{
        require (msg.sender == owner);
        require (amount <= address(this).balance);
        owner.transfer(amount);
    }
    
    function sell(uint amountTosell) public {
        require (amountTosell > 0, "Sell amount has to be more than zero");
        
        _burn(msg.sender, amountTosell);
        
        withdraw(amountTosell);
        
        emit Sold(amountTosell);
    }
    
}