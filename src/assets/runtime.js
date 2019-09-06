var Mint = (function () {
	'use strict';

	var commonjsGlobal = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};

	function commonjsRequire () {
		throw new Error('Dynamic requires are not currently supported by rollup-plugin-commonjs');
	}

	function unwrapExports (x) {
		return x && x.__esModule && Object.prototype.hasOwnProperty.call(x, 'default') ? x['default'] : x;
	}

	function createCommonjsModule(fn, module) {
		return module = { exports: {} }, fn(module, module.exports), module.exports;
	}

	/*
	object-assign
	(c) Sindre Sorhus
	@license MIT
	*/
	/* eslint-disable no-unused-vars */
	var getOwnPropertySymbols = Object.getOwnPropertySymbols;
	var hasOwnProperty = Object.prototype.hasOwnProperty;
	var propIsEnumerable = Object.prototype.propertyIsEnumerable;

	function toObject(val) {
		if (val === null || val === undefined) {
			throw new TypeError('Object.assign cannot be called with null or undefined');
		}

		return Object(val);
	}

	function shouldUseNative() {
		try {
			if (!Object.assign) {
				return false;
			}

			// Detect buggy property enumeration order in older V8 versions.

			// https://bugs.chromium.org/p/v8/issues/detail?id=4118
			var test1 = new String('abc');  // eslint-disable-line no-new-wrappers
			test1[5] = 'de';
			if (Object.getOwnPropertyNames(test1)[0] === '5') {
				return false;
			}

			// https://bugs.chromium.org/p/v8/issues/detail?id=3056
			var test2 = {};
			for (var i = 0; i < 10; i++) {
				test2['_' + String.fromCharCode(i)] = i;
			}
			var order2 = Object.getOwnPropertyNames(test2).map(function (n) {
				return test2[n];
			});
			if (order2.join('') !== '0123456789') {
				return false;
			}

			// https://bugs.chromium.org/p/v8/issues/detail?id=3056
			var test3 = {};
			'abcdefghijklmnopqrst'.split('').forEach(function (letter) {
				test3[letter] = letter;
			});
			if (Object.keys(Object.assign({}, test3)).join('') !==
					'abcdefghijklmnopqrst') {
				return false;
			}

			return true;
		} catch (err) {
			// We don't expect any of the above to throw, but better to be safe.
			return false;
		}
	}

	var objectAssign = shouldUseNative() ? Object.assign : function (target, source) {
		var from;
		var to = toObject(target);
		var symbols;

		for (var s = 1; s < arguments.length; s++) {
			from = Object(arguments[s]);

			for (var key in from) {
				if (hasOwnProperty.call(from, key)) {
					to[key] = from[key];
				}
			}

			if (getOwnPropertySymbols) {
				symbols = getOwnPropertySymbols(from);
				for (var i = 0; i < symbols.length; i++) {
					if (propIsEnumerable.call(from, symbols[i])) {
						to[symbols[i]] = from[symbols[i]];
					}
				}
			}
		}

		return to;
	};

	var n="function"===typeof Symbol&&Symbol.for,p=n?Symbol.for("react.element"):60103,q=n?Symbol.for("react.portal"):60106,r=n?Symbol.for("react.fragment"):60107,t=n?Symbol.for("react.strict_mode"):60108,u=n?Symbol.for("react.profiler"):60114,v=n?Symbol.for("react.provider"):60109,w=n?Symbol.for("react.context"):60110,x=n?Symbol.for("react.concurrent_mode"):60111,y=n?Symbol.for("react.forward_ref"):60112,z=n?Symbol.for("react.suspense"):60113,aa=n?Symbol.for("react.memo"):
	60115,ba=n?Symbol.for("react.lazy"):60116,A="function"===typeof Symbol&&Symbol.iterator;function ca(a,b,d,c,e,g,h,f){if(!a){a=void 0;if(void 0===b)a=Error("Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.");else{var l=[d,c,e,g,h,f],m=0;a=Error(b.replace(/%s/g,function(){return l[m++]}));a.name="Invariant Violation";}a.framesToPop=1;throw a;}}
	function B(a){for(var b=arguments.length-1,d="https://reactjs.org/docs/error-decoder.html?invariant="+a,c=0;c<b;c++)d+="&args[]="+encodeURIComponent(arguments[c+1]);ca(!1,"Minified React error #"+a+"; visit %s for the full message or use the non-minified dev environment for full errors and additional helpful warnings. ",d);}var C={isMounted:function(){return!1},enqueueForceUpdate:function(){},enqueueReplaceState:function(){},enqueueSetState:function(){}},D={};
	function E(a,b,d){this.props=a;this.context=b;this.refs=D;this.updater=d||C;}E.prototype.isReactComponent={};E.prototype.setState=function(a,b){"object"!==typeof a&&"function"!==typeof a&&null!=a?B("85"):void 0;this.updater.enqueueSetState(this,a,b,"setState");};E.prototype.forceUpdate=function(a){this.updater.enqueueForceUpdate(this,a,"forceUpdate");};function F(){}F.prototype=E.prototype;function G(a,b,d){this.props=a;this.context=b;this.refs=D;this.updater=d||C;}var H=G.prototype=new F;
	H.constructor=G;objectAssign(H,E.prototype);H.isPureReactComponent=!0;var I={current:null},J={current:null},K=Object.prototype.hasOwnProperty,L={key:!0,ref:!0,__self:!0,__source:!0};
	function M(a,b,d){var c=void 0,e={},g=null,h=null;if(null!=b)for(c in void 0!==b.ref&&(h=b.ref), void 0!==b.key&&(g=""+b.key), b)K.call(b,c)&&!L.hasOwnProperty(c)&&(e[c]=b[c]);var f=arguments.length-2;if(1===f)e.children=d;else if(1<f){for(var l=Array(f),m=0;m<f;m++)l[m]=arguments[m+2];e.children=l;}if(a&&a.defaultProps)for(c in f=a.defaultProps, f)void 0===e[c]&&(e[c]=f[c]);return{$$typeof:p,type:a,key:g,ref:h,props:e,_owner:J.current}}
	function da(a,b){return{$$typeof:p,type:a.type,key:b,ref:a.ref,props:a.props,_owner:a._owner}}function N(a){return"object"===typeof a&&null!==a&&a.$$typeof===p}function escape(a){var b={"=":"=0",":":"=2"};return"$"+(""+a).replace(/[=:]/g,function(a){return b[a]})}var O=/\/+/g,P=[];function Q(a,b,d,c){if(P.length){var e=P.pop();e.result=a;e.keyPrefix=b;e.func=d;e.context=c;e.count=0;return e}return{result:a,keyPrefix:b,func:d,context:c,count:0}}
	function R(a){a.result=null;a.keyPrefix=null;a.func=null;a.context=null;a.count=0;10>P.length&&P.push(a);}
	function S(a,b,d,c){var e=typeof a;if("undefined"===e||"boolean"===e)a=null;var g=!1;if(null===a)g=!0;else switch(e){case "string":case "number":g=!0;break;case "object":switch(a.$$typeof){case p:case q:g=!0;}}if(g)return d(c,a,""===b?"."+T(a,0):b), 1;g=0;b=""===b?".":b+":";if(Array.isArray(a))for(var h=0;h<a.length;h++){e=a[h];var f=b+T(e,h);g+=S(e,f,d,c);}else if(null===a||"object"!==typeof a?f=null:(f=A&&a[A]||a["@@iterator"], f="function"===typeof f?f:null), "function"===typeof f)for(a=f.call(a), h=
	0;!(e=a.next()).done;)e=e.value, f=b+T(e,h++), g+=S(e,f,d,c);else"object"===e&&(d=""+a, B("31","[object Object]"===d?"object with keys {"+Object.keys(a).join(", ")+"}":d,""));return g}function U(a,b,d){return null==a?0:S(a,"",b,d)}function T(a,b){return"object"===typeof a&&null!==a&&null!=a.key?escape(a.key):b.toString(36)}function ea(a,b){a.func.call(a.context,b,a.count++);}
	function fa(a,b,d){var c=a.result,e=a.keyPrefix;a=a.func.call(a.context,b,a.count++);Array.isArray(a)?V(a,c,d,function(a){return a}):null!=a&&(N(a)&&(a=da(a,e+(!a.key||b&&b.key===a.key?"":(""+a.key).replace(O,"$&/")+"/")+d)), c.push(a));}function V(a,b,d,c,e){var g="";null!=d&&(g=(""+d).replace(O,"$&/")+"/");b=Q(b,g,c,e);U(a,fa,b);R(b);}function W(){var a=I.current;null===a?B("321"):void 0;return a}
	var X={Children:{map:function(a,b,d){if(null==a)return a;var c=[];V(a,c,null,b,d);return c},forEach:function(a,b,d){if(null==a)return a;b=Q(null,null,b,d);U(a,ea,b);R(b);},count:function(a){return U(a,function(){return null},null)},toArray:function(a){var b=[];V(a,b,null,function(a){return a});return b},only:function(a){N(a)?void 0:B("143");return a}},createRef:function(){return{current:null}},Component:E,PureComponent:G,createContext:function(a,b){void 0===b&&(b=null);a={$$typeof:w,_calculateChangedBits:b,
	_currentValue:a,_currentValue2:a,_threadCount:0,Provider:null,Consumer:null};a.Provider={$$typeof:v,_context:a};return a.Consumer=a},forwardRef:function(a){return{$$typeof:y,render:a}},lazy:function(a){return{$$typeof:ba,_ctor:a,_status:-1,_result:null}},memo:function(a,b){return{$$typeof:aa,type:a,compare:void 0===b?null:b}},useCallback:function(a,b){return W().useCallback(a,b)},useContext:function(a,b){return W().useContext(a,b)},useEffect:function(a,b){return W().useEffect(a,b)},useImperativeHandle:function(a,
	b,d){return W().useImperativeHandle(a,b,d)},useDebugValue:function(){},useLayoutEffect:function(a,b){return W().useLayoutEffect(a,b)},useMemo:function(a,b){return W().useMemo(a,b)},useReducer:function(a,b,d){return W().useReducer(a,b,d)},useRef:function(a){return W().useRef(a)},useState:function(a){return W().useState(a)},Fragment:r,StrictMode:t,Suspense:z,createElement:M,cloneElement:function(a,b,d){null===a||void 0===a?B("267",a):void 0;var c=void 0,e=objectAssign({},a.props),g=a.key,h=a.ref,f=a._owner;if(null!=
	b){void 0!==b.ref&&(h=b.ref, f=J.current);void 0!==b.key&&(g=""+b.key);var l=void 0;a.type&&a.type.defaultProps&&(l=a.type.defaultProps);for(c in b)K.call(b,c)&&!L.hasOwnProperty(c)&&(e[c]=void 0===b[c]&&void 0!==l?l[c]:b[c]);}c=arguments.length-2;if(1===c)e.children=d;else if(1<c){l=Array(c);for(var m=0;m<c;m++)l[m]=arguments[m+2];e.children=l;}return{$$typeof:p,type:a.type,key:g,ref:h,props:e,_owner:f}},createFactory:function(a){var b=M.bind(null,a);b.type=a;return b},isValidElement:N,version:"16.8.6",
	unstable_ConcurrentMode:x,unstable_Profiler:u,__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED:{ReactCurrentDispatcher:I,ReactCurrentOwner:J,assign:objectAssign}},Y={default:X},Z=Y&&X||Y;var react_production_min=Z.default||Z;

	/**
	 * Copyright (c) 2013-present, Facebook, Inc.
	 *
	 * This source code is licensed under the MIT license found in the
	 * LICENSE file in the root directory of this source tree.
	 */

	var react_development = createCommonjsModule(function (module) {
	});

	var react = createCommonjsModule(function (module) {

	{
	  module.exports = react_production_min;
	}
	});

	var scheduler_production_min = createCommonjsModule(function (module, exports) {
	Object.defineProperty(exports,"__esModule",{value:!0});var d=null,e=!1,g=3,k=-1,l=-1,m=!1,n=!1;function p(){if(!m){var a=d.expirationTime;n?q():n=!0;r(t,a);}}
	function u(){var a=d,b=d.next;if(d===b)d=null;else{var c=d.previous;d=c.next=b;b.previous=c;}a.next=a.previous=null;c=a.callback;b=a.expirationTime;a=a.priorityLevel;var f=g,Q=l;g=a;l=b;try{var h=c();}finally{g=f, l=Q;}if("function"===typeof h)if(h={callback:h,priorityLevel:a,expirationTime:b,next:null,previous:null}, null===d)d=h.next=h.previous=h;else{c=null;a=d;do{if(a.expirationTime>=b){c=a;break}a=a.next;}while(a!==d);null===c?c=d:c===d&&(d=h, p());b=c.previous;b.next=c.previous=h;h.next=c;h.previous=
	b;}}function v(){if(-1===k&&null!==d&&1===d.priorityLevel){m=!0;try{do u();while(null!==d&&1===d.priorityLevel)}finally{m=!1, null!==d?p():n=!1;}}}function t(a){m=!0;var b=e;e=a;try{if(a)for(;null!==d;){var c=exports.unstable_now();if(d.expirationTime<=c){do u();while(null!==d&&d.expirationTime<=c)}else break}else if(null!==d){do u();while(null!==d&&!w())}}finally{m=!1, e=b, null!==d?p():n=!1, v();}}
	var x=Date,y="function"===typeof setTimeout?setTimeout:void 0,z="function"===typeof clearTimeout?clearTimeout:void 0,A="function"===typeof requestAnimationFrame?requestAnimationFrame:void 0,B="function"===typeof cancelAnimationFrame?cancelAnimationFrame:void 0,C,D;function E(a){C=A(function(b){z(D);a(b);});D=y(function(){B(C);a(exports.unstable_now());},100);}
	if("object"===typeof performance&&"function"===typeof performance.now){var F=performance;exports.unstable_now=function(){return F.now()};}else exports.unstable_now=function(){return x.now()};var r,q,w,G=null;"undefined"!==typeof window?G=window:"undefined"!==typeof commonjsGlobal&&(G=commonjsGlobal);
	if(G&&G._schedMock){var H=G._schedMock;r=H[0];q=H[1];w=H[2];exports.unstable_now=H[3];}else if("undefined"===typeof window||"function"!==typeof MessageChannel){var I=null,J=function(a){if(null!==I)try{I(a);}finally{I=null;}};r=function(a){null!==I?setTimeout(r,0,a):(I=a, setTimeout(J,0,!1));};q=function(){I=null;};w=function(){return!1};}else{"undefined"!==typeof console&&("function"!==typeof A&&console.error("This browser doesn't support requestAnimationFrame. Make sure that you load a polyfill in older browsers. https://fb.me/react-polyfills"), "function"!==typeof B&&console.error("This browser doesn't support cancelAnimationFrame. Make sure that you load a polyfill in older browsers. https://fb.me/react-polyfills"));var K=null,L=!1,M=-1,N=!1,O=!1,P=0,R=33,S=33;w=function(){return P<=exports.unstable_now()};var T=new MessageChannel,U=T.port2;T.port1.onmessage=function(){L=!1;var a=K,b=M;K=null;M=-1;var c=exports.unstable_now(),f=!1;if(0>=P-c)if(-1!==b&&b<=c)f=!0;else{N||(N=!0, E(V));K=a;M=b;return}if(null!==a){O=!0;try{a(f);}finally{O=!1;}}};
	var V=function(a){if(null!==K){E(V);var b=a-P+S;b<S&&R<S?(8>b&&(b=8), S=b<R?R:b):R=b;P=a+S;L||(L=!0, U.postMessage(void 0));}else N=!1;};r=function(a,b){K=a;M=b;O||0>b?U.postMessage(void 0):N||(N=!0, E(V));};q=function(){K=null;L=!1;M=-1;};}exports.unstable_ImmediatePriority=1;exports.unstable_UserBlockingPriority=2;exports.unstable_NormalPriority=3;exports.unstable_IdlePriority=5;exports.unstable_LowPriority=4;
	exports.unstable_runWithPriority=function(a,b){switch(a){case 1:case 2:case 3:case 4:case 5:break;default:a=3;}var c=g,f=k;g=a;k=exports.unstable_now();try{return b()}finally{g=c, k=f, v();}};exports.unstable_next=function(a){switch(g){case 1:case 2:case 3:var b=3;break;default:b=g;}var c=g,f=k;g=b;k=exports.unstable_now();try{return a()}finally{g=c, k=f, v();}};
	exports.unstable_scheduleCallback=function(a,b){var c=-1!==k?k:exports.unstable_now();if("object"===typeof b&&null!==b&&"number"===typeof b.timeout)b=c+b.timeout;else switch(g){case 1:b=c+-1;break;case 2:b=c+250;break;case 5:b=c+1073741823;break;case 4:b=c+1E4;break;default:b=c+5E3;}a={callback:a,priorityLevel:g,expirationTime:b,next:null,previous:null};if(null===d)d=a.next=a.previous=a, p();else{c=null;var f=d;do{if(f.expirationTime>b){c=f;break}f=f.next;}while(f!==d);null===c?c=d:c===d&&(d=a, p());
	b=c.previous;b.next=c.previous=a;a.next=c;a.previous=b;}return a};exports.unstable_cancelCallback=function(a){var b=a.next;if(null!==b){if(b===a)d=null;else{a===d&&(d=b);var c=a.previous;c.next=b;b.previous=c;}a.next=a.previous=null;}};exports.unstable_wrapCallback=function(a){var b=g;return function(){var c=g,f=k;g=b;k=exports.unstable_now();try{return a.apply(this,arguments)}finally{g=c, k=f, v();}}};exports.unstable_getCurrentPriorityLevel=function(){return g};
	exports.unstable_shouldYield=function(){return!e&&(null!==d&&d.expirationTime<l||w())};exports.unstable_continueExecution=function(){null!==d&&p();};exports.unstable_pauseExecution=function(){};exports.unstable_getFirstCallbackNode=function(){return d};
	});

	unwrapExports(scheduler_production_min);
	var scheduler_production_min_1 = scheduler_production_min.unstable_now;
	var scheduler_production_min_2 = scheduler_production_min.unstable_ImmediatePriority;
	var scheduler_production_min_3 = scheduler_production_min.unstable_UserBlockingPriority;
	var scheduler_production_min_4 = scheduler_production_min.unstable_NormalPriority;
	var scheduler_production_min_5 = scheduler_production_min.unstable_IdlePriority;
	var scheduler_production_min_6 = scheduler_production_min.unstable_LowPriority;
	var scheduler_production_min_7 = scheduler_production_min.unstable_runWithPriority;
	var scheduler_production_min_8 = scheduler_production_min.unstable_next;
	var scheduler_production_min_9 = scheduler_production_min.unstable_scheduleCallback;
	var scheduler_production_min_10 = scheduler_production_min.unstable_cancelCallback;
	var scheduler_production_min_11 = scheduler_production_min.unstable_wrapCallback;
	var scheduler_production_min_12 = scheduler_production_min.unstable_getCurrentPriorityLevel;
	var scheduler_production_min_13 = scheduler_production_min.unstable_shouldYield;
	var scheduler_production_min_14 = scheduler_production_min.unstable_continueExecution;
	var scheduler_production_min_15 = scheduler_production_min.unstable_pauseExecution;
	var scheduler_production_min_16 = scheduler_production_min.unstable_getFirstCallbackNode;

	var scheduler_development = createCommonjsModule(function (module, exports) {
	});

	unwrapExports(scheduler_development);
	var scheduler_development_1 = scheduler_development.unstable_now;
	var scheduler_development_2 = scheduler_development.unstable_ImmediatePriority;
	var scheduler_development_3 = scheduler_development.unstable_UserBlockingPriority;
	var scheduler_development_4 = scheduler_development.unstable_NormalPriority;
	var scheduler_development_5 = scheduler_development.unstable_IdlePriority;
	var scheduler_development_6 = scheduler_development.unstable_LowPriority;
	var scheduler_development_7 = scheduler_development.unstable_runWithPriority;
	var scheduler_development_8 = scheduler_development.unstable_next;
	var scheduler_development_9 = scheduler_development.unstable_scheduleCallback;
	var scheduler_development_10 = scheduler_development.unstable_cancelCallback;
	var scheduler_development_11 = scheduler_development.unstable_wrapCallback;
	var scheduler_development_12 = scheduler_development.unstable_getCurrentPriorityLevel;
	var scheduler_development_13 = scheduler_development.unstable_shouldYield;
	var scheduler_development_14 = scheduler_development.unstable_continueExecution;
	var scheduler_development_15 = scheduler_development.unstable_pauseExecution;
	var scheduler_development_16 = scheduler_development.unstable_getFirstCallbackNode;

	var scheduler = createCommonjsModule(function (module) {

	{
	  module.exports = scheduler_production_min;
	}
	});

	function ba$1(a,b,c,d,e,f,g,h){if(!a){a=void 0;if(void 0===b)a=Error("Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.");else{var l=[c,d,e,f,g,h],k=0;a=Error(b.replace(/%s/g,function(){return l[k++]}));a.name="Invariant Violation";}a.framesToPop=1;throw a;}}
	function x$1(a){for(var b=arguments.length-1,c="https://reactjs.org/docs/error-decoder.html?invariant="+a,d=0;d<b;d++)c+="&args[]="+encodeURIComponent(arguments[d+1]);ba$1(!1,"Minified React error #"+a+"; visit %s for the full message or use the non-minified dev environment for full errors and additional helpful warnings. ",c);}react?void 0:x$1("227");function ca$1(a,b,c,d,e,f,g,h,l){var k=Array.prototype.slice.call(arguments,3);try{b.apply(c,k);}catch(m){this.onError(m);}}
	var da$1=!1,ea$1=null,fa$1=!1,ha=null,ia={onError:function(a){da$1=!0;ea$1=a;}};function ja(a,b,c,d,e,f,g,h,l){da$1=!1;ea$1=null;ca$1.apply(ia,arguments);}function ka(a,b,c,d,e,f,g,h,l){ja.apply(this,arguments);if(da$1){if(da$1){var k=ea$1;da$1=!1;ea$1=null;}else x$1("198"), k=void 0;fa$1||(fa$1=!0, ha=k);}}var la=null,ma={};
	function na(){if(la)for(var a in ma){var b=ma[a],c=la.indexOf(a);-1<c?void 0:x$1("96",a);if(!oa[c]){b.extractEvents?void 0:x$1("97",a);oa[c]=b;c=b.eventTypes;for(var d in c){var e=void 0;var f=c[d],g=b,h=d;pa.hasOwnProperty(h)?x$1("99",h):void 0;pa[h]=f;var l=f.phasedRegistrationNames;if(l){for(e in l)l.hasOwnProperty(e)&&qa(l[e],g,h);e=!0;}else f.registrationName?(qa(f.registrationName,g,h), e=!0):e=!1;e?void 0:x$1("98",d,a);}}}}
	function qa(a,b,c){ra[a]?x$1("100",a):void 0;ra[a]=b;sa[a]=b.eventTypes[c].dependencies;}var oa=[],pa={},ra={},sa={},ta=null,ua=null,va=null;function wa(a,b,c){var d=a.type||"unknown-event";a.currentTarget=va(c);ka(d,b,void 0,a);a.currentTarget=null;}function xa(a,b){null==b?x$1("30"):void 0;if(null==a)return b;if(Array.isArray(a)){if(Array.isArray(b))return a.push.apply(a,b), a;a.push(b);return a}return Array.isArray(b)?[a].concat(b):[a,b]}
	function ya(a,b,c){Array.isArray(a)?a.forEach(b,c):a&&b.call(c,a);}var za=null;function Aa(a){if(a){var b=a._dispatchListeners,c=a._dispatchInstances;if(Array.isArray(b))for(var d=0;d<b.length&&!a.isPropagationStopped();d++)wa(a,b[d],c[d]);else b&&wa(a,b,c);a._dispatchListeners=null;a._dispatchInstances=null;a.isPersistent()||a.constructor.release(a);}}
	var Ba={injectEventPluginOrder:function(a){la?x$1("101"):void 0;la=Array.prototype.slice.call(a);na();},injectEventPluginsByName:function(a){var b=!1,c;for(c in a)if(a.hasOwnProperty(c)){var d=a[c];ma.hasOwnProperty(c)&&ma[c]===d||(ma[c]?x$1("102",c):void 0, ma[c]=d, b=!0);}b&&na();}};
	function Ca(a,b){var c=a.stateNode;if(!c)return null;var d=ta(c);if(!d)return null;c=d[b];a:switch(b){case "onClick":case "onClickCapture":case "onDoubleClick":case "onDoubleClickCapture":case "onMouseDown":case "onMouseDownCapture":case "onMouseMove":case "onMouseMoveCapture":case "onMouseUp":case "onMouseUpCapture":(d=!d.disabled)||(a=a.type, d=!("button"===a||"input"===a||"select"===a||"textarea"===a));a=!d;break a;default:a=!1;}if(a)return null;c&&"function"!==typeof c?x$1("231",b,typeof c):void 0;
	return c}function Da(a){null!==a&&(za=xa(za,a));a=za;za=null;if(a&&(ya(a,Aa), za?x$1("95"):void 0, fa$1))throw a=ha, fa$1=!1, ha=null, a;}var Ea=Math.random().toString(36).slice(2),Fa="__reactInternalInstance$"+Ea,Ga="__reactEventHandlers$"+Ea;function Ha(a){if(a[Fa])return a[Fa];for(;!a[Fa];)if(a.parentNode)a=a.parentNode;else return null;a=a[Fa];return 5===a.tag||6===a.tag?a:null}function Ia(a){a=a[Fa];return!a||5!==a.tag&&6!==a.tag?null:a}
	function Ja(a){if(5===a.tag||6===a.tag)return a.stateNode;x$1("33");}function Ka(a){return a[Ga]||null}function La(a){do a=a.return;while(a&&5!==a.tag);return a?a:null}function Ma(a,b,c){if(b=Ca(a,c.dispatchConfig.phasedRegistrationNames[b]))c._dispatchListeners=xa(c._dispatchListeners,b), c._dispatchInstances=xa(c._dispatchInstances,a);}
	function Na(a){if(a&&a.dispatchConfig.phasedRegistrationNames){for(var b=a._targetInst,c=[];b;)c.push(b), b=La(b);for(b=c.length;0<b--;)Ma(c[b],"captured",a);for(b=0;b<c.length;b++)Ma(c[b],"bubbled",a);}}function Oa(a,b,c){a&&c&&c.dispatchConfig.registrationName&&(b=Ca(a,c.dispatchConfig.registrationName))&&(c._dispatchListeners=xa(c._dispatchListeners,b), c._dispatchInstances=xa(c._dispatchInstances,a));}function Pa(a){a&&a.dispatchConfig.registrationName&&Oa(a._targetInst,null,a);}
	function Qa(a){ya(a,Na);}var Ra=!("undefined"===typeof window||!window.document||!window.document.createElement);function Sa(a,b){var c={};c[a.toLowerCase()]=b.toLowerCase();c["Webkit"+a]="webkit"+b;c["Moz"+a]="moz"+b;return c}var Ta={animationend:Sa("Animation","AnimationEnd"),animationiteration:Sa("Animation","AnimationIteration"),animationstart:Sa("Animation","AnimationStart"),transitionend:Sa("Transition","TransitionEnd")},Ua={},Va={};
	Ra&&(Va=document.createElement("div").style, "AnimationEvent"in window||(delete Ta.animationend.animation, delete Ta.animationiteration.animation, delete Ta.animationstart.animation), "TransitionEvent"in window||delete Ta.transitionend.transition);function Wa(a){if(Ua[a])return Ua[a];if(!Ta[a])return a;var b=Ta[a],c;for(c in b)if(b.hasOwnProperty(c)&&c in Va)return Ua[a]=b[c];return a}
	var Xa=Wa("animationend"),Ya=Wa("animationiteration"),Za=Wa("animationstart"),$a=Wa("transitionend"),ab="abort canplay canplaythrough durationchange emptied encrypted ended error loadeddata loadedmetadata loadstart pause play playing progress ratechange seeked seeking stalled suspend timeupdate volumechange waiting".split(" "),bb=null,cb=null,db=null;
	function eb(){if(db)return db;var a,b=cb,c=b.length,d,e="value"in bb?bb.value:bb.textContent,f=e.length;for(a=0;a<c&&b[a]===e[a];a++);var g=c-a;for(d=1;d<=g&&b[c-d]===e[f-d];d++);return db=e.slice(a,1<d?1-d:void 0)}function fb(){return!0}function gb(){return!1}
	function y$1(a,b,c,d){this.dispatchConfig=a;this._targetInst=b;this.nativeEvent=c;a=this.constructor.Interface;for(var e in a)a.hasOwnProperty(e)&&((b=a[e])?this[e]=b(c):"target"===e?this.target=d:this[e]=c[e]);this.isDefaultPrevented=(null!=c.defaultPrevented?c.defaultPrevented:!1===c.returnValue)?fb:gb;this.isPropagationStopped=gb;return this}
	objectAssign(y$1.prototype,{preventDefault:function(){this.defaultPrevented=!0;var a=this.nativeEvent;a&&(a.preventDefault?a.preventDefault():"unknown"!==typeof a.returnValue&&(a.returnValue=!1), this.isDefaultPrevented=fb);},stopPropagation:function(){var a=this.nativeEvent;a&&(a.stopPropagation?a.stopPropagation():"unknown"!==typeof a.cancelBubble&&(a.cancelBubble=!0), this.isPropagationStopped=fb);},persist:function(){this.isPersistent=fb;},isPersistent:gb,destructor:function(){var a=this.constructor.Interface,
	b;for(b in a)this[b]=null;this.nativeEvent=this._targetInst=this.dispatchConfig=null;this.isPropagationStopped=this.isDefaultPrevented=gb;this._dispatchInstances=this._dispatchListeners=null;}});y$1.Interface={type:null,target:null,currentTarget:function(){return null},eventPhase:null,bubbles:null,cancelable:null,timeStamp:function(a){return a.timeStamp||Date.now()},defaultPrevented:null,isTrusted:null};
	y$1.extend=function(a){function b(){}function c(){return d.apply(this,arguments)}var d=this;b.prototype=d.prototype;var e=new b;objectAssign(e,c.prototype);c.prototype=e;c.prototype.constructor=c;c.Interface=objectAssign({},d.Interface,a);c.extend=d.extend;hb(c);return c};hb(y$1);function ib(a,b,c,d){if(this.eventPool.length){var e=this.eventPool.pop();this.call(e,a,b,c,d);return e}return new this(a,b,c,d)}function jb(a){a instanceof this?void 0:x$1("279");a.destructor();10>this.eventPool.length&&this.eventPool.push(a);}
	function hb(a){a.eventPool=[];a.getPooled=ib;a.release=jb;}var kb=y$1.extend({data:null}),lb=y$1.extend({data:null}),mb=[9,13,27,32],nb=Ra&&"CompositionEvent"in window,ob=null;Ra&&"documentMode"in document&&(ob=document.documentMode);
	var pb=Ra&&"TextEvent"in window&&!ob,qb=Ra&&(!nb||ob&&8<ob&&11>=ob),rb=String.fromCharCode(32),sb={beforeInput:{phasedRegistrationNames:{bubbled:"onBeforeInput",captured:"onBeforeInputCapture"},dependencies:["compositionend","keypress","textInput","paste"]},compositionEnd:{phasedRegistrationNames:{bubbled:"onCompositionEnd",captured:"onCompositionEndCapture"},dependencies:"blur compositionend keydown keypress keyup mousedown".split(" ")},compositionStart:{phasedRegistrationNames:{bubbled:"onCompositionStart",
	captured:"onCompositionStartCapture"},dependencies:"blur compositionstart keydown keypress keyup mousedown".split(" ")},compositionUpdate:{phasedRegistrationNames:{bubbled:"onCompositionUpdate",captured:"onCompositionUpdateCapture"},dependencies:"blur compositionupdate keydown keypress keyup mousedown".split(" ")}},tb=!1;
	function ub(a,b){switch(a){case "keyup":return-1!==mb.indexOf(b.keyCode);case "keydown":return 229!==b.keyCode;case "keypress":case "mousedown":case "blur":return!0;default:return!1}}function vb(a){a=a.detail;return"object"===typeof a&&"data"in a?a.data:null}var wb=!1;function xb(a,b){switch(a){case "compositionend":return vb(b);case "keypress":if(32!==b.which)return null;tb=!0;return rb;case "textInput":return a=b.data, a===rb&&tb?null:a;default:return null}}
	function yb(a,b){if(wb)return"compositionend"===a||!nb&&ub(a,b)?(a=eb(), db=cb=bb=null, wb=!1, a):null;switch(a){case "paste":return null;case "keypress":if(!(b.ctrlKey||b.altKey||b.metaKey)||b.ctrlKey&&b.altKey){if(b.char&&1<b.char.length)return b.char;if(b.which)return String.fromCharCode(b.which)}return null;case "compositionend":return qb&&"ko"!==b.locale?null:b.data;default:return null}}
	var zb={eventTypes:sb,extractEvents:function(a,b,c,d){var e=void 0;var f=void 0;if(nb)b:{switch(a){case "compositionstart":e=sb.compositionStart;break b;case "compositionend":e=sb.compositionEnd;break b;case "compositionupdate":e=sb.compositionUpdate;break b}e=void 0;}else wb?ub(a,c)&&(e=sb.compositionEnd):"keydown"===a&&229===c.keyCode&&(e=sb.compositionStart);e?(qb&&"ko"!==c.locale&&(wb||e!==sb.compositionStart?e===sb.compositionEnd&&wb&&(f=eb()):(bb=d, cb="value"in bb?bb.value:bb.textContent, wb=
	!0)), e=kb.getPooled(e,b,c,d), f?e.data=f:(f=vb(c), null!==f&&(e.data=f)), Qa(e), f=e):f=null;(a=pb?xb(a,c):yb(a,c))?(b=lb.getPooled(sb.beforeInput,b,c,d), b.data=a, Qa(b)):b=null;return null===f?b:null===b?f:[f,b]}},Ab=null,Bb=null,Cb=null;function Db(a){if(a=ua(a)){"function"!==typeof Ab?x$1("280"):void 0;var b=ta(a.stateNode);Ab(a.stateNode,a.type,b);}}function Eb(a){Bb?Cb?Cb.push(a):Cb=[a]:Bb=a;}function Fb(){if(Bb){var a=Bb,b=Cb;Cb=Bb=null;Db(a);if(b)for(a=0;a<b.length;a++)Db(b[a]);}}
	function Gb(a,b){return a(b)}function Hb(a,b,c){return a(b,c)}function Ib(){}var Jb=!1;function Kb(a,b){if(Jb)return a(b);Jb=!0;try{return Gb(a,b)}finally{if(Jb=!1, null!==Bb||null!==Cb)Ib(), Fb();}}var Lb={color:!0,date:!0,datetime:!0,"datetime-local":!0,email:!0,month:!0,number:!0,password:!0,range:!0,search:!0,tel:!0,text:!0,time:!0,url:!0,week:!0};function Mb(a){var b=a&&a.nodeName&&a.nodeName.toLowerCase();return"input"===b?!!Lb[a.type]:"textarea"===b?!0:!1}
	function Nb(a){a=a.target||a.srcElement||window;a.correspondingUseElement&&(a=a.correspondingUseElement);return 3===a.nodeType?a.parentNode:a}function Ob(a){if(!Ra)return!1;a="on"+a;var b=a in document;b||(b=document.createElement("div"), b.setAttribute(a,"return;"), b="function"===typeof b[a]);return b}function Pb(a){var b=a.type;return(a=a.nodeName)&&"input"===a.toLowerCase()&&("checkbox"===b||"radio"===b)}
	function Qb(a){var b=Pb(a)?"checked":"value",c=Object.getOwnPropertyDescriptor(a.constructor.prototype,b),d=""+a[b];if(!a.hasOwnProperty(b)&&"undefined"!==typeof c&&"function"===typeof c.get&&"function"===typeof c.set){var e=c.get,f=c.set;Object.defineProperty(a,b,{configurable:!0,get:function(){return e.call(this)},set:function(a){d=""+a;f.call(this,a);}});Object.defineProperty(a,b,{enumerable:c.enumerable});return{getValue:function(){return d},setValue:function(a){d=""+a;},stopTracking:function(){a._valueTracker=
	null;delete a[b];}}}}function Rb(a){a._valueTracker||(a._valueTracker=Qb(a));}function Sb(a){if(!a)return!1;var b=a._valueTracker;if(!b)return!0;var c=b.getValue();var d="";a&&(d=Pb(a)?a.checked?"true":"false":a.value);a=d;return a!==c?(b.setValue(a), !0):!1}var Tb=react.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED;Tb.hasOwnProperty("ReactCurrentDispatcher")||(Tb.ReactCurrentDispatcher={current:null});
	var Ub=/^(.*)[\\\/]/,z$1="function"===typeof Symbol&&Symbol.for,Vb=z$1?Symbol.for("react.element"):60103,Wb=z$1?Symbol.for("react.portal"):60106,Xb=z$1?Symbol.for("react.fragment"):60107,Yb=z$1?Symbol.for("react.strict_mode"):60108,Zb=z$1?Symbol.for("react.profiler"):60114,$b=z$1?Symbol.for("react.provider"):60109,ac=z$1?Symbol.for("react.context"):60110,bc=z$1?Symbol.for("react.concurrent_mode"):60111,cc=z$1?Symbol.for("react.forward_ref"):60112,dc=z$1?Symbol.for("react.suspense"):60113,ec=z$1?Symbol.for("react.memo"):
	60115,fc=z$1?Symbol.for("react.lazy"):60116,gc="function"===typeof Symbol&&Symbol.iterator;function hc(a){if(null===a||"object"!==typeof a)return null;a=gc&&a[gc]||a["@@iterator"];return"function"===typeof a?a:null}
	function ic(a){if(null==a)return null;if("function"===typeof a)return a.displayName||a.name||null;if("string"===typeof a)return a;switch(a){case bc:return"ConcurrentMode";case Xb:return"Fragment";case Wb:return"Portal";case Zb:return"Profiler";case Yb:return"StrictMode";case dc:return"Suspense"}if("object"===typeof a)switch(a.$$typeof){case ac:return"Context.Consumer";case $b:return"Context.Provider";case cc:var b=a.render;b=b.displayName||b.name||"";return a.displayName||(""!==b?"ForwardRef("+b+
	")":"ForwardRef");case ec:return ic(a.type);case fc:if(a=1===a._status?a._result:null)return ic(a)}return null}function jc(a){var b="";do{a:switch(a.tag){case 3:case 4:case 6:case 7:case 10:case 9:var c="";break a;default:var d=a._debugOwner,e=a._debugSource,f=ic(a.type);c=null;d&&(c=ic(d.type));d=f;f="";e?f=" (at "+e.fileName.replace(Ub,"")+":"+e.lineNumber+")":c&&(f=" (created by "+c+")");c="\n    in "+(d||"Unknown")+f;}b+=c;a=a.return;}while(a);return b}
	var kc=/^[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\-.0-9\u00B7\u0300-\u036F\u203F-\u2040]*$/,lc=Object.prototype.hasOwnProperty,mc={},nc={};
	function oc(a){if(lc.call(nc,a))return!0;if(lc.call(mc,a))return!1;if(kc.test(a))return nc[a]=!0;mc[a]=!0;return!1}function pc(a,b,c,d){if(null!==c&&0===c.type)return!1;switch(typeof b){case "function":case "symbol":return!0;case "boolean":if(d)return!1;if(null!==c)return!c.acceptsBooleans;a=a.toLowerCase().slice(0,5);return"data-"!==a&&"aria-"!==a;default:return!1}}
	function qc(a,b,c,d){if(null===b||"undefined"===typeof b||pc(a,b,c,d))return!0;if(d)return!1;if(null!==c)switch(c.type){case 3:return!b;case 4:return!1===b;case 5:return isNaN(b);case 6:return isNaN(b)||1>b}return!1}function C$1(a,b,c,d,e){this.acceptsBooleans=2===b||3===b||4===b;this.attributeName=d;this.attributeNamespace=e;this.mustUseProperty=c;this.propertyName=a;this.type=b;}var D$1={};
	"children dangerouslySetInnerHTML defaultValue defaultChecked innerHTML suppressContentEditableWarning suppressHydrationWarning style".split(" ").forEach(function(a){D$1[a]=new C$1(a,0,!1,a,null);});[["acceptCharset","accept-charset"],["className","class"],["htmlFor","for"],["httpEquiv","http-equiv"]].forEach(function(a){var b=a[0];D$1[b]=new C$1(b,1,!1,a[1],null);});["contentEditable","draggable","spellCheck","value"].forEach(function(a){D$1[a]=new C$1(a,2,!1,a.toLowerCase(),null);});
	["autoReverse","externalResourcesRequired","focusable","preserveAlpha"].forEach(function(a){D$1[a]=new C$1(a,2,!1,a,null);});"allowFullScreen async autoFocus autoPlay controls default defer disabled formNoValidate hidden loop noModule noValidate open playsInline readOnly required reversed scoped seamless itemScope".split(" ").forEach(function(a){D$1[a]=new C$1(a,3,!1,a.toLowerCase(),null);});["checked","multiple","muted","selected"].forEach(function(a){D$1[a]=new C$1(a,3,!0,a,null);});
	["capture","download"].forEach(function(a){D$1[a]=new C$1(a,4,!1,a,null);});["cols","rows","size","span"].forEach(function(a){D$1[a]=new C$1(a,6,!1,a,null);});["rowSpan","start"].forEach(function(a){D$1[a]=new C$1(a,5,!1,a.toLowerCase(),null);});var rc=/[\-:]([a-z])/g;function sc(a){return a[1].toUpperCase()}
	"accent-height alignment-baseline arabic-form baseline-shift cap-height clip-path clip-rule color-interpolation color-interpolation-filters color-profile color-rendering dominant-baseline enable-background fill-opacity fill-rule flood-color flood-opacity font-family font-size font-size-adjust font-stretch font-style font-variant font-weight glyph-name glyph-orientation-horizontal glyph-orientation-vertical horiz-adv-x horiz-origin-x image-rendering letter-spacing lighting-color marker-end marker-mid marker-start overline-position overline-thickness paint-order panose-1 pointer-events rendering-intent shape-rendering stop-color stop-opacity strikethrough-position strikethrough-thickness stroke-dasharray stroke-dashoffset stroke-linecap stroke-linejoin stroke-miterlimit stroke-opacity stroke-width text-anchor text-decoration text-rendering underline-position underline-thickness unicode-bidi unicode-range units-per-em v-alphabetic v-hanging v-ideographic v-mathematical vector-effect vert-adv-y vert-origin-x vert-origin-y word-spacing writing-mode xmlns:xlink x-height".split(" ").forEach(function(a){var b=a.replace(rc,
	sc);D$1[b]=new C$1(b,1,!1,a,null);});"xlink:actuate xlink:arcrole xlink:href xlink:role xlink:show xlink:title xlink:type".split(" ").forEach(function(a){var b=a.replace(rc,sc);D$1[b]=new C$1(b,1,!1,a,"http://www.w3.org/1999/xlink");});["xml:base","xml:lang","xml:space"].forEach(function(a){var b=a.replace(rc,sc);D$1[b]=new C$1(b,1,!1,a,"http://www.w3.org/XML/1998/namespace");});["tabIndex","crossOrigin"].forEach(function(a){D$1[a]=new C$1(a,1,!1,a.toLowerCase(),null);});
	function tc(a,b,c,d){var e=D$1.hasOwnProperty(b)?D$1[b]:null;var f=null!==e?0===e.type:d?!1:!(2<b.length)||"o"!==b[0]&&"O"!==b[0]||"n"!==b[1]&&"N"!==b[1]?!1:!0;f||(qc(b,c,e,d)&&(c=null), d||null===e?oc(b)&&(null===c?a.removeAttribute(b):a.setAttribute(b,""+c)):e.mustUseProperty?a[e.propertyName]=null===c?3===e.type?!1:"":c:(b=e.attributeName, d=e.attributeNamespace, null===c?a.removeAttribute(b):(e=e.type, c=3===e||4===e&&!0===c?"":""+c, d?a.setAttributeNS(d,b,c):a.setAttribute(b,c))));}
	function uc(a){switch(typeof a){case "boolean":case "number":case "object":case "string":case "undefined":return a;default:return""}}function vc(a,b){var c=b.checked;return objectAssign({},b,{defaultChecked:void 0,defaultValue:void 0,value:void 0,checked:null!=c?c:a._wrapperState.initialChecked})}
	function wc(a,b){var c=null==b.defaultValue?"":b.defaultValue,d=null!=b.checked?b.checked:b.defaultChecked;c=uc(null!=b.value?b.value:c);a._wrapperState={initialChecked:d,initialValue:c,controlled:"checkbox"===b.type||"radio"===b.type?null!=b.checked:null!=b.value};}function xc(a,b){b=b.checked;null!=b&&tc(a,"checked",b,!1);}
	function yc(a,b){xc(a,b);var c=uc(b.value),d=b.type;if(null!=c)if("number"===d){if(0===c&&""===a.value||a.value!=c)a.value=""+c;}else a.value!==""+c&&(a.value=""+c);else if("submit"===d||"reset"===d){a.removeAttribute("value");return}b.hasOwnProperty("value")?zc(a,b.type,c):b.hasOwnProperty("defaultValue")&&zc(a,b.type,uc(b.defaultValue));null==b.checked&&null!=b.defaultChecked&&(a.defaultChecked=!!b.defaultChecked);}
	function Ac(a,b,c){if(b.hasOwnProperty("value")||b.hasOwnProperty("defaultValue")){var d=b.type;if(!("submit"!==d&&"reset"!==d||void 0!==b.value&&null!==b.value))return;b=""+a._wrapperState.initialValue;c||b===a.value||(a.value=b);a.defaultValue=b;}c=a.name;""!==c&&(a.name="");a.defaultChecked=!a.defaultChecked;a.defaultChecked=!!a._wrapperState.initialChecked;""!==c&&(a.name=c);}
	function zc(a,b,c){if("number"!==b||a.ownerDocument.activeElement!==a)null==c?a.defaultValue=""+a._wrapperState.initialValue:a.defaultValue!==""+c&&(a.defaultValue=""+c);}var Bc={change:{phasedRegistrationNames:{bubbled:"onChange",captured:"onChangeCapture"},dependencies:"blur change click focus input keydown keyup selectionchange".split(" ")}};function Cc(a,b,c){a=y$1.getPooled(Bc.change,a,b,c);a.type="change";Eb(c);Qa(a);return a}var Dc=null,Ec=null;function Fc(a){Da(a);}
	function Gc(a){var b=Ja(a);if(Sb(b))return a}function Hc(a,b){if("change"===a)return b}var Ic=!1;Ra&&(Ic=Ob("input")&&(!document.documentMode||9<document.documentMode));function Jc(){Dc&&(Dc.detachEvent("onpropertychange",Kc), Ec=Dc=null);}function Kc(a){"value"===a.propertyName&&Gc(Ec)&&(a=Cc(Ec,a,Nb(a)), Kb(Fc,a));}function Lc(a,b,c){"focus"===a?(Jc(), Dc=b, Ec=c, Dc.attachEvent("onpropertychange",Kc)):"blur"===a&&Jc();}function Mc(a){if("selectionchange"===a||"keyup"===a||"keydown"===a)return Gc(Ec)}
	function Nc(a,b){if("click"===a)return Gc(b)}function Oc(a,b){if("input"===a||"change"===a)return Gc(b)}
	var Pc={eventTypes:Bc,_isInputEventSupported:Ic,extractEvents:function(a,b,c,d){var e=b?Ja(b):window,f=void 0,g=void 0,h=e.nodeName&&e.nodeName.toLowerCase();"select"===h||"input"===h&&"file"===e.type?f=Hc:Mb(e)?Ic?f=Oc:(f=Mc, g=Lc):(h=e.nodeName)&&"input"===h.toLowerCase()&&("checkbox"===e.type||"radio"===e.type)&&(f=Nc);if(f&&(f=f(a,b)))return Cc(f,c,d);g&&g(a,e,b);"blur"===a&&(a=e._wrapperState)&&a.controlled&&"number"===e.type&&zc(e,"number",e.value);}},Qc=y$1.extend({view:null,detail:null}),Rc={Alt:"altKey",
	Control:"ctrlKey",Meta:"metaKey",Shift:"shiftKey"};function Sc(a){var b=this.nativeEvent;return b.getModifierState?b.getModifierState(a):(a=Rc[a])?!!b[a]:!1}function Tc(){return Sc}
	var Uc=0,Vc=0,Wc=!1,Xc=!1,Yc=Qc.extend({screenX:null,screenY:null,clientX:null,clientY:null,pageX:null,pageY:null,ctrlKey:null,shiftKey:null,altKey:null,metaKey:null,getModifierState:Tc,button:null,buttons:null,relatedTarget:function(a){return a.relatedTarget||(a.fromElement===a.srcElement?a.toElement:a.fromElement)},movementX:function(a){if("movementX"in a)return a.movementX;var b=Uc;Uc=a.screenX;return Wc?"mousemove"===a.type?a.screenX-b:0:(Wc=!0, 0)},movementY:function(a){if("movementY"in a)return a.movementY;
	var b=Vc;Vc=a.screenY;return Xc?"mousemove"===a.type?a.screenY-b:0:(Xc=!0, 0)}}),Zc=Yc.extend({pointerId:null,width:null,height:null,pressure:null,tangentialPressure:null,tiltX:null,tiltY:null,twist:null,pointerType:null,isPrimary:null}),$c={mouseEnter:{registrationName:"onMouseEnter",dependencies:["mouseout","mouseover"]},mouseLeave:{registrationName:"onMouseLeave",dependencies:["mouseout","mouseover"]},pointerEnter:{registrationName:"onPointerEnter",dependencies:["pointerout","pointerover"]},pointerLeave:{registrationName:"onPointerLeave",
	dependencies:["pointerout","pointerover"]}},ad={eventTypes:$c,extractEvents:function(a,b,c,d){var e="mouseover"===a||"pointerover"===a,f="mouseout"===a||"pointerout"===a;if(e&&(c.relatedTarget||c.fromElement)||!f&&!e)return null;e=d.window===d?d:(e=d.ownerDocument)?e.defaultView||e.parentWindow:window;f?(f=b, b=(b=c.relatedTarget||c.toElement)?Ha(b):null):f=null;if(f===b)return null;var g=void 0,h=void 0,l=void 0,k=void 0;if("mouseout"===a||"mouseover"===a)g=Yc, h=$c.mouseLeave, l=$c.mouseEnter, k="mouse";
	else if("pointerout"===a||"pointerover"===a)g=Zc, h=$c.pointerLeave, l=$c.pointerEnter, k="pointer";var m=null==f?e:Ja(f);e=null==b?e:Ja(b);a=g.getPooled(h,f,c,d);a.type=k+"leave";a.target=m;a.relatedTarget=e;c=g.getPooled(l,b,c,d);c.type=k+"enter";c.target=e;c.relatedTarget=m;d=b;if(f&&d)a:{b=f;e=d;k=0;for(g=b;g;g=La(g))k++;g=0;for(l=e;l;l=La(l))g++;for(;0<k-g;)b=La(b), k--;for(;0<g-k;)e=La(e), g--;for(;k--;){if(b===e||b===e.alternate)break a;b=La(b);e=La(e);}b=null;}else b=null;e=b;for(b=[];f&&f!==e;){k=
	f.alternate;if(null!==k&&k===e)break;b.push(f);f=La(f);}for(f=[];d&&d!==e;){k=d.alternate;if(null!==k&&k===e)break;f.push(d);d=La(d);}for(d=0;d<b.length;d++)Oa(b[d],"bubbled",a);for(d=f.length;0<d--;)Oa(f[d],"captured",c);return[a,c]}};function bd(a,b){return a===b&&(0!==a||1/a===1/b)||a!==a&&b!==b}var cd=Object.prototype.hasOwnProperty;
	function dd(a,b){if(bd(a,b))return!0;if("object"!==typeof a||null===a||"object"!==typeof b||null===b)return!1;var c=Object.keys(a),d=Object.keys(b);if(c.length!==d.length)return!1;for(d=0;d<c.length;d++)if(!cd.call(b,c[d])||!bd(a[c[d]],b[c[d]]))return!1;return!0}function ed(a){var b=a;if(a.alternate)for(;b.return;)b=b.return;else{if(0!==(b.effectTag&2))return 1;for(;b.return;)if(b=b.return, 0!==(b.effectTag&2))return 1}return 3===b.tag?2:3}function fd(a){2!==ed(a)?x$1("188"):void 0;}
	function gd(a){var b=a.alternate;if(!b)return b=ed(a), 3===b?x$1("188"):void 0, 1===b?null:a;for(var c=a,d=b;;){var e=c.return,f=e?e.alternate:null;if(!e||!f)break;if(e.child===f.child){for(var g=e.child;g;){if(g===c)return fd(e), a;if(g===d)return fd(e), b;g=g.sibling;}x$1("188");}if(c.return!==d.return)c=e, d=f;else{g=!1;for(var h=e.child;h;){if(h===c){g=!0;c=e;d=f;break}if(h===d){g=!0;d=e;c=f;break}h=h.sibling;}if(!g){for(h=f.child;h;){if(h===c){g=!0;c=f;d=e;break}if(h===d){g=!0;d=f;c=e;break}h=h.sibling;}g?
	void 0:x$1("189");}}c.alternate!==d?x$1("190"):void 0;}3!==c.tag?x$1("188"):void 0;return c.stateNode.current===c?a:b}function hd(a){a=gd(a);if(!a)return null;for(var b=a;;){if(5===b.tag||6===b.tag)return b;if(b.child)b.child.return=b, b=b.child;else{if(b===a)break;for(;!b.sibling;){if(!b.return||b.return===a)return null;b=b.return;}b.sibling.return=b.return;b=b.sibling;}}return null}
	var id=y$1.extend({animationName:null,elapsedTime:null,pseudoElement:null}),jd=y$1.extend({clipboardData:function(a){return"clipboardData"in a?a.clipboardData:window.clipboardData}}),kd=Qc.extend({relatedTarget:null});function ld(a){var b=a.keyCode;"charCode"in a?(a=a.charCode, 0===a&&13===b&&(a=13)):a=b;10===a&&(a=13);return 32<=a||13===a?a:0}
	var md={Esc:"Escape",Spacebar:" ",Left:"ArrowLeft",Up:"ArrowUp",Right:"ArrowRight",Down:"ArrowDown",Del:"Delete",Win:"OS",Menu:"ContextMenu",Apps:"ContextMenu",Scroll:"ScrollLock",MozPrintableKey:"Unidentified"},nd={8:"Backspace",9:"Tab",12:"Clear",13:"Enter",16:"Shift",17:"Control",18:"Alt",19:"Pause",20:"CapsLock",27:"Escape",32:" ",33:"PageUp",34:"PageDown",35:"End",36:"Home",37:"ArrowLeft",38:"ArrowUp",39:"ArrowRight",40:"ArrowDown",45:"Insert",46:"Delete",112:"F1",113:"F2",114:"F3",115:"F4",
	116:"F5",117:"F6",118:"F7",119:"F8",120:"F9",121:"F10",122:"F11",123:"F12",144:"NumLock",145:"ScrollLock",224:"Meta"},od=Qc.extend({key:function(a){if(a.key){var b=md[a.key]||a.key;if("Unidentified"!==b)return b}return"keypress"===a.type?(a=ld(a), 13===a?"Enter":String.fromCharCode(a)):"keydown"===a.type||"keyup"===a.type?nd[a.keyCode]||"Unidentified":""},location:null,ctrlKey:null,shiftKey:null,altKey:null,metaKey:null,repeat:null,locale:null,getModifierState:Tc,charCode:function(a){return"keypress"===
	a.type?ld(a):0},keyCode:function(a){return"keydown"===a.type||"keyup"===a.type?a.keyCode:0},which:function(a){return"keypress"===a.type?ld(a):"keydown"===a.type||"keyup"===a.type?a.keyCode:0}}),pd=Yc.extend({dataTransfer:null}),qd=Qc.extend({touches:null,targetTouches:null,changedTouches:null,altKey:null,metaKey:null,ctrlKey:null,shiftKey:null,getModifierState:Tc}),rd=y$1.extend({propertyName:null,elapsedTime:null,pseudoElement:null}),sd=Yc.extend({deltaX:function(a){return"deltaX"in a?a.deltaX:"wheelDeltaX"in
	a?-a.wheelDeltaX:0},deltaY:function(a){return"deltaY"in a?a.deltaY:"wheelDeltaY"in a?-a.wheelDeltaY:"wheelDelta"in a?-a.wheelDelta:0},deltaZ:null,deltaMode:null}),td=[["abort","abort"],[Xa,"animationEnd"],[Ya,"animationIteration"],[Za,"animationStart"],["canplay","canPlay"],["canplaythrough","canPlayThrough"],["drag","drag"],["dragenter","dragEnter"],["dragexit","dragExit"],["dragleave","dragLeave"],["dragover","dragOver"],["durationchange","durationChange"],["emptied","emptied"],["encrypted","encrypted"],
	["ended","ended"],["error","error"],["gotpointercapture","gotPointerCapture"],["load","load"],["loadeddata","loadedData"],["loadedmetadata","loadedMetadata"],["loadstart","loadStart"],["lostpointercapture","lostPointerCapture"],["mousemove","mouseMove"],["mouseout","mouseOut"],["mouseover","mouseOver"],["playing","playing"],["pointermove","pointerMove"],["pointerout","pointerOut"],["pointerover","pointerOver"],["progress","progress"],["scroll","scroll"],["seeking","seeking"],["stalled","stalled"],
	["suspend","suspend"],["timeupdate","timeUpdate"],["toggle","toggle"],["touchmove","touchMove"],[$a,"transitionEnd"],["waiting","waiting"],["wheel","wheel"]],ud={},vd={};function wd(a,b){var c=a[0];a=a[1];var d="on"+(a[0].toUpperCase()+a.slice(1));b={phasedRegistrationNames:{bubbled:d,captured:d+"Capture"},dependencies:[c],isInteractive:b};ud[a]=b;vd[c]=b;}
	[["blur","blur"],["cancel","cancel"],["click","click"],["close","close"],["contextmenu","contextMenu"],["copy","copy"],["cut","cut"],["auxclick","auxClick"],["dblclick","doubleClick"],["dragend","dragEnd"],["dragstart","dragStart"],["drop","drop"],["focus","focus"],["input","input"],["invalid","invalid"],["keydown","keyDown"],["keypress","keyPress"],["keyup","keyUp"],["mousedown","mouseDown"],["mouseup","mouseUp"],["paste","paste"],["pause","pause"],["play","play"],["pointercancel","pointerCancel"],
	["pointerdown","pointerDown"],["pointerup","pointerUp"],["ratechange","rateChange"],["reset","reset"],["seeked","seeked"],["submit","submit"],["touchcancel","touchCancel"],["touchend","touchEnd"],["touchstart","touchStart"],["volumechange","volumeChange"]].forEach(function(a){wd(a,!0);});td.forEach(function(a){wd(a,!1);});
	var xd={eventTypes:ud,isInteractiveTopLevelEventType:function(a){a=vd[a];return void 0!==a&&!0===a.isInteractive},extractEvents:function(a,b,c,d){var e=vd[a];if(!e)return null;switch(a){case "keypress":if(0===ld(c))return null;case "keydown":case "keyup":a=od;break;case "blur":case "focus":a=kd;break;case "click":if(2===c.button)return null;case "auxclick":case "dblclick":case "mousedown":case "mousemove":case "mouseup":case "mouseout":case "mouseover":case "contextmenu":a=Yc;break;case "drag":case "dragend":case "dragenter":case "dragexit":case "dragleave":case "dragover":case "dragstart":case "drop":a=
	pd;break;case "touchcancel":case "touchend":case "touchmove":case "touchstart":a=qd;break;case Xa:case Ya:case Za:a=id;break;case $a:a=rd;break;case "scroll":a=Qc;break;case "wheel":a=sd;break;case "copy":case "cut":case "paste":a=jd;break;case "gotpointercapture":case "lostpointercapture":case "pointercancel":case "pointerdown":case "pointermove":case "pointerout":case "pointerover":case "pointerup":a=Zc;break;default:a=y$1;}b=a.getPooled(e,b,c,d);Qa(b);return b}},yd=xd.isInteractiveTopLevelEventType,
	zd=[];function Ad(a){var b=a.targetInst,c=b;do{if(!c){a.ancestors.push(c);break}var d;for(d=c;d.return;)d=d.return;d=3!==d.tag?null:d.stateNode.containerInfo;if(!d)break;a.ancestors.push(c);c=Ha(d);}while(c);for(c=0;c<a.ancestors.length;c++){b=a.ancestors[c];var e=Nb(a.nativeEvent);d=a.topLevelType;for(var f=a.nativeEvent,g=null,h=0;h<oa.length;h++){var l=oa[h];l&&(l=l.extractEvents(d,b,f,e))&&(g=xa(g,l));}Da(g);}}var Bd=!0;
	function E$1(a,b){if(!b)return null;var c=(yd(a)?Cd:Dd).bind(null,a);b.addEventListener(a,c,!1);}function Ed(a,b){if(!b)return null;var c=(yd(a)?Cd:Dd).bind(null,a);b.addEventListener(a,c,!0);}function Cd(a,b){Hb(Dd,a,b);}
	function Dd(a,b){if(Bd){var c=Nb(b);c=Ha(c);null===c||"number"!==typeof c.tag||2===ed(c)||(c=null);if(zd.length){var d=zd.pop();d.topLevelType=a;d.nativeEvent=b;d.targetInst=c;a=d;}else a={topLevelType:a,nativeEvent:b,targetInst:c,ancestors:[]};try{Kb(Ad,a);}finally{a.topLevelType=null, a.nativeEvent=null, a.targetInst=null, a.ancestors.length=0, 10>zd.length&&zd.push(a);}}}var Fd={},Gd=0,Hd="_reactListenersID"+(""+Math.random()).slice(2);
	function Id(a){Object.prototype.hasOwnProperty.call(a,Hd)||(a[Hd]=Gd++, Fd[a[Hd]]={});return Fd[a[Hd]]}function Jd(a){a=a||("undefined"!==typeof document?document:void 0);if("undefined"===typeof a)return null;try{return a.activeElement||a.body}catch(b){return a.body}}function Kd(a){for(;a&&a.firstChild;)a=a.firstChild;return a}
	function Ld(a,b){var c=Kd(a);a=0;for(var d;c;){if(3===c.nodeType){d=a+c.textContent.length;if(a<=b&&d>=b)return{node:c,offset:b-a};a=d;}a:{for(;c;){if(c.nextSibling){c=c.nextSibling;break a}c=c.parentNode;}c=void 0;}c=Kd(c);}}function Md(a,b){return a&&b?a===b?!0:a&&3===a.nodeType?!1:b&&3===b.nodeType?Md(a,b.parentNode):"contains"in a?a.contains(b):a.compareDocumentPosition?!!(a.compareDocumentPosition(b)&16):!1:!1}
	function Nd(){for(var a=window,b=Jd();b instanceof a.HTMLIFrameElement;){try{var c="string"===typeof b.contentWindow.location.href;}catch(d){c=!1;}if(c)a=b.contentWindow;else break;b=Jd(a.document);}return b}function Od(a){var b=a&&a.nodeName&&a.nodeName.toLowerCase();return b&&("input"===b&&("text"===a.type||"search"===a.type||"tel"===a.type||"url"===a.type||"password"===a.type)||"textarea"===b||"true"===a.contentEditable)}
	function Pd(){var a=Nd();if(Od(a)){if("selectionStart"in a)var b={start:a.selectionStart,end:a.selectionEnd};else a:{b=(b=a.ownerDocument)&&b.defaultView||window;var c=b.getSelection&&b.getSelection();if(c&&0!==c.rangeCount){b=c.anchorNode;var d=c.anchorOffset,e=c.focusNode;c=c.focusOffset;try{b.nodeType, e.nodeType;}catch(A){b=null;break a}var f=0,g=-1,h=-1,l=0,k=0,m=a,p=null;b:for(;;){for(var t;;){m!==b||0!==d&&3!==m.nodeType||(g=f+d);m!==e||0!==c&&3!==m.nodeType||(h=f+c);3===m.nodeType&&(f+=m.nodeValue.length);
	if(null===(t=m.firstChild))break;p=m;m=t;}for(;;){if(m===a)break b;p===b&&++l===d&&(g=f);p===e&&++k===c&&(h=f);if(null!==(t=m.nextSibling))break;m=p;p=m.parentNode;}m=t;}b=-1===g||-1===h?null:{start:g,end:h};}else b=null;}b=b||{start:0,end:0};}else b=null;return{focusedElem:a,selectionRange:b}}
	function Qd(a){var b=Nd(),c=a.focusedElem,d=a.selectionRange;if(b!==c&&c&&c.ownerDocument&&Md(c.ownerDocument.documentElement,c)){if(null!==d&&Od(c))if(b=d.start, a=d.end, void 0===a&&(a=b), "selectionStart"in c)c.selectionStart=b, c.selectionEnd=Math.min(a,c.value.length);else if(a=(b=c.ownerDocument||document)&&b.defaultView||window, a.getSelection){a=a.getSelection();var e=c.textContent.length,f=Math.min(d.start,e);d=void 0===d.end?f:Math.min(d.end,e);!a.extend&&f>d&&(e=d, d=f, f=e);e=Ld(c,f);var g=Ld(c,
	d);e&&g&&(1!==a.rangeCount||a.anchorNode!==e.node||a.anchorOffset!==e.offset||a.focusNode!==g.node||a.focusOffset!==g.offset)&&(b=b.createRange(), b.setStart(e.node,e.offset), a.removeAllRanges(), f>d?(a.addRange(b), a.extend(g.node,g.offset)):(b.setEnd(g.node,g.offset), a.addRange(b)));}b=[];for(a=c;a=a.parentNode;)1===a.nodeType&&b.push({element:a,left:a.scrollLeft,top:a.scrollTop});"function"===typeof c.focus&&c.focus();for(c=0;c<b.length;c++)a=b[c], a.element.scrollLeft=a.left, a.element.scrollTop=a.top;}}
	var Rd=Ra&&"documentMode"in document&&11>=document.documentMode,Sd={select:{phasedRegistrationNames:{bubbled:"onSelect",captured:"onSelectCapture"},dependencies:"blur contextmenu dragend focus keydown keyup mousedown mouseup selectionchange".split(" ")}},Td=null,Ud=null,Vd=null,Wd=!1;
	function Xd(a,b){var c=b.window===b?b.document:9===b.nodeType?b:b.ownerDocument;if(Wd||null==Td||Td!==Jd(c))return null;c=Td;"selectionStart"in c&&Od(c)?c={start:c.selectionStart,end:c.selectionEnd}:(c=(c.ownerDocument&&c.ownerDocument.defaultView||window).getSelection(), c={anchorNode:c.anchorNode,anchorOffset:c.anchorOffset,focusNode:c.focusNode,focusOffset:c.focusOffset});return Vd&&dd(Vd,c)?null:(Vd=c, a=y$1.getPooled(Sd.select,Ud,a,b), a.type="select", a.target=Td, Qa(a), a)}
	var Yd={eventTypes:Sd,extractEvents:function(a,b,c,d){var e=d.window===d?d.document:9===d.nodeType?d:d.ownerDocument,f;if(!(f=!e)){a:{e=Id(e);f=sa.onSelect;for(var g=0;g<f.length;g++){var h=f[g];if(!e.hasOwnProperty(h)||!e[h]){e=!1;break a}}e=!0;}f=!e;}if(f)return null;e=b?Ja(b):window;switch(a){case "focus":if(Mb(e)||"true"===e.contentEditable)Td=e, Ud=b, Vd=null;break;case "blur":Vd=Ud=Td=null;break;case "mousedown":Wd=!0;break;case "contextmenu":case "mouseup":case "dragend":return Wd=!1, Xd(c,d);case "selectionchange":if(Rd)break;
	case "keydown":case "keyup":return Xd(c,d)}return null}};Ba.injectEventPluginOrder("ResponderEventPlugin SimpleEventPlugin EnterLeaveEventPlugin ChangeEventPlugin SelectEventPlugin BeforeInputEventPlugin".split(" "));ta=Ka;ua=Ia;va=Ja;Ba.injectEventPluginsByName({SimpleEventPlugin:xd,EnterLeaveEventPlugin:ad,ChangeEventPlugin:Pc,SelectEventPlugin:Yd,BeforeInputEventPlugin:zb});function Zd(a){var b="";react.Children.forEach(a,function(a){null!=a&&(b+=a);});return b}
	function $d(a,b){a=objectAssign({children:void 0},b);if(b=Zd(b.children))a.children=b;return a}function ae(a,b,c,d){a=a.options;if(b){b={};for(var e=0;e<c.length;e++)b["$"+c[e]]=!0;for(c=0;c<a.length;c++)e=b.hasOwnProperty("$"+a[c].value), a[c].selected!==e&&(a[c].selected=e), e&&d&&(a[c].defaultSelected=!0);}else{c=""+uc(c);b=null;for(e=0;e<a.length;e++){if(a[e].value===c){a[e].selected=!0;d&&(a[e].defaultSelected=!0);return}null!==b||a[e].disabled||(b=a[e]);}null!==b&&(b.selected=!0);}}
	function be(a,b){null!=b.dangerouslySetInnerHTML?x$1("91"):void 0;return objectAssign({},b,{value:void 0,defaultValue:void 0,children:""+a._wrapperState.initialValue})}function ce(a,b){var c=b.value;null==c&&(c=b.defaultValue, b=b.children, null!=b&&(null!=c?x$1("92"):void 0, Array.isArray(b)&&(1>=b.length?void 0:x$1("93"), b=b[0]), c=b), null==c&&(c=""));a._wrapperState={initialValue:uc(c)};}
	function de(a,b){var c=uc(b.value),d=uc(b.defaultValue);null!=c&&(c=""+c, c!==a.value&&(a.value=c), null==b.defaultValue&&a.defaultValue!==c&&(a.defaultValue=c));null!=d&&(a.defaultValue=""+d);}function ee(a){var b=a.textContent;b===a._wrapperState.initialValue&&(a.value=b);}var fe={html:"http://www.w3.org/1999/xhtml",mathml:"http://www.w3.org/1998/Math/MathML",svg:"http://www.w3.org/2000/svg"};
	function ge(a){switch(a){case "svg":return"http://www.w3.org/2000/svg";case "math":return"http://www.w3.org/1998/Math/MathML";default:return"http://www.w3.org/1999/xhtml"}}function he(a,b){return null==a||"http://www.w3.org/1999/xhtml"===a?ge(b):"http://www.w3.org/2000/svg"===a&&"foreignObject"===b?"http://www.w3.org/1999/xhtml":a}
	var ie=void 0,je=function(a){return"undefined"!==typeof MSApp&&MSApp.execUnsafeLocalFunction?function(b,c,d,e){MSApp.execUnsafeLocalFunction(function(){return a(b,c,d,e)});}:a}(function(a,b){if(a.namespaceURI!==fe.svg||"innerHTML"in a)a.innerHTML=b;else{ie=ie||document.createElement("div");ie.innerHTML="<svg>"+b+"</svg>";for(b=ie.firstChild;a.firstChild;)a.removeChild(a.firstChild);for(;b.firstChild;)a.appendChild(b.firstChild);}});
	function ke(a,b){if(b){var c=a.firstChild;if(c&&c===a.lastChild&&3===c.nodeType){c.nodeValue=b;return}}a.textContent=b;}
	var le={animationIterationCount:!0,borderImageOutset:!0,borderImageSlice:!0,borderImageWidth:!0,boxFlex:!0,boxFlexGroup:!0,boxOrdinalGroup:!0,columnCount:!0,columns:!0,flex:!0,flexGrow:!0,flexPositive:!0,flexShrink:!0,flexNegative:!0,flexOrder:!0,gridArea:!0,gridRow:!0,gridRowEnd:!0,gridRowSpan:!0,gridRowStart:!0,gridColumn:!0,gridColumnEnd:!0,gridColumnSpan:!0,gridColumnStart:!0,fontWeight:!0,lineClamp:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,tabSize:!0,widows:!0,zIndex:!0,zoom:!0,fillOpacity:!0,
	floodOpacity:!0,stopOpacity:!0,strokeDasharray:!0,strokeDashoffset:!0,strokeMiterlimit:!0,strokeOpacity:!0,strokeWidth:!0},me=["Webkit","ms","Moz","O"];Object.keys(le).forEach(function(a){me.forEach(function(b){b=b+a.charAt(0).toUpperCase()+a.substring(1);le[b]=le[a];});});function ne(a,b,c){return null==b||"boolean"===typeof b||""===b?"":c||"number"!==typeof b||0===b||le.hasOwnProperty(a)&&le[a]?(""+b).trim():b+"px"}
	function oe(a,b){a=a.style;for(var c in b)if(b.hasOwnProperty(c)){var d=0===c.indexOf("--"),e=ne(c,b[c],d);"float"===c&&(c="cssFloat");d?a.setProperty(c,e):a[c]=e;}}var pe=objectAssign({menuitem:!0},{area:!0,base:!0,br:!0,col:!0,embed:!0,hr:!0,img:!0,input:!0,keygen:!0,link:!0,meta:!0,param:!0,source:!0,track:!0,wbr:!0});
	function qe(a,b){b&&(pe[a]&&(null!=b.children||null!=b.dangerouslySetInnerHTML?x$1("137",a,""):void 0), null!=b.dangerouslySetInnerHTML&&(null!=b.children?x$1("60"):void 0, "object"===typeof b.dangerouslySetInnerHTML&&"__html"in b.dangerouslySetInnerHTML?void 0:x$1("61")), null!=b.style&&"object"!==typeof b.style?x$1("62",""):void 0);}
	function re(a,b){if(-1===a.indexOf("-"))return"string"===typeof b.is;switch(a){case "annotation-xml":case "color-profile":case "font-face":case "font-face-src":case "font-face-uri":case "font-face-format":case "font-face-name":case "missing-glyph":return!1;default:return!0}}
	function se(a,b){a=9===a.nodeType||11===a.nodeType?a:a.ownerDocument;var c=Id(a);b=sa[b];for(var d=0;d<b.length;d++){var e=b[d];if(!c.hasOwnProperty(e)||!c[e]){switch(e){case "scroll":Ed("scroll",a);break;case "focus":case "blur":Ed("focus",a);Ed("blur",a);c.blur=!0;c.focus=!0;break;case "cancel":case "close":Ob(e)&&Ed(e,a);break;case "invalid":case "submit":case "reset":break;default:-1===ab.indexOf(e)&&E$1(e,a);}c[e]=!0;}}}function te(){}var ue=null,ve=null;
	function we(a,b){switch(a){case "button":case "input":case "select":case "textarea":return!!b.autoFocus}return!1}function xe(a,b){return"textarea"===a||"option"===a||"noscript"===a||"string"===typeof b.children||"number"===typeof b.children||"object"===typeof b.dangerouslySetInnerHTML&&null!==b.dangerouslySetInnerHTML&&null!=b.dangerouslySetInnerHTML.__html}
	var ye="function"===typeof setTimeout?setTimeout:void 0,ze="function"===typeof clearTimeout?clearTimeout:void 0,Ae=scheduler.unstable_scheduleCallback,Be=scheduler.unstable_cancelCallback;
	function Ce(a,b,c,d,e){a[Ga]=e;"input"===c&&"radio"===e.type&&null!=e.name&&xc(a,e);re(c,d);d=re(c,e);for(var f=0;f<b.length;f+=2){var g=b[f],h=b[f+1];"style"===g?oe(a,h):"dangerouslySetInnerHTML"===g?je(a,h):"children"===g?ke(a,h):tc(a,g,h,d);}switch(c){case "input":yc(a,e);break;case "textarea":de(a,e);break;case "select":b=a._wrapperState.wasMultiple, a._wrapperState.wasMultiple=!!e.multiple, c=e.value, null!=c?ae(a,!!e.multiple,c,!1):b!==!!e.multiple&&(null!=e.defaultValue?ae(a,!!e.multiple,e.defaultValue,
	!0):ae(a,!!e.multiple,e.multiple?[]:"",!1));}}function De(a){for(a=a.nextSibling;a&&1!==a.nodeType&&3!==a.nodeType;)a=a.nextSibling;return a}function Ee(a){for(a=a.firstChild;a&&1!==a.nodeType&&3!==a.nodeType;)a=a.nextSibling;return a}var Fe=[],Ge=-1;function F$1(a){0>Ge||(a.current=Fe[Ge], Fe[Ge]=null, Ge--);}function G$1(a,b){Ge++;Fe[Ge]=a.current;a.current=b;}var He={},H$1={current:He},I$1={current:!1},Ie=He;
	function Je(a,b){var c=a.type.contextTypes;if(!c)return He;var d=a.stateNode;if(d&&d.__reactInternalMemoizedUnmaskedChildContext===b)return d.__reactInternalMemoizedMaskedChildContext;var e={},f;for(f in c)e[f]=b[f];d&&(a=a.stateNode, a.__reactInternalMemoizedUnmaskedChildContext=b, a.__reactInternalMemoizedMaskedChildContext=e);return e}function J$1(a){a=a.childContextTypes;return null!==a&&void 0!==a}function Ke(a){F$1(I$1,a);F$1(H$1,a);}function Le(a){F$1(I$1,a);F$1(H$1,a);}
	function Me(a,b,c){H$1.current!==He?x$1("168"):void 0;G$1(H$1,b,a);G$1(I$1,c,a);}function Ne(a,b,c){var d=a.stateNode;a=b.childContextTypes;if("function"!==typeof d.getChildContext)return c;d=d.getChildContext();for(var e in d)e in a?void 0:x$1("108",ic(b)||"Unknown",e);return objectAssign({},c,d)}function Oe(a){var b=a.stateNode;b=b&&b.__reactInternalMemoizedMergedChildContext||He;Ie=H$1.current;G$1(H$1,b,a);G$1(I$1,I$1.current,a);return!0}
	function Pe(a,b,c){var d=a.stateNode;d?void 0:x$1("169");c?(b=Ne(a,b,Ie), d.__reactInternalMemoizedMergedChildContext=b, F$1(I$1,a), F$1(H$1,a), G$1(H$1,b,a)):F$1(I$1,a);G$1(I$1,c,a);}var Qe=null,Re=null;function Se(a){return function(b){try{return a(b)}catch(c){}}}
	function Te(a){if("undefined"===typeof __REACT_DEVTOOLS_GLOBAL_HOOK__)return!1;var b=__REACT_DEVTOOLS_GLOBAL_HOOK__;if(b.isDisabled||!b.supportsFiber)return!0;try{var c=b.inject(a);Qe=Se(function(a){return b.onCommitFiberRoot(c,a)});Re=Se(function(a){return b.onCommitFiberUnmount(c,a)});}catch(d){}return!0}
	function Ue(a,b,c,d){this.tag=a;this.key=c;this.sibling=this.child=this.return=this.stateNode=this.type=this.elementType=null;this.index=0;this.ref=null;this.pendingProps=b;this.contextDependencies=this.memoizedState=this.updateQueue=this.memoizedProps=null;this.mode=d;this.effectTag=0;this.lastEffect=this.firstEffect=this.nextEffect=null;this.childExpirationTime=this.expirationTime=0;this.alternate=null;}function K$1(a,b,c,d){return new Ue(a,b,c,d)}
	function Ve(a){a=a.prototype;return!(!a||!a.isReactComponent)}function We(a){if("function"===typeof a)return Ve(a)?1:0;if(void 0!==a&&null!==a){a=a.$$typeof;if(a===cc)return 11;if(a===ec)return 14}return 2}
	function Xe(a,b){var c=a.alternate;null===c?(c=K$1(a.tag,b,a.key,a.mode), c.elementType=a.elementType, c.type=a.type, c.stateNode=a.stateNode, c.alternate=a, a.alternate=c):(c.pendingProps=b, c.effectTag=0, c.nextEffect=null, c.firstEffect=null, c.lastEffect=null);c.childExpirationTime=a.childExpirationTime;c.expirationTime=a.expirationTime;c.child=a.child;c.memoizedProps=a.memoizedProps;c.memoizedState=a.memoizedState;c.updateQueue=a.updateQueue;c.contextDependencies=a.contextDependencies;c.sibling=a.sibling;
	c.index=a.index;c.ref=a.ref;return c}
	function Ye(a,b,c,d,e,f){var g=2;d=a;if("function"===typeof a)Ve(a)&&(g=1);else if("string"===typeof a)g=5;else a:switch(a){case Xb:return Ze(c.children,e,f,b);case bc:return $e(c,e|3,f,b);case Yb:return $e(c,e|2,f,b);case Zb:return a=K$1(12,c,b,e|4), a.elementType=Zb, a.type=Zb, a.expirationTime=f, a;case dc:return a=K$1(13,c,b,e), a.elementType=dc, a.type=dc, a.expirationTime=f, a;default:if("object"===typeof a&&null!==a)switch(a.$$typeof){case $b:g=10;break a;case ac:g=9;break a;case cc:g=11;break a;case ec:g=
	14;break a;case fc:g=16;d=null;break a}x$1("130",null==a?a:typeof a,"");}b=K$1(g,c,b,e);b.elementType=a;b.type=d;b.expirationTime=f;return b}function Ze(a,b,c,d){a=K$1(7,a,d,b);a.expirationTime=c;return a}function $e(a,b,c,d){a=K$1(8,a,d,b);b=0===(b&1)?Yb:bc;a.elementType=b;a.type=b;a.expirationTime=c;return a}function af(a,b,c){a=K$1(6,a,null,b);a.expirationTime=c;return a}
	function bf(a,b,c){b=K$1(4,null!==a.children?a.children:[],a.key,b);b.expirationTime=c;b.stateNode={containerInfo:a.containerInfo,pendingChildren:null,implementation:a.implementation};return b}function cf(a,b){a.didError=!1;var c=a.earliestPendingTime;0===c?a.earliestPendingTime=a.latestPendingTime=b:c<b?a.earliestPendingTime=b:a.latestPendingTime>b&&(a.latestPendingTime=b);df(b,a);}
	function ef(a,b){a.didError=!1;if(0===b)a.earliestPendingTime=0, a.latestPendingTime=0, a.earliestSuspendedTime=0, a.latestSuspendedTime=0, a.latestPingedTime=0;else{b<a.latestPingedTime&&(a.latestPingedTime=0);var c=a.latestPendingTime;0!==c&&(c>b?a.earliestPendingTime=a.latestPendingTime=0:a.earliestPendingTime>b&&(a.earliestPendingTime=a.latestPendingTime));c=a.earliestSuspendedTime;0===c?cf(a,b):b<a.latestSuspendedTime?(a.earliestSuspendedTime=0, a.latestSuspendedTime=0, a.latestPingedTime=0, cf(a,b)):
	b>c&&cf(a,b);}df(0,a);}function ff(a,b){a.didError=!1;a.latestPingedTime>=b&&(a.latestPingedTime=0);var c=a.earliestPendingTime,d=a.latestPendingTime;c===b?a.earliestPendingTime=d===b?a.latestPendingTime=0:d:d===b&&(a.latestPendingTime=c);c=a.earliestSuspendedTime;d=a.latestSuspendedTime;0===c?a.earliestSuspendedTime=a.latestSuspendedTime=b:c<b?a.earliestSuspendedTime=b:d>b&&(a.latestSuspendedTime=b);df(b,a);}
	function gf(a,b){var c=a.earliestPendingTime;a=a.earliestSuspendedTime;c>b&&(b=c);a>b&&(b=a);return b}function df(a,b){var c=b.earliestSuspendedTime,d=b.latestSuspendedTime,e=b.earliestPendingTime,f=b.latestPingedTime;e=0!==e?e:f;0===e&&(0===a||d<a)&&(e=d);a=e;0!==a&&c>a&&(a=c);b.nextExpirationTimeToWorkOn=e;b.expirationTime=a;}function L$1(a,b){if(a&&a.defaultProps){b=objectAssign({},b);a=a.defaultProps;for(var c in a)void 0===b[c]&&(b[c]=a[c]);}return b}
	function hf(a){var b=a._result;switch(a._status){case 1:return b;case 2:throw b;case 0:throw b;default:a._status=0;b=a._ctor;b=b();b.then(function(b){0===a._status&&(b=b.default, a._status=1, a._result=b);},function(b){0===a._status&&(a._status=2, a._result=b);});switch(a._status){case 1:return a._result;case 2:throw a._result;}a._result=b;throw b;}}var jf=(new react.Component).refs;
	function kf(a,b,c,d){b=a.memoizedState;c=c(d,b);c=null===c||void 0===c?b:objectAssign({},b,c);a.memoizedState=c;d=a.updateQueue;null!==d&&0===a.expirationTime&&(d.baseState=c);}
	var tf={isMounted:function(a){return(a=a._reactInternalFiber)?2===ed(a):!1},enqueueSetState:function(a,b,c){a=a._reactInternalFiber;var d=lf();d=mf(d,a);var e=nf(d);e.payload=b;void 0!==c&&null!==c&&(e.callback=c);of();pf(a,e);qf(a,d);},enqueueReplaceState:function(a,b,c){a=a._reactInternalFiber;var d=lf();d=mf(d,a);var e=nf(d);e.tag=rf;e.payload=b;void 0!==c&&null!==c&&(e.callback=c);of();pf(a,e);qf(a,d);},enqueueForceUpdate:function(a,b){a=a._reactInternalFiber;var c=lf();c=mf(c,a);var d=nf(c);d.tag=
	sf;void 0!==b&&null!==b&&(d.callback=b);of();pf(a,d);qf(a,c);}};function uf(a,b,c,d,e,f,g){a=a.stateNode;return"function"===typeof a.shouldComponentUpdate?a.shouldComponentUpdate(d,f,g):b.prototype&&b.prototype.isPureReactComponent?!dd(c,d)||!dd(e,f):!0}
	function vf(a,b,c){var d=!1,e=He;var f=b.contextType;"object"===typeof f&&null!==f?f=M$1(f):(e=J$1(b)?Ie:H$1.current, d=b.contextTypes, f=(d=null!==d&&void 0!==d)?Je(a,e):He);b=new b(c,f);a.memoizedState=null!==b.state&&void 0!==b.state?b.state:null;b.updater=tf;a.stateNode=b;b._reactInternalFiber=a;d&&(a=a.stateNode, a.__reactInternalMemoizedUnmaskedChildContext=e, a.__reactInternalMemoizedMaskedChildContext=f);return b}
	function wf(a,b,c,d){a=b.state;"function"===typeof b.componentWillReceiveProps&&b.componentWillReceiveProps(c,d);"function"===typeof b.UNSAFE_componentWillReceiveProps&&b.UNSAFE_componentWillReceiveProps(c,d);b.state!==a&&tf.enqueueReplaceState(b,b.state,null);}
	function xf(a,b,c,d){var e=a.stateNode;e.props=c;e.state=a.memoizedState;e.refs=jf;var f=b.contextType;"object"===typeof f&&null!==f?e.context=M$1(f):(f=J$1(b)?Ie:H$1.current, e.context=Je(a,f));f=a.updateQueue;null!==f&&(yf(a,f,c,e,d), e.state=a.memoizedState);f=b.getDerivedStateFromProps;"function"===typeof f&&(kf(a,b,f,c), e.state=a.memoizedState);"function"===typeof b.getDerivedStateFromProps||"function"===typeof e.getSnapshotBeforeUpdate||"function"!==typeof e.UNSAFE_componentWillMount&&"function"!==
	typeof e.componentWillMount||(b=e.state, "function"===typeof e.componentWillMount&&e.componentWillMount(), "function"===typeof e.UNSAFE_componentWillMount&&e.UNSAFE_componentWillMount(), b!==e.state&&tf.enqueueReplaceState(e,e.state,null), f=a.updateQueue, null!==f&&(yf(a,f,c,e,d), e.state=a.memoizedState));"function"===typeof e.componentDidMount&&(a.effectTag|=4);}var zf=Array.isArray;
	function Af(a,b,c){a=c.ref;if(null!==a&&"function"!==typeof a&&"object"!==typeof a){if(c._owner){c=c._owner;var d=void 0;c&&(1!==c.tag?x$1("309"):void 0, d=c.stateNode);d?void 0:x$1("147",a);var e=""+a;if(null!==b&&null!==b.ref&&"function"===typeof b.ref&&b.ref._stringRef===e)return b.ref;b=function(a){var b=d.refs;b===jf&&(b=d.refs={});null===a?delete b[e]:b[e]=a;};b._stringRef=e;return b}"string"!==typeof a?x$1("284"):void 0;c._owner?void 0:x$1("290",a);}return a}
	function Bf(a,b){"textarea"!==a.type&&x$1("31","[object Object]"===Object.prototype.toString.call(b)?"object with keys {"+Object.keys(b).join(", ")+"}":b,"");}
	function Cf(a){function b(b,c){if(a){var d=b.lastEffect;null!==d?(d.nextEffect=c, b.lastEffect=c):b.firstEffect=b.lastEffect=c;c.nextEffect=null;c.effectTag=8;}}function c(c,d){if(!a)return null;for(;null!==d;)b(c,d), d=d.sibling;return null}function d(a,b){for(a=new Map;null!==b;)null!==b.key?a.set(b.key,b):a.set(b.index,b), b=b.sibling;return a}function e(a,b,c){a=Xe(a,b,c);a.index=0;a.sibling=null;return a}function f(b,c,d){b.index=d;if(!a)return c;d=b.alternate;if(null!==d)return d=d.index, d<c?(b.effectTag=
	2, c):d;b.effectTag=2;return c}function g(b){a&&null===b.alternate&&(b.effectTag=2);return b}function h(a,b,c,d){if(null===b||6!==b.tag)return b=af(c,a.mode,d), b.return=a, b;b=e(b,c,d);b.return=a;return b}function l(a,b,c,d){if(null!==b&&b.elementType===c.type)return d=e(b,c.props,d), d.ref=Af(a,b,c), d.return=a, d;d=Ye(c.type,c.key,c.props,null,a.mode,d);d.ref=Af(a,b,c);d.return=a;return d}function k(a,b,c,d){if(null===b||4!==b.tag||b.stateNode.containerInfo!==c.containerInfo||b.stateNode.implementation!==
	c.implementation)return b=bf(c,a.mode,d), b.return=a, b;b=e(b,c.children||[],d);b.return=a;return b}function m(a,b,c,d,f){if(null===b||7!==b.tag)return b=Ze(c,a.mode,d,f), b.return=a, b;b=e(b,c,d);b.return=a;return b}function p(a,b,c){if("string"===typeof b||"number"===typeof b)return b=af(""+b,a.mode,c), b.return=a, b;if("object"===typeof b&&null!==b){switch(b.$$typeof){case Vb:return c=Ye(b.type,b.key,b.props,null,a.mode,c), c.ref=Af(a,null,b), c.return=a, c;case Wb:return b=bf(b,a.mode,c), b.return=a, b}if(zf(b)||
	hc(b))return b=Ze(b,a.mode,c,null), b.return=a, b;Bf(a,b);}return null}function t(a,b,c,d){var e=null!==b?b.key:null;if("string"===typeof c||"number"===typeof c)return null!==e?null:h(a,b,""+c,d);if("object"===typeof c&&null!==c){switch(c.$$typeof){case Vb:return c.key===e?c.type===Xb?m(a,b,c.props.children,d,e):l(a,b,c,d):null;case Wb:return c.key===e?k(a,b,c,d):null}if(zf(c)||hc(c))return null!==e?null:m(a,b,c,d,null);Bf(a,c);}return null}function A(a,b,c,d,e){if("string"===typeof d||"number"===typeof d)return a=
	a.get(c)||null, h(b,a,""+d,e);if("object"===typeof d&&null!==d){switch(d.$$typeof){case Vb:return a=a.get(null===d.key?c:d.key)||null, d.type===Xb?m(b,a,d.props.children,e,d.key):l(b,a,d,e);case Wb:return a=a.get(null===d.key?c:d.key)||null, k(b,a,d,e)}if(zf(d)||hc(d))return a=a.get(c)||null, m(b,a,d,e,null);Bf(b,d);}return null}function v(e,g,h,k){for(var l=null,m=null,q=g,u=g=0,B=null;null!==q&&u<h.length;u++){q.index>u?(B=q, q=null):B=q.sibling;var w=t(e,q,h[u],k);if(null===w){null===q&&(q=B);break}a&&
	q&&null===w.alternate&&b(e,q);g=f(w,g,u);null===m?l=w:m.sibling=w;m=w;q=B;}if(u===h.length)return c(e,q), l;if(null===q){for(;u<h.length;u++)if(q=p(e,h[u],k))g=f(q,g,u), null===m?l=q:m.sibling=q, m=q;return l}for(q=d(e,q);u<h.length;u++)if(B=A(q,e,u,h[u],k))a&&null!==B.alternate&&q.delete(null===B.key?u:B.key), g=f(B,g,u), null===m?l=B:m.sibling=B, m=B;a&&q.forEach(function(a){return b(e,a)});return l}function R(e,g,h,k){var l=hc(h);"function"!==typeof l?x$1("150"):void 0;h=l.call(h);null==h?x$1("151"):void 0;
	for(var m=l=null,q=g,u=g=0,B=null,w=h.next();null!==q&&!w.done;u++, w=h.next()){q.index>u?(B=q, q=null):B=q.sibling;var v=t(e,q,w.value,k);if(null===v){q||(q=B);break}a&&q&&null===v.alternate&&b(e,q);g=f(v,g,u);null===m?l=v:m.sibling=v;m=v;q=B;}if(w.done)return c(e,q), l;if(null===q){for(;!w.done;u++, w=h.next())w=p(e,w.value,k), null!==w&&(g=f(w,g,u), null===m?l=w:m.sibling=w, m=w);return l}for(q=d(e,q);!w.done;u++, w=h.next())w=A(q,e,u,w.value,k), null!==w&&(a&&null!==w.alternate&&q.delete(null===w.key?u:
	w.key), g=f(w,g,u), null===m?l=w:m.sibling=w, m=w);a&&q.forEach(function(a){return b(e,a)});return l}return function(a,d,f,h){var k="object"===typeof f&&null!==f&&f.type===Xb&&null===f.key;k&&(f=f.props.children);var l="object"===typeof f&&null!==f;if(l)switch(f.$$typeof){case Vb:a:{l=f.key;for(k=d;null!==k;){if(k.key===l)if(7===k.tag?f.type===Xb:k.elementType===f.type){c(a,k.sibling);d=e(k,f.type===Xb?f.props.children:f.props,h);d.ref=Af(a,k,f);d.return=a;a=d;break a}else{c(a,k);break}else b(a,k);k=
	k.sibling;}f.type===Xb?(d=Ze(f.props.children,a.mode,h,f.key), d.return=a, a=d):(h=Ye(f.type,f.key,f.props,null,a.mode,h), h.ref=Af(a,d,f), h.return=a, a=h);}return g(a);case Wb:a:{for(k=f.key;null!==d;){if(d.key===k)if(4===d.tag&&d.stateNode.containerInfo===f.containerInfo&&d.stateNode.implementation===f.implementation){c(a,d.sibling);d=e(d,f.children||[],h);d.return=a;a=d;break a}else{c(a,d);break}else b(a,d);d=d.sibling;}d=bf(f,a.mode,h);d.return=a;a=d;}return g(a)}if("string"===typeof f||"number"===typeof f)return f=
	""+f, null!==d&&6===d.tag?(c(a,d.sibling), d=e(d,f,h), d.return=a, a=d):(c(a,d), d=af(f,a.mode,h), d.return=a, a=d), g(a);if(zf(f))return v(a,d,f,h);if(hc(f))return R(a,d,f,h);l&&Bf(a,f);if("undefined"===typeof f&&!k)switch(a.tag){case 1:case 0:h=a.type, x$1("152",h.displayName||h.name||"Component");}return c(a,d)}}var Df=Cf(!0),Ef=Cf(!1),Ff={},N$1={current:Ff},Gf={current:Ff},Hf={current:Ff};function If(a){a===Ff?x$1("174"):void 0;return a}
	function Jf(a,b){G$1(Hf,b,a);G$1(Gf,a,a);G$1(N$1,Ff,a);var c=b.nodeType;switch(c){case 9:case 11:b=(b=b.documentElement)?b.namespaceURI:he(null,"");break;default:c=8===c?b.parentNode:b, b=c.namespaceURI||null, c=c.tagName, b=he(b,c);}F$1(N$1,a);G$1(N$1,b,a);}function Kf(a){F$1(N$1,a);F$1(Gf,a);F$1(Hf,a);}function Lf(a){If(Hf.current);var b=If(N$1.current);var c=he(b,a.type);b!==c&&(G$1(Gf,a,a), G$1(N$1,c,a));}function Mf(a){Gf.current===a&&(F$1(N$1,a), F$1(Gf,a));}
	var Nf=0,Of=2,Pf=4,Qf=8,Rf=16,Sf=32,Tf=64,Uf=128,Vf=Tb.ReactCurrentDispatcher,Wf=0,Xf=null,O$1=null,P$1=null,Yf=null,Q$1=null,Zf=null,$f=0,ag=null,bg=0,cg=!1,dg=null,eg=0;function fg(){x$1("321");}function gg(a,b){if(null===b)return!1;for(var c=0;c<b.length&&c<a.length;c++)if(!bd(a[c],b[c]))return!1;return!0}
	function hg(a,b,c,d,e,f){Wf=f;Xf=b;P$1=null!==a?a.memoizedState:null;Vf.current=null===P$1?ig:jg;b=c(d,e);if(cg){do cg=!1, eg+=1, P$1=null!==a?a.memoizedState:null, Zf=Yf, ag=Q$1=O$1=null, Vf.current=jg, b=c(d,e);while(cg);dg=null;eg=0;}Vf.current=kg;a=Xf;a.memoizedState=Yf;a.expirationTime=$f;a.updateQueue=ag;a.effectTag|=bg;a=null!==O$1&&null!==O$1.next;Wf=0;Zf=Q$1=Yf=P$1=O$1=Xf=null;$f=0;ag=null;bg=0;a?x$1("300"):void 0;return b}function lg(){Vf.current=kg;Wf=0;Zf=Q$1=Yf=P$1=O$1=Xf=null;$f=0;ag=null;bg=0;cg=!1;dg=null;eg=0;}
	function mg(){var a={memoizedState:null,baseState:null,queue:null,baseUpdate:null,next:null};null===Q$1?Yf=Q$1=a:Q$1=Q$1.next=a;return Q$1}function ng(){if(null!==Zf)Q$1=Zf, Zf=Q$1.next, O$1=P$1, P$1=null!==O$1?O$1.next:null;else{null===P$1?x$1("310"):void 0;O$1=P$1;var a={memoizedState:O$1.memoizedState,baseState:O$1.baseState,queue:O$1.queue,baseUpdate:O$1.baseUpdate,next:null};Q$1=null===Q$1?Yf=a:Q$1.next=a;P$1=O$1.next;}return Q$1}function og(a,b){return"function"===typeof b?b(a):b}
	function pg(a){var b=ng(),c=b.queue;null===c?x$1("311"):void 0;c.lastRenderedReducer=a;if(0<eg){var d=c.dispatch;if(null!==dg){var e=dg.get(c);if(void 0!==e){dg.delete(c);var f=b.memoizedState;do f=a(f,e.action), e=e.next;while(null!==e);bd(f,b.memoizedState)||(qg=!0);b.memoizedState=f;b.baseUpdate===c.last&&(b.baseState=f);c.lastRenderedState=f;return[f,d]}}return[b.memoizedState,d]}d=c.last;var g=b.baseUpdate;f=b.baseState;null!==g?(null!==d&&(d.next=null), d=g.next):d=null!==d?d.next:null;if(null!==
	d){var h=e=null,l=d,k=!1;do{var m=l.expirationTime;m<Wf?(k||(k=!0, h=g, e=f), m>$f&&($f=m)):f=l.eagerReducer===a?l.eagerState:a(f,l.action);g=l;l=l.next;}while(null!==l&&l!==d);k||(h=g, e=f);bd(f,b.memoizedState)||(qg=!0);b.memoizedState=f;b.baseUpdate=h;b.baseState=e;c.lastRenderedState=f;}return[b.memoizedState,c.dispatch]}
	function rg(a,b,c,d){a={tag:a,create:b,destroy:c,deps:d,next:null};null===ag?(ag={lastEffect:null}, ag.lastEffect=a.next=a):(b=ag.lastEffect, null===b?ag.lastEffect=a.next=a:(c=b.next, b.next=a, a.next=c, ag.lastEffect=a));return a}function sg(a,b,c,d){var e=mg();bg|=a;e.memoizedState=rg(b,c,void 0,void 0===d?null:d);}
	function tg(a,b,c,d){var e=ng();d=void 0===d?null:d;var f=void 0;if(null!==O$1){var g=O$1.memoizedState;f=g.destroy;if(null!==d&&gg(d,g.deps)){rg(Nf,c,f,d);return}}bg|=a;e.memoizedState=rg(b,c,f,d);}function ug(a,b){if("function"===typeof b)return a=a(), b(a), function(){b(null);};if(null!==b&&void 0!==b)return a=a(), b.current=a, function(){b.current=null;}}function vg(){}
	function wg(a,b,c){25>eg?void 0:x$1("301");var d=a.alternate;if(a===Xf||null!==d&&d===Xf)if(cg=!0, a={expirationTime:Wf,action:c,eagerReducer:null,eagerState:null,next:null}, null===dg&&(dg=new Map), c=dg.get(b), void 0===c)dg.set(b,a);else{for(b=c;null!==b.next;)b=b.next;b.next=a;}else{of();var e=lf();e=mf(e,a);var f={expirationTime:e,action:c,eagerReducer:null,eagerState:null,next:null},g=b.last;if(null===g)f.next=f;else{var h=g.next;null!==h&&(f.next=h);g.next=f;}b.last=f;if(0===a.expirationTime&&(null===
	d||0===d.expirationTime)&&(d=b.lastRenderedReducer, null!==d))try{var l=b.lastRenderedState,k=d(l,c);f.eagerReducer=d;f.eagerState=k;if(bd(k,l))return}catch(m){}finally{}qf(a,e);}}
	var kg={readContext:M$1,useCallback:fg,useContext:fg,useEffect:fg,useImperativeHandle:fg,useLayoutEffect:fg,useMemo:fg,useReducer:fg,useRef:fg,useState:fg,useDebugValue:fg},ig={readContext:M$1,useCallback:function(a,b){mg().memoizedState=[a,void 0===b?null:b];return a},useContext:M$1,useEffect:function(a,b){return sg(516,Uf|Tf,a,b)},useImperativeHandle:function(a,b,c){c=null!==c&&void 0!==c?c.concat([a]):null;return sg(4,Pf|Sf,ug.bind(null,b,a),c)},useLayoutEffect:function(a,b){return sg(4,Pf|Sf,a,b)},
	useMemo:function(a,b){var c=mg();b=void 0===b?null:b;a=a();c.memoizedState=[a,b];return a},useReducer:function(a,b,c){var d=mg();b=void 0!==c?c(b):b;d.memoizedState=d.baseState=b;a=d.queue={last:null,dispatch:null,lastRenderedReducer:a,lastRenderedState:b};a=a.dispatch=wg.bind(null,Xf,a);return[d.memoizedState,a]},useRef:function(a){var b=mg();a={current:a};return b.memoizedState=a},useState:function(a){var b=mg();"function"===typeof a&&(a=a());b.memoizedState=b.baseState=a;a=b.queue={last:null,dispatch:null,
	lastRenderedReducer:og,lastRenderedState:a};a=a.dispatch=wg.bind(null,Xf,a);return[b.memoizedState,a]},useDebugValue:vg},jg={readContext:M$1,useCallback:function(a,b){var c=ng();b=void 0===b?null:b;var d=c.memoizedState;if(null!==d&&null!==b&&gg(b,d[1]))return d[0];c.memoizedState=[a,b];return a},useContext:M$1,useEffect:function(a,b){return tg(516,Uf|Tf,a,b)},useImperativeHandle:function(a,b,c){c=null!==c&&void 0!==c?c.concat([a]):null;return tg(4,Pf|Sf,ug.bind(null,b,a),c)},useLayoutEffect:function(a,
	b){return tg(4,Pf|Sf,a,b)},useMemo:function(a,b){var c=ng();b=void 0===b?null:b;var d=c.memoizedState;if(null!==d&&null!==b&&gg(b,d[1]))return d[0];a=a();c.memoizedState=[a,b];return a},useReducer:pg,useRef:function(){return ng().memoizedState},useState:function(a){return pg(og,a)},useDebugValue:vg},xg=null,yg=null,zg=!1;
	function Ag(a,b){var c=K$1(5,null,null,0);c.elementType="DELETED";c.type="DELETED";c.stateNode=b;c.return=a;c.effectTag=8;null!==a.lastEffect?(a.lastEffect.nextEffect=c, a.lastEffect=c):a.firstEffect=a.lastEffect=c;}function Bg(a,b){switch(a.tag){case 5:var c=a.type;b=1!==b.nodeType||c.toLowerCase()!==b.nodeName.toLowerCase()?null:b;return null!==b?(a.stateNode=b, !0):!1;case 6:return b=""===a.pendingProps||3!==b.nodeType?null:b, null!==b?(a.stateNode=b, !0):!1;case 13:return!1;default:return!1}}
	function Cg(a){if(zg){var b=yg;if(b){var c=b;if(!Bg(a,b)){b=De(c);if(!b||!Bg(a,b)){a.effectTag|=2;zg=!1;xg=a;return}Ag(xg,c);}xg=a;yg=Ee(b);}else a.effectTag|=2, zg=!1, xg=a;}}function Dg(a){for(a=a.return;null!==a&&5!==a.tag&&3!==a.tag&&18!==a.tag;)a=a.return;xg=a;}function Eg(a){if(a!==xg)return!1;if(!zg)return Dg(a), zg=!0, !1;var b=a.type;if(5!==a.tag||"head"!==b&&"body"!==b&&!xe(b,a.memoizedProps))for(b=yg;b;)Ag(a,b), b=De(b);Dg(a);yg=xg?De(a.stateNode):null;return!0}function Fg(){yg=xg=null;zg=!1;}
	var Gg=Tb.ReactCurrentOwner,qg=!1;function S$1(a,b,c,d){b.child=null===a?Ef(b,null,c,d):Df(b,a.child,c,d);}function Hg(a,b,c,d,e){c=c.render;var f=b.ref;Ig(b,e);d=hg(a,b,c,d,f,e);if(null!==a&&!qg)return b.updateQueue=a.updateQueue, b.effectTag&=-517, a.expirationTime<=e&&(a.expirationTime=0), Jg(a,b,e);b.effectTag|=1;S$1(a,b,d,e);return b.child}
	function Kg(a,b,c,d,e,f){if(null===a){var g=c.type;if("function"===typeof g&&!Ve(g)&&void 0===g.defaultProps&&null===c.compare&&void 0===c.defaultProps)return b.tag=15, b.type=g, Lg(a,b,g,d,e,f);a=Ye(c.type,null,d,null,b.mode,f);a.ref=b.ref;a.return=b;return b.child=a}g=a.child;if(e<f&&(e=g.memoizedProps, c=c.compare, c=null!==c?c:dd, c(e,d)&&a.ref===b.ref))return Jg(a,b,f);b.effectTag|=1;a=Xe(g,d,f);a.ref=b.ref;a.return=b;return b.child=a}
	function Lg(a,b,c,d,e,f){return null!==a&&dd(a.memoizedProps,d)&&a.ref===b.ref&&(qg=!1, e<f)?Jg(a,b,f):Mg(a,b,c,d,f)}function Ng(a,b){var c=b.ref;if(null===a&&null!==c||null!==a&&a.ref!==c)b.effectTag|=128;}function Mg(a,b,c,d,e){var f=J$1(c)?Ie:H$1.current;f=Je(b,f);Ig(b,e);c=hg(a,b,c,d,f,e);if(null!==a&&!qg)return b.updateQueue=a.updateQueue, b.effectTag&=-517, a.expirationTime<=e&&(a.expirationTime=0), Jg(a,b,e);b.effectTag|=1;S$1(a,b,c,e);return b.child}
	function Og(a,b,c,d,e){if(J$1(c)){var f=!0;Oe(b);}else f=!1;Ig(b,e);if(null===b.stateNode)null!==a&&(a.alternate=null, b.alternate=null, b.effectTag|=2), vf(b,c,d,e), xf(b,c,d,e), d=!0;else if(null===a){var g=b.stateNode,h=b.memoizedProps;g.props=h;var l=g.context,k=c.contextType;"object"===typeof k&&null!==k?k=M$1(k):(k=J$1(c)?Ie:H$1.current, k=Je(b,k));var m=c.getDerivedStateFromProps,p="function"===typeof m||"function"===typeof g.getSnapshotBeforeUpdate;p||"function"!==typeof g.UNSAFE_componentWillReceiveProps&&
	"function"!==typeof g.componentWillReceiveProps||(h!==d||l!==k)&&wf(b,g,d,k);Pg=!1;var t=b.memoizedState;l=g.state=t;var A=b.updateQueue;null!==A&&(yf(b,A,d,g,e), l=b.memoizedState);h!==d||t!==l||I$1.current||Pg?("function"===typeof m&&(kf(b,c,m,d), l=b.memoizedState), (h=Pg||uf(b,c,h,d,t,l,k))?(p||"function"!==typeof g.UNSAFE_componentWillMount&&"function"!==typeof g.componentWillMount||("function"===typeof g.componentWillMount&&g.componentWillMount(), "function"===typeof g.UNSAFE_componentWillMount&&
	g.UNSAFE_componentWillMount()), "function"===typeof g.componentDidMount&&(b.effectTag|=4)):("function"===typeof g.componentDidMount&&(b.effectTag|=4), b.memoizedProps=d, b.memoizedState=l), g.props=d, g.state=l, g.context=k, d=h):("function"===typeof g.componentDidMount&&(b.effectTag|=4), d=!1);}else g=b.stateNode, h=b.memoizedProps, g.props=b.type===b.elementType?h:L$1(b.type,h), l=g.context, k=c.contextType, "object"===typeof k&&null!==k?k=M$1(k):(k=J$1(c)?Ie:H$1.current, k=Je(b,k)), m=c.getDerivedStateFromProps, (p="function"===
	typeof m||"function"===typeof g.getSnapshotBeforeUpdate)||"function"!==typeof g.UNSAFE_componentWillReceiveProps&&"function"!==typeof g.componentWillReceiveProps||(h!==d||l!==k)&&wf(b,g,d,k), Pg=!1, l=b.memoizedState, t=g.state=l, A=b.updateQueue, null!==A&&(yf(b,A,d,g,e), t=b.memoizedState), h!==d||l!==t||I$1.current||Pg?("function"===typeof m&&(kf(b,c,m,d), t=b.memoizedState), (m=Pg||uf(b,c,h,d,l,t,k))?(p||"function"!==typeof g.UNSAFE_componentWillUpdate&&"function"!==typeof g.componentWillUpdate||("function"===
	typeof g.componentWillUpdate&&g.componentWillUpdate(d,t,k), "function"===typeof g.UNSAFE_componentWillUpdate&&g.UNSAFE_componentWillUpdate(d,t,k)), "function"===typeof g.componentDidUpdate&&(b.effectTag|=4), "function"===typeof g.getSnapshotBeforeUpdate&&(b.effectTag|=256)):("function"!==typeof g.componentDidUpdate||h===a.memoizedProps&&l===a.memoizedState||(b.effectTag|=4), "function"!==typeof g.getSnapshotBeforeUpdate||h===a.memoizedProps&&l===a.memoizedState||(b.effectTag|=256), b.memoizedProps=d, b.memoizedState=
	t), g.props=d, g.state=t, g.context=k, d=m):("function"!==typeof g.componentDidUpdate||h===a.memoizedProps&&l===a.memoizedState||(b.effectTag|=4), "function"!==typeof g.getSnapshotBeforeUpdate||h===a.memoizedProps&&l===a.memoizedState||(b.effectTag|=256), d=!1);return Qg(a,b,c,d,f,e)}
	function Qg(a,b,c,d,e,f){Ng(a,b);var g=0!==(b.effectTag&64);if(!d&&!g)return e&&Pe(b,c,!1), Jg(a,b,f);d=b.stateNode;Gg.current=b;var h=g&&"function"!==typeof c.getDerivedStateFromError?null:d.render();b.effectTag|=1;null!==a&&g?(b.child=Df(b,a.child,null,f), b.child=Df(b,null,h,f)):S$1(a,b,h,f);b.memoizedState=d.state;e&&Pe(b,c,!0);return b.child}function Rg(a){var b=a.stateNode;b.pendingContext?Me(a,b.pendingContext,b.pendingContext!==b.context):b.context&&Me(a,b.context,!1);Jf(a,b.containerInfo);}
	function Sg(a,b,c){var d=b.mode,e=b.pendingProps,f=b.memoizedState;if(0===(b.effectTag&64)){f=null;var g=!1;}else f={timedOutAt:null!==f?f.timedOutAt:0}, g=!0, b.effectTag&=-65;if(null===a)if(g){var h=e.fallback;a=Ze(null,d,0,null);0===(b.mode&1)&&(a.child=null!==b.memoizedState?b.child.child:b.child);d=Ze(h,d,c,null);a.sibling=d;c=a;c.return=d.return=b;}else c=d=Ef(b,null,e.children,c);else null!==a.memoizedState?(d=a.child, h=d.sibling, g?(c=e.fallback, e=Xe(d,d.pendingProps,0), 0===(b.mode&1)&&(g=null!==
	b.memoizedState?b.child.child:b.child, g!==d.child&&(e.child=g)), d=e.sibling=Xe(h,c,h.expirationTime), c=e, e.childExpirationTime=0, c.return=d.return=b):c=d=Df(b,d.child,e.children,c)):(h=a.child, g?(g=e.fallback, e=Ze(null,d,0,null), e.child=h, 0===(b.mode&1)&&(e.child=null!==b.memoizedState?b.child.child:b.child), d=e.sibling=Ze(g,d,c,null), d.effectTag|=2, c=e, e.childExpirationTime=0, c.return=d.return=b):d=c=Df(b,h,e.children,c)), b.stateNode=a.stateNode;b.memoizedState=f;b.child=c;return d}
	function Jg(a,b,c){null!==a&&(b.contextDependencies=a.contextDependencies);if(b.childExpirationTime<c)return null;null!==a&&b.child!==a.child?x$1("153"):void 0;if(null!==b.child){a=b.child;c=Xe(a,a.pendingProps,a.expirationTime);b.child=c;for(c.return=b;null!==a.sibling;)a=a.sibling, c=c.sibling=Xe(a,a.pendingProps,a.expirationTime), c.return=b;c.sibling=null;}return b.child}
	function Tg(a,b,c){var d=b.expirationTime;if(null!==a)if(a.memoizedProps!==b.pendingProps||I$1.current)qg=!0;else{if(d<c){qg=!1;switch(b.tag){case 3:Rg(b);Fg();break;case 5:Lf(b);break;case 1:J$1(b.type)&&Oe(b);break;case 4:Jf(b,b.stateNode.containerInfo);break;case 10:Ug(b,b.memoizedProps.value);break;case 13:if(null!==b.memoizedState){d=b.child.childExpirationTime;if(0!==d&&d>=c)return Sg(a,b,c);b=Jg(a,b,c);return null!==b?b.sibling:null}}return Jg(a,b,c)}}else qg=!1;b.expirationTime=0;switch(b.tag){case 2:d=
	b.elementType;null!==a&&(a.alternate=null, b.alternate=null, b.effectTag|=2);a=b.pendingProps;var e=Je(b,H$1.current);Ig(b,c);e=hg(null,b,d,a,e,c);b.effectTag|=1;if("object"===typeof e&&null!==e&&"function"===typeof e.render&&void 0===e.$$typeof){b.tag=1;lg();if(J$1(d)){var f=!0;Oe(b);}else f=!1;b.memoizedState=null!==e.state&&void 0!==e.state?e.state:null;var g=d.getDerivedStateFromProps;"function"===typeof g&&kf(b,d,g,a);e.updater=tf;b.stateNode=e;e._reactInternalFiber=b;xf(b,d,a,c);b=Qg(null,b,d,!0,f,
	c);}else b.tag=0, S$1(null,b,e,c), b=b.child;return b;case 16:e=b.elementType;null!==a&&(a.alternate=null, b.alternate=null, b.effectTag|=2);f=b.pendingProps;a=hf(e);b.type=a;e=b.tag=We(a);f=L$1(a,f);g=void 0;switch(e){case 0:g=Mg(null,b,a,f,c);break;case 1:g=Og(null,b,a,f,c);break;case 11:g=Hg(null,b,a,f,c);break;case 14:g=Kg(null,b,a,L$1(a.type,f),d,c);break;default:x$1("306",a,"");}return g;case 0:return d=b.type, e=b.pendingProps, e=b.elementType===d?e:L$1(d,e), Mg(a,b,d,e,c);case 1:return d=b.type, e=b.pendingProps, e=b.elementType===d?e:L$1(d,e), Og(a,b,d,e,c);case 3:Rg(b);d=b.updateQueue;null===d?x$1("282"):void 0;e=b.memoizedState;e=null!==e?e.element:null;yf(b,d,b.pendingProps,null,c);d=b.memoizedState.element;if(d===e)Fg(), b=Jg(a,b,c);else{e=b.stateNode;if(e=(null===a||null===a.child)&&e.hydrate)yg=Ee(b.stateNode.containerInfo), xg=b, e=zg=!0;e?(b.effectTag|=2, b.child=Ef(b,null,d,c)):(S$1(a,b,d,c), Fg());b=b.child;}return b;case 5:return Lf(b), null===a&&Cg(b), d=b.type, e=b.pendingProps, f=null!==a?a.memoizedProps:null, g=e.children, xe(d,e)?g=null:null!==f&&xe(d,f)&&(b.effectTag|=16), Ng(a,b), 1!==c&&b.mode&1&&e.hidden?(b.expirationTime=b.childExpirationTime=1, b=null):(S$1(a,b,g,c), b=b.child), b;case 6:return null===a&&Cg(b), null;case 13:return Sg(a,b,c);case 4:return Jf(b,b.stateNode.containerInfo), d=b.pendingProps, null===a?b.child=Df(b,null,d,c):S$1(a,b,d,c), b.child;case 11:return d=b.type, e=b.pendingProps, e=b.elementType===d?e:L$1(d,e), Hg(a,b,d,e,c);case 7:return S$1(a,b,b.pendingProps,c), b.child;case 8:return S$1(a,b,b.pendingProps.children,
	c), b.child;case 12:return S$1(a,b,b.pendingProps.children,c), b.child;case 10:a:{d=b.type._context;e=b.pendingProps;g=b.memoizedProps;f=e.value;Ug(b,f);if(null!==g){var h=g.value;f=bd(h,f)?0:("function"===typeof d._calculateChangedBits?d._calculateChangedBits(h,f):1073741823)|0;if(0===f){if(g.children===e.children&&!I$1.current){b=Jg(a,b,c);break a}}else for(h=b.child, null!==h&&(h.return=b);null!==h;){var l=h.contextDependencies;if(null!==l){g=h.child;for(var k=l.first;null!==k;){if(k.context===d&&0!==
	(k.observedBits&f)){1===h.tag&&(k=nf(c), k.tag=sf, pf(h,k));h.expirationTime<c&&(h.expirationTime=c);k=h.alternate;null!==k&&k.expirationTime<c&&(k.expirationTime=c);k=c;for(var m=h.return;null!==m;){var p=m.alternate;if(m.childExpirationTime<k)m.childExpirationTime=k, null!==p&&p.childExpirationTime<k&&(p.childExpirationTime=k);else if(null!==p&&p.childExpirationTime<k)p.childExpirationTime=k;else break;m=m.return;}l.expirationTime<c&&(l.expirationTime=c);break}k=k.next;}}else g=10===h.tag?h.type===b.type?
	null:h.child:h.child;if(null!==g)g.return=h;else for(g=h;null!==g;){if(g===b){g=null;break}h=g.sibling;if(null!==h){h.return=g.return;g=h;break}g=g.return;}h=g;}}S$1(a,b,e.children,c);b=b.child;}return b;case 9:return e=b.type, f=b.pendingProps, d=f.children, Ig(b,c), e=M$1(e,f.unstable_observedBits), d=d(e), b.effectTag|=1, S$1(a,b,d,c), b.child;case 14:return e=b.type, f=L$1(e,b.pendingProps), f=L$1(e.type,f), Kg(a,b,e,f,d,c);case 15:return Lg(a,b,b.type,b.pendingProps,d,c);case 17:return d=b.type, e=b.pendingProps, e=b.elementType===
	d?e:L$1(d,e), null!==a&&(a.alternate=null, b.alternate=null, b.effectTag|=2), b.tag=1, J$1(d)?(a=!0, Oe(b)):a=!1, Ig(b,c), vf(b,d,e,c), xf(b,d,e,c), Qg(null,b,d,!0,a,c)}x$1("156");}var Vg={current:null},Wg=null,Xg=null,Yg=null;function Ug(a,b){var c=a.type._context;G$1(Vg,c._currentValue,a);c._currentValue=b;}function Zg(a){var b=Vg.current;F$1(Vg,a);a.type._context._currentValue=b;}function Ig(a,b){Wg=a;Yg=Xg=null;var c=a.contextDependencies;null!==c&&c.expirationTime>=b&&(qg=!0);a.contextDependencies=null;}
	function M$1(a,b){if(Yg!==a&&!1!==b&&0!==b){if("number"!==typeof b||1073741823===b)Yg=a, b=1073741823;b={context:a,observedBits:b,next:null};null===Xg?(null===Wg?x$1("308"):void 0, Xg=b, Wg.contextDependencies={first:b,expirationTime:0}):Xg=Xg.next=b;}return a._currentValue}var $g=0,rf=1,sf=2,ah=3,Pg=!1;function bh(a){return{baseState:a,firstUpdate:null,lastUpdate:null,firstCapturedUpdate:null,lastCapturedUpdate:null,firstEffect:null,lastEffect:null,firstCapturedEffect:null,lastCapturedEffect:null}}
	function ch(a){return{baseState:a.baseState,firstUpdate:a.firstUpdate,lastUpdate:a.lastUpdate,firstCapturedUpdate:null,lastCapturedUpdate:null,firstEffect:null,lastEffect:null,firstCapturedEffect:null,lastCapturedEffect:null}}function nf(a){return{expirationTime:a,tag:$g,payload:null,callback:null,next:null,nextEffect:null}}function dh(a,b){null===a.lastUpdate?a.firstUpdate=a.lastUpdate=b:(a.lastUpdate.next=b, a.lastUpdate=b);}
	function pf(a,b){var c=a.alternate;if(null===c){var d=a.updateQueue;var e=null;null===d&&(d=a.updateQueue=bh(a.memoizedState));}else d=a.updateQueue, e=c.updateQueue, null===d?null===e?(d=a.updateQueue=bh(a.memoizedState), e=c.updateQueue=bh(c.memoizedState)):d=a.updateQueue=ch(e):null===e&&(e=c.updateQueue=ch(d));null===e||d===e?dh(d,b):null===d.lastUpdate||null===e.lastUpdate?(dh(d,b), dh(e,b)):(dh(d,b), e.lastUpdate=b);}
	function eh(a,b){var c=a.updateQueue;c=null===c?a.updateQueue=bh(a.memoizedState):fh(a,c);null===c.lastCapturedUpdate?c.firstCapturedUpdate=c.lastCapturedUpdate=b:(c.lastCapturedUpdate.next=b, c.lastCapturedUpdate=b);}function fh(a,b){var c=a.alternate;null!==c&&b===c.updateQueue&&(b=a.updateQueue=ch(b));return b}
	function gh(a,b,c,d,e,f){switch(c.tag){case rf:return a=c.payload, "function"===typeof a?a.call(f,d,e):a;case ah:a.effectTag=a.effectTag&-2049|64;case $g:a=c.payload;e="function"===typeof a?a.call(f,d,e):a;if(null===e||void 0===e)break;return objectAssign({},d,e);case sf:Pg=!0;}return d}
	function yf(a,b,c,d,e){Pg=!1;b=fh(a,b);for(var f=b.baseState,g=null,h=0,l=b.firstUpdate,k=f;null!==l;){var m=l.expirationTime;m<e?(null===g&&(g=l, f=k), h<m&&(h=m)):(k=gh(a,b,l,k,c,d), null!==l.callback&&(a.effectTag|=32, l.nextEffect=null, null===b.lastEffect?b.firstEffect=b.lastEffect=l:(b.lastEffect.nextEffect=l, b.lastEffect=l)));l=l.next;}m=null;for(l=b.firstCapturedUpdate;null!==l;){var p=l.expirationTime;p<e?(null===m&&(m=l, null===g&&(f=k)), h<p&&(h=p)):(k=gh(a,b,l,k,c,d), null!==l.callback&&(a.effectTag|=
	32, l.nextEffect=null, null===b.lastCapturedEffect?b.firstCapturedEffect=b.lastCapturedEffect=l:(b.lastCapturedEffect.nextEffect=l, b.lastCapturedEffect=l)));l=l.next;}null===g&&(b.lastUpdate=null);null===m?b.lastCapturedUpdate=null:a.effectTag|=32;null===g&&null===m&&(f=k);b.baseState=f;b.firstUpdate=g;b.firstCapturedUpdate=m;a.expirationTime=h;a.memoizedState=k;}
	function hh(a,b,c){null!==b.firstCapturedUpdate&&(null!==b.lastUpdate&&(b.lastUpdate.next=b.firstCapturedUpdate, b.lastUpdate=b.lastCapturedUpdate), b.firstCapturedUpdate=b.lastCapturedUpdate=null);ih(b.firstEffect,c);b.firstEffect=b.lastEffect=null;ih(b.firstCapturedEffect,c);b.firstCapturedEffect=b.lastCapturedEffect=null;}function ih(a,b){for(;null!==a;){var c=a.callback;if(null!==c){a.callback=null;var d=b;"function"!==typeof c?x$1("191",c):void 0;c.call(d);}a=a.nextEffect;}}
	function jh(a,b){return{value:a,source:b,stack:jc(b)}}function kh(a){a.effectTag|=4;}var lh=void 0,mh=void 0,nh=void 0,oh=void 0;lh=function(a,b){for(var c=b.child;null!==c;){if(5===c.tag||6===c.tag)a.appendChild(c.stateNode);else if(4!==c.tag&&null!==c.child){c.child.return=c;c=c.child;continue}if(c===b)break;for(;null===c.sibling;){if(null===c.return||c.return===b)return;c=c.return;}c.sibling.return=c.return;c=c.sibling;}};mh=function(){};
	nh=function(a,b,c,d,e){var f=a.memoizedProps;if(f!==d){var g=b.stateNode;If(N$1.current);a=null;switch(c){case "input":f=vc(g,f);d=vc(g,d);a=[];break;case "option":f=$d(g,f);d=$d(g,d);a=[];break;case "select":f=objectAssign({},f,{value:void 0});d=objectAssign({},d,{value:void 0});a=[];break;case "textarea":f=be(g,f);d=be(g,d);a=[];break;default:"function"!==typeof f.onClick&&"function"===typeof d.onClick&&(g.onclick=te);}qe(c,d);g=c=void 0;var h=null;for(c in f)if(!d.hasOwnProperty(c)&&f.hasOwnProperty(c)&&null!=f[c])if("style"===
	c){var l=f[c];for(g in l)l.hasOwnProperty(g)&&(h||(h={}), h[g]="");}else"dangerouslySetInnerHTML"!==c&&"children"!==c&&"suppressContentEditableWarning"!==c&&"suppressHydrationWarning"!==c&&"autoFocus"!==c&&(ra.hasOwnProperty(c)?a||(a=[]):(a=a||[]).push(c,null));for(c in d){var k=d[c];l=null!=f?f[c]:void 0;if(d.hasOwnProperty(c)&&k!==l&&(null!=k||null!=l))if("style"===c)if(l){for(g in l)!l.hasOwnProperty(g)||k&&k.hasOwnProperty(g)||(h||(h={}), h[g]="");for(g in k)k.hasOwnProperty(g)&&l[g]!==k[g]&&(h||
	(h={}), h[g]=k[g]);}else h||(a||(a=[]), a.push(c,h)), h=k;else"dangerouslySetInnerHTML"===c?(k=k?k.__html:void 0, l=l?l.__html:void 0, null!=k&&l!==k&&(a=a||[]).push(c,""+k)):"children"===c?l===k||"string"!==typeof k&&"number"!==typeof k||(a=a||[]).push(c,""+k):"suppressContentEditableWarning"!==c&&"suppressHydrationWarning"!==c&&(ra.hasOwnProperty(c)?(null!=k&&se(e,c), a||l===k||(a=[])):(a=a||[]).push(c,k));}h&&(a=a||[]).push("style",h);e=a;(b.updateQueue=e)&&kh(b);}};oh=function(a,b,c,d){c!==d&&kh(b);};
	var ph="function"===typeof WeakSet?WeakSet:Set;function qh(a,b){var c=b.source,d=b.stack;null===d&&null!==c&&(d=jc(c));null!==c&&ic(c.type);b=b.value;null!==a&&1===a.tag&&ic(a.type);try{console.error(b);}catch(e){setTimeout(function(){throw e;});}}function rh(a){var b=a.ref;if(null!==b)if("function"===typeof b)try{b(null);}catch(c){sh(a,c);}else b.current=null;}
	function th(a,b,c){c=c.updateQueue;c=null!==c?c.lastEffect:null;if(null!==c){var d=c=c.next;do{if((d.tag&a)!==Nf){var e=d.destroy;d.destroy=void 0;void 0!==e&&e();}(d.tag&b)!==Nf&&(e=d.create, d.destroy=e());d=d.next;}while(d!==c)}}
	function uh(a,b){for(var c=a;;){if(5===c.tag){var d=c.stateNode;if(b)d.style.display="none";else{d=c.stateNode;var e=c.memoizedProps.style;e=void 0!==e&&null!==e&&e.hasOwnProperty("display")?e.display:null;d.style.display=ne("display",e);}}else if(6===c.tag)c.stateNode.nodeValue=b?"":c.memoizedProps;else if(13===c.tag&&null!==c.memoizedState){d=c.child.sibling;d.return=c;c=d;continue}else if(null!==c.child){c.child.return=c;c=c.child;continue}if(c===a)break;for(;null===c.sibling;){if(null===c.return||
	c.return===a)return;c=c.return;}c.sibling.return=c.return;c=c.sibling;}}
	function vh(a){"function"===typeof Re&&Re(a);switch(a.tag){case 0:case 11:case 14:case 15:var b=a.updateQueue;if(null!==b&&(b=b.lastEffect, null!==b)){var c=b=b.next;do{var d=c.destroy;if(void 0!==d){var e=a;try{d();}catch(f){sh(e,f);}}c=c.next;}while(c!==b)}break;case 1:rh(a);b=a.stateNode;if("function"===typeof b.componentWillUnmount)try{b.props=a.memoizedProps, b.state=a.memoizedState, b.componentWillUnmount();}catch(f){sh(a,f);}break;case 5:rh(a);break;case 4:wh(a);}}
	function xh(a){return 5===a.tag||3===a.tag||4===a.tag}
	function yh(a){a:{for(var b=a.return;null!==b;){if(xh(b)){var c=b;break a}b=b.return;}x$1("160");c=void 0;}var d=b=void 0;switch(c.tag){case 5:b=c.stateNode;d=!1;break;case 3:b=c.stateNode.containerInfo;d=!0;break;case 4:b=c.stateNode.containerInfo;d=!0;break;default:x$1("161");}c.effectTag&16&&(ke(b,""), c.effectTag&=-17);a:b:for(c=a;;){for(;null===c.sibling;){if(null===c.return||xh(c.return)){c=null;break a}c=c.return;}c.sibling.return=c.return;for(c=c.sibling;5!==c.tag&&6!==c.tag&&18!==c.tag;){if(c.effectTag&
	2)continue b;if(null===c.child||4===c.tag)continue b;else c.child.return=c, c=c.child;}if(!(c.effectTag&2)){c=c.stateNode;break a}}for(var e=a;;){if(5===e.tag||6===e.tag)if(c)if(d){var f=b,g=e.stateNode,h=c;8===f.nodeType?f.parentNode.insertBefore(g,h):f.insertBefore(g,h);}else b.insertBefore(e.stateNode,c);else d?(g=b, h=e.stateNode, 8===g.nodeType?(f=g.parentNode, f.insertBefore(h,g)):(f=g, f.appendChild(h)), g=g._reactRootContainer, null!==g&&void 0!==g||null!==f.onclick||(f.onclick=te)):b.appendChild(e.stateNode);
	else if(4!==e.tag&&null!==e.child){e.child.return=e;e=e.child;continue}if(e===a)break;for(;null===e.sibling;){if(null===e.return||e.return===a)return;e=e.return;}e.sibling.return=e.return;e=e.sibling;}}
	function wh(a){for(var b=a,c=!1,d=void 0,e=void 0;;){if(!c){c=b.return;a:for(;;){null===c?x$1("160"):void 0;switch(c.tag){case 5:d=c.stateNode;e=!1;break a;case 3:d=c.stateNode.containerInfo;e=!0;break a;case 4:d=c.stateNode.containerInfo;e=!0;break a}c=c.return;}c=!0;}if(5===b.tag||6===b.tag){a:for(var f=b,g=f;;)if(vh(g), null!==g.child&&4!==g.tag)g.child.return=g, g=g.child;else{if(g===f)break;for(;null===g.sibling;){if(null===g.return||g.return===f)break a;g=g.return;}g.sibling.return=g.return;g=g.sibling;}e?
	(f=d, g=b.stateNode, 8===f.nodeType?f.parentNode.removeChild(g):f.removeChild(g)):d.removeChild(b.stateNode);}else if(4===b.tag){if(null!==b.child){d=b.stateNode.containerInfo;e=!0;b.child.return=b;b=b.child;continue}}else if(vh(b), null!==b.child){b.child.return=b;b=b.child;continue}if(b===a)break;for(;null===b.sibling;){if(null===b.return||b.return===a)return;b=b.return;4===b.tag&&(c=!1);}b.sibling.return=b.return;b=b.sibling;}}
	function zh(a,b){switch(b.tag){case 0:case 11:case 14:case 15:th(Pf,Qf,b);break;case 1:break;case 5:var c=b.stateNode;if(null!=c){var d=b.memoizedProps;a=null!==a?a.memoizedProps:d;var e=b.type,f=b.updateQueue;b.updateQueue=null;null!==f&&Ce(c,f,e,a,d,b);}break;case 6:null===b.stateNode?x$1("162"):void 0;b.stateNode.nodeValue=b.memoizedProps;break;case 3:break;case 12:break;case 13:c=b.memoizedState;d=void 0;a=b;null===c?d=!1:(d=!0, a=b.child, 0===c.timedOutAt&&(c.timedOutAt=lf()));null!==a&&uh(a,d);c=
	b.updateQueue;if(null!==c){b.updateQueue=null;var g=b.stateNode;null===g&&(g=b.stateNode=new ph);c.forEach(function(a){var c=Ah.bind(null,b,a);g.has(a)||(g.add(a), a.then(c,c));});}break;case 17:break;default:x$1("163");}}var Bh="function"===typeof WeakMap?WeakMap:Map;function Ch(a,b,c){c=nf(c);c.tag=ah;c.payload={element:null};var d=b.value;c.callback=function(){Dh(d);qh(a,b);};return c}
	function Eh(a,b,c){c=nf(c);c.tag=ah;var d=a.type.getDerivedStateFromError;if("function"===typeof d){var e=b.value;c.payload=function(){return d(e)};}var f=a.stateNode;null!==f&&"function"===typeof f.componentDidCatch&&(c.callback=function(){"function"!==typeof d&&(null===Fh?Fh=new Set([this]):Fh.add(this));var c=b.value,e=b.stack;qh(a,b);this.componentDidCatch(c,{componentStack:null!==e?e:""});});return c}
	function Gh(a){switch(a.tag){case 1:J$1(a.type)&&Ke(a);var b=a.effectTag;return b&2048?(a.effectTag=b&-2049|64, a):null;case 3:return Kf(a), Le(a), b=a.effectTag, 0!==(b&64)?x$1("285"):void 0, a.effectTag=b&-2049|64, a;case 5:return Mf(a), null;case 13:return b=a.effectTag, b&2048?(a.effectTag=b&-2049|64, a):null;case 18:return null;case 4:return Kf(a), null;case 10:return Zg(a), null;default:return null}}
	var Hh=Tb.ReactCurrentDispatcher,Ih=Tb.ReactCurrentOwner,Jh=1073741822,Kh=!1,T$1=null,Lh=null,U$1=0,Mh=-1,Nh=!1,V$1=null,Oh=!1,Ph=null,Qh=null,Rh=null,Fh=null;function Sh(){if(null!==T$1)for(var a=T$1.return;null!==a;){var b=a;switch(b.tag){case 1:var c=b.type.childContextTypes;null!==c&&void 0!==c&&Ke(b);break;case 3:Kf(b);Le(b);break;case 5:Mf(b);break;case 4:Kf(b);break;case 10:Zg(b);}a=a.return;}Lh=null;U$1=0;Mh=-1;Nh=!1;T$1=null;}
	function Th(){for(;null!==V$1;){var a=V$1.effectTag;a&16&&ke(V$1.stateNode,"");if(a&128){var b=V$1.alternate;null!==b&&(b=b.ref, null!==b&&("function"===typeof b?b(null):b.current=null));}switch(a&14){case 2:yh(V$1);V$1.effectTag&=-3;break;case 6:yh(V$1);V$1.effectTag&=-3;zh(V$1.alternate,V$1);break;case 4:zh(V$1.alternate,V$1);break;case 8:a=V$1, wh(a), a.return=null, a.child=null, a.memoizedState=null, a.updateQueue=null, a=a.alternate, null!==a&&(a.return=null, a.child=null, a.memoizedState=null, a.updateQueue=null);}V$1=V$1.nextEffect;}}
	function Uh(){for(;null!==V$1;){if(V$1.effectTag&256)a:{var a=V$1.alternate,b=V$1;switch(b.tag){case 0:case 11:case 15:th(Of,Nf,b);break a;case 1:if(b.effectTag&256&&null!==a){var c=a.memoizedProps,d=a.memoizedState;a=b.stateNode;b=a.getSnapshotBeforeUpdate(b.elementType===b.type?c:L$1(b.type,c),d);a.__reactInternalSnapshotBeforeUpdate=b;}break a;case 3:case 5:case 6:case 4:case 17:break a;default:x$1("163");}}V$1=V$1.nextEffect;}}
	function Vh(a,b){for(;null!==V$1;){var c=V$1.effectTag;if(c&36){var d=V$1.alternate,e=V$1,f=b;switch(e.tag){case 0:case 11:case 15:th(Rf,Sf,e);break;case 1:var g=e.stateNode;if(e.effectTag&4)if(null===d)g.componentDidMount();else{var h=e.elementType===e.type?d.memoizedProps:L$1(e.type,d.memoizedProps);g.componentDidUpdate(h,d.memoizedState,g.__reactInternalSnapshotBeforeUpdate);}d=e.updateQueue;null!==d&&hh(e,d,g,f);break;case 3:d=e.updateQueue;if(null!==d){g=null;if(null!==e.child)switch(e.child.tag){case 5:g=
	e.child.stateNode;break;case 1:g=e.child.stateNode;}hh(e,d,g,f);}break;case 5:f=e.stateNode;null===d&&e.effectTag&4&&we(e.type,e.memoizedProps)&&f.focus();break;case 6:break;case 4:break;case 12:break;case 13:break;case 17:break;default:x$1("163");}}c&128&&(e=V$1.ref, null!==e&&(f=V$1.stateNode, "function"===typeof e?e(f):e.current=f));c&512&&(Ph=a);V$1=V$1.nextEffect;}}
	function Wh(a,b){Rh=Qh=Ph=null;var c=W$1;W$1=!0;do{if(b.effectTag&512){var d=!1,e=void 0;try{var f=b;th(Uf,Nf,f);th(Nf,Tf,f);}catch(g){d=!0, e=g;}d&&sh(b,e);}b=b.nextEffect;}while(null!==b);W$1=c;c=a.expirationTime;0!==c&&Xh(a,c);X$1||W$1||Yh(1073741823,!1);}function of(){null!==Qh&&Be(Qh);null!==Rh&&Rh();}
	function Zh(a,b){Oh=Kh=!0;a.current===b?x$1("177"):void 0;var c=a.pendingCommitExpirationTime;0===c?x$1("261"):void 0;a.pendingCommitExpirationTime=0;var d=b.expirationTime,e=b.childExpirationTime;ef(a,e>d?e:d);Ih.current=null;d=void 0;1<b.effectTag?null!==b.lastEffect?(b.lastEffect.nextEffect=b, d=b.firstEffect):d=b:d=b.firstEffect;ue=Bd;ve=Pd();Bd=!1;for(V$1=d;null!==V$1;){e=!1;var f=void 0;try{Uh();}catch(h){e=!0, f=h;}e&&(null===V$1?x$1("178"):void 0, sh(V$1,f), null!==V$1&&(V$1=V$1.nextEffect));}for(V$1=d;null!==V$1;){e=!1;
	f=void 0;try{Th();}catch(h){e=!0, f=h;}e&&(null===V$1?x$1("178"):void 0, sh(V$1,f), null!==V$1&&(V$1=V$1.nextEffect));}Qd(ve);ve=null;Bd=!!ue;ue=null;a.current=b;for(V$1=d;null!==V$1;){e=!1;f=void 0;try{Vh(a,c);}catch(h){e=!0, f=h;}e&&(null===V$1?x$1("178"):void 0, sh(V$1,f), null!==V$1&&(V$1=V$1.nextEffect));}if(null!==d&&null!==Ph){var g=Wh.bind(null,a,d);Qh=scheduler.unstable_runWithPriority(scheduler.unstable_NormalPriority,function(){return Ae(g)});Rh=g;}Kh=Oh=!1;"function"===typeof Qe&&Qe(b.stateNode);c=b.expirationTime;b=b.childExpirationTime;b=
	b>c?b:c;0===b&&(Fh=null);$h(a,b);}
	function ai(a){for(;;){var b=a.alternate,c=a.return,d=a.sibling;if(0===(a.effectTag&1024)){T$1=a;a:{var e=b;b=a;var f=U$1;var g=b.pendingProps;switch(b.tag){case 2:break;case 16:break;case 15:case 0:break;case 1:J$1(b.type)&&Ke(b);break;case 3:Kf(b);Le(b);g=b.stateNode;g.pendingContext&&(g.context=g.pendingContext, g.pendingContext=null);if(null===e||null===e.child)Eg(b), b.effectTag&=-3;mh(b);break;case 5:Mf(b);var h=If(Hf.current);f=b.type;if(null!==e&&null!=b.stateNode)nh(e,b,f,g,h), e.ref!==b.ref&&(b.effectTag|=
	128);else if(g){var l=If(N$1.current);if(Eg(b)){g=b;e=g.stateNode;var k=g.type,m=g.memoizedProps,p=h;e[Fa]=g;e[Ga]=m;f=void 0;h=k;switch(h){case "iframe":case "object":E$1("load",e);break;case "video":case "audio":for(k=0;k<ab.length;k++)E$1(ab[k],e);break;case "source":E$1("error",e);break;case "img":case "image":case "link":E$1("error",e);E$1("load",e);break;case "form":E$1("reset",e);E$1("submit",e);break;case "details":E$1("toggle",e);break;case "input":wc(e,m);E$1("invalid",e);se(p,"onChange");break;case "select":e._wrapperState=
	{wasMultiple:!!m.multiple};E$1("invalid",e);se(p,"onChange");break;case "textarea":ce(e,m), E$1("invalid",e), se(p,"onChange");}qe(h,m);k=null;for(f in m)m.hasOwnProperty(f)&&(l=m[f], "children"===f?"string"===typeof l?e.textContent!==l&&(k=["children",l]):"number"===typeof l&&e.textContent!==""+l&&(k=["children",""+l]):ra.hasOwnProperty(f)&&null!=l&&se(p,f));switch(h){case "input":Rb(e);Ac(e,m,!0);break;case "textarea":Rb(e);ee(e,m);break;case "select":case "option":break;default:"function"===typeof m.onClick&&
	(e.onclick=te);}f=k;g.updateQueue=f;g=null!==f?!0:!1;g&&kh(b);}else{m=b;p=f;e=g;k=9===h.nodeType?h:h.ownerDocument;l===fe.html&&(l=ge(p));l===fe.html?"script"===p?(e=k.createElement("div"), e.innerHTML="<script>\x3c/script>", k=e.removeChild(e.firstChild)):"string"===typeof e.is?k=k.createElement(p,{is:e.is}):(k=k.createElement(p), "select"===p&&(p=k, e.multiple?p.multiple=!0:e.size&&(p.size=e.size))):k=k.createElementNS(l,p);e=k;e[Fa]=m;e[Ga]=g;lh(e,b,!1,!1);p=e;k=f;m=g;var t=h,A=re(k,m);switch(k){case "iframe":case "object":E$1("load",
	p);h=m;break;case "video":case "audio":for(h=0;h<ab.length;h++)E$1(ab[h],p);h=m;break;case "source":E$1("error",p);h=m;break;case "img":case "image":case "link":E$1("error",p);E$1("load",p);h=m;break;case "form":E$1("reset",p);E$1("submit",p);h=m;break;case "details":E$1("toggle",p);h=m;break;case "input":wc(p,m);h=vc(p,m);E$1("invalid",p);se(t,"onChange");break;case "option":h=$d(p,m);break;case "select":p._wrapperState={wasMultiple:!!m.multiple};h=objectAssign({},m,{value:void 0});E$1("invalid",p);se(t,"onChange");break;case "textarea":ce(p,
	m);h=be(p,m);E$1("invalid",p);se(t,"onChange");break;default:h=m;}qe(k,h);l=void 0;var v=k,R=p,u=h;for(l in u)if(u.hasOwnProperty(l)){var q=u[l];"style"===l?oe(R,q):"dangerouslySetInnerHTML"===l?(q=q?q.__html:void 0, null!=q&&je(R,q)):"children"===l?"string"===typeof q?("textarea"!==v||""!==q)&&ke(R,q):"number"===typeof q&&ke(R,""+q):"suppressContentEditableWarning"!==l&&"suppressHydrationWarning"!==l&&"autoFocus"!==l&&(ra.hasOwnProperty(l)?null!=q&&se(t,l):null!=q&&tc(R,l,q,A));}switch(k){case "input":Rb(p);
	Ac(p,m,!1);break;case "textarea":Rb(p);ee(p,m);break;case "option":null!=m.value&&p.setAttribute("value",""+uc(m.value));break;case "select":h=p;h.multiple=!!m.multiple;p=m.value;null!=p?ae(h,!!m.multiple,p,!1):null!=m.defaultValue&&ae(h,!!m.multiple,m.defaultValue,!0);break;default:"function"===typeof h.onClick&&(p.onclick=te);}(g=we(f,g))&&kh(b);b.stateNode=e;}null!==b.ref&&(b.effectTag|=128);}else null===b.stateNode?x$1("166"):void 0;break;case 6:e&&null!=b.stateNode?oh(e,b,e.memoizedProps,g):("string"!==
	typeof g&&(null===b.stateNode?x$1("166"):void 0), e=If(Hf.current), If(N$1.current), Eg(b)?(g=b, f=g.stateNode, e=g.memoizedProps, f[Fa]=g, (g=f.nodeValue!==e)&&kh(b)):(f=b, g=(9===e.nodeType?e:e.ownerDocument).createTextNode(g), g[Fa]=b, f.stateNode=g));break;case 11:break;case 13:g=b.memoizedState;if(0!==(b.effectTag&64)){b.expirationTime=f;T$1=b;break a}g=null!==g;f=null!==e&&null!==e.memoizedState;null!==e&&!g&&f&&(e=e.child.sibling, null!==e&&(h=b.firstEffect, null!==h?(b.firstEffect=e, e.nextEffect=h):(b.firstEffect=
	b.lastEffect=e, e.nextEffect=null), e.effectTag=8));if(g||f)b.effectTag|=4;break;case 7:break;case 8:break;case 12:break;case 4:Kf(b);mh(b);break;case 10:Zg(b);break;case 9:break;case 14:break;case 17:J$1(b.type)&&Ke(b);break;case 18:break;default:x$1("156");}T$1=null;}b=a;if(1===U$1||1!==b.childExpirationTime){g=0;for(f=b.child;null!==f;)e=f.expirationTime, h=f.childExpirationTime, e>g&&(g=e), h>g&&(g=h), f=f.sibling;b.childExpirationTime=g;}if(null!==T$1)return T$1;null!==c&&0===(c.effectTag&1024)&&(null===c.firstEffect&&
	(c.firstEffect=a.firstEffect), null!==a.lastEffect&&(null!==c.lastEffect&&(c.lastEffect.nextEffect=a.firstEffect), c.lastEffect=a.lastEffect), 1<a.effectTag&&(null!==c.lastEffect?c.lastEffect.nextEffect=a:c.firstEffect=a, c.lastEffect=a));}else{a=Gh(a,U$1);if(null!==a)return a.effectTag&=1023, a;null!==c&&(c.firstEffect=c.lastEffect=null, c.effectTag|=1024);}if(null!==d)return d;if(null!==c)a=c;else break}return null}
	function bi(a){var b=Tg(a.alternate,a,U$1);a.memoizedProps=a.pendingProps;null===b&&(b=ai(a));Ih.current=null;return b}
	function ci(a,b){Kh?x$1("243"):void 0;of();Kh=!0;var c=Hh.current;Hh.current=kg;var d=a.nextExpirationTimeToWorkOn;if(d!==U$1||a!==Lh||null===T$1)Sh(), Lh=a, U$1=d, T$1=Xe(Lh.current,null,U$1), a.pendingCommitExpirationTime=0;var e=!1;do{try{if(b)for(;null!==T$1&&!di();)T$1=bi(T$1);else for(;null!==T$1;)T$1=bi(T$1);}catch(u){if(Yg=Xg=Wg=null, lg(), null===T$1)e=!0, Dh(u);else{null===T$1?x$1("271"):void 0;var f=T$1,g=f.return;if(null===g)e=!0, Dh(u);else{a:{var h=a,l=g,k=f,m=u;g=U$1;k.effectTag|=1024;k.firstEffect=k.lastEffect=null;if(null!==
	m&&"object"===typeof m&&"function"===typeof m.then){var p=m;m=l;var t=-1,A=-1;do{if(13===m.tag){var v=m.alternate;if(null!==v&&(v=v.memoizedState, null!==v)){A=10*(1073741822-v.timedOutAt);break}v=m.pendingProps.maxDuration;if("number"===typeof v)if(0>=v)t=0;else if(-1===t||v<t)t=v;}m=m.return;}while(null!==m);m=l;do{if(v=13===m.tag)v=void 0===m.memoizedProps.fallback?!1:null===m.memoizedState;if(v){l=m.updateQueue;null===l?(l=new Set, l.add(p), m.updateQueue=l):l.add(p);if(0===(m.mode&1)){m.effectTag|=
	64;k.effectTag&=-1957;1===k.tag&&(null===k.alternate?k.tag=17:(g=nf(1073741823), g.tag=sf, pf(k,g)));k.expirationTime=1073741823;break a}k=h;l=g;var R=k.pingCache;null===R?(R=k.pingCache=new Bh, v=new Set, R.set(p,v)):(v=R.get(p), void 0===v&&(v=new Set, R.set(p,v)));v.has(l)||(v.add(l), k=ei.bind(null,k,p,l), p.then(k,k));-1===t?h=1073741823:(-1===A&&(A=10*(1073741822-gf(h,g))-5E3), h=A+t);0<=h&&Mh<h&&(Mh=h);m.effectTag|=2048;m.expirationTime=g;break a}m=m.return;}while(null!==m);m=Error((ic(k.type)||"A React component")+
	" suspended while rendering, but no fallback UI was specified.\n\nAdd a <Suspense fallback=...> component higher in the tree to provide a loading indicator or placeholder to display."+jc(k));}Nh=!0;m=jh(m,k);h=l;do{switch(h.tag){case 3:h.effectTag|=2048;h.expirationTime=g;g=Ch(h,m,g);eh(h,g);break a;case 1:if(t=m, A=h.type, k=h.stateNode, 0===(h.effectTag&64)&&("function"===typeof A.getDerivedStateFromError||null!==k&&"function"===typeof k.componentDidCatch&&(null===Fh||!Fh.has(k)))){h.effectTag|=2048;
	h.expirationTime=g;g=Eh(h,t,g);eh(h,g);break a}}h=h.return;}while(null!==h)}T$1=ai(f);continue}}}break}while(1);Kh=!1;Hh.current=c;Yg=Xg=Wg=null;lg();if(e)Lh=null, a.finishedWork=null;else if(null!==T$1)a.finishedWork=null;else{c=a.current.alternate;null===c?x$1("281"):void 0;Lh=null;if(Nh){e=a.latestPendingTime;f=a.latestSuspendedTime;g=a.latestPingedTime;if(0!==e&&e<d||0!==f&&f<d||0!==g&&g<d){ff(a,d);fi(a,c,d,a.expirationTime,-1);return}if(!a.didError&&b){a.didError=!0;d=a.nextExpirationTimeToWorkOn=d;
	b=a.expirationTime=1073741823;fi(a,c,d,b,-1);return}}b&&-1!==Mh?(ff(a,d), b=10*(1073741822-gf(a,d)), b<Mh&&(Mh=b), b=10*(1073741822-lf()), b=Mh-b, fi(a,c,d,a.expirationTime,0>b?0:b)):(a.pendingCommitExpirationTime=d, a.finishedWork=c);}}
	function sh(a,b){for(var c=a.return;null!==c;){switch(c.tag){case 1:var d=c.stateNode;if("function"===typeof c.type.getDerivedStateFromError||"function"===typeof d.componentDidCatch&&(null===Fh||!Fh.has(d))){a=jh(b,a);a=Eh(c,a,1073741823);pf(c,a);qf(c,1073741823);return}break;case 3:a=jh(b,a);a=Ch(c,a,1073741823);pf(c,a);qf(c,1073741823);return}c=c.return;}3===a.tag&&(c=jh(b,a), c=Ch(a,c,1073741823), pf(a,c), qf(a,1073741823));}
	function mf(a,b){var c=scheduler.unstable_getCurrentPriorityLevel(),d=void 0;if(0===(b.mode&1))d=1073741823;else if(Kh&&!Oh)d=U$1;else{switch(c){case scheduler.unstable_ImmediatePriority:d=1073741823;break;case scheduler.unstable_UserBlockingPriority:d=1073741822-10*(((1073741822-a+15)/10|0)+1);break;case scheduler.unstable_NormalPriority:d=1073741822-25*(((1073741822-a+500)/25|0)+1);break;case scheduler.unstable_LowPriority:case scheduler.unstable_IdlePriority:d=1;break;default:x$1("313");}null!==Lh&&d===U$1&&--d;}c===scheduler.unstable_UserBlockingPriority&&
	(0===gi||d<gi)&&(gi=d);return d}function ei(a,b,c){var d=a.pingCache;null!==d&&d.delete(b);if(null!==Lh&&U$1===c)Lh=null;else if(b=a.earliestSuspendedTime, d=a.latestSuspendedTime, 0!==b&&c<=b&&c>=d){a.didError=!1;b=a.latestPingedTime;if(0===b||b>c)a.latestPingedTime=c;df(c,a);c=a.expirationTime;0!==c&&Xh(a,c);}}function Ah(a,b){var c=a.stateNode;null!==c&&c.delete(b);b=lf();b=mf(b,a);a=hi(a,b);null!==a&&(cf(a,b), b=a.expirationTime, 0!==b&&Xh(a,b));}
	function hi(a,b){a.expirationTime<b&&(a.expirationTime=b);var c=a.alternate;null!==c&&c.expirationTime<b&&(c.expirationTime=b);var d=a.return,e=null;if(null===d&&3===a.tag)e=a.stateNode;else for(;null!==d;){c=d.alternate;d.childExpirationTime<b&&(d.childExpirationTime=b);null!==c&&c.childExpirationTime<b&&(c.childExpirationTime=b);if(null===d.return&&3===d.tag){e=d.stateNode;break}d=d.return;}return e}
	function qf(a,b){a=hi(a,b);null!==a&&(!Kh&&0!==U$1&&b>U$1&&Sh(), cf(a,b), Kh&&!Oh&&Lh===a||Xh(a,a.expirationTime), ii>ji&&(ii=0, x$1("185")));}function ki(a,b,c,d,e){return scheduler.unstable_runWithPriority(scheduler.unstable_ImmediatePriority,function(){return a(b,c,d,e)})}var li=null,Y$1=null,mi=0,ni=void 0,W$1=!1,oi=null,Z$1=0,gi=0,pi=!1,qi=null,X$1=!1,ri=!1,si=null,ti=scheduler.unstable_now(),ui=1073741822-(ti/10|0),vi=ui,ji=50,ii=0,wi=null;function xi(){ui=1073741822-((scheduler.unstable_now()-ti)/10|0);}
	function yi(a,b){if(0!==mi){if(b<mi)return;null!==ni&&scheduler.unstable_cancelCallback(ni);}mi=b;a=scheduler.unstable_now()-ti;ni=scheduler.unstable_scheduleCallback(zi,{timeout:10*(1073741822-b)-a});}function fi(a,b,c,d,e){a.expirationTime=d;0!==e||di()?0<e&&(a.timeoutHandle=ye(Ai.bind(null,a,b,c),e)):(a.pendingCommitExpirationTime=c, a.finishedWork=b);}function Ai(a,b,c){a.pendingCommitExpirationTime=c;a.finishedWork=b;xi();vi=ui;Bi(a,c);}function $h(a,b){a.expirationTime=b;a.finishedWork=null;}
	function lf(){if(W$1)return vi;Ci();if(0===Z$1||1===Z$1)xi(), vi=ui;return vi}function Xh(a,b){null===a.nextScheduledRoot?(a.expirationTime=b, null===Y$1?(li=Y$1=a, a.nextScheduledRoot=a):(Y$1=Y$1.nextScheduledRoot=a, Y$1.nextScheduledRoot=li)):b>a.expirationTime&&(a.expirationTime=b);W$1||(X$1?ri&&(oi=a, Z$1=1073741823, Di(a,1073741823,!1)):1073741823===b?Yh(1073741823,!1):yi(a,b));}
	function Ci(){var a=0,b=null;if(null!==Y$1)for(var c=Y$1,d=li;null!==d;){var e=d.expirationTime;if(0===e){null===c||null===Y$1?x$1("244"):void 0;if(d===d.nextScheduledRoot){li=Y$1=d.nextScheduledRoot=null;break}else if(d===li)li=e=d.nextScheduledRoot, Y$1.nextScheduledRoot=e, d.nextScheduledRoot=null;else if(d===Y$1){Y$1=c;Y$1.nextScheduledRoot=li;d.nextScheduledRoot=null;break}else c.nextScheduledRoot=d.nextScheduledRoot, d.nextScheduledRoot=null;d=c.nextScheduledRoot;}else{e>a&&(a=e, b=d);if(d===Y$1)break;if(1073741823===
	a)break;c=d;d=d.nextScheduledRoot;}}oi=b;Z$1=a;}var Ei=!1;function di(){return Ei?!0:scheduler.unstable_shouldYield()?Ei=!0:!1}function zi(){try{if(!di()&&null!==li){xi();var a=li;do{var b=a.expirationTime;0!==b&&ui<=b&&(a.nextExpirationTimeToWorkOn=ui);a=a.nextScheduledRoot;}while(a!==li)}Yh(0,!0);}finally{Ei=!1;}}
	function Yh(a,b){Ci();if(b)for(xi(), vi=ui;null!==oi&&0!==Z$1&&a<=Z$1&&!(Ei&&ui>Z$1);)Di(oi,Z$1,ui>Z$1), Ci(), xi(), vi=ui;else for(;null!==oi&&0!==Z$1&&a<=Z$1;)Di(oi,Z$1,!1), Ci();b&&(mi=0, ni=null);0!==Z$1&&yi(oi,Z$1);ii=0;wi=null;if(null!==si)for(a=si, si=null, b=0;b<a.length;b++){var c=a[b];try{c._onComplete();}catch(d){pi||(pi=!0, qi=d);}}if(pi)throw a=qi, qi=null, pi=!1, a;}function Bi(a,b){W$1?x$1("253"):void 0;oi=a;Z$1=b;Di(a,b,!1);Yh(1073741823,!1);}
	function Di(a,b,c){W$1?x$1("245"):void 0;W$1=!0;if(c){var d=a.finishedWork;null!==d?Fi(a,d,b):(a.finishedWork=null, d=a.timeoutHandle, -1!==d&&(a.timeoutHandle=-1, ze(d)), ci(a,c), d=a.finishedWork, null!==d&&(di()?a.finishedWork=d:Fi(a,d,b)));}else d=a.finishedWork, null!==d?Fi(a,d,b):(a.finishedWork=null, d=a.timeoutHandle, -1!==d&&(a.timeoutHandle=-1, ze(d)), ci(a,c), d=a.finishedWork, null!==d&&Fi(a,d,b));W$1=!1;}
	function Fi(a,b,c){var d=a.firstBatch;if(null!==d&&d._expirationTime>=c&&(null===si?si=[d]:si.push(d), d._defer)){a.finishedWork=b;a.expirationTime=0;return}a.finishedWork=null;a===wi?ii++:(wi=a, ii=0);scheduler.unstable_runWithPriority(scheduler.unstable_ImmediatePriority,function(){Zh(a,b);});}function Dh(a){null===oi?x$1("246"):void 0;oi.expirationTime=0;pi||(pi=!0, qi=a);}function Gi(a,b){var c=X$1;X$1=!0;try{return a(b)}finally{(X$1=c)||W$1||Yh(1073741823,!1);}}
	function Hi(a,b){if(X$1&&!ri){ri=!0;try{return a(b)}finally{ri=!1;}}return a(b)}function Ii(a,b,c){X$1||W$1||0===gi||(Yh(gi,!1), gi=0);var d=X$1;X$1=!0;try{return scheduler.unstable_runWithPriority(scheduler.unstable_UserBlockingPriority,function(){return a(b,c)})}finally{(X$1=d)||W$1||Yh(1073741823,!1);}}
	function Ji(a,b,c,d,e){var f=b.current;a:if(c){c=c._reactInternalFiber;b:{2===ed(c)&&1===c.tag?void 0:x$1("170");var g=c;do{switch(g.tag){case 3:g=g.stateNode.context;break b;case 1:if(J$1(g.type)){g=g.stateNode.__reactInternalMemoizedMergedChildContext;break b}}g=g.return;}while(null!==g);x$1("171");g=void 0;}if(1===c.tag){var h=c.type;if(J$1(h)){c=Ne(c,h,g);break a}}c=g;}else c=He;null===b.context?b.context=c:b.pendingContext=c;b=e;e=nf(d);e.payload={element:a};b=void 0===b?null:b;null!==b&&(e.callback=b);
	of();pf(f,e);qf(f,d);return d}function Ki(a,b,c,d){var e=b.current,f=lf();e=mf(f,e);return Ji(a,b,c,e,d)}function Li(a){a=a.current;if(!a.child)return null;switch(a.child.tag){case 5:return a.child.stateNode;default:return a.child.stateNode}}function Mi(a,b,c){var d=3<arguments.length&&void 0!==arguments[3]?arguments[3]:null;return{$$typeof:Wb,key:null==d?null:""+d,children:a,containerInfo:b,implementation:c}}
	Ab=function(a,b,c){switch(b){case "input":yc(a,c);b=c.name;if("radio"===c.type&&null!=b){for(c=a;c.parentNode;)c=c.parentNode;c=c.querySelectorAll("input[name="+JSON.stringify(""+b)+'][type="radio"]');for(b=0;b<c.length;b++){var d=c[b];if(d!==a&&d.form===a.form){var e=Ka(d);e?void 0:x$1("90");Sb(d);yc(d,e);}}}break;case "textarea":de(a,c);break;case "select":b=c.value, null!=b&&ae(a,!!c.multiple,b,!1);}};
	function Ni(a){var b=1073741822-25*(((1073741822-lf()+500)/25|0)+1);b>=Jh&&(b=Jh-1);this._expirationTime=Jh=b;this._root=a;this._callbacks=this._next=null;this._hasChildren=this._didComplete=!1;this._children=null;this._defer=!0;}Ni.prototype.render=function(a){this._defer?void 0:x$1("250");this._hasChildren=!0;this._children=a;var b=this._root._internalRoot,c=this._expirationTime,d=new Oi;Ji(a,b,null,c,d._onCommit);return d};
	Ni.prototype.then=function(a){if(this._didComplete)a();else{var b=this._callbacks;null===b&&(b=this._callbacks=[]);b.push(a);}};
	Ni.prototype.commit=function(){var a=this._root._internalRoot,b=a.firstBatch;this._defer&&null!==b?void 0:x$1("251");if(this._hasChildren){var c=this._expirationTime;if(b!==this){this._hasChildren&&(c=this._expirationTime=b._expirationTime, this.render(this._children));for(var d=null,e=b;e!==this;)d=e, e=e._next;null===d?x$1("251"):void 0;d._next=e._next;this._next=b;a.firstBatch=this;}this._defer=!1;Bi(a,c);b=this._next;this._next=null;b=a.firstBatch=b;null!==b&&b._hasChildren&&b.render(b._children);}else this._next=
	null, this._defer=!1;};Ni.prototype._onComplete=function(){if(!this._didComplete){this._didComplete=!0;var a=this._callbacks;if(null!==a)for(var b=0;b<a.length;b++)(0, a[b])();}};function Oi(){this._callbacks=null;this._didCommit=!1;this._onCommit=this._onCommit.bind(this);}Oi.prototype.then=function(a){if(this._didCommit)a();else{var b=this._callbacks;null===b&&(b=this._callbacks=[]);b.push(a);}};
	Oi.prototype._onCommit=function(){if(!this._didCommit){this._didCommit=!0;var a=this._callbacks;if(null!==a)for(var b=0;b<a.length;b++){var c=a[b];"function"!==typeof c?x$1("191",c):void 0;c();}}};
	function Pi(a,b,c){b=K$1(3,null,null,b?3:0);a={current:b,containerInfo:a,pendingChildren:null,pingCache:null,earliestPendingTime:0,latestPendingTime:0,earliestSuspendedTime:0,latestSuspendedTime:0,latestPingedTime:0,didError:!1,pendingCommitExpirationTime:0,finishedWork:null,timeoutHandle:-1,context:null,pendingContext:null,hydrate:c,nextExpirationTimeToWorkOn:0,expirationTime:0,firstBatch:null,nextScheduledRoot:null};this._internalRoot=b.stateNode=a;}
	Pi.prototype.render=function(a,b){var c=this._internalRoot,d=new Oi;b=void 0===b?null:b;null!==b&&d.then(b);Ki(a,c,null,d._onCommit);return d};Pi.prototype.unmount=function(a){var b=this._internalRoot,c=new Oi;a=void 0===a?null:a;null!==a&&c.then(a);Ki(null,b,null,c._onCommit);return c};Pi.prototype.legacy_renderSubtreeIntoContainer=function(a,b,c){var d=this._internalRoot,e=new Oi;c=void 0===c?null:c;null!==c&&e.then(c);Ki(b,d,a,e._onCommit);return e};
	Pi.prototype.createBatch=function(){var a=new Ni(this),b=a._expirationTime,c=this._internalRoot,d=c.firstBatch;if(null===d)c.firstBatch=a, a._next=null;else{for(c=null;null!==d&&d._expirationTime>=b;)c=d, d=d._next;a._next=d;null!==c&&(c._next=a);}return a};function Qi(a){return!(!a||1!==a.nodeType&&9!==a.nodeType&&11!==a.nodeType&&(8!==a.nodeType||" react-mount-point-unstable "!==a.nodeValue))}Gb=Gi;Hb=Ii;Ib=function(){W$1||0===gi||(Yh(gi,!1), gi=0);};
	function Ri(a,b){b||(b=a?9===a.nodeType?a.documentElement:a.firstChild:null, b=!(!b||1!==b.nodeType||!b.hasAttribute("data-reactroot")));if(!b)for(var c;c=a.lastChild;)a.removeChild(c);return new Pi(a,!1,b)}
	function Si(a,b,c,d,e){var f=c._reactRootContainer;if(f){if("function"===typeof e){var g=e;e=function(){var a=Li(f._internalRoot);g.call(a);};}null!=a?f.legacy_renderSubtreeIntoContainer(a,b,e):f.render(b,e);}else{f=c._reactRootContainer=Ri(c,d);if("function"===typeof e){var h=e;e=function(){var a=Li(f._internalRoot);h.call(a);};}Hi(function(){null!=a?f.legacy_renderSubtreeIntoContainer(a,b,e):f.render(b,e);});}return Li(f._internalRoot)}
	function Ti(a,b){var c=2<arguments.length&&void 0!==arguments[2]?arguments[2]:null;Qi(b)?void 0:x$1("200");return Mi(a,b,null,c)}
	var Vi={createPortal:Ti,findDOMNode:function(a){if(null==a)return null;if(1===a.nodeType)return a;var b=a._reactInternalFiber;void 0===b&&("function"===typeof a.render?x$1("188"):x$1("268",Object.keys(a)));a=hd(b);a=null===a?null:a.stateNode;return a},hydrate:function(a,b,c){Qi(b)?void 0:x$1("200");return Si(null,a,b,!0,c)},render:function(a,b,c){Qi(b)?void 0:x$1("200");return Si(null,a,b,!1,c)},unstable_renderSubtreeIntoContainer:function(a,b,c,d){Qi(c)?void 0:x$1("200");null==a||void 0===a._reactInternalFiber?
	x$1("38"):void 0;return Si(a,b,c,!1,d)},unmountComponentAtNode:function(a){Qi(a)?void 0:x$1("40");return a._reactRootContainer?(Hi(function(){Si(null,null,a,!1,function(){a._reactRootContainer=null;});}), !0):!1},unstable_createPortal:function(){return Ti.apply(void 0,arguments)},unstable_batchedUpdates:Gi,unstable_interactiveUpdates:Ii,flushSync:function(a,b){W$1?x$1("187"):void 0;var c=X$1;X$1=!0;try{return ki(a,b)}finally{X$1=c, Yh(1073741823,!1);}},unstable_createRoot:Ui,unstable_flushControlled:function(a){var b=
	X$1;X$1=!0;try{ki(a);}finally{(X$1=b)||W$1||Yh(1073741823,!1);}},__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED:{Events:[Ia,Ja,Ka,Ba.injectEventPluginsByName,pa,Qa,function(a){ya(a,Pa);},Eb,Fb,Dd,Da]}};function Ui(a,b){Qi(a)?void 0:x$1("299","unstable_createRoot");return new Pi(a,!0,null!=b&&!0===b.hydrate)}
	(function(a){var b=a.findFiberByHostInstance;return Te(objectAssign({},a,{overrideProps:null,currentDispatcherRef:Tb.ReactCurrentDispatcher,findHostInstanceByFiber:function(a){a=hd(a);return null===a?null:a.stateNode},findFiberByHostInstance:function(a){return b?b(a):null}}))})({findFiberByHostInstance:Ha,bundleType:0,version:"16.8.6",rendererPackageName:"react-dom"});var Wi={default:Vi},Xi=Wi&&Vi||Wi;var reactDom_production_min=Xi.default||Xi;

	var schedulerTracing_production_min = createCommonjsModule(function (module, exports) {
	Object.defineProperty(exports,"__esModule",{value:!0});var b=0;exports.__interactionsRef=null;exports.__subscriberRef=null;exports.unstable_clear=function(a){return a()};exports.unstable_getCurrent=function(){return null};exports.unstable_getThreadID=function(){return++b};exports.unstable_trace=function(a,d,c){return c()};exports.unstable_wrap=function(a){return a};exports.unstable_subscribe=function(){};exports.unstable_unsubscribe=function(){};
	});

	unwrapExports(schedulerTracing_production_min);
	var schedulerTracing_production_min_1 = schedulerTracing_production_min.__interactionsRef;
	var schedulerTracing_production_min_2 = schedulerTracing_production_min.__subscriberRef;
	var schedulerTracing_production_min_3 = schedulerTracing_production_min.unstable_clear;
	var schedulerTracing_production_min_4 = schedulerTracing_production_min.unstable_getCurrent;
	var schedulerTracing_production_min_5 = schedulerTracing_production_min.unstable_getThreadID;
	var schedulerTracing_production_min_6 = schedulerTracing_production_min.unstable_trace;
	var schedulerTracing_production_min_7 = schedulerTracing_production_min.unstable_wrap;
	var schedulerTracing_production_min_8 = schedulerTracing_production_min.unstable_subscribe;
	var schedulerTracing_production_min_9 = schedulerTracing_production_min.unstable_unsubscribe;

	var schedulerTracing_development = createCommonjsModule(function (module, exports) {
	});

	unwrapExports(schedulerTracing_development);
	var schedulerTracing_development_1 = schedulerTracing_development.__interactionsRef;
	var schedulerTracing_development_2 = schedulerTracing_development.__subscriberRef;
	var schedulerTracing_development_3 = schedulerTracing_development.unstable_clear;
	var schedulerTracing_development_4 = schedulerTracing_development.unstable_getCurrent;
	var schedulerTracing_development_5 = schedulerTracing_development.unstable_getThreadID;
	var schedulerTracing_development_6 = schedulerTracing_development.unstable_trace;
	var schedulerTracing_development_7 = schedulerTracing_development.unstable_wrap;
	var schedulerTracing_development_8 = schedulerTracing_development.unstable_subscribe;
	var schedulerTracing_development_9 = schedulerTracing_development.unstable_unsubscribe;

	var tracing = createCommonjsModule(function (module) {

	{
	  module.exports = schedulerTracing_production_min;
	}
	});

	var reactDom_development = createCommonjsModule(function (module) {
	});

	var reactDom = createCommonjsModule(function (module) {

	function checkDCE() {
	  /* global __REACT_DEVTOOLS_GLOBAL_HOOK__ */
	  if (
	    typeof __REACT_DEVTOOLS_GLOBAL_HOOK__ === 'undefined' ||
	    typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE !== 'function'
	  ) {
	    return;
	  }
	  try {
	    // Verify that the code above has been dead code eliminated (DCE'd).
	    __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(checkDCE);
	  } catch (err) {
	    // DevTools shouldn't crash React, no matter what.
	    // We should still report in case we break this code.
	    console.error(err);
	  }
	}

	{
	  // DCE check should happen before ReactDOM bundle executes so that
	  // DevTools can report bad minification during injection.
	  checkDCE();
	  module.exports = reactDom_production_min;
	}
	});

	var MILLISECONDS_IN_MINUTE = 60000;

	/**
	 * Google Chrome as of 67.0.3396.87 introduced timezones with offset that includes seconds.
	 * They usually appear for dates that denote time before the timezones were introduced
	 * (e.g. for 'Europe/Prague' timezone the offset is GMT+00:57:44 before 1 October 1891
	 * and GMT+01:00:00 after that date)
	 *
	 * Date#getTimezoneOffset returns the offset in minutes and would return 57 for the example above,
	 * which would lead to incorrect calculations.
	 *
	 * This function returns the timezone offset in milliseconds that takes seconds in account.
	 */
	var getTimezoneOffsetInMilliseconds = function getTimezoneOffsetInMilliseconds (dirtyDate) {
	  var date = new Date(dirtyDate.getTime());
	  var baseTimezoneOffset = date.getTimezoneOffset();
	  date.setSeconds(0, 0);
	  var millisecondsPartOfTimezoneOffset = date.getTime() % MILLISECONDS_IN_MINUTE;

	  return baseTimezoneOffset * MILLISECONDS_IN_MINUTE + millisecondsPartOfTimezoneOffset
	};

	/**
	 * @category Common Helpers
	 * @summary Is the given argument an instance of Date?
	 *
	 * @description
	 * Is the given argument an instance of Date?
	 *
	 * @param {*} argument - the argument to check
	 * @returns {Boolean} the given argument is an instance of Date
	 *
	 * @example
	 * // Is 'mayonnaise' a Date?
	 * var result = isDate('mayonnaise')
	 * //=> false
	 */
	function isDate (argument) {
	  return argument instanceof Date
	}

	var is_date = isDate;

	var MILLISECONDS_IN_HOUR = 3600000;
	var MILLISECONDS_IN_MINUTE$1 = 60000;
	var DEFAULT_ADDITIONAL_DIGITS = 2;

	var parseTokenDateTimeDelimeter = /[T ]/;
	var parseTokenPlainTime = /:/;

	// year tokens
	var parseTokenYY = /^(\d{2})$/;
	var parseTokensYYY = [
	  /^([+-]\d{2})$/, // 0 additional digits
	  /^([+-]\d{3})$/, // 1 additional digit
	  /^([+-]\d{4})$/ // 2 additional digits
	];

	var parseTokenYYYY = /^(\d{4})/;
	var parseTokensYYYYY = [
	  /^([+-]\d{4})/, // 0 additional digits
	  /^([+-]\d{5})/, // 1 additional digit
	  /^([+-]\d{6})/ // 2 additional digits
	];

	// date tokens
	var parseTokenMM = /^-(\d{2})$/;
	var parseTokenDDD = /^-?(\d{3})$/;
	var parseTokenMMDD = /^-?(\d{2})-?(\d{2})$/;
	var parseTokenWww = /^-?W(\d{2})$/;
	var parseTokenWwwD = /^-?W(\d{2})-?(\d{1})$/;

	// time tokens
	var parseTokenHH = /^(\d{2}([.,]\d*)?)$/;
	var parseTokenHHMM = /^(\d{2}):?(\d{2}([.,]\d*)?)$/;
	var parseTokenHHMMSS = /^(\d{2}):?(\d{2}):?(\d{2}([.,]\d*)?)$/;

	// timezone tokens
	var parseTokenTimezone = /([Z+-].*)$/;
	var parseTokenTimezoneZ = /^(Z)$/;
	var parseTokenTimezoneHH = /^([+-])(\d{2})$/;
	var parseTokenTimezoneHHMM = /^([+-])(\d{2}):?(\d{2})$/;

	/**
	 * @category Common Helpers
	 * @summary Convert the given argument to an instance of Date.
	 *
	 * @description
	 * Convert the given argument to an instance of Date.
	 *
	 * If the argument is an instance of Date, the function returns its clone.
	 *
	 * If the argument is a number, it is treated as a timestamp.
	 *
	 * If an argument is a string, the function tries to parse it.
	 * Function accepts complete ISO 8601 formats as well as partial implementations.
	 * ISO 8601: http://en.wikipedia.org/wiki/ISO_8601
	 *
	 * If all above fails, the function passes the given argument to Date constructor.
	 *
	 * @param {Date|String|Number} argument - the value to convert
	 * @param {Object} [options] - the object with options
	 * @param {0 | 1 | 2} [options.additionalDigits=2] - the additional number of digits in the extended year format
	 * @returns {Date} the parsed date in the local time zone
	 *
	 * @example
	 * // Convert string '2014-02-11T11:30:30' to date:
	 * var result = parse('2014-02-11T11:30:30')
	 * //=> Tue Feb 11 2014 11:30:30
	 *
	 * @example
	 * // Parse string '+02014101',
	 * // if the additional number of digits in the extended year format is 1:
	 * var result = parse('+02014101', {additionalDigits: 1})
	 * //=> Fri Apr 11 2014 00:00:00
	 */
	function parse (argument, dirtyOptions) {
	  if (is_date(argument)) {
	    // Prevent the date to lose the milliseconds when passed to new Date() in IE10
	    return new Date(argument.getTime())
	  } else if (typeof argument !== 'string') {
	    return new Date(argument)
	  }

	  var options = dirtyOptions || {};
	  var additionalDigits = options.additionalDigits;
	  if (additionalDigits == null) {
	    additionalDigits = DEFAULT_ADDITIONAL_DIGITS;
	  } else {
	    additionalDigits = Number(additionalDigits);
	  }

	  var dateStrings = splitDateString(argument);

	  var parseYearResult = parseYear(dateStrings.date, additionalDigits);
	  var year = parseYearResult.year;
	  var restDateString = parseYearResult.restDateString;

	  var date = parseDate(restDateString, year);

	  if (date) {
	    var timestamp = date.getTime();
	    var time = 0;
	    var offset;

	    if (dateStrings.time) {
	      time = parseTime(dateStrings.time);
	    }

	    if (dateStrings.timezone) {
	      offset = parseTimezone(dateStrings.timezone) * MILLISECONDS_IN_MINUTE$1;
	    } else {
	      var fullTime = timestamp + time;
	      var fullTimeDate = new Date(fullTime);

	      offset = getTimezoneOffsetInMilliseconds(fullTimeDate);

	      // Adjust time when it's coming from DST
	      var fullTimeDateNextDay = new Date(fullTime);
	      fullTimeDateNextDay.setDate(fullTimeDate.getDate() + 1);
	      var offsetDiff =
	        getTimezoneOffsetInMilliseconds(fullTimeDateNextDay) -
	        getTimezoneOffsetInMilliseconds(fullTimeDate);
	      if (offsetDiff > 0) {
	        offset += offsetDiff;
	      }
	    }

	    return new Date(timestamp + time + offset)
	  } else {
	    return new Date(argument)
	  }
	}

	function splitDateString (dateString) {
	  var dateStrings = {};
	  var array = dateString.split(parseTokenDateTimeDelimeter);
	  var timeString;

	  if (parseTokenPlainTime.test(array[0])) {
	    dateStrings.date = null;
	    timeString = array[0];
	  } else {
	    dateStrings.date = array[0];
	    timeString = array[1];
	  }

	  if (timeString) {
	    var token = parseTokenTimezone.exec(timeString);
	    if (token) {
	      dateStrings.time = timeString.replace(token[1], '');
	      dateStrings.timezone = token[1];
	    } else {
	      dateStrings.time = timeString;
	    }
	  }

	  return dateStrings
	}

	function parseYear (dateString, additionalDigits) {
	  var parseTokenYYY = parseTokensYYY[additionalDigits];
	  var parseTokenYYYYY = parseTokensYYYYY[additionalDigits];

	  var token;

	  // YYYY or ±YYYYY
	  token = parseTokenYYYY.exec(dateString) || parseTokenYYYYY.exec(dateString);
	  if (token) {
	    var yearString = token[1];
	    return {
	      year: parseInt(yearString, 10),
	      restDateString: dateString.slice(yearString.length)
	    }
	  }

	  // YY or ±YYY
	  token = parseTokenYY.exec(dateString) || parseTokenYYY.exec(dateString);
	  if (token) {
	    var centuryString = token[1];
	    return {
	      year: parseInt(centuryString, 10) * 100,
	      restDateString: dateString.slice(centuryString.length)
	    }
	  }

	  // Invalid ISO-formatted year
	  return {
	    year: null
	  }
	}

	function parseDate (dateString, year) {
	  // Invalid ISO-formatted year
	  if (year === null) {
	    return null
	  }

	  var token;
	  var date;
	  var month;
	  var week;

	  // YYYY
	  if (dateString.length === 0) {
	    date = new Date(0);
	    date.setUTCFullYear(year);
	    return date
	  }

	  // YYYY-MM
	  token = parseTokenMM.exec(dateString);
	  if (token) {
	    date = new Date(0);
	    month = parseInt(token[1], 10) - 1;
	    date.setUTCFullYear(year, month);
	    return date
	  }

	  // YYYY-DDD or YYYYDDD
	  token = parseTokenDDD.exec(dateString);
	  if (token) {
	    date = new Date(0);
	    var dayOfYear = parseInt(token[1], 10);
	    date.setUTCFullYear(year, 0, dayOfYear);
	    return date
	  }

	  // YYYY-MM-DD or YYYYMMDD
	  token = parseTokenMMDD.exec(dateString);
	  if (token) {
	    date = new Date(0);
	    month = parseInt(token[1], 10) - 1;
	    var day = parseInt(token[2], 10);
	    date.setUTCFullYear(year, month, day);
	    return date
	  }

	  // YYYY-Www or YYYYWww
	  token = parseTokenWww.exec(dateString);
	  if (token) {
	    week = parseInt(token[1], 10) - 1;
	    return dayOfISOYear(year, week)
	  }

	  // YYYY-Www-D or YYYYWwwD
	  token = parseTokenWwwD.exec(dateString);
	  if (token) {
	    week = parseInt(token[1], 10) - 1;
	    var dayOfWeek = parseInt(token[2], 10) - 1;
	    return dayOfISOYear(year, week, dayOfWeek)
	  }

	  // Invalid ISO-formatted date
	  return null
	}

	function parseTime (timeString) {
	  var token;
	  var hours;
	  var minutes;

	  // hh
	  token = parseTokenHH.exec(timeString);
	  if (token) {
	    hours = parseFloat(token[1].replace(',', '.'));
	    return (hours % 24) * MILLISECONDS_IN_HOUR
	  }

	  // hh:mm or hhmm
	  token = parseTokenHHMM.exec(timeString);
	  if (token) {
	    hours = parseInt(token[1], 10);
	    minutes = parseFloat(token[2].replace(',', '.'));
	    return (hours % 24) * MILLISECONDS_IN_HOUR +
	      minutes * MILLISECONDS_IN_MINUTE$1
	  }

	  // hh:mm:ss or hhmmss
	  token = parseTokenHHMMSS.exec(timeString);
	  if (token) {
	    hours = parseInt(token[1], 10);
	    minutes = parseInt(token[2], 10);
	    var seconds = parseFloat(token[3].replace(',', '.'));
	    return (hours % 24) * MILLISECONDS_IN_HOUR +
	      minutes * MILLISECONDS_IN_MINUTE$1 +
	      seconds * 1000
	  }

	  // Invalid ISO-formatted time
	  return null
	}

	function parseTimezone (timezoneString) {
	  var token;
	  var absoluteOffset;

	  // Z
	  token = parseTokenTimezoneZ.exec(timezoneString);
	  if (token) {
	    return 0
	  }

	  // ±hh
	  token = parseTokenTimezoneHH.exec(timezoneString);
	  if (token) {
	    absoluteOffset = parseInt(token[2], 10) * 60;
	    return (token[1] === '+') ? -absoluteOffset : absoluteOffset
	  }

	  // ±hh:mm or ±hhmm
	  token = parseTokenTimezoneHHMM.exec(timezoneString);
	  if (token) {
	    absoluteOffset = parseInt(token[2], 10) * 60 + parseInt(token[3], 10);
	    return (token[1] === '+') ? -absoluteOffset : absoluteOffset
	  }

	  return 0
	}

	function dayOfISOYear (isoYear, week, day) {
	  week = week || 0;
	  day = day || 0;
	  var date = new Date(0);
	  date.setUTCFullYear(isoYear, 0, 4);
	  var fourthOfJanuaryDay = date.getUTCDay() || 7;
	  var diff = week * 7 + day + 1 - fourthOfJanuaryDay;
	  date.setUTCDate(date.getUTCDate() + diff);
	  return date
	}

	var parse_1 = parse;

	/**
	 * @category Day Helpers
	 * @summary Add the specified number of days to the given date.
	 *
	 * @description
	 * Add the specified number of days to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of days to be added
	 * @returns {Date} the new date with the days added
	 *
	 * @example
	 * // Add 10 days to 1 September 2014:
	 * var result = addDays(new Date(2014, 8, 1), 10)
	 * //=> Thu Sep 11 2014 00:00:00
	 */
	function addDays (dirtyDate, dirtyAmount) {
	  var date = parse_1(dirtyDate);
	  var amount = Number(dirtyAmount);
	  date.setDate(date.getDate() + amount);
	  return date
	}

	var add_days = addDays;

	/**
	 * @category Millisecond Helpers
	 * @summary Add the specified number of milliseconds to the given date.
	 *
	 * @description
	 * Add the specified number of milliseconds to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of milliseconds to be added
	 * @returns {Date} the new date with the milliseconds added
	 *
	 * @example
	 * // Add 750 milliseconds to 10 July 2014 12:45:30.000:
	 * var result = addMilliseconds(new Date(2014, 6, 10, 12, 45, 30, 0), 750)
	 * //=> Thu Jul 10 2014 12:45:30.750
	 */
	function addMilliseconds (dirtyDate, dirtyAmount) {
	  var timestamp = parse_1(dirtyDate).getTime();
	  var amount = Number(dirtyAmount);
	  return new Date(timestamp + amount)
	}

	var add_milliseconds = addMilliseconds;

	var MILLISECONDS_IN_HOUR$1 = 3600000;

	/**
	 * @category Hour Helpers
	 * @summary Add the specified number of hours to the given date.
	 *
	 * @description
	 * Add the specified number of hours to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of hours to be added
	 * @returns {Date} the new date with the hours added
	 *
	 * @example
	 * // Add 2 hours to 10 July 2014 23:00:00:
	 * var result = addHours(new Date(2014, 6, 10, 23, 0), 2)
	 * //=> Fri Jul 11 2014 01:00:00
	 */
	function addHours (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_milliseconds(dirtyDate, amount * MILLISECONDS_IN_HOUR$1)
	}

	var add_hours = addHours;

	/**
	 * @category Week Helpers
	 * @summary Return the start of a week for the given date.
	 *
	 * @description
	 * Return the start of a week for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @param {Object} [options] - the object with options
	 * @param {Number} [options.weekStartsOn=0] - the index of the first day of the week (0 - Sunday)
	 * @returns {Date} the start of a week
	 *
	 * @example
	 * // The start of a week for 2 September 2014 11:55:00:
	 * var result = startOfWeek(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Sun Aug 31 2014 00:00:00
	 *
	 * @example
	 * // If the week starts on Monday, the start of the week for 2 September 2014 11:55:00:
	 * var result = startOfWeek(new Date(2014, 8, 2, 11, 55, 0), {weekStartsOn: 1})
	 * //=> Mon Sep 01 2014 00:00:00
	 */
	function startOfWeek (dirtyDate, dirtyOptions) {
	  var weekStartsOn = dirtyOptions ? (Number(dirtyOptions.weekStartsOn) || 0) : 0;

	  var date = parse_1(dirtyDate);
	  var day = date.getDay();
	  var diff = (day < weekStartsOn ? 7 : 0) + day - weekStartsOn;

	  date.setDate(date.getDate() - diff);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var start_of_week = startOfWeek;

	/**
	 * @category ISO Week Helpers
	 * @summary Return the start of an ISO week for the given date.
	 *
	 * @description
	 * Return the start of an ISO week for the given date.
	 * The result will be in the local timezone.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of an ISO week
	 *
	 * @example
	 * // The start of an ISO week for 2 September 2014 11:55:00:
	 * var result = startOfISOWeek(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Mon Sep 01 2014 00:00:00
	 */
	function startOfISOWeek (dirtyDate) {
	  return start_of_week(dirtyDate, {weekStartsOn: 1})
	}

	var start_of_iso_week = startOfISOWeek;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Get the ISO week-numbering year of the given date.
	 *
	 * @description
	 * Get the ISO week-numbering year of the given date,
	 * which always starts 3 days before the year's first Thursday.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the ISO week-numbering year
	 *
	 * @example
	 * // Which ISO-week numbering year is 2 January 2005?
	 * var result = getISOYear(new Date(2005, 0, 2))
	 * //=> 2004
	 */
	function getISOYear (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var year = date.getFullYear();

	  var fourthOfJanuaryOfNextYear = new Date(0);
	  fourthOfJanuaryOfNextYear.setFullYear(year + 1, 0, 4);
	  fourthOfJanuaryOfNextYear.setHours(0, 0, 0, 0);
	  var startOfNextYear = start_of_iso_week(fourthOfJanuaryOfNextYear);

	  var fourthOfJanuaryOfThisYear = new Date(0);
	  fourthOfJanuaryOfThisYear.setFullYear(year, 0, 4);
	  fourthOfJanuaryOfThisYear.setHours(0, 0, 0, 0);
	  var startOfThisYear = start_of_iso_week(fourthOfJanuaryOfThisYear);

	  if (date.getTime() >= startOfNextYear.getTime()) {
	    return year + 1
	  } else if (date.getTime() >= startOfThisYear.getTime()) {
	    return year
	  } else {
	    return year - 1
	  }
	}

	var get_iso_year = getISOYear;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Return the start of an ISO week-numbering year for the given date.
	 *
	 * @description
	 * Return the start of an ISO week-numbering year,
	 * which always starts 3 days before the year's first Thursday.
	 * The result will be in the local timezone.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of an ISO year
	 *
	 * @example
	 * // The start of an ISO week-numbering year for 2 July 2005:
	 * var result = startOfISOYear(new Date(2005, 6, 2))
	 * //=> Mon Jan 03 2005 00:00:00
	 */
	function startOfISOYear (dirtyDate) {
	  var year = get_iso_year(dirtyDate);
	  var fourthOfJanuary = new Date(0);
	  fourthOfJanuary.setFullYear(year, 0, 4);
	  fourthOfJanuary.setHours(0, 0, 0, 0);
	  var date = start_of_iso_week(fourthOfJanuary);
	  return date
	}

	var start_of_iso_year = startOfISOYear;

	/**
	 * @category Day Helpers
	 * @summary Return the start of a day for the given date.
	 *
	 * @description
	 * Return the start of a day for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of a day
	 *
	 * @example
	 * // The start of a day for 2 September 2014 11:55:00:
	 * var result = startOfDay(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Tue Sep 02 2014 00:00:00
	 */
	function startOfDay (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var start_of_day = startOfDay;

	var MILLISECONDS_IN_MINUTE$2 = 60000;
	var MILLISECONDS_IN_DAY = 86400000;

	/**
	 * @category Day Helpers
	 * @summary Get the number of calendar days between the given dates.
	 *
	 * @description
	 * Get the number of calendar days between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of calendar days
	 *
	 * @example
	 * // How many calendar days are between
	 * // 2 July 2011 23:00:00 and 2 July 2012 00:00:00?
	 * var result = differenceInCalendarDays(
	 *   new Date(2012, 6, 2, 0, 0),
	 *   new Date(2011, 6, 2, 23, 0)
	 * )
	 * //=> 366
	 */
	function differenceInCalendarDays (dirtyDateLeft, dirtyDateRight) {
	  var startOfDayLeft = start_of_day(dirtyDateLeft);
	  var startOfDayRight = start_of_day(dirtyDateRight);

	  var timestampLeft = startOfDayLeft.getTime() -
	    startOfDayLeft.getTimezoneOffset() * MILLISECONDS_IN_MINUTE$2;
	  var timestampRight = startOfDayRight.getTime() -
	    startOfDayRight.getTimezoneOffset() * MILLISECONDS_IN_MINUTE$2;

	  // Round the number of days to the nearest integer
	  // because the number of milliseconds in a day is not constant
	  // (e.g. it's different in the day of the daylight saving time clock shift)
	  return Math.round((timestampLeft - timestampRight) / MILLISECONDS_IN_DAY)
	}

	var difference_in_calendar_days = differenceInCalendarDays;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Set the ISO week-numbering year to the given date.
	 *
	 * @description
	 * Set the ISO week-numbering year to the given date,
	 * saving the week number and the weekday number.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} isoYear - the ISO week-numbering year of the new date
	 * @returns {Date} the new date with the ISO week-numbering year setted
	 *
	 * @example
	 * // Set ISO week-numbering year 2007 to 29 December 2008:
	 * var result = setISOYear(new Date(2008, 11, 29), 2007)
	 * //=> Mon Jan 01 2007 00:00:00
	 */
	function setISOYear (dirtyDate, dirtyISOYear) {
	  var date = parse_1(dirtyDate);
	  var isoYear = Number(dirtyISOYear);
	  var diff = difference_in_calendar_days(date, start_of_iso_year(date));
	  var fourthOfJanuary = new Date(0);
	  fourthOfJanuary.setFullYear(isoYear, 0, 4);
	  fourthOfJanuary.setHours(0, 0, 0, 0);
	  date = start_of_iso_year(fourthOfJanuary);
	  date.setDate(date.getDate() + diff);
	  return date
	}

	var set_iso_year = setISOYear;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Add the specified number of ISO week-numbering years to the given date.
	 *
	 * @description
	 * Add the specified number of ISO week-numbering years to the given date.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of ISO week-numbering years to be added
	 * @returns {Date} the new date with the ISO week-numbering years added
	 *
	 * @example
	 * // Add 5 ISO week-numbering years to 2 July 2010:
	 * var result = addISOYears(new Date(2010, 6, 2), 5)
	 * //=> Fri Jun 26 2015 00:00:00
	 */
	function addISOYears (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return set_iso_year(dirtyDate, get_iso_year(dirtyDate) + amount)
	}

	var add_iso_years = addISOYears;

	var MILLISECONDS_IN_MINUTE$3 = 60000;

	/**
	 * @category Minute Helpers
	 * @summary Add the specified number of minutes to the given date.
	 *
	 * @description
	 * Add the specified number of minutes to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of minutes to be added
	 * @returns {Date} the new date with the minutes added
	 *
	 * @example
	 * // Add 30 minutes to 10 July 2014 12:00:00:
	 * var result = addMinutes(new Date(2014, 6, 10, 12, 0), 30)
	 * //=> Thu Jul 10 2014 12:30:00
	 */
	function addMinutes (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_milliseconds(dirtyDate, amount * MILLISECONDS_IN_MINUTE$3)
	}

	var add_minutes = addMinutes;

	/**
	 * @category Month Helpers
	 * @summary Get the number of days in a month of the given date.
	 *
	 * @description
	 * Get the number of days in a month of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the number of days in a month
	 *
	 * @example
	 * // How many days are in February 2000?
	 * var result = getDaysInMonth(new Date(2000, 1))
	 * //=> 29
	 */
	function getDaysInMonth (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var year = date.getFullYear();
	  var monthIndex = date.getMonth();
	  var lastDayOfMonth = new Date(0);
	  lastDayOfMonth.setFullYear(year, monthIndex + 1, 0);
	  lastDayOfMonth.setHours(0, 0, 0, 0);
	  return lastDayOfMonth.getDate()
	}

	var get_days_in_month = getDaysInMonth;

	/**
	 * @category Month Helpers
	 * @summary Add the specified number of months to the given date.
	 *
	 * @description
	 * Add the specified number of months to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of months to be added
	 * @returns {Date} the new date with the months added
	 *
	 * @example
	 * // Add 5 months to 1 September 2014:
	 * var result = addMonths(new Date(2014, 8, 1), 5)
	 * //=> Sun Feb 01 2015 00:00:00
	 */
	function addMonths (dirtyDate, dirtyAmount) {
	  var date = parse_1(dirtyDate);
	  var amount = Number(dirtyAmount);
	  var desiredMonth = date.getMonth() + amount;
	  var dateWithDesiredMonth = new Date(0);
	  dateWithDesiredMonth.setFullYear(date.getFullYear(), desiredMonth, 1);
	  dateWithDesiredMonth.setHours(0, 0, 0, 0);
	  var daysInMonth = get_days_in_month(dateWithDesiredMonth);
	  // Set the last day of the new month
	  // if the original date was the last day of the longer month
	  date.setMonth(desiredMonth, Math.min(daysInMonth, date.getDate()));
	  return date
	}

	var add_months = addMonths;

	/**
	 * @category Quarter Helpers
	 * @summary Add the specified number of year quarters to the given date.
	 *
	 * @description
	 * Add the specified number of year quarters to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of quarters to be added
	 * @returns {Date} the new date with the quarters added
	 *
	 * @example
	 * // Add 1 quarter to 1 September 2014:
	 * var result = addQuarters(new Date(2014, 8, 1), 1)
	 * //=> Mon Dec 01 2014 00:00:00
	 */
	function addQuarters (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  var months = amount * 3;
	  return add_months(dirtyDate, months)
	}

	var add_quarters = addQuarters;

	/**
	 * @category Second Helpers
	 * @summary Add the specified number of seconds to the given date.
	 *
	 * @description
	 * Add the specified number of seconds to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of seconds to be added
	 * @returns {Date} the new date with the seconds added
	 *
	 * @example
	 * // Add 30 seconds to 10 July 2014 12:45:00:
	 * var result = addSeconds(new Date(2014, 6, 10, 12, 45, 0), 30)
	 * //=> Thu Jul 10 2014 12:45:30
	 */
	function addSeconds (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_milliseconds(dirtyDate, amount * 1000)
	}

	var add_seconds = addSeconds;

	/**
	 * @category Week Helpers
	 * @summary Add the specified number of weeks to the given date.
	 *
	 * @description
	 * Add the specified number of week to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of weeks to be added
	 * @returns {Date} the new date with the weeks added
	 *
	 * @example
	 * // Add 4 weeks to 1 September 2014:
	 * var result = addWeeks(new Date(2014, 8, 1), 4)
	 * //=> Mon Sep 29 2014 00:00:00
	 */
	function addWeeks (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  var days = amount * 7;
	  return add_days(dirtyDate, days)
	}

	var add_weeks = addWeeks;

	/**
	 * @category Year Helpers
	 * @summary Add the specified number of years to the given date.
	 *
	 * @description
	 * Add the specified number of years to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of years to be added
	 * @returns {Date} the new date with the years added
	 *
	 * @example
	 * // Add 5 years to 1 September 2014:
	 * var result = addYears(new Date(2014, 8, 1), 5)
	 * //=> Sun Sep 01 2019 00:00:00
	 */
	function addYears (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_months(dirtyDate, amount * 12)
	}

	var add_years = addYears;

	/**
	 * @category Range Helpers
	 * @summary Is the given date range overlapping with another date range?
	 *
	 * @description
	 * Is the given date range overlapping with another date range?
	 *
	 * @param {Date|String|Number} initialRangeStartDate - the start of the initial range
	 * @param {Date|String|Number} initialRangeEndDate - the end of the initial range
	 * @param {Date|String|Number} comparedRangeStartDate - the start of the range to compare it with
	 * @param {Date|String|Number} comparedRangeEndDate - the end of the range to compare it with
	 * @returns {Boolean} whether the date ranges are overlapping
	 * @throws {Error} startDate of a date range cannot be after its endDate
	 *
	 * @example
	 * // For overlapping date ranges:
	 * areRangesOverlapping(
	 *   new Date(2014, 0, 10), new Date(2014, 0, 20), new Date(2014, 0, 17), new Date(2014, 0, 21)
	 * )
	 * //=> true
	 *
	 * @example
	 * // For non-overlapping date ranges:
	 * areRangesOverlapping(
	 *   new Date(2014, 0, 10), new Date(2014, 0, 20), new Date(2014, 0, 21), new Date(2014, 0, 22)
	 * )
	 * //=> false
	 */
	function areRangesOverlapping (dirtyInitialRangeStartDate, dirtyInitialRangeEndDate, dirtyComparedRangeStartDate, dirtyComparedRangeEndDate) {
	  var initialStartTime = parse_1(dirtyInitialRangeStartDate).getTime();
	  var initialEndTime = parse_1(dirtyInitialRangeEndDate).getTime();
	  var comparedStartTime = parse_1(dirtyComparedRangeStartDate).getTime();
	  var comparedEndTime = parse_1(dirtyComparedRangeEndDate).getTime();

	  if (initialStartTime > initialEndTime || comparedStartTime > comparedEndTime) {
	    throw new Error('The start of the range cannot be after the end of the range')
	  }

	  return initialStartTime < comparedEndTime && comparedStartTime < initialEndTime
	}

	var are_ranges_overlapping = areRangesOverlapping;

	/**
	 * @category Common Helpers
	 * @summary Return an index of the closest date from the array comparing to the given date.
	 *
	 * @description
	 * Return an index of the closest date from the array comparing to the given date.
	 *
	 * @param {Date|String|Number} dateToCompare - the date to compare with
	 * @param {Date[]|String[]|Number[]} datesArray - the array to search
	 * @returns {Number} an index of the date closest to the given date
	 * @throws {TypeError} the second argument must be an instance of Array
	 *
	 * @example
	 * // Which date is closer to 6 September 2015?
	 * var dateToCompare = new Date(2015, 8, 6)
	 * var datesArray = [
	 *   new Date(2015, 0, 1),
	 *   new Date(2016, 0, 1),
	 *   new Date(2017, 0, 1)
	 * ]
	 * var result = closestIndexTo(dateToCompare, datesArray)
	 * //=> 1
	 */
	function closestIndexTo (dirtyDateToCompare, dirtyDatesArray) {
	  if (!(dirtyDatesArray instanceof Array)) {
	    throw new TypeError(toString.call(dirtyDatesArray) + ' is not an instance of Array')
	  }

	  var dateToCompare = parse_1(dirtyDateToCompare);
	  var timeToCompare = dateToCompare.getTime();

	  var result;
	  var minDistance;

	  dirtyDatesArray.forEach(function (dirtyDate, index) {
	    var currentDate = parse_1(dirtyDate);
	    var distance = Math.abs(timeToCompare - currentDate.getTime());
	    if (result === undefined || distance < minDistance) {
	      result = index;
	      minDistance = distance;
	    }
	  });

	  return result
	}

	var closest_index_to = closestIndexTo;

	/**
	 * @category Common Helpers
	 * @summary Return a date from the array closest to the given date.
	 *
	 * @description
	 * Return a date from the array closest to the given date.
	 *
	 * @param {Date|String|Number} dateToCompare - the date to compare with
	 * @param {Date[]|String[]|Number[]} datesArray - the array to search
	 * @returns {Date} the date from the array closest to the given date
	 * @throws {TypeError} the second argument must be an instance of Array
	 *
	 * @example
	 * // Which date is closer to 6 September 2015: 1 January 2000 or 1 January 2030?
	 * var dateToCompare = new Date(2015, 8, 6)
	 * var result = closestTo(dateToCompare, [
	 *   new Date(2000, 0, 1),
	 *   new Date(2030, 0, 1)
	 * ])
	 * //=> Tue Jan 01 2030 00:00:00
	 */
	function closestTo (dirtyDateToCompare, dirtyDatesArray) {
	  if (!(dirtyDatesArray instanceof Array)) {
	    throw new TypeError(toString.call(dirtyDatesArray) + ' is not an instance of Array')
	  }

	  var dateToCompare = parse_1(dirtyDateToCompare);
	  var timeToCompare = dateToCompare.getTime();

	  var result;
	  var minDistance;

	  dirtyDatesArray.forEach(function (dirtyDate) {
	    var currentDate = parse_1(dirtyDate);
	    var distance = Math.abs(timeToCompare - currentDate.getTime());
	    if (result === undefined || distance < minDistance) {
	      result = currentDate;
	      minDistance = distance;
	    }
	  });

	  return result
	}

	var closest_to = closestTo;

	/**
	 * @category Common Helpers
	 * @summary Compare the two dates and return -1, 0 or 1.
	 *
	 * @description
	 * Compare the two dates and return 1 if the first date is after the second,
	 * -1 if the first date is before the second or 0 if dates are equal.
	 *
	 * @param {Date|String|Number} dateLeft - the first date to compare
	 * @param {Date|String|Number} dateRight - the second date to compare
	 * @returns {Number} the result of the comparison
	 *
	 * @example
	 * // Compare 11 February 1987 and 10 July 1989:
	 * var result = compareAsc(
	 *   new Date(1987, 1, 11),
	 *   new Date(1989, 6, 10)
	 * )
	 * //=> -1
	 *
	 * @example
	 * // Sort the array of dates:
	 * var result = [
	 *   new Date(1995, 6, 2),
	 *   new Date(1987, 1, 11),
	 *   new Date(1989, 6, 10)
	 * ].sort(compareAsc)
	 * //=> [
	 * //   Wed Feb 11 1987 00:00:00,
	 * //   Mon Jul 10 1989 00:00:00,
	 * //   Sun Jul 02 1995 00:00:00
	 * // ]
	 */
	function compareAsc (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var timeLeft = dateLeft.getTime();
	  var dateRight = parse_1(dirtyDateRight);
	  var timeRight = dateRight.getTime();

	  if (timeLeft < timeRight) {
	    return -1
	  } else if (timeLeft > timeRight) {
	    return 1
	  } else {
	    return 0
	  }
	}

	var compare_asc = compareAsc;

	/**
	 * @category Common Helpers
	 * @summary Compare the two dates reverse chronologically and return -1, 0 or 1.
	 *
	 * @description
	 * Compare the two dates and return -1 if the first date is after the second,
	 * 1 if the first date is before the second or 0 if dates are equal.
	 *
	 * @param {Date|String|Number} dateLeft - the first date to compare
	 * @param {Date|String|Number} dateRight - the second date to compare
	 * @returns {Number} the result of the comparison
	 *
	 * @example
	 * // Compare 11 February 1987 and 10 July 1989 reverse chronologically:
	 * var result = compareDesc(
	 *   new Date(1987, 1, 11),
	 *   new Date(1989, 6, 10)
	 * )
	 * //=> 1
	 *
	 * @example
	 * // Sort the array of dates in reverse chronological order:
	 * var result = [
	 *   new Date(1995, 6, 2),
	 *   new Date(1987, 1, 11),
	 *   new Date(1989, 6, 10)
	 * ].sort(compareDesc)
	 * //=> [
	 * //   Sun Jul 02 1995 00:00:00,
	 * //   Mon Jul 10 1989 00:00:00,
	 * //   Wed Feb 11 1987 00:00:00
	 * // ]
	 */
	function compareDesc (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var timeLeft = dateLeft.getTime();
	  var dateRight = parse_1(dirtyDateRight);
	  var timeRight = dateRight.getTime();

	  if (timeLeft > timeRight) {
	    return -1
	  } else if (timeLeft < timeRight) {
	    return 1
	  } else {
	    return 0
	  }
	}

	var compare_desc = compareDesc;

	var MILLISECONDS_IN_MINUTE$4 = 60000;
	var MILLISECONDS_IN_WEEK = 604800000;

	/**
	 * @category ISO Week Helpers
	 * @summary Get the number of calendar ISO weeks between the given dates.
	 *
	 * @description
	 * Get the number of calendar ISO weeks between the given dates.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of calendar ISO weeks
	 *
	 * @example
	 * // How many calendar ISO weeks are between 6 July 2014 and 21 July 2014?
	 * var result = differenceInCalendarISOWeeks(
	 *   new Date(2014, 6, 21),
	 *   new Date(2014, 6, 6)
	 * )
	 * //=> 3
	 */
	function differenceInCalendarISOWeeks (dirtyDateLeft, dirtyDateRight) {
	  var startOfISOWeekLeft = start_of_iso_week(dirtyDateLeft);
	  var startOfISOWeekRight = start_of_iso_week(dirtyDateRight);

	  var timestampLeft = startOfISOWeekLeft.getTime() -
	    startOfISOWeekLeft.getTimezoneOffset() * MILLISECONDS_IN_MINUTE$4;
	  var timestampRight = startOfISOWeekRight.getTime() -
	    startOfISOWeekRight.getTimezoneOffset() * MILLISECONDS_IN_MINUTE$4;

	  // Round the number of days to the nearest integer
	  // because the number of milliseconds in a week is not constant
	  // (e.g. it's different in the week of the daylight saving time clock shift)
	  return Math.round((timestampLeft - timestampRight) / MILLISECONDS_IN_WEEK)
	}

	var difference_in_calendar_iso_weeks = differenceInCalendarISOWeeks;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Get the number of calendar ISO week-numbering years between the given dates.
	 *
	 * @description
	 * Get the number of calendar ISO week-numbering years between the given dates.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of calendar ISO week-numbering years
	 *
	 * @example
	 * // How many calendar ISO week-numbering years are 1 January 2010 and 1 January 2012?
	 * var result = differenceInCalendarISOYears(
	 *   new Date(2012, 0, 1),
	 *   new Date(2010, 0, 1)
	 * )
	 * //=> 2
	 */
	function differenceInCalendarISOYears (dirtyDateLeft, dirtyDateRight) {
	  return get_iso_year(dirtyDateLeft) - get_iso_year(dirtyDateRight)
	}

	var difference_in_calendar_iso_years = differenceInCalendarISOYears;

	/**
	 * @category Month Helpers
	 * @summary Get the number of calendar months between the given dates.
	 *
	 * @description
	 * Get the number of calendar months between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of calendar months
	 *
	 * @example
	 * // How many calendar months are between 31 January 2014 and 1 September 2014?
	 * var result = differenceInCalendarMonths(
	 *   new Date(2014, 8, 1),
	 *   new Date(2014, 0, 31)
	 * )
	 * //=> 8
	 */
	function differenceInCalendarMonths (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);

	  var yearDiff = dateLeft.getFullYear() - dateRight.getFullYear();
	  var monthDiff = dateLeft.getMonth() - dateRight.getMonth();

	  return yearDiff * 12 + monthDiff
	}

	var difference_in_calendar_months = differenceInCalendarMonths;

	/**
	 * @category Quarter Helpers
	 * @summary Get the year quarter of the given date.
	 *
	 * @description
	 * Get the year quarter of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the quarter
	 *
	 * @example
	 * // Which quarter is 2 July 2014?
	 * var result = getQuarter(new Date(2014, 6, 2))
	 * //=> 3
	 */
	function getQuarter (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var quarter = Math.floor(date.getMonth() / 3) + 1;
	  return quarter
	}

	var get_quarter = getQuarter;

	/**
	 * @category Quarter Helpers
	 * @summary Get the number of calendar quarters between the given dates.
	 *
	 * @description
	 * Get the number of calendar quarters between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of calendar quarters
	 *
	 * @example
	 * // How many calendar quarters are between 31 December 2013 and 2 July 2014?
	 * var result = differenceInCalendarQuarters(
	 *   new Date(2014, 6, 2),
	 *   new Date(2013, 11, 31)
	 * )
	 * //=> 3
	 */
	function differenceInCalendarQuarters (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);

	  var yearDiff = dateLeft.getFullYear() - dateRight.getFullYear();
	  var quarterDiff = get_quarter(dateLeft) - get_quarter(dateRight);

	  return yearDiff * 4 + quarterDiff
	}

	var difference_in_calendar_quarters = differenceInCalendarQuarters;

	var MILLISECONDS_IN_MINUTE$5 = 60000;
	var MILLISECONDS_IN_WEEK$1 = 604800000;

	/**
	 * @category Week Helpers
	 * @summary Get the number of calendar weeks between the given dates.
	 *
	 * @description
	 * Get the number of calendar weeks between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @param {Object} [options] - the object with options
	 * @param {Number} [options.weekStartsOn=0] - the index of the first day of the week (0 - Sunday)
	 * @returns {Number} the number of calendar weeks
	 *
	 * @example
	 * // How many calendar weeks are between 5 July 2014 and 20 July 2014?
	 * var result = differenceInCalendarWeeks(
	 *   new Date(2014, 6, 20),
	 *   new Date(2014, 6, 5)
	 * )
	 * //=> 3
	 *
	 * @example
	 * // If the week starts on Monday,
	 * // how many calendar weeks are between 5 July 2014 and 20 July 2014?
	 * var result = differenceInCalendarWeeks(
	 *   new Date(2014, 6, 20),
	 *   new Date(2014, 6, 5),
	 *   {weekStartsOn: 1}
	 * )
	 * //=> 2
	 */
	function differenceInCalendarWeeks (dirtyDateLeft, dirtyDateRight, dirtyOptions) {
	  var startOfWeekLeft = start_of_week(dirtyDateLeft, dirtyOptions);
	  var startOfWeekRight = start_of_week(dirtyDateRight, dirtyOptions);

	  var timestampLeft = startOfWeekLeft.getTime() -
	    startOfWeekLeft.getTimezoneOffset() * MILLISECONDS_IN_MINUTE$5;
	  var timestampRight = startOfWeekRight.getTime() -
	    startOfWeekRight.getTimezoneOffset() * MILLISECONDS_IN_MINUTE$5;

	  // Round the number of days to the nearest integer
	  // because the number of milliseconds in a week is not constant
	  // (e.g. it's different in the week of the daylight saving time clock shift)
	  return Math.round((timestampLeft - timestampRight) / MILLISECONDS_IN_WEEK$1)
	}

	var difference_in_calendar_weeks = differenceInCalendarWeeks;

	/**
	 * @category Year Helpers
	 * @summary Get the number of calendar years between the given dates.
	 *
	 * @description
	 * Get the number of calendar years between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of calendar years
	 *
	 * @example
	 * // How many calendar years are between 31 December 2013 and 11 February 2015?
	 * var result = differenceInCalendarYears(
	 *   new Date(2015, 1, 11),
	 *   new Date(2013, 11, 31)
	 * )
	 * //=> 2
	 */
	function differenceInCalendarYears (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);

	  return dateLeft.getFullYear() - dateRight.getFullYear()
	}

	var difference_in_calendar_years = differenceInCalendarYears;

	/**
	 * @category Day Helpers
	 * @summary Get the number of full days between the given dates.
	 *
	 * @description
	 * Get the number of full days between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of full days
	 *
	 * @example
	 * // How many full days are between
	 * // 2 July 2011 23:00:00 and 2 July 2012 00:00:00?
	 * var result = differenceInDays(
	 *   new Date(2012, 6, 2, 0, 0),
	 *   new Date(2011, 6, 2, 23, 0)
	 * )
	 * //=> 365
	 */
	function differenceInDays (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);

	  var sign = compare_asc(dateLeft, dateRight);
	  var difference = Math.abs(difference_in_calendar_days(dateLeft, dateRight));
	  dateLeft.setDate(dateLeft.getDate() - sign * difference);

	  // Math.abs(diff in full days - diff in calendar days) === 1 if last calendar day is not full
	  // If so, result must be decreased by 1 in absolute value
	  var isLastDayNotFull = compare_asc(dateLeft, dateRight) === -sign;
	  return sign * (difference - isLastDayNotFull)
	}

	var difference_in_days = differenceInDays;

	/**
	 * @category Millisecond Helpers
	 * @summary Get the number of milliseconds between the given dates.
	 *
	 * @description
	 * Get the number of milliseconds between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of milliseconds
	 *
	 * @example
	 * // How many milliseconds are between
	 * // 2 July 2014 12:30:20.600 and 2 July 2014 12:30:21.700?
	 * var result = differenceInMilliseconds(
	 *   new Date(2014, 6, 2, 12, 30, 21, 700),
	 *   new Date(2014, 6, 2, 12, 30, 20, 600)
	 * )
	 * //=> 1100
	 */
	function differenceInMilliseconds (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);
	  return dateLeft.getTime() - dateRight.getTime()
	}

	var difference_in_milliseconds = differenceInMilliseconds;

	var MILLISECONDS_IN_HOUR$2 = 3600000;

	/**
	 * @category Hour Helpers
	 * @summary Get the number of hours between the given dates.
	 *
	 * @description
	 * Get the number of hours between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of hours
	 *
	 * @example
	 * // How many hours are between 2 July 2014 06:50:00 and 2 July 2014 19:00:00?
	 * var result = differenceInHours(
	 *   new Date(2014, 6, 2, 19, 0),
	 *   new Date(2014, 6, 2, 6, 50)
	 * )
	 * //=> 12
	 */
	function differenceInHours (dirtyDateLeft, dirtyDateRight) {
	  var diff = difference_in_milliseconds(dirtyDateLeft, dirtyDateRight) / MILLISECONDS_IN_HOUR$2;
	  return diff > 0 ? Math.floor(diff) : Math.ceil(diff)
	}

	var difference_in_hours = differenceInHours;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Subtract the specified number of ISO week-numbering years from the given date.
	 *
	 * @description
	 * Subtract the specified number of ISO week-numbering years from the given date.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of ISO week-numbering years to be subtracted
	 * @returns {Date} the new date with the ISO week-numbering years subtracted
	 *
	 * @example
	 * // Subtract 5 ISO week-numbering years from 1 September 2014:
	 * var result = subISOYears(new Date(2014, 8, 1), 5)
	 * //=> Mon Aug 31 2009 00:00:00
	 */
	function subISOYears (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_iso_years(dirtyDate, -amount)
	}

	var sub_iso_years = subISOYears;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Get the number of full ISO week-numbering years between the given dates.
	 *
	 * @description
	 * Get the number of full ISO week-numbering years between the given dates.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of full ISO week-numbering years
	 *
	 * @example
	 * // How many full ISO week-numbering years are between 1 January 2010 and 1 January 2012?
	 * var result = differenceInISOYears(
	 *   new Date(2012, 0, 1),
	 *   new Date(2010, 0, 1)
	 * )
	 * //=> 1
	 */
	function differenceInISOYears (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);

	  var sign = compare_asc(dateLeft, dateRight);
	  var difference = Math.abs(difference_in_calendar_iso_years(dateLeft, dateRight));
	  dateLeft = sub_iso_years(dateLeft, sign * difference);

	  // Math.abs(diff in full ISO years - diff in calendar ISO years) === 1
	  // if last calendar ISO year is not full
	  // If so, result must be decreased by 1 in absolute value
	  var isLastISOYearNotFull = compare_asc(dateLeft, dateRight) === -sign;
	  return sign * (difference - isLastISOYearNotFull)
	}

	var difference_in_iso_years = differenceInISOYears;

	var MILLISECONDS_IN_MINUTE$6 = 60000;

	/**
	 * @category Minute Helpers
	 * @summary Get the number of minutes between the given dates.
	 *
	 * @description
	 * Get the number of minutes between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of minutes
	 *
	 * @example
	 * // How many minutes are between 2 July 2014 12:07:59 and 2 July 2014 12:20:00?
	 * var result = differenceInMinutes(
	 *   new Date(2014, 6, 2, 12, 20, 0),
	 *   new Date(2014, 6, 2, 12, 7, 59)
	 * )
	 * //=> 12
	 */
	function differenceInMinutes (dirtyDateLeft, dirtyDateRight) {
	  var diff = difference_in_milliseconds(dirtyDateLeft, dirtyDateRight) / MILLISECONDS_IN_MINUTE$6;
	  return diff > 0 ? Math.floor(diff) : Math.ceil(diff)
	}

	var difference_in_minutes = differenceInMinutes;

	/**
	 * @category Month Helpers
	 * @summary Get the number of full months between the given dates.
	 *
	 * @description
	 * Get the number of full months between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of full months
	 *
	 * @example
	 * // How many full months are between 31 January 2014 and 1 September 2014?
	 * var result = differenceInMonths(
	 *   new Date(2014, 8, 1),
	 *   new Date(2014, 0, 31)
	 * )
	 * //=> 7
	 */
	function differenceInMonths (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);

	  var sign = compare_asc(dateLeft, dateRight);
	  var difference = Math.abs(difference_in_calendar_months(dateLeft, dateRight));
	  dateLeft.setMonth(dateLeft.getMonth() - sign * difference);

	  // Math.abs(diff in full months - diff in calendar months) === 1 if last calendar month is not full
	  // If so, result must be decreased by 1 in absolute value
	  var isLastMonthNotFull = compare_asc(dateLeft, dateRight) === -sign;
	  return sign * (difference - isLastMonthNotFull)
	}

	var difference_in_months = differenceInMonths;

	/**
	 * @category Quarter Helpers
	 * @summary Get the number of full quarters between the given dates.
	 *
	 * @description
	 * Get the number of full quarters between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of full quarters
	 *
	 * @example
	 * // How many full quarters are between 31 December 2013 and 2 July 2014?
	 * var result = differenceInQuarters(
	 *   new Date(2014, 6, 2),
	 *   new Date(2013, 11, 31)
	 * )
	 * //=> 2
	 */
	function differenceInQuarters (dirtyDateLeft, dirtyDateRight) {
	  var diff = difference_in_months(dirtyDateLeft, dirtyDateRight) / 3;
	  return diff > 0 ? Math.floor(diff) : Math.ceil(diff)
	}

	var difference_in_quarters = differenceInQuarters;

	/**
	 * @category Second Helpers
	 * @summary Get the number of seconds between the given dates.
	 *
	 * @description
	 * Get the number of seconds between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of seconds
	 *
	 * @example
	 * // How many seconds are between
	 * // 2 July 2014 12:30:07.999 and 2 July 2014 12:30:20.000?
	 * var result = differenceInSeconds(
	 *   new Date(2014, 6, 2, 12, 30, 20, 0),
	 *   new Date(2014, 6, 2, 12, 30, 7, 999)
	 * )
	 * //=> 12
	 */
	function differenceInSeconds (dirtyDateLeft, dirtyDateRight) {
	  var diff = difference_in_milliseconds(dirtyDateLeft, dirtyDateRight) / 1000;
	  return diff > 0 ? Math.floor(diff) : Math.ceil(diff)
	}

	var difference_in_seconds = differenceInSeconds;

	/**
	 * @category Week Helpers
	 * @summary Get the number of full weeks between the given dates.
	 *
	 * @description
	 * Get the number of full weeks between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of full weeks
	 *
	 * @example
	 * // How many full weeks are between 5 July 2014 and 20 July 2014?
	 * var result = differenceInWeeks(
	 *   new Date(2014, 6, 20),
	 *   new Date(2014, 6, 5)
	 * )
	 * //=> 2
	 */
	function differenceInWeeks (dirtyDateLeft, dirtyDateRight) {
	  var diff = difference_in_days(dirtyDateLeft, dirtyDateRight) / 7;
	  return diff > 0 ? Math.floor(diff) : Math.ceil(diff)
	}

	var difference_in_weeks = differenceInWeeks;

	/**
	 * @category Year Helpers
	 * @summary Get the number of full years between the given dates.
	 *
	 * @description
	 * Get the number of full years between the given dates.
	 *
	 * @param {Date|String|Number} dateLeft - the later date
	 * @param {Date|String|Number} dateRight - the earlier date
	 * @returns {Number} the number of full years
	 *
	 * @example
	 * // How many full years are between 31 December 2013 and 11 February 2015?
	 * var result = differenceInYears(
	 *   new Date(2015, 1, 11),
	 *   new Date(2013, 11, 31)
	 * )
	 * //=> 1
	 */
	function differenceInYears (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);

	  var sign = compare_asc(dateLeft, dateRight);
	  var difference = Math.abs(difference_in_calendar_years(dateLeft, dateRight));
	  dateLeft.setFullYear(dateLeft.getFullYear() - sign * difference);

	  // Math.abs(diff in full years - diff in calendar years) === 1 if last calendar year is not full
	  // If so, result must be decreased by 1 in absolute value
	  var isLastYearNotFull = compare_asc(dateLeft, dateRight) === -sign;
	  return sign * (difference - isLastYearNotFull)
	}

	var difference_in_years = differenceInYears;

	function buildDistanceInWordsLocale () {
	  var distanceInWordsLocale = {
	    lessThanXSeconds: {
	      one: 'less than a second',
	      other: 'less than {{count}} seconds'
	    },

	    xSeconds: {
	      one: '1 second',
	      other: '{{count}} seconds'
	    },

	    halfAMinute: 'half a minute',

	    lessThanXMinutes: {
	      one: 'less than a minute',
	      other: 'less than {{count}} minutes'
	    },

	    xMinutes: {
	      one: '1 minute',
	      other: '{{count}} minutes'
	    },

	    aboutXHours: {
	      one: 'about 1 hour',
	      other: 'about {{count}} hours'
	    },

	    xHours: {
	      one: '1 hour',
	      other: '{{count}} hours'
	    },

	    xDays: {
	      one: '1 day',
	      other: '{{count}} days'
	    },

	    aboutXMonths: {
	      one: 'about 1 month',
	      other: 'about {{count}} months'
	    },

	    xMonths: {
	      one: '1 month',
	      other: '{{count}} months'
	    },

	    aboutXYears: {
	      one: 'about 1 year',
	      other: 'about {{count}} years'
	    },

	    xYears: {
	      one: '1 year',
	      other: '{{count}} years'
	    },

	    overXYears: {
	      one: 'over 1 year',
	      other: 'over {{count}} years'
	    },

	    almostXYears: {
	      one: 'almost 1 year',
	      other: 'almost {{count}} years'
	    }
	  };

	  function localize (token, count, options) {
	    options = options || {};

	    var result;
	    if (typeof distanceInWordsLocale[token] === 'string') {
	      result = distanceInWordsLocale[token];
	    } else if (count === 1) {
	      result = distanceInWordsLocale[token].one;
	    } else {
	      result = distanceInWordsLocale[token].other.replace('{{count}}', count);
	    }

	    if (options.addSuffix) {
	      if (options.comparison > 0) {
	        return 'in ' + result
	      } else {
	        return result + ' ago'
	      }
	    }

	    return result
	  }

	  return {
	    localize: localize
	  }
	}

	var build_distance_in_words_locale = buildDistanceInWordsLocale;

	var commonFormatterKeys = [
	  'M', 'MM', 'Q', 'D', 'DD', 'DDD', 'DDDD', 'd',
	  'E', 'W', 'WW', 'YY', 'YYYY', 'GG', 'GGGG',
	  'H', 'HH', 'h', 'hh', 'm', 'mm',
	  's', 'ss', 'S', 'SS', 'SSS',
	  'Z', 'ZZ', 'X', 'x'
	];

	function buildFormattingTokensRegExp (formatters) {
	  var formatterKeys = [];
	  for (var key in formatters) {
	    if (formatters.hasOwnProperty(key)) {
	      formatterKeys.push(key);
	    }
	  }

	  var formattingTokens = commonFormatterKeys
	    .concat(formatterKeys)
	    .sort()
	    .reverse();
	  var formattingTokensRegExp = new RegExp(
	    '(\\[[^\\[]*\\])|(\\\\)?' + '(' + formattingTokens.join('|') + '|.)', 'g'
	  );

	  return formattingTokensRegExp
	}

	var build_formatting_tokens_reg_exp = buildFormattingTokensRegExp;

	function buildFormatLocale () {
	  // Note: in English, the names of days of the week and months are capitalized.
	  // If you are making a new locale based on this one, check if the same is true for the language you're working on.
	  // Generally, formatted dates should look like they are in the middle of a sentence,
	  // e.g. in Spanish language the weekdays and months should be in the lowercase.
	  var months3char = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
	  var monthsFull = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
	  var weekdays2char = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
	  var weekdays3char = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
	  var weekdaysFull = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
	  var meridiemUppercase = ['AM', 'PM'];
	  var meridiemLowercase = ['am', 'pm'];
	  var meridiemFull = ['a.m.', 'p.m.'];

	  var formatters = {
	    // Month: Jan, Feb, ..., Dec
	    'MMM': function (date) {
	      return months3char[date.getMonth()]
	    },

	    // Month: January, February, ..., December
	    'MMMM': function (date) {
	      return monthsFull[date.getMonth()]
	    },

	    // Day of week: Su, Mo, ..., Sa
	    'dd': function (date) {
	      return weekdays2char[date.getDay()]
	    },

	    // Day of week: Sun, Mon, ..., Sat
	    'ddd': function (date) {
	      return weekdays3char[date.getDay()]
	    },

	    // Day of week: Sunday, Monday, ..., Saturday
	    'dddd': function (date) {
	      return weekdaysFull[date.getDay()]
	    },

	    // AM, PM
	    'A': function (date) {
	      return (date.getHours() / 12) >= 1 ? meridiemUppercase[1] : meridiemUppercase[0]
	    },

	    // am, pm
	    'a': function (date) {
	      return (date.getHours() / 12) >= 1 ? meridiemLowercase[1] : meridiemLowercase[0]
	    },

	    // a.m., p.m.
	    'aa': function (date) {
	      return (date.getHours() / 12) >= 1 ? meridiemFull[1] : meridiemFull[0]
	    }
	  };

	  // Generate ordinal version of formatters: M -> Mo, D -> Do, etc.
	  var ordinalFormatters = ['M', 'D', 'DDD', 'd', 'Q', 'W'];
	  ordinalFormatters.forEach(function (formatterToken) {
	    formatters[formatterToken + 'o'] = function (date, formatters) {
	      return ordinal(formatters[formatterToken](date))
	    };
	  });

	  return {
	    formatters: formatters,
	    formattingTokensRegExp: build_formatting_tokens_reg_exp(formatters)
	  }
	}

	function ordinal (number) {
	  var rem100 = number % 100;
	  if (rem100 > 20 || rem100 < 10) {
	    switch (rem100 % 10) {
	      case 1:
	        return number + 'st'
	      case 2:
	        return number + 'nd'
	      case 3:
	        return number + 'rd'
	    }
	  }
	  return number + 'th'
	}

	var build_format_locale = buildFormatLocale;

	/**
	 * @category Locales
	 * @summary English locale.
	 */
	var en = {
	  distanceInWords: build_distance_in_words_locale(),
	  format: build_format_locale()
	};

	var MINUTES_IN_DAY = 1440;
	var MINUTES_IN_ALMOST_TWO_DAYS = 2520;
	var MINUTES_IN_MONTH = 43200;
	var MINUTES_IN_TWO_MONTHS = 86400;

	/**
	 * @category Common Helpers
	 * @summary Return the distance between the given dates in words.
	 *
	 * @description
	 * Return the distance between the given dates in words.
	 *
	 * | Distance between dates                                            | Result              |
	 * |-------------------------------------------------------------------|---------------------|
	 * | 0 ... 30 secs                                                     | less than a minute  |
	 * | 30 secs ... 1 min 30 secs                                         | 1 minute            |
	 * | 1 min 30 secs ... 44 mins 30 secs                                 | [2..44] minutes     |
	 * | 44 mins ... 30 secs ... 89 mins 30 secs                           | about 1 hour        |
	 * | 89 mins 30 secs ... 23 hrs 59 mins 30 secs                        | about [2..24] hours |
	 * | 23 hrs 59 mins 30 secs ... 41 hrs 59 mins 30 secs                 | 1 day               |
	 * | 41 hrs 59 mins 30 secs ... 29 days 23 hrs 59 mins 30 secs         | [2..30] days        |
	 * | 29 days 23 hrs 59 mins 30 secs ... 44 days 23 hrs 59 mins 30 secs | about 1 month       |
	 * | 44 days 23 hrs 59 mins 30 secs ... 59 days 23 hrs 59 mins 30 secs | about 2 months      |
	 * | 59 days 23 hrs 59 mins 30 secs ... 1 yr                           | [2..12] months      |
	 * | 1 yr ... 1 yr 3 months                                            | about 1 year        |
	 * | 1 yr 3 months ... 1 yr 9 month s                                  | over 1 year         |
	 * | 1 yr 9 months ... 2 yrs                                           | almost 2 years      |
	 * | N yrs ... N yrs 3 months                                          | about N years       |
	 * | N yrs 3 months ... N yrs 9 months                                 | over N years        |
	 * | N yrs 9 months ... N+1 yrs                                        | almost N+1 years    |
	 *
	 * With `options.includeSeconds == true`:
	 * | Distance between dates | Result               |
	 * |------------------------|----------------------|
	 * | 0 secs ... 5 secs      | less than 5 seconds  |
	 * | 5 secs ... 10 secs     | less than 10 seconds |
	 * | 10 secs ... 20 secs    | less than 20 seconds |
	 * | 20 secs ... 40 secs    | half a minute        |
	 * | 40 secs ... 60 secs    | less than a minute   |
	 * | 60 secs ... 90 secs    | 1 minute             |
	 *
	 * @param {Date|String|Number} dateToCompare - the date to compare with
	 * @param {Date|String|Number} date - the other date
	 * @param {Object} [options] - the object with options
	 * @param {Boolean} [options.includeSeconds=false] - distances less than a minute are more detailed
	 * @param {Boolean} [options.addSuffix=false] - result indicates if the second date is earlier or later than the first
	 * @param {Object} [options.locale=enLocale] - the locale object
	 * @returns {String} the distance in words
	 *
	 * @example
	 * // What is the distance between 2 July 2014 and 1 January 2015?
	 * var result = distanceInWords(
	 *   new Date(2014, 6, 2),
	 *   new Date(2015, 0, 1)
	 * )
	 * //=> '6 months'
	 *
	 * @example
	 * // What is the distance between 1 January 2015 00:00:15
	 * // and 1 January 2015 00:00:00, including seconds?
	 * var result = distanceInWords(
	 *   new Date(2015, 0, 1, 0, 0, 15),
	 *   new Date(2015, 0, 1, 0, 0, 0),
	 *   {includeSeconds: true}
	 * )
	 * //=> 'less than 20 seconds'
	 *
	 * @example
	 * // What is the distance from 1 January 2016
	 * // to 1 January 2015, with a suffix?
	 * var result = distanceInWords(
	 *   new Date(2016, 0, 1),
	 *   new Date(2015, 0, 1),
	 *   {addSuffix: true}
	 * )
	 * //=> 'about 1 year ago'
	 *
	 * @example
	 * // What is the distance between 1 August 2016 and 1 January 2015 in Esperanto?
	 * var eoLocale = require('date-fns/locale/eo')
	 * var result = distanceInWords(
	 *   new Date(2016, 7, 1),
	 *   new Date(2015, 0, 1),
	 *   {locale: eoLocale}
	 * )
	 * //=> 'pli ol 1 jaro'
	 */
	function distanceInWords (dirtyDateToCompare, dirtyDate, dirtyOptions) {
	  var options = dirtyOptions || {};

	  var comparison = compare_desc(dirtyDateToCompare, dirtyDate);

	  var locale = options.locale;
	  var localize = en.distanceInWords.localize;
	  if (locale && locale.distanceInWords && locale.distanceInWords.localize) {
	    localize = locale.distanceInWords.localize;
	  }

	  var localizeOptions = {
	    addSuffix: Boolean(options.addSuffix),
	    comparison: comparison
	  };

	  var dateLeft, dateRight;
	  if (comparison > 0) {
	    dateLeft = parse_1(dirtyDateToCompare);
	    dateRight = parse_1(dirtyDate);
	  } else {
	    dateLeft = parse_1(dirtyDate);
	    dateRight = parse_1(dirtyDateToCompare);
	  }

	  var seconds = difference_in_seconds(dateRight, dateLeft);
	  var offset = dateRight.getTimezoneOffset() - dateLeft.getTimezoneOffset();
	  var minutes = Math.round(seconds / 60) - offset;
	  var months;

	  // 0 up to 2 mins
	  if (minutes < 2) {
	    if (options.includeSeconds) {
	      if (seconds < 5) {
	        return localize('lessThanXSeconds', 5, localizeOptions)
	      } else if (seconds < 10) {
	        return localize('lessThanXSeconds', 10, localizeOptions)
	      } else if (seconds < 20) {
	        return localize('lessThanXSeconds', 20, localizeOptions)
	      } else if (seconds < 40) {
	        return localize('halfAMinute', null, localizeOptions)
	      } else if (seconds < 60) {
	        return localize('lessThanXMinutes', 1, localizeOptions)
	      } else {
	        return localize('xMinutes', 1, localizeOptions)
	      }
	    } else {
	      if (minutes === 0) {
	        return localize('lessThanXMinutes', 1, localizeOptions)
	      } else {
	        return localize('xMinutes', minutes, localizeOptions)
	      }
	    }

	  // 2 mins up to 0.75 hrs
	  } else if (minutes < 45) {
	    return localize('xMinutes', minutes, localizeOptions)

	  // 0.75 hrs up to 1.5 hrs
	  } else if (minutes < 90) {
	    return localize('aboutXHours', 1, localizeOptions)

	  // 1.5 hrs up to 24 hrs
	  } else if (minutes < MINUTES_IN_DAY) {
	    var hours = Math.round(minutes / 60);
	    return localize('aboutXHours', hours, localizeOptions)

	  // 1 day up to 1.75 days
	  } else if (minutes < MINUTES_IN_ALMOST_TWO_DAYS) {
	    return localize('xDays', 1, localizeOptions)

	  // 1.75 days up to 30 days
	  } else if (minutes < MINUTES_IN_MONTH) {
	    var days = Math.round(minutes / MINUTES_IN_DAY);
	    return localize('xDays', days, localizeOptions)

	  // 1 month up to 2 months
	  } else if (minutes < MINUTES_IN_TWO_MONTHS) {
	    months = Math.round(minutes / MINUTES_IN_MONTH);
	    return localize('aboutXMonths', months, localizeOptions)
	  }

	  months = difference_in_months(dateRight, dateLeft);

	  // 2 months up to 12 months
	  if (months < 12) {
	    var nearestMonth = Math.round(minutes / MINUTES_IN_MONTH);
	    return localize('xMonths', nearestMonth, localizeOptions)

	  // 1 year up to max Date
	  } else {
	    var monthsSinceStartOfYear = months % 12;
	    var years = Math.floor(months / 12);

	    // N years up to 1 years 3 months
	    if (monthsSinceStartOfYear < 3) {
	      return localize('aboutXYears', years, localizeOptions)

	    // N years 3 months up to N years 9 months
	    } else if (monthsSinceStartOfYear < 9) {
	      return localize('overXYears', years, localizeOptions)

	    // N years 9 months up to N year 12 months
	    } else {
	      return localize('almostXYears', years + 1, localizeOptions)
	    }
	  }
	}

	var distance_in_words = distanceInWords;

	var MINUTES_IN_DAY$1 = 1440;
	var MINUTES_IN_MONTH$1 = 43200;
	var MINUTES_IN_YEAR = 525600;

	/**
	 * @category Common Helpers
	 * @summary Return the distance between the given dates in words.
	 *
	 * @description
	 * Return the distance between the given dates in words, using strict units.
	 * This is like `distanceInWords`, but does not use helpers like 'almost', 'over',
	 * 'less than' and the like.
	 *
	 * | Distance between dates | Result              |
	 * |------------------------|---------------------|
	 * | 0 ... 59 secs          | [0..59] seconds     |
	 * | 1 ... 59 mins          | [1..59] minutes     |
	 * | 1 ... 23 hrs           | [1..23] hours       |
	 * | 1 ... 29 days          | [1..29] days        |
	 * | 1 ... 11 months        | [1..11] months      |
	 * | 1 ... N years          | [1..N]  years       |
	 *
	 * @param {Date|String|Number} dateToCompare - the date to compare with
	 * @param {Date|String|Number} date - the other date
	 * @param {Object} [options] - the object with options
	 * @param {Boolean} [options.addSuffix=false] - result indicates if the second date is earlier or later than the first
	 * @param {'s'|'m'|'h'|'d'|'M'|'Y'} [options.unit] - if specified, will force a unit
	 * @param {'floor'|'ceil'|'round'} [options.partialMethod='floor'] - which way to round partial units
	 * @param {Object} [options.locale=enLocale] - the locale object
	 * @returns {String} the distance in words
	 *
	 * @example
	 * // What is the distance between 2 July 2014 and 1 January 2015?
	 * var result = distanceInWordsStrict(
	 *   new Date(2014, 6, 2),
	 *   new Date(2015, 0, 2)
	 * )
	 * //=> '6 months'
	 *
	 * @example
	 * // What is the distance between 1 January 2015 00:00:15
	 * // and 1 January 2015 00:00:00?
	 * var result = distanceInWordsStrict(
	 *   new Date(2015, 0, 1, 0, 0, 15),
	 *   new Date(2015, 0, 1, 0, 0, 0),
	 * )
	 * //=> '15 seconds'
	 *
	 * @example
	 * // What is the distance from 1 January 2016
	 * // to 1 January 2015, with a suffix?
	 * var result = distanceInWordsStrict(
	 *   new Date(2016, 0, 1),
	 *   new Date(2015, 0, 1),
	 *   {addSuffix: true}
	 * )
	 * //=> '1 year ago'
	 *
	 * @example
	 * // What is the distance from 1 January 2016
	 * // to 1 January 2015, in minutes?
	 * var result = distanceInWordsStrict(
	 *   new Date(2016, 0, 1),
	 *   new Date(2015, 0, 1),
	 *   {unit: 'm'}
	 * )
	 * //=> '525600 minutes'
	 *
	 * @example
	 * // What is the distance from 1 January 2016
	 * // to 28 January 2015, in months, rounded up?
	 * var result = distanceInWordsStrict(
	 *   new Date(2015, 0, 28),
	 *   new Date(2015, 0, 1),
	 *   {unit: 'M', partialMethod: 'ceil'}
	 * )
	 * //=> '1 month'
	 *
	 * @example
	 * // What is the distance between 1 August 2016 and 1 January 2015 in Esperanto?
	 * var eoLocale = require('date-fns/locale/eo')
	 * var result = distanceInWordsStrict(
	 *   new Date(2016, 7, 1),
	 *   new Date(2015, 0, 1),
	 *   {locale: eoLocale}
	 * )
	 * //=> '1 jaro'
	 */
	function distanceInWordsStrict (dirtyDateToCompare, dirtyDate, dirtyOptions) {
	  var options = dirtyOptions || {};

	  var comparison = compare_desc(dirtyDateToCompare, dirtyDate);

	  var locale = options.locale;
	  var localize = en.distanceInWords.localize;
	  if (locale && locale.distanceInWords && locale.distanceInWords.localize) {
	    localize = locale.distanceInWords.localize;
	  }

	  var localizeOptions = {
	    addSuffix: Boolean(options.addSuffix),
	    comparison: comparison
	  };

	  var dateLeft, dateRight;
	  if (comparison > 0) {
	    dateLeft = parse_1(dirtyDateToCompare);
	    dateRight = parse_1(dirtyDate);
	  } else {
	    dateLeft = parse_1(dirtyDate);
	    dateRight = parse_1(dirtyDateToCompare);
	  }

	  var unit;
	  var mathPartial = Math[options.partialMethod ? String(options.partialMethod) : 'floor'];
	  var seconds = difference_in_seconds(dateRight, dateLeft);
	  var offset = dateRight.getTimezoneOffset() - dateLeft.getTimezoneOffset();
	  var minutes = mathPartial(seconds / 60) - offset;
	  var hours, days, months, years;

	  if (options.unit) {
	    unit = String(options.unit);
	  } else {
	    if (minutes < 1) {
	      unit = 's';
	    } else if (minutes < 60) {
	      unit = 'm';
	    } else if (minutes < MINUTES_IN_DAY$1) {
	      unit = 'h';
	    } else if (minutes < MINUTES_IN_MONTH$1) {
	      unit = 'd';
	    } else if (minutes < MINUTES_IN_YEAR) {
	      unit = 'M';
	    } else {
	      unit = 'Y';
	    }
	  }

	  // 0 up to 60 seconds
	  if (unit === 's') {
	    return localize('xSeconds', seconds, localizeOptions)

	  // 1 up to 60 mins
	  } else if (unit === 'm') {
	    return localize('xMinutes', minutes, localizeOptions)

	  // 1 up to 24 hours
	  } else if (unit === 'h') {
	    hours = mathPartial(minutes / 60);
	    return localize('xHours', hours, localizeOptions)

	  // 1 up to 30 days
	  } else if (unit === 'd') {
	    days = mathPartial(minutes / MINUTES_IN_DAY$1);
	    return localize('xDays', days, localizeOptions)

	  // 1 up to 12 months
	  } else if (unit === 'M') {
	    months = mathPartial(minutes / MINUTES_IN_MONTH$1);
	    return localize('xMonths', months, localizeOptions)

	  // 1 year up to max Date
	  } else if (unit === 'Y') {
	    years = mathPartial(minutes / MINUTES_IN_YEAR);
	    return localize('xYears', years, localizeOptions)
	  }

	  throw new Error('Unknown unit: ' + unit)
	}

	var distance_in_words_strict = distanceInWordsStrict;

	/**
	 * @category Common Helpers
	 * @summary Return the distance between the given date and now in words.
	 *
	 * @description
	 * Return the distance between the given date and now in words.
	 *
	 * | Distance to now                                                   | Result              |
	 * |-------------------------------------------------------------------|---------------------|
	 * | 0 ... 30 secs                                                     | less than a minute  |
	 * | 30 secs ... 1 min 30 secs                                         | 1 minute            |
	 * | 1 min 30 secs ... 44 mins 30 secs                                 | [2..44] minutes     |
	 * | 44 mins ... 30 secs ... 89 mins 30 secs                           | about 1 hour        |
	 * | 89 mins 30 secs ... 23 hrs 59 mins 30 secs                        | about [2..24] hours |
	 * | 23 hrs 59 mins 30 secs ... 41 hrs 59 mins 30 secs                 | 1 day               |
	 * | 41 hrs 59 mins 30 secs ... 29 days 23 hrs 59 mins 30 secs         | [2..30] days        |
	 * | 29 days 23 hrs 59 mins 30 secs ... 44 days 23 hrs 59 mins 30 secs | about 1 month       |
	 * | 44 days 23 hrs 59 mins 30 secs ... 59 days 23 hrs 59 mins 30 secs | about 2 months      |
	 * | 59 days 23 hrs 59 mins 30 secs ... 1 yr                           | [2..12] months      |
	 * | 1 yr ... 1 yr 3 months                                            | about 1 year        |
	 * | 1 yr 3 months ... 1 yr 9 month s                                  | over 1 year         |
	 * | 1 yr 9 months ... 2 yrs                                           | almost 2 years      |
	 * | N yrs ... N yrs 3 months                                          | about N years       |
	 * | N yrs 3 months ... N yrs 9 months                                 | over N years        |
	 * | N yrs 9 months ... N+1 yrs                                        | almost N+1 years    |
	 *
	 * With `options.includeSeconds == true`:
	 * | Distance to now     | Result               |
	 * |---------------------|----------------------|
	 * | 0 secs ... 5 secs   | less than 5 seconds  |
	 * | 5 secs ... 10 secs  | less than 10 seconds |
	 * | 10 secs ... 20 secs | less than 20 seconds |
	 * | 20 secs ... 40 secs | half a minute        |
	 * | 40 secs ... 60 secs | less than a minute   |
	 * | 60 secs ... 90 secs | 1 minute             |
	 *
	 * @param {Date|String|Number} date - the given date
	 * @param {Object} [options] - the object with options
	 * @param {Boolean} [options.includeSeconds=false] - distances less than a minute are more detailed
	 * @param {Boolean} [options.addSuffix=false] - result specifies if the second date is earlier or later than the first
	 * @param {Object} [options.locale=enLocale] - the locale object
	 * @returns {String} the distance in words
	 *
	 * @example
	 * // If today is 1 January 2015, what is the distance to 2 July 2014?
	 * var result = distanceInWordsToNow(
	 *   new Date(2014, 6, 2)
	 * )
	 * //=> '6 months'
	 *
	 * @example
	 * // If now is 1 January 2015 00:00:00,
	 * // what is the distance to 1 January 2015 00:00:15, including seconds?
	 * var result = distanceInWordsToNow(
	 *   new Date(2015, 0, 1, 0, 0, 15),
	 *   {includeSeconds: true}
	 * )
	 * //=> 'less than 20 seconds'
	 *
	 * @example
	 * // If today is 1 January 2015,
	 * // what is the distance to 1 January 2016, with a suffix?
	 * var result = distanceInWordsToNow(
	 *   new Date(2016, 0, 1),
	 *   {addSuffix: true}
	 * )
	 * //=> 'in about 1 year'
	 *
	 * @example
	 * // If today is 1 January 2015,
	 * // what is the distance to 1 August 2016 in Esperanto?
	 * var eoLocale = require('date-fns/locale/eo')
	 * var result = distanceInWordsToNow(
	 *   new Date(2016, 7, 1),
	 *   {locale: eoLocale}
	 * )
	 * //=> 'pli ol 1 jaro'
	 */
	function distanceInWordsToNow (dirtyDate, dirtyOptions) {
	  return distance_in_words(Date.now(), dirtyDate, dirtyOptions)
	}

	var distance_in_words_to_now = distanceInWordsToNow;

	/**
	 * @category Day Helpers
	 * @summary Return the array of dates within the specified range.
	 *
	 * @description
	 * Return the array of dates within the specified range.
	 *
	 * @param {Date|String|Number} startDate - the first date
	 * @param {Date|String|Number} endDate - the last date
	 * @param {Number} [step=1] - the step between each day
	 * @returns {Date[]} the array with starts of days from the day of startDate to the day of endDate
	 * @throws {Error} startDate cannot be after endDate
	 *
	 * @example
	 * // Each day between 6 October 2014 and 10 October 2014:
	 * var result = eachDay(
	 *   new Date(2014, 9, 6),
	 *   new Date(2014, 9, 10)
	 * )
	 * //=> [
	 * //   Mon Oct 06 2014 00:00:00,
	 * //   Tue Oct 07 2014 00:00:00,
	 * //   Wed Oct 08 2014 00:00:00,
	 * //   Thu Oct 09 2014 00:00:00,
	 * //   Fri Oct 10 2014 00:00:00
	 * // ]
	 */
	function eachDay (dirtyStartDate, dirtyEndDate, dirtyStep) {
	  var startDate = parse_1(dirtyStartDate);
	  var endDate = parse_1(dirtyEndDate);
	  var step = dirtyStep !== undefined ? dirtyStep : 1;

	  var endTime = endDate.getTime();

	  if (startDate.getTime() > endTime) {
	    throw new Error('The first date cannot be after the second date')
	  }

	  var dates = [];

	  var currentDate = startDate;
	  currentDate.setHours(0, 0, 0, 0);

	  while (currentDate.getTime() <= endTime) {
	    dates.push(parse_1(currentDate));
	    currentDate.setDate(currentDate.getDate() + step);
	  }

	  return dates
	}

	var each_day = eachDay;

	/**
	 * @category Day Helpers
	 * @summary Return the end of a day for the given date.
	 *
	 * @description
	 * Return the end of a day for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of a day
	 *
	 * @example
	 * // The end of a day for 2 September 2014 11:55:00:
	 * var result = endOfDay(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Tue Sep 02 2014 23:59:59.999
	 */
	function endOfDay (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setHours(23, 59, 59, 999);
	  return date
	}

	var end_of_day = endOfDay;

	/**
	 * @category Hour Helpers
	 * @summary Return the end of an hour for the given date.
	 *
	 * @description
	 * Return the end of an hour for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of an hour
	 *
	 * @example
	 * // The end of an hour for 2 September 2014 11:55:00:
	 * var result = endOfHour(new Date(2014, 8, 2, 11, 55))
	 * //=> Tue Sep 02 2014 11:59:59.999
	 */
	function endOfHour (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setMinutes(59, 59, 999);
	  return date
	}

	var end_of_hour = endOfHour;

	/**
	 * @category Week Helpers
	 * @summary Return the end of a week for the given date.
	 *
	 * @description
	 * Return the end of a week for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @param {Object} [options] - the object with options
	 * @param {Number} [options.weekStartsOn=0] - the index of the first day of the week (0 - Sunday)
	 * @returns {Date} the end of a week
	 *
	 * @example
	 * // The end of a week for 2 September 2014 11:55:00:
	 * var result = endOfWeek(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Sat Sep 06 2014 23:59:59.999
	 *
	 * @example
	 * // If the week starts on Monday, the end of the week for 2 September 2014 11:55:00:
	 * var result = endOfWeek(new Date(2014, 8, 2, 11, 55, 0), {weekStartsOn: 1})
	 * //=> Sun Sep 07 2014 23:59:59.999
	 */
	function endOfWeek (dirtyDate, dirtyOptions) {
	  var weekStartsOn = dirtyOptions ? (Number(dirtyOptions.weekStartsOn) || 0) : 0;

	  var date = parse_1(dirtyDate);
	  var day = date.getDay();
	  var diff = (day < weekStartsOn ? -7 : 0) + 6 - (day - weekStartsOn);

	  date.setDate(date.getDate() + diff);
	  date.setHours(23, 59, 59, 999);
	  return date
	}

	var end_of_week = endOfWeek;

	/**
	 * @category ISO Week Helpers
	 * @summary Return the end of an ISO week for the given date.
	 *
	 * @description
	 * Return the end of an ISO week for the given date.
	 * The result will be in the local timezone.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of an ISO week
	 *
	 * @example
	 * // The end of an ISO week for 2 September 2014 11:55:00:
	 * var result = endOfISOWeek(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Sun Sep 07 2014 23:59:59.999
	 */
	function endOfISOWeek (dirtyDate) {
	  return end_of_week(dirtyDate, {weekStartsOn: 1})
	}

	var end_of_iso_week = endOfISOWeek;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Return the end of an ISO week-numbering year for the given date.
	 *
	 * @description
	 * Return the end of an ISO week-numbering year,
	 * which always starts 3 days before the year's first Thursday.
	 * The result will be in the local timezone.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of an ISO week-numbering year
	 *
	 * @example
	 * // The end of an ISO week-numbering year for 2 July 2005:
	 * var result = endOfISOYear(new Date(2005, 6, 2))
	 * //=> Sun Jan 01 2006 23:59:59.999
	 */
	function endOfISOYear (dirtyDate) {
	  var year = get_iso_year(dirtyDate);
	  var fourthOfJanuaryOfNextYear = new Date(0);
	  fourthOfJanuaryOfNextYear.setFullYear(year + 1, 0, 4);
	  fourthOfJanuaryOfNextYear.setHours(0, 0, 0, 0);
	  var date = start_of_iso_week(fourthOfJanuaryOfNextYear);
	  date.setMilliseconds(date.getMilliseconds() - 1);
	  return date
	}

	var end_of_iso_year = endOfISOYear;

	/**
	 * @category Minute Helpers
	 * @summary Return the end of a minute for the given date.
	 *
	 * @description
	 * Return the end of a minute for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of a minute
	 *
	 * @example
	 * // The end of a minute for 1 December 2014 22:15:45.400:
	 * var result = endOfMinute(new Date(2014, 11, 1, 22, 15, 45, 400))
	 * //=> Mon Dec 01 2014 22:15:59.999
	 */
	function endOfMinute (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setSeconds(59, 999);
	  return date
	}

	var end_of_minute = endOfMinute;

	/**
	 * @category Month Helpers
	 * @summary Return the end of a month for the given date.
	 *
	 * @description
	 * Return the end of a month for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of a month
	 *
	 * @example
	 * // The end of a month for 2 September 2014 11:55:00:
	 * var result = endOfMonth(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Tue Sep 30 2014 23:59:59.999
	 */
	function endOfMonth (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var month = date.getMonth();
	  date.setFullYear(date.getFullYear(), month + 1, 0);
	  date.setHours(23, 59, 59, 999);
	  return date
	}

	var end_of_month = endOfMonth;

	/**
	 * @category Quarter Helpers
	 * @summary Return the end of a year quarter for the given date.
	 *
	 * @description
	 * Return the end of a year quarter for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of a quarter
	 *
	 * @example
	 * // The end of a quarter for 2 September 2014 11:55:00:
	 * var result = endOfQuarter(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Tue Sep 30 2014 23:59:59.999
	 */
	function endOfQuarter (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var currentMonth = date.getMonth();
	  var month = currentMonth - currentMonth % 3 + 3;
	  date.setMonth(month, 0);
	  date.setHours(23, 59, 59, 999);
	  return date
	}

	var end_of_quarter = endOfQuarter;

	/**
	 * @category Second Helpers
	 * @summary Return the end of a second for the given date.
	 *
	 * @description
	 * Return the end of a second for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of a second
	 *
	 * @example
	 * // The end of a second for 1 December 2014 22:15:45.400:
	 * var result = endOfSecond(new Date(2014, 11, 1, 22, 15, 45, 400))
	 * //=> Mon Dec 01 2014 22:15:45.999
	 */
	function endOfSecond (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setMilliseconds(999);
	  return date
	}

	var end_of_second = endOfSecond;

	/**
	 * @category Day Helpers
	 * @summary Return the end of today.
	 *
	 * @description
	 * Return the end of today.
	 *
	 * @returns {Date} the end of today
	 *
	 * @example
	 * // If today is 6 October 2014:
	 * var result = endOfToday()
	 * //=> Mon Oct 6 2014 23:59:59.999
	 */
	function endOfToday () {
	  return end_of_day(new Date())
	}

	var end_of_today = endOfToday;

	/**
	 * @category Day Helpers
	 * @summary Return the end of tomorrow.
	 *
	 * @description
	 * Return the end of tomorrow.
	 *
	 * @returns {Date} the end of tomorrow
	 *
	 * @example
	 * // If today is 6 October 2014:
	 * var result = endOfTomorrow()
	 * //=> Tue Oct 7 2014 23:59:59.999
	 */
	function endOfTomorrow () {
	  var now = new Date();
	  var year = now.getFullYear();
	  var month = now.getMonth();
	  var day = now.getDate();

	  var date = new Date(0);
	  date.setFullYear(year, month, day + 1);
	  date.setHours(23, 59, 59, 999);
	  return date
	}

	var end_of_tomorrow = endOfTomorrow;

	/**
	 * @category Year Helpers
	 * @summary Return the end of a year for the given date.
	 *
	 * @description
	 * Return the end of a year for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of a year
	 *
	 * @example
	 * // The end of a year for 2 September 2014 11:55:00:
	 * var result = endOfYear(new Date(2014, 8, 2, 11, 55, 00))
	 * //=> Wed Dec 31 2014 23:59:59.999
	 */
	function endOfYear (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var year = date.getFullYear();
	  date.setFullYear(year + 1, 0, 0);
	  date.setHours(23, 59, 59, 999);
	  return date
	}

	var end_of_year = endOfYear;

	/**
	 * @category Day Helpers
	 * @summary Return the end of yesterday.
	 *
	 * @description
	 * Return the end of yesterday.
	 *
	 * @returns {Date} the end of yesterday
	 *
	 * @example
	 * // If today is 6 October 2014:
	 * var result = endOfYesterday()
	 * //=> Sun Oct 5 2014 23:59:59.999
	 */
	function endOfYesterday () {
	  var now = new Date();
	  var year = now.getFullYear();
	  var month = now.getMonth();
	  var day = now.getDate();

	  var date = new Date(0);
	  date.setFullYear(year, month, day - 1);
	  date.setHours(23, 59, 59, 999);
	  return date
	}

	var end_of_yesterday = endOfYesterday;

	/**
	 * @category Year Helpers
	 * @summary Return the start of a year for the given date.
	 *
	 * @description
	 * Return the start of a year for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of a year
	 *
	 * @example
	 * // The start of a year for 2 September 2014 11:55:00:
	 * var result = startOfYear(new Date(2014, 8, 2, 11, 55, 00))
	 * //=> Wed Jan 01 2014 00:00:00
	 */
	function startOfYear (dirtyDate) {
	  var cleanDate = parse_1(dirtyDate);
	  var date = new Date(0);
	  date.setFullYear(cleanDate.getFullYear(), 0, 1);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var start_of_year = startOfYear;

	/**
	 * @category Day Helpers
	 * @summary Get the day of the year of the given date.
	 *
	 * @description
	 * Get the day of the year of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the day of year
	 *
	 * @example
	 * // Which day of the year is 2 July 2014?
	 * var result = getDayOfYear(new Date(2014, 6, 2))
	 * //=> 183
	 */
	function getDayOfYear (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var diff = difference_in_calendar_days(date, start_of_year(date));
	  var dayOfYear = diff + 1;
	  return dayOfYear
	}

	var get_day_of_year = getDayOfYear;

	var MILLISECONDS_IN_WEEK$2 = 604800000;

	/**
	 * @category ISO Week Helpers
	 * @summary Get the ISO week of the given date.
	 *
	 * @description
	 * Get the ISO week of the given date.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the ISO week
	 *
	 * @example
	 * // Which week of the ISO-week numbering year is 2 January 2005?
	 * var result = getISOWeek(new Date(2005, 0, 2))
	 * //=> 53
	 */
	function getISOWeek (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var diff = start_of_iso_week(date).getTime() - start_of_iso_year(date).getTime();

	  // Round the number of days to the nearest integer
	  // because the number of milliseconds in a week is not constant
	  // (e.g. it's different in the week of the daylight saving time clock shift)
	  return Math.round(diff / MILLISECONDS_IN_WEEK$2) + 1
	}

	var get_iso_week = getISOWeek;

	/**
	 * @category Common Helpers
	 * @summary Is the given date valid?
	 *
	 * @description
	 * Returns false if argument is Invalid Date and true otherwise.
	 * Invalid Date is a Date, whose time value is NaN.
	 *
	 * Time value of Date: http://es5.github.io/#x15.9.1.1
	 *
	 * @param {Date} date - the date to check
	 * @returns {Boolean} the date is valid
	 * @throws {TypeError} argument must be an instance of Date
	 *
	 * @example
	 * // For the valid date:
	 * var result = isValid(new Date(2014, 1, 31))
	 * //=> true
	 *
	 * @example
	 * // For the invalid date:
	 * var result = isValid(new Date(''))
	 * //=> false
	 */
	function isValid (dirtyDate) {
	  if (is_date(dirtyDate)) {
	    return !isNaN(dirtyDate)
	  } else {
	    throw new TypeError(toString.call(dirtyDate) + ' is not an instance of Date')
	  }
	}

	var is_valid = isValid;

	/**
	 * @category Common Helpers
	 * @summary Format the date.
	 *
	 * @description
	 * Return the formatted date string in the given format.
	 *
	 * Accepted tokens:
	 * | Unit                    | Token | Result examples                  |
	 * |-------------------------|-------|----------------------------------|
	 * | Month                   | M     | 1, 2, ..., 12                    |
	 * |                         | Mo    | 1st, 2nd, ..., 12th              |
	 * |                         | MM    | 01, 02, ..., 12                  |
	 * |                         | MMM   | Jan, Feb, ..., Dec               |
	 * |                         | MMMM  | January, February, ..., December |
	 * | Quarter                 | Q     | 1, 2, 3, 4                       |
	 * |                         | Qo    | 1st, 2nd, 3rd, 4th               |
	 * | Day of month            | D     | 1, 2, ..., 31                    |
	 * |                         | Do    | 1st, 2nd, ..., 31st              |
	 * |                         | DD    | 01, 02, ..., 31                  |
	 * | Day of year             | DDD   | 1, 2, ..., 366                   |
	 * |                         | DDDo  | 1st, 2nd, ..., 366th             |
	 * |                         | DDDD  | 001, 002, ..., 366               |
	 * | Day of week             | d     | 0, 1, ..., 6                     |
	 * |                         | do    | 0th, 1st, ..., 6th               |
	 * |                         | dd    | Su, Mo, ..., Sa                  |
	 * |                         | ddd   | Sun, Mon, ..., Sat               |
	 * |                         | dddd  | Sunday, Monday, ..., Saturday    |
	 * | Day of ISO week         | E     | 1, 2, ..., 7                     |
	 * | ISO week                | W     | 1, 2, ..., 53                    |
	 * |                         | Wo    | 1st, 2nd, ..., 53rd              |
	 * |                         | WW    | 01, 02, ..., 53                  |
	 * | Year                    | YY    | 00, 01, ..., 99                  |
	 * |                         | YYYY  | 1900, 1901, ..., 2099            |
	 * | ISO week-numbering year | GG    | 00, 01, ..., 99                  |
	 * |                         | GGGG  | 1900, 1901, ..., 2099            |
	 * | AM/PM                   | A     | AM, PM                           |
	 * |                         | a     | am, pm                           |
	 * |                         | aa    | a.m., p.m.                       |
	 * | Hour                    | H     | 0, 1, ... 23                     |
	 * |                         | HH    | 00, 01, ... 23                   |
	 * |                         | h     | 1, 2, ..., 12                    |
	 * |                         | hh    | 01, 02, ..., 12                  |
	 * | Minute                  | m     | 0, 1, ..., 59                    |
	 * |                         | mm    | 00, 01, ..., 59                  |
	 * | Second                  | s     | 0, 1, ..., 59                    |
	 * |                         | ss    | 00, 01, ..., 59                  |
	 * | 1/10 of second          | S     | 0, 1, ..., 9                     |
	 * | 1/100 of second         | SS    | 00, 01, ..., 99                  |
	 * | Millisecond             | SSS   | 000, 001, ..., 999               |
	 * | Timezone                | Z     | -01:00, +00:00, ... +12:00       |
	 * |                         | ZZ    | -0100, +0000, ..., +1200         |
	 * | Seconds timestamp       | X     | 512969520                        |
	 * | Milliseconds timestamp  | x     | 512969520900                     |
	 *
	 * The characters wrapped in square brackets are escaped.
	 *
	 * The result may vary by locale.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @param {String} [format='YYYY-MM-DDTHH:mm:ss.SSSZ'] - the string of tokens
	 * @param {Object} [options] - the object with options
	 * @param {Object} [options.locale=enLocale] - the locale object
	 * @returns {String} the formatted date string
	 *
	 * @example
	 * // Represent 11 February 2014 in middle-endian format:
	 * var result = format(
	 *   new Date(2014, 1, 11),
	 *   'MM/DD/YYYY'
	 * )
	 * //=> '02/11/2014'
	 *
	 * @example
	 * // Represent 2 July 2014 in Esperanto:
	 * var eoLocale = require('date-fns/locale/eo')
	 * var result = format(
	 *   new Date(2014, 6, 2),
	 *   'Do [de] MMMM YYYY',
	 *   {locale: eoLocale}
	 * )
	 * //=> '2-a de julio 2014'
	 */
	function format (dirtyDate, dirtyFormatStr, dirtyOptions) {
	  var formatStr = dirtyFormatStr ? String(dirtyFormatStr) : 'YYYY-MM-DDTHH:mm:ss.SSSZ';
	  var options = dirtyOptions || {};

	  var locale = options.locale;
	  var localeFormatters = en.format.formatters;
	  var formattingTokensRegExp = en.format.formattingTokensRegExp;
	  if (locale && locale.format && locale.format.formatters) {
	    localeFormatters = locale.format.formatters;

	    if (locale.format.formattingTokensRegExp) {
	      formattingTokensRegExp = locale.format.formattingTokensRegExp;
	    }
	  }

	  var date = parse_1(dirtyDate);

	  if (!is_valid(date)) {
	    return 'Invalid Date'
	  }

	  var formatFn = buildFormatFn(formatStr, localeFormatters, formattingTokensRegExp);

	  return formatFn(date)
	}

	var formatters = {
	  // Month: 1, 2, ..., 12
	  'M': function (date) {
	    return date.getMonth() + 1
	  },

	  // Month: 01, 02, ..., 12
	  'MM': function (date) {
	    return addLeadingZeros(date.getMonth() + 1, 2)
	  },

	  // Quarter: 1, 2, 3, 4
	  'Q': function (date) {
	    return Math.ceil((date.getMonth() + 1) / 3)
	  },

	  // Day of month: 1, 2, ..., 31
	  'D': function (date) {
	    return date.getDate()
	  },

	  // Day of month: 01, 02, ..., 31
	  'DD': function (date) {
	    return addLeadingZeros(date.getDate(), 2)
	  },

	  // Day of year: 1, 2, ..., 366
	  'DDD': function (date) {
	    return get_day_of_year(date)
	  },

	  // Day of year: 001, 002, ..., 366
	  'DDDD': function (date) {
	    return addLeadingZeros(get_day_of_year(date), 3)
	  },

	  // Day of week: 0, 1, ..., 6
	  'd': function (date) {
	    return date.getDay()
	  },

	  // Day of ISO week: 1, 2, ..., 7
	  'E': function (date) {
	    return date.getDay() || 7
	  },

	  // ISO week: 1, 2, ..., 53
	  'W': function (date) {
	    return get_iso_week(date)
	  },

	  // ISO week: 01, 02, ..., 53
	  'WW': function (date) {
	    return addLeadingZeros(get_iso_week(date), 2)
	  },

	  // Year: 00, 01, ..., 99
	  'YY': function (date) {
	    return addLeadingZeros(date.getFullYear(), 4).substr(2)
	  },

	  // Year: 1900, 1901, ..., 2099
	  'YYYY': function (date) {
	    return addLeadingZeros(date.getFullYear(), 4)
	  },

	  // ISO week-numbering year: 00, 01, ..., 99
	  'GG': function (date) {
	    return String(get_iso_year(date)).substr(2)
	  },

	  // ISO week-numbering year: 1900, 1901, ..., 2099
	  'GGGG': function (date) {
	    return get_iso_year(date)
	  },

	  // Hour: 0, 1, ... 23
	  'H': function (date) {
	    return date.getHours()
	  },

	  // Hour: 00, 01, ..., 23
	  'HH': function (date) {
	    return addLeadingZeros(date.getHours(), 2)
	  },

	  // Hour: 1, 2, ..., 12
	  'h': function (date) {
	    var hours = date.getHours();
	    if (hours === 0) {
	      return 12
	    } else if (hours > 12) {
	      return hours % 12
	    } else {
	      return hours
	    }
	  },

	  // Hour: 01, 02, ..., 12
	  'hh': function (date) {
	    return addLeadingZeros(formatters['h'](date), 2)
	  },

	  // Minute: 0, 1, ..., 59
	  'm': function (date) {
	    return date.getMinutes()
	  },

	  // Minute: 00, 01, ..., 59
	  'mm': function (date) {
	    return addLeadingZeros(date.getMinutes(), 2)
	  },

	  // Second: 0, 1, ..., 59
	  's': function (date) {
	    return date.getSeconds()
	  },

	  // Second: 00, 01, ..., 59
	  'ss': function (date) {
	    return addLeadingZeros(date.getSeconds(), 2)
	  },

	  // 1/10 of second: 0, 1, ..., 9
	  'S': function (date) {
	    return Math.floor(date.getMilliseconds() / 100)
	  },

	  // 1/100 of second: 00, 01, ..., 99
	  'SS': function (date) {
	    return addLeadingZeros(Math.floor(date.getMilliseconds() / 10), 2)
	  },

	  // Millisecond: 000, 001, ..., 999
	  'SSS': function (date) {
	    return addLeadingZeros(date.getMilliseconds(), 3)
	  },

	  // Timezone: -01:00, +00:00, ... +12:00
	  'Z': function (date) {
	    return formatTimezone(date.getTimezoneOffset(), ':')
	  },

	  // Timezone: -0100, +0000, ... +1200
	  'ZZ': function (date) {
	    return formatTimezone(date.getTimezoneOffset())
	  },

	  // Seconds timestamp: 512969520
	  'X': function (date) {
	    return Math.floor(date.getTime() / 1000)
	  },

	  // Milliseconds timestamp: 512969520900
	  'x': function (date) {
	    return date.getTime()
	  }
	};

	function buildFormatFn (formatStr, localeFormatters, formattingTokensRegExp) {
	  var array = formatStr.match(formattingTokensRegExp);
	  var length = array.length;

	  var i;
	  var formatter;
	  for (i = 0; i < length; i++) {
	    formatter = localeFormatters[array[i]] || formatters[array[i]];
	    if (formatter) {
	      array[i] = formatter;
	    } else {
	      array[i] = removeFormattingTokens(array[i]);
	    }
	  }

	  return function (date) {
	    var output = '';
	    for (var i = 0; i < length; i++) {
	      if (array[i] instanceof Function) {
	        output += array[i](date, formatters);
	      } else {
	        output += array[i];
	      }
	    }
	    return output
	  }
	}

	function removeFormattingTokens (input) {
	  if (input.match(/\[[\s\S]/)) {
	    return input.replace(/^\[|]$/g, '')
	  }
	  return input.replace(/\\/g, '')
	}

	function formatTimezone (offset, delimeter) {
	  delimeter = delimeter || '';
	  var sign = offset > 0 ? '-' : '+';
	  var absOffset = Math.abs(offset);
	  var hours = Math.floor(absOffset / 60);
	  var minutes = absOffset % 60;
	  return sign + addLeadingZeros(hours, 2) + delimeter + addLeadingZeros(minutes, 2)
	}

	function addLeadingZeros (number, targetLength) {
	  var output = Math.abs(number).toString();
	  while (output.length < targetLength) {
	    output = '0' + output;
	  }
	  return output
	}

	var format_1 = format;

	/**
	 * @category Day Helpers
	 * @summary Get the day of the month of the given date.
	 *
	 * @description
	 * Get the day of the month of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the day of month
	 *
	 * @example
	 * // Which day of the month is 29 February 2012?
	 * var result = getDate(new Date(2012, 1, 29))
	 * //=> 29
	 */
	function getDate (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var dayOfMonth = date.getDate();
	  return dayOfMonth
	}

	var get_date = getDate;

	/**
	 * @category Weekday Helpers
	 * @summary Get the day of the week of the given date.
	 *
	 * @description
	 * Get the day of the week of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the day of week
	 *
	 * @example
	 * // Which day of the week is 29 February 2012?
	 * var result = getDay(new Date(2012, 1, 29))
	 * //=> 3
	 */
	function getDay (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var day = date.getDay();
	  return day
	}

	var get_day = getDay;

	/**
	 * @category Year Helpers
	 * @summary Is the given date in the leap year?
	 *
	 * @description
	 * Is the given date in the leap year?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in the leap year
	 *
	 * @example
	 * // Is 1 September 2012 in the leap year?
	 * var result = isLeapYear(new Date(2012, 8, 1))
	 * //=> true
	 */
	function isLeapYear (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var year = date.getFullYear();
	  return year % 400 === 0 || year % 4 === 0 && year % 100 !== 0
	}

	var is_leap_year = isLeapYear;

	/**
	 * @category Year Helpers
	 * @summary Get the number of days in a year of the given date.
	 *
	 * @description
	 * Get the number of days in a year of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the number of days in a year
	 *
	 * @example
	 * // How many days are in 2012?
	 * var result = getDaysInYear(new Date(2012, 0, 1))
	 * //=> 366
	 */
	function getDaysInYear (dirtyDate) {
	  return is_leap_year(dirtyDate) ? 366 : 365
	}

	var get_days_in_year = getDaysInYear;

	/**
	 * @category Hour Helpers
	 * @summary Get the hours of the given date.
	 *
	 * @description
	 * Get the hours of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the hours
	 *
	 * @example
	 * // Get the hours of 29 February 2012 11:45:00:
	 * var result = getHours(new Date(2012, 1, 29, 11, 45))
	 * //=> 11
	 */
	function getHours (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var hours = date.getHours();
	  return hours
	}

	var get_hours = getHours;

	/**
	 * @category Weekday Helpers
	 * @summary Get the day of the ISO week of the given date.
	 *
	 * @description
	 * Get the day of the ISO week of the given date,
	 * which is 7 for Sunday, 1 for Monday etc.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the day of ISO week
	 *
	 * @example
	 * // Which day of the ISO week is 26 February 2012?
	 * var result = getISODay(new Date(2012, 1, 26))
	 * //=> 7
	 */
	function getISODay (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var day = date.getDay();

	  if (day === 0) {
	    day = 7;
	  }

	  return day
	}

	var get_iso_day = getISODay;

	var MILLISECONDS_IN_WEEK$3 = 604800000;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Get the number of weeks in an ISO week-numbering year of the given date.
	 *
	 * @description
	 * Get the number of weeks in an ISO week-numbering year of the given date.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the number of ISO weeks in a year
	 *
	 * @example
	 * // How many weeks are in ISO week-numbering year 2015?
	 * var result = getISOWeeksInYear(new Date(2015, 1, 11))
	 * //=> 53
	 */
	function getISOWeeksInYear (dirtyDate) {
	  var thisYear = start_of_iso_year(dirtyDate);
	  var nextYear = start_of_iso_year(add_weeks(thisYear, 60));
	  var diff = nextYear.valueOf() - thisYear.valueOf();
	  // Round the number of weeks to the nearest integer
	  // because the number of milliseconds in a week is not constant
	  // (e.g. it's different in the week of the daylight saving time clock shift)
	  return Math.round(diff / MILLISECONDS_IN_WEEK$3)
	}

	var get_iso_weeks_in_year = getISOWeeksInYear;

	/**
	 * @category Millisecond Helpers
	 * @summary Get the milliseconds of the given date.
	 *
	 * @description
	 * Get the milliseconds of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the milliseconds
	 *
	 * @example
	 * // Get the milliseconds of 29 February 2012 11:45:05.123:
	 * var result = getMilliseconds(new Date(2012, 1, 29, 11, 45, 5, 123))
	 * //=> 123
	 */
	function getMilliseconds (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var milliseconds = date.getMilliseconds();
	  return milliseconds
	}

	var get_milliseconds = getMilliseconds;

	/**
	 * @category Minute Helpers
	 * @summary Get the minutes of the given date.
	 *
	 * @description
	 * Get the minutes of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the minutes
	 *
	 * @example
	 * // Get the minutes of 29 February 2012 11:45:05:
	 * var result = getMinutes(new Date(2012, 1, 29, 11, 45, 5))
	 * //=> 45
	 */
	function getMinutes (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var minutes = date.getMinutes();
	  return minutes
	}

	var get_minutes = getMinutes;

	/**
	 * @category Month Helpers
	 * @summary Get the month of the given date.
	 *
	 * @description
	 * Get the month of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the month
	 *
	 * @example
	 * // Which month is 29 February 2012?
	 * var result = getMonth(new Date(2012, 1, 29))
	 * //=> 1
	 */
	function getMonth (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var month = date.getMonth();
	  return month
	}

	var get_month = getMonth;

	var MILLISECONDS_IN_DAY$1 = 24 * 60 * 60 * 1000;

	/**
	 * @category Range Helpers
	 * @summary Get the number of days that overlap in two date ranges
	 *
	 * @description
	 * Get the number of days that overlap in two date ranges
	 *
	 * @param {Date|String|Number} initialRangeStartDate - the start of the initial range
	 * @param {Date|String|Number} initialRangeEndDate - the end of the initial range
	 * @param {Date|String|Number} comparedRangeStartDate - the start of the range to compare it with
	 * @param {Date|String|Number} comparedRangeEndDate - the end of the range to compare it with
	 * @returns {Number} the number of days that overlap in two date ranges
	 * @throws {Error} startDate of a date range cannot be after its endDate
	 *
	 * @example
	 * // For overlapping date ranges adds 1 for each started overlapping day:
	 * getOverlappingDaysInRanges(
	 *   new Date(2014, 0, 10), new Date(2014, 0, 20), new Date(2014, 0, 17), new Date(2014, 0, 21)
	 * )
	 * //=> 3
	 *
	 * @example
	 * // For non-overlapping date ranges returns 0:
	 * getOverlappingDaysInRanges(
	 *   new Date(2014, 0, 10), new Date(2014, 0, 20), new Date(2014, 0, 21), new Date(2014, 0, 22)
	 * )
	 * //=> 0
	 */
	function getOverlappingDaysInRanges (dirtyInitialRangeStartDate, dirtyInitialRangeEndDate, dirtyComparedRangeStartDate, dirtyComparedRangeEndDate) {
	  var initialStartTime = parse_1(dirtyInitialRangeStartDate).getTime();
	  var initialEndTime = parse_1(dirtyInitialRangeEndDate).getTime();
	  var comparedStartTime = parse_1(dirtyComparedRangeStartDate).getTime();
	  var comparedEndTime = parse_1(dirtyComparedRangeEndDate).getTime();

	  if (initialStartTime > initialEndTime || comparedStartTime > comparedEndTime) {
	    throw new Error('The start of the range cannot be after the end of the range')
	  }

	  var isOverlapping = initialStartTime < comparedEndTime && comparedStartTime < initialEndTime;

	  if (!isOverlapping) {
	    return 0
	  }

	  var overlapStartDate = comparedStartTime < initialStartTime
	    ? initialStartTime
	    : comparedStartTime;

	  var overlapEndDate = comparedEndTime > initialEndTime
	    ? initialEndTime
	    : comparedEndTime;

	  var differenceInMs = overlapEndDate - overlapStartDate;

	  return Math.ceil(differenceInMs / MILLISECONDS_IN_DAY$1)
	}

	var get_overlapping_days_in_ranges = getOverlappingDaysInRanges;

	/**
	 * @category Second Helpers
	 * @summary Get the seconds of the given date.
	 *
	 * @description
	 * Get the seconds of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the seconds
	 *
	 * @example
	 * // Get the seconds of 29 February 2012 11:45:05.123:
	 * var result = getSeconds(new Date(2012, 1, 29, 11, 45, 5, 123))
	 * //=> 5
	 */
	function getSeconds (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var seconds = date.getSeconds();
	  return seconds
	}

	var get_seconds = getSeconds;

	/**
	 * @category Timestamp Helpers
	 * @summary Get the milliseconds timestamp of the given date.
	 *
	 * @description
	 * Get the milliseconds timestamp of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the timestamp
	 *
	 * @example
	 * // Get the timestamp of 29 February 2012 11:45:05.123:
	 * var result = getTime(new Date(2012, 1, 29, 11, 45, 5, 123))
	 * //=> 1330515905123
	 */
	function getTime (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var timestamp = date.getTime();
	  return timestamp
	}

	var get_time = getTime;

	/**
	 * @category Year Helpers
	 * @summary Get the year of the given date.
	 *
	 * @description
	 * Get the year of the given date.
	 *
	 * @param {Date|String|Number} date - the given date
	 * @returns {Number} the year
	 *
	 * @example
	 * // Which year is 2 July 2014?
	 * var result = getYear(new Date(2014, 6, 2))
	 * //=> 2014
	 */
	function getYear (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var year = date.getFullYear();
	  return year
	}

	var get_year = getYear;

	/**
	 * @category Common Helpers
	 * @summary Is the first date after the second one?
	 *
	 * @description
	 * Is the first date after the second one?
	 *
	 * @param {Date|String|Number} date - the date that should be after the other one to return true
	 * @param {Date|String|Number} dateToCompare - the date to compare with
	 * @returns {Boolean} the first date is after the second date
	 *
	 * @example
	 * // Is 10 July 1989 after 11 February 1987?
	 * var result = isAfter(new Date(1989, 6, 10), new Date(1987, 1, 11))
	 * //=> true
	 */
	function isAfter (dirtyDate, dirtyDateToCompare) {
	  var date = parse_1(dirtyDate);
	  var dateToCompare = parse_1(dirtyDateToCompare);
	  return date.getTime() > dateToCompare.getTime()
	}

	var is_after = isAfter;

	/**
	 * @category Common Helpers
	 * @summary Is the first date before the second one?
	 *
	 * @description
	 * Is the first date before the second one?
	 *
	 * @param {Date|String|Number} date - the date that should be before the other one to return true
	 * @param {Date|String|Number} dateToCompare - the date to compare with
	 * @returns {Boolean} the first date is before the second date
	 *
	 * @example
	 * // Is 10 July 1989 before 11 February 1987?
	 * var result = isBefore(new Date(1989, 6, 10), new Date(1987, 1, 11))
	 * //=> false
	 */
	function isBefore (dirtyDate, dirtyDateToCompare) {
	  var date = parse_1(dirtyDate);
	  var dateToCompare = parse_1(dirtyDateToCompare);
	  return date.getTime() < dateToCompare.getTime()
	}

	var is_before = isBefore;

	/**
	 * @category Common Helpers
	 * @summary Are the given dates equal?
	 *
	 * @description
	 * Are the given dates equal?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to compare
	 * @param {Date|String|Number} dateRight - the second date to compare
	 * @returns {Boolean} the dates are equal
	 *
	 * @example
	 * // Are 2 July 2014 06:30:45.000 and 2 July 2014 06:30:45.500 equal?
	 * var result = isEqual(
	 *   new Date(2014, 6, 2, 6, 30, 45, 0)
	 *   new Date(2014, 6, 2, 6, 30, 45, 500)
	 * )
	 * //=> false
	 */
	function isEqual (dirtyLeftDate, dirtyRightDate) {
	  var dateLeft = parse_1(dirtyLeftDate);
	  var dateRight = parse_1(dirtyRightDate);
	  return dateLeft.getTime() === dateRight.getTime()
	}

	var is_equal = isEqual;

	/**
	 * @category Month Helpers
	 * @summary Is the given date the first day of a month?
	 *
	 * @description
	 * Is the given date the first day of a month?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is the first day of a month
	 *
	 * @example
	 * // Is 1 September 2014 the first day of a month?
	 * var result = isFirstDayOfMonth(new Date(2014, 8, 1))
	 * //=> true
	 */
	function isFirstDayOfMonth (dirtyDate) {
	  return parse_1(dirtyDate).getDate() === 1
	}

	var is_first_day_of_month = isFirstDayOfMonth;

	/**
	 * @category Weekday Helpers
	 * @summary Is the given date Friday?
	 *
	 * @description
	 * Is the given date Friday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is Friday
	 *
	 * @example
	 * // Is 26 September 2014 Friday?
	 * var result = isFriday(new Date(2014, 8, 26))
	 * //=> true
	 */
	function isFriday (dirtyDate) {
	  return parse_1(dirtyDate).getDay() === 5
	}

	var is_friday = isFriday;

	/**
	 * @category Common Helpers
	 * @summary Is the given date in the future?
	 *
	 * @description
	 * Is the given date in the future?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in the future
	 *
	 * @example
	 * // If today is 6 October 2014, is 31 December 2014 in the future?
	 * var result = isFuture(new Date(2014, 11, 31))
	 * //=> true
	 */
	function isFuture (dirtyDate) {
	  return parse_1(dirtyDate).getTime() > new Date().getTime()
	}

	var is_future = isFuture;

	/**
	 * @category Month Helpers
	 * @summary Is the given date the last day of a month?
	 *
	 * @description
	 * Is the given date the last day of a month?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is the last day of a month
	 *
	 * @example
	 * // Is 28 February 2014 the last day of a month?
	 * var result = isLastDayOfMonth(new Date(2014, 1, 28))
	 * //=> true
	 */
	function isLastDayOfMonth (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  return end_of_day(date).getTime() === end_of_month(date).getTime()
	}

	var is_last_day_of_month = isLastDayOfMonth;

	/**
	 * @category Weekday Helpers
	 * @summary Is the given date Monday?
	 *
	 * @description
	 * Is the given date Monday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is Monday
	 *
	 * @example
	 * // Is 22 September 2014 Monday?
	 * var result = isMonday(new Date(2014, 8, 22))
	 * //=> true
	 */
	function isMonday (dirtyDate) {
	  return parse_1(dirtyDate).getDay() === 1
	}

	var is_monday = isMonday;

	/**
	 * @category Common Helpers
	 * @summary Is the given date in the past?
	 *
	 * @description
	 * Is the given date in the past?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in the past
	 *
	 * @example
	 * // If today is 6 October 2014, is 2 July 2014 in the past?
	 * var result = isPast(new Date(2014, 6, 2))
	 * //=> true
	 */
	function isPast (dirtyDate) {
	  return parse_1(dirtyDate).getTime() < new Date().getTime()
	}

	var is_past = isPast;

	/**
	 * @category Day Helpers
	 * @summary Are the given dates in the same day?
	 *
	 * @description
	 * Are the given dates in the same day?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same day
	 *
	 * @example
	 * // Are 4 September 06:00:00 and 4 September 18:00:00 in the same day?
	 * var result = isSameDay(
	 *   new Date(2014, 8, 4, 6, 0),
	 *   new Date(2014, 8, 4, 18, 0)
	 * )
	 * //=> true
	 */
	function isSameDay (dirtyDateLeft, dirtyDateRight) {
	  var dateLeftStartOfDay = start_of_day(dirtyDateLeft);
	  var dateRightStartOfDay = start_of_day(dirtyDateRight);

	  return dateLeftStartOfDay.getTime() === dateRightStartOfDay.getTime()
	}

	var is_same_day = isSameDay;

	/**
	 * @category Hour Helpers
	 * @summary Return the start of an hour for the given date.
	 *
	 * @description
	 * Return the start of an hour for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of an hour
	 *
	 * @example
	 * // The start of an hour for 2 September 2014 11:55:00:
	 * var result = startOfHour(new Date(2014, 8, 2, 11, 55))
	 * //=> Tue Sep 02 2014 11:00:00
	 */
	function startOfHour (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setMinutes(0, 0, 0);
	  return date
	}

	var start_of_hour = startOfHour;

	/**
	 * @category Hour Helpers
	 * @summary Are the given dates in the same hour?
	 *
	 * @description
	 * Are the given dates in the same hour?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same hour
	 *
	 * @example
	 * // Are 4 September 2014 06:00:00 and 4 September 06:30:00 in the same hour?
	 * var result = isSameHour(
	 *   new Date(2014, 8, 4, 6, 0),
	 *   new Date(2014, 8, 4, 6, 30)
	 * )
	 * //=> true
	 */
	function isSameHour (dirtyDateLeft, dirtyDateRight) {
	  var dateLeftStartOfHour = start_of_hour(dirtyDateLeft);
	  var dateRightStartOfHour = start_of_hour(dirtyDateRight);

	  return dateLeftStartOfHour.getTime() === dateRightStartOfHour.getTime()
	}

	var is_same_hour = isSameHour;

	/**
	 * @category Week Helpers
	 * @summary Are the given dates in the same week?
	 *
	 * @description
	 * Are the given dates in the same week?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @param {Object} [options] - the object with options
	 * @param {Number} [options.weekStartsOn=0] - the index of the first day of the week (0 - Sunday)
	 * @returns {Boolean} the dates are in the same week
	 *
	 * @example
	 * // Are 31 August 2014 and 4 September 2014 in the same week?
	 * var result = isSameWeek(
	 *   new Date(2014, 7, 31),
	 *   new Date(2014, 8, 4)
	 * )
	 * //=> true
	 *
	 * @example
	 * // If week starts with Monday,
	 * // are 31 August 2014 and 4 September 2014 in the same week?
	 * var result = isSameWeek(
	 *   new Date(2014, 7, 31),
	 *   new Date(2014, 8, 4),
	 *   {weekStartsOn: 1}
	 * )
	 * //=> false
	 */
	function isSameWeek (dirtyDateLeft, dirtyDateRight, dirtyOptions) {
	  var dateLeftStartOfWeek = start_of_week(dirtyDateLeft, dirtyOptions);
	  var dateRightStartOfWeek = start_of_week(dirtyDateRight, dirtyOptions);

	  return dateLeftStartOfWeek.getTime() === dateRightStartOfWeek.getTime()
	}

	var is_same_week = isSameWeek;

	/**
	 * @category ISO Week Helpers
	 * @summary Are the given dates in the same ISO week?
	 *
	 * @description
	 * Are the given dates in the same ISO week?
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same ISO week
	 *
	 * @example
	 * // Are 1 September 2014 and 7 September 2014 in the same ISO week?
	 * var result = isSameISOWeek(
	 *   new Date(2014, 8, 1),
	 *   new Date(2014, 8, 7)
	 * )
	 * //=> true
	 */
	function isSameISOWeek (dirtyDateLeft, dirtyDateRight) {
	  return is_same_week(dirtyDateLeft, dirtyDateRight, {weekStartsOn: 1})
	}

	var is_same_iso_week = isSameISOWeek;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Are the given dates in the same ISO week-numbering year?
	 *
	 * @description
	 * Are the given dates in the same ISO week-numbering year?
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same ISO week-numbering year
	 *
	 * @example
	 * // Are 29 December 2003 and 2 January 2005 in the same ISO week-numbering year?
	 * var result = isSameISOYear(
	 *   new Date(2003, 11, 29),
	 *   new Date(2005, 0, 2)
	 * )
	 * //=> true
	 */
	function isSameISOYear (dirtyDateLeft, dirtyDateRight) {
	  var dateLeftStartOfYear = start_of_iso_year(dirtyDateLeft);
	  var dateRightStartOfYear = start_of_iso_year(dirtyDateRight);

	  return dateLeftStartOfYear.getTime() === dateRightStartOfYear.getTime()
	}

	var is_same_iso_year = isSameISOYear;

	/**
	 * @category Minute Helpers
	 * @summary Return the start of a minute for the given date.
	 *
	 * @description
	 * Return the start of a minute for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of a minute
	 *
	 * @example
	 * // The start of a minute for 1 December 2014 22:15:45.400:
	 * var result = startOfMinute(new Date(2014, 11, 1, 22, 15, 45, 400))
	 * //=> Mon Dec 01 2014 22:15:00
	 */
	function startOfMinute (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setSeconds(0, 0);
	  return date
	}

	var start_of_minute = startOfMinute;

	/**
	 * @category Minute Helpers
	 * @summary Are the given dates in the same minute?
	 *
	 * @description
	 * Are the given dates in the same minute?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same minute
	 *
	 * @example
	 * // Are 4 September 2014 06:30:00 and 4 September 2014 06:30:15
	 * // in the same minute?
	 * var result = isSameMinute(
	 *   new Date(2014, 8, 4, 6, 30),
	 *   new Date(2014, 8, 4, 6, 30, 15)
	 * )
	 * //=> true
	 */
	function isSameMinute (dirtyDateLeft, dirtyDateRight) {
	  var dateLeftStartOfMinute = start_of_minute(dirtyDateLeft);
	  var dateRightStartOfMinute = start_of_minute(dirtyDateRight);

	  return dateLeftStartOfMinute.getTime() === dateRightStartOfMinute.getTime()
	}

	var is_same_minute = isSameMinute;

	/**
	 * @category Month Helpers
	 * @summary Are the given dates in the same month?
	 *
	 * @description
	 * Are the given dates in the same month?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same month
	 *
	 * @example
	 * // Are 2 September 2014 and 25 September 2014 in the same month?
	 * var result = isSameMonth(
	 *   new Date(2014, 8, 2),
	 *   new Date(2014, 8, 25)
	 * )
	 * //=> true
	 */
	function isSameMonth (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);
	  return dateLeft.getFullYear() === dateRight.getFullYear() &&
	    dateLeft.getMonth() === dateRight.getMonth()
	}

	var is_same_month = isSameMonth;

	/**
	 * @category Quarter Helpers
	 * @summary Return the start of a year quarter for the given date.
	 *
	 * @description
	 * Return the start of a year quarter for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of a quarter
	 *
	 * @example
	 * // The start of a quarter for 2 September 2014 11:55:00:
	 * var result = startOfQuarter(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Tue Jul 01 2014 00:00:00
	 */
	function startOfQuarter (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var currentMonth = date.getMonth();
	  var month = currentMonth - currentMonth % 3;
	  date.setMonth(month, 1);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var start_of_quarter = startOfQuarter;

	/**
	 * @category Quarter Helpers
	 * @summary Are the given dates in the same year quarter?
	 *
	 * @description
	 * Are the given dates in the same year quarter?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same quarter
	 *
	 * @example
	 * // Are 1 January 2014 and 8 March 2014 in the same quarter?
	 * var result = isSameQuarter(
	 *   new Date(2014, 0, 1),
	 *   new Date(2014, 2, 8)
	 * )
	 * //=> true
	 */
	function isSameQuarter (dirtyDateLeft, dirtyDateRight) {
	  var dateLeftStartOfQuarter = start_of_quarter(dirtyDateLeft);
	  var dateRightStartOfQuarter = start_of_quarter(dirtyDateRight);

	  return dateLeftStartOfQuarter.getTime() === dateRightStartOfQuarter.getTime()
	}

	var is_same_quarter = isSameQuarter;

	/**
	 * @category Second Helpers
	 * @summary Return the start of a second for the given date.
	 *
	 * @description
	 * Return the start of a second for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of a second
	 *
	 * @example
	 * // The start of a second for 1 December 2014 22:15:45.400:
	 * var result = startOfSecond(new Date(2014, 11, 1, 22, 15, 45, 400))
	 * //=> Mon Dec 01 2014 22:15:45.000
	 */
	function startOfSecond (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setMilliseconds(0);
	  return date
	}

	var start_of_second = startOfSecond;

	/**
	 * @category Second Helpers
	 * @summary Are the given dates in the same second?
	 *
	 * @description
	 * Are the given dates in the same second?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same second
	 *
	 * @example
	 * // Are 4 September 2014 06:30:15.000 and 4 September 2014 06:30.15.500
	 * // in the same second?
	 * var result = isSameSecond(
	 *   new Date(2014, 8, 4, 6, 30, 15),
	 *   new Date(2014, 8, 4, 6, 30, 15, 500)
	 * )
	 * //=> true
	 */
	function isSameSecond (dirtyDateLeft, dirtyDateRight) {
	  var dateLeftStartOfSecond = start_of_second(dirtyDateLeft);
	  var dateRightStartOfSecond = start_of_second(dirtyDateRight);

	  return dateLeftStartOfSecond.getTime() === dateRightStartOfSecond.getTime()
	}

	var is_same_second = isSameSecond;

	/**
	 * @category Year Helpers
	 * @summary Are the given dates in the same year?
	 *
	 * @description
	 * Are the given dates in the same year?
	 *
	 * @param {Date|String|Number} dateLeft - the first date to check
	 * @param {Date|String|Number} dateRight - the second date to check
	 * @returns {Boolean} the dates are in the same year
	 *
	 * @example
	 * // Are 2 September 2014 and 25 September 2014 in the same year?
	 * var result = isSameYear(
	 *   new Date(2014, 8, 2),
	 *   new Date(2014, 8, 25)
	 * )
	 * //=> true
	 */
	function isSameYear (dirtyDateLeft, dirtyDateRight) {
	  var dateLeft = parse_1(dirtyDateLeft);
	  var dateRight = parse_1(dirtyDateRight);
	  return dateLeft.getFullYear() === dateRight.getFullYear()
	}

	var is_same_year = isSameYear;

	/**
	 * @category Weekday Helpers
	 * @summary Is the given date Saturday?
	 *
	 * @description
	 * Is the given date Saturday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is Saturday
	 *
	 * @example
	 * // Is 27 September 2014 Saturday?
	 * var result = isSaturday(new Date(2014, 8, 27))
	 * //=> true
	 */
	function isSaturday (dirtyDate) {
	  return parse_1(dirtyDate).getDay() === 6
	}

	var is_saturday = isSaturday;

	/**
	 * @category Weekday Helpers
	 * @summary Is the given date Sunday?
	 *
	 * @description
	 * Is the given date Sunday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is Sunday
	 *
	 * @example
	 * // Is 21 September 2014 Sunday?
	 * var result = isSunday(new Date(2014, 8, 21))
	 * //=> true
	 */
	function isSunday (dirtyDate) {
	  return parse_1(dirtyDate).getDay() === 0
	}

	var is_sunday = isSunday;

	/**
	 * @category Hour Helpers
	 * @summary Is the given date in the same hour as the current date?
	 *
	 * @description
	 * Is the given date in the same hour as the current date?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this hour
	 *
	 * @example
	 * // If now is 25 September 2014 18:30:15.500,
	 * // is 25 September 2014 18:00:00 in this hour?
	 * var result = isThisHour(new Date(2014, 8, 25, 18))
	 * //=> true
	 */
	function isThisHour (dirtyDate) {
	  return is_same_hour(new Date(), dirtyDate)
	}

	var is_this_hour = isThisHour;

	/**
	 * @category ISO Week Helpers
	 * @summary Is the given date in the same ISO week as the current date?
	 *
	 * @description
	 * Is the given date in the same ISO week as the current date?
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this ISO week
	 *
	 * @example
	 * // If today is 25 September 2014, is 22 September 2014 in this ISO week?
	 * var result = isThisISOWeek(new Date(2014, 8, 22))
	 * //=> true
	 */
	function isThisISOWeek (dirtyDate) {
	  return is_same_iso_week(new Date(), dirtyDate)
	}

	var is_this_iso_week = isThisISOWeek;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Is the given date in the same ISO week-numbering year as the current date?
	 *
	 * @description
	 * Is the given date in the same ISO week-numbering year as the current date?
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this ISO week-numbering year
	 *
	 * @example
	 * // If today is 25 September 2014,
	 * // is 30 December 2013 in this ISO week-numbering year?
	 * var result = isThisISOYear(new Date(2013, 11, 30))
	 * //=> true
	 */
	function isThisISOYear (dirtyDate) {
	  return is_same_iso_year(new Date(), dirtyDate)
	}

	var is_this_iso_year = isThisISOYear;

	/**
	 * @category Minute Helpers
	 * @summary Is the given date in the same minute as the current date?
	 *
	 * @description
	 * Is the given date in the same minute as the current date?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this minute
	 *
	 * @example
	 * // If now is 25 September 2014 18:30:15.500,
	 * // is 25 September 2014 18:30:00 in this minute?
	 * var result = isThisMinute(new Date(2014, 8, 25, 18, 30))
	 * //=> true
	 */
	function isThisMinute (dirtyDate) {
	  return is_same_minute(new Date(), dirtyDate)
	}

	var is_this_minute = isThisMinute;

	/**
	 * @category Month Helpers
	 * @summary Is the given date in the same month as the current date?
	 *
	 * @description
	 * Is the given date in the same month as the current date?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this month
	 *
	 * @example
	 * // If today is 25 September 2014, is 15 September 2014 in this month?
	 * var result = isThisMonth(new Date(2014, 8, 15))
	 * //=> true
	 */
	function isThisMonth (dirtyDate) {
	  return is_same_month(new Date(), dirtyDate)
	}

	var is_this_month = isThisMonth;

	/**
	 * @category Quarter Helpers
	 * @summary Is the given date in the same quarter as the current date?
	 *
	 * @description
	 * Is the given date in the same quarter as the current date?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this quarter
	 *
	 * @example
	 * // If today is 25 September 2014, is 2 July 2014 in this quarter?
	 * var result = isThisQuarter(new Date(2014, 6, 2))
	 * //=> true
	 */
	function isThisQuarter (dirtyDate) {
	  return is_same_quarter(new Date(), dirtyDate)
	}

	var is_this_quarter = isThisQuarter;

	/**
	 * @category Second Helpers
	 * @summary Is the given date in the same second as the current date?
	 *
	 * @description
	 * Is the given date in the same second as the current date?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this second
	 *
	 * @example
	 * // If now is 25 September 2014 18:30:15.500,
	 * // is 25 September 2014 18:30:15.000 in this second?
	 * var result = isThisSecond(new Date(2014, 8, 25, 18, 30, 15))
	 * //=> true
	 */
	function isThisSecond (dirtyDate) {
	  return is_same_second(new Date(), dirtyDate)
	}

	var is_this_second = isThisSecond;

	/**
	 * @category Week Helpers
	 * @summary Is the given date in the same week as the current date?
	 *
	 * @description
	 * Is the given date in the same week as the current date?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @param {Object} [options] - the object with options
	 * @param {Number} [options.weekStartsOn=0] - the index of the first day of the week (0 - Sunday)
	 * @returns {Boolean} the date is in this week
	 *
	 * @example
	 * // If today is 25 September 2014, is 21 September 2014 in this week?
	 * var result = isThisWeek(new Date(2014, 8, 21))
	 * //=> true
	 *
	 * @example
	 * // If today is 25 September 2014 and week starts with Monday
	 * // is 21 September 2014 in this week?
	 * var result = isThisWeek(new Date(2014, 8, 21), {weekStartsOn: 1})
	 * //=> false
	 */
	function isThisWeek (dirtyDate, dirtyOptions) {
	  return is_same_week(new Date(), dirtyDate, dirtyOptions)
	}

	var is_this_week = isThisWeek;

	/**
	 * @category Year Helpers
	 * @summary Is the given date in the same year as the current date?
	 *
	 * @description
	 * Is the given date in the same year as the current date?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is in this year
	 *
	 * @example
	 * // If today is 25 September 2014, is 2 July 2014 in this year?
	 * var result = isThisYear(new Date(2014, 6, 2))
	 * //=> true
	 */
	function isThisYear (dirtyDate) {
	  return is_same_year(new Date(), dirtyDate)
	}

	var is_this_year = isThisYear;

	/**
	 * @category Weekday Helpers
	 * @summary Is the given date Thursday?
	 *
	 * @description
	 * Is the given date Thursday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is Thursday
	 *
	 * @example
	 * // Is 25 September 2014 Thursday?
	 * var result = isThursday(new Date(2014, 8, 25))
	 * //=> true
	 */
	function isThursday (dirtyDate) {
	  return parse_1(dirtyDate).getDay() === 4
	}

	var is_thursday = isThursday;

	/**
	 * @category Day Helpers
	 * @summary Is the given date today?
	 *
	 * @description
	 * Is the given date today?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is today
	 *
	 * @example
	 * // If today is 6 October 2014, is 6 October 14:00:00 today?
	 * var result = isToday(new Date(2014, 9, 6, 14, 0))
	 * //=> true
	 */
	function isToday (dirtyDate) {
	  return start_of_day(dirtyDate).getTime() === start_of_day(new Date()).getTime()
	}

	var is_today = isToday;

	/**
	 * @category Day Helpers
	 * @summary Is the given date tomorrow?
	 *
	 * @description
	 * Is the given date tomorrow?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is tomorrow
	 *
	 * @example
	 * // If today is 6 October 2014, is 7 October 14:00:00 tomorrow?
	 * var result = isTomorrow(new Date(2014, 9, 7, 14, 0))
	 * //=> true
	 */
	function isTomorrow (dirtyDate) {
	  var tomorrow = new Date();
	  tomorrow.setDate(tomorrow.getDate() + 1);
	  return start_of_day(dirtyDate).getTime() === start_of_day(tomorrow).getTime()
	}

	var is_tomorrow = isTomorrow;

	/**
	 * @category Weekday Helpers
	 * @summary Is the given date Tuesday?
	 *
	 * @description
	 * Is the given date Tuesday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is Tuesday
	 *
	 * @example
	 * // Is 23 September 2014 Tuesday?
	 * var result = isTuesday(new Date(2014, 8, 23))
	 * //=> true
	 */
	function isTuesday (dirtyDate) {
	  return parse_1(dirtyDate).getDay() === 2
	}

	var is_tuesday = isTuesday;

	/**
	 * @category Weekday Helpers
	 * @summary Is the given date Wednesday?
	 *
	 * @description
	 * Is the given date Wednesday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is Wednesday
	 *
	 * @example
	 * // Is 24 September 2014 Wednesday?
	 * var result = isWednesday(new Date(2014, 8, 24))
	 * //=> true
	 */
	function isWednesday (dirtyDate) {
	  return parse_1(dirtyDate).getDay() === 3
	}

	var is_wednesday = isWednesday;

	/**
	 * @category Weekday Helpers
	 * @summary Does the given date fall on a weekend?
	 *
	 * @description
	 * Does the given date fall on a weekend?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date falls on a weekend
	 *
	 * @example
	 * // Does 5 October 2014 fall on a weekend?
	 * var result = isWeekend(new Date(2014, 9, 5))
	 * //=> true
	 */
	function isWeekend (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var day = date.getDay();
	  return day === 0 || day === 6
	}

	var is_weekend = isWeekend;

	/**
	 * @category Range Helpers
	 * @summary Is the given date within the range?
	 *
	 * @description
	 * Is the given date within the range?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @param {Date|String|Number} startDate - the start of range
	 * @param {Date|String|Number} endDate - the end of range
	 * @returns {Boolean} the date is within the range
	 * @throws {Error} startDate cannot be after endDate
	 *
	 * @example
	 * // For the date within the range:
	 * isWithinRange(
	 *   new Date(2014, 0, 3), new Date(2014, 0, 1), new Date(2014, 0, 7)
	 * )
	 * //=> true
	 *
	 * @example
	 * // For the date outside of the range:
	 * isWithinRange(
	 *   new Date(2014, 0, 10), new Date(2014, 0, 1), new Date(2014, 0, 7)
	 * )
	 * //=> false
	 */
	function isWithinRange (dirtyDate, dirtyStartDate, dirtyEndDate) {
	  var time = parse_1(dirtyDate).getTime();
	  var startTime = parse_1(dirtyStartDate).getTime();
	  var endTime = parse_1(dirtyEndDate).getTime();

	  if (startTime > endTime) {
	    throw new Error('The start of the range cannot be after the end of the range')
	  }

	  return time >= startTime && time <= endTime
	}

	var is_within_range = isWithinRange;

	/**
	 * @category Day Helpers
	 * @summary Is the given date yesterday?
	 *
	 * @description
	 * Is the given date yesterday?
	 *
	 * @param {Date|String|Number} date - the date to check
	 * @returns {Boolean} the date is yesterday
	 *
	 * @example
	 * // If today is 6 October 2014, is 5 October 14:00:00 yesterday?
	 * var result = isYesterday(new Date(2014, 9, 5, 14, 0))
	 * //=> true
	 */
	function isYesterday (dirtyDate) {
	  var yesterday = new Date();
	  yesterday.setDate(yesterday.getDate() - 1);
	  return start_of_day(dirtyDate).getTime() === start_of_day(yesterday).getTime()
	}

	var is_yesterday = isYesterday;

	/**
	 * @category Week Helpers
	 * @summary Return the last day of a week for the given date.
	 *
	 * @description
	 * Return the last day of a week for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @param {Object} [options] - the object with options
	 * @param {Number} [options.weekStartsOn=0] - the index of the first day of the week (0 - Sunday)
	 * @returns {Date} the last day of a week
	 *
	 * @example
	 * // The last day of a week for 2 September 2014 11:55:00:
	 * var result = lastDayOfWeek(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Sat Sep 06 2014 00:00:00
	 *
	 * @example
	 * // If the week starts on Monday, the last day of the week for 2 September 2014 11:55:00:
	 * var result = lastDayOfWeek(new Date(2014, 8, 2, 11, 55, 0), {weekStartsOn: 1})
	 * //=> Sun Sep 07 2014 00:00:00
	 */
	function lastDayOfWeek (dirtyDate, dirtyOptions) {
	  var weekStartsOn = dirtyOptions ? (Number(dirtyOptions.weekStartsOn) || 0) : 0;

	  var date = parse_1(dirtyDate);
	  var day = date.getDay();
	  var diff = (day < weekStartsOn ? -7 : 0) + 6 - (day - weekStartsOn);

	  date.setHours(0, 0, 0, 0);
	  date.setDate(date.getDate() + diff);
	  return date
	}

	var last_day_of_week = lastDayOfWeek;

	/**
	 * @category ISO Week Helpers
	 * @summary Return the last day of an ISO week for the given date.
	 *
	 * @description
	 * Return the last day of an ISO week for the given date.
	 * The result will be in the local timezone.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the last day of an ISO week
	 *
	 * @example
	 * // The last day of an ISO week for 2 September 2014 11:55:00:
	 * var result = lastDayOfISOWeek(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Sun Sep 07 2014 00:00:00
	 */
	function lastDayOfISOWeek (dirtyDate) {
	  return last_day_of_week(dirtyDate, {weekStartsOn: 1})
	}

	var last_day_of_iso_week = lastDayOfISOWeek;

	/**
	 * @category ISO Week-Numbering Year Helpers
	 * @summary Return the last day of an ISO week-numbering year for the given date.
	 *
	 * @description
	 * Return the last day of an ISO week-numbering year,
	 * which always starts 3 days before the year's first Thursday.
	 * The result will be in the local timezone.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the end of an ISO week-numbering year
	 *
	 * @example
	 * // The last day of an ISO week-numbering year for 2 July 2005:
	 * var result = lastDayOfISOYear(new Date(2005, 6, 2))
	 * //=> Sun Jan 01 2006 00:00:00
	 */
	function lastDayOfISOYear (dirtyDate) {
	  var year = get_iso_year(dirtyDate);
	  var fourthOfJanuary = new Date(0);
	  fourthOfJanuary.setFullYear(year + 1, 0, 4);
	  fourthOfJanuary.setHours(0, 0, 0, 0);
	  var date = start_of_iso_week(fourthOfJanuary);
	  date.setDate(date.getDate() - 1);
	  return date
	}

	var last_day_of_iso_year = lastDayOfISOYear;

	/**
	 * @category Month Helpers
	 * @summary Return the last day of a month for the given date.
	 *
	 * @description
	 * Return the last day of a month for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the last day of a month
	 *
	 * @example
	 * // The last day of a month for 2 September 2014 11:55:00:
	 * var result = lastDayOfMonth(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Tue Sep 30 2014 00:00:00
	 */
	function lastDayOfMonth (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var month = date.getMonth();
	  date.setFullYear(date.getFullYear(), month + 1, 0);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var last_day_of_month = lastDayOfMonth;

	/**
	 * @category Quarter Helpers
	 * @summary Return the last day of a year quarter for the given date.
	 *
	 * @description
	 * Return the last day of a year quarter for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the last day of a quarter
	 *
	 * @example
	 * // The last day of a quarter for 2 September 2014 11:55:00:
	 * var result = lastDayOfQuarter(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Tue Sep 30 2014 00:00:00
	 */
	function lastDayOfQuarter (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var currentMonth = date.getMonth();
	  var month = currentMonth - currentMonth % 3 + 3;
	  date.setMonth(month, 0);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var last_day_of_quarter = lastDayOfQuarter;

	/**
	 * @category Year Helpers
	 * @summary Return the last day of a year for the given date.
	 *
	 * @description
	 * Return the last day of a year for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the last day of a year
	 *
	 * @example
	 * // The last day of a year for 2 September 2014 11:55:00:
	 * var result = lastDayOfYear(new Date(2014, 8, 2, 11, 55, 00))
	 * //=> Wed Dec 31 2014 00:00:00
	 */
	function lastDayOfYear (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  var year = date.getFullYear();
	  date.setFullYear(year + 1, 0, 0);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var last_day_of_year = lastDayOfYear;

	/**
	 * @category Common Helpers
	 * @summary Return the latest of the given dates.
	 *
	 * @description
	 * Return the latest of the given dates.
	 *
	 * @param {...(Date|String|Number)} dates - the dates to compare
	 * @returns {Date} the latest of the dates
	 *
	 * @example
	 * // Which of these dates is the latest?
	 * var result = max(
	 *   new Date(1989, 6, 10),
	 *   new Date(1987, 1, 11),
	 *   new Date(1995, 6, 2),
	 *   new Date(1990, 0, 1)
	 * )
	 * //=> Sun Jul 02 1995 00:00:00
	 */
	function max () {
	  var dirtyDates = Array.prototype.slice.call(arguments);
	  var dates = dirtyDates.map(function (dirtyDate) {
	    return parse_1(dirtyDate)
	  });
	  var latestTimestamp = Math.max.apply(null, dates);
	  return new Date(latestTimestamp)
	}

	var max_1 = max;

	/**
	 * @category Common Helpers
	 * @summary Return the earliest of the given dates.
	 *
	 * @description
	 * Return the earliest of the given dates.
	 *
	 * @param {...(Date|String|Number)} dates - the dates to compare
	 * @returns {Date} the earliest of the dates
	 *
	 * @example
	 * // Which of these dates is the earliest?
	 * var result = min(
	 *   new Date(1989, 6, 10),
	 *   new Date(1987, 1, 11),
	 *   new Date(1995, 6, 2),
	 *   new Date(1990, 0, 1)
	 * )
	 * //=> Wed Feb 11 1987 00:00:00
	 */
	function min () {
	  var dirtyDates = Array.prototype.slice.call(arguments);
	  var dates = dirtyDates.map(function (dirtyDate) {
	    return parse_1(dirtyDate)
	  });
	  var earliestTimestamp = Math.min.apply(null, dates);
	  return new Date(earliestTimestamp)
	}

	var min_1 = min;

	/**
	 * @category Day Helpers
	 * @summary Set the day of the month to the given date.
	 *
	 * @description
	 * Set the day of the month to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} dayOfMonth - the day of the month of the new date
	 * @returns {Date} the new date with the day of the month setted
	 *
	 * @example
	 * // Set the 30th day of the month to 1 September 2014:
	 * var result = setDate(new Date(2014, 8, 1), 30)
	 * //=> Tue Sep 30 2014 00:00:00
	 */
	function setDate (dirtyDate, dirtyDayOfMonth) {
	  var date = parse_1(dirtyDate);
	  var dayOfMonth = Number(dirtyDayOfMonth);
	  date.setDate(dayOfMonth);
	  return date
	}

	var set_date = setDate;

	/**
	 * @category Weekday Helpers
	 * @summary Set the day of the week to the given date.
	 *
	 * @description
	 * Set the day of the week to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} day - the day of the week of the new date
	 * @param {Object} [options] - the object with options
	 * @param {Number} [options.weekStartsOn=0] - the index of the first day of the week (0 - Sunday)
	 * @returns {Date} the new date with the day of the week setted
	 *
	 * @example
	 * // Set Sunday to 1 September 2014:
	 * var result = setDay(new Date(2014, 8, 1), 0)
	 * //=> Sun Aug 31 2014 00:00:00
	 *
	 * @example
	 * // If week starts with Monday, set Sunday to 1 September 2014:
	 * var result = setDay(new Date(2014, 8, 1), 0, {weekStartsOn: 1})
	 * //=> Sun Sep 07 2014 00:00:00
	 */
	function setDay (dirtyDate, dirtyDay, dirtyOptions) {
	  var weekStartsOn = dirtyOptions ? (Number(dirtyOptions.weekStartsOn) || 0) : 0;
	  var date = parse_1(dirtyDate);
	  var day = Number(dirtyDay);
	  var currentDay = date.getDay();

	  var remainder = day % 7;
	  var dayIndex = (remainder + 7) % 7;

	  var diff = (dayIndex < weekStartsOn ? 7 : 0) + day - currentDay;
	  return add_days(date, diff)
	}

	var set_day = setDay;

	/**
	 * @category Day Helpers
	 * @summary Set the day of the year to the given date.
	 *
	 * @description
	 * Set the day of the year to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} dayOfYear - the day of the year of the new date
	 * @returns {Date} the new date with the day of the year setted
	 *
	 * @example
	 * // Set the 2nd day of the year to 2 July 2014:
	 * var result = setDayOfYear(new Date(2014, 6, 2), 2)
	 * //=> Thu Jan 02 2014 00:00:00
	 */
	function setDayOfYear (dirtyDate, dirtyDayOfYear) {
	  var date = parse_1(dirtyDate);
	  var dayOfYear = Number(dirtyDayOfYear);
	  date.setMonth(0);
	  date.setDate(dayOfYear);
	  return date
	}

	var set_day_of_year = setDayOfYear;

	/**
	 * @category Hour Helpers
	 * @summary Set the hours to the given date.
	 *
	 * @description
	 * Set the hours to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} hours - the hours of the new date
	 * @returns {Date} the new date with the hours setted
	 *
	 * @example
	 * // Set 4 hours to 1 September 2014 11:30:00:
	 * var result = setHours(new Date(2014, 8, 1, 11, 30), 4)
	 * //=> Mon Sep 01 2014 04:30:00
	 */
	function setHours (dirtyDate, dirtyHours) {
	  var date = parse_1(dirtyDate);
	  var hours = Number(dirtyHours);
	  date.setHours(hours);
	  return date
	}

	var set_hours = setHours;

	/**
	 * @category Weekday Helpers
	 * @summary Set the day of the ISO week to the given date.
	 *
	 * @description
	 * Set the day of the ISO week to the given date.
	 * ISO week starts with Monday.
	 * 7 is the index of Sunday, 1 is the index of Monday etc.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} day - the day of the ISO week of the new date
	 * @returns {Date} the new date with the day of the ISO week setted
	 *
	 * @example
	 * // Set Sunday to 1 September 2014:
	 * var result = setISODay(new Date(2014, 8, 1), 7)
	 * //=> Sun Sep 07 2014 00:00:00
	 */
	function setISODay (dirtyDate, dirtyDay) {
	  var date = parse_1(dirtyDate);
	  var day = Number(dirtyDay);
	  var currentDay = get_iso_day(date);
	  var diff = day - currentDay;
	  return add_days(date, diff)
	}

	var set_iso_day = setISODay;

	/**
	 * @category ISO Week Helpers
	 * @summary Set the ISO week to the given date.
	 *
	 * @description
	 * Set the ISO week to the given date, saving the weekday number.
	 *
	 * ISO week-numbering year: http://en.wikipedia.org/wiki/ISO_week_date
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} isoWeek - the ISO week of the new date
	 * @returns {Date} the new date with the ISO week setted
	 *
	 * @example
	 * // Set the 53rd ISO week to 7 August 2004:
	 * var result = setISOWeek(new Date(2004, 7, 7), 53)
	 * //=> Sat Jan 01 2005 00:00:00
	 */
	function setISOWeek (dirtyDate, dirtyISOWeek) {
	  var date = parse_1(dirtyDate);
	  var isoWeek = Number(dirtyISOWeek);
	  var diff = get_iso_week(date) - isoWeek;
	  date.setDate(date.getDate() - diff * 7);
	  return date
	}

	var set_iso_week = setISOWeek;

	/**
	 * @category Millisecond Helpers
	 * @summary Set the milliseconds to the given date.
	 *
	 * @description
	 * Set the milliseconds to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} milliseconds - the milliseconds of the new date
	 * @returns {Date} the new date with the milliseconds setted
	 *
	 * @example
	 * // Set 300 milliseconds to 1 September 2014 11:30:40.500:
	 * var result = setMilliseconds(new Date(2014, 8, 1, 11, 30, 40, 500), 300)
	 * //=> Mon Sep 01 2014 11:30:40.300
	 */
	function setMilliseconds (dirtyDate, dirtyMilliseconds) {
	  var date = parse_1(dirtyDate);
	  var milliseconds = Number(dirtyMilliseconds);
	  date.setMilliseconds(milliseconds);
	  return date
	}

	var set_milliseconds = setMilliseconds;

	/**
	 * @category Minute Helpers
	 * @summary Set the minutes to the given date.
	 *
	 * @description
	 * Set the minutes to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} minutes - the minutes of the new date
	 * @returns {Date} the new date with the minutes setted
	 *
	 * @example
	 * // Set 45 minutes to 1 September 2014 11:30:40:
	 * var result = setMinutes(new Date(2014, 8, 1, 11, 30, 40), 45)
	 * //=> Mon Sep 01 2014 11:45:40
	 */
	function setMinutes (dirtyDate, dirtyMinutes) {
	  var date = parse_1(dirtyDate);
	  var minutes = Number(dirtyMinutes);
	  date.setMinutes(minutes);
	  return date
	}

	var set_minutes = setMinutes;

	/**
	 * @category Month Helpers
	 * @summary Set the month to the given date.
	 *
	 * @description
	 * Set the month to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} month - the month of the new date
	 * @returns {Date} the new date with the month setted
	 *
	 * @example
	 * // Set February to 1 September 2014:
	 * var result = setMonth(new Date(2014, 8, 1), 1)
	 * //=> Sat Feb 01 2014 00:00:00
	 */
	function setMonth (dirtyDate, dirtyMonth) {
	  var date = parse_1(dirtyDate);
	  var month = Number(dirtyMonth);
	  var year = date.getFullYear();
	  var day = date.getDate();

	  var dateWithDesiredMonth = new Date(0);
	  dateWithDesiredMonth.setFullYear(year, month, 15);
	  dateWithDesiredMonth.setHours(0, 0, 0, 0);
	  var daysInMonth = get_days_in_month(dateWithDesiredMonth);
	  // Set the last day of the new month
	  // if the original date was the last day of the longer month
	  date.setMonth(month, Math.min(day, daysInMonth));
	  return date
	}

	var set_month = setMonth;

	/**
	 * @category Quarter Helpers
	 * @summary Set the year quarter to the given date.
	 *
	 * @description
	 * Set the year quarter to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} quarter - the quarter of the new date
	 * @returns {Date} the new date with the quarter setted
	 *
	 * @example
	 * // Set the 2nd quarter to 2 July 2014:
	 * var result = setQuarter(new Date(2014, 6, 2), 2)
	 * //=> Wed Apr 02 2014 00:00:00
	 */
	function setQuarter (dirtyDate, dirtyQuarter) {
	  var date = parse_1(dirtyDate);
	  var quarter = Number(dirtyQuarter);
	  var oldQuarter = Math.floor(date.getMonth() / 3) + 1;
	  var diff = quarter - oldQuarter;
	  return set_month(date, date.getMonth() + diff * 3)
	}

	var set_quarter = setQuarter;

	/**
	 * @category Second Helpers
	 * @summary Set the seconds to the given date.
	 *
	 * @description
	 * Set the seconds to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} seconds - the seconds of the new date
	 * @returns {Date} the new date with the seconds setted
	 *
	 * @example
	 * // Set 45 seconds to 1 September 2014 11:30:40:
	 * var result = setSeconds(new Date(2014, 8, 1, 11, 30, 40), 45)
	 * //=> Mon Sep 01 2014 11:30:45
	 */
	function setSeconds (dirtyDate, dirtySeconds) {
	  var date = parse_1(dirtyDate);
	  var seconds = Number(dirtySeconds);
	  date.setSeconds(seconds);
	  return date
	}

	var set_seconds = setSeconds;

	/**
	 * @category Year Helpers
	 * @summary Set the year to the given date.
	 *
	 * @description
	 * Set the year to the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} year - the year of the new date
	 * @returns {Date} the new date with the year setted
	 *
	 * @example
	 * // Set year 2013 to 1 September 2014:
	 * var result = setYear(new Date(2014, 8, 1), 2013)
	 * //=> Sun Sep 01 2013 00:00:00
	 */
	function setYear (dirtyDate, dirtyYear) {
	  var date = parse_1(dirtyDate);
	  var year = Number(dirtyYear);
	  date.setFullYear(year);
	  return date
	}

	var set_year = setYear;

	/**
	 * @category Month Helpers
	 * @summary Return the start of a month for the given date.
	 *
	 * @description
	 * Return the start of a month for the given date.
	 * The result will be in the local timezone.
	 *
	 * @param {Date|String|Number} date - the original date
	 * @returns {Date} the start of a month
	 *
	 * @example
	 * // The start of a month for 2 September 2014 11:55:00:
	 * var result = startOfMonth(new Date(2014, 8, 2, 11, 55, 0))
	 * //=> Mon Sep 01 2014 00:00:00
	 */
	function startOfMonth (dirtyDate) {
	  var date = parse_1(dirtyDate);
	  date.setDate(1);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var start_of_month = startOfMonth;

	/**
	 * @category Day Helpers
	 * @summary Return the start of today.
	 *
	 * @description
	 * Return the start of today.
	 *
	 * @returns {Date} the start of today
	 *
	 * @example
	 * // If today is 6 October 2014:
	 * var result = startOfToday()
	 * //=> Mon Oct 6 2014 00:00:00
	 */
	function startOfToday () {
	  return start_of_day(new Date())
	}

	var start_of_today = startOfToday;

	/**
	 * @category Day Helpers
	 * @summary Return the start of tomorrow.
	 *
	 * @description
	 * Return the start of tomorrow.
	 *
	 * @returns {Date} the start of tomorrow
	 *
	 * @example
	 * // If today is 6 October 2014:
	 * var result = startOfTomorrow()
	 * //=> Tue Oct 7 2014 00:00:00
	 */
	function startOfTomorrow () {
	  var now = new Date();
	  var year = now.getFullYear();
	  var month = now.getMonth();
	  var day = now.getDate();

	  var date = new Date(0);
	  date.setFullYear(year, month, day + 1);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var start_of_tomorrow = startOfTomorrow;

	/**
	 * @category Day Helpers
	 * @summary Return the start of yesterday.
	 *
	 * @description
	 * Return the start of yesterday.
	 *
	 * @returns {Date} the start of yesterday
	 *
	 * @example
	 * // If today is 6 October 2014:
	 * var result = startOfYesterday()
	 * //=> Sun Oct 5 2014 00:00:00
	 */
	function startOfYesterday () {
	  var now = new Date();
	  var year = now.getFullYear();
	  var month = now.getMonth();
	  var day = now.getDate();

	  var date = new Date(0);
	  date.setFullYear(year, month, day - 1);
	  date.setHours(0, 0, 0, 0);
	  return date
	}

	var start_of_yesterday = startOfYesterday;

	/**
	 * @category Day Helpers
	 * @summary Subtract the specified number of days from the given date.
	 *
	 * @description
	 * Subtract the specified number of days from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of days to be subtracted
	 * @returns {Date} the new date with the days subtracted
	 *
	 * @example
	 * // Subtract 10 days from 1 September 2014:
	 * var result = subDays(new Date(2014, 8, 1), 10)
	 * //=> Fri Aug 22 2014 00:00:00
	 */
	function subDays (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_days(dirtyDate, -amount)
	}

	var sub_days = subDays;

	/**
	 * @category Hour Helpers
	 * @summary Subtract the specified number of hours from the given date.
	 *
	 * @description
	 * Subtract the specified number of hours from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of hours to be subtracted
	 * @returns {Date} the new date with the hours subtracted
	 *
	 * @example
	 * // Subtract 2 hours from 11 July 2014 01:00:00:
	 * var result = subHours(new Date(2014, 6, 11, 1, 0), 2)
	 * //=> Thu Jul 10 2014 23:00:00
	 */
	function subHours (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_hours(dirtyDate, -amount)
	}

	var sub_hours = subHours;

	/**
	 * @category Millisecond Helpers
	 * @summary Subtract the specified number of milliseconds from the given date.
	 *
	 * @description
	 * Subtract the specified number of milliseconds from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of milliseconds to be subtracted
	 * @returns {Date} the new date with the milliseconds subtracted
	 *
	 * @example
	 * // Subtract 750 milliseconds from 10 July 2014 12:45:30.000:
	 * var result = subMilliseconds(new Date(2014, 6, 10, 12, 45, 30, 0), 750)
	 * //=> Thu Jul 10 2014 12:45:29.250
	 */
	function subMilliseconds (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_milliseconds(dirtyDate, -amount)
	}

	var sub_milliseconds = subMilliseconds;

	/**
	 * @category Minute Helpers
	 * @summary Subtract the specified number of minutes from the given date.
	 *
	 * @description
	 * Subtract the specified number of minutes from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of minutes to be subtracted
	 * @returns {Date} the new date with the mintues subtracted
	 *
	 * @example
	 * // Subtract 30 minutes from 10 July 2014 12:00:00:
	 * var result = subMinutes(new Date(2014, 6, 10, 12, 0), 30)
	 * //=> Thu Jul 10 2014 11:30:00
	 */
	function subMinutes (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_minutes(dirtyDate, -amount)
	}

	var sub_minutes = subMinutes;

	/**
	 * @category Month Helpers
	 * @summary Subtract the specified number of months from the given date.
	 *
	 * @description
	 * Subtract the specified number of months from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of months to be subtracted
	 * @returns {Date} the new date with the months subtracted
	 *
	 * @example
	 * // Subtract 5 months from 1 February 2015:
	 * var result = subMonths(new Date(2015, 1, 1), 5)
	 * //=> Mon Sep 01 2014 00:00:00
	 */
	function subMonths (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_months(dirtyDate, -amount)
	}

	var sub_months = subMonths;

	/**
	 * @category Quarter Helpers
	 * @summary Subtract the specified number of year quarters from the given date.
	 *
	 * @description
	 * Subtract the specified number of year quarters from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of quarters to be subtracted
	 * @returns {Date} the new date with the quarters subtracted
	 *
	 * @example
	 * // Subtract 3 quarters from 1 September 2014:
	 * var result = subQuarters(new Date(2014, 8, 1), 3)
	 * //=> Sun Dec 01 2013 00:00:00
	 */
	function subQuarters (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_quarters(dirtyDate, -amount)
	}

	var sub_quarters = subQuarters;

	/**
	 * @category Second Helpers
	 * @summary Subtract the specified number of seconds from the given date.
	 *
	 * @description
	 * Subtract the specified number of seconds from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of seconds to be subtracted
	 * @returns {Date} the new date with the seconds subtracted
	 *
	 * @example
	 * // Subtract 30 seconds from 10 July 2014 12:45:00:
	 * var result = subSeconds(new Date(2014, 6, 10, 12, 45, 0), 30)
	 * //=> Thu Jul 10 2014 12:44:30
	 */
	function subSeconds (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_seconds(dirtyDate, -amount)
	}

	var sub_seconds = subSeconds;

	/**
	 * @category Week Helpers
	 * @summary Subtract the specified number of weeks from the given date.
	 *
	 * @description
	 * Subtract the specified number of weeks from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of weeks to be subtracted
	 * @returns {Date} the new date with the weeks subtracted
	 *
	 * @example
	 * // Subtract 4 weeks from 1 September 2014:
	 * var result = subWeeks(new Date(2014, 8, 1), 4)
	 * //=> Mon Aug 04 2014 00:00:00
	 */
	function subWeeks (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_weeks(dirtyDate, -amount)
	}

	var sub_weeks = subWeeks;

	/**
	 * @category Year Helpers
	 * @summary Subtract the specified number of years from the given date.
	 *
	 * @description
	 * Subtract the specified number of years from the given date.
	 *
	 * @param {Date|String|Number} date - the date to be changed
	 * @param {Number} amount - the amount of years to be subtracted
	 * @returns {Date} the new date with the years subtracted
	 *
	 * @example
	 * // Subtract 5 years from 1 September 2014:
	 * var result = subYears(new Date(2014, 8, 1), 5)
	 * //=> Tue Sep 01 2009 00:00:00
	 */
	function subYears (dirtyDate, dirtyAmount) {
	  var amount = Number(dirtyAmount);
	  return add_years(dirtyDate, -amount)
	}

	var sub_years = subYears;

	var dateFns = {
	  addDays: add_days,
	  addHours: add_hours,
	  addISOYears: add_iso_years,
	  addMilliseconds: add_milliseconds,
	  addMinutes: add_minutes,
	  addMonths: add_months,
	  addQuarters: add_quarters,
	  addSeconds: add_seconds,
	  addWeeks: add_weeks,
	  addYears: add_years,
	  areRangesOverlapping: are_ranges_overlapping,
	  closestIndexTo: closest_index_to,
	  closestTo: closest_to,
	  compareAsc: compare_asc,
	  compareDesc: compare_desc,
	  differenceInCalendarDays: difference_in_calendar_days,
	  differenceInCalendarISOWeeks: difference_in_calendar_iso_weeks,
	  differenceInCalendarISOYears: difference_in_calendar_iso_years,
	  differenceInCalendarMonths: difference_in_calendar_months,
	  differenceInCalendarQuarters: difference_in_calendar_quarters,
	  differenceInCalendarWeeks: difference_in_calendar_weeks,
	  differenceInCalendarYears: difference_in_calendar_years,
	  differenceInDays: difference_in_days,
	  differenceInHours: difference_in_hours,
	  differenceInISOYears: difference_in_iso_years,
	  differenceInMilliseconds: difference_in_milliseconds,
	  differenceInMinutes: difference_in_minutes,
	  differenceInMonths: difference_in_months,
	  differenceInQuarters: difference_in_quarters,
	  differenceInSeconds: difference_in_seconds,
	  differenceInWeeks: difference_in_weeks,
	  differenceInYears: difference_in_years,
	  distanceInWords: distance_in_words,
	  distanceInWordsStrict: distance_in_words_strict,
	  distanceInWordsToNow: distance_in_words_to_now,
	  eachDay: each_day,
	  endOfDay: end_of_day,
	  endOfHour: end_of_hour,
	  endOfISOWeek: end_of_iso_week,
	  endOfISOYear: end_of_iso_year,
	  endOfMinute: end_of_minute,
	  endOfMonth: end_of_month,
	  endOfQuarter: end_of_quarter,
	  endOfSecond: end_of_second,
	  endOfToday: end_of_today,
	  endOfTomorrow: end_of_tomorrow,
	  endOfWeek: end_of_week,
	  endOfYear: end_of_year,
	  endOfYesterday: end_of_yesterday,
	  format: format_1,
	  getDate: get_date,
	  getDay: get_day,
	  getDayOfYear: get_day_of_year,
	  getDaysInMonth: get_days_in_month,
	  getDaysInYear: get_days_in_year,
	  getHours: get_hours,
	  getISODay: get_iso_day,
	  getISOWeek: get_iso_week,
	  getISOWeeksInYear: get_iso_weeks_in_year,
	  getISOYear: get_iso_year,
	  getMilliseconds: get_milliseconds,
	  getMinutes: get_minutes,
	  getMonth: get_month,
	  getOverlappingDaysInRanges: get_overlapping_days_in_ranges,
	  getQuarter: get_quarter,
	  getSeconds: get_seconds,
	  getTime: get_time,
	  getYear: get_year,
	  isAfter: is_after,
	  isBefore: is_before,
	  isDate: is_date,
	  isEqual: is_equal,
	  isFirstDayOfMonth: is_first_day_of_month,
	  isFriday: is_friday,
	  isFuture: is_future,
	  isLastDayOfMonth: is_last_day_of_month,
	  isLeapYear: is_leap_year,
	  isMonday: is_monday,
	  isPast: is_past,
	  isSameDay: is_same_day,
	  isSameHour: is_same_hour,
	  isSameISOWeek: is_same_iso_week,
	  isSameISOYear: is_same_iso_year,
	  isSameMinute: is_same_minute,
	  isSameMonth: is_same_month,
	  isSameQuarter: is_same_quarter,
	  isSameSecond: is_same_second,
	  isSameWeek: is_same_week,
	  isSameYear: is_same_year,
	  isSaturday: is_saturday,
	  isSunday: is_sunday,
	  isThisHour: is_this_hour,
	  isThisISOWeek: is_this_iso_week,
	  isThisISOYear: is_this_iso_year,
	  isThisMinute: is_this_minute,
	  isThisMonth: is_this_month,
	  isThisQuarter: is_this_quarter,
	  isThisSecond: is_this_second,
	  isThisWeek: is_this_week,
	  isThisYear: is_this_year,
	  isThursday: is_thursday,
	  isToday: is_today,
	  isTomorrow: is_tomorrow,
	  isTuesday: is_tuesday,
	  isValid: is_valid,
	  isWednesday: is_wednesday,
	  isWeekend: is_weekend,
	  isWithinRange: is_within_range,
	  isYesterday: is_yesterday,
	  lastDayOfISOWeek: last_day_of_iso_week,
	  lastDayOfISOYear: last_day_of_iso_year,
	  lastDayOfMonth: last_day_of_month,
	  lastDayOfQuarter: last_day_of_quarter,
	  lastDayOfWeek: last_day_of_week,
	  lastDayOfYear: last_day_of_year,
	  max: max_1,
	  min: min_1,
	  parse: parse_1,
	  setDate: set_date,
	  setDay: set_day,
	  setDayOfYear: set_day_of_year,
	  setHours: set_hours,
	  setISODay: set_iso_day,
	  setISOWeek: set_iso_week,
	  setISOYear: set_iso_year,
	  setMilliseconds: set_milliseconds,
	  setMinutes: set_minutes,
	  setMonth: set_month,
	  setQuarter: set_quarter,
	  setSeconds: set_seconds,
	  setYear: set_year,
	  startOfDay: start_of_day,
	  startOfHour: start_of_hour,
	  startOfISOWeek: start_of_iso_week,
	  startOfISOYear: start_of_iso_year,
	  startOfMinute: start_of_minute,
	  startOfMonth: start_of_month,
	  startOfQuarter: start_of_quarter,
	  startOfSecond: start_of_second,
	  startOfToday: start_of_today,
	  startOfTomorrow: start_of_tomorrow,
	  startOfWeek: start_of_week,
	  startOfYear: start_of_year,
	  startOfYesterday: start_of_yesterday,
	  subDays: sub_days,
	  subHours: sub_hours,
	  subISOYears: sub_iso_years,
	  subMilliseconds: sub_milliseconds,
	  subMinutes: sub_minutes,
	  subMonths: sub_months,
	  subQuarters: sub_quarters,
	  subSeconds: sub_seconds,
	  subWeeks: sub_weeks,
	  subYears: sub_years
	};

	const Equals = Symbol("Mint.Equals");

	const compare = (a, b) => {
	  if (a != null && a != undefined && a[Equals]) {
	    return a[Equals](b);
	  } else {
	    if (b != null && b != undefined && b[Equals]) {
	      return b[Equals](a);
	    } else {
	      console.warn(`Could not compare "${a}" with "${b}" comparing with ===`);
	      return a === b;
	    }
	  }
	};

	class Record {
	  constructor(data) {
	    for (let key in data) {
	      this[key] = data[key];
	    }
	  }

	  [Equals](other) {
	    if (!(other instanceof Record)) {
	      return false;
	    }

	    if (Object.keys(this).length !== Object.keys(other).length) {
	      return false;
	    }

	    for (let key in this) {
	      if (!compare(other[key], this[key])) {
	        return false;
	      }
	    }

	    return true;
	  }
	}

	const create = (Decoder, enums) => mappings => {
	  const item = class extends Record {};
	  const {ok, err} = enums;

	  item.mappings = mappings;
	  item.decode = _input => {
	    const object = {};

	    for (let key in mappings) {
	      const [otherKey, decoder] = mappings[key];
	      const result = Decoder.field(otherKey, decoder)(_input);

	      if (result instanceof err) {
	        return result;
	      }

	      object[key] = result._0;
	    }

	    return new ok(new item(object));
	  };

	  return item;
	};

	const update = (data, new_data) => {
	  return new Record(Object.assign(Object.create(null), data, new_data));
	};

	const navigate = (url, dispatch = true) => {
	  if (window.location.pathname !== url) {
	    window.history.pushState({}, "", url);

	    if (dispatch) {
	      dispatchEvent(new PopStateEvent("popstate"));
	    } else {
	    }
	  }
	};

	const insertStyles = styles => {
	  let style = document.createElement("style");
	  document.head.appendChild(style);
	  style.innerHTML = styles;
	};

	const at = (enums) => (array, index) => {
	  const {just, nothing} = enums;

	  if (array.length >= index + 1 && index >= 0) {
	    return new just(array[index]);
	  } else {
	    return new nothing();
	  }
	};

	const normalizeEvent = event => {
	  return new Proxy(event, {
	    get: function(obj, prop) {
	      if (prop in obj) {
	        return obj[prop];
	      } else {
	        switch (prop) {
	          // onCopy onCut onPaste
	          case "clipboardData":
	            return new DataTransfer();

	          // onCompositionEnd onCompositionStart onCompositionUpdate
	          case "data":
	            return "";

	          // onKeyDown onKeyPress onKeyUp
	          case "altKey":
	            return false;
	          case "charCode":
	            return -1;
	          case "ctrlKey":
	            return false;
	          case "key":
	            return "";
	          case "keyCode":
	            return -1;
	          case "locale":
	            return "";
	          case "location":
	            return -1;
	          case "metaKey":
	            return false;
	          case "repeat":
	            return false;
	          case "shiftKey":
	            return false;
	          case "which":
	            return -1;

	          // onClick onContextMenu onDoubleClick onDrag onDragEnd
	          // onDragEnter onDragExit onDragLeave onDragOver onDragStart
	          // onDrop onMouseDown onMouseEnter onMouseLeave
	          // onMouseMove onMouseOut onMouseOver onMouseUp
	          case "button":
	            return -1;
	          case "buttons":
	            return -1;
	          case "clientX":
	            return -1;
	          case "clientY":
	            return -1;
	          case "pageX":
	            return -1;
	          case "pageY":
	            return -1;
	          case "screenX":
	            return -1;
	          case "screenY":
	            return -1;

	          // onScroll
	          case "detail":
	            return -1;

	          // onWheel
	          case "deltaMode":
	            return -1;
	          case "deltaX":
	            return -1;
	          case "deltaY":
	            return -1;
	          case "deltaZ":
	            return -1;

	          // onAnimationStart onAnimationEnd onAnimationIteration
	          case "animationName":
	            return "";
	          case "pseudoElement":
	            return "";
	          case "elapsedTime":
	            return -1;

	          // onTransitionEnd
	          case "propertyName":
	            return "";

	          default:
	            return undefined;
	        }
	      }
	    }
	  });
	};

	const bindFunctions = (target, exclude) => {
	  const descriptors = Object.getOwnPropertyDescriptors(
	    Reflect.getPrototypeOf(target)
	  );

	  for (let key in descriptors) {
	    if (exclude && exclude[key]) {
	      continue;
	    }
	    const value = descriptors[key].value;
	    if (typeof value !== "function") {
	      continue;
	    }
	    target[key] = value.bind(target);
	  }
	};

	const array = function() {
	  let items = Array.from(arguments);
	  if (Array.isArray(items[0]) && items.length === 1) {
	    return items[0];
	  } else {
	    return items;
	  }
	};

	const style = function(items) {
	  const result = {};

	  for (let item of items) {
	    if (typeof item === "string") {
	      item.split(";").forEach(prop => {
	        const [key, value] = prop.split(":");

	        if (key && value) {
	          result[key] = value;
	        }
	      });
	    } else if (item instanceof Map) {
	      for (let [key, value] of item) {
	        result[key] = value;
	      }
	    } else {
	      for (let key in item) {
	        result[key] = item[key];
	      }
	    }
	  }

	  return result;
	};

	class TestContext {
	  constructor(subject, teardown) {
	    this.teardown = teardown;
	    this.subject = subject;
	    this.steps = [];
	  }

	  async run() {
	    let result;

	    try {
	      result = await new Promise(this.next.bind(this));
	    } finally {
	      this.teardown && this.teardown();
	    }

	    return result;
	  }

	  async next(resolve, reject) {
	    requestAnimationFrame(async () => {
	      let step = this.steps.shift();

	      if (step) {
	        try {
	          this.subject = await step(this.subject);
	        } catch (error) {
	          return reject(error);
	        }
	      }

	      if (this.steps.length) {
	        this.next(resolve, reject);
	      } else {
	        resolve(this.subject);
	      }
	    });
	  }

	  step(proc) {
	    this.steps.push(proc);
	    return this;
	  }
	}

	const excludedMethods = [
	  "componentWillMount",
	  "UNSAFE_componentWillMount",
	  "render",
	  "getSnapshotBeforeUpdate",
	  "componentDidMount",
	  "componentWillReceiveProps",
	  "UNSAFE_componentWillReceiveProps",
	  "shouldComponentUpdate",
	  "componentWillUpdate",
	  "UNSAFE_componentWillUpdate",
	  "componentDidUpdate",
	  "componentWillUnmount",
	  "componentDidCatch",
	  "setState",
	  "forceUpdate",
	  "constructor"
	];

	class Component extends react.PureComponent {
	  constructor(props) {
	    super(props);
	    bindFunctions(this, excludedMethods);
	  }

	  _d(object) {
	    const properties = {};

	    Object.keys(object).forEach(item => {
	      const [foreign, value] = object[item];
	      const key = foreign || item;

	      properties[item] = {
	        get: () => {
	          return key in this.props ? this.props[key] : value;
	        }
	      };
	    });

	    Object.defineProperties(this, properties);
	  }
	}

	class Provider {
	  constructor() {
	    this.subscriptions = new Map();
	  }

	  _subscribe(owner, object) {
	    if (this.subscriptions.has(owner)) {
	      return;
	    }
	    this.subscriptions.set(owner, object);
	    this._update();
	  }

	  _unsubscribe(owner) {
	    if (!this.subscriptions.has(owner)) {
	      return;
	    }
	    this.subscriptions.delete(owner);
	    this._update();
	  }

	  _update() {
	    if (this.subscriptions.size == 0) {
	      this.detach();
	    } else {
	      this.attach();
	    }
	  }

	  get _subscriptions() {
	    let array = [];
	    for (let item of this.subscriptions.values()) {
	      array.push(item);
	    }
	    return array;
	  }

	  attach() {}

	  detach() {}
	}

	var compiledGrammar = createCommonjsModule(function (module, exports) {
	/* parser generated by jison 0.4.17 */
	/*
	  Returns a Parser object of the following structure:

	  Parser: {
	    yy: {}
	  }

	  Parser.prototype: {
	    yy: {},
	    trace: function(),
	    symbols_: {associative list: name ==> number},
	    terminals_: {associative list: number ==> name},
	    productions_: [...],
	    performAction: function anonymous(yytext, yyleng, yylineno, yy, yystate, $$, _$),
	    table: [...],
	    defaultActions: {...},
	    parseError: function(str, hash),
	    parse: function(input),

	    lexer: {
	        EOF: 1,
	        parseError: function(str, hash),
	        setInput: function(input),
	        input: function(),
	        unput: function(str),
	        more: function(),
	        less: function(n),
	        pastInput: function(),
	        upcomingInput: function(),
	        showPosition: function(),
	        test_match: function(regex_match_array, rule_index),
	        next: function(),
	        lex: function(),
	        begin: function(condition),
	        popState: function(),
	        _currentRules: function(),
	        topState: function(),
	        pushState: function(condition),

	        options: {
	            ranges: boolean           (optional: true ==> token location info will include a .range[] member)
	            flex: boolean             (optional: true ==> flex-like lexing behaviour where the rules are tested exhaustively to find the longest match)
	            backtrack_lexer: boolean  (optional: true ==> lexer regexes are tested in order and for each matching regex the action code is invoked; the lexer terminates the scan when a token is returned by the action code)
	        },

	        performAction: function(yy, yy_, $avoiding_name_collisions, YY_START),
	        rules: [...],
	        conditions: {associative list: name ==> set},
	    }
	  }


	  token location info (@$, _$, etc.): {
	    first_line: n,
	    last_line: n,
	    first_column: n,
	    last_column: n,
	    range: [start_number, end_number]       (where the numbers are indexes into the input string, regular zero-based)
	  }


	  the parseError function receives a 'hash' object with these members for lexer and parser errors: {
	    text:        (matched text)
	    token:       (the produced terminal token, if any)
	    line:        (yylineno)
	  }
	  while parser (grammar) errors will also provide these members, i.e. parser errors deliver a superset of attributes: {
	    loc:         (yylloc)
	    expected:    (string describing the set of expected tokens)
	    recoverable: (boolean: TRUE when the parser has a error recovery rule available for this particular error)
	  }
	*/
	var parser = (function(){
	var o=function(k,v,o,l){for(o=o||{}, l=k.length;l--;o[k[l]]=v);return o},$V0=[1,9],$V1=[1,10],$V2=[1,11],$V3=[1,12],$V4=[5,11,12,13,14,15];
	var parser = {trace: function trace() { },
	yy: {},
	symbols_: {"error":2,"root":3,"expressions":4,"EOF":5,"expression":6,"optional":7,"literal":8,"splat":9,"param":10,"(":11,")":12,"LITERAL":13,"SPLAT":14,"PARAM":15,"$accept":0,"$end":1},
	terminals_: {2:"error",5:"EOF",11:"(",12:")",13:"LITERAL",14:"SPLAT",15:"PARAM"},
	productions_: [0,[3,2],[3,1],[4,2],[4,1],[6,1],[6,1],[6,1],[6,1],[7,3],[8,1],[9,1],[10,1]],
	performAction: function anonymous(yytext, yyleng, yylineno, yy, yystate /* action[1] */, $$ /* vstack */, _$ /* lstack */) {
	/* this == yyval */

	var $0 = $$.length - 1;
	switch (yystate) {
	case 1:
	return new yy.Root({},[$$[$0-1]])
	break;
	case 2:
	return new yy.Root({},[new yy.Literal({value: ''})])
	break;
	case 3:
	this.$ = new yy.Concat({},[$$[$0-1],$$[$0]]);
	break;
	case 4: case 5:
	this.$ = $$[$0];
	break;
	case 6:
	this.$ = new yy.Literal({value: $$[$0]});
	break;
	case 7:
	this.$ = new yy.Splat({name: $$[$0]});
	break;
	case 8:
	this.$ = new yy.Param({name: $$[$0]});
	break;
	case 9:
	this.$ = new yy.Optional({},[$$[$0-1]]);
	break;
	case 10:
	this.$ = yytext;
	break;
	case 11: case 12:
	this.$ = yytext.slice(1);
	break;
	}
	},
	table: [{3:1,4:2,5:[1,3],6:4,7:5,8:6,9:7,10:8,11:$V0,13:$V1,14:$V2,15:$V3},{1:[3]},{5:[1,13],6:14,7:5,8:6,9:7,10:8,11:$V0,13:$V1,14:$V2,15:$V3},{1:[2,2]},o($V4,[2,4]),o($V4,[2,5]),o($V4,[2,6]),o($V4,[2,7]),o($V4,[2,8]),{4:15,6:4,7:5,8:6,9:7,10:8,11:$V0,13:$V1,14:$V2,15:$V3},o($V4,[2,10]),o($V4,[2,11]),o($V4,[2,12]),{1:[2,1]},o($V4,[2,3]),{6:14,7:5,8:6,9:7,10:8,11:$V0,12:[1,16],13:$V1,14:$V2,15:$V3},o($V4,[2,9])],
	defaultActions: {3:[2,2],13:[2,1]},
	parseError: function parseError(str, hash) {
	    if (hash.recoverable) {
	        this.trace(str);
	    } else {
	        function _parseError (msg, hash) {
	            this.message = msg;
	            this.hash = hash;
	        }
	        _parseError.prototype = Error;

	        throw new _parseError(str, hash);
	    }
	},
	parse: function parse(input) {
	    var self = this, stack = [0], vstack = [null], lstack = [], table = this.table, yytext = '', yylineno = 0, yyleng = 0, TERROR = 2, EOF = 1;
	    var args = lstack.slice.call(arguments, 1);
	    var lexer = Object.create(this.lexer);
	    var sharedState = { yy: {} };
	    for (var k in this.yy) {
	        if (Object.prototype.hasOwnProperty.call(this.yy, k)) {
	            sharedState.yy[k] = this.yy[k];
	        }
	    }
	    lexer.setInput(input, sharedState.yy);
	    sharedState.yy.lexer = lexer;
	    sharedState.yy.parser = this;
	    if (typeof lexer.yylloc == 'undefined') {
	        lexer.yylloc = {};
	    }
	    var yyloc = lexer.yylloc;
	    lstack.push(yyloc);
	    var ranges = lexer.options && lexer.options.ranges;
	    if (typeof sharedState.yy.parseError === 'function') {
	        this.parseError = sharedState.yy.parseError;
	    } else {
	        this.parseError = Object.getPrototypeOf(this).parseError;
	    }
	    _token_stack:
	        var lex = function () {
	            var token;
	            token = lexer.lex() || EOF;
	            if (typeof token !== 'number') {
	                token = self.symbols_[token] || token;
	            }
	            return token;
	        };
	    var symbol, preErrorSymbol, state, action, r, yyval = {}, p, len, newState, expected;
	    while (true) {
	        state = stack[stack.length - 1];
	        if (this.defaultActions[state]) {
	            action = this.defaultActions[state];
	        } else {
	            if (symbol === null || typeof symbol == 'undefined') {
	                symbol = lex();
	            }
	            action = table[state] && table[state][symbol];
	        }
	                    if (typeof action === 'undefined' || !action.length || !action[0]) {
	                var errStr = '';
	                expected = [];
	                for (p in table[state]) {
	                    if (this.terminals_[p] && p > TERROR) {
	                        expected.push('\'' + this.terminals_[p] + '\'');
	                    }
	                }
	                if (lexer.showPosition) {
	                    errStr = 'Parse error on line ' + (yylineno + 1) + ':\n' + lexer.showPosition() + '\nExpecting ' + expected.join(', ') + ', got \'' + (this.terminals_[symbol] || symbol) + '\'';
	                } else {
	                    errStr = 'Parse error on line ' + (yylineno + 1) + ': Unexpected ' + (symbol == EOF ? 'end of input' : '\'' + (this.terminals_[symbol] || symbol) + '\'');
	                }
	                this.parseError(errStr, {
	                    text: lexer.match,
	                    token: this.terminals_[symbol] || symbol,
	                    line: lexer.yylineno,
	                    loc: yyloc,
	                    expected: expected
	                });
	            }
	        if (action[0] instanceof Array && action.length > 1) {
	            throw new Error('Parse Error: multiple actions possible at state: ' + state + ', token: ' + symbol);
	        }
	        switch (action[0]) {
	        case 1:
	            stack.push(symbol);
	            vstack.push(lexer.yytext);
	            lstack.push(lexer.yylloc);
	            stack.push(action[1]);
	            symbol = null;
	            if (!preErrorSymbol) {
	                yyleng = lexer.yyleng;
	                yytext = lexer.yytext;
	                yylineno = lexer.yylineno;
	                yyloc = lexer.yylloc;
	            } else {
	                symbol = preErrorSymbol;
	                preErrorSymbol = null;
	            }
	            break;
	        case 2:
	            len = this.productions_[action[1]][1];
	            yyval.$ = vstack[vstack.length - len];
	            yyval._$ = {
	                first_line: lstack[lstack.length - (len || 1)].first_line,
	                last_line: lstack[lstack.length - 1].last_line,
	                first_column: lstack[lstack.length - (len || 1)].first_column,
	                last_column: lstack[lstack.length - 1].last_column
	            };
	            if (ranges) {
	                yyval._$.range = [
	                    lstack[lstack.length - (len || 1)].range[0],
	                    lstack[lstack.length - 1].range[1]
	                ];
	            }
	            r = this.performAction.apply(yyval, [
	                yytext,
	                yyleng,
	                yylineno,
	                sharedState.yy,
	                action[1],
	                vstack,
	                lstack
	            ].concat(args));
	            if (typeof r !== 'undefined') {
	                return r;
	            }
	            if (len) {
	                stack = stack.slice(0, -1 * len * 2);
	                vstack = vstack.slice(0, -1 * len);
	                lstack = lstack.slice(0, -1 * len);
	            }
	            stack.push(this.productions_[action[1]][0]);
	            vstack.push(yyval.$);
	            lstack.push(yyval._$);
	            newState = table[stack[stack.length - 2]][stack[stack.length - 1]];
	            stack.push(newState);
	            break;
	        case 3:
	            return true;
	        }
	    }
	    return true;
	}};
	/* generated by jison-lex 0.3.4 */
	var lexer = (function(){
	var lexer = ({

	EOF:1,

	parseError:function parseError(str, hash) {
	        if (this.yy.parser) {
	            this.yy.parser.parseError(str, hash);
	        } else {
	            throw new Error(str);
	        }
	    },

	// resets the lexer, sets new input
	setInput:function (input, yy) {
	        this.yy = yy || this.yy || {};
	        this._input = input;
	        this._more = this._backtrack = this.done = false;
	        this.yylineno = this.yyleng = 0;
	        this.yytext = this.matched = this.match = '';
	        this.conditionStack = ['INITIAL'];
	        this.yylloc = {
	            first_line: 1,
	            first_column: 0,
	            last_line: 1,
	            last_column: 0
	        };
	        if (this.options.ranges) {
	            this.yylloc.range = [0,0];
	        }
	        this.offset = 0;
	        return this;
	    },

	// consumes and returns one char from the input
	input:function () {
	        var ch = this._input[0];
	        this.yytext += ch;
	        this.yyleng++;
	        this.offset++;
	        this.match += ch;
	        this.matched += ch;
	        var lines = ch.match(/(?:\r\n?|\n).*/g);
	        if (lines) {
	            this.yylineno++;
	            this.yylloc.last_line++;
	        } else {
	            this.yylloc.last_column++;
	        }
	        if (this.options.ranges) {
	            this.yylloc.range[1]++;
	        }

	        this._input = this._input.slice(1);
	        return ch;
	    },

	// unshifts one char (or a string) into the input
	unput:function (ch) {
	        var len = ch.length;
	        var lines = ch.split(/(?:\r\n?|\n)/g);

	        this._input = ch + this._input;
	        this.yytext = this.yytext.substr(0, this.yytext.length - len);
	        //this.yyleng -= len;
	        this.offset -= len;
	        var oldLines = this.match.split(/(?:\r\n?|\n)/g);
	        this.match = this.match.substr(0, this.match.length - 1);
	        this.matched = this.matched.substr(0, this.matched.length - 1);

	        if (lines.length - 1) {
	            this.yylineno -= lines.length - 1;
	        }
	        var r = this.yylloc.range;

	        this.yylloc = {
	            first_line: this.yylloc.first_line,
	            last_line: this.yylineno + 1,
	            first_column: this.yylloc.first_column,
	            last_column: lines ?
	                (lines.length === oldLines.length ? this.yylloc.first_column : 0)
	                 + oldLines[oldLines.length - lines.length].length - lines[0].length :
	              this.yylloc.first_column - len
	        };

	        if (this.options.ranges) {
	            this.yylloc.range = [r[0], r[0] + this.yyleng - len];
	        }
	        this.yyleng = this.yytext.length;
	        return this;
	    },

	// When called from action, caches matched text and appends it on next action
	more:function () {
	        this._more = true;
	        return this;
	    },

	// When called from action, signals the lexer that this rule fails to match the input, so the next matching rule (regex) should be tested instead.
	reject:function () {
	        if (this.options.backtrack_lexer) {
	            this._backtrack = true;
	        } else {
	            return this.parseError('Lexical error on line ' + (this.yylineno + 1) + '. You can only invoke reject() in the lexer when the lexer is of the backtracking persuasion (options.backtrack_lexer = true).\n' + this.showPosition(), {
	                text: "",
	                token: null,
	                line: this.yylineno
	            });

	        }
	        return this;
	    },

	// retain first n characters of the match
	less:function (n) {
	        this.unput(this.match.slice(n));
	    },

	// displays already matched input, i.e. for error messages
	pastInput:function () {
	        var past = this.matched.substr(0, this.matched.length - this.match.length);
	        return (past.length > 20 ? '...':'') + past.substr(-20).replace(/\n/g, "");
	    },

	// displays upcoming input, i.e. for error messages
	upcomingInput:function () {
	        var next = this.match;
	        if (next.length < 20) {
	            next += this._input.substr(0, 20-next.length);
	        }
	        return (next.substr(0,20) + (next.length > 20 ? '...' : '')).replace(/\n/g, "");
	    },

	// displays the character position where the lexing error occurred, i.e. for error messages
	showPosition:function () {
	        var pre = this.pastInput();
	        var c = new Array(pre.length + 1).join("-");
	        return pre + this.upcomingInput() + "\n" + c + "^";
	    },

	// test the lexed token: return FALSE when not a match, otherwise return token
	test_match:function (match, indexed_rule) {
	        var token,
	            lines,
	            backup;

	        if (this.options.backtrack_lexer) {
	            // save context
	            backup = {
	                yylineno: this.yylineno,
	                yylloc: {
	                    first_line: this.yylloc.first_line,
	                    last_line: this.last_line,
	                    first_column: this.yylloc.first_column,
	                    last_column: this.yylloc.last_column
	                },
	                yytext: this.yytext,
	                match: this.match,
	                matches: this.matches,
	                matched: this.matched,
	                yyleng: this.yyleng,
	                offset: this.offset,
	                _more: this._more,
	                _input: this._input,
	                yy: this.yy,
	                conditionStack: this.conditionStack.slice(0),
	                done: this.done
	            };
	            if (this.options.ranges) {
	                backup.yylloc.range = this.yylloc.range.slice(0);
	            }
	        }

	        lines = match[0].match(/(?:\r\n?|\n).*/g);
	        if (lines) {
	            this.yylineno += lines.length;
	        }
	        this.yylloc = {
	            first_line: this.yylloc.last_line,
	            last_line: this.yylineno + 1,
	            first_column: this.yylloc.last_column,
	            last_column: lines ?
	                         lines[lines.length - 1].length - lines[lines.length - 1].match(/\r?\n?/)[0].length :
	                         this.yylloc.last_column + match[0].length
	        };
	        this.yytext += match[0];
	        this.match += match[0];
	        this.matches = match;
	        this.yyleng = this.yytext.length;
	        if (this.options.ranges) {
	            this.yylloc.range = [this.offset, this.offset += this.yyleng];
	        }
	        this._more = false;
	        this._backtrack = false;
	        this._input = this._input.slice(match[0].length);
	        this.matched += match[0];
	        token = this.performAction.call(this, this.yy, this, indexed_rule, this.conditionStack[this.conditionStack.length - 1]);
	        if (this.done && this._input) {
	            this.done = false;
	        }
	        if (token) {
	            return token;
	        } else if (this._backtrack) {
	            // recover context
	            for (var k in backup) {
	                this[k] = backup[k];
	            }
	            return false; // rule action called reject() implying the next rule should be tested instead.
	        }
	        return false;
	    },

	// return next match in input
	next:function () {
	        if (this.done) {
	            return this.EOF;
	        }
	        if (!this._input) {
	            this.done = true;
	        }

	        var token,
	            match,
	            tempMatch,
	            index;
	        if (!this._more) {
	            this.yytext = '';
	            this.match = '';
	        }
	        var rules = this._currentRules();
	        for (var i = 0; i < rules.length; i++) {
	            tempMatch = this._input.match(this.rules[rules[i]]);
	            if (tempMatch && (!match || tempMatch[0].length > match[0].length)) {
	                match = tempMatch;
	                index = i;
	                if (this.options.backtrack_lexer) {
	                    token = this.test_match(tempMatch, rules[i]);
	                    if (token !== false) {
	                        return token;
	                    } else if (this._backtrack) {
	                        match = false;
	                        continue; // rule action called reject() implying a rule MISmatch.
	                    } else {
	                        // else: this is a lexer rule which consumes input without producing a token (e.g. whitespace)
	                        return false;
	                    }
	                } else if (!this.options.flex) {
	                    break;
	                }
	            }
	        }
	        if (match) {
	            token = this.test_match(match, rules[index]);
	            if (token !== false) {
	                return token;
	            }
	            // else: this is a lexer rule which consumes input without producing a token (e.g. whitespace)
	            return false;
	        }
	        if (this._input === "") {
	            return this.EOF;
	        } else {
	            return this.parseError('Lexical error on line ' + (this.yylineno + 1) + '. Unrecognized text.\n' + this.showPosition(), {
	                text: "",
	                token: null,
	                line: this.yylineno
	            });
	        }
	    },

	// return next match that has a token
	lex:function lex() {
	        var r = this.next();
	        if (r) {
	            return r;
	        } else {
	            return this.lex();
	        }
	    },

	// activates a new lexer condition state (pushes the new lexer condition state onto the condition stack)
	begin:function begin(condition) {
	        this.conditionStack.push(condition);
	    },

	// pop the previously active lexer condition state off the condition stack
	popState:function popState() {
	        var n = this.conditionStack.length - 1;
	        if (n > 0) {
	            return this.conditionStack.pop();
	        } else {
	            return this.conditionStack[0];
	        }
	    },

	// produce the lexer rule set which is active for the currently active lexer condition state
	_currentRules:function _currentRules() {
	        if (this.conditionStack.length && this.conditionStack[this.conditionStack.length - 1]) {
	            return this.conditions[this.conditionStack[this.conditionStack.length - 1]].rules;
	        } else {
	            return this.conditions["INITIAL"].rules;
	        }
	    },

	// return the currently active lexer condition state; when an index argument is provided it produces the N-th previous condition state, if available
	topState:function topState(n) {
	        n = this.conditionStack.length - 1 - Math.abs(n || 0);
	        if (n >= 0) {
	            return this.conditionStack[n];
	        } else {
	            return "INITIAL";
	        }
	    },

	// alias for begin(condition)
	pushState:function pushState(condition) {
	        this.begin(condition);
	    },

	// return the number of states currently on the stack
	stateStackSize:function stateStackSize() {
	        return this.conditionStack.length;
	    },
	options: {},
	performAction: function anonymous(yy,yy_,$avoiding_name_collisions,YY_START) {
	switch($avoiding_name_collisions) {
	case 0:return "(";
	break;
	case 1:return ")";
	break;
	case 2:return "SPLAT";
	break;
	case 3:return "PARAM";
	break;
	case 4:return "LITERAL";
	break;
	case 5:return "LITERAL";
	break;
	case 6:return "EOF";
	break;
	}
	},
	rules: [/^(?:\()/,/^(?:\))/,/^(?:\*+\w+)/,/^(?::+\w+)/,/^(?:[\w%\-~\n]+)/,/^(?:.)/,/^(?:$)/],
	conditions: {"INITIAL":{"rules":[0,1,2,3,4,5,6],"inclusive":true}}
	});
	return lexer;
	})();
	parser.lexer = lexer;
	function Parser () {
	  this.yy = {};
	}
	Parser.prototype = parser;parser.Parser = Parser;
	return new Parser;
	})();


	if (typeof commonjsRequire !== 'undefined' && 'object' !== 'undefined') {
	exports.parser = parser;
	exports.Parser = parser.Parser;
	exports.parse = function () { return parser.parse.apply(parser, arguments); };
	}
	});
	var compiledGrammar_1 = compiledGrammar.parser;
	var compiledGrammar_2 = compiledGrammar.Parser;
	var compiledGrammar_3 = compiledGrammar.parse;

	/** @module route/nodes */


	/**
	 * Create a node for use with the parser, giving it a constructor that takes
	 * props, children, and returns an object with props, children, and a
	 * displayName.
	 * @param  {String} displayName The display name for the node
	 * @return {{displayName: string, props: Object, children: Array}}
	 */
	function createNode(displayName) {
	  return function(props, children) {
	    return {
	      displayName: displayName,
	      props: props,
	      children: children || []
	    };
	  };
	}

	var nodes = {
	  Root: createNode('Root'),
	  Concat: createNode('Concat'),
	  Literal: createNode('Literal'),
	  Splat: createNode('Splat'),
	  Param: createNode('Param'),
	  Optional: createNode('Optional')
	};

	/** Wrap the compiled parser with the context to create node objects */
	var parser = compiledGrammar.parser;
	parser.yy = nodes;
	var parser_1 = parser;

	/**
	 * @module route/visitors/create_visitor
	 */

	var nodeTypes = Object.keys(nodes);

	/**
	 * Helper for creating visitors. Take an object of node name to handler
	 * mappings, returns an object with a "visit" method that can be called
	 * @param  {Object.<string,function(node,context)>} handlers A mapping of node
	 * type to visitor functions
	 * @return {{visit: function(node,context)}}  A visitor object with a "visit"
	 * method that can be called on a node with a context
	 */
	function createVisitor(handlers) {
	  nodeTypes.forEach(function(nodeType) {
	    if( typeof handlers[nodeType] === 'undefined') {
	      throw new Error('No handler defined for ' + nodeType.displayName);
	    }

	  });

	  return {
	    /**
	     * Call the given handler for this node type
	     * @param  {Object} node    the AST node
	     * @param  {Object} context context to pass through to handlers
	     * @return {Object}
	     */
	    visit: function(node, context) {
	      return this.handlers[node.displayName].call(this,node, context);
	    },
	    handlers: handlers
	  };
	}

	var create_visitor = createVisitor;

	var escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g;

	/**
	 * @class
	 * @private
	 */
	function Matcher(options) {
	  this.captures = options.captures;
	  this.re = options.re;
	}

	/**
	 * Try matching a path against the generated regular expression
	 * @param  {String} path The path to try to match
	 * @return {Object|false}      matched parameters or false
	 */
	Matcher.prototype.match = function (path) {
	  var match = this.re.exec(path),
	      matchParams = {};

	  if( !match ) {
	    return;
	  }

	  this.captures.forEach( function(capture, i) {
	    if( typeof match[i+1] === 'undefined' ) {
	      matchParams[capture] = undefined;
	    }
	    else {
	      matchParams[capture] = decodeURIComponent(match[i+1]);
	    }
	  });

	  return matchParams;
	};

	/**
	 * Visitor for the AST to create a regular expression matcher
	 * @class RegexpVisitor
	 * @borrows Visitor-visit
	 */
	var RegexpVisitor = create_visitor({
	  'Concat': function(node) {
	    return node.children
	      .reduce(
	        function(memo, child) {
	          var childResult = this.visit(child);
	          return {
	            re: memo.re + childResult.re,
	            captures: memo.captures.concat(childResult.captures)
	          };
	        }.bind(this),
	        {re: '', captures: []}
	      );
	  },
	  'Literal': function(node) {
	    return {
	      re: node.props.value.replace(escapeRegExp, '\\$&'),
	      captures: []
	    };
	  },

	  'Splat': function(node) {
	    return {
	      re: '([^?]*?)',
	      captures: [node.props.name]
	    };
	  },

	  'Param': function(node) {
	    return {
	      re: '([^\\/\\?]+)',
	      captures: [node.props.name]
	    };
	  },

	  'Optional': function(node) {
	    var child = this.visit(node.children[0]);
	    return {
	      re: '(?:' + child.re + ')?',
	      captures: child.captures
	    };
	  },

	  'Root': function(node) {
	    var childResult = this.visit(node.children[0]);
	    return new Matcher({
	      re: new RegExp('^' + childResult.re + '(?=\\?|$)' ),
	      captures: childResult.captures
	    });
	  }
	});

	var regexp = RegexpVisitor;

	/**
	 * Visitor for the AST to construct a path with filled in parameters
	 * @class ReverseVisitor
	 * @borrows Visitor-visit
	 */
	var ReverseVisitor = create_visitor({
	  'Concat': function(node, context) {
	    var childResults =  node.children
	      .map( function(child) {
	        return this.visit(child,context);
	      }.bind(this));

	    if( childResults.some(function(c) { return c === false; }) ) {
	      return false;
	    }
	    else {
	      return childResults.join('');
	    }
	  },

	  'Literal': function(node) {
	    return decodeURI(node.props.value);
	  },

	  'Splat': function(node, context) {
	    if( context[node.props.name] ) {
	      return context[node.props.name];
	    }
	    else {
	      return false;
	    }
	  },

	  'Param': function(node, context) {
	    if( context[node.props.name] ) {
	      return context[node.props.name];
	    }
	    else {
	      return false;
	    }
	  },

	  'Optional': function(node, context) {
	    var childResult = this.visit(node.children[0], context);
	    if( childResult ) {
	      return childResult;
	    }
	    else {
	      return '';
	    }
	  },

	  'Root': function(node, context) {
	    context = context || {};
	    var childResult = this.visit(node.children[0], context);
	    if( !childResult ) {
	      return false;
	    }
	    return encodeURI(childResult);
	  }
	});

	var reverse = ReverseVisitor;

	Route.prototype = Object.create(null);

	/**
	 * Match a path against this route, returning the matched parameters if
	 * it matches, false if not.
	 * @example
	 * var route = new Route('/this/is/my/route')
	 * route.match('/this/is/my/route') // -> {}
	 * @example
	 * var route = new Route('/:one/:two')
	 * route.match('/foo/bar/') // -> {one: 'foo', two: 'bar'}
	 * @param  {string} path the path to match this route against
	 * @return {(Object.<string,string>|false)} A map of the matched route
	 * parameters, or false if matching failed
	 */
	Route.prototype.match = function(path) {
	  var re = regexp.visit(this.ast),
	      matched = re.match(path);

	  return matched ? matched : false;

	};

	/**
	 * Reverse a route specification to a path, returning false if it can't be
	 * fulfilled
	 * @example
	 * var route = new Route('/:one/:two')
	 * route.reverse({one: 'foo', two: 'bar'}) -> '/foo/bar'
	 * @param  {Object} params The parameters to fill in
	 * @return {(String|false)} The filled in path
	 */
	Route.prototype.reverse = function(params) {
	  return reverse.visit(this.ast, params);
	};

	/**
	 * Represents a route
	 * @example
	 * var route = Route('/:foo/:bar');
	 * @example
	 * var route = Route('/:foo/:bar');
	 * @param {string} spec -  the string specification of the route.
	 *     use :param for single portion captures, *param for splat style captures,
	 *     and () for optional route branches
	 * @constructor
	 */
	function Route(spec) {
	  var route;
	  if (this) {
	    // constructor called with new
	    route = this;
	  } else {
	    // constructor called as a function
	    route = Object.create(Route.prototype);
	  }
	  if( typeof spec === 'undefined' ) {
	    throw new Error('A route spec is required');
	  }
	  route.spec = spec;
	  route.ast = parser_1.parse(spec);
	  return route;
	}

	var route = Route;

	var routeParser = route;

	Event.prototype.propagationPath = function propagationPath() {
	    var polyfill = function () {
	        var element = this.target || null;
	        var pathArr = [element];

	        if (!element || !element.parentElement) {
	            return [];
	        }

	        while (element.parentElement) {
	            element = element.parentElement;
	            pathArr.unshift(element);
	        }

	        return pathArr;
	    }.bind(this);

	    return this.path || (this.composedPath && this.composedPath()) || polyfill();
	};

	class Root extends react.Component {
	  handleClick(event, routes) {
	    const nativeEvent = event.nativeEvent;

	    // If someone prevented default we honor that.
	    if (event.defaultPrevented) {
	      return;
	    }

	    // If the control is pressed it means that the user wants
	    // to open it a new tab so we honor that.
	    if (event.ctrlKey) {
	      return;
	    }

	    for (let element of event.nativeEvent.propagationPath()) {
	      if (element.tagName === "A") {
	        let pathname = element.pathname;
	        let origin = element.origin;
	        let search = element.search;
	        let hash = element.hash;

	        if (origin === window.location.origin) {
	          for (let item of this.props.routes) {
	            let fullPath = pathname + search + hash;
	            let path = new routeParser(item.path);
	            let match = path.match(fullPath);

	            if (match) {
	              event.preventDefault();
	              navigate(fullPath);
	              return;
	            }
	          }
	        }
	      }
	    }
	  }

	  render() {
	    return react.createElement(
	      "div",
	      { onClick: this.handleClick.bind(this) },
	      this.props.children
	    );
	  }
	}

	Root.displayName = "Mint.Root";

	var Program = enums => {
	  const {ok } = enums;

	  return class Program {

	    constructor() {
	      this.root = document.createElement("div");
	      document.body.appendChild(this.root);
	      this.routes = [];

	      window.addEventListener("popstate", () => {
	        this.handlePopState();
	      });
	    }

	    handlePopState() {
	      for (let item of this.routes) {
	        if (item.path === "*") {
	          item.handler();
	        } else {
	          let path = new routeParser(item.path);

	          let match = path.match(
	            window.location.pathname +
	              window.location.search +
	              window.location.hash
	          );

	          if (match) {
	            try {
	              let args = item.mapping.map((name, index) => {
	                const value = match[name];
	                const result = item.decoders[index](value);

	                if (result instanceof ok) {
	                  return result._0;
	                } else {
	                  throw "";
	                }
	              });

	              item.handler.apply(null, args);
	              break;
	            } catch (_) {}
	          }
	        }
	      }
	    }

	    render(main) {
	      if (typeof main != "undefined") {
	        this.handlePopState();
	        reactDom.render(
	          react.createElement(
	            Root,
	            { routes: this.routes },
	            react.createElement(main)
	          ),
	          this.root
	        );
	      }
	    }

	    addRoutes(routes) {
	      this.routes = this.routes.concat(routes);
	    }
	  }
	}

	var indentString = (str, count, opts) => {
		// Support older versions: use the third parameter as options.indent
		// TODO: Remove the workaround in the next major version
		const options = typeof opts === 'object' ? Object.assign({indent: ' '}, opts) : {indent: opts || ' '};
		count = count === undefined ? 1 : count;

		if (typeof str !== 'string') {
			throw new TypeError(`Expected \`input\` to be a \`string\`, got \`${typeof str}\``);
		}

		if (typeof count !== 'number') {
			throw new TypeError(`Expected \`count\` to be a \`number\`, got \`${typeof count}\``);
		}

		if (typeof options.indent !== 'string') {
			throw new TypeError(`Expected \`options.indent\` to be a \`string\`, got \`${typeof options.indent}\``);
		}

		if (count === 0) {
			return str;
		}

		const regex = options.includeEmptyLines ? /^/mg : /^(?!\s*$)/mg;
		return str.replace(regex, options.indent.repeat(count));
	}
	;

	const format$1 = value => {
	  let string = JSON.stringify(value, "", 2);

	  if (typeof string === "undefined") {
	    string = "undefined";
	  }

	  return indentString(string);
	};

	class Error$1 {
	  constructor(message, path = []) {
	    this.message = message;
	    this.object = null;
	    this.path = path;
	  }

	  push(input) {
	    this.path.unshift(input);
	  }

	  toString() {
	    const message = this.message.trim();

	    const path = this.path.reduce((memo, item) => {
	      if (memo.length) {
	        switch (item.type) {
	          case "FIELD":
	            return `${memo}.${item.value}`;
	          case "ARRAY":
	            return `${memo}[${item.value}]`;
	        }
	      } else {
	        switch (item.type) {
	          case "FIELD":
	            return item.value;
	          case "ARRAY":
	            return `[$(item.value)]`;
	        }
	      }
	    }, "");

	    if (path.length && this.object) {
	      return (
	        message +
	        "\n\n" +
	        IN_OBJECT.trim()
	          .replace("{value}", format$1(this.object))
	          .replace("{path}", path)
	      );
	    } else {
	      return message;
	    }
	  }
	}

	const IN_OBJECT = `
The input is in this object:

{value}

at: {path}
`;

	const NOT_A_STRING = `
I was trying to decode the value:

{value}

as a String, but could not.
`;

	const NOT_A_TIME = `
I was trying to decode the value:

{value}

as a Time, but could not.
`;

	const NOT_A_NUMBER = `
I was trying to decode the value:

{value}

as a Number, but could not.
`;

	const NOT_A_BOOLEAN = `
I was trying to decode the value:

{value}

as a Bool, but could not.
`;

	const NOT_AN_OBJECT = `
I was trying to decode the field "{field}" from the object:

{value}

but I could not because it's not an object.
`;

	const NOT_AN_ARRAY = `
I was trying to decode the value:

{value}

as an Array, but could not.
`;

	const MISSING_OBJECT_KEY = `
I was trying to decode the field "{field}" from the object:

{value}

but I could not because it's not an object.
`;

	const NOT_A_MAP = `
I was trying to decode the value:

{value}

as a Map, but could not.
`;

	const string = enums => input => {
	  const {ok, err} = enums;

	  if (typeof input != "string") {
	    return new err(new Error$1(NOT_A_STRING.replace("{value}", format$1(input))));
	  } else {
	    return new ok(input);
	  }
	};

	const time = (enums) => input => {
	  const {ok, err} = enums;

	  let parsed = NaN;

	  if (typeof input === "number") {
	    parsed = new Date(input);
	  } else {
	    parsed = Date.parse(input);
	  }

	  if (Number.isNaN(parsed)) {
	    return new err(new Error$1(NOT_A_TIME.replace("{value}", format$1(input))));
	  } else {
	    return new ok(new Date(parsed));
	  }
	};

	const number = (enums) => input => {
	  const {ok, err} = enums;

	  let value = parseFloat(input);

	  if (isNaN(value)) {
	    return new err(new Error$1(NOT_A_NUMBER.replace("{value}", format$1(input))));
	  } else {
	    return new ok(value);
	  }
	};

	const boolean = enums => input => {
	  const {ok, err} = enums;

	  if (typeof input != "boolean") {
	    return new err(new Error$1(NOT_A_BOOLEAN.replace("{value}", format$1(input))));
	  } else {
	    return new ok(input);
	  }
	};

	const field = (enums) => (key, decoder) => {
	  const {err} = enums;

	  return input => {
	    if (
	      input == null ||
	      input == undefined ||
	      typeof input !== "object" ||
	      Array.isArray(input)
	    ) {
	      const message = NOT_AN_OBJECT.replace("{field}", key).replace(
	        "{value}",
	        format$1(input)
	      );

	      return new err(new Error$1(message));
	    } else {
	      const actual = input[key];

	      const message = MISSING_OBJECT_KEY.replace("{field}", key).replace(
	        "{value}",
	        format$1(input)
	      );

	      if (typeof actual === "undefined") {
	        return new err(new Error$1(message));
	      }

	      const decoded = decoder(actual);

	      if (decoded instanceof err) {
	        decoded._0.push({ type: "FIELD", value: key });
	        decoded._0.object = input;
	      }

	      return decoded;
	    }
	  };
	};

	const array$1 = (enums) => decoder => {
	  const {ok, err} = enums;

	  return input => {
	    if (!Array.isArray(input)) {
	      return new err(new Error$1(NOT_AN_ARRAY.replace("{value}", format$1(input))));
	    }

	    let results = [];
	    let index = 0;

	    for (let item of input) {
	      let result = decoder(item);

	      if (result instanceof err) {
	        result._0.push({ type: "ARRAY", value: index });
	        result._0.object = input;
	        return result;
	      } else {
	        results.push(result._0);
	      }

	      index++;
	    }

	    return new ok(results);
	  };
	};

	const maybe = (enums) => decoder => {
	  const {ok, just, nothing, err} = enums;

	  return input => {
	    if (input == null || input == undefined) {
	      return new ok(new nothing());
	    } else {
	      const result = decoder(input);

	      if (result instanceof err) {
	        return result;
	      } else {
	        return new ok(new just(result._0));
	      }
	    }
	  };
	};

	const map = (enums) => decoder => {
	  const {ok, err} = enums;

	  return input => {
	    if (
	      input == null ||
	      input == undefined ||
	      typeof input !== "object" ||
	      Array.isArray(input)
	    ) {
	      const message = NOT_A_MAP.replace("{value}", format$1(input));

	      return new err(new Error$1(message));
	    } else {
	      const map = new Map();

	      for (let key in input) {
	        const result = decoder(input[key]);

	        if (result instanceof err) {
	          return result;
	        } else {
	          map.set(key, result._0);
	        }
	      }

	      return new ok(map);
	    }
	  };
	};

	var Decoder = (enums) => ({
	  boolean: boolean(enums),
	  number: number(enums),
	  string: string(enums),
	  field: field(enums),
	  array: array$1(enums),
	  maybe: maybe(enums),
	  time: time(enums),
	  map: map(enums)
	});

	const encode = (enums) => item => {
	  const {just, nothing} = enums;

	  if (item == null || item == undefined) {
	    return null;
	  } else if (Array.isArray(item)) {
	    return item.map(encode({nothing, just}));
	  } else {
	    switch (typeof item) {
	      case "string":
	      case "boolean":
	      case "number":
	        return item;
	      case "object":
	        if (item instanceof just) {
	          return item._0;
	        } else if (item instanceof nothing) {
	          return null;
	        } else if (item instanceof Map) {
	          let result = {};

	          item.forEach((value, key) => {
	            result[key] = encode({nothing, just})(value);
	          });

	          return result;
	        } else if (item instanceof Record) {
	          let result = {};

	          for (let key in item) {
	            const actualKey =
	              (item.constructor.mappings &&
	                item.constructor.mappings[key] &&
	                item.constructor.mappings[key][0]) ||
	              key;
	            result[actualKey] = encode({nothing, just})(item[key]);
	          }

	          return result;
	        }
	      default:
	        return item;
	    }
	  }
	};

	class Module {
	  constructor() {
	    bindFunctions(this);
	  }
	}

	class Store {
	  constructor() {
	    this.listeners = new Set();
	    this.state = {};
	  }

	  setState(state, callback) {
	    this.state = Object.assign({}, this.state, state);

	    for (let listener of this.listeners) {
	      listener.forceUpdate();
	    }

	    callback();
	  }

	  _subscribe(owner) {
	    this.listeners.add(owner);
	  }

	  _unsubscribe(owner) {
	    this.listeners.delete(owner);
	  }
	}

	class Enum {
	  [Equals](other) {
	    if (!(other instanceof this.constructor)) {
	      return false;
	    }

	    if (other.length !== this.length) {
	      return false;
	    }

	    for (let index = 0; index < this.length; index++) {
	      if (!compare(this["_" + index], other["_" + index])) {
	        return false;
	      }
	    }

	    return true;
	  }
	}

	Symbol.prototype[Equals] = function(other) {
	  return this.valueOf() === other;
	};

	Date.prototype[Equals] = function(other) {
	  return +this === +other;
	};

	Number.prototype[Equals] = function(other) {
	  return this.valueOf() === other;
	};

	Boolean.prototype[Equals] = function(other) {
	  return this.valueOf() === other;
	};

	String.prototype[Equals] = function(other) {
	  return this.valueOf() === other;
	};

	Array.prototype[Equals] = function(other) {
	  if (this.length !== other.length) {
	    return false;
	  }

	  if (this.length == 0) {
	    return true;
	  }

	  for (let index in this) {
	    if (!compare(this[index], other[index])) {
	      return false;
	    }
	  }

	  return true;
	};

	FormData.prototype[Equals] = function(other) {
	  const aKeys = Array.from(this.keys()).sort();
	  const bKeys = Array.from(other.keys()).sort();

	  if (compare(aKeys, bKeys)) {
	    if (aKeys.length == 0) {
	      return true;
	    }

	    for (let key of aKeys) {
	      const aValue = Array.from(this.getAll(key).sort());
	      const bValue = Array.from(other.getAll(key).sort());

	      if (!compare(aValue, bValue)) {
	        return false;
	      }
	    }

	    return true;
	  } else {
	    return false;
	  }
	};

	URLSearchParams.prototype[Equals] = function(other) {
	  return this.toString() === other.toString();
	};

	Set.prototype[Equals] = function(other) {
	  return compare(Array.from(this).sort(), Array.from(other).sort());
	};

	Map.prototype[Equals] = function(other) {
	  const aKeys = Array.from(this.keys()).sort();
	  const bKeys = Array.from(other.keys()).sort();

	  if (compare(aKeys, bKeys)) {
	    if (aKeys.length == 0) {
	      return true;
	    }

	    for (let key of aKeys) {
	      if (!compare(this.get(key), other.get(key))) {
	        return false;
	      }
	    }

	    return true;
	  } else {
	    return false;
	  }
	};

	var Main = (enums) => {
	  const DecoderWithEnums = Decoder(enums);

	  return {
	    program: new (Program(enums)),

	    normalizeEvent: normalizeEvent,
	    insertStyles: insertStyles,
	    navigate: navigate,
	    compare: compare,
	    update: update,
	    array: array,
	    style: style,

	    encode: encode(enums),
	    at: at(enums),

	    ReactDOM: reactDom,
	    React: react,

	    TestContext: TestContext,
	    Component: Component,
	    Provider: Provider,
	    Module: Module,
	    Store: Store,

	    Decoder: DecoderWithEnums,
	    DateFNS: dateFns,
	    Record: Record,
	    Enum: Enum,

	    Nothing: enums.nothing,
	    Just: enums.just,

	    Err: enums.err,
	    Ok: enums.ok,

	    createRecord: create(DecoderWithEnums, enums),
	    createPortal: reactDom.createPortal,
	    createElement: react.createElement,

	    Symbols: {
	      Equals: Equals
	    }
	  }
	};

	return Main;

}());
