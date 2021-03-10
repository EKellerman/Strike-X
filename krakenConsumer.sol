pragma solidity ^0.6.0;

import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/evm-contracts/src/v0.6/ChainlinkClient.sol";

/**
 * DO NOT USE IN PRODUCTION!!
 * THIS IS EXAMPLE CONTRACT FOR THE KOVAN TESTNET
 */
contract KrakenConsumer is ChainlinkClient {
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    uint256 public currentPrice;
    
    /**
     * Network: Kovan
     * Chainlink - 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
     * Kraken - 8f4eeda1a8724077a0560ee84eb006b4
     * Fee: 1 LINK
     */
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "8f4eeda1a8724077a0560ee84eb006b4";
        fee = 1 * 10 ** 18; // 1 LINK
    }
    
    function requestPrice() public {
      Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
      req.add("index", "DEFI_KXBTUSD");
      req.addInt("times", 100);
      sendChainlinkRequestTo(oracle, req, fee);
    }
    
    function fulfill(bytes32 _requestId, uint256 _price) public
        recordChainlinkFulfillment(_requestId)
    {
        currentPrice = _price;
    }
}