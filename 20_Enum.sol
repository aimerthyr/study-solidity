// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Enum {

    enum State {
        Start, // 0
        Pending, // 1
        Finish // 2
    }

    State public state;

    function setState(State _state) external  {
        state = _state;
    }

    function setPending() external  {
        state = State.Pending;
    }

    function reset() external  {
        // 枚举的默认值就是第一个枚举值
        delete state;
    }

}