pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";

//Inherit from ZombieHelper
contract ZombieAttack is ZombieHelper {
  // Variable declarations 
  // randNonce - used to encode as a one time used number
  uint randNonce = 0;
  // The probability that a zombie will win its fight.
  uint attackVictoryProbability = 70;
  
  // using the randomNonce, the random modulous is used to encode, and mod the sender, nonce,  and time.
  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }
  
  // zombie attacks another, requires that only the owner of that zombie can do this
  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    // Checks to see if the zombie wins the fight or not.
    if (rand <= attackVictoryProbability) {
      myZombie.winCount = myZombie.winCount.add(1);
      myZombie.level = myZombie.level.add(1);
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      // creates a new zombie using the enemies DNA
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } 
    // else the zombie loses
    else {
      myZombie.lossCount = myZombie.lossCount.add(1);
      enemyZombie.winCount = enemyZombie.winCount.add(1);
      _triggerCooldown(myZombie);
    }
  }
}
