(function($) {
  if(!$ || !window['performance'] || !performance['timing']) { return };

  var sendTimings = function() {
    var data = {};
    var t = performance.timing;

    data.navigation = {
      type: performance.navigation.type,
      redirect_count: performance.navigation.redirectCount
    };

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

    var id = $('#speed_gun').data('speed-gun-id');
    var endpoint = $('#speed_gun').data('speed-gun-endpoint') + "/" + id;

    $.post(endpoint, {browser: data}, function() {});
    $('#speed_gun_total').text(
      (t.domContentLoadedEventEnd - t.navigationStart).toString() + 'ms'
    );
  };

  var loadedInterval = setInterval(function() {
    if (performance.timing.loadEventEnd != 0) {
      clearInterval(loadedInterval);
      sendTimings();
    }
  }, 100);
})(window['jQuery'] || window['Zepto']);
