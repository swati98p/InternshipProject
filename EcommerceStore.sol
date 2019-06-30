 pragma solidity ^0.5.0;
 contract EcommerceStore{
     enum ProductStatus{Open,Sold,Unsold}
     enum ProductCondition{ NEW,Used}
     uint public productIndex;
     mapping(address => mapping(uint =>Product))stores;
     mapping(uint => address)productIdInStore;
     struct Product{
         uint id;
         string name;
         string category;
         string imagelink;
         string descLink;
         uint auctionsStartTime;
         uint auctionsEndTime;
         uint startPrice;
         address  payable highestBidder;
         uint highestBid;
         uint secondHighestBid;
         uint totalBids;
         ProductStatus status;
         ProductCondition condition;
         mapping (address => mapping (bytes32 => Bid))bids;
     } 
     struct Bid{
       address bidder;
       uint productId;
       uint value;
       bool revealed;
     }
      constructor()public{ 
         productIndex=0;
     }
     function addProductToStore(string memory _name,string memory _category, string memory _imageLink,string memory _descLink, uint _auctionsStartTime,
         uint _auctionsEndTime, uint _startPrice, uint _productCondition)public{
             require(_auctionsStartTime <_auctionsEndTime);
             productIndex += 1;
             Product memory product = Product(productIndex, _name,_category,_imageLink,_descLink, _auctionsStartTime,_auctionsEndTime,_startPrice,address(0),0,0,0, ProductStatus.Open,ProductCondition(_productCondition));
             stores[msg.sender][productIndex]=product;
             productIdInStore[productIndex]=msg.sender;
         }
         function getProduct(uint _productId) view public returns(uint,string memory,string memory,string memory,string memory,uint,uint,uint,ProductStatus,ProductCondition)
         {
             Product memory product=stores[productIdInStore[_productId]][_productId];
             
             return(product.id,product.name,product.category,product.imagelink,product.descLink,product.auctionsStartTime,product.auctionsEndTime,product.startPrice,product.status,product.condition);
         }
         function bid(uint _productId,bytes32 _bid)payable public returns(bool){
             Product storage product =stores[productIdInStore[_productId]][_productId];
             require(now >=product.auctionsStartTime);
             require(now<= product.auctionsEndTime);
             require(msg.value > product.startPrice);
             
             
             require(product.bids[msg.sender][_bid].bidder==address(0));
             product.bids[msg.sender][_bid]=Bid(msg.sender, _productId,msg.value,false);
             product.totalBids +=1;
             return true;
         }
         
      function revealBid(uint _productId,string memory _amount ,string memory _secret)public{
    Product storage product=
    stores[productIdInStore[_productId]][_productId];
    require(now > product.auctionsEndTime);
    bytes32 sealedBid = keccak256(abi.encodePacked(_amount,_secret));
    Bid memory bidInfo=product.bids[msg.sender][sealedBid];
    require(bidInfo.bidder>address(0));
    require(bidInfo.revealed==false);
    uint refund;
    uint amount =stringToUint(_amount);
    if(bidInfo.value<amount){
        refund=bidInfo.value;
        
    }else{
        if(address(product.highestBidder)==address(0)){
            product.highestBidder=msg.sender;
            product.highestBid=amount;
            product.secondHighestBid=product.startPrice;
            refund=bidInfo.value-amount;
        }
        else{
    if(amount>product.highestBid){
        product.secondHighestBid=product.highestBid;
        product.highestBidder.transfer(product.highestBid);
        product.highestBidder=msg.sender;
        product.highestBid=amount;
        refund=bidInfo.value-amount;
    }
    else if(amount>product.secondHighestBid){
        product.secondHighestBid=amount;
        refund=amount;
        
    }
    else{
        refund=amount;
    }
}
}
product.bids[msg.sender][sealedBid].revealed=true;
if(refund>0){
    msg.sender.transfer(refund);
}
}
function highestBidderInfo(uint _productId)view public returns(address,uint,uint){
    Product memory product = stores[productIdInStore[_productId]][_productId];
    return(product.highestBidder, product.highestBid,product.secondHighestBid);
    
}
function totalBids(uint _productId)view public returns(uint){
    Product memory product= stores[productIdInStore[_productId]][_productId];
    return product.totalBids;
}
function stringToUint(string memory s)pure private returns(uint){
    bytes memory b= bytes(s);
    uint result=0;
    for(uint i=0;i<b.length;i++){
        if(uint8(b[i])>=48 && uint8(b[i])<=57){
            result =result*uint256(10)+(uint8(b[i])-48);
        }
    }
    return result;
}
 }
 
 
 
 