class SpeedGun
  NULL_ID = '00000000-0000-0000-0000-000000000000'

  JS_ELEMENT_ID = 'speed-gun-browser-profiling'

  TIMING_PROPERTIES = [
    'connectEnd',
    'connectStart',
    'domComplete',
    'domContentLoadedEventEnd',
    'domContentLoadedEventStart',
    'domInteractive',
    'domLoading',
    'domainLookupEnd',
    'domainLookupStart',
    'fetchStart',
    'loadEventEnd',
    'loadEventStart',
    'navigationStart',
    'redirectEnd',
    'redirectStart',
    'requestStart',
    'responseEnd',
    'responseStart',
    'secureConnectionStart',
    'unloadEventEnd',
    'unloadEventStart',
  ]

  class Profile
    constructor: (@name, @payload = {}) ->
      @startedAt = null
      @finishedAt = null

    start: () ->
      @startedAt = window.SpeedGun.now()
      profile?("#{@name}-#{@startedAt}")

    finish: () ->
      @finishedAt = window.SpeedGun.now()
      profileEnd?("#{@name}-#{@startedAt}")
      window.SpeedGun.sendProfile(@)

    toJSON: () ->
      JSON.stringify(
        name: @name,
        payload: @payload,
        started_at: @startedAt,
        finished_at: @finishedAt
      )

  constructor: () ->
    @profileId = @getProfileId()

    @listen('load', () =>
      if performance?.timing?
        setTimeout(() =>
          @sendProfile(
            name: 'buitin.browser.timing',
            payload: @timing()
          )
        , 100)
    )

  getProfileId: (cookie = document.cookie) ->
    start = cookie.indexOf("#{@cookieName()}=")
    if start != -1
      start += @cookieName() + 1
      end = cookie.indexOf(';',start)
      if end == -1
        end = cookie.length

      return cookie.substring(start, end)

    return NULL_ID

  cookieName: () ->
    @_cookieName ||= @element().getAttribute?('data-cookie') || ''

  element: (elementId = JS_ELEMENT_ID) ->
    @_element ||= document.getElementById(elementId)

  timing: () ->
    timing = {}

    if performance? && performance.timing?
      for property in TIMING_PROPERTIES
        timing[property] = performance.timing[property]

    return timing

  listen: (element, event, listener) ->
    if element.addEventListener?
      element.addEventListener(event, listener, false)
    else
      element.attachEvent?("on#{event}", listener)

  now: () ->
    performance?.now?() || +(new Date)

  profile: (name, func, payload = {}) ->
    profile = new Profile(name, payload)
    profile.start()
    func?(profile)
    profile.finish()

  newProfile: (name, payload) ->
    new Profile(name, payload)

  sendProfile: (profile) ->
    @api(
      'profile',
      profile
    )

  api_base: () ->
    @_api_base ||= @element()?.getAttribute?('data-api-base') || ''

  api: (name, params = {}) ->
    if XMLHttpRequest?
      request = new XMLHttpRequest()
    else
      request = new ActiveXObject('Microsoft.XMLHTTP')

    request.open('POST', "#{@api_base()}/#{name}", true)
    request.setRequestHeader('Content-Type', 'application/json; charset=utf-8')
    request.send(JSON.stringify(params))

@SpeedGun = new SpeedGun
