
pragma solidity ^0.4.0;

contract MyLandContract
{
    struct Land
    {
        address ownerAddress;
        string location;
        uint cost;
    }
    address owner;
    
    //define who is owner
    function MyLandContract() public
    {
        owner = msg.sender;
    }
    
    //land transfer event
    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    modifier isOwner
    {
        require(msg.sender == owner);
        _;
    }
    
    //one account can hold many lands (many landTokens, each token one land)
    mapping (address => mapping (uint => Land)) private __ownedLands;   

    //1. FIRST OPERATION
    //owner shall add lands via this function
    function addLand(string _location, uint _cost, uint _landID) public isOwner
    {
        __ownedLands[msg.sender][_landID].location = _location;
        __ownedLands[msg.sender][_landID].cost = _cost;
        __ownedLands[msg.sender][_landID].ownerAddress = msg.sender;

    }
    
    
    //2. SECOND OPERATION
    //caller (owner/anyone) to transfer land to buyer provided caller is owner of the land
    function transferLand(address _landBuyer, uint _landID) public returns (bool)
    {
        if (__ownedLands[msg.sender][_landID].ownerAddress == msg.sender) //if caller is owner
        {
            //transfer land
            __ownedLands[_landBuyer][_landID] = __ownedLands[msg.sender][_landID];    
            
            //update ownership
            __ownedLands[_landBuyer][_landID].ownerAddress = _landBuyer;
            
            //delete
            delete __ownedLands[msg.sender][_landID]; 
            
            return true;
        }
        return false;
    }
    
    
    //3. THIRD OPERATION
    //get land details of an account
    function verifyLand(address _landHolder, uint _landID) public returns (string, uint, address)
    {
        return (__ownedLands[_landHolder][_landID].location, 
                __ownedLands[_landHolder][_landID].cost,
                __ownedLands[_landHolder][_landID].ownerAddress);
                
    }
    


}