var array = []; 

App = {
    web3Provider:null,
    contracts: {},

    initWeb3: function(){
        App.web3Provider = new web3.providers.HttpProvider("http://localhost:9545");
        return App.initContract();
    },

    initContract: function(){
        $.getJSON('Main.json', function(data){
            var Artifact = data;
            App.contracts.Main = TruffleContract(Artifact);
            App.contracts.Main.setProvider(App.web3Provider);
            App.contracts.Main.deployed().then(function(instance) {
                return instance.testfunc();
            }).then(function(adopters){
                document.write(adopters);
            }).catch(function(err){
                console.log(err.message);
            });
        });
    }
}

window.onload = function(){
    App.initWeb3();
}