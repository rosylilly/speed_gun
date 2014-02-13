if(!window['speedGun']) { window.speedGun = {}; };

(function($) {
  if(!$) { return }

  speedGun.sendBrowserInfo = function() {
    var data = {};
    var p = window['performance'];

    data.user_agent = navigator.userAgent;

    if(p['navigation']) {
      data.navigation = {
        type: p.navigation.type,
        redirect_count: p.navigation.redirectCount
      };
    }

    if(p['timing']) {
      var t = p.timing;
      data.timing = {
        navigationStart: t.navigationStart,
        redirectStart: t.redirectStart,
        unloadEventStart: t.unloadEventStart,
        unloadEventEnd: t.unloadEventEnd,
        redirectEnd: t.redirectEnd,
        fetchStart: t.fetchStart,
        domainLookupStart: t.domainLookupStart,
        domainLookupEnd: t.domainLookupEnd,
        connectStart: t.connectStart,
        secureConnectionStart: t.secureConnectionStart,
        connectEnd: t.connectEnd,
        requestStart: t.requestStart,
        responseStart: t.responseStart,
        responseEnd: t.responseEnd,
        domLoading: t.domLoading,
        domInteractive: t.domInteractive,
        domContentLoadedEventStart: t.domContentLoadedEventStart,
        domContentLoadedEventEnd: t.domContentLoadedEventEnd,
        domComplete: t.domComplete,
        loadEventStart: t.loadEventStart,
        loadEventEnd: t.loadEventEnd,
      };
    }

    speedGun.send({ browser: data });
    $('#speed_gun_total').text(
      (t.domContentLoadedEventEnd - t.navigationStart).toString() + 'ms'
    );
  };

  speedGun.send = function(data) {
    if(speedGun.activated) {
      $.post(speedGun.endpoint, data, function() {});
    } else {
      if(!speedGun.queue) { speedGun.queue = [] };
      speedGun.queue.push(data);
    }
  };

  speedGun.processQueue = function() {
    var queue = speedGun.queue || [];
    for(var i = 0; i < queue.length; i++) {
      speedGun.send(queue[i])
    }
  }

  var loadedInterval = setInterval(function() {
    if (performance && performance.timing && performance.timing.loadEventEnd != 0) {
      clearInterval(loadedInterval);

      speedGun.id = $('#speed_gun').data('speed-gun-id');
      speedGun.endpoint = $('#speed_gun').data('speed-gun-endpoint') + "/" + speedGun.id;
      speedGun.activated = true;
      speedGun.sendBrowserInfo();
      speedGun.processQueue();
    }
  }, 100);
})(window['jQuery'] || window['Zepto']);
