const expectThrow = require('./utils').expectThrow;
const BasicBoardContract = artifacts.require('BasicBoard');

contract('BasicBoardContract spec', function (accounts) {

    const ONE_WEI = 1;

    let BasicBoard;

    beforeEach(async () => {
        BasicBoard = await BasicBoardContract.new({ from: accounts[ 0 ] });
    });

    it('creation: defaults are set correctly', async () => {
        const maxWidth = await BasicBoard.maxWidth.call();
        assert.strictEqual(maxWidth.toNumber(), 1000);

        const maxHeight = await BasicBoard.maxHeight.call();
        assert.strictEqual(maxHeight.toNumber(), 1000);

        const blockSize = await BasicBoard.blockSize.call();
        assert.strictEqual(blockSize.toNumber(), 10);
    });

    it('can purchase co-ordinate', async () => {
        console.log(accounts);

        let details = await BasicBoard.getCoordinateDetails(0, 1);
        console.log(details);
        validatePixel(details, {
            owner: 0, price: 0, colour: '' // empty response
        });

        // FIXME can only purchase small number of pixels at once
        let purchased = await BasicBoard.purchaseSpace(0, 1, 0, 1, 'red', {
            from: accounts[ 0 ], value: ONE_WEI
        });
        assert(purchased.valueOf());

        details = await BasicBoard.getCoordinateDetails(0, 1);
        validatePixel(details, {
            owner:accounts[0], price: ONE_WEI, colour: "red"
        });
    });

    const validatePixel = (details, { owner, price, colour }) => {
        assert.equal(details[ 0 ], owner, "owner is not correct");
        assert.equal(details[ 1 ], price, "price is not correct");
        assert.equal(details[ 2 ], colour, "colour is not correct");
        // TODO fix date time
    };

});
