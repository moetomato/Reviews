array = []; 

App = {
    web3Provider:null,
    contracts: {},

    initWeb3: function(){
        App.web3Provider = new web3.providers.HttpProvider("http://localhost:9545");
        return App.initContract();
    },

    initContract: function(){
        $.getJSON('Main.json', function(data){
            for(i = 0; i<10; i++){
                array.push(new Array(10));
            }
            var Artifact = data;
            App.contracts.Main = TruffleContract(Artifact);
            App.contracts.Main.setProvider(App.web3Provider);
            App.contracts.Main.deployed().then(function(instance) {
                var cnt = 0;                  
                for(var i = 0; i<10; i++){
                    for(var j = 0; j<10; j++){
                        instance.getPeerReviews.call(i,j).then(function(res){
                            var ii = res[1]["words"][0];
                            var jj = res[2]["words"][0];
                            array[ii][jj] = res[0]["words"][0];
                            if (++cnt == 100)
                                document.write(array);
                        });
                    }
                }
            });
        });
    }
}







// App = {
//     web3Provider:null,
//     contracts: {},

//     initWeb3: function(){
//         App.web3Provider = new web3.providers.HttpProvider("http://localhost:9545");
//         return App.initContract();
//     },

//     initContract: function(){
//         $.getJSON('Main.json', function(data){
//             var Artifact = data;
//             App.contracts.Main = TruffleContract(Artifact);

//             App.contracts.Main.setProvider(App.web3Provider);

//             App.contracts.Main.deployed().then(function(instance) {
//                 return instance.getPeerReviews.call(0,1);
//             }).then(function(adopters){
//                 document.write(adopters);
//             }).catch(function(err){
//                 console.log(err.message);
//             });
//         });
//     }
// }

window.onload = function(){
    App.initWeb3();
}