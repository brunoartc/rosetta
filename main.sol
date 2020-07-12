pragma solidity 0.6.9;


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
        bytes description;
        bytes lastSignature;
    }

    mapping(uint256 => Project) projects;
    uint256[] public projectIds;

    function projectsCount() public view returns (uint256 count) {
        return projectIds.length;
    }

    function addProjects(address _memberAddress, string memory _IPFSDescriptionHash) public {
        if (isStaff()) {
            BlockchainInsper.Project memory _project = projects[projectsCount() + 1];

            _project.projectCreator = _memberAddress;
            _project.active = true;
            _project.description = bytes(_IPFSDescriptionHash);
            _project.lastSignature = bytes(_IPFSDescriptionHash);
            projectIds.push(memberCount() + 1); //change to a number (less memory?)
        }
    }

    function signProjectUpdate(uint256 _projectId, bytes memory _IPFSHash) internal{
        projects[_projectId].lastSignature = _IPFSHash;
    }

    function getProjectLastUpdate(uint256 _projectId) public view returns(bytes memory) {
        return projects[_projectId].lastSignature;
    }

    function getProjectDescription(uint256 _projectId) public view returns(bytes memory) {
        return projects[_projectId].description;
    }


    /* ====================
        Members section
    =======================*/
    struct Member{
        address memberAddress;
        bool active;
        uint256 xp;
        bytes PGPfingerprint;
        bytes moreInfo;
    }

    mapping(uint256 => Member) members;
    uint256[] public memberIds;

    function memberCount() public view returns (uint256 count) {
        return memberIds.length;
    }

    function addMembers(address _memberAddress, string memory _PGPfingerprint,
     string memory _IPFSfile) public {
        if (isStaff()) {
            members[memberCount() + 1].memberAddress = _memberAddress;
            members[memberCount() + 1].active = true;
            members[memberCount() + 1].xp = 10;
            members[memberCount() + 1].PGPfingerprint = bytes(_PGPfingerprint);
            members[memberCount() + 1].moreInfo = bytes(_IPFSfile);

            memberIds.push(memberCount() + 1); //change to a number (less memory?)
        }
    }


    function addXp(uint256 _memberId, uint256 _amount, uint256 _projectId, string memory _IPFSHash) public {
        if (isStaff()) {
            if (projects[_projectId].active){
                members[_memberId].xp += _amount;
                signProjectUpdate(_projectId, bytes(_IPFSHash));
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

    function changePresident(address _address) public {
        if (isStaff()) {
            president = _address;
        }
    }

    function changeTechDirector(address _address, string memory _techDirectorFingerprint) public {
        if (isStaff()) {
            techDirector = _address;
            techDirectorFingerprint = _techDirectorFingerprint;
        }
    }

    function deactivateMembers(uint256[] memory _ids) public{
        if (isStaff()){
            for (uint256 i; i < _ids.length; i++) {
                members[_ids[i]].active = false;
            }
        }
    }

    function getUserXp(uint256 _memberId) public view returns (uint256 count) {
        return members[_memberId].xp;
    }

    function getMemberDescription(uint256 _memberId) public view returns(bytes memory) {
        return members[_memberId].moreInfo;
    }

    function getMemberPGPfingerprint(uint256 _memberId) public view returns(bytes memory) {
        return members[_memberId].PGPfingerprint;
    }

    function getMemberAddress(uint256 _memberId) public view returns(address) {
        return members[_memberId].memberAddress;
    }
}