App = {
    web3Provider:null,
    contracts: {},

    initWeb3: function(){
        App.web3Provider = new web3.providers.HttpProvider("http://localhost:9545");
        return App.initContract();
    },

    array: new Array(10)(10),

    initContract: function(){
        $.getJSON('Main.json', function(data){
            var Artifact = data;
            App.contracts.Main = TruffleContract(Artifact);

            App.contracts.Main.setProvider(App.web3Provider);

            App.contracts.Main.deployed().then(function(instance) {
                for(i = 0; i<10; i++){
                    for(j = 0; j<10; j++){
                        array[i][j] = instance.getPeerReviews.call(i,j);
                    }
                }
            }).then(function(){
                for(i = 0; i<100; i++) document.write(array[i]);
            }).catch(function(err){
                console.log(err.message);
            });

        });
    }
}

App.initWeb3();