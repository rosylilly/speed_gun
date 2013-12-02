if(!window['speedGun']) { window.speedGun = {}; };
speedGun.enableConsoleProfile = !!(window['console'] && console['profile']);
speedGun.profileCount = 0;

speedGun.profile = function(title, func) {
  speedGun.profileCount++;
  if(!func) {
    func = title;
    title = undefined;
  };
  if(!title) {
    title = "Speed Gun Profile #" + speedGun.profileCount;
  };
  var callstack = [];
  var caller = arguments['callee'];
  if(caller) {
    while(caller) {
      caller = caller['caller'];
      if(caller) { callstack.push(caller.toString()); };
    }
  }
  var before = +(new Date);
  if(speedGun.enableConsoleProfile) { console.profile(title); };
  ret = func();
  if(speedGun.enableConsoleProfile) { console.profileEnd(title); };
  var elapsedTime = (+(new Date)) - before;
  if(speedGun['send']) {
    speedGun.send(
      { js: { title: title, elapsed_time: elapsedTime, backtrace: callstack } }
    );
  };
  return ret;
};

speedGun.profileMethod = function(object, methodName, title) {
  if(!title) { title = "#" + methodName; };
  var method = object[methodName];
  var func = function() {
    var args = arguments;
    return speedGun.profile(title, function() {
      return method.apply(object, args);
    });
  };
  object[methodName] = func;
}
