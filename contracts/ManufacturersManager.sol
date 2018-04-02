pragma solidity ^0.4.18;

contract ManufacturersManager {

  struct ManufacturerInfo {
    uint id;
    uint companyPrefix;
    string companyName;
    uint expireTime;
  }
  /* ManufacturerInfo[] public manufacturerInfos; */
  mapping(uint => ManufacturerInfo) public manufacturerInfos;
  //アドレスを指定すると、メーカーの情報を返す
  mapping(address => ManufacturerInfo) addressToManufacturer;
  //メーカーのPrefixを指定すると、その会社のaddressを返す
  mapping(uint => address) companyPrefixToAddress;

  uint manufacturerCounter;

  function enrollManufacturer (address companyAddress, uint _companyPrefix, string _companyName, uint _expireTime) public {
    //manufacturerInfosのid(manufacturerCounter)=1番目から代入している
    manufacturerCounter ++;
    manufacturerInfos[manufacturerCounter] = ManufacturerInfo(manufacturerCounter, _companyPrefix, _companyName, _expireTime);
    companyPrefixToAddress[_companyPrefix] = companyAddress;
  }

  function getManufacturer() public view returns(uint []) {
    //idを入れるarrayを用意
    uint[] memory manufacturerIds = new uint[](manufacturerCounter);
    uint numberOfManufacturer = 0;

    //配列にmanufacturerのidを入れていく(mappingにはid=1番目から入っているのでi=1からroopする)
    for(uint i = 1; i <= manufacturerCounter; i++){
      manufacturerIds[numberOfManufacturer] = manufacturerInfos[i].id;
      numberOfManufacturer++;
    }
    return manufacturerIds;
  }
}
