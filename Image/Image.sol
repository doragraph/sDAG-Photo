pragma solidity ^0.5.2;


contract SampleImage{
    
    struct User {
    uint32 ImageOwned;
    uint balance;
    uint earning;
  }
  
  struct Image {
    address owner;
    uint price;
  }
  
  uint constant public lastStageIncomeThreshold = 10000000000;
  uint32 constant public lastStageDuratio = 28800;
  uint constant public defaultPrice = 20000000;
  uint8 constant public incrementRate = 35;
  uint8 constant public feeRatio = 25;
  
  address public lastPainter;
  
    
  mapping(address => User) users;
  mapping(bytes32 => Image) image;
   
   
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
  
  function buyImageTest(string memory ImageToBuy) public payable returns (uint) {
   
    bytes32 input = stringToBytes32(ImageToBuy);
    
    uint totalSpent = 0;
    uint totalFees = 0;
    uint32 successCount = 0;
    
    User storage u = users[msg.sender];
    bytes32 coordinate = input;
    Image storage p = image[coordinate];
    if (p.owner == address(0)) {
        if (msg.value < totalSpent + defaultPrice) {
            revert();
        }
        totalSpent += defaultPrice;
        totalFees += defaultPrice;
        p.owner = msg.sender;
        p.price = defaultPrice;
	p.coordinate = coordinate;
        u.ImageOwned++;
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
        u.ImageOwned++;
        p.price = newPrice;
        p.owner = msg.sender;
	p.coordinate = coordinate;
      }
      successCount++;
    
    if (msg.value > totalSpent) {
      u.balance += (msg.value - totalSpent);
    }
    return u.balance;
  }
}


