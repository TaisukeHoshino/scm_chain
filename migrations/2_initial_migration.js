var ManufacturersManager = artifacts.require("./ManufacturersManager.sol");

module.exports = function(deployer) {
  deployer.deploy(ManufacturersManager);
};
