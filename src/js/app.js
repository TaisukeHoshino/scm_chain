App = {
     web3Provider: null,
     contracts: {},
     loading: false,


     init: function() {
          /*
           * Replace me...
           */

          return App.initWeb3();
     },

     initWeb3: function() {
       //❶initialize web3
         if (typeof web3 !== 'undefined'){
           //1.1 reuse the provieder of the Web3 object injected by metamask
           App.web3Provider = web3.currentProvider;
         }else{
           //1.2 create a new provider and plug it directory into our local node
           App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
         }
           //❷web3オブジェクト作成
         web3 = new Web3(App.web3Provider);

         App.displayAccountInfo();

           //❸コントラクトの初期化
         return App.initContract();


     },

     initContract: function() {
       $.getJSON('ManufacturersManager.json', function(manufacturersManagerArtifact){
        //❶get the contract artifact file and use it to instatiate a truffle contract abstraction
        App.contracts.ManufacturersManager = TruffleContract(manufacturersManagerArtifact);
        //❷set the provider for our contracts
        App.contracts.ManufacturersManager.setProvider(App.web3Provider);
        //❸listen to events
        //retrieve the article from the contract

      })
     },

     setManufacturer: function() {

       //テキストボックスに入力されたアドレスを取得
       var manufacturerAddress = $('#manufacturerAddressInput').val();
       var manufacturerPrefix = $('#manufacturerPrefixInput').val();
       var manufacturerName = $('#manufacturerNameInput').val();
       var manufacturerTime = $('#manufacturerTimeInput').val();
       //アドレスをブロックチェーンに登録する
       var manufacturerInstance;

      App.contracts.ManufacturersManager.deployed().then(function(instance){
        manufacturerInstance = instance;
        return manufacturerInstance.enrollManufacturer(manufacturerAddress ,manufacturerPrefix, manufacturerName, manufacturerTime, {
          from: App.account,
          gas: 500000
        })
      }).catch(function(err){
        console.error(err.message);
      })

      App.reloadManufacturer();


     },
     reloadManufacturer: function(){
       //ブロックチェーンに登録してあるメーカーをリロードし、表示する

       var manufacturerInstance;


       App.contracts.ManufacturersManager.deployed().then(function(instance){
         manufacturerInstance = instance;
         manufacturerInstance.getManufacturer().then(function(manufacturerIds){
           for (var i = 0; i < manufacturerIds.length; i++) {
             var manufacturerId = manufacturerIds[i];
             manufacturerInstance.manufacturerInfos(manufacturerId.toNumber()).then(function(manufacturerInfo){
               App.displayManufacturer(manufacturerInfo[1], manufacturerInfo[2], manufacturerInfo[3]);
             });
           }
         }).catch(function(err){
           console.error(err);
         })
       })


     },

     displayManufacturer: function(_prefix, _name, _time){
       $('#manufacturerPrefix').text(_prefix);
       $('#manufacturerName').text(_name);
       $('#manufacturerTime').text(_time);

     },

     checkAddress: function(_manufacturerAddress){
       //ブロックチェーンに登録してあるメーカーのprefixから、アドレスを返す

     },
      //アカウントの情報をjsファイルで扱えるようにする
      displayAccountInfo: function() {
        web3.eth.getCoinbase(function(err, account){
          if(err === null){
            App.account = account;
            web3.eth.getBalance(account, function(err, balance){
              if(err===null){
                //Balance情報の取得と表示
              }
            })
          }
        })
      }

};

$(function() {
     $(window).load(function() {
          App.init();
     });
});
