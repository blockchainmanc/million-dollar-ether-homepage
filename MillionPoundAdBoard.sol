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
 * Rules - https://etherconverter.online/
 * =====
 * Purchase price is 1 pixel = 100000000000000 wei (1000000 [1 million pixel] x 0.001 eth [100000000000000 wei] = 100 ETHER for the full board
 * Original board creator sells first pixel space
 * After purchase owner can re-sell at price of purchase + 0.001 ether per pixel
 * User is allow to upload image against purchase space
 * Smallest space allowed to be purchased is 100 * 100 pixels = 0.1 ether
 * Largest space allowed to be purchased is 1000 * 1000 pixels = 1 ether
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
		uint32 purchaseAtTime;
		uint ownerID;
	}
	mapping(address => Owner) private owners;
	mapping(uint => address) private ownersAddrs;

	struct Area {
		address owner;		// the owner of this area
		uint imageID;		// the image backing this purchase
		uint purchaseSize;	// the total size purchased (should this live on Image?)
		uint salePrice;		// the total sale price for this area
		// TODO record max resale price at this point?
	}

	// purchased areas (check size requirements)
	Area[1000][1000] private areasPurchased;

	// The advert
	struct Image {
		// coordinates
		uint8 fromX;
		uint8 toX;
		uint8 fromY;
		uint8 toY;

		// images details
		string imageUrl;
		string imageLink;
		string altText;
	}

	// image DB
	mapping (uint => Image) private images;

	// Board Config
	address private boardCreator;		// board creator / administrator
	bool private contractKilled = false;// emergency kill switch, disables all future sales

	uint public boardSize = 0;       	// the initial size of the board
	uint public costPerUnitInWei = 0;   // the cost per pixel in wei

	// Constructor - board creation logic
	function AdvertBoard(int _boardSize, int _costPerUnitInWei) {
		// keep a track of the board creator
		boardCreator = msg.sender;

		// configure the board
		boardSize = _boardSize;
		costPerUnitInWei = _costPerUnitInWei;

		// create an initial owner for the board creator
		owners[boardCreator].purchaseAtTime = uint32(now);
		owners[boardCreator].ownerID = 0;

		// persist mapping from owner to address
		ownersAddrs[owners[boardCreator].ownerID] = boardCreator;
	}

	// Accessors

	function purchaseAdSpace(int fromX, int fromY, int size, string imgUrl) {
		// TODO return success/failure
		// TODO how to received funds in payment?
		isValidPurchaseSpace();
	}

	function getBoard() {
		// TODO simply return the current state of the baord
	}

	function transferOwnership(address _purchaser, int _purchasePrice, string imgUrl){
		address owner = msg.sender;
		// whos buying it (the initiator of the transaction)
	}


	function updateImgUrl(string imgUrl){
		address owner = msg.sender;
		// TODO is this chargeable
	}

	function getAdvertSpacePrice() {
		// TODO calculate and return price with some meta data
	}

	function calculateTotalSpaceRequired(int fromX, int fromY, int size) {

	}

	function isSpaceAlreadyTaken() {

	}

	// Validators

	modifier isBoardAdmin {
		if (msg.sender != boardCreator) throw;
		_;
	}

	modifier isValidPurchaseSpace {
		isValidMinSize();
		isValidMaxSize();
		// TODO space not already take
	}

	modifier isValidMinSize() {
		// TODO space not < 100 * 100 pixels
	}

	modifier isValidMaxSize() {
		// TODO space not > 1000 * 1000 pixels
	}


	// If something goes wrongs stop immediately!
	modifier killSwitch {
		if (msg.sender != admin) {
			if (contractKilled) throw;
		}
		_;
	}
}
