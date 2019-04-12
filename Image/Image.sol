pragma solidity ^0.5.2;


contract Image{
    
    struct User {
    uint32 coordinateOwned;
    uint balance;
    uint earning;
  }
  
  struct CoordinatorInfo {
    address owner;
    uint price;
  }
  
  struct ImageInfo{
      string imagehex;
      bytes32 coordinator;
  }
  
  uint constant public defaultPrice = 20000000;
  uint8 constant public incrementRate = 35;
  uint8 constant public feeRatio = 25;
  
  
  mapping(address => User) users;
  mapping(bytes32 => CoordinatorInfo) coordinate;
  mapping(address => ImageInfo) image;
   
   
   function updateOwnerInfo(address addr, uint _balance, uint _earning) public {
    User storage user = users[addr];
    user.balance += _balance;
    user.earning += _earning;
  }
  
  function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        assembly {
        result := mload(add(source, 32))
        }
    }
  
  function buyCoordinator(bytes32 coordinator, string memory coimage) public payable returns (uint) {
   
    
    bytes32 input = coordinator;
    
    uint totalSpent = 0;
    uint totalFees = 0;
    uint32 successCount = 0;
    
    User storage u = users[msg.sender];
    bytes32 space = input;
    CoordinatorInfo storage p = coordinate[space];
    if (p.owner == address(0)) {
        if (msg.value < totalSpent + defaultPrice) {
            revert();
        }
        totalSpent += defaultPrice;
        totalFees += defaultPrice;
        p.owner = msg.sender;
        p.price = defaultPrice;
        
        u.coordinateOwned++;
    } else {
        uint increment = p.price * incrementRate / 100; 
        uint newPrice = p.price + increment;
        if (msg.value < totalSpent + newPrice) {
          revert();        
        }
        totalSpent += newPrice;
        totalFees += increment * feeRatio / 100;
        
        uint ownerEarning = increment * (100 - feeRatio) / 100;
        
        updateOwnerInfo(p.owner, p.price + ownerEarning, ownerEarning);
        u.coordinateOwned++;
        p.price = newPrice;
        p.owner = msg.sender;
       
      }
      successCount++;
      
    updateImage(msg.sender, coimage, coordinator);
    
    if (msg.value > totalSpent) {
      u.balance += (msg.value - totalSpent);
    }
    return u.balance;
  }
  
  
  function updateImage(address addr, string memory imagehex, bytes32 coordinator) public  {
    ImageInfo storage img = image[addr];
    img.imagehex = imagehex;
    img.coordinator = coordinator;
  }
  
}


