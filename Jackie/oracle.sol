pragma solidity ^0.5.0;

import "https://github.com/provable-things/ethereum-api/blob/master/provableAPI_0.5.sol";

contract eceuPrice is usingProvable {

    string public ETHUSD;
    string public ETHCAD;
    mapping(bytes32=>bool) validIds;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewProvableQuery(string description);

    function currencyPrice() public payable {
        emit LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Provable Query.");
    }

    function __ethusdCallback(bytes32 myid, string memory result) public {
        if (!validIds[myid]) revert();
        if (msg.sender != provable_cbAddress()) revert();
        ETHUSD = result;
        emit LogPriceUpdated(result);
        ethusdUpdatePrice();
    }
    
    function __ethcadCallback(bytes32 myid, string memory result) public {
        if (!validIds[myid]) revert();
        if (msg.sender != provable_cbAddress()) revert();
        ETHCAD = result;
        emit LogPriceUpdated(result);
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

}