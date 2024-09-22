// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library Convert {
    // 获取最后换算后的美元（并且是18位小数）
    function convertToDollars(uint256 weiAmount) internal view returns (uint256) {
        // chainlink datafeed 合约地址 0x694AA1769357215DE4FAC081bf1f309aDC325306 https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
        AggregatorV3Interface datafeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 answer, , , ) = datafeed.latestRoundData();
        // 获取当前价格的小数位数（举例 假如此时 answer 259777000000， decimals 是 8 那么就代表 1 eth = 2597.77000000 $）
        uint8 decimals = datafeed.decimals();
        // 又因为我们计算都是用 wei 来，所以还需要做一次转换
        /*
            1. 真实过程是 uint(answer) * (10**(18 - decimals) 就代表 1 eth 等于多少美元 并且补充到 18个小数
            2. 需要将wei 变成 eth 所以 weiAmount / 1e18
            3. 但是我们可以先做乘法，所以就是下面的结果
        */
        return (uint256(answer) * (10**(18 - decimals)) * weiAmount) / 1e18;
    }
}
