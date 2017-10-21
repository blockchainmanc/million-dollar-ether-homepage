const HumanStandardToken = artifacts.require(`./BasicBoard.sol`);

module.exports = (deployer) => {
    deployer.deploy(HumanStandardToken)
};
