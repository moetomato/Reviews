var review = artifacts.require("./Review.sol")

module.exports = function(deployer) {
    deployer.deploy(review);
};