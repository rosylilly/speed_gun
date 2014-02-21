(function() {
  var SpeedGun;

  SpeedGun = (function() {
    var JS_ELEMENT_ID, NULL_ID, Profile, TIMING_PROPERTIES;

    NULL_ID = '00000000-0000-0000-0000-000000000000';

    JS_ELEMENT_ID = 'speed-gun-browser-profiling';

    TIMING_PROPERTIES = ['connectEnd', 'connectStart', 'domComplete', 'domContentLoadedEventEnd', 'domContentLoadedEventStart', 'domInteractive', 'domLoading', 'domainLookupEnd', 'domainLookupStart', 'fetchStart', 'loadEventEnd', 'loadEventStart', 'navigationStart', 'redirectEnd', 'redirectStart', 'requestStart', 'responseEnd', 'responseStart', 'secureConnectionStart', 'unloadEventEnd', 'unloadEventStart'];

    Profile = (function() {
      function Profile(name, payload) {
        this.name = name;
        this.payload = payload != null ? payload : {};
        this.startedAt = null;
        this.finishedAt = null;
      }

      Profile.prototype.start = function() {
        this.startedAt = window.SpeedGun.now();
        return typeof profile === "function" ? profile("" + this.name + "-" + this.startedAt) : void 0;
      };

      Profile.prototype.finish = function() {
        this.finishedAt = window.SpeedGun.now();
        if (typeof profileEnd === "function") {
          profileEnd("" + this.name + "-" + this.startedAt);
        }
        return window.SpeedGun.sendProfile(this);
      };

      Profile.prototype.toJSON = function() {
        return JSON.stringify({
          name: this.name,
          payload: this.payload,
          started_at: this.startedAt,
          finished_at: this.finishedAt
        });
      };

      return Profile;

    })();

    function SpeedGun() {
      this.profileId = this.getProfileId();
      this.listen('load', (function(_this) {
        return function() {
          if ((typeof performance !== "undefined" && performance !== null ? performance.timing : void 0) != null) {
            return setTimeout(function() {
              return _this.sendProfile({
                name: 'buitin.browser.timing',
                payload: _this.timing()
              });
            }, 100);
          }
        };
      })(this));
    }

    SpeedGun.prototype.getProfileId = function(cookie) {
      var end, start;
      if (cookie == null) {
        cookie = document.cookie;
      }
      start = cookie.indexOf("" + (this.cookieName()) + "=");
      if (start !== -1) {
        start += this.cookieName() + 1;
        end = cookie.indexOf(';', start);
        if (end === -1) {
          end = cookie.length;
        }
        return cookie.substring(start, end);
      }
      return NULL_ID;
    };

    SpeedGun.prototype.cookieName = function() {
      var _base;
      return this._cookieName || (this._cookieName = (typeof (_base = this.element()).getAttribute === "function" ? _base.getAttribute('data-cookie') : void 0) || '');
    };

    SpeedGun.prototype.element = function(elementId) {
      if (elementId == null) {
        elementId = JS_ELEMENT_ID;
      }
      return this._element || (this._element = document.getElementById(elementId));
    };

    SpeedGun.prototype.timing = function() {
      var property, timing, _i, _len;
      timing = {};
      if ((typeof performance !== "undefined" && performance !== null) && (performance.timing != null)) {
        for (_i = 0, _len = TIMING_PROPERTIES.length; _i < _len; _i++) {
          property = TIMING_PROPERTIES[_i];
          timing[property] = performance.timing[property];
        }
      }
      return timing;
    };

    SpeedGun.prototype.listen = function(element, event, listener) {
      if (element.addEventListener != null) {
        return element.addEventListener(event, listener, false);
      } else {
        return typeof element.attachEvent === "function" ? element.attachEvent("on" + event, listener) : void 0;
      }
    };

    SpeedGun.prototype.now = function() {
      return (typeof performance !== "undefined" && performance !== null ? typeof performance.now === "function" ? performance.now() : void 0 : void 0) || +(new Date);
    };

    SpeedGun.prototype.profile = function(name, func, payload) {
      var profile;
      if (payload == null) {
        payload = {};
      }
      profile = new Profile(name, payload);
      profile.start();
      if (typeof func === "function") {
        func(profile);
      }
      return profile.finish();
    };

    SpeedGun.prototype.newProfile = function(name, payload) {
      return new Profile(name, payload);
    };

    SpeedGun.prototype.sendProfile = function(profile) {
      return this.api('profile', profile);
    };

    SpeedGun.prototype.api_base = function() {
      var _ref;
      return this._api_base || (this._api_base = ((_ref = this.element()) != null ? typeof _ref.getAttribute === "function" ? _ref.getAttribute('data-api-base') : void 0 : void 0) || '');
    };

    SpeedGun.prototype.api = function(name, params) {
      var request;
      if (params == null) {
        params = {};
      }
      if (typeof XMLHttpRequest !== "undefined" && XMLHttpRequest !== null) {
        request = new XMLHttpRequest();
      } else {
        request = new ActiveXObject('Microsoft.XMLHTTP');
      }
      request.open('POST', "" + (this.api_base()) + "/" + name, true);
      request.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
      return request.send(JSON.stringify(params));
    };

    return SpeedGun;

  })();

  this.SpeedGun = new SpeedGun;

}).call(this);
