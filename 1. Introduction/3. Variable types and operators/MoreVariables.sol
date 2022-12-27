pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract more_variables {
    // string
    string my_first_string;
    string public my_first_string_init = "hello";
    string empty_string = "";

    // boolean
    bool my_first_bool;
    bool public flag_true = true;
    bool public flag_false = false;

    // bytes
    bytes32 my_first_bytes;
    bytes32 public hash = keccak256(abi.encodePacked("hola"));
    bytes4 public identity;

    function testBytes4() public {
        identity = msg.sig;
    }

    // address
    address my_first_address;
    address public my_address = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
}
