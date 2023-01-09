// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract DeFiBankKYC{

    address DeFi_RBI; //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

    constructor() {
        DeFi_RBI = msg.sender;
    }

    modifier RBI {
        require(msg.sender == DeFi_RBI, "Decentralized Financial access to RBI record");
        _;
    } 

    struct bankInfo {
        address bankAddress;
        string bankName;
        uint kycCount;
        bool canAddCustomer;
        bool canDoKYC;
    }

    struct customerInfo {
        string cxName;
        string cxID;
        address cxBankAddress;
        bool cxKYCStatus;
    }

    mapping(address => bankInfo) bankDetails;
    mapping(string => customerInfo) customerDetails;

    function addNewBank(
        address _bankAddress, 
        string memory _bankName, 
        uint _kycCount, 
        bool _canAddCustomer, 
        bool _canDoKYC
        ) public RBI {
            bankDetails[_bankAddress].bankAddress = _bankAddress;
            bankDetails[_bankAddress].bankName = _bankName;
            bankDetails[_bankAddress].kycCount = _kycCount;
            bankDetails[_bankAddress].canAddCustomer = _canAddCustomer;
            bankDetails[_bankAddress].canDoKYC = _canDoKYC;
    }

    function addNewCustomerToBank(
        string memory _cxName, 
        string memory _cxID
        ) public {
            require(checkBankHasAddCustomerPermission(msg.sender), "You do not have permission to Add customer");
            customerDetails[_cxName].cxName = _cxName;
            customerDetails[_cxName].cxID = _cxID;
            customerDetails[_cxName].cxBankAddress = msg.sender;
            customerDetails[_cxName].cxKYCStatus = false;
    }

    function checkKycStatus(string memory _cxName) public view returns(bool cxKYCStatus) {
        return customerDetails[_cxName].cxKYCStatus;
    }

    function addNewCustomerRequestForKyc(string memory _cxName, bool _cxKYCStatus) public {
        require(checkBankHasKycPermission(msg.sender), "You do not have Permission for KYC.");
        customerDetails[_cxName].cxKYCStatus = _cxKYCStatus;
        address herebankAddress = customerDetails[_cxName].cxBankAddress;
        
        if(_cxKYCStatus==true){
            bankDetails[herebankAddress].kycCount++;
        } else {
            bankDetails[herebankAddress].kycCount--;
        }
    }

    function allowBankFromAddingNewCustomers(address _bankAddress) public RBI {
        bankDetails[_bankAddress].canAddCustomer = true;
    }

    function blockBankFromAddingNewCustomers(address _bankAddress) public RBI {
        bankDetails[_bankAddress].canAddCustomer = false;
    }

    function allowBankForKyc(address _bankAddress) public RBI {
        bankDetails[_bankAddress].canDoKYC = true;
    }

    function blockBankForKyc(address _bankAddress) public RBI {
        bankDetails[_bankAddress].canDoKYC = false;
    }

    function viewCustomerData(string memory _cxName) public view returns(
        string memory cxName, 
        string memory cxID, 
        address cxBankAddress, 
        bool customerKycStatus
    ) {
        return (
            customerDetails[_cxName].cxName,
            customerDetails[_cxName].cxID,
            customerDetails[_cxName].cxBankAddress,
            customerDetails[_cxName].cxKYCStatus
        );
    }

    function checkBankHasKycPermission(address _bankAddress) public view returns(bool) {
        if(bankDetails[_bankAddress].canDoKYC == true){
            return true;
        } else {
            return false;
        }
    }

    function checkBankHasAddCustomerPermission(address _bankAddress) public view returns(bool) {
        if(bankDetails[_bankAddress].canAddCustomer == true){
            return true;
        } else {
            return false;
        }
    }

}
