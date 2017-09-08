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

	struct Owner {
		uint32 purchaseAtTime;
		uint ownerID;
	}
	mapping(address => Owner) private owners;
	mapping(uint => address) private ownerAddresses;

	struct Area {
		address owner; // who owns that pixel
		uint colour; // the colour hex code
		
		// coordinates
		uint8 fromX;
		uint8 toX;
		uint8 fromY;
		uint8 toY;
	}

	Area[100][100] private areasPurchased;

	// Board Config
	
	address private boardCreator;
	
	// emergency kill switch, disables all future sales
	bool private stopped = false; 
	
	function BasicBoard() {
		// keep a track of the board creator
		boardCreator = msg.sender;

		// create an initial owner for the board creator
		owners[boardCreator].purchaseAtTime = uint32(now);
		owners[boardCreator].ownerID = 0;

		// persist mapping from owner to address
		ownerAddresses[owners[boardCreator].ownerID] = boardCreator;
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
				// TODO assign colour to AREA array			
			}
		}
		return true;
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
