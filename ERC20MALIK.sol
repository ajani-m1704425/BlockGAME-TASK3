// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC20/ERC20.sol";



contract Owned{
    address public originalOwner;
    address public newOwner;

    event OwnershipTransfer(address indexed _from, address indexed _to);
    
    constructor() public {
        originalOwner = msg.sender;
    }
    
    function transferOwnership(address _to) public{
        require(msg.sender == originalOwner);
        newOwner = _to;
    }

    function acceptingOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransfer(originalOwner, newOwner);
        originalOwner = newOwner;
        newOwner = address(0);
    }

}

contract Token is ERC20, Owned{
    string public _name;
    string public _symbol;
    uint public _decimal;
    uint public _totalSupply;
    address  public  _minter;
    uint public tokenPrice = 10**15; // 1 token is 0.001ETH i.e 1000 token equals 1ETH

    mapping(address => uint) balances;

    constructor() public {
        _symbol = "MT";
        _name = "Malik Token";
        _decimal = 0;
        _totalSupply = 1000000;
        _minter = 0xB48e1B00c42B7eF57082b927C819882Eb06CF706;

        balances[_minter]=_totalSupply;
        emit Transfer(address(0), _minter, _totalSupply);
    }

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }
    
    function decimals() public view returns (uint){
        return _decimal;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance){
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(balances[_from] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }    

    function transfer(address _to, uint256 _value) public returns (bool success){
        transferFrom(msg.sender, _to, _value);
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success){
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return 0;
    }

    function buyToken( address payable receiver, uint amount) public payable returns (bool){
        require(msg.sender == receiver);
         require(msg.value == amount * tokenPrice, 'Need to send exact amount of ETH');
        balances[receiver] += amount;
        _totalSupply += amount;
        transfer(receiver, amount);
        return true;
    } 


}
