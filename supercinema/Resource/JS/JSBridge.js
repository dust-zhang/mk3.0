
;(function(global)
  {
  'use strict';

  var doc = document;
  var methods = {};

  var Util = {
    slice: Array.prototype.slice
  };

  var _exec = function(host, querystring)
  {
    var url = 'jsbridge://' + host;
//    alert(url + '?' + encodeURIComponent(querystring))
    global.location.href = url + '?' + encodeURIComponent(querystring);
  };

  methods.weixinShare = function()
  {
    var args = Util.slice.call(arguments);
    _exec('weixinShare', args);
  };
  
  methods.globalInvoke = function(method,args){
    _exec(method, args);
  }

  var _init = function()
  {
    this.methods = methods;
  };

  var _invoke = function()
  {
    var args = Util.slice.call(arguments);
  
    if (!args) {
      //alert('arguments error');
    }

    var method = args.shift();
    try
   {
      if(this.methods[method]){
          this.methods[method].call(global, args);
      }
      else{
          this.methods.globalInvoke(method, args);
      }
  
    } catch(e) {
      //alert(e.stack);
    }
  };

  var MovikrJSBridge =
  {
    init: _init,
    invoke: _invoke
  };

  MovikrJSBridge.init();

  var readyEvent = doc.createEvent('Events');
  readyEvent.initEvent('JSBridgeReady');
  doc.dispatchEvent(readyEvent);
  
  global.MovikrJSBridge = MovikrJSBridge;
})(this);
