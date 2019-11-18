pragma solidity  ^0.5.0;

contract Main {
    uint constant numOfReviewees = 1;

    uint constant numOfCheckers = 3;

    uint constant numOfAllCheckers = 100;

    // 11/17 -> 1117
    uint lastCalcTimeStamp;

  struct Review {
      string reviewer;
      string reviewee;
      uint score;
      string sentence;
      mapping(address => bool) checkerToApproval;
      Checker checker1;
      Checker checker2;
      Checker checker3;
      bool isApproved;
      uint checkCnt;
  }

  struct Reviewer {
    string name;
    address adrs;
    // initiated with 100.
    uint score;
    uint newScore;
  }

  struct Reviewee {
    string name;
    address adrs;
    uint score;
  }

  struct Checker {
    address payable adrs;
  }

  string[] private reviewers;

  mapping(string => bool) reviewerHasPR;
 
  Checker[] public  checkers;

  mapping (string => Reviewer) nameToReviewer;

  mapping(string => Reviewee) nameToReviewee;

  mapping(string => Review[]) revieweeToReview;

  mapping(string => Review[]) reviewerToReview;

  mapping(string => string[]) graph;

  // constructor() public {
  // }

  event notifyChecker(address indexed adr, string reviewer, uint num);

  event checkDone(string indexed userName, uint num);

  function _addReviewer(string memory _name, address _adrs) public {
    Reviewer memory reviewer = Reviewer(_name, _adrs, 100, 0);
    reviewers.push(_name);
    nameToReviewer[_name] = reviewer;
  }

  function _addReviewee(string memory _name, address _adrs) public {
    Reviewee memory reviewee = Reviewee(_name,_adrs, 0);
    nameToReviewee[_name] = reviewee;
  }

  function _addChecker(address payable _adrs) public {
    Checker memory checker = Checker(_adrs);
    checkers.push(checker);
  }

  function _generateRandomNumber(string memory _str) private pure returns (uint) {
      uint rand = uint(keccak256(abi.encode(_str)));
      return rand;
  }

  function _addReview(string memory _reviewer, string memory _reviewee, uint _score, string memory _sentence) public {
    uint num = reviewerToReview[_reviewer].length;
    Checker[] memory selectedCheckers = _selectCheckers(_sentence);
    Review memory review = Review(_reviewer, _reviewee, _score, _sentence, selectedCheckers[0],
                                                        selectedCheckers[1], selectedCheckers[2],false, 0);
    reviewerToReview[_reviewer].push(review);
    emit notifyChecker(selectedCheckers[0].adrs, _reviewer, num);
    emit notifyChecker(selectedCheckers[1].adrs, _reviewer, num);
    emit notifyChecker(selectedCheckers[2].adrs, _reviewer, num);
  }

  function _selectCheckers(string memory _sentence) private view returns (Checker[] memory) {
    Checker[] memory selectedCheckers = new Checker[](3);
    for(uint i = 0; i < 3; i++) {
      uint rand = _generateRandomNumber(_sentence);
      Checker memory checker = checkers[(rand+i)%numOfAllCheckers];
      selectedCheckers[i] = checker;
    }
    return selectedCheckers;
  }

  function _checkReview(string memory _reviewer, uint _num, bool _judgement, address _adrs) public {
    Review storage review = reviewerToReview[_reviewer][_num];
    review.checkerToApproval[_adrs] = _judgement;
    review.checkCnt++;
    if(review.checkCnt == numOfCheckers){
      Checker memory checker1 = review.checker1;
      Checker memory checker2 = review.checker2;
      Checker memory checker3 = review.checker3;
      if(review.checkerToApproval[checker1.adrs] == review.checkerToApproval[checker2.adrs]) review.isApproved = review.checkerToApproval[checker1.adrs];
      else review.isApproved = review.checkerToApproval[checker3.adrs];
      emit checkDone(_reviewer, _num);
    }
  }

  function _addApproviedReview(string memory _reviewer, uint _num) public payable {
    Review storage review = reviewerToReview[_reviewer][_num];
    Reviewee memory reviewee = nameToReviewee[review.reviewee];
    uint numOfReview = revieweeToReview[reviewee.name].length;
    uint newScore = (reviewee.score * numOfReview + review.score) / (numOfReview + 1);
    reviewee.score = newScore;
    revieweeToReview[review.reviewee].push(review);
    if(review.checkerToApproval[review.checker1.adrs] == review.isApproved) _send(review.checker1.adrs, msg.value);
    if(review.checkerToApproval[review.checker2.adrs] == review.isApproved) _send(review.checker2.adrs, msg.value);
    if(review.checkerToApproval[review.checker3.adrs] == review.isApproved) _send(review.checker3.adrs, msg.value);
  }

  function _send(address payable _to, uint amount) public {
    _to.transfer(amount);
  }

  function _addPeerReview(string memory _from, string memory _to, uint _timeStamp) public {
    graph[_from].push(_to);
    reviewerHasPR[_from] = true;
    if(lastCalcTimeStamp != _timeStamp){
      _updateScore();
    }
  }

  function _updateScore() private {
    for(uint i = 0; i < reviewers.length; i++){
      if(reviewerHasPR[reviewers[i]] == false) continue;
      string[] memory rs = graph[reviewers[i]];
      for(uint j = 0; j<rs.length; j++){
        Reviewer storage r2 = nameToReviewer[rs[j]];
        r2.newScore = r2.newScore + nameToReviewer[reviewers[i]].score / rs.length;
      }
    }
    for(uint i = 0; i < reviewers.length; i++){
      Reviewer storage reviewer = nameToReviewer[reviewers[i]];
      reviewer.score = reviewer.newScore;
      reviewer.newScore = 0;
    }
  }
}