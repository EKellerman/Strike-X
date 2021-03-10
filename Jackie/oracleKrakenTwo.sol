pragma solidity ^0.5.0;

import "@chainlink/contracts/v0.5/ChainlinkClient.sol";

contract KrakenChainlink is ChainlinkClient {
  
  uint256 oraclePayment;
  
  constructor(uint256 _oraclePayment) public {
    setPublicChainlinkToken();
    oraclePayment = _oraclePayment;
  }
  // Additional functions here:
  
}