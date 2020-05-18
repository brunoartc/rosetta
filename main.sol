pragma solidity 0.6.4;


contract BlockchainInsper {
    address private president;
    address private techDirector;
    string public techDirectorFingerprint;

    constructor(address _president, address _techDirector, string memory _techDirectorFingerprint) public {
        president = _president;
        techDirector = _techDirector;
        techDirectorFingerprint = _techDirectorFingerprint;

    }

    function isStaff() internal view returns (bool staff){
        return msg.sender == president || msg.sender == techDirector;
    }


    function getStaffFingerPrint() public view returns(string memory _fingerprint) {
        return techDirectorFingerprint;
    }


    /* ====================
        Projects section
    =======================*/
    string latestProjectUpdateHash;

    struct Project {
        bool active;
        address projectCreator;
        string description;
        string lastSignature;
    }

    mapping(uint256 => Project) projects;
    uint256[] public projectIds;

    function projectsCount() private view returns (uint256 count) {
        return projectIds.length;
    }

    function addProjects(address _memberAddress, string memory _IPFSDescriptionHash) public {
        if (isStaff()) {
            BlockchainInsper.Project memory _project = projects[projectsCount() + 1];

            _project.projectCreator = _memberAddress;
            _project.active = true;
            _project.description = _IPFSDescriptionHash;

            projectIds.push(memberCount() + 1); //change to a number (less memory?)
        }
    }

    function signProjectUpdate(uint256 _projectId, string memory _IPFSHash) internal{
        projects[_projectId].lastSignature = _IPFSHash;
    }



    /* ====================
        Members section
    =======================*/
    struct Member{
        address memberAddress;
        bool active;
        uint256 xp;
        string PGPfingerprint;
        string moreInfo;
    }

    mapping(uint256 => Member) members;
    uint256[] public memberIds;

    function memberCount() private view returns (uint256 count) {
        return memberIds.length;
    }

    function addMembers(address _memberAddress, string memory _PGPfingerprint,
     string memory _IPFSfile) public returns (uint256){
        if (isStaff()) {
            BlockchainInsper.Member memory _member = members[memberCount() + 1];

            _member.memberAddress = _memberAddress;
            _member.active = true;
            _member.xp = 0;
            _member.PGPfingerprint = _PGPfingerprint;
            _member.moreInfo = _IPFSfile;

            memberIds.push(memberCount() + 1); //change to a number (less memory?)
            return memberCount() + 1;
        } else {
            return 0;
        }
    }


    function addXp(uint256 _memberId, uint256 _amount, uint256 _projectId, string memory _IPFSHash) public {
        if (isStaff()) {
            if (projects[_projectId].active){
                members[_memberId].xp += _amount;
                signProjectUpdate(_projectId, _IPFSHash);
            }
        }
    }
    // must be payed in ethereum
    // change to IPFS to lower gas cost & mainten
    function changeMemberAddress(uint256 _memberId, address _address) public {
        if (isStaff()) {
            members[_memberId].memberAddress = _address;
        }
    }

    function deactivateMembers(uint256[] memory _ids) public{
        if (isStaff()){
            for (uint256 i; i < _ids.length; i++) {
                members[_ids[i]].active = false;
            }
        }
    }

}
