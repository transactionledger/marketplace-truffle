pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    mapping(uint => Product) public products;
    uint public productCount = 0;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Tech University Marketplace";
    }

    function createProduct(string memory _name, uint _price) public {
        require(bytes(_name).length > 0, 'must have a name');
        require(_price > 0, 'price must be greater than 0');

        productCount++;

        //create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);

        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        //we don't want to store this on chain to save costs
        Product memory _product = products[_id];

        address payable _seller = _product.owner;

        require(_product.id > 0 && _product.id <= productCount, 'product id must be valid');
        require(msg.value >= _product.price, 'make sure there is enough ether');
        require(!_product.purchased, 'product must not be purchased');
        require(_seller != msg.sender, 'seller cannot be buyer');

        //transfer ownership to buyer
        _product.owner = msg.sender;
        _product.purchased = true;
        products[_id] = _product;

        //pay the seller by sending them ether
        address(_seller).transfer(msg.value);

        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}