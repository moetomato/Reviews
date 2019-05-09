pragma solidity  ^0.5.0;

contract Main {

  string private _word;
  uint private shopSize;

  constructor() public {
    _word = "Main!";
    shopSize = 0;
  }
  function get() public view returns(string memory){
    return _word;
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
  mapping(string => Shop) Shops;

  uint reviewerSize = 0;

  //address <-> reviewer
  mapping(address => Reviewer) reviewers;

  function addShop(string memory name) public {
    Shop memory s = Shop(0,name,msg.sender);
    Shops[name] = s;
    shopSize++;
  }

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
      Reviewer memory rer = reviewers[msg.sender];
      Review memory review = Review(score,reviewee,rer.name,comment);
      reviewMap[reviewee].push(review);
  }

}