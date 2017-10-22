pragma solidity ^0.4.13;


/**
 *
 * Concept:
 *
 * Phase 1
 * =======
 *
 * Create a 2 dimensional  board of 100 x 100 squares
 * Allow a person to purchase a single square and set its colour
 *
 * Phase 2
 * =======
 * Allow a person to purchase a set of squares and set its colour
 *
 **/
contract BasicBoard {

	struct Coordinate {
		uint x;
		uint y;
	}

	struct Owner {
		address owner;  			// owner of pixel
		uint price;     			// price of pixel
		string colour;   			// pixel colour
		uint32 purchasedDateTime; 	// approx time it was purchased
		Coordinate coordinate; 		// the purchased Coordinate
	}

	// Events
	event Purchased(uint fromX, uint toX, uint fromY, uint toY, string colour, address owner);

	/**
	 * Maximum board width
	 */
	uint maxWidth = 1000;

	/**
	 * Maximum board height
     */
	uint maxHeight = 1000;

	/**
	 * The basic board - a X -> Y -> Owner
	 */
	mapping (uint => mapping (uint => Owner)) private board;

	/**
	 *  Who created the board
	 */
	address private boardCreator;

    /**
     *  emergency kill switch, disables all future sales
     */
    bool public stopped = false;

    /**
     *  Board constructor
     */
    function BasicBoard() {
		boardCreator = msg.sender;
	}

	// Accessors

	function purchaseSpace (uint8 fromX, uint8 toX, uint8 fromY, uint8 toY, string colour)
    stopInEmergency
    validateWithinBoardBoundary(fromX, toX, fromY, toY)
	public
    payable
    returns(bool)
	{
        // TODO validate price?
        // TODO how allow owner to sell block?

		// iterate the pixel space
		for (uint8 ix = fromX; ix <= toX; ix++) {
			for (uint8 iy = fromY; iy <= toY; iy++) {

				// Look up the existing area block
                Owner storage existingOwner = board[ix][iy];

				// validate area is available OR is owned by caller
				require(existingOwner.owner == 0 || existingOwner.owner == msg.sender);

				// Set block to colour at location
                board[ix][iy] = Owner({
                    owner: msg.sender,
                    price: msg.value,
                    colour: colour,
                    purchasedDateTime: uint32(now),
                    coordinate: Coordinate({x:ix, y:iy})
                });
			}
		}

        // fire purchased event
		Purchased(fromX, toX, fromY, toY, colour, msg.sender);

		return true;
	}

	/**
	 * Return coordinate details
	 */
	function getCoordinateDetails(uint x, uint y) constant returns (address owner, uint price, string colour, uint32 purchasedDateTime) {
		Owner storage o = board[x][y];
		return (o.owner, o.price, o.colour, o.purchasedDateTime);
    }

    // TODO add function to get all pixels the caller owners

    /**
    * Validator - the kill switch
    */
	function toggleContractActive() isBoardAdmin public {
		stopped = !stopped;
	}

    /**
     * Validator - fails when not the board admin i.e. the creator
     */
	modifier isBoardAdmin {
		assert(msg.sender == boardCreator);
		_;
	}

    /**
     * Validator - fails when area exceeds board boundary
     */
	modifier validateWithinBoardBoundary(uint fromX, uint toX, uint fromY, uint toY) {
		assert(fromX >= 0 && toX <= maxWidth - 1);
		assert(fromY >= 0 && toY <= maxHeight - 1);
		_;
	}

    // kill switch validators

	modifier stopInEmergency {
		require(!stopped);
		 _;
	}

	modifier onlyInEmergency {
		 if (stopped)
		 _;
	}

}
