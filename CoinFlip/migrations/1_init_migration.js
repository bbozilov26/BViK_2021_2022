var owner = artifacts.require("Owner");
var manager = artifacts.require("Manager");
var safeMath = artifacts.require("SafeMath");
var coinFlip = artifacts.require("CoinFlip");

module.exports = function(deployer) {
    // deployment steps
    deployer.deploy(owner);
    deployer.deploy(manager);
    deployer.deploy(safeMath);
    deployer.deploy(coinFlip);
};