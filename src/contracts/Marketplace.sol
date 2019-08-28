pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    mapping(uint => Product) public products;
    uint public productCount = 0;

    struct Product {
        uint id;
        string name;
        uint price;
        address owner;
        bool purchased;
    }

    constructor() public {
        name = "Tech University Marketplace";
    }
}