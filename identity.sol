pragma solidity ^0.4.11;

contract Identity {
    address public owner;
    string public guid;

    string private firstName;
    string private lastName;
    string private email;
    string private phone;
    uint16 private birthYear;
    uint8 private birthMonth;
    uint8 private birthDay;

    mapping (address => uint8) private acl;

    // constants to represent fields in acl

    uint8 constant FIRST_NAME = 0;
    uint8 constant LAST_NAME = 1;
    uint8 constant EMAIL = 2;
    uint8 constant PHONE = 3;
    uint8 constant BIRTHDAY = 4;

    // TODO: replace with real AppInMail account address
    address constant APP_IN_MAIL = 0x123;

    // constructor

    function Identity(string _guid, string _firstName, string _lastName,
                      string _email, string _phone, uint16 _birthYear,
                      uint8 _birthMonth, uint8 _birthDay) {
        owner = msg.sender;
        guid = _guid;
        firstName = _firstName;
        lastName = _lastName;
        email = _email;
        phone = _phone;
        birthYear = _birthYear;
        birthMonth = _birthMonth;
        birthDay = _birthDay;
        // add AppInMail account address to acl with value 0xFF - grant
        // read access to all fields
        acl[APP_IN_MAIL] = 0xFF;
    }

    // acl checker

    function getAccess(address addr, uint8 field) returns (bool) {
        if (addr == owner)
            return true;
        uint8 rights = acl[addr];
        return (rights & (1 << field)) != 0;
    }

    function canRead(uint8 field) private returns (bool) {
        return getAccess(msg.sender, field);
    }

    // add or remove access - only owner is alowed to do it

    function grantAccess(address addr, uint8 field) {
        if (msg.sender == owner && addr != owner) {
            uint8 rights = acl[addr];
            rights = rights | (1 << field);
            acl[addr] = rights;
        }
    }

    function revokeAccess(address addr, uint8 field) {
        if (msg.sender == owner && addr != owner) {
            uint8 rights = acl[addr];
            rights = rights & ~(1 << field);
            acl[addr] = rights;
        }
    }

    // getter methods
    // those who are explicitly allowed by acl plus owner and special
    // AppInMail account can read fields

    function getFirstName() returns (string) {
        if (canRead(FIRST_NAME))
            return firstName;
    }

    function getLastName() returns (string) {
        if (canRead(LAST_NAME))
            return lastName;
    }

    function getEmail() returns (string) {
        if (canRead(EMAIL))
            return email;
    }

    function getPhone() returns (string) {
        if (canRead(PHONE))
            return phone;
    }

    function getBirthday() returns (uint16 year, uint8 month, uint8 day) {
        if (canRead(BIRTHDAY))
            return (birthYear, birthMonth, birthDay);
    }

    // setter methods - only owner can change private fields

    function setFirstName(string _firstName) {
        if (msg.sender == owner)
            firstName = _firstName;
    }

    function setLastName(string _lastName) {
        if (msg.sender == owner)
            lastName = _lastName;
    }

    function setEmail(string _email) {
        if (msg.sender == owner)
            email = _email;
    }

    function setPhone(string _phone) {
        if (msg.sender == owner)
            phone = _phone;
    }

    function setBirthday(uint16 _year, uint8 _month, uint8 _day) {
        if (msg.sender == owner) {
            birthYear = _year;
            birthMonth = _month;
            birthDay = _day;
        }
    }

}
