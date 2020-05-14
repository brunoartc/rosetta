pragma solidity 0.6.4;


contract BlockchainInsper {
    address private president;
    address private techDirector;

    constructor(address _president, address _techDirector) public {
        president = _president;
        techDirector = _techDirector;
    }

    function isStaff() internal view returns (bool staff){
        return msg.sender == president || msg.sender == techDirector;
    }

    function changeStaff(address _president, address _techDirector) public {
        if (isStaff()) {
            president = _president;
            techDirector = _techDirector;
        }

    }



    /* ====================
        Election section
    =======================*/
    //burnout time dos dois pdoe ser correlacionado
    //pode ser feito uma aleatoriedade para voce pegar sua chave privada
    /*
    uint512[] private privateKeys; //colocar no ipfs
    function addNewVoterPrivateKey(uint512[] _privateKeys) public {
        if (isStaff()) {
            privateKeys = _privateKeys;
        }
    }

    mapping(uint256 => bool) passwords;
    function addPasswordHashes(uint256[] _passwords) public {
        if (isStaff()) {
            passwords = _passwords;
        }
    }

    mapping(uint64 => uint512) futureRelease;
    uint64[] possibleReleases;
    function correlatePasswordWallet(uint256 _password) public returns (uint64) {
        if (!passwords[_password]) {
            passwords[_password] = !passwords[_password];
            uint64 randomnumber = uint64(keccak256(abi.encodePacked(now, msg.sender, nonce))) % 100;
            possibleReleases.push(randomnumber);
            return randomnumber;
        }
    }


    function releaseKeys() public {
        if (isStaff()) {
            for (uint i = 0; i < privateKeys.length; i++) {
                futureRelease[possibleReleases[i]] = privateKeys[i];
            }
        }
    }

    function getKey(uint64 _randomId) public returns (uint512){
        return futureRelease[_randomId];
    }
    */


    mapping(address => bool) voted;
    function addVoter(address _voter) public {
        if (isStaff()){
            voted[_voter] = true;
        }
    }

    uint256 greater = 0;
    uint256 greaterId = 0;

    function vote(uint256 _votingId) public {
        if (voted[msg.sender]) {
            members[_votingId].staffPoints += 1;
            if (members[_votingId].staffPoints > greater) {
                greaterId = _votingId;
                greater = members[_votingId].staffPoints;
            }
            voted[msg.sender] = false;
        }
    }

    function votedStaff() public view returns(uint256) {
        return greaterId;
    }






    /* ====================
        Projects section
    =======================*/
    struct Project {
        bool active;
        address projectCreator;
        //ipfs description & current users owner and maiteiners
    }

    mapping(uint256 => Project) projects;
    uint256[] public projectIds;

    function projectsCount() private view returns (uint256 count) {
        return projectIds.length;
    }

    function addProjects(address _memberAddress) public {
        if (isStaff()) {
            BlockchainInsper.Project memory _project = projects[projectsCount() + 1];

            _project.projectCreator = _memberAddress;
            _project.active = false;

            memberIds.push(memberCount() + 1);
        }
    }



    /* ====================
        Members section
    =======================*/
    struct Member {
        uint8 memberType;
        address memberAddress;
        bool active;
        uint8 xp;
        bool changed;
        string PGP;
        uint8 staffPoints;
    }
    mapping(uint256 => Member) members;
    uint256[] public memberIds;

    function memberCount() private view returns (uint256 count) {
        return memberIds.length;
    }

    function addMembers(uint8 _memberType, address _memberAddress) public returns(uint256) {
        if (msg.sender == president || msg.sender == techDirector) {
            members[memberCount() + 1] = Member(_memberType, _memberAddress, true, 0, false, "", 0);
            /*
            _member.memberType = _memberType;
            _member.memberAddress = _memberAddress;
            _member.active = true;
            _member.xp = 0;
            _member.changed = false;
            */
            memberIds.push(memberCount() + 1);
            return memberCount() + 1;
        }
    }

    //sync with project
    function addXp(uint256 _memberId, uint8 _amount) public {
        if (isStaff()) {
            members[_memberId].xp += _amount;
        }
    }

    //sync with project
    function getXp(uint256 _memberId) public view returns(uint8) {
        if (isStaff()) {
             return members[_memberId].xp;
        }
    }

    // must be payed in ethereum
    // change to IPFS to lower gas cost & mainten
    function changeMemberAddressAndPGP(uint256 _memberId, address _address, string memory _PGPKey ) public {
        if (isStaff()) {
            members[_memberId].memberAddress = _address;
            members[_memberId].PGP = _PGPKey;
        }
    }

    function deactivateMembers(uint256 _ids) public{
        if (isStaff()){
            members[_ids].active = false;
        }
    }

}
