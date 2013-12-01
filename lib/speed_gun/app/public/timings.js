(function($) {
  if(!$ || !window['performance'] || !performance['timing']) { return };

  var sendTimings = function() {
    var data = {};
    var timing = performance.timing;

    data.navigation = {
      type: performance.navigation.type,
      redirect_count: performance.navigation.redirectCount
    };

    data.timing = {
      0: { 'all': timing.loadEventEnd - timing.navigationStart },
      1: { 'redirect': timing.redirectEnd - timing.redirectStart },
      2: { 'application_cache': timing.domainLookupStart - timing.fetchStart },
      3: { 'dns': timing.domainLookupEnd - timing.domainLookupStart },
      4: { 'tcp': timing.connectEnd - timing.connectStart },
      5: { 'request': timing.responseStart - timing.requestStart },
      6: { 'response': timing.responseEnd - timing.responseStart },
      7: { 'dom': timing.domComplete - timing.domLoading },
      8: { 'load': timing.loadEventEnd - timing.loadEventStart }
    };

    data.timeline = {
      'start': timing.navigationStart,
      'redirect ended': timing.redirectEnd,
      'fetch start': timing.fetchStart,
      'dns lookuped': timing.domainLookupEnd,
      'tcp connected': timing.connectEnd,
      'request start': timing.responseStart,
      'response receive start': timing.responseEnd,
      'dom content loaded': timing.domContentLoadedEventEnd,
      'loaded page': timing.loadEventEnd
    };

    var endpoint = $('#speed_gun').data('speed-gun-endpoint');

    $.post(endpoint, {client_info: data}, function() {});
    $('#speed_gun_total').text(
      'All: ' + data.timing[0]['all'].toString() + 'ms / Rack: ' + $('#speed_gun_total').text()
    );
  };

  var loadedInterval = setInterval(function() {
    if (performance.timing.loadEventEnd != 0) {
      clearInterval(loadedInterval);
      sendTimings();
    }
  }, 100);
})(window['jQuery'] || window['Zepto']);
