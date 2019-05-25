pragma solidity  ^0.5.0;

contract Main {

  uint private shopSize;
  uint private reviewerSize;
  uint private checkerSize;
  uint[][] peerReviews;

  constructor() public {
    shopSize = 0;
    reviewerSize = 0;
    checkerSize = 0;
    peerReviews = new uint[][](10);
    initArray();
  }

  function initArray() public {
    for(uint i = 0; i<10; i++) peerReviews[i] = new uint[](10);
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
    uint id;
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

  //id -> reviewer
  mapping(uint => Reviewer) private reviewers;
  //address -> id
  mapping(address => uint) private idMap;

  function addReviewer(string memory name) public {
    Reviewer memory r = Reviewer(0,name,msg.sender,reviewerSize,0);
    reviewers[reviewerSize] = r;
    idMap[msg.sender] = reviewerSize;
    reviewerSize++;
  }

  function getReviewer(uint a) public view returns (uint,string memory,address) {
    Reviewer memory r = reviewers[a];
    return (r.score, r.name, r.owner);
  }

  function getReviewerSize() public view returns (uint) {
    return  reviewerSize;
  }

  //shop name <-> review list
  mapping(string => Review[]) reviewMap;

  function addReview(string memory reviewee, uint score, string memory comment) public {
    //  checkReview(comment);
      uint id = idMap[msg.sender];
      Reviewer memory reviewer = reviewers[id];
      Review memory review = Review(score,reviewee,reviewer.name,comment);
      reviewMap[reviewee].push(review);
      updateShopScore(reviewee,score);
  }

  // function getReview(string memory s, uint i) public view returns (Review memory) {
  //     //Exception handling
  //     return reviewMap[s][i];
  // }

  function updateShopScore(string memory s, uint k) public view {
      Shop memory target = ShopDetails[s];
      target.score += k;
  }

  function addPeerReviews(uint t) public{
    //get reveiwee's detail
    Reviewer memory target = reviewers[t];
    //get reviewer's detail
    uint id = idMap[msg.sender];
    Reviewer memory reviewer = reviewers[id];
    reviewer.peerReviewNum++;
    peerReviews[target.id][reviewer.id] = 1;
  }

  function getPeerReviews(uint i, uint j) public view returns (uint, uint, uint) {
    return (peerReviews[i][j], i, j);
  }

  function updateReviewerScore(uint i) public {
      uint updatedScore = calcPeerReviewScore();
      reviewers[i].score = updatedScore;
  }

  function calcPeerReviewScore() public pure returns (uint) {
    // Checker memory c1 = selectChecker();
    // Checker memory c2 = selectChecker();
    // Checker memory c3 = selectChecker();
    // それぞれのcheckerに通知
    return 1;
  }

  // function selectChecker() public returns (Checker memory) {
  //   uint i = block.timestamp;
  //   uint random = i % checkerSize;
  //   uint sum = 0;
  //   for(uint j = 0; j < checkerSize; j++){
  //     Checker memory c = checkers[i];
  //     sum += c.score;
  //     if(sum<random) return c;
  //   }
  // }

  Checker[] checkers;
  function addChecker() public {
    Checker memory checker = Checker(1,msg.sender,checkerSize);
    checkers.push(checker);
    checkerSize++;
  }
}