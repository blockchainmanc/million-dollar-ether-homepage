pragma solidity ^0.4.0;
/**
 *
 * Concept:
 *
 * A decentralised smart contract based advertising platform.
 * Based on the early 2000's www.milliondollarhomepage.com
 * The ability to purchase a location of on a piece of web ad space.
 * Payment to be made in ETHER, cost & size defined by contract creator
 *
 * Rules
 * =====
 * Purchase price is 1 pixel = 100000000000000 wei (1000000 [1 million pixel] x 0.001 eth [100000000000000 wei] = 100 ETHER for the full board
 * Original board creator sells first pixel space
 * After purchase owner can re-sell at price of purchase + 0.001 ether per pixel
 * User is allow to upload image against purchase space
 * Smallest space allowed to be purchased is 100 * 100 pixels = 0.1 ether
 *
 * Phase 1
 * =======
 *
 * 1) Construct a advertisement board of 
 *  - $_size pixels in a square (basic typed 2D array)
 *  - $_costPerUnitInWei the initial price in wei? (could be hard coded for first pass)
 * 2) Allow the creator of the board to define a payment address
 * 3) Allow 3rd parties to purchase X number of sections/pixels on the board
 *  - 3rd party can supply a img URL which is placed on the page in the location purchased
 * 4) Construct web app to display the outcome of purchases
 *
 * Phase 2
 * =======
 *
 * Once purchase the owner can then further sell on the pixel space
 * The creator gets all the profits, after initial sale the space is not there's anymore
 * The ability to mange the purchase space - change URL etc
 * 
 * Questions:
 * - Can buys/sells define the resale price - if so how?
 * - how to make payment to addresses?
 * - how to make 2d array
 * - how to validate image size (cloud function?)
 * - web UI
 **/
contract AdvertBoard {

    struct Owner {
        address delegate;
        SpaceLocation location;
    }

    struct SpaceLocation {
        uint8 x;
        uint8 y;
    }

    // TODO how to map 2d array of locations - 1m + 1m

	address private boardCreator; // who creates the initial board (may not be required) / administrator

    int boardSize; // the initial size of the board
    int costPerUnitInWei; // the cost per pixel in wei
    mapping(bytes32 => Owner) owners; // map of address to owners for lookup (needs testing)

    function AdvertBoard(int _boardSize, int _costPerUnitInWei) {
        boardCreator = msg.sender;
        boardSize = _boardSize;
        costPerUnitInWei = _costPerUnitInWei;
    }

	// Accessors

    function purchaseAdSpace(int fromX, int fromY, int size) {
        // TODO return success/failure
        // TODO how to received funds in payment?
    }

    function getBoard() {
        // TODO simply return the current state of the baord
    }

    function transferOwnership(address _purchaser, int _purchasePrice){
        address owner = msg.sender; // whos buying it (the initiator of the transaction)
    }

	// Validators

	modifier isAdmin {
		if (msg.sender != boardCreator) throw;
		_;
	}

}
