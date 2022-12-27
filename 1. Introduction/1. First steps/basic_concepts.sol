pragma solidity >=0.7.0 <0.9.0;
import "./ERC20.sol";

contract FirstContract {
    address owner;
    ERC20Basic token;

    constructor() public {
        owner = msg.sender;
        token = new ERC20Basic(1000);
    }
}
