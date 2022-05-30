pragma solidity >=0.5.0 <0.6.0;

// Sets the contract and is required for any new contract.
contract ZombieFactory {
    //used as a trigger
    event NewZombie(uint zombieId, string name, uint dna);
    
    //Unsigned integers and variables
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //Struct containing a string and uint
    struct Zombie {
        string name;
        uint dna;
    }
   // Creating a publicy accessible array of type Zombie
   Zombie[] public zombies;

    //Mapping to an address (eth) to a uint signialing the owner
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    // Function declaration - requires the type, storage (memory, sotrage), and if the fucntion is accessible to the blockchain (private, public, interal, external)
    function _createZombie(string memory _name, uint _dna) private {
        // pushing the zombie onto the stack and tracking the IDs 
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        //setting the zombie owner to the eth address msg.sender
        zombieToOwner[id] = msg.sender;
        // adding a coutner to the eth adress for the number of the zombies
        ownerZombieCount[msg.sender]++;
        // Look this up again
        emit NewZombie(id, _name, _dna);
    }
    
    // Functino decalres its reutnring a value
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

}
