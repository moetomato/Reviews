pragma solidity  ^0.5.0;

contract Main {
    uint constant numOfReviewees = 1;

    string lastCalcTimeStamp;

    uint dnaDigits = 16;

    uint dnaModulus = 10 ** dnaDigits;

  struct Review {
      string reviewer;
      uint score;
      string sentence;
      bool[] approvals;
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
    address ads;
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

  function _generateRandomNumber(string memory _str) private view returns (uint) {
      uint rand = uint(keccak256(abi.encode(_str)));
      return rand % dnaModulus;
  }

  // function _addReview(string memory _reviewer, string memory _reviewee, uint _score, string memory _sentence) public {

  // } 
}