pragma solidity ^0.8.7;


contract distributeProfit{

    uint Id = 0;   //软件标识

    mapping(uint => softwareConcern) private softwaremap;

    struct softwareConcern{
        uint softwareId;
        mapping(address => contributor) contributors;
        address [] allContributors;     //软件所有的贡献者
        uint entryThreshold;        // 加入项目需要购买的贡献度阈值
        uint totalContri;           // 软件总贡献度
        uint softwareBouns;         //软件收益余额
    }

    struct contributor{
        address addr;         //贡献者的地址
        bool isIn;            //是否是软件的贡献者
        uint contribution;    //贡献者贡献度
    }

    function developSoftware(uint _entryThreshold) public{
        uint _softwareId = Id;
        softwaremap[_softwareId].softwareId = _softwareId;
        softwaremap[_softwareId].entryThreshold = _entryThreshold;
        softwaremap[_softwareId].contributors[msg.sender].addr = msg.sender;
        softwaremap[_softwareId].contributors[msg.sender].isIn = true;
        Id++;
    }


    function buyContribution(uint256 _softwareId) public payable{
        softwareConcern storage _software = softwaremap[_softwareId];
        if (!softwaremap[_softwareId].contributors[msg.sender].isIn){
            require(msg.value >= softwaremap[_softwareId].entryThreshold);
            softwaremap[_softwareId].contributors[msg.sender].isIn = true;
            softwaremap[_softwareId].contributors[msg.sender].addr = msg.sender;
        }
        softwaremap[_softwareId].contributors[msg.sender].contribution += msg.value;
        softwaremap[_softwareId].totalContri += msg.value;
        //判断购买贡献度的用户是否在所有贡献者列表中，如果不在则添加其列表中
        if(!existContributors(softwaremap[_softwareId].allContributors,msg.sender)){
            softwaremap[_softwareId].allContributors.push(msg.sender);
        }
    }

    //判断地址a是否在地址数组all
    function existContributors(address[] memory all, address a) public pure returns(bool) {
        for(uint i=0;i<all.length;i++){
            if(a==all[i]){
                return true;
            }
        }
        return false;
    }

    function DistributeProfit(uint _softwareId) public payable{
        uint _totalContri = softwaremap[_softwareId].totalContri;
        uint i = 0;
        while(i < softwaremap[_softwareId].allContributors.length){
            address payable ContributorAddress = payable(softwaremap[_softwareId].allContributors[i]);
            uint _Income = msg.value * 4 / 5 * softwaremap[_softwareId].contributors[ContributorAddress].contribution / _totalContri;
            ContributorAddress.transfer(_Income);
            i++;
        }
    }
}