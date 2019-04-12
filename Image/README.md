Tronimage Contract Interfaces

1. Contract Name: SampleImage

2. Constants:
   uint constant public defaultPrice = 20000000;
   uint8 constant public incrementRate = 35;
   uint8 constant public feeRatio = 25;

3. Payable method to buy coordinator space.
	function buyCoordinator(bytes32 ImageToBuy, string memory coimage) public payable returns (uint)

   This method is used to buy coordinator space. It will check whether selected coordinator space has owner or not and will charge accordingly. Finally, the owner information and image information will get update.

4. Update owner information:
   function updateOwnerInfo(address addr, uint _balance, uint _earning) public

   This function will update the coordinator's owner information.

5. Update Image:
   function updateImage(address addr, string memory imagehex, bytes32 coordinator) public

   This function will update image for selected coordinate space.

5. Method for Remix testing purpose. 
   function stringToBytes32(string memory source) public pure returns (bytes32 result)


   
