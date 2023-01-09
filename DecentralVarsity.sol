# soldidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Decentralvarsity{

    address public collegeHead; 

    constructor() {
        collegeHead = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == collegeHead, "Only access to College Admin");
        _;
    }

    struct list_of_College_Record {
        string college_Name;
        address college_Address;
        string college_Admin;
        string college_Code;
        bool canAddNewStudent;
        uint totalStudent;
    }

    struct student_record {
        string sName;
        address addr;
        uint256 Mobile_No;
        string courseName;
    }
    mapping(address => list_of_College_Record) CollegeRecord;
    mapping(string => student_record) studentRecord;

    function add_New_College(
        string memory _college_Name,
        address _college_Address,
        string memory _college_Admin,
        string memory _college_Code,
        bool _canAddNewStudent
        ) public onlyAdmin{
            CollegeRecord[_college_Address].college_Address = _college_Address;
            CollegeRecord[_college_Address].college_Name = _college_Name;
            CollegeRecord[_college_Address].college_Admin = _college_Admin;
            CollegeRecord[_college_Address].college_Code = _college_Code;
            CollegeRecord[_college_Address].canAddNewStudent = _canAddNewStudent;
            CollegeRecord[_college_Address].totalStudent = 0;
        }
    function add_New_Student_To_College(
        address _addr,
        string memory _sName, 
        uint256 _Mobile_No,
        string memory _courseName
        ) public{
            studentRecord[_sName].addr = _addr;
            studentRecord[_sName].sName = _sName;
            studentRecord[_sName].Mobile_No = _Mobile_No;
            studentRecord[_sName].courseName = _courseName;
            CollegeRecord[msg.sender].totalStudent++;
            }

      function blockCollegeToAddNewStudents(address _college_Address) public onlyAdmin {
        CollegeRecord[_college_Address].canAddNewStudent = false;
    }

       function unblockCollegeToAddNewStudents(address _college_Address) public onlyAdmin {
        CollegeRecord[_college_Address].canAddNewStudent = true;
    }

        function change_Student_Course(
        string memory _sName, 
        string memory New_course) public {
            studentRecord[_sName].courseName = New_course;
    }

    function getNumberofStudentforCollege(address _college_Address) public view returns (uint) {
        return CollegeRecord[_college_Address].totalStudent;
    }

    function viewStudentDetails(string memory _sName) public view returns (
        address addr,
        string memory sName,
        uint256 Mobile_No,
        string memory courseName
    )
         {  
             return
            (
            studentRecord[_sName].addr,
            studentRecord[_sName].sName,
            studentRecord[_sName].Mobile_No,
            studentRecord[_sName].courseName
        );
    }

    function viewCollegeDetails(address _college_Address) public view returns (
        string memory college_Name,
        address college_Address,
        string memory college_Admin,
        string memory college_Code,
        bool canAddNewStudent,
        uint totalStudent
    )   {
        return(
            CollegeRecord[_college_Address].college_Name,
            CollegeRecord[_college_Address].college_Address,
            CollegeRecord[_college_Address].college_Admin,
            CollegeRecord[_college_Address].college_Code,
            CollegeRecord[_college_Address].canAddNewStudent,
            CollegeRecord[_college_Address].totalStudent
        );
    }


}
