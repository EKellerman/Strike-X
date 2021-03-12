pragma solidity ^0.5.0;

import "https://github.com/provable-things/ethereum-api/blob/master/provableAPI_0.5.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";


contract StrikeToken is ERC20, ERC20Detailed, usingProvable {
    
    using SafeMath for uint;
    
    address payable owner = msg.sender;
    
    // uint public exchangeRate;
    
    //mapping(address => uint) balances;
    
    uint public ETHUSD;
    uint public ETHCAD;
    
    mapping(bytes32=>bool) validIds;
    
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(uint price);
    event LogNewProvableQuery(string description);
    
    event Bought(uint amount);
    event Sold(uint amount);
    
    constructor() ERC20Detailed("StrikeToken", "STRX", 18) public {
        owner = msg.sender;
    }
    
    function currencyPrice() public payable {
        emit LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Provable Query.");
    }

    function __ethusdCallback(bytes32 myid, uint ethusdResult) public {
        if (!validIds[myid]) revert();
        if (msg.sender != provable_cbAddress()) revert();
        ETHUSD = ethusdResult;
        emit LogPriceUpdated(ETHUSD);
        ethusdUpdatePrice();
    }
    
    function __ethcadCallback(bytes32 myid, uint ethcadResult) public {
        if (!validIds[myid]) revert();
        if (msg.sender != provable_cbAddress()) revert();
        ETHCAD = ethcadResult;
        emit LogPriceUpdated(ETHCAD);
        ethcadUpdatePrice();
    }

    function ethusdUpdatePrice() payable  public {
        if (provable_getPrice("URL") > address(this).balance) {
            emit LogNewProvableQuery("Provable query was NOT sent, please add some ETH to cover for the query fee");
        } 
        
        else {
            emit LogNewProvableQuery("Provable query was sent, standing by for the answer..");
            provable_query(60, "URL", "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price");
        }
    }
    
    function ethcadUpdatePrice() payable  public {
        if (provable_getPrice("URL") > address(this).balance) {
            emit LogNewProvableQuery("Provable query was NOT sent, please add some ETH to cover for the query fee");
        } 
        
        else {
            emit LogNewProvableQuery("Provable query was sent, standing by for the answer..");
            provable_query(60, "URL", "json(https://api.pro.coinbase.com/products/ETH-CAD/ticker).price");
        }
    }
    
    function exchangeRate(uint rate) internal {
        rate == ETHCAD / ETHUSD;  
    }

    function buy() payable public {
        exchangeRate (msg.value);
        // uint amountTobuy = msg.value;
        require (msg.value > 0, "Purchase amount has to be more than zero");
        _mint(msg.sender, msg.value);
    
        emit Bought(msg.value);
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