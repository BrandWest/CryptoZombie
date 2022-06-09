pragma solidity >=0.5.0 <0.6.0;

// Imports zombiefeeding.sol
import "./zombiefeeding.sol";

// contract that inherits from ZombieFeeding
contract ZombieHelper is ZombieFeeding {
  // Variable Declaration
  // levelUpFee - cost to level up the zombie
  uint levelUpFee = 0.001 ether;
  
  // modifier to require a level to be greater than a certain _level
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // ability to withdraw a balance
  function withdraw() external onlyOwner {
    address _owner = owner();
    _owner.transfer(address(this).balance);
  }
  
  // a function to set up the level fee, only the owner of the contract can perform this
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }
  
  //performs the level up using the payable modifier
  function levelUp(uint _zombieId) external payable {
    //requires the fee to be paid pulled from the address
    require(msg.value == levelUpFee);
    zombies[_zombieId].level = zombies[_zombieId].level.add(1);
  }

  // change name of the zombie, only the onwer of the zombie can do this, the zombie must be level 2 or higher.
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }
  
  // Change the DNA of the zombie, requires aboveLevel 20 and be the owner of the zombie
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }

  // get the zombies by the owner address, returns a unsigned int to memory
  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      // goes through the zombies the owner has if there is more than 1.
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}// end of contract
