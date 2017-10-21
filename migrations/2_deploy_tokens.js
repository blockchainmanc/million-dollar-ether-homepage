const BasicBoard = artifacts.require(`./BasicBoard.sol`);

module.exports = (deployer) => {
    deployer.deploy(BasicBoard)
};
