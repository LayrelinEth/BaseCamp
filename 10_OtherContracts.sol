// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "./10_AddressBook.sol";

contract AddressBookFactory {
    string private salt = "value";

    function deploy() external returns (AddressBook) {
        AddressBook newAddressBook = new AddressBook();
        newAddressBook.transferOwnership(msg.sender);
        return newAddressBook;
    }
}
