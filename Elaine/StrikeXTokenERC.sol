pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";


contract StrikeXToken is ERC20, ERC20Detailed {
    
    using SafeMath for uint;
    
    address payable owner = msg.sender;
    uint public exchangeRate = 1;
    
    mapping(address => uint) balances;
    
    event Bought(uint amount);
    event Sold(uint amount);

    
    constructor() ERC20Detailed("StrikeTiken", "STRX", 18) public {
        owner = msg.sender;
    }
    
    function buy() payable public {
        uint amountToBuy = msg.value;
        require(amountToBuy > 0, "Purchase amount must be greater than zero");
        _mint(msg.sender, amountToBuy);
        //owner.transfer(amountToBuy);
        //balances[msg.sender] = balances[msg.sender].add(amountToBuy);
        emit Bought(amountToBuy);
    }
    
    function withdraw(uint amount) internal {
        require (msg.sender == owner);
        require (amount <= address(this).balance);
        owner.transfer(amount);
    }
    
    function sell(uint amountTosell) public {
        require(amountTosell > 0, "Sell amount has to be greater than zero");
        
        _burn(msg.sender, amountTosell);
        
        msg.sender.transfer(amountTosell);
        
        withdraw(amountTosell);
        
        emit Sold(amountTosell);
    }

    
}



