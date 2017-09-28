(function () {
  var flags = {
    hash: window.location.hash
  };

  var lmcApp = Elm.Main.fullscreen(flags);
  
  lmcApp.ports.setHash.subscribe(function (newHashValue) {
    window.location.hash = newHashValue;
  });
})();
