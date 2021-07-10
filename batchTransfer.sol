pragma solidity ^ 0.4.21;

contract Token{

uint256 public totalSupply;

function transfer(address _to, uint256 _value) public returns(bool);

function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

function approve(address _spender, uint256 _value) public;

}

contract A {


function A() public {
    
}



//初始化该合约

uint256 public a;  //创建的合约代币总数

function approve(address _token, address _spender, uint256 _value) public returns (bool success) {
    Token token = Token(_token);
    token.approve(_spender, _value);
    return true;
}


function aTransfer(address _token, address _to, uint256 _value) public returns(bool) {
    Token token = Token(_token);
    token.transferFrom(msg.sender, _to, _value);
}


function bBatchTransfer(address _token, address[] _dsts, uint256[] _values) public payable
{
    Token token = Token(_token);
    for (uint256 i = 0; i < _dsts.length; i++) {
        token.transferFrom(msg.sender, _dsts[i], _values[i]);
    }
}


}


