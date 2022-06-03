pragma solidity >=0.5.0 <0.6.0;

// Imports zombiefeeding.sol
import "./zombiefeeding.sol";

// contract that inherits from ZombieFeeding
contract ZombieHelper is ZombieFeeding {
  // modifier to require a level to be greater than a certain _level
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

} //End of contract
