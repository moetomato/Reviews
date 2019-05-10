pragma solidity  ^0.5.0;

contract Main {

  uint private shopSize;
  uint private reviewerSize;

  constructor() public {
    shopSize = 0;
    reviewerSize = 0;
  }

 struct Shop {
    uint score;
    string name;
    address owner;
  }

  struct Reviewer {
    uint score;
    string name;
    uint reviewerId;
    address sender;
  }

  struct Review {
    uint score;
    string shopName;
    string reviewerName;
    string comment;
  }

  //name <-> shop
  mapping(string => Shop) private ShopDetails;

  // shop name list
  string[] private shops;

  function addShop(string memory name) public {
    shops.push(name);
    Shop memory s = Shop(0,name,msg.sender);
    ShopDetails[name] = s;
    shopSize++;
  }

  //address <-> reviewer
  mapping(address => Reviewer) private reviewers;

  function addReviewer(string memory name) public {
    Reviewer memory r = Reviewer(0,name,reviewerSize,msg.sender);
    reviewers[msg.sender] = r;
    reviewerSize++;
  }

  function getShopSize() public view returns (uint) {
    return shopSize;
  }

  //shop name <-> review list
  mapping(string => Review[]) reviewMap;

  function addReview(string memory reviewee, uint score, string memory comment) public {
      Reviewer memory reviewer = reviewers[msg.sender];
      Review memory review = Review(score,reviewee,reviewer.name,comment);
      reviewMap[reviewee].push(review);
  }
}