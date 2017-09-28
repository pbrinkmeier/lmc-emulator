(function () {
  var lmcApp = Elm.Main.fullscreen();
  
  lmcApp.ports.setHash.subscribe(function (newHashValue) {
    window.location.hash = newHashValue;
  });
})();
