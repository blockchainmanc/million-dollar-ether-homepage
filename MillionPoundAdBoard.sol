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

	// RAn owner of a piece of space
	struct Owner {
		uint32 purchaseAtTime;
		uint ownerID;
	}
	mapping(address => Owner) private owners;
	mapping(uint => address) private ownersAddrs;

	// An area of the advert board
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
	bool private stopped = false;// emergency kill switch, disables all future sales

	uint public boardSize = 0;       	// the initial size of the board
	uint public costPerUnitInWei = 0;   // the cost per pixel in wei

	// Constructor - board creation logic
	function AdvertBoard(uint _boardSize, uint _costPerUnitInWei) {
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

	function purchaseAdSpace (uint8 fromX, uint8 toX, uint8 fromY, uint8 toY, string imgUrl)
	public
	payable
		// TODO add fail safe kill switch - only admin can trigger and forces refund etc
		isValidPurchaseSpace(fromX, toX, fromY, toX) // validate purchase
	{
		// TODO return success/failure
		// TODO how to received funds in payment?

		uint totalPurchasePrice = calculatePurchasePrice(fromX, toX, fromY, toX, msg.sender);
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

	function calculatePurchasePrice(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY, address purchaser)
	private
	returns (uint)
	{
		// if the board creator is making a purchase it should be free as they own the board
		if (owners[purchaser].ownerID == 0){
			return 0;
		}

		uint totalAreaPrice;

		// iterate the pixel space
		for (uint8 ix = fromX; ix <= toX; ix++) {
			for (uint8 iy = fromY; iy <= toY; iy++) {
				// add a cost that each pixel
				totalAreaPrice += costPerUnitInWei;
			}
		}

		return totalAreaPrice;
	}

	function isSpaceAlreadyTaken(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY) {
		// TODO check if all pixels are either unowned or owned by the current called
		// current msg.caller can over write pixel space for free
	}

	function toggleContractActive() isBoardAdmin public {
		// You can add an additional modifier that restricts stopping a contract to be based on another action, such as a vote of users
		stopped = !stopped;
	}

	modifier stopInEmergency { 
		if (!stopped) 
		_; 
	}
	modifier onlyInEmergency {
		 if (stopped) 
		 _; 
	}

	// Validators

	modifier isBoardAdmin {
		assert(msg.sender == boardCreator);
		_;
	}

	// Run all validation functions
	function isValidPurchaseSpace(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY) 
		isValidMinSize(fromX, toX, fromY, toX)
		isValidMaxSize(fromX, toX, fromY, toX)
		isSpaceAlreadyTaken(fromX, toX, fromY, toX)
	{
	
	
	}

	// Validate min space is no smaller than 100 x 100 pixels long
	modifier isValidMinSize(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY) {
		uint8 xAxis = fromX * toX;
		uint8 yAxis = fromY * toY;

		assert((xAxis > 100) && (yAxis > 100));
		_;
	}

	// Validate max space is no larger than 1000 x 1000 pixels long
	modifier isValidMaxSize(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY) {
		uint8 xAxis = fromX * toX;
		uint8 yAxis = fromY * toY;

		assert((xAxis < 1000) && (yAxis < 1000));
		_;
	}

}
