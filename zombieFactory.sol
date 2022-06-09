pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";
import "./safemath.sol";

// Sets the contract and is required for any new contract.
// Inherits from the Ownable contract - making it to provide specific ownership to specific areas of the DApps
contract ZombieFactory is Ownable {
    //used as a trigger
    event NewZombie(uint zombieId, string name, uint dna);
    
    // Calling safemath on uint 256, 32, 16
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    
    //Unsigned integers and variables
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days; 
    
    /**
        By adding like variables to structs (string 1; string 2; unit 1, unit 2;, uint32 1; unit32 2;) will allow less gas to be used.
        This can be seen in the struct Zombie where level and readyTime are created one after another. 
        Keep in mind that in the case of "Unix Time" one day a 32 bit integer will overflow.
        But if a limit exists like level 1-1000, then it will never hit that integer.
        
        This is done to save gas from executing the contract on the eth blockchain
    **/
    
    //Struct containing a string and uint
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }
   // Creating a publicy accessible array of type Zombie
   Zombie[] public zombies;

    //Mapping to an address (eth) to a uint signialing the owner
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    // Function declaration - requires the type, storage (memory, sotrage), and if the fucntion is accessible to the blockchain (private, public, interal, external)
    function _createZombie(string memory _name, uint _dna) private {
        // pushing the zombie onto the stack and tracking the IDs 
        uint id = zombies.push(Zombie(_name, _dna,1, uint32(now + cooldownTime))) - 1;
        //setting the zombie owner to the eth address msg.sender
        zombieToOwner[id] = msg.sender;
        // adding a coutner to the eth adress for the number of the zombies
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        // Look this up again
        emit NewZombie(id, _name, _dna);
    }
    
    // Function decalres its reutnring a value
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
    // function to create a random zombie, sores name in memory
    function createRandomZombie(string memory _name) public {
        // requires makes the address equal to the zombie owner as a requirement. 
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}//End of Contract  
