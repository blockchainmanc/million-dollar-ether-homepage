pragma solidity ^0.4.0;


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

	struct Coordinates {
		uint8 fromX;
		uint8 toX;
		uint8 fromY; 
		uint8 toY;
	}

	struct Owner {
		uint32 purchasedDateTime;
		Coordinates coordinates; // the purchased coordinates
	}

	// a map of address to owner
	mapping(address => Owner) private owners;

	struct Area {
		string colour; // the colour hex code
		address owner; // who owns that pixel
	}	

	// Events
	event Purchased(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY, string colour, address owner);
	event Error(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY, string reason);

	// Board Config
	Area[100][100] public board;

	address private boardCreator;
	
	// emergency kill switch, disables all future sales
	bool public stopped = false; 
	
	function BasicBoard() {
		// keep a track of the board creator
		boardCreator = msg.sender;
	}

	// Accessors

	function purchaseSpace (uint8 fromX, uint8 toX, uint8 fromY, uint8 toY, string colour) 
	stopInEmergency 
	validateArea(fromX, toX, fromY, toY)
	public payable
	returns (bool isPurchased)
	{
		// iterate the pixel space
		for (uint8 ix = fromX; ix <= toX; ix++) {
			for (uint8 iy = fromY; iy <= toY; iy++) {
				
				// Look up the existing area block
				Area storage existingBlock = board[ix][iy];

				// validate area is not owned or is owned by caller
				require(existingBlock.owner == 0 || existingBlock.owner == msg.sender);

				// TODO how to handle changes by block owner ?

				// Set block to colour at location
				board[ix][iy] = Area(colour, msg.sender);

				// Define the coordinates
				// Coordinates memory coordinates = Coordinates(fromX, toX, fromY, toY);

				// simple keep a map of owner to datetime and coordinates
				// owners[msg.sender] = Owner(uint32(now), coordinates);
			}
		}

		Purchased(fromX, toX, fromY, toY, colour, msg.sender);

		return true;
	}

	// Short hand for querying specific coordinate
	function getPixelDetails(uint x, uint8 y) constant returns (string colour, address owner) {   
		Area storage area = board[x][y];
		return (area.colour, area.owner);
    }

	// User can check what space they own
	function getOwner() constant returns (uint32 purchasedDateTime, uint8 fromX, uint8 toX, uint8 fromY, uint8 toY) {   
		// TODO - this feels hacky - any better ways to check if you own any space?
		// TODO - how to handle the same user buy 
		Owner storage owner = owners[msg.sender];
		return (
			owner.purchasedDateTime, 
			owner.coordinates.fromX, 
			owner.coordinates.toX, 
			owner.coordinates.fromY, 
			owner.coordinates.toY
		);
    }

	function toggleContractActive() isBoardAdmin public {
		stopped = !stopped;
	}

	// Validators

	modifier stopInEmergency { 
		require(!stopped);
		 _; 
	}

	modifier onlyInEmergency {
		 if (stopped) 
		 _; 
	}

	modifier isBoardAdmin {
		assert(msg.sender == boardCreator);
		_;
	}

	modifier validateArea(uint8 fromX, uint8 toX, uint8 fromY, uint8 toY) {
		assert(fromX >= 0 && toX <= 99);
		assert(fromY >= 0 && toY <= 99);
		_;
	}

}
