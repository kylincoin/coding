pragma solidity ^ 0.4.21;

contract Token{

uint256 public totalSupply;

function transfer(address _to, uint256 _value) public returns(bool);

function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

function approve(address _spender, uint256 _value) public;

}

contract A {

Token TestToken;

function A(address contractAddress) public {

TestToken = Token(contractAddress);

}

//初始化该合约

uint256 public a;  //创建的合约代币总数

function aTransfer( address[] _to, uint256[] _value) public returns(bool) {

    for(uint i=0; i <= _to.length ; i++){

        TestToken.transferFrom(msg.sender, _to[i], _value[i]);

    }

  }

}

