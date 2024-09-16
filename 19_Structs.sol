// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Structs {
    struct Car {
        string brand;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;

    function testCar() external {
        // 创建一个结构体的几种方式
        Car memory newCar = Car('bmw',1990, msg.sender);
        Car memory newCar1 = Car({ brand: 'audi', year: 2000, owner: address(10)});
        cars.push(newCar);
        cars.push(newCar1);

        Car storage car1 = cars[0];
        car1.year = 2020;
        delete car1.brand; // car1.brand => ''
        // 那么会把 car 中的三个属性都变成默认值
        delete cars[0]; 
    }


    uint[] public arr = [2,20,3];
    function modifyValueByMemory() external view {
        // 如果是 memory 修饰，那无法修改这个状态变量
        uint[] memory a = arr;
        a[0] = 10;
    }

    function modifyValueByStorage() external  {
        // 如果希望重新赋值去修改状态变量，则必须是 storage
        uint[] storage b = arr;
        b[0] = 20;
    }
}