import "./ManufacturersManager.sol";

pragma solidity ^0.4.18;

contract ProductManager is ManufacturersManager{
  //ProductStatusという列挙型の型を設定
   enum ProductStatus {Shipped, Owned,Disposed}

   //製品の情報構造
   struct ProductInfo {
       address owner;
       address recipient;
       ProductStatus pStatus;
       uint creationTime;
       uint8 nTransferred;
       //address manufacuture
   }

   //製品のEPCを受けて、製品の情報構造を返す
   mapping (uint => ProductInfo) products;

   //製品（EPC）が本当に呼び出したメーカーのものなのか確認
   /* function checkAuthorship(uint _EPC) returns(bool){
       //EPCデータベースで確認⇨今の所できない
   } */

   //製品をブロックチェーン上に登録
   function enrollProduct(address _manufacturerAddress, uint _EPC) public onlyNotExist(_EPC) {
     //if checkAuthorship(_EPC)
      products[_EPC].owner = _manufacturerAddress;
      products[_EPC].pStatus = ProductStatus.Owned;
      products[_EPC].creationTime = now;
      products[_EPC].nTransferred = 0;
   }

   function shipProduct(address _reciever, uint _EPC) public onlyExist(_EPC) onlyOwner(_EPC) onlyStatusIs(_EPC, ProductStatus.Owned) {
     if (_reciever == products[_EPC].owner) {
           //製品の所有者が_recieverの時（すでに出発している）、例外処理⇨何もしない
           /* throw; */
       } else {
           //製品の所有者が_recieverじゃないとき
           products[_EPC].pStatus = ProductStatus.Shipped;
           products[_EPC].recipient = _reciever;
       }
   }


 //受け手は、製品を受け取ったら、製品の所有者、ステータス、配送回数を更新
     function receiveProduct(uint _EPC) public onlyExist(_EPC) onlyRecipient(_EPC) onlyStatusIs(_EPC, ProductStatus.Shipped) {
         products[_EPC].owner = msg.sender;
         products[_EPC].pStatus = ProductStatus.Owned;
         products[_EPC].nTransferred = products[_EPC].nTransferred + 1;
         // if (products[EPC].nTransferred <= MAXTRANSFER) {
         //     msg.sender.send(transferReward);
         // }
     }




     ////製造者が一つという前提になっているから注意！(0or1)///
//指定された製品が構造体に登録されていない
modifier onlyNotExist (uint _EPC) {
    require(products[_EPC].owner == 0x0000000000000000000000000000000000000000);
    _;
}

//指定された製品Cが構造体に登録されている
modifier onlyExist (uint _EPC)  {
    require(products[_EPC].owner != 0x0000000000000000000000000000000000000000);
    _;
}


//本当に受けて(msg.sender)は真の受け手なのか
modifier onlyRecipient (uint _EPC) {
    require(products[_EPC].recipient == msg.sender);
    _;
}

 //本当に自分はオーナーなの?
modifier onlyOwner (uint _EPC) {
    require(products[_EPC].owner == msg.sender);
    _;
}


//製品のステータスが指定の状況の時
modifier onlyStatusIs (uint _EPC, ProductStatus thisStatus) {
    require(products[_EPC].pStatus == thisStatus);
    _;
}






}
