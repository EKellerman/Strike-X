pragma solidity ^0.5.0;

import "dev.oraclize.it/api.sol";

contract KrakenPriceTicker is usingOraclize {
    string public ETHCAD;

    function PriceTicker() {
        oraclize_setNetwork(networkID_testnet);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHCAD).result.XETHXCAD.c.0");
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) throw;
        ETHXBT = result;
        // do something with ETHCAD
    }
} 