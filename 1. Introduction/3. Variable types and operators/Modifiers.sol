pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract modifiers {
    // public
    uint256 public my_integer = 45;
    string public my_string = "hello";
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    // private
    uint256 private my_private_integer = 10;
    bool private flag = true;

    function test(uint256 _k) public {
        my_private_integer = _k;
    }

    // internal
    bytes32 internal hash = keccak256(abi.encodePacked("hola"));
    address internal my_address = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
}
