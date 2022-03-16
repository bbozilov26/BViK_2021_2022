// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

struct Person{
    string firstName;
    string lastName;
}

struct Company{
    string name;
}

struct Mappings{
    mapping (address => Person) peopleAddresses;
    mapping (address => Company) companyAddresses;
}

library Lab3Lib{

    event newPersonEvent(address personAddress, string fName, string lName);
    event newCompanyEvent(address companyAddress, string name);

    function addPerson(Mappings storage self, address personAddr, string memory fName, string memory lName) public{
        self.peopleAddresses[personAddr] = Person(fName, lName);
        emit newPersonEvent(personAddr, fName, lName);
    }

    function addCompany(Mappings storage self, address companyAddr, string memory name) public{
        self.companyAddresses[companyAddr] = Company(name);
        emit newCompanyEvent(companyAddr, name);
    }
}

interface ILab3{
    function addPerson(address personAddress, string memory name, string memory surname) external;
    function addCompany(address companyAddress, string memory name) external;
    function getPerson(address personAddress) external view returns (Person memory);
    function getCompany(address companyAddress) external view returns (Company memory);
}

contract Lab3 is ILab3{

    Mappings maps;

    function addPerson(address personAddr, string memory fName, string memory lName) public override{
        Lab3Lib.addPerson(maps, personAddr, fName, lName);
    }

    function addCompany(address companyAddr, string memory name) public override{
        Lab3Lib.addCompany(maps, companyAddr, name);
    }

    function getPerson(address personAddress) public view override returns (Person memory){
        return maps.peopleAddresses[personAddress];
    }

    function getCompany(address companyAddress) public view override returns (Company memory){
        return maps.companyAddresses[companyAddress];
    }
}