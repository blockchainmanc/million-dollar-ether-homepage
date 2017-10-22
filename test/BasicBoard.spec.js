const expectThrow = require('./utils').expectThrow;
const BasicBoardContract = artifacts.require('BasicBoard');

contract('BasicBoardContract spec', function (accounts) {

    const ONE_ETHER = 1;

    let BasicBoard;

    beforeEach(async () => {
        BasicBoard = await BasicBoardContract.new({from: accounts[0]})
    });

    it('can purchase co-ordinate', async () => {
        console.log(accounts);

        let details = await BasicBoard.getCoordinateDetails(0, 0);
        console.log("Before", details);

        let purchased = await BasicBoard.purchaseSpace(0, 100, 0, 100, 'red', {
            from: accounts[0], value: ONE_ETHER
        });
        console.log("purchased", purchased);

        details = await BasicBoard.getCoordinateDetails(0, 0);
        console.log("After", details);

    });

    it.skip('can determine co-ordinates are already purchased', async () => {

    });

    it.skip('can determine co-ordinates are out of range', async () => {

    });

});
