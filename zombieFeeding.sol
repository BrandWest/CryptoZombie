pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

//Calling another contract with returns
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

// my contract inheriting via IS keyword from zombieFactory
contract ZombieFeeding is ZombieFactory {
  KittyInterface kittyContract;
  //using onlyOwner modifier to make it so that only the owner can modify the address of the contract
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }
  // The address of the contract we want to call
  //address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // setting the contract to "kittyContract" via the eth address
  //KittyInterface kittyContract = KittyInterface(ckAddress);
  
  // This function creates the cooldown so the zombie can not eat multiple times
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }
  // This function returns if the zombie is ready to eat or not.
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }
  
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
  
    // If statement to create new zombies if a "kitty" is selected
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    // takes the final argument of the kittContract 
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
