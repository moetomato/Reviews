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
    address owner;
    uint id;
    uint peerReviewNum;
  }

  struct Review {
    uint score;
    string shopName;
    string reviewerName;
    string comment;
  }

  struct Checker {
    uint score;
    address owner;
  }

  //name <-> shop
  mapping(string => Shop) private ShopDetails;

  // shop name list
  string[] public shops;

  function addShop(string memory name) public {
    shops.push(name);
    Shop memory s = Shop(0,name,msg.sender);
    ShopDetails[name] = s;
    shopSize++;
  }

  function getShop(string memory name) public view returns (uint,string memory,address) {
    Shop memory s = ShopDetails[name];
    return (s.score, s.name, s.owner);
  }

  function getShopSize() public view returns (uint) {
    return shopSize;
  }

  //address <-> reviewer
  mapping(address => Reviewer) private reviewers;
  mapping(string => address) private reviewerMap;
  mapping(uint => uint[]) peerReviews;

  function addReviewer(string memory name) public {
    Reviewer memory r = Reviewer(0,name,msg.sender,reviewerSize,0);
    reviewers[msg.sender] = r;
    reviewerMap[name] = msg.sender;
    peerReviews[r.id] = new uint[](100);
    reviewerSize++;
  }

  function getReviewer(address a) public view returns (uint,string memory,address) {
    Reviewer memory r = reviewers[a];
    return (r.score, r.name, r.owner);
  }

  function getReviewerSize() public view returns (uint) {
    return  reviewerSize;
  }

  //shop name <-> review list
  mapping(string => Review[]) reviewMap;

  function addReview(string memory reviewee, uint score, string memory comment) public {
      Reviewer memory reviewer = reviewers[msg.sender];
      Review memory review = Review(score,reviewee,reviewer.name,comment);
      reviewMap[reviewee].push(review);
      updateShopScore(reviewee,score);
  }

  // function getReview(string memory s) public view returns (Review[]) {
  //     //Exception handling
  //     return reviewMap[s];
  // }

  function updateShopScore(string memory s, uint k) public view {
      Shop memory target = ShopDetails[s];
      target.score += k;
  }
  //あとはJS側でなんとかする
  function addPeerReviews(address t) public{
    Reviewer memory target = reviewers[t];
    Reviewer memory reviewer = reviewers[msg.sender];
    reviewer.peerReviewNum++;
    peerReviews[reviewer.id][target.id] = 1;
  }

  function getPeerReviews(uint i) public view returns(uint[] memory){
    return peerReviews[i];
  }

  function updateReviewerScore(string memory r, uint k) public view{
      address ta = reviewerMap[r];
      Reviewer memory target = reviewers[ta];
      target.score = k;
  }

}