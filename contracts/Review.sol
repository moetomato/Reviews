pragma solidity ^0.5.0;


contract Review {

  struct Shop {
    uint8 score;
    string name;
    uint shopId;
  }

  uint shopSize = 0;

  //Id <-> shop
  mapping(uint => Shop) Shops;
  //shop <-> review list
  // mapping(uint => string[]) reviewMap; 

  function addShop(string memory name) public {
      Shop memory s = Shop(0,name,shopSize);
      Shops[shopSize] = s;
      shopSize++;
  }
}
