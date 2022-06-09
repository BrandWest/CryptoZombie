pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";
//Using safemath that verifies for under/overflows
import "./safemath.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
  //calling safemath for specific datatypes
  using SafeMath for uint256;

  //Maps the ZombieApprovals from a unsigned int to an address
  mapping (uint => address) zombieApprovals;
  
  // This function allows for the balance of an address be accessed (zombies)
  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }
  
  // Using the tokenId, the zombies owner is returned
  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }
  
  // Transfer zombie from one owner to another
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    // .add is used to prevent over/under flows through SafeMath
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].sub(1);
    zombieToOwner[_tokenId] = _to;
    // Trigger the transfer
    emit Transfer(_from, _to, _tokenId);
  }
  
  // Requiring that the owner of the zombie or approval to move the zombie has been provided
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
      require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
      _transfer(_from, _to, _tokenId);
    }

  // approve the zombie transfer
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
      zombieApprovals[_tokenId] = _approved;
      //trigger approval
      emit Approval(msg.sender, _approved, _tokenId);
    }

}
