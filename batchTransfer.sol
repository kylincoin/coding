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

function approve(address _spender, uint256 _value) public returns (bool success) {
        TestToken.approve(_spender, _value);
        return true;
    }
    
function aTransfer(address _to, uint256 _value) public returns(bool) {

    TestToken.transferFrom(msg.sender, _to, _value);

}


function bBatchTransfer(address _token, address[] _dsts, uint256[] _values) public payable
{
    Token token = Token(_token);
    for (uint256 i = 0; i < _dsts.length; i++) {
        token.transferFrom(msg.sender, _dsts[i], _values[i]);
    }
}


function aBatchTransfer( address[] _to, uint256[] _value) public returns(bool) {
    
    //   aTransfer(_to[0], _value[0]);
    //   aTransfer(_to[1], _value[1]);

    for(uint i=0; i <= _to.length ; i++){

        aTransfer(_to[i], _value[i]);

    }

  }

}

