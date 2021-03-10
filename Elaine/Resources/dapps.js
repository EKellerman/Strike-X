// Change this address to match your deployed contract!
const contract_address = "";

const dApp = {
  ethEnabled: function() {
    // If the browser has MetaMask installed
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      window.ethereum.enable();
      return true;
    }
    return false;
  },
  updateUI: function() {
    const renderItem = (copyright_id, reference_uri, icon_class, {name, description, image}) => `
  
};

dApp.main();