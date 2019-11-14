pragma solidity  ^0.5.0;

contract Main {
    uint constant numOfReviewees = 1;

    uint constant numOfCheckers = 3;

    uint constant numOfAllCheckers = 100;

    string lastCalcTimeStamp;

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
    address adr;
    uint score;
  }

  struct Reviewee {
    string name;
    address adr;
    uint score;
  }

  struct Checker {
    address adrs;
  }

  bool[numOfReviewees][] public graph;

  Checker[] public  checkers;

  mapping (string => Reviewer) nameToReviewer;

  mapping(string => Reviewee) nameToReviewee;

  mapping(string => Review[]) revieweeToReview;

  mapping(string => Review[]) reviewerToReview;

  // constructor
  constructor() public {
    graph = new bool[numOfReviewees][](numOfReviewees);
  }

  event notifyChecker(address indexed adr, string reviewer, uint num);

  event checkDone(string indexed userName, uint num);

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
}