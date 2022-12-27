pragma solidity >=0.7.0 <0.9.0;

contract enums {
    // switch
    enum State {
        ON,
        OFF
    }

    State state;

    function on() public {
        state = State.ON;
    }

    function off() public {
        state = State.OFF;
    }

    function changeState(uint256 _index) public {
        state = State(_index);
    }

    function getState() public view returns (State) {
        return state;
    }
}
