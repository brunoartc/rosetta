pragma solidity 0.6.4;


contract BlockchainInsper {
    address private president;
    address private techDirector;

    constructor(address _president, address _techDirector) public {
        president = _president;
        techDirector = _techDirector;
    }

    /* ====================
        Projects section
    =======================*/
    struct Project {
        bool active;
        address projectCreator;
        address currentMaintainer;
    }

    mapping(uint256 => Project) projects;
    uint256[] public projectIds;

    function projectsCount() private view returns (uint256 count) {
        return projectIds.length;
    }

    function addProjects(address _memberAddress) public {
        if (msg.sender == president || msg.sender == techDirector) {
            BlockchainInsper.Project memory _project = projects[projectsCount() + 1];

            _project.projectCreator = _memberAddress;
            _project.active = false;
            _project.currentMaintainer = msg.sender;

            memberIds.push(memberCount() + 1);
        }
    }



    /* ====================
        Members section
    =======================*/
    struct Member {
        uint256 memberType;
        address memberAddress;
        bool active;
        uint256 xp;
        uint256[] projects;
        bool changed;
        string PGP;
    }
    mapping(uint256 => Member) members;
    uint256[] public memberIds;

    function memberCount() private view returns (uint256 count) {
        return memberIds.length;
    }

    function addMember(uint256 _memberType, address _memberAddress) public {
        if (msg.sender == president || msg.sender == techDirector) {
            BlockchainInsper.Member memory _member = members[memberCount() + 1];

            _member.memberType = _memberType;
            _member.memberAddress = _memberAddress;
            _member.active = true;
            _member.xp = 0;
            _member.changed = false;

            memberIds.push(memberCount() + 1);
        }
    }

    //add given xp sync with project & check if sender has permission
    function addXp(uint256 _memberId, uint256 _amount) public {
        members[_memberId].xp += _amount;
    }
    // check if sender has permission
    // must be payed in ethereum
    // change to IPFS
    function changeMemberAddressAndPGP(uint256 _memberId, address _address, string memory _PGP ) public {
        members[_memberId].memberAddress = _address;
        members[_memberId].PGP = _PGP;
    }

}
