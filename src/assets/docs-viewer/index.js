var Mint=function(){"use strict";function e(e,t){return e(t={exports:{}},t.exports),t.exports}var t=Object.getOwnPropertySymbols,n=Object.prototype.hasOwnProperty,r=Object.prototype.propertyIsEnumerable;var o=function(){try{if(!Object.assign)return!1;var e=new String("abc");if(e[5]="de","5"===Object.getOwnPropertyNames(e)[0])return!1;for(var t={},n=0;n<10;n++)t["_"+String.fromCharCode(n)]=n;if("0123456789"!==Object.getOwnPropertyNames(t).map(function(e){return t[e]}).join(""))return!1;var r={};return"abcdefghijklmnopqrst".split("").forEach(function(e){r[e]=e}),"abcdefghijklmnopqrst"===Object.keys(Object.assign({},r)).join("")}catch(e){return!1}}()?Object.assign:function(e,o){for(var a,i,u=function(e){if(null===e||void 0===e)throw new TypeError("Object.assign cannot be called with null or undefined");return Object(e)}(e),l=1;l<arguments.length;l++){for(var s in a=Object(arguments[l]))n.call(a,s)&&(u[s]=a[s]);if(t){i=t(a);for(var c=0;c<i.length;c++)r.call(a,i[c])&&(u[i[c]]=a[i[c]])}}return u},a={};function i(e){return function(){return e}}var u=function(){};u.thatReturns=i,u.thatReturnsFalse=i(!1),u.thatReturnsTrue=i(!0),u.thatReturnsNull=i(null),u.thatReturnsThis=function(){return this},u.thatReturnsArgument=function(e){return e};var l=u,s="function"==typeof Symbol&&Symbol.for,c=s?Symbol.for("react.element"):60103,f=s?Symbol.for("react.portal"):60106,d=s?Symbol.for("react.fragment"):60107,p=s?Symbol.for("react.strict_mode"):60108,h=s?Symbol.for("react.provider"):60109,m=s?Symbol.for("react.context"):60110,g=s?Symbol.for("react.async_mode"):60111,v=s?Symbol.for("react.forward_ref"):60112,y="function"==typeof Symbol&&Symbol.iterator;function b(e){for(var t=arguments.length-1,n="Minified React error #"+e+"; visit http://facebook.github.io/react/docs/error-decoder.html?invariant="+e,r=0;r<t;r++)n+="&args[]="+encodeURIComponent(arguments[r+1]);throw(t=Error(n+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings.")).name="Invariant Violation",t.framesToPop=1,t}var w={isMounted:function(){return!1},enqueueForceUpdate:function(){},enqueueReplaceState:function(){},enqueueSetState:function(){}};function k(e,t,n){this.props=e,this.context=t,this.refs=a,this.updater=n||w}function C(){}function x(e,t,n){this.props=e,this.context=t,this.refs=a,this.updater=n||w}k.prototype.isReactComponent={},k.prototype.setState=function(e,t){"object"!=typeof e&&"function"!=typeof e&&null!=e&&b("85"),this.updater.enqueueSetState(this,e,t,"setState")},k.prototype.forceUpdate=function(e){this.updater.enqueueForceUpdate(this,e,"forceUpdate")},C.prototype=k.prototype;var T=x.prototype=new C;T.constructor=x,o(T,k.prototype),T.isPureReactComponent=!0;var S={current:null},E=Object.prototype.hasOwnProperty,_={key:!0,ref:!0,__self:!0,__source:!0};function D(e,t,n){var r=void 0,o={},a=null,i=null;if(null!=t)for(r in void 0!==t.ref&&(i=t.ref),void 0!==t.key&&(a=""+t.key),t)E.call(t,r)&&!_.hasOwnProperty(r)&&(o[r]=t[r]);var u=arguments.length-2;if(1===u)o.children=n;else if(1<u){for(var l=Array(u),s=0;s<u;s++)l[s]=arguments[s+2];o.children=l}if(e&&e.defaultProps)for(r in u=e.defaultProps)void 0===o[r]&&(o[r]=u[r]);return{$$typeof:c,type:e,key:a,ref:i,props:o,_owner:S.current}}function M(e){return"object"==typeof e&&null!==e&&e.$$typeof===c}var I=/\/+/g,P=[];function O(e,t,n,r){if(P.length){var o=P.pop();return o.result=e,o.keyPrefix=t,o.func=n,o.context=r,o.count=0,o}return{result:e,keyPrefix:t,func:n,context:r,count:0}}function N(e){e.result=null,e.keyPrefix=null,e.func=null,e.context=null,e.count=0,10>P.length&&P.push(e)}function F(e,t,n,r){var o=typeof e;"undefined"!==o&&"boolean"!==o||(e=null);var a=!1;if(null===e)a=!0;else switch(o){case"string":case"number":a=!0;break;case"object":switch(e.$$typeof){case c:case f:a=!0}}if(a)return n(r,e,""===t?"."+R(e,0):t),1;if(a=0,t=""===t?".":t+":",Array.isArray(e))for(var i=0;i<e.length;i++){var u=t+R(o=e[i],i);a+=F(o,u,n,r)}else if(null===e||void 0===e?u=null:u="function"==typeof(u=y&&e[y]||e["@@iterator"])?u:null,"function"==typeof u)for(e=u.call(e),i=0;!(o=e.next()).done;)a+=F(o=o.value,u=t+R(o,i++),n,r);else"object"===o&&b("31","[object Object]"===(n=""+e)?"object with keys {"+Object.keys(e).join(", ")+"}":n,"");return a}function R(e,t){return"object"==typeof e&&null!==e&&null!=e.key?function(e){var t={"=":"=0",":":"=2"};return"$"+(""+e).replace(/[=:]/g,function(e){return t[e]})}(e.key):t.toString(36)}function U(e,t){e.func.call(e.context,t,e.count++)}function A(e,t,n){var r=e.result,o=e.keyPrefix;e=e.func.call(e.context,t,e.count++),Array.isArray(e)?H(e,r,n,l.thatReturnsArgument):null!=e&&(M(e)&&(t=o+(!e.key||t&&t.key===e.key?"":(""+e.key).replace(I,"$&/")+"/")+n,e={$$typeof:c,type:e.type,key:t,ref:e.ref,props:e.props,_owner:e._owner}),r.push(e))}function H(e,t,n,r,o){var a="";null!=n&&(a=(""+n).replace(I,"$&/")+"/"),t=O(t,a,r,o),null==e||F(e,"",A,t),N(t)}var L={Children:{map:function(e,t,n){if(null==e)return e;var r=[];return H(e,r,null,t,n),r},forEach:function(e,t,n){if(null==e)return e;t=O(null,null,t,n),null==e||F(e,"",U,t),N(t)},count:function(e){return null==e?0:F(e,"",l.thatReturnsNull,null)},toArray:function(e){var t=[];return H(e,t,null,l.thatReturnsArgument),t},only:function(e){return M(e)||b("143"),e}},createRef:function(){return{current:null}},Component:k,PureComponent:x,createContext:function(e,t){return void 0===t&&(t=null),(e={$$typeof:m,_calculateChangedBits:t,_defaultValue:e,_currentValue:e,_changedBits:0,Provider:null,Consumer:null}).Provider={$$typeof:h,context:e},e.Consumer=e},forwardRef:function(e){return{$$typeof:v,render:e}},Fragment:d,StrictMode:p,unstable_AsyncMode:g,createElement:D,cloneElement:function(e,t,n){var r=void 0,a=o({},e.props),i=e.key,u=e.ref,l=e._owner;if(null!=t){void 0!==t.ref&&(u=t.ref,l=S.current),void 0!==t.key&&(i=""+t.key);var s=void 0;for(r in e.type&&e.type.defaultProps&&(s=e.type.defaultProps),t)E.call(t,r)&&!_.hasOwnProperty(r)&&(a[r]=void 0===t[r]&&void 0!==s?s[r]:t[r])}if(1===(r=arguments.length-2))a.children=n;else if(1<r){s=Array(r);for(var f=0;f<r;f++)s[f]=arguments[f+2];a.children=s}return{$$typeof:c,type:e.type,key:i,ref:u,props:a,_owner:l}},createFactory:function(e){var t=D.bind(null,e);return t.type=e,t},isValidElement:M,version:"16.3.0",__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED:{ReactCurrentOwner:S,assign:o}},z=Object.freeze({default:L}),Y=z&&L||z,j=Y.default?Y.default:Y,W=(e(function(e){}),e(function(e){e.exports=j})),V=!("undefined"==typeof window||!window.document||!window.document.createElement),$={canUseDOM:V,canUseWorkers:"undefined"!=typeof Worker,canUseEventListeners:V&&!(!window.addEventListener&&!window.attachEvent),canUseViewport:V&&!!window.screen,isInWorker:!V};var B=function(e){if(void 0===(e=e||("undefined"!=typeof document?document:void 0)))return null;try{return e.activeElement||e.body}catch(t){return e.body}},K=Object.prototype.hasOwnProperty;function Q(e,t){return e===t?0!==e||0!==t||1/e==1/t:e!=e&&t!=t}var q=function(e,t){if(Q(e,t))return!0;if("object"!=typeof e||null===e||"object"!=typeof t||null===t)return!1;var n=Object.keys(e),r=Object.keys(t);if(n.length!==r.length)return!1;for(var o=0;o<n.length;o++)if(!K.call(t,n[o])||!Q(e[n[o]],t[n[o]]))return!1;return!0};var X=function(e){var t=(e?e.ownerDocument||e:document).defaultView||window;return!(!e||!("function"==typeof t.Node?e instanceof t.Node:"object"==typeof e&&"number"==typeof e.nodeType&&"string"==typeof e.nodeName))};var G=function(e){return X(e)&&3==e.nodeType};var Z=function e(t,n){return!(!t||!n)&&(t===n||!G(t)&&(G(n)?e(t,n.parentNode):"contains"in t?t.contains(n):!!t.compareDocumentPosition&&!!(16&t.compareDocumentPosition(n))))};function J(e){for(var t=arguments.length-1,n="Minified React error #"+e+"; visit http://facebook.github.io/react/docs/error-decoder.html?invariant="+e,r=0;r<t;r++)n+="&args[]="+encodeURIComponent(arguments[r+1]);throw(t=Error(n+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings.")).name="Invariant Violation",t.framesToPop=1,t}W||J("227");var ee={_caughtError:null,_hasCaughtError:!1,_rethrowError:null,_hasRethrowError:!1,invokeGuardedCallback:function(e,t,n,r,o,a,i,u,l){(function(e,t,n,r,o,a,i,u,l){this._hasCaughtError=!1,this._caughtError=null;var s=Array.prototype.slice.call(arguments,3);try{t.apply(n,s)}catch(e){this._caughtError=e,this._hasCaughtError=!0}}).apply(ee,arguments)},invokeGuardedCallbackAndCatchFirstError:function(e,t,n,r,o,a,i,u,l){if(ee.invokeGuardedCallback.apply(this,arguments),ee.hasCaughtError()){var s=ee.clearCaughtError();ee._hasRethrowError||(ee._hasRethrowError=!0,ee._rethrowError=s)}},rethrowCaughtError:function(){return function(){if(ee._hasRethrowError){var e=ee._rethrowError;throw ee._rethrowError=null,ee._hasRethrowError=!1,e}}.apply(ee,arguments)},hasCaughtError:function(){return ee._hasCaughtError},clearCaughtError:function(){if(ee._hasCaughtError){var e=ee._caughtError;return ee._caughtError=null,ee._hasCaughtError=!1,e}J("198")}};var te=null,ne={};function re(){if(te)for(var e in ne){var t=ne[e],n=te.indexOf(e);if(-1<n||J("96",e),!ae[n])for(var r in t.extractEvents||J("97",e),ae[n]=t,n=t.eventTypes){var o=void 0,a=n[r],i=t,u=r;ie.hasOwnProperty(u)&&J("99",u),ie[u]=a;var l=a.phasedRegistrationNames;if(l){for(o in l)l.hasOwnProperty(o)&&oe(l[o],i,u);o=!0}else a.registrationName?(oe(a.registrationName,i,u),o=!0):o=!1;o||J("98",r,e)}}}function oe(e,t,n){ue[e]&&J("100",e),ue[e]=t,le[e]=t.eventTypes[n].dependencies}var ae=[],ie={},ue={},le={};function se(e){te&&J("101"),te=Array.prototype.slice.call(e),re()}function ce(e){var t,n=!1;for(t in e)if(e.hasOwnProperty(t)){var r=e[t];ne.hasOwnProperty(t)&&ne[t]===r||(ne[t]&&J("102",t),ne[t]=r,n=!0)}n&&re()}var fe=Object.freeze({plugins:ae,eventNameDispatchConfigs:ie,registrationNameModules:ue,registrationNameDependencies:le,possibleRegistrationNames:null,injectEventPluginOrder:se,injectEventPluginsByName:ce}),de=null,pe=null,he=null;function me(e,t,n,r){t=e.type||"unknown-event",e.currentTarget=he(r),ee.invokeGuardedCallbackAndCatchFirstError(t,n,void 0,e),e.currentTarget=null}function ge(e,t){return null==t&&J("30"),null==e?t:Array.isArray(e)?Array.isArray(t)?(e.push.apply(e,t),e):(e.push(t),e):Array.isArray(t)?[e].concat(t):[e,t]}function ve(e,t,n){Array.isArray(e)?e.forEach(t,n):e&&t.call(n,e)}var ye=null;function be(e,t){if(e){var n=e._dispatchListeners,r=e._dispatchInstances;if(Array.isArray(n))for(var o=0;o<n.length&&!e.isPropagationStopped();o++)me(e,t,n[o],r[o]);else n&&me(e,t,n,r);e._dispatchListeners=null,e._dispatchInstances=null,e.isPersistent()||e.constructor.release(e)}}function we(e){return be(e,!0)}function ke(e){return be(e,!1)}var Ce={injectEventPluginOrder:se,injectEventPluginsByName:ce};function xe(e,t){var n=e.stateNode;if(!n)return null;var r=de(n);if(!r)return null;n=r[t];e:switch(t){case"onClick":case"onClickCapture":case"onDoubleClick":case"onDoubleClickCapture":case"onMouseDown":case"onMouseDownCapture":case"onMouseMove":case"onMouseMoveCapture":case"onMouseUp":case"onMouseUpCapture":(r=!r.disabled)||(r=!("button"===(e=e.type)||"input"===e||"select"===e||"textarea"===e)),e=!r;break e;default:e=!1}return e?null:(n&&"function"!=typeof n&&J("231",t,typeof n),n)}function Te(e,t){null!==e&&(ye=ge(ye,e)),e=ye,ye=null,e&&(ve(e,t?we:ke),ye&&J("95"),ee.rethrowCaughtError())}function Se(e,t,n,r){for(var o=null,a=0;a<ae.length;a++){var i=ae[a];i&&(i=i.extractEvents(e,t,n,r))&&(o=ge(o,i))}Te(o,!1)}var Ee=Object.freeze({injection:Ce,getListener:xe,runEventsInBatch:Te,runExtractedEventsInBatch:Se}),_e=Math.random().toString(36).slice(2),De="__reactInternalInstance$"+_e,Me="__reactEventHandlers$"+_e;function Ie(e){if(e[De])return e[De];for(;!e[De];){if(!e.parentNode)return null;e=e.parentNode}return 5===(e=e[De]).tag||6===e.tag?e:null}function Pe(e){if(5===e.tag||6===e.tag)return e.stateNode;J("33")}function Oe(e){return e[Me]||null}var Ne=Object.freeze({precacheFiberNode:function(e,t){t[De]=e},getClosestInstanceFromNode:Ie,getInstanceFromNode:function(e){return!(e=e[De])||5!==e.tag&&6!==e.tag?null:e},getNodeFromInstance:Pe,getFiberCurrentPropsFromNode:Oe,updateFiberProps:function(e,t){e[Me]=t}});function Fe(e){do{e=e.return}while(e&&5!==e.tag);return e||null}function Re(e,t,n){for(var r=[];e;)r.push(e),e=Fe(e);for(e=r.length;0<e--;)t(r[e],"captured",n);for(e=0;e<r.length;e++)t(r[e],"bubbled",n)}function Ue(e,t,n){(t=xe(e,n.dispatchConfig.phasedRegistrationNames[t]))&&(n._dispatchListeners=ge(n._dispatchListeners,t),n._dispatchInstances=ge(n._dispatchInstances,e))}function Ae(e){e&&e.dispatchConfig.phasedRegistrationNames&&Re(e._targetInst,Ue,e)}function He(e){if(e&&e.dispatchConfig.phasedRegistrationNames){var t=e._targetInst;Re(t=t?Fe(t):null,Ue,e)}}function Le(e,t,n){e&&n&&n.dispatchConfig.registrationName&&(t=xe(e,n.dispatchConfig.registrationName))&&(n._dispatchListeners=ge(n._dispatchListeners,t),n._dispatchInstances=ge(n._dispatchInstances,e))}function ze(e){e&&e.dispatchConfig.registrationName&&Le(e._targetInst,null,e)}function Ye(e){ve(e,Ae)}function je(e,t,n,r){if(n&&r)e:{for(var o=n,a=r,i=0,u=o;u;u=Fe(u))i++;u=0;for(var l=a;l;l=Fe(l))u++;for(;0<i-u;)o=Fe(o),i--;for(;0<u-i;)a=Fe(a),u--;for(;i--;){if(o===a||o===a.alternate)break e;o=Fe(o),a=Fe(a)}o=null}else o=null;for(a=o,o=[];n&&n!==a&&(null===(i=n.alternate)||i!==a);)o.push(n),n=Fe(n);for(n=[];r&&r!==a&&(null===(i=r.alternate)||i!==a);)n.push(r),r=Fe(r);for(r=0;r<o.length;r++)Le(o[r],"bubbled",e);for(e=n.length;0<e--;)Le(n[e],"captured",t)}var We=Object.freeze({accumulateTwoPhaseDispatches:Ye,accumulateTwoPhaseDispatchesSkipTarget:function(e){ve(e,He)},accumulateEnterLeaveDispatches:je,accumulateDirectDispatches:function(e){ve(e,ze)}}),Ve=null;function $e(){return!Ve&&$.canUseDOM&&(Ve="textContent"in document.documentElement?"textContent":"innerText"),Ve}var Be={_root:null,_startText:null,_fallbackText:null};function Ke(){if(Be._fallbackText)return Be._fallbackText;var e,t,n=Be._startText,r=n.length,o=Qe(),a=o.length;for(e=0;e<r&&n[e]===o[e];e++);var i=r-e;for(t=1;t<=i&&n[r-t]===o[a-t];t++);return Be._fallbackText=o.slice(e,1<t?1-t:void 0),Be._fallbackText}function Qe(){return"value"in Be._root?Be._root.value:Be._root[$e()]}var qe="dispatchConfig _targetInst nativeEvent isDefaultPrevented isPropagationStopped _dispatchListeners _dispatchInstances".split(" "),Xe={type:null,target:null,currentTarget:l.thatReturnsNull,eventPhase:null,bubbles:null,cancelable:null,timeStamp:function(e){return e.timeStamp||Date.now()},defaultPrevented:null,isTrusted:null};function Ge(e,t,n,r){for(var o in this.dispatchConfig=e,this._targetInst=t,this.nativeEvent=n,e=this.constructor.Interface)e.hasOwnProperty(o)&&((t=e[o])?this[o]=t(n):"target"===o?this.target=r:this[o]=n[o]);return this.isDefaultPrevented=(null!=n.defaultPrevented?n.defaultPrevented:!1===n.returnValue)?l.thatReturnsTrue:l.thatReturnsFalse,this.isPropagationStopped=l.thatReturnsFalse,this}function Ze(e,t,n,r){if(this.eventPool.length){var o=this.eventPool.pop();return this.call(o,e,t,n,r),o}return new this(e,t,n,r)}function Je(e){e instanceof this||J("223"),e.destructor(),10>this.eventPool.length&&this.eventPool.push(e)}function et(e){e.eventPool=[],e.getPooled=Ze,e.release=Je}o(Ge.prototype,{preventDefault:function(){this.defaultPrevented=!0;var e=this.nativeEvent;e&&(e.preventDefault?e.preventDefault():"unknown"!=typeof e.returnValue&&(e.returnValue=!1),this.isDefaultPrevented=l.thatReturnsTrue)},stopPropagation:function(){var e=this.nativeEvent;e&&(e.stopPropagation?e.stopPropagation():"unknown"!=typeof e.cancelBubble&&(e.cancelBubble=!0),this.isPropagationStopped=l.thatReturnsTrue)},persist:function(){this.isPersistent=l.thatReturnsTrue},isPersistent:l.thatReturnsFalse,destructor:function(){var e,t=this.constructor.Interface;for(e in t)this[e]=null;for(t=0;t<qe.length;t++)this[qe[t]]=null}}),Ge.Interface=Xe,Ge.extend=function(e){function t(){}function n(){return r.apply(this,arguments)}var r=this;t.prototype=r.prototype;var a=new t;return o(a,n.prototype),n.prototype=a,n.prototype.constructor=n,n.Interface=o({},r.Interface,e),n.extend=r.extend,et(n),n},et(Ge);var tt=Ge.extend({data:null}),nt=Ge.extend({data:null}),rt=[9,13,27,32],ot=$.canUseDOM&&"CompositionEvent"in window,at=null;$.canUseDOM&&"documentMode"in document&&(at=document.documentMode);var it=$.canUseDOM&&"TextEvent"in window&&!at,ut=$.canUseDOM&&(!ot||at&&8<at&&11>=at),lt=String.fromCharCode(32),st={beforeInput:{phasedRegistrationNames:{bubbled:"onBeforeInput",captured:"onBeforeInputCapture"},dependencies:["topCompositionEnd","topKeyPress","topTextInput","topPaste"]},compositionEnd:{phasedRegistrationNames:{bubbled:"onCompositionEnd",captured:"onCompositionEndCapture"},dependencies:"topBlur topCompositionEnd topKeyDown topKeyPress topKeyUp topMouseDown".split(" ")},compositionStart:{phasedRegistrationNames:{bubbled:"onCompositionStart",captured:"onCompositionStartCapture"},dependencies:"topBlur topCompositionStart topKeyDown topKeyPress topKeyUp topMouseDown".split(" ")},compositionUpdate:{phasedRegistrationNames:{bubbled:"onCompositionUpdate",captured:"onCompositionUpdateCapture"},dependencies:"topBlur topCompositionUpdate topKeyDown topKeyPress topKeyUp topMouseDown".split(" ")}},ct=!1;function ft(e,t){switch(e){case"topKeyUp":return-1!==rt.indexOf(t.keyCode);case"topKeyDown":return 229!==t.keyCode;case"topKeyPress":case"topMouseDown":case"topBlur":return!0;default:return!1}}function dt(e){return"object"==typeof(e=e.detail)&&"data"in e?e.data:null}var pt=!1;var ht={eventTypes:st,extractEvents:function(e,t,n,r){var o=void 0,a=void 0;if(ot)e:{switch(e){case"topCompositionStart":o=st.compositionStart;break e;case"topCompositionEnd":o=st.compositionEnd;break e;case"topCompositionUpdate":o=st.compositionUpdate;break e}o=void 0}else pt?ft(e,n)&&(o=st.compositionEnd):"topKeyDown"===e&&229===n.keyCode&&(o=st.compositionStart);return o?(ut&&(pt||o!==st.compositionStart?o===st.compositionEnd&&pt&&(a=Ke()):(Be._root=r,Be._startText=Qe(),pt=!0)),o=tt.getPooled(o,t,n,r),a?o.data=a:null!==(a=dt(n))&&(o.data=a),Ye(o),a=o):a=null,(e=it?function(e,t){switch(e){case"topCompositionEnd":return dt(t);case"topKeyPress":return 32!==t.which?null:(ct=!0,lt);case"topTextInput":return(e=t.data)===lt&&ct?null:e;default:return null}}(e,n):function(e,t){if(pt)return"topCompositionEnd"===e||!ot&&ft(e,t)?(e=Ke(),Be._root=null,Be._startText=null,Be._fallbackText=null,pt=!1,e):null;switch(e){case"topPaste":return null;case"topKeyPress":if(!(t.ctrlKey||t.altKey||t.metaKey)||t.ctrlKey&&t.altKey){if(t.char&&1<t.char.length)return t.char;if(t.which)return String.fromCharCode(t.which)}return null;case"topCompositionEnd":return ut?null:t.data;default:return null}}(e,n))?((t=nt.getPooled(st.beforeInput,t,n,r)).data=e,Ye(t)):t=null,null===a?t:null===t?a:[a,t]}},mt=null,gt=null,vt=null;function yt(e){if(e=pe(e)){mt&&"function"==typeof mt.restoreControlledState||J("194");var t=de(e.stateNode);mt.restoreControlledState(e.stateNode,e.type,t)}}var bt={injectFiberControlledHostComponent:function(e){mt=e}};function wt(e){gt?vt?vt.push(e):vt=[e]:gt=e}function kt(){return null!==gt||null!==vt}function Ct(){if(gt){var e=gt,t=vt;if(vt=gt=null,yt(e),t)for(e=0;e<t.length;e++)yt(t[e])}}var xt=Object.freeze({injection:bt,enqueueStateRestore:wt,needsStateRestore:kt,restoreStateIfNeeded:Ct});function Tt(e,t){return e(t)}function St(e,t,n){return e(t,n)}function Et(){}var _t=!1;function Dt(e,t){if(_t)return e(t);_t=!0;try{return Tt(e,t)}finally{_t=!1,kt()&&(Et(),Ct())}}var Mt={color:!0,date:!0,datetime:!0,"datetime-local":!0,email:!0,month:!0,number:!0,password:!0,range:!0,search:!0,tel:!0,text:!0,time:!0,url:!0,week:!0};function It(e){var t=e&&e.nodeName&&e.nodeName.toLowerCase();return"input"===t?!!Mt[e.type]:"textarea"===t}function Pt(e){return(e=e.target||window).correspondingUseElement&&(e=e.correspondingUseElement),3===e.nodeType?e.parentNode:e}function Ot(e,t){return!(!$.canUseDOM||t&&!("addEventListener"in document))&&((t=(e="on"+e)in document)||((t=document.createElement("div")).setAttribute(e,"return;"),t="function"==typeof t[e]),t)}function Nt(e){var t=e.type;return(e=e.nodeName)&&"input"===e.toLowerCase()&&("checkbox"===t||"radio"===t)}function Ft(e){e._valueTracker||(e._valueTracker=function(e){var t=Nt(e)?"checked":"value",n=Object.getOwnPropertyDescriptor(e.constructor.prototype,t),r=""+e[t];if(!e.hasOwnProperty(t)&&"function"==typeof n.get&&"function"==typeof n.set)return Object.defineProperty(e,t,{configurable:!0,get:function(){return n.get.call(this)},set:function(e){r=""+e,n.set.call(this,e)}}),Object.defineProperty(e,t,{enumerable:n.enumerable}),{getValue:function(){return r},setValue:function(e){r=""+e},stopTracking:function(){e._valueTracker=null,delete e[t]}}}(e))}function Rt(e){if(!e)return!1;var t=e._valueTracker;if(!t)return!0;var n=t.getValue(),r="";return e&&(r=Nt(e)?e.checked?"true":"false":e.value),(e=r)!==n&&(t.setValue(e),!0)}var Ut=W.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,At="function"==typeof Symbol&&Symbol.for,Ht=At?Symbol.for("react.element"):60103,Lt=At?Symbol.for("react.call"):60104,zt=At?Symbol.for("react.return"):60105,Yt=At?Symbol.for("react.portal"):60106,jt=At?Symbol.for("react.fragment"):60107,Wt=At?Symbol.for("react.strict_mode"):60108,Vt=At?Symbol.for("react.provider"):60109,$t=At?Symbol.for("react.context"):60110,Bt=At?Symbol.for("react.async_mode"):60111,Kt=At?Symbol.for("react.forward_ref"):60112,Qt="function"==typeof Symbol&&Symbol.iterator;function qt(e){return null===e||void 0===e?null:"function"==typeof(e=Qt&&e[Qt]||e["@@iterator"])?e:null}function Xt(e){if("function"==typeof(e=e.type))return e.displayName||e.name;if("string"==typeof e)return e;switch(e){case jt:return"ReactFragment";case Yt:return"ReactPortal";case Lt:return"ReactCall";case zt:return"ReactReturn"}return null}function Gt(e){var t="";do{e:switch(e.tag){case 0:case 1:case 2:case 5:var n=e._debugOwner,r=e._debugSource,o=Xt(e),a=null;n&&(a=Xt(n)),n=r,o="\n    in "+(o||"Unknown")+(n?" (at "+n.fileName.replace(/^.*[\\\/]/,"")+":"+n.lineNumber+")":a?" (created by "+a+")":"");break e;default:o=""}t+=o,e=e.return}while(e);return t}var Zt=/^[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\-.0-9\u00B7\u0300-\u036F\u203F-\u2040]*$/,Jt={},en={};function tn(e,t,n,r,o){this.acceptsBooleans=2===t||3===t||4===t,this.attributeName=r,this.attributeNamespace=o,this.mustUseProperty=n,this.propertyName=e,this.type=t}var nn={};"children dangerouslySetInnerHTML defaultValue defaultChecked innerHTML suppressContentEditableWarning suppressHydrationWarning style".split(" ").forEach(function(e){nn[e]=new tn(e,0,!1,e,null)}),[["acceptCharset","accept-charset"],["className","class"],["htmlFor","for"],["httpEquiv","http-equiv"]].forEach(function(e){var t=e[0];nn[t]=new tn(t,1,!1,e[1],null)}),["contentEditable","draggable","spellCheck","value"].forEach(function(e){nn[e]=new tn(e,2,!1,e.toLowerCase(),null)}),["autoReverse","externalResourcesRequired","preserveAlpha"].forEach(function(e){nn[e]=new tn(e,2,!1,e,null)}),"allowFullScreen async autoFocus autoPlay controls default defer disabled formNoValidate hidden loop noModule noValidate open playsInline readOnly required reversed scoped seamless itemScope".split(" ").forEach(function(e){nn[e]=new tn(e,3,!1,e.toLowerCase(),null)}),["checked","multiple","muted","selected"].forEach(function(e){nn[e]=new tn(e,3,!0,e.toLowerCase(),null)}),["capture","download"].forEach(function(e){nn[e]=new tn(e,4,!1,e.toLowerCase(),null)}),["cols","rows","size","span"].forEach(function(e){nn[e]=new tn(e,6,!1,e.toLowerCase(),null)}),["rowSpan","start"].forEach(function(e){nn[e]=new tn(e,5,!1,e.toLowerCase(),null)});var rn=/[\-\:]([a-z])/g;function on(e){return e[1].toUpperCase()}function an(e,t,n,r){var o=nn.hasOwnProperty(t)?nn[t]:null;(null!==o?0===o.type:!r&&(2<t.length&&("o"===t[0]||"O"===t[0])&&("n"===t[1]||"N"===t[1])))||(function(e,t,n,r){if(null===t||void 0===t||function(e,t,n,r){if(null!==n&&0===n.type)return!1;switch(typeof t){case"function":case"symbol":return!0;case"boolean":return!r&&(null!==n?!n.acceptsBooleans:"data-"!==(e=e.toLowerCase().slice(0,5))&&"aria-"!==e);default:return!1}}(e,t,n,r))return!0;if(null!==n)switch(n.type){case 3:return!t;case 4:return!1===t;case 5:return isNaN(t);case 6:return isNaN(t)||1>t}return!1}(t,n,o,r)&&(n=null),r||null===o?function(e){return!!en.hasOwnProperty(e)||!Jt.hasOwnProperty(e)&&(Zt.test(e)?en[e]=!0:(Jt[e]=!0,!1))}(t)&&(null===n?e.removeAttribute(t):e.setAttribute(t,""+n)):o.mustUseProperty?e[o.propertyName]=null===n?3!==o.type&&"":n:(t=o.attributeName,r=o.attributeNamespace,null===n?e.removeAttribute(t):(n=3===(o=o.type)||4===o&&!0===n?"":""+n,r?e.setAttributeNS(r,t,n):e.setAttribute(t,n))))}function un(e,t){var n=t.checked;return o({},t,{defaultChecked:void 0,defaultValue:void 0,value:void 0,checked:null!=n?n:e._wrapperState.initialChecked})}function ln(e,t){var n=null==t.defaultValue?"":t.defaultValue,r=null!=t.checked?t.checked:t.defaultChecked;n=pn(null!=t.value?t.value:n),e._wrapperState={initialChecked:r,initialValue:n,controlled:"checkbox"===t.type||"radio"===t.type?null!=t.checked:null!=t.value}}function sn(e,t){null!=(t=t.checked)&&an(e,"checked",t,!1)}function cn(e,t){sn(e,t);var n=pn(t.value);null!=n&&("number"===t.type?(0===n&&""===e.value||e.value!=n)&&(e.value=""+n):e.value!==""+n&&(e.value=""+n)),t.hasOwnProperty("value")?dn(e,t.type,n):t.hasOwnProperty("defaultValue")&&dn(e,t.type,pn(t.defaultValue)),null==t.checked&&null!=t.defaultChecked&&(e.defaultChecked=!!t.defaultChecked)}function fn(e,t){(t.hasOwnProperty("value")||t.hasOwnProperty("defaultValue"))&&(""===e.value&&(e.value=""+e._wrapperState.initialValue),e.defaultValue=""+e._wrapperState.initialValue),""!==(t=e.name)&&(e.name=""),e.defaultChecked=!e.defaultChecked,e.defaultChecked=!e.defaultChecked,""!==t&&(e.name=t)}function dn(e,t,n){"number"===t&&e.ownerDocument.activeElement===e||(null==n?e.defaultValue=""+e._wrapperState.initialValue:e.defaultValue!==""+n&&(e.defaultValue=""+n))}function pn(e){switch(typeof e){case"boolean":case"number":case"object":case"string":case"undefined":return e;default:return""}}"accent-height alignment-baseline arabic-form baseline-shift cap-height clip-path clip-rule color-interpolation color-interpolation-filters color-profile color-rendering dominant-baseline enable-background fill-opacity fill-rule flood-color flood-opacity font-family font-size font-size-adjust font-stretch font-style font-variant font-weight glyph-name glyph-orientation-horizontal glyph-orientation-vertical horiz-adv-x horiz-origin-x image-rendering letter-spacing lighting-color marker-end marker-mid marker-start overline-position overline-thickness paint-order panose-1 pointer-events rendering-intent shape-rendering stop-color stop-opacity strikethrough-position strikethrough-thickness stroke-dasharray stroke-dashoffset stroke-linecap stroke-linejoin stroke-miterlimit stroke-opacity stroke-width text-anchor text-decoration text-rendering underline-position underline-thickness unicode-bidi unicode-range units-per-em v-alphabetic v-hanging v-ideographic v-mathematical vector-effect vert-adv-y vert-origin-x vert-origin-y word-spacing writing-mode xmlns:xlink x-height".split(" ").forEach(function(e){var t=e.replace(rn,on);nn[t]=new tn(t,1,!1,e,null)}),"xlink:actuate xlink:arcrole xlink:href xlink:role xlink:show xlink:title xlink:type".split(" ").forEach(function(e){var t=e.replace(rn,on);nn[t]=new tn(t,1,!1,e,"http://www.w3.org/1999/xlink")}),["xml:base","xml:lang","xml:space"].forEach(function(e){var t=e.replace(rn,on);nn[t]=new tn(t,1,!1,e,"http://www.w3.org/XML/1998/namespace")}),nn.tabIndex=new tn("tabIndex",1,!1,"tabindex",null);var hn={change:{phasedRegistrationNames:{bubbled:"onChange",captured:"onChangeCapture"},dependencies:"topBlur topChange topClick topFocus topInput topKeyDown topKeyUp topSelectionChange".split(" ")}};function mn(e,t,n){return(e=Ge.getPooled(hn.change,e,t,n)).type="change",wt(n),Ye(e),e}var gn=null,vn=null;function yn(e){Te(e,!1)}function bn(e){if(Rt(Pe(e)))return e}function wn(e,t){if("topChange"===e)return t}var kn=!1;function Cn(){gn&&(gn.detachEvent("onpropertychange",xn),vn=gn=null)}function xn(e){"value"===e.propertyName&&bn(vn)&&Dt(yn,e=mn(vn,e,Pt(e)))}function Tn(e,t,n){"topFocus"===e?(Cn(),vn=n,(gn=t).attachEvent("onpropertychange",xn)):"topBlur"===e&&Cn()}function Sn(e){if("topSelectionChange"===e||"topKeyUp"===e||"topKeyDown"===e)return bn(vn)}function En(e,t){if("topClick"===e)return bn(t)}function _n(e,t){if("topInput"===e||"topChange"===e)return bn(t)}$.canUseDOM&&(kn=Ot("input")&&(!document.documentMode||9<document.documentMode));var Dn={eventTypes:hn,_isInputEventSupported:kn,extractEvents:function(e,t,n,r){var o=t?Pe(t):window,a=void 0,i=void 0,u=o.nodeName&&o.nodeName.toLowerCase();if("select"===u||"input"===u&&"file"===o.type?a=wn:It(o)?kn?a=_n:(a=Sn,i=Tn):!(u=o.nodeName)||"input"!==u.toLowerCase()||"checkbox"!==o.type&&"radio"!==o.type||(a=En),a&&(a=a(e,t)))return mn(a,n,r);i&&i(e,o,t),"topBlur"===e&&null!=t&&(e=t._wrapperState||o._wrapperState)&&e.controlled&&"number"===o.type&&dn(o,"number",o.value)}},Mn=Ge.extend({view:null,detail:null}),In={Alt:"altKey",Control:"ctrlKey",Meta:"metaKey",Shift:"shiftKey"};function Pn(e){var t=this.nativeEvent;return t.getModifierState?t.getModifierState(e):!!(e=In[e])&&!!t[e]}function On(){return Pn}var Nn=Mn.extend({screenX:null,screenY:null,clientX:null,clientY:null,pageX:null,pageY:null,ctrlKey:null,shiftKey:null,altKey:null,metaKey:null,getModifierState:On,button:null,buttons:null,relatedTarget:function(e){return e.relatedTarget||(e.fromElement===e.srcElement?e.toElement:e.fromElement)}}),Fn={mouseEnter:{registrationName:"onMouseEnter",dependencies:["topMouseOut","topMouseOver"]},mouseLeave:{registrationName:"onMouseLeave",dependencies:["topMouseOut","topMouseOver"]}},Rn={eventTypes:Fn,extractEvents:function(e,t,n,r){if("topMouseOver"===e&&(n.relatedTarget||n.fromElement)||"topMouseOut"!==e&&"topMouseOver"!==e)return null;var o=r.window===r?r:(o=r.ownerDocument)?o.defaultView||o.parentWindow:window;if("topMouseOut"===e?(e=t,t=(t=n.relatedTarget||n.toElement)?Ie(t):null):e=null,e===t)return null;var a=null==e?o:Pe(e);o=null==t?o:Pe(t);var i=Nn.getPooled(Fn.mouseLeave,e,n,r);return i.type="mouseleave",i.target=a,i.relatedTarget=o,(n=Nn.getPooled(Fn.mouseEnter,t,n,r)).type="mouseenter",n.target=o,n.relatedTarget=a,je(i,n,e,t),[i,n]}};function Un(e){var t=e;if(e.alternate)for(;t.return;)t=t.return;else{if(0!=(2&t.effectTag))return 1;for(;t.return;)if(0!=(2&(t=t.return).effectTag))return 1}return 3===t.tag?2:3}function An(e){return!!(e=e._reactInternalFiber)&&2===Un(e)}function Hn(e){2!==Un(e)&&J("188")}function Ln(e){var t=e.alternate;if(!t)return 3===(t=Un(e))&&J("188"),1===t?null:e;for(var n=e,r=t;;){var o=n.return,a=o?o.alternate:null;if(!o||!a)break;if(o.child===a.child){for(var i=o.child;i;){if(i===n)return Hn(o),e;if(i===r)return Hn(o),t;i=i.sibling}J("188")}if(n.return!==r.return)n=o,r=a;else{i=!1;for(var u=o.child;u;){if(u===n){i=!0,n=o,r=a;break}if(u===r){i=!0,r=o,n=a;break}u=u.sibling}if(!i){for(u=a.child;u;){if(u===n){i=!0,n=a,r=o;break}if(u===r){i=!0,r=a,n=o;break}u=u.sibling}i||J("189")}}n.alternate!==r&&J("190")}return 3!==n.tag&&J("188"),n.stateNode.current===n?e:t}var zn=Ge.extend({animationName:null,elapsedTime:null,pseudoElement:null}),Yn=Ge.extend({clipboardData:function(e){return"clipboardData"in e?e.clipboardData:window.clipboardData}}),jn=Mn.extend({relatedTarget:null});function Wn(e){var t=e.keyCode;return"charCode"in e?0===(e=e.charCode)&&13===t&&(e=13):e=t,10===e&&(e=13),32<=e||13===e?e:0}var Vn={Esc:"Escape",Spacebar:" ",Left:"ArrowLeft",Up:"ArrowUp",Right:"ArrowRight",Down:"ArrowDown",Del:"Delete",Win:"OS",Menu:"ContextMenu",Apps:"ContextMenu",Scroll:"ScrollLock",MozPrintableKey:"Unidentified"},$n={8:"Backspace",9:"Tab",12:"Clear",13:"Enter",16:"Shift",17:"Control",18:"Alt",19:"Pause",20:"CapsLock",27:"Escape",32:" ",33:"PageUp",34:"PageDown",35:"End",36:"Home",37:"ArrowLeft",38:"ArrowUp",39:"ArrowRight",40:"ArrowDown",45:"Insert",46:"Delete",112:"F1",113:"F2",114:"F3",115:"F4",116:"F5",117:"F6",118:"F7",119:"F8",120:"F9",121:"F10",122:"F11",123:"F12",144:"NumLock",145:"ScrollLock",224:"Meta"},Bn=Mn.extend({key:function(e){if(e.key){var t=Vn[e.key]||e.key;if("Unidentified"!==t)return t}return"keypress"===e.type?13===(e=Wn(e))?"Enter":String.fromCharCode(e):"keydown"===e.type||"keyup"===e.type?$n[e.keyCode]||"Unidentified":""},location:null,ctrlKey:null,shiftKey:null,altKey:null,metaKey:null,repeat:null,locale:null,getModifierState:On,charCode:function(e){return"keypress"===e.type?Wn(e):0},keyCode:function(e){return"keydown"===e.type||"keyup"===e.type?e.keyCode:0},which:function(e){return"keypress"===e.type?Wn(e):"keydown"===e.type||"keyup"===e.type?e.keyCode:0}}),Kn=Nn.extend({dataTransfer:null}),Qn=Mn.extend({touches:null,targetTouches:null,changedTouches:null,altKey:null,metaKey:null,ctrlKey:null,shiftKey:null,getModifierState:On}),qn=Ge.extend({propertyName:null,elapsedTime:null,pseudoElement:null}),Xn=Nn.extend({deltaX:function(e){return"deltaX"in e?e.deltaX:"wheelDeltaX"in e?-e.wheelDeltaX:0},deltaY:function(e){return"deltaY"in e?e.deltaY:"wheelDeltaY"in e?-e.wheelDeltaY:"wheelDelta"in e?-e.wheelDelta:0},deltaZ:null,deltaMode:null}),Gn={},Zn={};function Jn(e,t){var n=e[0].toUpperCase()+e.slice(1),r="on"+n;t={phasedRegistrationNames:{bubbled:r,captured:r+"Capture"},dependencies:[n="top"+n],isInteractive:t},Gn[e]=t,Zn[n]=t}"blur cancel click close contextMenu copy cut doubleClick dragEnd dragStart drop focus input invalid keyDown keyPress keyUp mouseDown mouseUp paste pause play rateChange reset seeked submit touchCancel touchEnd touchStart volumeChange".split(" ").forEach(function(e){Jn(e,!0)}),"abort animationEnd animationIteration animationStart canPlay canPlayThrough drag dragEnter dragExit dragLeave dragOver durationChange emptied encrypted ended error load loadedData loadedMetadata loadStart mouseMove mouseOut mouseOver playing progress scroll seeking stalled suspend timeUpdate toggle touchMove transitionEnd waiting wheel".split(" ").forEach(function(e){Jn(e,!1)});var er={eventTypes:Gn,isInteractiveTopLevelEventType:function(e){return void 0!==(e=Zn[e])&&!0===e.isInteractive},extractEvents:function(e,t,n,r){var o=Zn[e];if(!o)return null;switch(e){case"topKeyPress":if(0===Wn(n))return null;case"topKeyDown":case"topKeyUp":e=Bn;break;case"topBlur":case"topFocus":e=jn;break;case"topClick":if(2===n.button)return null;case"topDoubleClick":case"topMouseDown":case"topMouseMove":case"topMouseUp":case"topMouseOut":case"topMouseOver":case"topContextMenu":e=Nn;break;case"topDrag":case"topDragEnd":case"topDragEnter":case"topDragExit":case"topDragLeave":case"topDragOver":case"topDragStart":case"topDrop":e=Kn;break;case"topTouchCancel":case"topTouchEnd":case"topTouchMove":case"topTouchStart":e=Qn;break;case"topAnimationEnd":case"topAnimationIteration":case"topAnimationStart":e=zn;break;case"topTransitionEnd":e=qn;break;case"topScroll":e=Mn;break;case"topWheel":e=Xn;break;case"topCopy":case"topCut":case"topPaste":e=Yn;break;default:e=Ge}return Ye(t=e.getPooled(o,t,n,r)),t}},tr=er.isInteractiveTopLevelEventType,nr=[];function rr(e){var t=e.targetInst;do{if(!t){e.ancestors.push(t);break}var n;for(n=t;n.return;)n=n.return;if(!(n=3!==n.tag?null:n.stateNode.containerInfo))break;e.ancestors.push(t),t=Ie(n)}while(t);for(n=0;n<e.ancestors.length;n++)t=e.ancestors[n],Se(e.topLevelType,t,e.nativeEvent,Pt(e.nativeEvent))}var or=!0;function ar(e){or=!!e}function ir(e,t,n){if(!n)return null;e=(tr(e)?lr:sr).bind(null,e),n.addEventListener(t,e,!1)}function ur(e,t,n){if(!n)return null;e=(tr(e)?lr:sr).bind(null,e),n.addEventListener(t,e,!0)}function lr(e,t){St(sr,e,t)}function sr(e,t){if(or){var n=Pt(t);if(null!==(n=Ie(n))&&"number"==typeof n.tag&&2!==Un(n)&&(n=null),nr.length){var r=nr.pop();r.topLevelType=e,r.nativeEvent=t,r.targetInst=n,e=r}else e={topLevelType:e,nativeEvent:t,targetInst:n,ancestors:[]};try{Dt(rr,e)}finally{e.topLevelType=null,e.nativeEvent=null,e.targetInst=null,e.ancestors.length=0,10>nr.length&&nr.push(e)}}}var cr=Object.freeze({get _enabled(){return or},setEnabled:ar,isEnabled:function(){return or},trapBubbledEvent:ir,trapCapturedEvent:ur,dispatchEvent:sr});function fr(e,t){var n={};return n[e.toLowerCase()]=t.toLowerCase(),n["Webkit"+e]="webkit"+t,n["Moz"+e]="moz"+t,n["ms"+e]="MS"+t,n["O"+e]="o"+t.toLowerCase(),n}var dr={animationend:fr("Animation","AnimationEnd"),animationiteration:fr("Animation","AnimationIteration"),animationstart:fr("Animation","AnimationStart"),transitionend:fr("Transition","TransitionEnd")},pr={},hr={};function mr(e){if(pr[e])return pr[e];if(!dr[e])return e;var t,n=dr[e];for(t in n)if(n.hasOwnProperty(t)&&t in hr)return pr[e]=n[t];return e}$.canUseDOM&&(hr=document.createElement("div").style,"AnimationEvent"in window||(delete dr.animationend.animation,delete dr.animationiteration.animation,delete dr.animationstart.animation),"TransitionEvent"in window||delete dr.transitionend.transition);var gr={topAnimationEnd:mr("animationend"),topAnimationIteration:mr("animationiteration"),topAnimationStart:mr("animationstart"),topBlur:"blur",topCancel:"cancel",topChange:"change",topClick:"click",topClose:"close",topCompositionEnd:"compositionend",topCompositionStart:"compositionstart",topCompositionUpdate:"compositionupdate",topContextMenu:"contextmenu",topCopy:"copy",topCut:"cut",topDoubleClick:"dblclick",topDrag:"drag",topDragEnd:"dragend",topDragEnter:"dragenter",topDragExit:"dragexit",topDragLeave:"dragleave",topDragOver:"dragover",topDragStart:"dragstart",topDrop:"drop",topFocus:"focus",topInput:"input",topKeyDown:"keydown",topKeyPress:"keypress",topKeyUp:"keyup",topLoad:"load",topLoadStart:"loadstart",topMouseDown:"mousedown",topMouseMove:"mousemove",topMouseOut:"mouseout",topMouseOver:"mouseover",topMouseUp:"mouseup",topPaste:"paste",topScroll:"scroll",topSelectionChange:"selectionchange",topTextInput:"textInput",topToggle:"toggle",topTouchCancel:"touchcancel",topTouchEnd:"touchend",topTouchMove:"touchmove",topTouchStart:"touchstart",topTransitionEnd:mr("transitionend"),topWheel:"wheel"},vr={topAbort:"abort",topCanPlay:"canplay",topCanPlayThrough:"canplaythrough",topDurationChange:"durationchange",topEmptied:"emptied",topEncrypted:"encrypted",topEnded:"ended",topError:"error",topLoadedData:"loadeddata",topLoadedMetadata:"loadedmetadata",topLoadStart:"loadstart",topPause:"pause",topPlay:"play",topPlaying:"playing",topProgress:"progress",topRateChange:"ratechange",topSeeked:"seeked",topSeeking:"seeking",topStalled:"stalled",topSuspend:"suspend",topTimeUpdate:"timeupdate",topVolumeChange:"volumechange",topWaiting:"waiting"},yr={},br=0,wr="_reactListenersID"+(""+Math.random()).slice(2);function kr(e){return Object.prototype.hasOwnProperty.call(e,wr)||(e[wr]=br++,yr[e[wr]]={}),yr[e[wr]]}function Cr(e){for(;e&&e.firstChild;)e=e.firstChild;return e}function xr(e,t){var n,r=Cr(e);for(e=0;r;){if(3===r.nodeType){if(n=e+r.textContent.length,e<=t&&n>=t)return{node:r,offset:t-e};e=n}e:{for(;r;){if(r.nextSibling){r=r.nextSibling;break e}r=r.parentNode}r=void 0}r=Cr(r)}}function Tr(e){var t=e&&e.nodeName&&e.nodeName.toLowerCase();return t&&("input"===t&&"text"===e.type||"textarea"===t||"true"===e.contentEditable)}var Sr=$.canUseDOM&&"documentMode"in document&&11>=document.documentMode,Er={select:{phasedRegistrationNames:{bubbled:"onSelect",captured:"onSelectCapture"},dependencies:"topBlur topContextMenu topFocus topKeyDown topKeyUp topMouseDown topMouseUp topSelectionChange".split(" ")}},_r=null,Dr=null,Mr=null,Ir=!1;function Pr(e,t){if(Ir||null==_r||_r!==B())return null;var n=_r;return"selectionStart"in n&&Tr(n)?n={start:n.selectionStart,end:n.selectionEnd}:window.getSelection?n={anchorNode:(n=window.getSelection()).anchorNode,anchorOffset:n.anchorOffset,focusNode:n.focusNode,focusOffset:n.focusOffset}:n=void 0,Mr&&q(Mr,n)?null:(Mr=n,(e=Ge.getPooled(Er.select,Dr,e,t)).type="select",e.target=_r,Ye(e),e)}var Or={eventTypes:Er,extractEvents:function(e,t,n,r){var o,a=r.window===r?r.document:9===r.nodeType?r:r.ownerDocument;if(!(o=!a)){e:{a=kr(a),o=le.onSelect;for(var i=0;i<o.length;i++){var u=o[i];if(!a.hasOwnProperty(u)||!a[u]){a=!1;break e}}a=!0}o=!a}if(o)return null;switch(a=t?Pe(t):window,e){case"topFocus":(It(a)||"true"===a.contentEditable)&&(_r=a,Dr=t,Mr=null);break;case"topBlur":Mr=Dr=_r=null;break;case"topMouseDown":Ir=!0;break;case"topContextMenu":case"topMouseUp":return Ir=!1,Pr(n,r);case"topSelectionChange":if(Sr)break;case"topKeyDown":case"topKeyUp":return Pr(n,r)}return null}};function Nr(e,t,n,r){this.tag=e,this.key=n,this.stateNode=this.type=null,this.sibling=this.child=this.return=null,this.index=0,this.ref=null,this.pendingProps=t,this.memoizedState=this.updateQueue=this.memoizedProps=null,this.mode=r,this.effectTag=0,this.lastEffect=this.firstEffect=this.nextEffect=null,this.expirationTime=0,this.alternate=null}function Fr(e,t,n){var r=e.alternate;return null===r?((r=new Nr(e.tag,t,e.key,e.mode)).type=e.type,r.stateNode=e.stateNode,r.alternate=e,e.alternate=r):(r.pendingProps=t,r.effectTag=0,r.nextEffect=null,r.firstEffect=null,r.lastEffect=null),r.expirationTime=n,r.child=e.child,r.memoizedProps=e.memoizedProps,r.memoizedState=e.memoizedState,r.updateQueue=e.updateQueue,r.sibling=e.sibling,r.index=e.index,r.ref=e.ref,r}function Rr(e,t,n){var r=e.type,o=e.key;e=e.props;var a=void 0;if("function"==typeof r)a=r.prototype&&r.prototype.isReactComponent?2:0;else if("string"==typeof r)a=5;else switch(r){case jt:return Ur(e.children,t,n,o);case Bt:a=11,t|=3;break;case Wt:a=11,t|=2;break;case Lt:a=7;break;case zt:a=9;break;default:if("object"==typeof r&&null!==r)switch(r.$$typeof){case Vt:a=13;break;case $t:a=12;break;case Kt:a=14;break;default:if("number"==typeof r.tag)return(t=r).pendingProps=e,t.expirationTime=n,t;J("130",null==r?r:typeof r,"")}else J("130",null==r?r:typeof r,"")}return(t=new Nr(a,e,o,t)).type=r,t.expirationTime=n,t}function Ur(e,t,n,r){return(e=new Nr(10,e,r,t)).expirationTime=n,e}function Ar(e,t,n){return(e=new Nr(6,e,null,t)).expirationTime=n,e}function Hr(e,t,n){return(t=new Nr(4,null!==e.children?e.children:[],e.key,t)).expirationTime=n,t.stateNode={containerInfo:e.containerInfo,pendingChildren:null,implementation:e.implementation},t}Ce.injectEventPluginOrder("ResponderEventPlugin SimpleEventPlugin TapEventPlugin EnterLeaveEventPlugin ChangeEventPlugin SelectEventPlugin BeforeInputEventPlugin".split(" ")),de=Ne.getFiberCurrentPropsFromNode,pe=Ne.getInstanceFromNode,he=Ne.getNodeFromInstance,Ce.injectEventPluginsByName({SimpleEventPlugin:er,EnterLeaveEventPlugin:Rn,ChangeEventPlugin:Dn,SelectEventPlugin:Or,BeforeInputEventPlugin:ht});var Lr=null,zr=null;function Yr(e){return function(t){try{return e(t)}catch(e){}}}function jr(e){"function"==typeof Lr&&Lr(e)}function Wr(e){"function"==typeof zr&&zr(e)}function Vr(e){return{baseState:e,expirationTime:0,first:null,last:null,callbackList:null,hasForceUpdate:!1,isInitialized:!1,capturedValues:null}}function $r(e,t){null===e.last?e.first=e.last=t:(e.last.next=t,e.last=t),(0===e.expirationTime||e.expirationTime>t.expirationTime)&&(e.expirationTime=t.expirationTime)}var Br=void 0,Kr=void 0;function Qr(e){Br=Kr=null;var t=e.alternate,n=e.updateQueue;null===n&&(n=e.updateQueue=Vr(null)),null!==t?null===(e=t.updateQueue)&&(e=t.updateQueue=Vr(null)):e=null,Br=n,Kr=e!==n?e:null}function qr(e,t){Qr(e),e=Br;var n=Kr;null===n?$r(e,t):null===e.last||null===n.last?($r(e,t),$r(n,t)):($r(e,t),n.last=t)}function Xr(e,t,n,r){return"function"==typeof(e=e.partialState)?e.call(t,n,r):e}function Gr(e,t,n,r,a,i){null!==e&&e.updateQueue===n&&(n=t.updateQueue={baseState:n.baseState,expirationTime:n.expirationTime,first:n.first,last:n.last,isInitialized:n.isInitialized,capturedValues:n.capturedValues,callbackList:null,hasForceUpdate:!1}),n.expirationTime=0,n.isInitialized?e=n.baseState:(e=n.baseState=t.memoizedState,n.isInitialized=!0);for(var u=!0,l=n.first,s=!1;null!==l;){var c=l.expirationTime;if(c>i){var f=n.expirationTime;(0===f||f>c)&&(n.expirationTime=c),s||(s=!0,n.baseState=e)}else s||(n.first=l.next,null===n.first&&(n.last=null)),l.isReplace?(e=Xr(l,r,e,a),u=!0):(c=Xr(l,r,e,a))&&(e=u?o({},e,c):o(e,c),u=!1),l.isForced&&(n.hasForceUpdate=!0),null!==l.callback&&(null===(c=n.callbackList)&&(c=n.callbackList=[]),c.push(l)),null!==l.capturedValue&&(null===(c=n.capturedValues)?n.capturedValues=[l.capturedValue]:c.push(l.capturedValue));l=l.next}return null!==n.callbackList?t.effectTag|=32:null!==n.first||n.hasForceUpdate||null!==n.capturedValues||(t.updateQueue=null),s||(n.baseState=e),e}function Zr(e,t){var n=e.callbackList;if(null!==n)for(e.callbackList=null,e=0;e<n.length;e++){var r=n[e],o=r.callback;r.callback=null,"function"!=typeof o&&J("191",o),o.call(t)}}var Jr=Array.isArray;function eo(e,t,n){if(null!==(e=n.ref)&&"function"!=typeof e&&"object"!=typeof e){if(n._owner){var r=void 0;(n=n._owner)&&(2!==n.tag&&J("110"),r=n.stateNode),r||J("147",e);var o=""+e;return null!==t&&null!==t.ref&&t.ref._stringRef===o?t.ref:((t=function(e){var t=r.refs===a?r.refs={}:r.refs;null===e?delete t[o]:t[o]=e})._stringRef=o,t)}"string"!=typeof e&&J("148"),n._owner||J("254",e)}return e}function to(e,t){"textarea"!==e.type&&J("31","[object Object]"===Object.prototype.toString.call(t)?"object with keys {"+Object.keys(t).join(", ")+"}":t,"")}function no(e){function t(t,n){if(e){var r=t.lastEffect;null!==r?(r.nextEffect=n,t.lastEffect=n):t.firstEffect=t.lastEffect=n,n.nextEffect=null,n.effectTag=8}}function n(n,r){if(!e)return null;for(;null!==r;)t(n,r),r=r.sibling;return null}function r(e,t){for(e=new Map;null!==t;)null!==t.key?e.set(t.key,t):e.set(t.index,t),t=t.sibling;return e}function o(e,t,n){return(e=Fr(e,t,n)).index=0,e.sibling=null,e}function a(t,n,r){return t.index=r,e?null!==(r=t.alternate)?(r=r.index)<n?(t.effectTag=2,n):r:(t.effectTag=2,n):n}function i(t){return e&&null===t.alternate&&(t.effectTag=2),t}function u(e,t,n,r){return null===t||6!==t.tag?((t=Ar(n,e.mode,r)).return=e,t):((t=o(t,n,r)).return=e,t)}function l(e,t,n,r){return null!==t&&t.type===n.type?((r=o(t,n.props,r)).ref=eo(e,t,n),r.return=e,r):((r=Rr(n,e.mode,r)).ref=eo(e,t,n),r.return=e,r)}function s(e,t,n,r){return null===t||4!==t.tag||t.stateNode.containerInfo!==n.containerInfo||t.stateNode.implementation!==n.implementation?((t=Hr(n,e.mode,r)).return=e,t):((t=o(t,n.children||[],r)).return=e,t)}function c(e,t,n,r,a){return null===t||10!==t.tag?((t=Ur(n,e.mode,r,a)).return=e,t):((t=o(t,n,r)).return=e,t)}function f(e,t,n){if("string"==typeof t||"number"==typeof t)return(t=Ar(""+t,e.mode,n)).return=e,t;if("object"==typeof t&&null!==t){switch(t.$$typeof){case Ht:return(n=Rr(t,e.mode,n)).ref=eo(e,null,t),n.return=e,n;case Yt:return(t=Hr(t,e.mode,n)).return=e,t}if(Jr(t)||qt(t))return(t=Ur(t,e.mode,n,null)).return=e,t;to(e,t)}return null}function d(e,t,n,r){var o=null!==t?t.key:null;if("string"==typeof n||"number"==typeof n)return null!==o?null:u(e,t,""+n,r);if("object"==typeof n&&null!==n){switch(n.$$typeof){case Ht:return n.key===o?n.type===jt?c(e,t,n.props.children,r,o):l(e,t,n,r):null;case Yt:return n.key===o?s(e,t,n,r):null}if(Jr(n)||qt(n))return null!==o?null:c(e,t,n,r,null);to(e,n)}return null}function p(e,t,n,r,o){if("string"==typeof r||"number"==typeof r)return u(t,e=e.get(n)||null,""+r,o);if("object"==typeof r&&null!==r){switch(r.$$typeof){case Ht:return e=e.get(null===r.key?n:r.key)||null,r.type===jt?c(t,e,r.props.children,o,r.key):l(t,e,r,o);case Yt:return s(t,e=e.get(null===r.key?n:r.key)||null,r,o)}if(Jr(r)||qt(r))return c(t,e=e.get(n)||null,r,o,null);to(t,r)}return null}function h(o,i,u,l){for(var s=null,c=null,h=i,m=i=0,g=null;null!==h&&m<u.length;m++){h.index>m?(g=h,h=null):g=h.sibling;var v=d(o,h,u[m],l);if(null===v){null===h&&(h=g);break}e&&h&&null===v.alternate&&t(o,h),i=a(v,i,m),null===c?s=v:c.sibling=v,c=v,h=g}if(m===u.length)return n(o,h),s;if(null===h){for(;m<u.length;m++)(h=f(o,u[m],l))&&(i=a(h,i,m),null===c?s=h:c.sibling=h,c=h);return s}for(h=r(o,h);m<u.length;m++)(g=p(h,o,m,u[m],l))&&(e&&null!==g.alternate&&h.delete(null===g.key?m:g.key),i=a(g,i,m),null===c?s=g:c.sibling=g,c=g);return e&&h.forEach(function(e){return t(o,e)}),s}function m(o,i,u,l){var s=qt(u);"function"!=typeof s&&J("150"),null==(u=s.call(u))&&J("151");for(var c=s=null,h=i,m=i=0,g=null,v=u.next();null!==h&&!v.done;m++,v=u.next()){h.index>m?(g=h,h=null):g=h.sibling;var y=d(o,h,v.value,l);if(null===y){h||(h=g);break}e&&h&&null===y.alternate&&t(o,h),i=a(y,i,m),null===c?s=y:c.sibling=y,c=y,h=g}if(v.done)return n(o,h),s;if(null===h){for(;!v.done;m++,v=u.next())null!==(v=f(o,v.value,l))&&(i=a(v,i,m),null===c?s=v:c.sibling=v,c=v);return s}for(h=r(o,h);!v.done;m++,v=u.next())null!==(v=p(h,o,m,v.value,l))&&(e&&null!==v.alternate&&h.delete(null===v.key?m:v.key),i=a(v,i,m),null===c?s=v:c.sibling=v,c=v);return e&&h.forEach(function(e){return t(o,e)}),s}return function(e,r,a,u){"object"==typeof a&&null!==a&&a.type===jt&&null===a.key&&(a=a.props.children);var l="object"==typeof a&&null!==a;if(l)switch(a.$$typeof){case Ht:e:{var s=a.key;for(l=r;null!==l;){if(l.key===s){if(10===l.tag?a.type===jt:l.type===a.type){n(e,l.sibling),(r=o(l,a.type===jt?a.props.children:a.props,u)).ref=eo(e,l,a),r.return=e,e=r;break e}n(e,l);break}t(e,l),l=l.sibling}a.type===jt?((r=Ur(a.props.children,e.mode,u,a.key)).return=e,e=r):((u=Rr(a,e.mode,u)).ref=eo(e,r,a),u.return=e,e=u)}return i(e);case Yt:e:{for(l=a.key;null!==r;){if(r.key===l){if(4===r.tag&&r.stateNode.containerInfo===a.containerInfo&&r.stateNode.implementation===a.implementation){n(e,r.sibling),(r=o(r,a.children||[],u)).return=e,e=r;break e}n(e,r);break}t(e,r),r=r.sibling}(r=Hr(a,e.mode,u)).return=e,e=r}return i(e)}if("string"==typeof a||"number"==typeof a)return a=""+a,null!==r&&6===r.tag?(n(e,r.sibling),r=o(r,a,u)):(n(e,r),r=Ar(a,e.mode,u)),r.return=e,i(e=r);if(Jr(a))return h(e,r,a,u);if(qt(a))return m(e,r,a,u);if(l&&to(e,a),void 0===a)switch(e.tag){case 2:case 1:J("152",(u=e.type).displayName||u.name||"Component")}return n(e,r)}}var ro=no(!0),oo=no(!1);function ao(e,t,n,r,i,u,l){function s(e,t,n){c(e,t,n,t.expirationTime)}function c(e,t,n,r){t.child=null===e?oo(t,null,n,r):ro(t,e.child,n,r)}function f(e,t){var n=t.ref;(null===e&&null!==n||null!==e&&e.ref!==n)&&(t.effectTag|=128)}function d(e,t,n,r,o,a){if(f(e,t),!n&&!o)return r&&E(t,!1),m(e,t);n=t.stateNode,Ut.current=t;var i=o?null:n.render();return t.effectTag|=1,o&&(c(e,t,null,a),t.child=null),c(e,t,i,a),t.memoizedState=n.state,t.memoizedProps=n.props,r&&E(t,!0),t.child}function p(e){var t=e.stateNode;t.pendingContext?S(e,t.pendingContext,t.pendingContext!==t.context):t.context&&S(e,t.context,!1),b(e,t.containerInfo)}function h(e,t,n,r){var o=e.child;for(null!==o&&(o.return=e);null!==o;){switch(o.tag){case 12:var a=0|o.stateNode;if(o.type===t&&0!=(a&n)){for(a=o;null!==a;){var i=a.alternate;if(0===a.expirationTime||a.expirationTime>r)a.expirationTime=r,null!==i&&(0===i.expirationTime||i.expirationTime>r)&&(i.expirationTime=r);else{if(null===i||!(0===i.expirationTime||i.expirationTime>r))break;i.expirationTime=r}a=a.return}a=null}else a=o.child;break;case 13:a=o.type===e.type?null:o.child;break;default:a=o.child}if(null!==a)a.return=o;else for(a=o;null!==a;){if(a===e){a=null;break}if(null!==(o=a.sibling)){a=o;break}a=a.return}o=a}}function m(e,t){if(null!==e&&t.child!==e.child&&J("153"),null!==t.child){var n=Fr(e=t.child,e.pendingProps,e.expirationTime);for(t.child=n,n.return=t;null!==e.sibling;)e=e.sibling,(n=n.sibling=Fr(e,e.pendingProps,e.expirationTime)).return=t;n.sibling=null}return t.child}var g=e.shouldSetTextContent,v=e.shouldDeprioritizeSubtree,y=t.pushHostContext,b=t.pushHostContainer,w=r.pushProvider,k=n.getMaskedContext,C=n.getUnmaskedContext,x=n.hasContextChanged,T=n.pushContextProvider,S=n.pushTopLevelContextObject,E=n.invalidateContextProvider,_=i.enterHydrationState,D=i.resetHydrationState,M=i.tryToClaimNextHydratableInstance,I=(e=function(e,t,n,r,i){function u(e,t,n,r,o,a){if(null===t||null!==e.updateQueue&&e.updateQueue.hasForceUpdate)return!0;var i=e.stateNode;return e=e.type,"function"==typeof i.shouldComponentUpdate?i.shouldComponentUpdate(n,o,a):!(e.prototype&&e.prototype.isPureReactComponent&&q(t,n)&&q(r,o))}function l(e,t){t.updater=g,e.stateNode=t,t._reactInternalFiber=e}function s(e,t,n,r){e=t.state,"function"==typeof t.componentWillReceiveProps&&t.componentWillReceiveProps(n,r),"function"==typeof t.UNSAFE_componentWillReceiveProps&&t.UNSAFE_componentWillReceiveProps(n,r),t.state!==e&&g.enqueueReplaceState(t,t.state,null)}function c(e,t,n,r){if("function"==typeof(e=e.type).getDerivedStateFromProps)return e.getDerivedStateFromProps.call(null,n,r)}var f=e.cacheContext,d=e.getMaskedContext,p=e.getUnmaskedContext,h=e.isContextConsumer,m=e.hasContextChanged,g={isMounted:An,enqueueSetState:function(e,r,o){e=e._reactInternalFiber,o=void 0===o?null:o;var a=n(e);qr(e,{expirationTime:a,partialState:r,callback:o,isReplace:!1,isForced:!1,capturedValue:null,next:null}),t(e,a)},enqueueReplaceState:function(e,r,o){e=e._reactInternalFiber,o=void 0===o?null:o;var a=n(e);qr(e,{expirationTime:a,partialState:r,callback:o,isReplace:!0,isForced:!1,capturedValue:null,next:null}),t(e,a)},enqueueForceUpdate:function(e,r){e=e._reactInternalFiber,r=void 0===r?null:r;var o=n(e);qr(e,{expirationTime:o,partialState:null,callback:r,isReplace:!1,isForced:!0,capturedValue:null,next:null}),t(e,o)}};return{adoptClassInstance:l,callGetDerivedStateFromProps:c,constructClassInstance:function(e,t){var n=e.type,r=p(e),i=h(e),u=i?d(e,r):a,s=null!==(n=new n(t,u)).state&&void 0!==n.state?n.state:null;return l(e,n),e.memoizedState=s,null!==(t=c(e,0,t,s))&&void 0!==t&&(e.memoizedState=o({},e.memoizedState,t)),i&&f(e,r,u),n},mountClassInstance:function(e,t){var n=e.type,r=e.alternate,o=e.stateNode,i=e.pendingProps,u=p(e);o.props=i,o.state=e.memoizedState,o.refs=a,o.context=d(e,u),"function"==typeof n.getDerivedStateFromProps||"function"==typeof o.getSnapshotBeforeUpdate||"function"!=typeof o.UNSAFE_componentWillMount&&"function"!=typeof o.componentWillMount||(n=o.state,"function"==typeof o.componentWillMount&&o.componentWillMount(),"function"==typeof o.UNSAFE_componentWillMount&&o.UNSAFE_componentWillMount(),n!==o.state&&g.enqueueReplaceState(o,o.state,null),null!==(n=e.updateQueue)&&(o.state=Gr(r,e,n,o,i,t))),"function"==typeof o.componentDidMount&&(e.effectTag|=4)},resumeMountClassInstance:function(e,t){var n=e.type,a=e.stateNode;a.props=e.memoizedProps,a.state=e.memoizedState;var l=e.memoizedProps,f=e.pendingProps,h=a.context,g=p(e);g=d(e,g),(n="function"==typeof n.getDerivedStateFromProps||"function"==typeof a.getSnapshotBeforeUpdate)||"function"!=typeof a.UNSAFE_componentWillReceiveProps&&"function"!=typeof a.componentWillReceiveProps||(l!==f||h!==g)&&s(e,a,f,g),h=e.memoizedState,t=null!==e.updateQueue?Gr(null,e,e.updateQueue,a,f,t):h;var v=void 0;return l!==f&&(v=c(e,0,f,t)),null!==v&&void 0!==v&&(t=null===t||void 0===t?v:o({},t,v)),l!==f||h!==t||m()||null!==e.updateQueue&&e.updateQueue.hasForceUpdate?((l=u(e,l,f,h,t,g))?(n||"function"!=typeof a.UNSAFE_componentWillMount&&"function"!=typeof a.componentWillMount||("function"==typeof a.componentWillMount&&a.componentWillMount(),"function"==typeof a.UNSAFE_componentWillMount&&a.UNSAFE_componentWillMount()),"function"==typeof a.componentDidMount&&(e.effectTag|=4)):("function"==typeof a.componentDidMount&&(e.effectTag|=4),r(e,f),i(e,t)),a.props=f,a.state=t,a.context=g,l):("function"==typeof a.componentDidMount&&(e.effectTag|=4),!1)},updateClassInstance:function(e,t,n){var a=t.type,l=t.stateNode;l.props=t.memoizedProps,l.state=t.memoizedState;var f=t.memoizedProps,h=t.pendingProps,g=l.context,v=p(t);v=d(t,v),(a="function"==typeof a.getDerivedStateFromProps||"function"==typeof l.getSnapshotBeforeUpdate)||"function"!=typeof l.UNSAFE_componentWillReceiveProps&&"function"!=typeof l.componentWillReceiveProps||(f!==h||g!==v)&&s(t,l,h,v),g=t.memoizedState,n=null!==t.updateQueue?Gr(e,t,t.updateQueue,l,h,n):g;var y=void 0;return f!==h&&(y=c(t,0,h,n)),null!==y&&void 0!==y&&(n=null===n||void 0===n?y:o({},n,y)),f!==h||g!==n||m()||null!==t.updateQueue&&t.updateQueue.hasForceUpdate?((y=u(t,f,h,g,n,v))?(a||"function"!=typeof l.UNSAFE_componentWillUpdate&&"function"!=typeof l.componentWillUpdate||("function"==typeof l.componentWillUpdate&&l.componentWillUpdate(h,n,v),"function"==typeof l.UNSAFE_componentWillUpdate&&l.UNSAFE_componentWillUpdate(h,n,v)),"function"==typeof l.componentDidUpdate&&(t.effectTag|=4),"function"==typeof l.getSnapshotBeforeUpdate&&(t.effectTag|=2048)):("function"!=typeof l.componentDidUpdate||f===e.memoizedProps&&g===e.memoizedState||(t.effectTag|=4),"function"!=typeof l.getSnapshotBeforeUpdate||f===e.memoizedProps&&g===e.memoizedState||(t.effectTag|=2048),r(t,h),i(t,n)),l.props=h,l.state=n,l.context=v,y):("function"!=typeof l.componentDidUpdate||f===e.memoizedProps&&g===e.memoizedState||(t.effectTag|=4),"function"!=typeof l.getSnapshotBeforeUpdate||f===e.memoizedProps&&g===e.memoizedState||(t.effectTag|=2048),!1)}}}(n,u,l,function(e,t){e.memoizedProps=t},function(e,t){e.memoizedState=t})).adoptClassInstance,P=e.callGetDerivedStateFromProps,O=e.constructClassInstance,N=e.mountClassInstance,F=e.resumeMountClassInstance,R=e.updateClassInstance;return{beginWork:function(e,t,n){if(0===t.expirationTime||t.expirationTime>n){switch(t.tag){case 3:p(t);break;case 2:T(t);break;case 4:b(t,t.stateNode.containerInfo);break;case 13:w(t)}return null}switch(t.tag){case 0:null!==e&&J("155");var r=t.type,a=t.pendingProps,i=C(t);return r=r(a,i=k(t,i)),t.effectTag|=1,"object"==typeof r&&null!==r&&"function"==typeof r.render&&void 0===r.$$typeof?(i=t.type,t.tag=2,t.memoizedState=null!==r.state&&void 0!==r.state?r.state:null,"function"==typeof i.getDerivedStateFromProps&&(null!==(a=P(t,r,a,t.memoizedState))&&void 0!==a&&(t.memoizedState=o({},t.memoizedState,a))),a=T(t),I(t,r),N(t,n),e=d(e,t,!0,a,!1,n)):(t.tag=1,s(e,t,r),t.memoizedProps=a,e=t.child),e;case 1:return a=t.type,n=t.pendingProps,x()||t.memoizedProps!==n?(r=C(t),a=a(n,r=k(t,r)),t.effectTag|=1,s(e,t,a),t.memoizedProps=n,e=t.child):e=m(e,t),e;case 2:a=T(t),null===e?null===t.stateNode?(O(t,t.pendingProps),N(t,n),r=!0):r=F(t,n):r=R(e,t,n),i=!1;var u=t.updateQueue;return null!==u&&null!==u.capturedValues&&(i=r=!0),d(e,t,r,a,i,n);case 3:e:if(p(t),r=t.updateQueue,null!==r){if(i=t.memoizedState,a=Gr(e,t,r,null,null,n),t.memoizedState=a,null!==(r=t.updateQueue)&&null!==r.capturedValues)r=null;else{if(i===a){D(),e=m(e,t);break e}r=a.element}i=t.stateNode,(null===e||null===e.child)&&i.hydrate&&_(t)?(t.effectTag|=2,t.child=oo(t,null,r,n)):(D(),s(e,t,r)),t.memoizedState=a,e=t.child}else D(),e=m(e,t);return e;case 5:return y(t),null===e&&M(t),a=t.type,u=t.memoizedProps,r=t.pendingProps,i=null!==e?e.memoizedProps:null,x()||u!==r||((u=1&t.mode&&v(a,r))&&(t.expirationTime=1073741823),u&&1073741823===n)?(u=r.children,g(a,r)?u=null:i&&g(a,i)&&(t.effectTag|=16),f(e,t),1073741823!==n&&1&t.mode&&v(a,r)?(t.expirationTime=1073741823,t.memoizedProps=r,e=null):(s(e,t,u),t.memoizedProps=r,e=t.child)):e=m(e,t),e;case 6:return null===e&&M(t),t.memoizedProps=t.pendingProps,null;case 8:t.tag=7;case 7:return a=t.pendingProps,x()||t.memoizedProps!==a||(a=t.memoizedProps),r=a.children,t.stateNode=null===e?oo(t,t.stateNode,r,n):ro(t,e.stateNode,r,n),t.memoizedProps=a,t.stateNode;case 9:return null;case 4:return b(t,t.stateNode.containerInfo),a=t.pendingProps,x()||t.memoizedProps!==a?(null===e?t.child=ro(t,null,a,n):s(e,t,a),t.memoizedProps=a,e=t.child):e=m(e,t),e;case 14:return s(e,t,n=(n=t.type.render)(t.pendingProps,t.ref)),t.memoizedProps=n,t.child;case 10:return n=t.pendingProps,x()||t.memoizedProps!==n?(s(e,t,n),t.memoizedProps=n,e=t.child):e=m(e,t),e;case 11:return n=t.pendingProps.children,x()||null!==n&&t.memoizedProps!==n?(s(e,t,n),t.memoizedProps=n,e=t.child):e=m(e,t),e;case 13:return function(e,t,n){var r=t.type.context,o=t.pendingProps,a=t.memoizedProps;if(!x()&&a===o)return t.stateNode=0,w(t),m(e,t);var i=o.value;if(t.memoizedProps=o,null===a)i=1073741823;else if(a.value===o.value){if(a.children===o.children)return t.stateNode=0,w(t),m(e,t);i=0}else{var u=a.value;if(u===i&&(0!==u||1/u==1/i)||u!=u&&i!=i){if(a.children===o.children)return t.stateNode=0,w(t),m(e,t);i=0}else if(i="function"==typeof r._calculateChangedBits?r._calculateChangedBits(u,i):1073741823,0==(i|=0)){if(a.children===o.children)return t.stateNode=0,w(t),m(e,t)}else h(t,r,i,n)}return t.stateNode=i,w(t),s(e,t,o.children),t.child}(e,t,n);case 12:r=t.type,i=t.pendingProps;var l=t.memoizedProps;return a=r._currentValue,u=r._changedBits,x()||0!==u||l!==i?(t.memoizedProps=i,void 0!==(l=i.unstable_observedBits)&&null!==l||(l=1073741823),t.stateNode=l,0!=(u&l)&&h(t,r,u,n),s(e,t,n=(n=i.children)(a)),e=t.child):e=m(e,t),e;default:J("156")}}}}function io(e,t){var n=t.source;null===t.stack&&Gt(n),null!==n&&Xt(n),t=t.value,null!==e&&2===e.tag&&Xt(e);try{t&&t.suppressReactErrorLogging||console.error(t)}catch(e){e&&e.suppressReactErrorLogging||console.error(e)}}var uo={};function lo(e){function t(){if(null!==ee)for(var e=ee.return;null!==e;)N(e),e=e.return;te=null,ne=0,ee=null,ae=!1}function n(e){return null!==ie&&ie.has(e)}function r(e){for(;;){var t=e.alternate,n=e.return,r=e.sibling;if(0==(512&e.effectTag)){t=I(t,e,ne);var o=e;if(1073741823===ne||1073741823!==o.expirationTime){e:switch(o.tag){case 3:case 2:var a=o.updateQueue;a=null===a?0:a.expirationTime;break e;default:a=0}for(var i=o.child;null!==i;)0!==i.expirationTime&&(0===a||a>i.expirationTime)&&(a=i.expirationTime),i=i.sibling;o.expirationTime=a}if(null!==t)return t;if(null!==n&&0==(512&n.effectTag)&&(null===n.firstEffect&&(n.firstEffect=e.firstEffect),null!==e.lastEffect&&(null!==n.lastEffect&&(n.lastEffect.nextEffect=e.firstEffect),n.lastEffect=e.lastEffect),1<e.effectTag&&(null!==n.lastEffect?n.lastEffect.nextEffect=e:n.firstEffect=e,n.lastEffect=e)),null!==r)return r;if(null===n){ae=!0;break}e=n}else{if(null!==(e=O(e)))return e.effectTag&=2559,e;if(null!==n&&(n.firstEffect=n.lastEffect=null,n.effectTag|=512),null!==r)return r;if(null===n)break;e=n}}return null}function i(e){var t=M(e.alternate,e,ne);return null===t&&(t=r(e)),Ut.current=null,t}function u(e,n,o){Z&&J("243"),Z=!0,n===ne&&e===te&&null!==ee||(t(),ne=n,ee=Fr((te=e).current,null,ne),e.pendingCommitExpirationTime=0);for(var a=!1;;){try{if(o)for(;null!==ee&&!x();)ee=i(ee);else for(;null!==ee;)ee=i(ee)}catch(e){if(null===ee){a=!0,T(e);break}var u=(o=ee).return;if(null===u){a=!0,T(e);break}P(u,o,e),ee=r(o)}break}return Z=!1,a||null!==ee?null:ae?(e.pendingCommitExpirationTime=n,e.current.alternate):void J("262")}function l(e,t,n,r){qr(t,{expirationTime:r,partialState:null,callback:null,isReplace:!1,isForced:!1,capturedValue:e={value:n,source:e,stack:Gt(e)},next:null}),f(t,r)}function s(e,t){e:{Z&&!oe&&J("263");for(var r=e.return;null!==r;){switch(r.tag){case 2:var o=r.stateNode;if("function"==typeof r.type.getDerivedStateFromCatch||"function"==typeof o.componentDidCatch&&!n(o)){l(e,r,t,1),e=void 0;break e}break;case 3:l(e,r,t,1),e=void 0;break e}r=r.return}3===e.tag&&l(e,e,t,1),e=void 0}return e}function c(e){return e=0!==G?G:Z?oe?1:ne:1&e.mode?ke?10*(1+((d()+50)/10|0)):25*(1+((d()+500)/25|0)):1,ke&&(0===he||e>he)&&(he=e),e}function f(e,n){e:{for(;null!==e;){if((0===e.expirationTime||e.expirationTime>n)&&(e.expirationTime=n),null!==e.alternate&&(0===e.alternate.expirationTime||e.alternate.expirationTime>n)&&(e.alternate.expirationTime=n),null===e.return){if(3!==e.tag){n=void 0;break e}var r=e.stateNode;!Z&&0!==ne&&n<ne&&t(),Z&&!oe&&te===r||m(r,n),Te>xe&&J("185")}e=e.return}n=void 0}return n}function d(){return q=W()-Q,2+(q/10|0)}function p(e,t,n,r,o){var a=G;G=1;try{return e(t,n,r,o)}finally{G=a}}function h(e){if(0!==se){if(e>se)return;$(ce)}var t=W()-Q;se=e,ce=V(v,{timeout:10*(e-2)-t})}function m(e,t){if(null===e.nextScheduledRoot)e.remainingExpirationTime=t,null===le?(ue=le=e,e.nextScheduledRoot=e):(le=le.nextScheduledRoot=e).nextScheduledRoot=ue;else{var n=e.remainingExpirationTime;(0===n||t<n)&&(e.remainingExpirationTime=t)}fe||(be?we&&(de=e,pe=1,k(e,1,!1)):1===t?y():h(t))}function g(){var e=0,t=null;if(null!==le)for(var n=le,r=ue;null!==r;){var o=r.remainingExpirationTime;if(0===o){if((null===n||null===le)&&J("244"),r===r.nextScheduledRoot){ue=le=r.nextScheduledRoot=null;break}if(r===ue)ue=o=r.nextScheduledRoot,le.nextScheduledRoot=o,r.nextScheduledRoot=null;else{if(r===le){(le=n).nextScheduledRoot=ue,r.nextScheduledRoot=null;break}n.nextScheduledRoot=r.nextScheduledRoot,r.nextScheduledRoot=null}r=n.nextScheduledRoot}else{if((0===e||o<e)&&(e=o,t=r),r===le)break;n=r,r=r.nextScheduledRoot}}null!==(n=de)&&n===t&&1===e?Te++:Te=0,de=t,pe=e}function v(e){b(0,!0,e)}function y(){b(1,!1,null)}function b(e,t,n){if(ye=n,g(),t)for(;null!==de&&0!==pe&&(0===e||e>=pe)&&(!me||d()>=pe);)k(de,pe,!me),g();else for(;null!==de&&0!==pe&&(0===e||e>=pe);)k(de,pe,!1),g();null!==ye&&(se=0,ce=-1),0!==pe&&h(pe),ye=null,me=!1,w()}function w(){if(Te=0,null!==Ce){var e=Ce;Ce=null;for(var t=0;t<e.length;t++){var n=e[t];try{n._onComplete()}catch(e){ge||(ge=!0,ve=e)}}}if(ge)throw e=ve,ve=null,ge=!1,e}function k(e,t,n){fe&&J("245"),fe=!0,n?null!==(n=e.finishedWork)?C(e,n,t):(e.finishedWork=null,null!==(n=u(e,t,!0))&&(x()?e.finishedWork=n:C(e,n,t))):null!==(n=e.finishedWork)?C(e,n,t):(e.finishedWork=null,null!==(n=u(e,t,!1))&&C(e,n,t)),fe=!1}function C(e,t,n){var r=e.firstBatch;if(null!==r&&r._expirationTime<=n&&(null===Ce?Ce=[r]:Ce.push(r),r._defer))return e.finishedWork=t,void(e.remainingExpirationTime=0);e.finishedWork=null,oe=Z=!0,(n=t.stateNode).current===t&&J("177"),0===(r=n.pendingCommitExpirationTime)&&J("261"),n.pendingCommitExpirationTime=0;var o=d();if(Ut.current=null,1<t.effectTag)if(null!==t.lastEffect){t.lastEffect.nextEffect=t;var a=t.firstEffect}else a=t;else a=t.firstEffect;for(B(n.containerInfo),re=a;null!==re;){var i=!1,u=void 0;try{for(;null!==re;)2048&re.effectTag&&F(re.alternate,re),re=re.nextEffect}catch(e){i=!0,u=e}i&&(null===re&&J("178"),s(re,u),null!==re&&(re=re.nextEffect))}for(re=a;null!==re;){i=!1,u=void 0;try{for(;null!==re;){var l=re.effectTag;if(16&l&&R(re),128&l){var c=re.alternate;null!==c&&j(c)}switch(14&l){case 2:U(re),re.effectTag&=-3;break;case 6:U(re),re.effectTag&=-3,H(re.alternate,re);break;case 4:H(re.alternate,re);break;case 8:A(re)}re=re.nextEffect}}catch(e){i=!0,u=e}i&&(null===re&&J("178"),s(re,u),null!==re&&(re=re.nextEffect))}for(K(n.containerInfo),n.current=t,re=a;null!==re;){l=!1,c=void 0;try{for(a=n,i=o,u=r;null!==re;){var f=re.effectTag;36&f&&L(a,re.alternate,re,i,u),256&f&&z(re,T),128&f&&Y(re);var p=re.nextEffect;re.nextEffect=null,re=p}}catch(e){l=!0,c=e}l&&(null===re&&J("178"),s(re,c),null!==re&&(re=re.nextEffect))}Z=oe=!1,jr(t.stateNode),0===(t=n.current.expirationTime)&&(ie=null),e.remainingExpirationTime=t}function x(){return!(null===ye||ye.timeRemaining()>Se)&&(me=!0)}function T(e){null===de&&J("246"),de.remainingExpirationTime=0,ge||(ge=!0,ve=e)}var S=function(){var e=[],t=-1;return{createCursor:function(e){return{current:e}},isEmpty:function(){return-1===t},pop:function(n){0>t||(n.current=e[t],e[t]=null,t--)},push:function(n,r){e[++t]=n.current,n.current=r},checkThatStackIsEmpty:function(){},resetStackAfterFatalErrorInDev:function(){}}}(),E=function(e,t){function n(e){return e===uo&&J("174"),e}var r=e.getChildHostContext,o=e.getRootHostContext;e=t.createCursor;var a=t.push,i=t.pop,u=e(uo),l=e(uo),s=e(uo);return{getHostContext:function(){return n(u.current)},getRootHostContainer:function(){return n(s.current)},popHostContainer:function(e){i(u,e),i(l,e),i(s,e)},popHostContext:function(e){l.current===e&&(i(u,e),i(l,e))},pushHostContainer:function(e,t){a(s,t,e),t=o(t),a(l,e,e),a(u,t,e)},pushHostContext:function(e){var t=n(s.current),o=n(u.current);o!==(t=r(o,e.type,t))&&(a(l,e,e),a(u,t,e))}}}(e,S),_=function(e){function t(e,t,n){(e=e.stateNode).__reactInternalMemoizedUnmaskedChildContext=t,e.__reactInternalMemoizedMaskedChildContext=n}function n(e){return 2===e.tag&&null!=e.type.childContextTypes}function r(e,t){var n=e.stateNode,r=e.type.childContextTypes;if("function"!=typeof n.getChildContext)return t;for(var a in n=n.getChildContext())a in r||J("108",Xt(e)||"Unknown",a);return o({},t,n)}var i=e.createCursor,u=e.push,l=e.pop,s=i(a),c=i(!1),f=a;return{getUnmaskedContext:function(e){return n(e)?f:s.current},cacheContext:t,getMaskedContext:function(e,n){var r=e.type.contextTypes;if(!r)return a;var o=e.stateNode;if(o&&o.__reactInternalMemoizedUnmaskedChildContext===n)return o.__reactInternalMemoizedMaskedChildContext;var i,u={};for(i in r)u[i]=n[i];return o&&t(e,n,u),u},hasContextChanged:function(){return c.current},isContextConsumer:function(e){return 2===e.tag&&null!=e.type.contextTypes},isContextProvider:n,popContextProvider:function(e){n(e)&&(l(c,e),l(s,e))},popTopLevelContextObject:function(e){l(c,e),l(s,e)},pushTopLevelContextObject:function(e,t,n){null!=s.cursor&&J("168"),u(s,t,e),u(c,n,e)},processChildContext:r,pushContextProvider:function(e){if(!n(e))return!1;var t=e.stateNode;return t=t&&t.__reactInternalMemoizedMergedChildContext||a,f=s.current,u(s,t,e),u(c,c.current,e),!0},invalidateContextProvider:function(e,t){var n=e.stateNode;if(n||J("169"),t){var o=r(e,f);n.__reactInternalMemoizedMergedChildContext=o,l(c,e),l(s,e),u(s,o,e)}else l(c,e);u(c,t,e)},findCurrentUnmaskedContext:function(e){for((2!==Un(e)||2!==e.tag)&&J("170");3!==e.tag;){if(n(e))return e.stateNode.__reactInternalMemoizedMergedChildContext;(e=e.return)||J("171")}return e.stateNode.context}}}(S);S=function(e){var t=e.createCursor,n=e.push,r=e.pop,o=t(null),a=t(null),i=t(0);return{pushProvider:function(e){var t=e.type.context;n(i,t._changedBits,e),n(a,t._currentValue,e),n(o,e,e),t._currentValue=e.pendingProps.value,t._changedBits=e.stateNode},popProvider:function(e){var t=i.current,n=a.current;r(o,e),r(a,e),r(i,e),(e=e.type.context)._currentValue=n,e._changedBits=t}}}(S);var D=function(e){function t(e,t){var n=new Nr(5,null,null,0);n.type="DELETED",n.stateNode=t,n.return=e,n.effectTag=8,null!==e.lastEffect?(e.lastEffect.nextEffect=n,e.lastEffect=n):e.firstEffect=e.lastEffect=n}function n(e,t){switch(e.tag){case 5:return null!==(t=a(t,e.type,e.pendingProps))&&(e.stateNode=t,!0);case 6:return null!==(t=i(t,e.pendingProps))&&(e.stateNode=t,!0);default:return!1}}function r(e){for(e=e.return;null!==e&&5!==e.tag&&3!==e.tag;)e=e.return;f=e}var o=e.shouldSetTextContent;if(!(e=e.hydration))return{enterHydrationState:function(){return!1},resetHydrationState:function(){},tryToClaimNextHydratableInstance:function(){},prepareToHydrateHostInstance:function(){J("175")},prepareToHydrateHostTextInstance:function(){J("176")},popHydrationState:function(){return!1}};var a=e.canHydrateInstance,i=e.canHydrateTextInstance,u=e.getNextHydratableSibling,l=e.getFirstHydratableChild,s=e.hydrateInstance,c=e.hydrateTextInstance,f=null,d=null,p=!1;return{enterHydrationState:function(e){return d=l(e.stateNode.containerInfo),f=e,p=!0},resetHydrationState:function(){d=f=null,p=!1},tryToClaimNextHydratableInstance:function(e){if(p){var r=d;if(r){if(!n(e,r)){if(!(r=u(r))||!n(e,r))return e.effectTag|=2,p=!1,void(f=e);t(f,d)}f=e,d=l(r)}else e.effectTag|=2,p=!1,f=e}},prepareToHydrateHostInstance:function(e,t,n){return t=s(e.stateNode,e.type,e.memoizedProps,t,n,e),e.updateQueue=t,null!==t},prepareToHydrateHostTextInstance:function(e){return c(e.stateNode,e.memoizedProps,e)},popHydrationState:function(e){if(e!==f)return!1;if(!p)return r(e),p=!0,!1;var n=e.type;if(5!==e.tag||"head"!==n&&"body"!==n&&!o(n,e.memoizedProps))for(n=d;n;)t(e,n),n=u(n);return r(e),d=f?u(e.stateNode):null,!0}}}(e),M=ao(e,E,_,S,D,f,c).beginWork,I=function(e,t,n,r,o){function a(e){e.effectTag|=4}var i=e.createInstance,u=e.createTextInstance,l=e.appendInitialChild,s=e.finalizeInitialChildren,c=e.prepareUpdate,f=e.persistence,d=t.getRootHostContainer,p=t.popHostContext,h=t.getHostContext,m=t.popHostContainer,g=n.popContextProvider,v=n.popTopLevelContextObject,y=r.popProvider,b=o.prepareToHydrateHostInstance,w=o.prepareToHydrateHostTextInstance,k=o.popHydrationState,C=void 0,x=void 0,T=void 0;return e.mutation?(C=function(){},x=function(e,t,n){(t.updateQueue=n)&&a(t)},T=function(e,t,n,r){n!==r&&a(t)}):J(f?"235":"236"),{completeWork:function(e,t,n){var r=t.pendingProps;switch(t.tag){case 1:return null;case 2:return g(t),e=t.stateNode,null!==(r=t.updateQueue)&&null!==r.capturedValues&&(t.effectTag&=-65,"function"==typeof e.componentDidCatch?t.effectTag|=256:r.capturedValues=null),null;case 3:return m(t),v(t),(r=t.stateNode).pendingContext&&(r.context=r.pendingContext,r.pendingContext=null),null!==e&&null!==e.child||(k(t),t.effectTag&=-3),C(t),null!==(e=t.updateQueue)&&null!==e.capturedValues&&(t.effectTag|=256),null;case 5:p(t),n=d();var o=t.type;if(null!==e&&null!=t.stateNode){var f=e.memoizedProps,S=t.stateNode,E=h();S=c(S,o,f,r,n,E),x(e,t,S,o,f,r,n,E),e.ref!==t.ref&&(t.effectTag|=128)}else{if(!r)return null===t.stateNode&&J("166"),null;if(e=h(),k(t))b(t,n,e)&&a(t);else{f=i(o,r,n,e,t);e:for(E=t.child;null!==E;){if(5===E.tag||6===E.tag)l(f,E.stateNode);else if(4!==E.tag&&null!==E.child){E.child.return=E,E=E.child;continue}if(E===t)break;for(;null===E.sibling;){if(null===E.return||E.return===t)break e;E=E.return}E.sibling.return=E.return,E=E.sibling}s(f,o,r,n,e)&&a(t),t.stateNode=f}null!==t.ref&&(t.effectTag|=128)}return null;case 6:if(e&&null!=t.stateNode)T(e,t,e.memoizedProps,r);else{if("string"!=typeof r)return null===t.stateNode&&J("166"),null;e=d(),n=h(),k(t)?w(t)&&a(t):t.stateNode=u(r,e,n,t)}return null;case 7:(r=t.memoizedProps)||J("165"),t.tag=8,o=[];e:for((f=t.stateNode)&&(f.return=t);null!==f;){if(5===f.tag||6===f.tag||4===f.tag)J("247");else if(9===f.tag)o.push(f.pendingProps.value);else if(null!==f.child){f.child.return=f,f=f.child;continue}for(;null===f.sibling;){if(null===f.return||f.return===t)break e;f=f.return}f.sibling.return=f.return,f=f.sibling}return r=(f=r.handler)(r.props,o),t.child=ro(t,null!==e?e.child:null,r,n),t.child;case 8:return t.tag=7,null;case 9:case 14:case 10:case 11:return null;case 4:return m(t),C(t),null;case 13:return y(t),null;case 12:return null;case 0:J("167");default:J("156")}}}}(e,E,_,S,D).completeWork,P=(E=function(e,t,n,r,o){var a=e.popHostContainer,i=e.popHostContext,u=t.popContextProvider,l=t.popTopLevelContextObject,s=n.popProvider;return{throwException:function(e,t,n){t.effectTag|=512,t.firstEffect=t.lastEffect=null,t={value:n,source:t,stack:Gt(t)};do{switch(e.tag){case 3:return Qr(e),e.updateQueue.capturedValues=[t],void(e.effectTag|=1024);case 2:if(n=e.stateNode,0==(64&e.effectTag)&&null!==n&&"function"==typeof n.componentDidCatch&&!o(n)){Qr(e);var r=(n=e.updateQueue).capturedValues;return null===r?n.capturedValues=[t]:r.push(t),void(e.effectTag|=1024)}}e=e.return}while(null!==e)},unwindWork:function(e){switch(e.tag){case 2:u(e);var t=e.effectTag;return 1024&t?(e.effectTag=-1025&t|64,e):null;case 3:return a(e),l(e),1024&(t=e.effectTag)?(e.effectTag=-1025&t|64,e):null;case 5:return i(e),null;case 4:return a(e),null;case 13:return s(e),null;default:return null}},unwindInterruptedWork:function(e){switch(e.tag){case 2:u(e);break;case 3:a(e),l(e);break;case 5:i(e);break;case 4:a(e);break;case 13:s(e)}}}}(E,_,S,0,n)).throwException,O=E.unwindWork,N=E.unwindInterruptedWork,F=(E=function(e,t,n,r,o){function a(e){var n=e.ref;if(null!==n)if("function"==typeof n)try{n(null)}catch(n){t(e,n)}else n.current=null}function i(e){switch(Wr(e),e.tag){case 2:a(e);var n=e.stateNode;if("function"==typeof n.componentWillUnmount)try{n.props=e.memoizedProps,n.state=e.memoizedState,n.componentWillUnmount()}catch(n){t(e,n)}break;case 5:a(e);break;case 7:u(e.stateNode);break;case 4:f&&s(e)}}function u(e){for(var t=e;;)if(i(t),null===t.child||f&&4===t.tag){if(t===e)break;for(;null===t.sibling;){if(null===t.return||t.return===e)return;t=t.return}t.sibling.return=t.return,t=t.sibling}else t.child.return=t,t=t.child}function l(e){return 5===e.tag||3===e.tag||4===e.tag}function s(e){for(var t=e,n=!1,r=void 0,o=void 0;;){if(!n){n=t.return;e:for(;;){switch(null===n&&J("160"),n.tag){case 5:r=n.stateNode,o=!1;break e;case 3:case 4:r=n.stateNode.containerInfo,o=!0;break e}n=n.return}n=!0}if(5===t.tag||6===t.tag)u(t),o?k(r,t.stateNode):w(r,t.stateNode);else if(4===t.tag?r=t.stateNode.containerInfo:i(t),null!==t.child){t.child.return=t,t=t.child;continue}if(t===e)break;for(;null===t.sibling;){if(null===t.return||t.return===e)return;4===(t=t.return).tag&&(n=!1)}t.sibling.return=t.return,t=t.sibling}}var c=e.getPublicInstance,f=e.mutation;e=e.persistence,f||J(e?"235":"236");var d=f.commitMount,p=f.commitUpdate,h=f.resetTextContent,m=f.commitTextUpdate,g=f.appendChild,v=f.appendChildToContainer,y=f.insertBefore,b=f.insertInContainerBefore,w=f.removeChild,k=f.removeChildFromContainer;return{commitBeforeMutationLifeCycles:function(e,t){switch(t.tag){case 2:if(2048&t.effectTag&&null!==e){var n=e.memoizedProps,r=e.memoizedState;(e=t.stateNode).props=t.memoizedProps,e.state=t.memoizedState,t=e.getSnapshotBeforeUpdate(n,r),e.__reactInternalSnapshotBeforeUpdate=t}break;case 3:case 5:case 6:case 4:break;default:J("163")}},commitResetTextContent:function(e){h(e.stateNode)},commitPlacement:function(e){e:{for(var t=e.return;null!==t;){if(l(t)){var n=t;break e}t=t.return}J("160"),n=void 0}var r=t=void 0;switch(n.tag){case 5:t=n.stateNode,r=!1;break;case 3:case 4:t=n.stateNode.containerInfo,r=!0;break;default:J("161")}16&n.effectTag&&(h(t),n.effectTag&=-17);e:t:for(n=e;;){for(;null===n.sibling;){if(null===n.return||l(n.return)){n=null;break e}n=n.return}for(n.sibling.return=n.return,n=n.sibling;5!==n.tag&&6!==n.tag;){if(2&n.effectTag)continue t;if(null===n.child||4===n.tag)continue t;n.child.return=n,n=n.child}if(!(2&n.effectTag)){n=n.stateNode;break e}}for(var o=e;;){if(5===o.tag||6===o.tag)n?r?b(t,o.stateNode,n):y(t,o.stateNode,n):r?v(t,o.stateNode):g(t,o.stateNode);else if(4!==o.tag&&null!==o.child){o.child.return=o,o=o.child;continue}if(o===e)break;for(;null===o.sibling;){if(null===o.return||o.return===e)return;o=o.return}o.sibling.return=o.return,o=o.sibling}},commitDeletion:function(e){s(e),e.return=null,e.child=null,e.alternate&&(e.alternate.child=null,e.alternate.return=null)},commitWork:function(e,t){switch(t.tag){case 2:break;case 5:var n=t.stateNode;if(null!=n){var r=t.memoizedProps;e=null!==e?e.memoizedProps:r;var o=t.type,a=t.updateQueue;t.updateQueue=null,null!==a&&p(n,a,o,e,r,t)}break;case 6:null===t.stateNode&&J("162"),n=t.memoizedProps,m(t.stateNode,null!==e?e.memoizedProps:n,n);break;case 3:break;default:J("163")}},commitLifeCycles:function(e,t,n){switch(n.tag){case 2:if(e=n.stateNode,4&n.effectTag)if(null===t)e.props=n.memoizedProps,e.state=n.memoizedState,e.componentDidMount();else{var r=t.memoizedProps;t=t.memoizedState,e.props=n.memoizedProps,e.state=n.memoizedState,e.componentDidUpdate(r,t,e.__reactInternalSnapshotBeforeUpdate)}null!==(n=n.updateQueue)&&Zr(n,e);break;case 3:if(null!==(t=n.updateQueue)){if(e=null,null!==n.child)switch(n.child.tag){case 5:e=c(n.child.stateNode);break;case 2:e=n.child.stateNode}Zr(t,e)}break;case 5:e=n.stateNode,null===t&&4&n.effectTag&&d(e,n.type,n.memoizedProps,n);break;case 6:case 4:break;default:J("163")}},commitErrorLogging:function(e,t){switch(e.tag){case 2:var n=e.type;t=e.stateNode;var r=e.updateQueue;(null===r||null===r.capturedValues)&&J("264");var a=r.capturedValues;for(r.capturedValues=null,"function"!=typeof n.getDerivedStateFromCatch&&o(t),t.props=e.memoizedProps,t.state=e.memoizedState,n=0;n<a.length;n++){var i=(r=a[n]).value,u=r.stack;io(e,r),t.componentDidCatch(i,{componentStack:null!==u?u:""})}break;case 3:for((null===(n=e.updateQueue)||null===n.capturedValues)&&J("264"),a=n.capturedValues,n.capturedValues=null,n=0;n<a.length;n++)io(e,r=a[n]),t(r.value);break;default:J("265")}},commitAttachRef:function(e){var t=e.ref;if(null!==t){var n=e.stateNode;switch(e.tag){case 5:e=c(n);break;default:e=n}"function"==typeof t?t(e):t.current=e}},commitDetachRef:function(e){null!==(e=e.ref)&&("function"==typeof e?e(null):e.current=null)}}}(e,s,0,0,function(e){null===ie?ie=new Set([e]):ie.add(e)})).commitBeforeMutationLifeCycles,R=E.commitResetTextContent,U=E.commitPlacement,A=E.commitDeletion,H=E.commitWork,L=E.commitLifeCycles,z=E.commitErrorLogging,Y=E.commitAttachRef,j=E.commitDetachRef,W=e.now,V=e.scheduleDeferredCallback,$=e.cancelDeferredCallback,B=e.prepareForCommit,K=e.resetAfterCommit,Q=W(),q=Q,X=0,G=0,Z=!1,ee=null,te=null,ne=0,re=null,oe=!1,ae=!1,ie=null,ue=null,le=null,se=0,ce=-1,fe=!1,de=null,pe=0,he=0,me=!1,ge=!1,ve=null,ye=null,be=!1,we=!1,ke=!1,Ce=null,xe=1e3,Te=0,Se=1;return{recalculateCurrentTime:d,computeExpirationForFiber:c,scheduleWork:f,requestWork:m,flushRoot:function(e,t){fe&&J("253"),de=e,pe=t,k(e,t,!1),y(),w()},batchedUpdates:function(e,t){var n=be;be=!0;try{return e(t)}finally{(be=n)||fe||y()}},unbatchedUpdates:function(e,t){if(be&&!we){we=!0;try{return e(t)}finally{we=!1}}return e(t)},flushSync:function(e,t){fe&&J("187");var n=be;be=!0;try{return p(e,t)}finally{be=n,y()}},flushControlled:function(e){var t=be;be=!0;try{p(e)}finally{(be=t)||fe||b(1,!1,null)}},deferredUpdates:function(e){var t=G;G=25*(1+((d()+500)/25|0));try{return e()}finally{G=t}},syncUpdates:p,interactiveUpdates:function(e,t,n){if(ke)return e(t,n);be||fe||0===he||(b(he,!1,null),he=0);var r=ke,o=be;be=ke=!0;try{return e(t,n)}finally{ke=r,(be=o)||fe||y()}},flushInteractiveUpdates:function(){fe||0===he||(b(he,!1,null),he=0)},computeUniqueAsyncExpiration:function(){var e=25*(1+((d()+500)/25|0));return e<=X&&(e=X+1),X=e},legacyContext:_}}function so(e){function t(e,t,n,r,o,i){if(r=t.current,n){n=n._reactInternalFiber;var u=c(n);n=f(n)?d(n,u):u}else n=a;return null===t.context?t.context=n:t.pendingContext=n,qr(r,{expirationTime:o,partialState:{element:e},callback:void 0===(t=i)?null:t,isReplace:!1,isForced:!1,capturedValue:null,next:null}),l(r,o),o}function n(e){return null===(e=function(e){if(!(e=Ln(e)))return null;for(var t=e;;){if(5===t.tag||6===t.tag)return t;if(t.child)t.child.return=t,t=t.child;else{if(t===e)break;for(;!t.sibling;){if(!t.return||t.return===e)return null;t=t.return}t.sibling.return=t.return,t=t.sibling}}return null}(e))?null:e.stateNode}var r=e.getPublicInstance,i=(e=lo(e)).recalculateCurrentTime,u=e.computeExpirationForFiber,l=e.scheduleWork,s=e.legacyContext,c=s.findCurrentUnmaskedContext,f=s.isContextProvider,d=s.processChildContext;return{createContainer:function(e,t,n){return e={current:t=new Nr(3,null,null,t?3:0),containerInfo:e,pendingChildren:null,pendingCommitExpirationTime:0,finishedWork:null,context:null,pendingContext:null,hydrate:n,remainingExpirationTime:0,firstBatch:null,nextScheduledRoot:null},t.stateNode=e},updateContainer:function(e,n,r,o){var a=n.current;return t(e,n,r,i(),a=u(a),o)},updateContainerAtExpirationTime:function(e,n,r,o,a){return t(e,n,r,i(),o,a)},flushRoot:e.flushRoot,requestWork:e.requestWork,computeUniqueAsyncExpiration:e.computeUniqueAsyncExpiration,batchedUpdates:e.batchedUpdates,unbatchedUpdates:e.unbatchedUpdates,deferredUpdates:e.deferredUpdates,syncUpdates:e.syncUpdates,interactiveUpdates:e.interactiveUpdates,flushInteractiveUpdates:e.flushInteractiveUpdates,flushControlled:e.flushControlled,flushSync:e.flushSync,getPublicRootInstance:function(e){if(!(e=e.current).child)return null;switch(e.child.tag){case 5:return r(e.child.stateNode);default:return e.child.stateNode}},findHostInstance:n,findHostInstanceWithNoPortals:function(e){return null===(e=function(e){if(!(e=Ln(e)))return null;for(var t=e;;){if(5===t.tag||6===t.tag)return t;if(t.child&&4!==t.tag)t.child.return=t,t=t.child;else{if(t===e)break;for(;!t.sibling;){if(!t.return||t.return===e)return null;t=t.return}t.sibling.return=t.return,t=t.sibling}}return null}(e))?null:e.stateNode},injectIntoDevTools:function(e){var t=e.findFiberByHostInstance;return function(e){if("undefined"==typeof __REACT_DEVTOOLS_GLOBAL_HOOK__)return!1;var t=__REACT_DEVTOOLS_GLOBAL_HOOK__;if(t.isDisabled||!t.supportsFiber)return!0;try{var n=t.inject(e);Lr=Yr(function(e){return t.onCommitFiberRoot(n,e)}),zr=Yr(function(e){return t.onCommitFiberUnmount(n,e)})}catch(e){}return!0}(o({},e,{findHostInstanceByFiber:function(e){return n(e)},findFiberByHostInstance:function(e){return t?t(e):null}}))}}}var co=Object.freeze({default:so}),fo=co&&so||co,po=fo.default?fo.default:fo;var ho="object"==typeof performance&&"function"==typeof performance.now,mo=void 0;mo=ho?function(){return performance.now()}:function(){return Date.now()};var go=void 0,vo=void 0;if($.canUseDOM)if("function"!=typeof requestIdleCallback||"function"!=typeof cancelIdleCallback){var yo=null,bo=!1,wo=-1,ko=!1,Co=0,xo=33,To=33,So=void 0;So=ho?{didTimeout:!1,timeRemaining:function(){var e=Co-performance.now();return 0<e?e:0}}:{didTimeout:!1,timeRemaining:function(){var e=Co-Date.now();return 0<e?e:0}};var Eo="__reactIdleCallback$"+Math.random().toString(36).slice(2);window.addEventListener("message",function(e){if(e.source===window&&e.data===Eo){if(bo=!1,e=mo(),0>=Co-e){if(!(-1!==wo&&wo<=e))return void(ko||(ko=!0,requestAnimationFrame(_o)));So.didTimeout=!0}else So.didTimeout=!1;wo=-1,e=yo,yo=null,null!==e&&e(So)}},!1);var _o=function(e){ko=!1;var t=e-Co+To;t<To&&xo<To?(8>t&&(t=8),To=t<xo?xo:t):xo=t,Co=e+To,bo||(bo=!0,window.postMessage(Eo,"*"))};go=function(e,t){return yo=e,null!=t&&"number"==typeof t.timeout&&(wo=mo()+t.timeout),ko||(ko=!0,requestAnimationFrame(_o)),0},vo=function(){yo=null,bo=!1,wo=-1}}else go=window.requestIdleCallback,vo=window.cancelIdleCallback;else go=function(e){return setTimeout(function(){e({timeRemaining:function(){return 1/0},didTimeout:!1})})},vo=function(e){clearTimeout(e)};function Do(e,t){return e=o({children:void 0},t),(t=function(e){var t="";return W.Children.forEach(e,function(e){null==e||"string"!=typeof e&&"number"!=typeof e||(t+=e)}),t}(t.children))&&(e.children=t),e}function Mo(e,t,n,r){if(e=e.options,t){t={};for(var o=0;o<n.length;o++)t["$"+n[o]]=!0;for(n=0;n<e.length;n++)o=t.hasOwnProperty("$"+e[n].value),e[n].selected!==o&&(e[n].selected=o),o&&r&&(e[n].defaultSelected=!0)}else{for(n=""+n,t=null,o=0;o<e.length;o++){if(e[o].value===n)return e[o].selected=!0,void(r&&(e[o].defaultSelected=!0));null!==t||e[o].disabled||(t=e[o])}null!==t&&(t.selected=!0)}}function Io(e,t){var n=t.value;e._wrapperState={initialValue:null!=n?n:t.defaultValue,wasMultiple:!!t.multiple}}function Po(e,t){return null!=t.dangerouslySetInnerHTML&&J("91"),o({},t,{value:void 0,defaultValue:void 0,children:""+e._wrapperState.initialValue})}function Oo(e,t){var n=t.value;null==n&&(n=t.defaultValue,null!=(t=t.children)&&(null!=n&&J("92"),Array.isArray(t)&&(1>=t.length||J("93"),t=t[0]),n=""+t),null==n&&(n="")),e._wrapperState={initialValue:""+n}}function No(e,t){var n=t.value;null!=n&&((n=""+n)!==e.value&&(e.value=n),null==t.defaultValue&&(e.defaultValue=n)),null!=t.defaultValue&&(e.defaultValue=t.defaultValue)}function Fo(e){var t=e.textContent;t===e._wrapperState.initialValue&&(e.value=t)}var Ro="http://www.w3.org/1999/xhtml",Uo="http://www.w3.org/2000/svg";function Ao(e){switch(e){case"svg":return"http://www.w3.org/2000/svg";case"math":return"http://www.w3.org/1998/Math/MathML";default:return"http://www.w3.org/1999/xhtml"}}function Ho(e,t){return null==e||"http://www.w3.org/1999/xhtml"===e?Ao(t):"http://www.w3.org/2000/svg"===e&&"foreignObject"===t?"http://www.w3.org/1999/xhtml":e}var Lo,zo=void 0,Yo=(Lo=function(e,t){if(e.namespaceURI!==Uo||"innerHTML"in e)e.innerHTML=t;else{for((zo=zo||document.createElement("div")).innerHTML="<svg>"+t+"</svg>",t=zo.firstChild;e.firstChild;)e.removeChild(e.firstChild);for(;t.firstChild;)e.appendChild(t.firstChild)}},"undefined"!=typeof MSApp&&MSApp.execUnsafeLocalFunction?function(e,t,n,r){MSApp.execUnsafeLocalFunction(function(){return Lo(e,t)})}:Lo);function jo(e,t){if(t){var n=e.firstChild;if(n&&n===e.lastChild&&3===n.nodeType)return void(n.nodeValue=t)}e.textContent=t}var Wo={animationIterationCount:!0,borderImageOutset:!0,borderImageSlice:!0,borderImageWidth:!0,boxFlex:!0,boxFlexGroup:!0,boxOrdinalGroup:!0,columnCount:!0,columns:!0,flex:!0,flexGrow:!0,flexPositive:!0,flexShrink:!0,flexNegative:!0,flexOrder:!0,gridRow:!0,gridRowEnd:!0,gridRowSpan:!0,gridRowStart:!0,gridColumn:!0,gridColumnEnd:!0,gridColumnSpan:!0,gridColumnStart:!0,fontWeight:!0,lineClamp:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,tabSize:!0,widows:!0,zIndex:!0,zoom:!0,fillOpacity:!0,floodOpacity:!0,stopOpacity:!0,strokeDasharray:!0,strokeDashoffset:!0,strokeMiterlimit:!0,strokeOpacity:!0,strokeWidth:!0},Vo=["Webkit","ms","Moz","O"];function $o(e,t){for(var n in e=e.style,t)if(t.hasOwnProperty(n)){var r=0===n.indexOf("--"),o=n,a=t[n];o=null==a||"boolean"==typeof a||""===a?"":r||"number"!=typeof a||0===a||Wo.hasOwnProperty(o)&&Wo[o]?(""+a).trim():a+"px","float"===n&&(n="cssFloat"),r?e.setProperty(n,o):e[n]=o}}Object.keys(Wo).forEach(function(e){Vo.forEach(function(t){t=t+e.charAt(0).toUpperCase()+e.substring(1),Wo[t]=Wo[e]})});var Bo=o({menuitem:!0},{area:!0,base:!0,br:!0,col:!0,embed:!0,hr:!0,img:!0,input:!0,keygen:!0,link:!0,meta:!0,param:!0,source:!0,track:!0,wbr:!0});function Ko(e,t,n){t&&(Bo[e]&&(null!=t.children||null!=t.dangerouslySetInnerHTML)&&J("137",e,n()),null!=t.dangerouslySetInnerHTML&&(null!=t.children&&J("60"),"object"==typeof t.dangerouslySetInnerHTML&&"__html"in t.dangerouslySetInnerHTML||J("61")),null!=t.style&&"object"!=typeof t.style&&J("62",n()))}function Qo(e,t){if(-1===e.indexOf("-"))return"string"==typeof t.is;switch(e){case"annotation-xml":case"color-profile":case"font-face":case"font-face-src":case"font-face-uri":case"font-face-format":case"font-face-name":case"missing-glyph":return!1;default:return!0}}var qo=Ro,Xo=l.thatReturns("");function Go(e,t){var n=kr(e=9===e.nodeType||11===e.nodeType?e:e.ownerDocument);t=le[t];for(var r=0;r<t.length;r++){var o=t[r];n.hasOwnProperty(o)&&n[o]||("topScroll"===o?ur("topScroll","scroll",e):"topFocus"===o||"topBlur"===o?(ur("topFocus","focus",e),ur("topBlur","blur",e),n.topBlur=!0,n.topFocus=!0):"topCancel"===o?(Ot("cancel",!0)&&ur("topCancel","cancel",e),n.topCancel=!0):"topClose"===o?(Ot("close",!0)&&ur("topClose","close",e),n.topClose=!0):gr.hasOwnProperty(o)&&ir(o,gr[o],e),n[o]=!0)}}function Zo(e,t,n,r){return n=9===n.nodeType?n:n.ownerDocument,r===qo&&(r=Ao(e)),r===qo?"script"===e?((e=n.createElement("div")).innerHTML="<script><\/script>",e=e.removeChild(e.firstChild)):e="string"==typeof t.is?n.createElement(e,{is:t.is}):n.createElement(e):e=n.createElementNS(r,e),e}function Jo(e,t){return(9===t.nodeType?t:t.ownerDocument).createTextNode(e)}function ea(e,t,n,r){var a=Qo(t,n);switch(t){case"iframe":case"object":ir("topLoad","load",e);var i=n;break;case"video":case"audio":for(i in vr)vr.hasOwnProperty(i)&&ir(i,vr[i],e);i=n;break;case"source":ir("topError","error",e),i=n;break;case"img":case"image":case"link":ir("topError","error",e),ir("topLoad","load",e),i=n;break;case"form":ir("topReset","reset",e),ir("topSubmit","submit",e),i=n;break;case"details":ir("topToggle","toggle",e),i=n;break;case"input":ln(e,n),i=un(e,n),ir("topInvalid","invalid",e),Go(r,"onChange");break;case"option":i=Do(e,n);break;case"select":Io(e,n),i=o({},n,{value:void 0}),ir("topInvalid","invalid",e),Go(r,"onChange");break;case"textarea":Oo(e,n),i=Po(e,n),ir("topInvalid","invalid",e),Go(r,"onChange");break;default:i=n}Ko(t,i,Xo);var u,s=i;for(u in s)if(s.hasOwnProperty(u)){var c=s[u];"style"===u?$o(e,c):"dangerouslySetInnerHTML"===u?null!=(c=c?c.__html:void 0)&&Yo(e,c):"children"===u?"string"==typeof c?("textarea"!==t||""!==c)&&jo(e,c):"number"==typeof c&&jo(e,""+c):"suppressContentEditableWarning"!==u&&"suppressHydrationWarning"!==u&&"autoFocus"!==u&&(ue.hasOwnProperty(u)?null!=c&&Go(r,u):null!=c&&an(e,u,c,a))}switch(t){case"input":Ft(e),fn(e,n);break;case"textarea":Ft(e),Fo(e);break;case"option":null!=n.value&&e.setAttribute("value",n.value);break;case"select":e.multiple=!!n.multiple,null!=(t=n.value)?Mo(e,!!n.multiple,t,!1):null!=n.defaultValue&&Mo(e,!!n.multiple,n.defaultValue,!0);break;default:"function"==typeof i.onClick&&(e.onclick=l)}}function ta(e,t,n,r,a){var i=null;switch(t){case"input":n=un(e,n),r=un(e,r),i=[];break;case"option":n=Do(e,n),r=Do(e,r),i=[];break;case"select":n=o({},n,{value:void 0}),r=o({},r,{value:void 0}),i=[];break;case"textarea":n=Po(e,n),r=Po(e,r),i=[];break;default:"function"!=typeof n.onClick&&"function"==typeof r.onClick&&(e.onclick=l)}Ko(t,r,Xo),t=e=void 0;var u=null;for(e in n)if(!r.hasOwnProperty(e)&&n.hasOwnProperty(e)&&null!=n[e])if("style"===e){var s=n[e];for(t in s)s.hasOwnProperty(t)&&(u||(u={}),u[t]="")}else"dangerouslySetInnerHTML"!==e&&"children"!==e&&"suppressContentEditableWarning"!==e&&"suppressHydrationWarning"!==e&&"autoFocus"!==e&&(ue.hasOwnProperty(e)?i||(i=[]):(i=i||[]).push(e,null));for(e in r){var c=r[e];if(s=null!=n?n[e]:void 0,r.hasOwnProperty(e)&&c!==s&&(null!=c||null!=s))if("style"===e)if(s){for(t in s)!s.hasOwnProperty(t)||c&&c.hasOwnProperty(t)||(u||(u={}),u[t]="");for(t in c)c.hasOwnProperty(t)&&s[t]!==c[t]&&(u||(u={}),u[t]=c[t])}else u||(i||(i=[]),i.push(e,u)),u=c;else"dangerouslySetInnerHTML"===e?(c=c?c.__html:void 0,s=s?s.__html:void 0,null!=c&&s!==c&&(i=i||[]).push(e,""+c)):"children"===e?s===c||"string"!=typeof c&&"number"!=typeof c||(i=i||[]).push(e,""+c):"suppressContentEditableWarning"!==e&&"suppressHydrationWarning"!==e&&(ue.hasOwnProperty(e)?(null!=c&&Go(a,e),i||s===c||(i=[])):(i=i||[]).push(e,c))}return u&&(i=i||[]).push("style",u),i}function na(e,t,n,r,o){"input"===n&&"radio"===o.type&&null!=o.name&&sn(e,o),Qo(n,r),r=Qo(n,o);for(var a=0;a<t.length;a+=2){var i=t[a],u=t[a+1];"style"===i?$o(e,u):"dangerouslySetInnerHTML"===i?Yo(e,u):"children"===i?jo(e,u):an(e,i,u,r)}switch(n){case"input":cn(e,o);break;case"textarea":No(e,o);break;case"select":e._wrapperState.initialValue=void 0,t=e._wrapperState.wasMultiple,e._wrapperState.wasMultiple=!!o.multiple,null!=(n=o.value)?Mo(e,!!o.multiple,n,!1):t!==!!o.multiple&&(null!=o.defaultValue?Mo(e,!!o.multiple,o.defaultValue,!0):Mo(e,!!o.multiple,o.multiple?[]:"",!1))}}function ra(e,t,n,r,o){switch(t){case"iframe":case"object":ir("topLoad","load",e);break;case"video":case"audio":for(var a in vr)vr.hasOwnProperty(a)&&ir(a,vr[a],e);break;case"source":ir("topError","error",e);break;case"img":case"image":case"link":ir("topError","error",e),ir("topLoad","load",e);break;case"form":ir("topReset","reset",e),ir("topSubmit","submit",e);break;case"details":ir("topToggle","toggle",e);break;case"input":ln(e,n),ir("topInvalid","invalid",e),Go(o,"onChange");break;case"select":Io(e,n),ir("topInvalid","invalid",e),Go(o,"onChange");break;case"textarea":Oo(e,n),ir("topInvalid","invalid",e),Go(o,"onChange")}for(var i in Ko(t,n,Xo),r=null,n)n.hasOwnProperty(i)&&(a=n[i],"children"===i?"string"==typeof a?e.textContent!==a&&(r=["children",a]):"number"==typeof a&&e.textContent!==""+a&&(r=["children",""+a]):ue.hasOwnProperty(i)&&null!=a&&Go(o,i));switch(t){case"input":Ft(e),fn(e,n);break;case"textarea":Ft(e),Fo(e);break;case"select":case"option":break;default:"function"==typeof n.onClick&&(e.onclick=l)}return r}function oa(e,t){return e.nodeValue!==t}var aa=Object.freeze({createElement:Zo,createTextNode:Jo,setInitialProperties:ea,diffProperties:ta,updateProperties:na,diffHydratedProperties:ra,diffHydratedText:oa,warnForUnmatchedText:function(){},warnForDeletedHydratableElement:function(){},warnForDeletedHydratableText:function(){},warnForInsertedHydratedElement:function(){},warnForInsertedHydratedText:function(){},restoreControlledState:function(e,t,n){switch(t){case"input":if(cn(e,n),t=n.name,"radio"===n.type&&null!=t){for(n=e;n.parentNode;)n=n.parentNode;for(n=n.querySelectorAll("input[name="+JSON.stringify(""+t)+'][type="radio"]'),t=0;t<n.length;t++){var r=n[t];if(r!==e&&r.form===e.form){var o=Oe(r);o||J("90"),Rt(r),cn(r,o)}}}break;case"textarea":No(e,n);break;case"select":null!=(t=n.value)&&Mo(e,!!n.multiple,t,!1)}}});bt.injectFiberControlledHostComponent(aa);var ia=null,ua=null;function la(e){this._expirationTime=pa.computeUniqueAsyncExpiration(),this._root=e,this._callbacks=this._next=null,this._hasChildren=this._didComplete=!1,this._children=null,this._defer=!0}function sa(){this._callbacks=null,this._didCommit=!1,this._onCommit=this._onCommit.bind(this)}function ca(e,t,n){this._internalRoot=pa.createContainer(e,t,n)}function fa(e){return!(!e||1!==e.nodeType&&9!==e.nodeType&&11!==e.nodeType&&(8!==e.nodeType||" react-mount-point-unstable "!==e.nodeValue))}function da(e,t){switch(e){case"button":case"input":case"select":case"textarea":return!!t.autoFocus}return!1}la.prototype.render=function(e){this._defer||J("250"),this._hasChildren=!0,this._children=e;var t=this._root._internalRoot,n=this._expirationTime,r=new sa;return pa.updateContainerAtExpirationTime(e,t,null,n,r._onCommit),r},la.prototype.then=function(e){if(this._didComplete)e();else{var t=this._callbacks;null===t&&(t=this._callbacks=[]),t.push(e)}},la.prototype.commit=function(){var e=this._root._internalRoot,t=e.firstBatch;if(this._defer&&null!==t||J("251"),this._hasChildren){var n=this._expirationTime;if(t!==this){this._hasChildren&&(n=this._expirationTime=t._expirationTime,this.render(this._children));for(var r=null,o=t;o!==this;)r=o,o=o._next;null===r&&J("251"),r._next=o._next,this._next=t,e.firstBatch=this}this._defer=!1,pa.flushRoot(e,n),t=this._next,this._next=null,null!==(t=e.firstBatch=t)&&t._hasChildren&&t.render(t._children)}else this._next=null,this._defer=!1},la.prototype._onComplete=function(){if(!this._didComplete){this._didComplete=!0;var e=this._callbacks;if(null!==e)for(var t=0;t<e.length;t++)(0,e[t])()}},sa.prototype.then=function(e){if(this._didCommit)e();else{var t=this._callbacks;null===t&&(t=this._callbacks=[]),t.push(e)}},sa.prototype._onCommit=function(){if(!this._didCommit){this._didCommit=!0;var e=this._callbacks;if(null!==e)for(var t=0;t<e.length;t++){var n=e[t];"function"!=typeof n&&J("191",n),n()}}},ca.prototype.render=function(e,t){var n=this._internalRoot,r=new sa;return null!==(t=void 0===t?null:t)&&r.then(t),pa.updateContainer(e,n,null,r._onCommit),r},ca.prototype.unmount=function(e){var t=this._internalRoot,n=new sa;return null!==(e=void 0===e?null:e)&&n.then(e),pa.updateContainer(null,t,null,n._onCommit),n},ca.prototype.legacy_renderSubtreeIntoContainer=function(e,t,n){var r=this._internalRoot,o=new sa;return null!==(n=void 0===n?null:n)&&o.then(n),pa.updateContainer(t,r,e,o._onCommit),o},ca.prototype.createBatch=function(){var e=new la(this),t=e._expirationTime,n=this._internalRoot,r=n.firstBatch;if(null===r)n.firstBatch=e,e._next=null;else{for(n=null;null!==r&&r._expirationTime<=t;)n=r,r=r._next;e._next=r,null!==n&&(n._next=e)}return e};var pa=po({getRootHostContext:function(e){var t=e.nodeType;switch(t){case 9:case 11:e=(e=e.documentElement)?e.namespaceURI:Ho(null,"");break;default:e=Ho(e=(t=8===t?e.parentNode:e).namespaceURI||null,t=t.tagName)}return e},getChildHostContext:function(e,t){return Ho(e,t)},getPublicInstance:function(e){return e},prepareForCommit:function(){ia=or;var e=B();if(Tr(e)){if("selectionStart"in e)var t={start:e.selectionStart,end:e.selectionEnd};else e:{var n=window.getSelection&&window.getSelection();if(n&&0!==n.rangeCount){t=n.anchorNode;var r=n.anchorOffset,o=n.focusNode;n=n.focusOffset;try{t.nodeType,o.nodeType}catch(e){t=null;break e}var a=0,i=-1,u=-1,l=0,s=0,c=e,f=null;t:for(;;){for(var d;c!==t||0!==r&&3!==c.nodeType||(i=a+r),c!==o||0!==n&&3!==c.nodeType||(u=a+n),3===c.nodeType&&(a+=c.nodeValue.length),null!==(d=c.firstChild);)f=c,c=d;for(;;){if(c===e)break t;if(f===t&&++l===r&&(i=a),f===o&&++s===n&&(u=a),null!==(d=c.nextSibling))break;f=(c=f).parentNode}c=d}t=-1===i||-1===u?null:{start:i,end:u}}else t=null}t=t||{start:0,end:0}}else t=null;ua={focusedElem:e,selectionRange:t},ar(!1)},resetAfterCommit:function(){var e=ua,t=B(),n=e.focusedElem,r=e.selectionRange;if(t!==n&&Z(document.documentElement,n)){if(Tr(n))if(t=r.start,void 0===(e=r.end)&&(e=t),"selectionStart"in n)n.selectionStart=t,n.selectionEnd=Math.min(e,n.value.length);else if(window.getSelection){t=window.getSelection();var o=n[$e()].length;e=Math.min(r.start,o),r=void 0===r.end?e:Math.min(r.end,o),!t.extend&&e>r&&(o=r,r=e,e=o),o=xr(n,e);var a=xr(n,r);if(o&&a&&(1!==t.rangeCount||t.anchorNode!==o.node||t.anchorOffset!==o.offset||t.focusNode!==a.node||t.focusOffset!==a.offset)){var i=document.createRange();i.setStart(o.node,o.offset),t.removeAllRanges(),e>r?(t.addRange(i),t.extend(a.node,a.offset)):(i.setEnd(a.node,a.offset),t.addRange(i))}}for(t=[],e=n;e=e.parentNode;)1===e.nodeType&&t.push({element:e,left:e.scrollLeft,top:e.scrollTop});for(n.focus(),n=0;n<t.length;n++)(e=t[n]).element.scrollLeft=e.left,e.element.scrollTop=e.top}ua=null,ar(ia),ia=null},createInstance:function(e,t,n,r,o){return(e=Zo(e,t,n,r))[De]=o,e[Me]=t,e},appendInitialChild:function(e,t){e.appendChild(t)},finalizeInitialChildren:function(e,t,n,r){return ea(e,t,n,r),da(t,n)},prepareUpdate:function(e,t,n,r,o){return ta(e,t,n,r,o)},shouldSetTextContent:function(e,t){return"textarea"===e||"string"==typeof t.children||"number"==typeof t.children||"object"==typeof t.dangerouslySetInnerHTML&&null!==t.dangerouslySetInnerHTML&&"string"==typeof t.dangerouslySetInnerHTML.__html},shouldDeprioritizeSubtree:function(e,t){return!!t.hidden},createTextInstance:function(e,t,n,r){return(e=Jo(e,t))[De]=r,e},now:mo,mutation:{commitMount:function(e,t,n){da(t,n)&&e.focus()},commitUpdate:function(e,t,n,r,o){e[Me]=o,na(e,t,n,r,o)},resetTextContent:function(e){jo(e,"")},commitTextUpdate:function(e,t,n){e.nodeValue=n},appendChild:function(e,t){e.appendChild(t)},appendChildToContainer:function(e,t){8===e.nodeType?e.parentNode.insertBefore(t,e):e.appendChild(t)},insertBefore:function(e,t,n){e.insertBefore(t,n)},insertInContainerBefore:function(e,t,n){8===e.nodeType?e.parentNode.insertBefore(t,n):e.insertBefore(t,n)},removeChild:function(e,t){e.removeChild(t)},removeChildFromContainer:function(e,t){8===e.nodeType?e.parentNode.removeChild(t):e.removeChild(t)}},hydration:{canHydrateInstance:function(e,t){return 1!==e.nodeType||t.toLowerCase()!==e.nodeName.toLowerCase()?null:e},canHydrateTextInstance:function(e,t){return""===t||3!==e.nodeType?null:e},getNextHydratableSibling:function(e){for(e=e.nextSibling;e&&1!==e.nodeType&&3!==e.nodeType;)e=e.nextSibling;return e},getFirstHydratableChild:function(e){for(e=e.firstChild;e&&1!==e.nodeType&&3!==e.nodeType;)e=e.nextSibling;return e},hydrateInstance:function(e,t,n,r,o,a){return e[De]=a,e[Me]=n,ra(e,t,n,o,r)},hydrateTextInstance:function(e,t,n){return e[De]=n,oa(e,t)},didNotMatchHydratedContainerTextInstance:function(){},didNotMatchHydratedTextInstance:function(){},didNotHydrateContainerInstance:function(){},didNotHydrateInstance:function(){},didNotFindHydratableContainerInstance:function(){},didNotFindHydratableContainerTextInstance:function(){},didNotFindHydratableInstance:function(){},didNotFindHydratableTextInstance:function(){}},scheduleDeferredCallback:go,cancelDeferredCallback:vo}),ha=pa;function ma(e,t,n,r,o){fa(n)||J("200");var a=n._reactRootContainer;if(a){if("function"==typeof o){var i=o;o=function(){var e=pa.getPublicRootInstance(a._internalRoot);i.call(e)}}null!=e?a.legacy_renderSubtreeIntoContainer(e,t,o):a.render(t,o)}else{if(a=n._reactRootContainer=function(e,t){if(t||(t=!(!(t=e?9===e.nodeType?e.documentElement:e.firstChild:null)||1!==t.nodeType||!t.hasAttribute("data-reactroot"))),!t)for(var n;n=e.lastChild;)e.removeChild(n);return new ca(e,!1,t)}(n,r),"function"==typeof o){var u=o;o=function(){var e=pa.getPublicRootInstance(a._internalRoot);u.call(e)}}pa.unbatchedUpdates(function(){null!=e?a.legacy_renderSubtreeIntoContainer(e,t,o):a.render(t,o)})}return pa.getPublicRootInstance(a._internalRoot)}function ga(e,t){var n=2<arguments.length&&void 0!==arguments[2]?arguments[2]:null;return fa(t)||J("200"),function(e,t,n){var r=3<arguments.length&&void 0!==arguments[3]?arguments[3]:null;return{$$typeof:Yt,key:null==r?null:""+r,children:e,containerInfo:t,implementation:n}}(e,t,null,n)}Tt=ha.batchedUpdates,St=ha.interactiveUpdates,Et=ha.flushInteractiveUpdates;var va={createPortal:ga,findDOMNode:function(e){if(null==e)return null;if(1===e.nodeType)return e;var t=e._reactInternalFiber;if(t)return pa.findHostInstance(t);"function"==typeof e.render?J("188"):J("213",Object.keys(e))},hydrate:function(e,t,n){return ma(null,e,t,!0,n)},render:function(e,t,n){return ma(null,e,t,!1,n)},unstable_renderSubtreeIntoContainer:function(e,t,n,r){return(null==e||void 0===e._reactInternalFiber)&&J("38"),ma(e,t,n,!1,r)},unmountComponentAtNode:function(e){return fa(e)||J("40"),!!e._reactRootContainer&&(pa.unbatchedUpdates(function(){ma(null,null,e,!1,function(){e._reactRootContainer=null})}),!0)},unstable_createPortal:function(){return ga.apply(void 0,arguments)},unstable_batchedUpdates:pa.batchedUpdates,unstable_deferredUpdates:pa.deferredUpdates,flushSync:pa.flushSync,unstable_flushControlled:pa.flushControlled,__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED:{EventPluginHub:Ee,EventPluginRegistry:fe,EventPropagators:We,ReactControlledComponent:xt,ReactDOMComponentTree:Ne,ReactDOMEventListener:cr},unstable_createRoot:function(e,t){return new ca(e,!0,null!=t&&!0===t.hydrate)}};pa.injectIntoDevTools({findFiberByHostInstance:Ie,bundleType:0,version:"16.3.0",rendererPackageName:"react-dom"});var ya=Object.freeze({default:va}),ba=ya&&va||ya,wa=ba.default?ba.default:ba,ka=(e(function(e){}),e(function(e){!function e(){if("undefined"!=typeof __REACT_DEVTOOLS_GLOBAL_HOOK__&&"function"==typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE)try{__REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(e)}catch(e){console.error(e)}}(),e.exports=wa}));var Ca=function(e){return e instanceof Date},xa=36e5,Ta=6e4,Sa=2,Ea=/[T ]/,_a=/:/,Da=/^(\d{2})$/,Ma=[/^([+-]\d{2})$/,/^([+-]\d{3})$/,/^([+-]\d{4})$/],Ia=/^(\d{4})/,Pa=[/^([+-]\d{4})/,/^([+-]\d{5})/,/^([+-]\d{6})/],Oa=/^-(\d{2})$/,Na=/^-?(\d{3})$/,Fa=/^-?(\d{2})-?(\d{2})$/,Ra=/^-?W(\d{2})$/,Ua=/^-?W(\d{2})-?(\d{1})$/,Aa=/^(\d{2}([.,]\d*)?)$/,Ha=/^(\d{2}):?(\d{2}([.,]\d*)?)$/,La=/^(\d{2}):?(\d{2}):?(\d{2}([.,]\d*)?)$/,za=/([Z+-].*)$/,Ya=/^(Z)$/,ja=/^([+-])(\d{2})$/,Wa=/^([+-])(\d{2}):?(\d{2})$/;function Va(e,t,n){t=t||0,n=n||0;var r=new Date(0);r.setUTCFullYear(e,0,4);var o=7*t+n+1-(r.getUTCDay()||7);return r.setUTCDate(r.getUTCDate()+o),r}var $a=function(e,t){if(Ca(e))return new Date(e.getTime());if("string"!=typeof e)return new Date(e);var n=(t||{}).additionalDigits;n=null==n?Sa:Number(n);var r=function(e){var t,n={},r=e.split(Ea);if(_a.test(r[0])?(n.date=null,t=r[0]):(n.date=r[0],t=r[1]),t){var o=za.exec(t);o?(n.time=t.replace(o[1],""),n.timezone=o[1]):n.time=t}return n}(e),o=function(e,t){var n,r=Ma[t],o=Pa[t];if(n=Ia.exec(e)||o.exec(e)){var a=n[1];return{year:parseInt(a,10),restDateString:e.slice(a.length)}}if(n=Da.exec(e)||r.exec(e)){var i=n[1];return{year:100*parseInt(i,10),restDateString:e.slice(i.length)}}return{year:null}}(r.date,n),a=o.year,i=function(e,t){if(null===t)return null;var n,r,o,a;if(0===e.length)return(r=new Date(0)).setUTCFullYear(t),r;if(n=Oa.exec(e))return r=new Date(0),o=parseInt(n[1],10)-1,r.setUTCFullYear(t,o),r;if(n=Na.exec(e)){r=new Date(0);var i=parseInt(n[1],10);return r.setUTCFullYear(t,0,i),r}if(n=Fa.exec(e)){r=new Date(0),o=parseInt(n[1],10)-1;var u=parseInt(n[2],10);return r.setUTCFullYear(t,o,u),r}if(n=Ra.exec(e))return a=parseInt(n[1],10)-1,Va(t,a);if(n=Ua.exec(e)){a=parseInt(n[1],10)-1;var l=parseInt(n[2],10)-1;return Va(t,a,l)}return null}(o.restDateString,a);if(i){var u,l=i.getTime(),s=0;return r.time&&(s=function(e){var t,n,r;if(t=Aa.exec(e))return(n=parseFloat(t[1].replace(",",".")))%24*xa;if(t=Ha.exec(e))return n=parseInt(t[1],10),r=parseFloat(t[2].replace(",",".")),n%24*xa+r*Ta;if(t=La.exec(e)){n=parseInt(t[1],10),r=parseInt(t[2],10);var o=parseFloat(t[3].replace(",","."));return n%24*xa+r*Ta+1e3*o}return null}(r.time)),r.timezone?(c=r.timezone,u=(f=Ya.exec(c))?0:(f=ja.exec(c))?(d=60*parseInt(f[2],10),"+"===f[1]?-d:d):(f=Wa.exec(c))?(d=60*parseInt(f[2],10)+parseInt(f[3],10),"+"===f[1]?-d:d):0):(u=new Date(l+s).getTimezoneOffset(),u=new Date(l+s+u*Ta).getTimezoneOffset()),new Date(l+s+u*Ta)}var c,f,d;return new Date(e)};var Ba=function(e,t){var n=$a(e),r=Number(t);return n.setDate(n.getDate()+r),n};var Ka=function(e,t){var n=$a(e).getTime(),r=Number(t);return new Date(n+r)},Qa=36e5;var qa=function(e,t){var n=Number(t);return Ka(e,n*Qa)};var Xa=function(e,t){var n=t&&Number(t.weekStartsOn)||0,r=$a(e),o=r.getDay(),a=(o<n?7:0)+o-n;return r.setDate(r.getDate()-a),r.setHours(0,0,0,0),r};var Ga=function(e){return Xa(e,{weekStartsOn:1})};var Za=function(e){var t=$a(e),n=t.getFullYear(),r=new Date(0);r.setFullYear(n+1,0,4),r.setHours(0,0,0,0);var o=Ga(r),a=new Date(0);a.setFullYear(n,0,4),a.setHours(0,0,0,0);var i=Ga(a);return t.getTime()>=o.getTime()?n+1:t.getTime()>=i.getTime()?n:n-1};var Ja=function(e){var t=Za(e),n=new Date(0);return n.setFullYear(t,0,4),n.setHours(0,0,0,0),Ga(n)};var ei=function(e){var t=$a(e);return t.setHours(0,0,0,0),t},ti=6e4,ni=864e5;var ri=function(e,t){var n=ei(e),r=ei(t),o=n.getTime()-n.getTimezoneOffset()*ti,a=r.getTime()-r.getTimezoneOffset()*ti;return Math.round((o-a)/ni)};var oi=function(e,t){var n=$a(e),r=Number(t),o=ri(n,Ja(n)),a=new Date(0);return a.setFullYear(r,0,4),a.setHours(0,0,0,0),(n=Ja(a)).setDate(n.getDate()+o),n};var ai=function(e,t){var n=Number(t);return oi(e,Za(e)+n)},ii=6e4;var ui=function(e,t){var n=Number(t);return Ka(e,n*ii)};var li=function(e){var t=$a(e),n=t.getFullYear(),r=t.getMonth(),o=new Date(0);return o.setFullYear(n,r+1,0),o.setHours(0,0,0,0),o.getDate()};var si=function(e,t){var n=$a(e),r=Number(t),o=n.getMonth()+r,a=new Date(0);a.setFullYear(n.getFullYear(),o,1),a.setHours(0,0,0,0);var i=li(a);return n.setMonth(o,Math.min(i,n.getDate())),n};var ci=function(e,t){var n=Number(t);return si(e,3*n)};var fi=function(e,t){var n=Number(t);return Ka(e,1e3*n)};var di=function(e,t){var n=Number(t);return Ba(e,7*n)};var pi=function(e,t){var n=Number(t);return si(e,12*n)};var hi=function(e,t,n,r){var o=$a(e).getTime(),a=$a(t).getTime(),i=$a(n).getTime(),u=$a(r).getTime();if(o>a||i>u)throw new Error("The start of the range cannot be after the end of the range");return o<u&&i<a};var mi=function(e,t){if(!(t instanceof Array))throw new TypeError(toString.call(t)+" is not an instance of Array");var n,r,o=$a(e).getTime();return t.forEach(function(e,t){var a=$a(e),i=Math.abs(o-a.getTime());(void 0===n||i<r)&&(n=t,r=i)}),n};var gi=function(e,t){if(!(t instanceof Array))throw new TypeError(toString.call(t)+" is not an instance of Array");var n,r,o=$a(e).getTime();return t.forEach(function(e){var t=$a(e),a=Math.abs(o-t.getTime());(void 0===n||a<r)&&(n=t,r=a)}),n};var vi=function(e,t){var n=$a(e).getTime(),r=$a(t).getTime();return n<r?-1:n>r?1:0};var yi=function(e,t){var n=$a(e).getTime(),r=$a(t).getTime();return n>r?-1:n<r?1:0},bi=6e4,wi=6048e5;var ki=function(e,t){var n=Ga(e),r=Ga(t),o=n.getTime()-n.getTimezoneOffset()*bi,a=r.getTime()-r.getTimezoneOffset()*bi;return Math.round((o-a)/wi)};var Ci=function(e,t){return Za(e)-Za(t)};var xi=function(e,t){var n=$a(e),r=$a(t);return 12*(n.getFullYear()-r.getFullYear())+(n.getMonth()-r.getMonth())};var Ti=function(e){var t=$a(e);return Math.floor(t.getMonth()/3)+1};var Si=function(e,t){var n=$a(e),r=$a(t);return 4*(n.getFullYear()-r.getFullYear())+(Ti(n)-Ti(r))},Ei=6e4,_i=6048e5;var Di=function(e,t,n){var r=Xa(e,n),o=Xa(t,n),a=r.getTime()-r.getTimezoneOffset()*Ei,i=o.getTime()-o.getTimezoneOffset()*Ei;return Math.round((a-i)/_i)};var Mi=function(e,t){var n=$a(e),r=$a(t);return n.getFullYear()-r.getFullYear()};var Ii=function(e,t){var n=$a(e),r=$a(t),o=vi(n,r),a=Math.abs(ri(n,r));return n.setDate(n.getDate()-o*a),o*(a-(vi(n,r)===-o))};var Pi=function(e,t){var n=$a(e),r=$a(t);return n.getTime()-r.getTime()},Oi=36e5;var Ni=function(e,t){var n=Pi(e,t)/Oi;return n>0?Math.floor(n):Math.ceil(n)};var Fi=function(e,t){var n=Number(t);return ai(e,-n)};var Ri=function(e,t){var n=$a(e),r=$a(t),o=vi(n,r),a=Math.abs(Ci(n,r));return n=Fi(n,o*a),o*(a-(vi(n,r)===-o))},Ui=6e4;var Ai=function(e,t){var n=Pi(e,t)/Ui;return n>0?Math.floor(n):Math.ceil(n)};var Hi=function(e,t){var n=$a(e),r=$a(t),o=vi(n,r),a=Math.abs(xi(n,r));return n.setMonth(n.getMonth()-o*a),o*(a-(vi(n,r)===-o))};var Li=function(e,t){var n=Hi(e,t)/3;return n>0?Math.floor(n):Math.ceil(n)};var zi=function(e,t){var n=Pi(e,t)/1e3;return n>0?Math.floor(n):Math.ceil(n)};var Yi=function(e,t){var n=Ii(e,t)/7;return n>0?Math.floor(n):Math.ceil(n)};var ji=function(e,t){var n=$a(e),r=$a(t),o=vi(n,r),a=Math.abs(Mi(n,r));return n.setFullYear(n.getFullYear()-o*a),o*(a-(vi(n,r)===-o))};var Wi=["M","MM","Q","D","DD","DDD","DDDD","d","E","W","WW","YY","YYYY","GG","GGGG","H","HH","h","hh","m","mm","s","ss","S","SS","SSS","Z","ZZ","X","x"];var Vi=function(e){var t=[];for(var n in e)e.hasOwnProperty(n)&&t.push(n);var r=Wi.concat(t).sort().reverse();return new RegExp("(\\[[^\\[]*\\])|(\\\\)?("+r.join("|")+"|.)","g")};var $i=function(){var e=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],t=["January","February","March","April","May","June","July","August","September","October","November","December"],n=["Su","Mo","Tu","We","Th","Fr","Sa"],r=["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],o=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],a=["AM","PM"],i=["am","pm"],u=["a.m.","p.m."],l={MMM:function(t){return e[t.getMonth()]},MMMM:function(e){return t[e.getMonth()]},dd:function(e){return n[e.getDay()]},ddd:function(e){return r[e.getDay()]},dddd:function(e){return o[e.getDay()]},A:function(e){return e.getHours()/12>=1?a[1]:a[0]},a:function(e){return e.getHours()/12>=1?i[1]:i[0]},aa:function(e){return e.getHours()/12>=1?u[1]:u[0]}};return["M","D","DDD","d","Q","W"].forEach(function(e){l[e+"o"]=function(t,n){return function(e){var t=e%100;if(t>20||t<10)switch(t%10){case 1:return e+"st";case 2:return e+"nd";case 3:return e+"rd"}return e+"th"}(n[e](t))}}),{formatters:l,formattingTokensRegExp:Vi(l)}},Bi={distanceInWords:function(){var e={lessThanXSeconds:{one:"less than a second",other:"less than {{count}} seconds"},xSeconds:{one:"1 second",other:"{{count}} seconds"},halfAMinute:"half a minute",lessThanXMinutes:{one:"less than a minute",other:"less than {{count}} minutes"},xMinutes:{one:"1 minute",other:"{{count}} minutes"},aboutXHours:{one:"about 1 hour",other:"about {{count}} hours"},xHours:{one:"1 hour",other:"{{count}} hours"},xDays:{one:"1 day",other:"{{count}} days"},aboutXMonths:{one:"about 1 month",other:"about {{count}} months"},xMonths:{one:"1 month",other:"{{count}} months"},aboutXYears:{one:"about 1 year",other:"about {{count}} years"},xYears:{one:"1 year",other:"{{count}} years"},overXYears:{one:"over 1 year",other:"over {{count}} years"},almostXYears:{one:"almost 1 year",other:"almost {{count}} years"}};return{localize:function(t,n,r){var o;return r=r||{},o="string"==typeof e[t]?e[t]:1===n?e[t].one:e[t].other.replace("{{count}}",n),r.addSuffix?r.comparison>0?"in "+o:o+" ago":o}}}(),format:$i()},Ki=1440,Qi=2520,qi=43200,Xi=86400;var Gi=function(e,t,n){var r=n||{},o=yi(e,t),a=r.locale,i=Bi.distanceInWords.localize;a&&a.distanceInWords&&a.distanceInWords.localize&&(i=a.distanceInWords.localize);var u,l,s={addSuffix:Boolean(r.addSuffix),comparison:o};o>0?(u=$a(e),l=$a(t)):(u=$a(t),l=$a(e));var c,f=zi(l,u),d=l.getTimezoneOffset()-u.getTimezoneOffset(),p=Math.round(f/60)-d;if(p<2)return r.includeSeconds?f<5?i("lessThanXSeconds",5,s):f<10?i("lessThanXSeconds",10,s):f<20?i("lessThanXSeconds",20,s):f<40?i("halfAMinute",null,s):i(f<60?"lessThanXMinutes":"xMinutes",1,s):0===p?i("lessThanXMinutes",1,s):i("xMinutes",p,s);if(p<45)return i("xMinutes",p,s);if(p<90)return i("aboutXHours",1,s);if(p<Ki)return i("aboutXHours",Math.round(p/60),s);if(p<Qi)return i("xDays",1,s);if(p<qi)return i("xDays",Math.round(p/Ki),s);if(p<Xi)return i("aboutXMonths",c=Math.round(p/qi),s);if((c=Hi(l,u))<12)return i("xMonths",Math.round(p/qi),s);var h=c%12,m=Math.floor(c/12);return h<3?i("aboutXYears",m,s):h<9?i("overXYears",m,s):i("almostXYears",m+1,s)},Zi=1440,Ji=43200,eu=525600;var tu=function(e){var t=$a(e);return t.setHours(23,59,59,999),t};var nu=function(e,t){var n=t&&Number(t.weekStartsOn)||0,r=$a(e),o=r.getDay(),a=6+(o<n?-7:0)-(o-n);return r.setDate(r.getDate()+a),r.setHours(23,59,59,999),r};var ru=function(e){var t=$a(e),n=t.getMonth();return t.setFullYear(t.getFullYear(),n+1,0),t.setHours(23,59,59,999),t};var ou=function(e){var t=$a(e),n=new Date(0);return n.setFullYear(t.getFullYear(),0,1),n.setHours(0,0,0,0),n};var au=function(e){var t=$a(e);return ri(t,ou(t))+1},iu=6048e5;var uu=function(e){var t=$a(e),n=Ga(t).getTime()-Ja(t).getTime();return Math.round(n/iu)+1};var lu=function(e){if(Ca(e))return!isNaN(e);throw new TypeError(toString.call(e)+" is not an instance of Date")};var su={M:function(e){return e.getMonth()+1},MM:function(e){return fu(e.getMonth()+1,2)},Q:function(e){return Math.ceil((e.getMonth()+1)/3)},D:function(e){return e.getDate()},DD:function(e){return fu(e.getDate(),2)},DDD:function(e){return au(e)},DDDD:function(e){return fu(au(e),3)},d:function(e){return e.getDay()},E:function(e){return e.getDay()||7},W:function(e){return uu(e)},WW:function(e){return fu(uu(e),2)},YY:function(e){return fu(e.getFullYear(),4).substr(2)},YYYY:function(e){return fu(e.getFullYear(),4)},GG:function(e){return String(Za(e)).substr(2)},GGGG:function(e){return Za(e)},H:function(e){return e.getHours()},HH:function(e){return fu(e.getHours(),2)},h:function(e){var t=e.getHours();return 0===t?12:t>12?t%12:t},hh:function(e){return fu(su.h(e),2)},m:function(e){return e.getMinutes()},mm:function(e){return fu(e.getMinutes(),2)},s:function(e){return e.getSeconds()},ss:function(e){return fu(e.getSeconds(),2)},S:function(e){return Math.floor(e.getMilliseconds()/100)},SS:function(e){return fu(Math.floor(e.getMilliseconds()/10),2)},SSS:function(e){return fu(e.getMilliseconds(),3)},Z:function(e){return cu(e.getTimezoneOffset(),":")},ZZ:function(e){return cu(e.getTimezoneOffset())},X:function(e){return Math.floor(e.getTime()/1e3)},x:function(e){return e.getTime()}};function cu(e,t){t=t||"";var n=e>0?"-":"+",r=Math.abs(e),o=r%60;return n+fu(Math.floor(r/60),2)+t+fu(o,2)}function fu(e,t){for(var n=Math.abs(e).toString();n.length<t;)n="0"+n;return n}var du=function(e){var t=$a(e).getFullYear();return t%400==0||t%4==0&&t%100!=0};var pu=function(e){var t=$a(e).getDay();return 0===t&&(t=7),t},hu=6048e5;var mu=864e5;var gu=function(e){var t=$a(e);return t.setMinutes(0,0,0),t};var vu=function(e,t){var n=gu(e),r=gu(t);return n.getTime()===r.getTime()};var yu=function(e,t,n){var r=Xa(e,n),o=Xa(t,n);return r.getTime()===o.getTime()};var bu=function(e,t){return yu(e,t,{weekStartsOn:1})};var wu=function(e,t){var n=Ja(e),r=Ja(t);return n.getTime()===r.getTime()};var ku=function(e){var t=$a(e);return t.setSeconds(0,0),t};var Cu=function(e,t){var n=ku(e),r=ku(t);return n.getTime()===r.getTime()};var xu=function(e,t){var n=$a(e),r=$a(t);return n.getFullYear()===r.getFullYear()&&n.getMonth()===r.getMonth()};var Tu=function(e){var t=$a(e),n=t.getMonth(),r=n-n%3;return t.setMonth(r,1),t.setHours(0,0,0,0),t};var Su=function(e,t){var n=Tu(e),r=Tu(t);return n.getTime()===r.getTime()};var Eu=function(e){var t=$a(e);return t.setMilliseconds(0),t};var _u=function(e,t){var n=Eu(e),r=Eu(t);return n.getTime()===r.getTime()};var Du=function(e,t){var n=$a(e),r=$a(t);return n.getFullYear()===r.getFullYear()};var Mu=function(e,t){var n=t&&Number(t.weekStartsOn)||0,r=$a(e),o=r.getDay(),a=6+(o<n?-7:0)-(o-n);return r.setHours(0,0,0,0),r.setDate(r.getDate()+a),r};var Iu=function(e,t){var n=$a(e),r=Number(t),o=n.getFullYear(),a=n.getDate(),i=new Date(0);i.setFullYear(o,r,15),i.setHours(0,0,0,0);var u=li(i);return n.setMonth(r,Math.min(a,u)),n};var Pu={addDays:Ba,addHours:qa,addISOYears:ai,addMilliseconds:Ka,addMinutes:ui,addMonths:si,addQuarters:ci,addSeconds:fi,addWeeks:di,addYears:pi,areRangesOverlapping:hi,closestIndexTo:mi,closestTo:gi,compareAsc:vi,compareDesc:yi,differenceInCalendarDays:ri,differenceInCalendarISOWeeks:ki,differenceInCalendarISOYears:Ci,differenceInCalendarMonths:xi,differenceInCalendarQuarters:Si,differenceInCalendarWeeks:Di,differenceInCalendarYears:Mi,differenceInDays:Ii,differenceInHours:Ni,differenceInISOYears:Ri,differenceInMilliseconds:Pi,differenceInMinutes:Ai,differenceInMonths:Hi,differenceInQuarters:Li,differenceInSeconds:zi,differenceInWeeks:Yi,differenceInYears:ji,distanceInWords:Gi,distanceInWordsStrict:function(e,t,n){var r=n||{},o=yi(e,t),a=r.locale,i=Bi.distanceInWords.localize;a&&a.distanceInWords&&a.distanceInWords.localize&&(i=a.distanceInWords.localize);var u,l,s,c={addSuffix:Boolean(r.addSuffix),comparison:o};o>0?(u=$a(e),l=$a(t)):(u=$a(t),l=$a(e));var f=Math[r.partialMethod?String(r.partialMethod):"floor"],d=zi(l,u),p=l.getTimezoneOffset()-u.getTimezoneOffset(),h=f(d/60)-p;if("s"===(s=r.unit?String(r.unit):h<1?"s":h<60?"m":h<Zi?"h":h<Ji?"d":h<eu?"M":"Y"))return i("xSeconds",d,c);if("m"===s)return i("xMinutes",h,c);if("h"===s)return i("xHours",f(h/60),c);if("d"===s)return i("xDays",f(h/Zi),c);if("M"===s)return i("xMonths",f(h/Ji),c);if("Y"===s)return i("xYears",f(h/eu),c);throw new Error("Unknown unit: "+s)},distanceInWordsToNow:function(e,t){return Gi(Date.now(),e,t)},eachDay:function(e,t,n){var r=$a(e),o=$a(t),a=void 0!==n?n:1,i=o.getTime();if(r.getTime()>i)throw new Error("The first date cannot be after the second date");var u=[],l=r;for(l.setHours(0,0,0,0);l.getTime()<=i;)u.push($a(l)),l.setDate(l.getDate()+a);return u},endOfDay:tu,endOfHour:function(e){var t=$a(e);return t.setMinutes(59,59,999),t},endOfISOWeek:function(e){return nu(e,{weekStartsOn:1})},endOfISOYear:function(e){var t=Za(e),n=new Date(0);n.setFullYear(t+1,0,4),n.setHours(0,0,0,0);var r=Ga(n);return r.setMilliseconds(r.getMilliseconds()-1),r},endOfMinute:function(e){var t=$a(e);return t.setSeconds(59,999),t},endOfMonth:ru,endOfQuarter:function(e){var t=$a(e),n=t.getMonth(),r=n-n%3+3;return t.setMonth(r,0),t.setHours(23,59,59,999),t},endOfSecond:function(e){var t=$a(e);return t.setMilliseconds(999),t},endOfToday:function(){return tu(new Date)},endOfTomorrow:function(){var e=new Date,t=e.getFullYear(),n=e.getMonth(),r=e.getDate(),o=new Date(0);return o.setFullYear(t,n,r+1),o.setHours(23,59,59,999),o},endOfWeek:nu,endOfYear:function(e){var t=$a(e),n=t.getFullYear();return t.setFullYear(n+1,0,0),t.setHours(23,59,59,999),t},endOfYesterday:function(){var e=new Date,t=e.getFullYear(),n=e.getMonth(),r=e.getDate(),o=new Date(0);return o.setFullYear(t,n,r-1),o.setHours(23,59,59,999),o},format:function(e,t,n){var r=t?String(t):"YYYY-MM-DDTHH:mm:ss.SSSZ",o=(n||{}).locale,a=Bi.format.formatters,i=Bi.format.formattingTokensRegExp;o&&o.format&&o.format.formatters&&(a=o.format.formatters,o.format.formattingTokensRegExp&&(i=o.format.formattingTokensRegExp));var u=$a(e);return lu(u)?function(e,t,n){var r,o,a,i=e.match(n),u=i.length;for(r=0;r<u;r++)o=t[i[r]]||su[i[r]],i[r]=o||((a=i[r]).match(/\[[\s\S]/)?a.replace(/^\[|]$/g,""):a.replace(/\\/g,""));return function(e){for(var t="",n=0;n<u;n++)i[n]instanceof Function?t+=i[n](e,su):t+=i[n];return t}}(r,a,i)(u):"Invalid Date"},getDate:function(e){return $a(e).getDate()},getDay:function(e){return $a(e).getDay()},getDayOfYear:au,getDaysInMonth:li,getDaysInYear:function(e){return du(e)?366:365},getHours:function(e){return $a(e).getHours()},getISODay:pu,getISOWeek:uu,getISOWeeksInYear:function(e){var t=Ja(e),n=Ja(di(t,60)).valueOf()-t.valueOf();return Math.round(n/hu)},getISOYear:Za,getMilliseconds:function(e){return $a(e).getMilliseconds()},getMinutes:function(e){return $a(e).getMinutes()},getMonth:function(e){return $a(e).getMonth()},getOverlappingDaysInRanges:function(e,t,n,r){var o=$a(e).getTime(),a=$a(t).getTime(),i=$a(n).getTime(),u=$a(r).getTime();if(o>a||i>u)throw new Error("The start of the range cannot be after the end of the range");if(!(o<u&&i<a))return 0;var l=(u>a?a:u)-(i<o?o:i);return Math.ceil(l/mu)},getQuarter:Ti,getSeconds:function(e){return $a(e).getSeconds()},getTime:function(e){return $a(e).getTime()},getYear:function(e){return $a(e).getFullYear()},isAfter:function(e,t){var n=$a(e),r=$a(t);return n.getTime()>r.getTime()},isBefore:function(e,t){var n=$a(e),r=$a(t);return n.getTime()<r.getTime()},isDate:Ca,isEqual:function(e,t){var n=$a(e),r=$a(t);return n.getTime()===r.getTime()},isFirstDayOfMonth:function(e){return 1===$a(e).getDate()},isFriday:function(e){return 5===$a(e).getDay()},isFuture:function(e){return $a(e).getTime()>(new Date).getTime()},isLastDayOfMonth:function(e){var t=$a(e);return tu(t).getTime()===ru(t).getTime()},isLeapYear:du,isMonday:function(e){return 1===$a(e).getDay()},isPast:function(e){return $a(e).getTime()<(new Date).getTime()},isSameDay:function(e,t){var n=ei(e),r=ei(t);return n.getTime()===r.getTime()},isSameHour:vu,isSameISOWeek:bu,isSameISOYear:wu,isSameMinute:Cu,isSameMonth:xu,isSameQuarter:Su,isSameSecond:_u,isSameWeek:yu,isSameYear:Du,isSaturday:function(e){return 6===$a(e).getDay()},isSunday:function(e){return 0===$a(e).getDay()},isThisHour:function(e){return vu(new Date,e)},isThisISOWeek:function(e){return bu(new Date,e)},isThisISOYear:function(e){return wu(new Date,e)},isThisMinute:function(e){return Cu(new Date,e)},isThisMonth:function(e){return xu(new Date,e)},isThisQuarter:function(e){return Su(new Date,e)},isThisSecond:function(e){return _u(new Date,e)},isThisWeek:function(e,t){return yu(new Date,e,t)},isThisYear:function(e){return Du(new Date,e)},isThursday:function(e){return 4===$a(e).getDay()},isToday:function(e){return ei(e).getTime()===ei(new Date).getTime()},isTomorrow:function(e){var t=new Date;return t.setDate(t.getDate()+1),ei(e).getTime()===ei(t).getTime()},isTuesday:function(e){return 2===$a(e).getDay()},isValid:lu,isWednesday:function(e){return 3===$a(e).getDay()},isWeekend:function(e){var t=$a(e).getDay();return 0===t||6===t},isWithinRange:function(e,t,n){var r=$a(e).getTime(),o=$a(t).getTime(),a=$a(n).getTime();if(o>a)throw new Error("The start of the range cannot be after the end of the range");return r>=o&&r<=a},isYesterday:function(e){var t=new Date;return t.setDate(t.getDate()-1),ei(e).getTime()===ei(t).getTime()},lastDayOfISOWeek:function(e){return Mu(e,{weekStartsOn:1})},lastDayOfISOYear:function(e){var t=Za(e),n=new Date(0);n.setFullYear(t+1,0,4),n.setHours(0,0,0,0);var r=Ga(n);return r.setDate(r.getDate()-1),r},lastDayOfMonth:function(e){var t=$a(e),n=t.getMonth();return t.setFullYear(t.getFullYear(),n+1,0),t.setHours(0,0,0,0),t},lastDayOfQuarter:function(e){var t=$a(e),n=t.getMonth(),r=n-n%3+3;return t.setMonth(r,0),t.setHours(0,0,0,0),t},lastDayOfWeek:Mu,lastDayOfYear:function(e){var t=$a(e),n=t.getFullYear();return t.setFullYear(n+1,0,0),t.setHours(0,0,0,0),t},max:function(){var e=Array.prototype.slice.call(arguments).map(function(e){return $a(e)}),t=Math.max.apply(null,e);return new Date(t)},min:function(){var e=Array.prototype.slice.call(arguments).map(function(e){return $a(e)}),t=Math.min.apply(null,e);return new Date(t)},parse:$a,setDate:function(e,t){var n=$a(e),r=Number(t);return n.setDate(r),n},setDay:function(e,t,n){var r=n&&Number(n.weekStartsOn)||0,o=$a(e),a=Number(t),i=o.getDay();return Ba(o,((a%7+7)%7<r?7:0)+a-i)},setDayOfYear:function(e,t){var n=$a(e),r=Number(t);return n.setMonth(0),n.setDate(r),n},setHours:function(e,t){var n=$a(e),r=Number(t);return n.setHours(r),n},setISODay:function(e,t){var n=$a(e),r=Number(t),o=pu(n);return Ba(n,r-o)},setISOWeek:function(e,t){var n=$a(e),r=Number(t),o=uu(n)-r;return n.setDate(n.getDate()-7*o),n},setISOYear:oi,setMilliseconds:function(e,t){var n=$a(e),r=Number(t);return n.setMilliseconds(r),n},setMinutes:function(e,t){var n=$a(e),r=Number(t);return n.setMinutes(r),n},setMonth:Iu,setQuarter:function(e,t){var n=$a(e),r=Number(t)-(Math.floor(n.getMonth()/3)+1);return Iu(n,n.getMonth()+3*r)},setSeconds:function(e,t){var n=$a(e),r=Number(t);return n.setSeconds(r),n},setYear:function(e,t){var n=$a(e),r=Number(t);return n.setFullYear(r),n},startOfDay:ei,startOfHour:gu,startOfISOWeek:Ga,startOfISOYear:Ja,startOfMinute:ku,startOfMonth:function(e){var t=$a(e);return t.setDate(1),t.setHours(0,0,0,0),t},startOfQuarter:Tu,startOfSecond:Eu,startOfToday:function(){return ei(new Date)},startOfTomorrow:function(){var e=new Date,t=e.getFullYear(),n=e.getMonth(),r=e.getDate(),o=new Date(0);return o.setFullYear(t,n,r+1),o.setHours(0,0,0,0),o},startOfWeek:Xa,startOfYear:ou,startOfYesterday:function(){var e=new Date,t=e.getFullYear(),n=e.getMonth(),r=e.getDate(),o=new Date(0);return o.setFullYear(t,n,r-1),o.setHours(0,0,0,0),o},subDays:function(e,t){var n=Number(t);return Ba(e,-n)},subHours:function(e,t){var n=Number(t);return qa(e,-n)},subISOYears:Fi,subMilliseconds:function(e,t){var n=Number(t);return Ka(e,-n)},subMinutes:function(e,t){var n=Number(t);return ui(e,-n)},subMonths:function(e,t){var n=Number(t);return si(e,-n)},subQuarters:function(e,t){var n=Number(t);return ci(e,-n)},subSeconds:function(e,t){var n=Number(t);return fi(e,-n)},subWeeks:function(e,t){var n=Number(t);return di(e,-n)},subYears:function(e,t){var n=Number(t);return pi(e,-n)}};const Ou=Symbol("Mint.Equals"),Nu=(e,t)=>null!=e&&void 0!=e&&e[Ou]?e[Ou](t):null!=t&&void 0!=t&&t[Ou]?t[Ou](e):(console.warn(`Could not compare "${e}" with "${t}" comparing with ===`),e===t);class Record{constructor(e){for(let t in e)this[t]=e[t]}[Ou](e){if(!(e instanceof Record))return!1;if(Object.keys(this).length!==Object.keys(e).length)return!1;for(let t in this)if(!Nu(e[t],this[t]))return!1;return!0}}const Fu=(e,t=!0)=>{window.location.pathname!==e&&(window.history.pushState({},"",e),t&&dispatchEvent(new PopStateEvent("popstate")))};class Maybe{}class Nothing extends Maybe{[Ou](e){return e instanceof Nothing}}class Just extends Maybe{constructor(e){super(),this.value=e}[Ou](e){return e instanceof Just&&Nu(e.value,this.value)}}class Ru{constructor(e){this.value=e}[Ou](e){return e instanceof this.constructor&&Nu(e.value,this.value)}}class Err extends Ru{}class Ok extends Ru{}var Uu=e(function(e,t){var n=function(){var e=function(e,t,n,r){for(n=n||{},r=e.length;r--;n[e[r]]=t);return n},t=[1,9],n=[1,10],r=[1,11],o=[1,12],a=[5,11,12,13,14,15],i={trace:function(){},yy:{},symbols_:{error:2,root:3,expressions:4,EOF:5,expression:6,optional:7,literal:8,splat:9,param:10,"(":11,")":12,LITERAL:13,SPLAT:14,PARAM:15,$accept:0,$end:1},terminals_:{2:"error",5:"EOF",11:"(",12:")",13:"LITERAL",14:"SPLAT",15:"PARAM"},productions_:[0,[3,2],[3,1],[4,2],[4,1],[6,1],[6,1],[6,1],[6,1],[7,3],[8,1],[9,1],[10,1]],performAction:function(e,t,n,r,o,a,i){var u=a.length-1;switch(o){case 1:return new r.Root({},[a[u-1]]);case 2:return new r.Root({},[new r.Literal({value:""})]);case 3:this.$=new r.Concat({},[a[u-1],a[u]]);break;case 4:case 5:this.$=a[u];break;case 6:this.$=new r.Literal({value:a[u]});break;case 7:this.$=new r.Splat({name:a[u]});break;case 8:this.$=new r.Param({name:a[u]});break;case 9:this.$=new r.Optional({},[a[u-1]]);break;case 10:this.$=e;break;case 11:case 12:this.$=e.slice(1)}},table:[{3:1,4:2,5:[1,3],6:4,7:5,8:6,9:7,10:8,11:t,13:n,14:r,15:o},{1:[3]},{5:[1,13],6:14,7:5,8:6,9:7,10:8,11:t,13:n,14:r,15:o},{1:[2,2]},e(a,[2,4]),e(a,[2,5]),e(a,[2,6]),e(a,[2,7]),e(a,[2,8]),{4:15,6:4,7:5,8:6,9:7,10:8,11:t,13:n,14:r,15:o},e(a,[2,10]),e(a,[2,11]),e(a,[2,12]),{1:[2,1]},e(a,[2,3]),{6:14,7:5,8:6,9:7,10:8,11:t,12:[1,16],13:n,14:r,15:o},e(a,[2,9])],defaultActions:{3:[2,2],13:[2,1]},parseError:function(e,t){if(!t.recoverable){function n(e,t){this.message=e,this.hash=t}throw n.prototype=Error,new n(e,t)}this.trace(e)},parse:function(e){var t=this,n=[0],r=[null],o=[],a=this.table,i="",u=0,l=0,s=o.slice.call(arguments,1),c=Object.create(this.lexer),f={yy:{}};for(var d in this.yy)Object.prototype.hasOwnProperty.call(this.yy,d)&&(f.yy[d]=this.yy[d]);c.setInput(e,f.yy),f.yy.lexer=c,f.yy.parser=this,void 0===c.yylloc&&(c.yylloc={});var p=c.yylloc;o.push(p);var h=c.options&&c.options.ranges;"function"==typeof f.yy.parseError?this.parseError=f.yy.parseError:this.parseError=Object.getPrototypeOf(this).parseError;for(var m,g,v,y,b,w,k,C,x,T=function(){var e;return"number"!=typeof(e=c.lex()||1)&&(e=t.symbols_[e]||e),e},S={};;){if(v=n[n.length-1],this.defaultActions[v]?y=this.defaultActions[v]:(null!==m&&void 0!==m||(m=T()),y=a[v]&&a[v][m]),void 0===y||!y.length||!y[0]){var E="";for(w in x=[],a[v])this.terminals_[w]&&w>2&&x.push("'"+this.terminals_[w]+"'");E=c.showPosition?"Parse error on line "+(u+1)+":\n"+c.showPosition()+"\nExpecting "+x.join(", ")+", got '"+(this.terminals_[m]||m)+"'":"Parse error on line "+(u+1)+": Unexpected "+(1==m?"end of input":"'"+(this.terminals_[m]||m)+"'"),this.parseError(E,{text:c.match,token:this.terminals_[m]||m,line:c.yylineno,loc:p,expected:x})}if(y[0]instanceof Array&&y.length>1)throw new Error("Parse Error: multiple actions possible at state: "+v+", token: "+m);switch(y[0]){case 1:n.push(m),r.push(c.yytext),o.push(c.yylloc),n.push(y[1]),m=null,g?(m=g,g=null):(l=c.yyleng,i=c.yytext,u=c.yylineno,p=c.yylloc);break;case 2:if(k=this.productions_[y[1]][1],S.$=r[r.length-k],S._$={first_line:o[o.length-(k||1)].first_line,last_line:o[o.length-1].last_line,first_column:o[o.length-(k||1)].first_column,last_column:o[o.length-1].last_column},h&&(S._$.range=[o[o.length-(k||1)].range[0],o[o.length-1].range[1]]),void 0!==(b=this.performAction.apply(S,[i,l,u,f.yy,y[1],r,o].concat(s))))return b;k&&(n=n.slice(0,-1*k*2),r=r.slice(0,-1*k),o=o.slice(0,-1*k)),n.push(this.productions_[y[1]][0]),r.push(S.$),o.push(S._$),C=a[n[n.length-2]][n[n.length-1]],n.push(C);break;case 3:return!0}}return!0}},u={EOF:1,parseError:function(e,t){if(!this.yy.parser)throw new Error(e);this.yy.parser.parseError(e,t)},setInput:function(e,t){return this.yy=t||this.yy||{},this._input=e,this._more=this._backtrack=this.done=!1,this.yylineno=this.yyleng=0,this.yytext=this.matched=this.match="",this.conditionStack=["INITIAL"],this.yylloc={first_line:1,first_column:0,last_line:1,last_column:0},this.options.ranges&&(this.yylloc.range=[0,0]),this.offset=0,this},input:function(){var e=this._input[0];return this.yytext+=e,this.yyleng++,this.offset++,this.match+=e,this.matched+=e,e.match(/(?:\r\n?|\n).*/g)?(this.yylineno++,this.yylloc.last_line++):this.yylloc.last_column++,this.options.ranges&&this.yylloc.range[1]++,this._input=this._input.slice(1),e},unput:function(e){var t=e.length,n=e.split(/(?:\r\n?|\n)/g);this._input=e+this._input,this.yytext=this.yytext.substr(0,this.yytext.length-t),this.offset-=t;var r=this.match.split(/(?:\r\n?|\n)/g);this.match=this.match.substr(0,this.match.length-1),this.matched=this.matched.substr(0,this.matched.length-1),n.length-1&&(this.yylineno-=n.length-1);var o=this.yylloc.range;return this.yylloc={first_line:this.yylloc.first_line,last_line:this.yylineno+1,first_column:this.yylloc.first_column,last_column:n?(n.length===r.length?this.yylloc.first_column:0)+r[r.length-n.length].length-n[0].length:this.yylloc.first_column-t},this.options.ranges&&(this.yylloc.range=[o[0],o[0]+this.yyleng-t]),this.yyleng=this.yytext.length,this},more:function(){return this._more=!0,this},reject:function(){return this.options.backtrack_lexer?(this._backtrack=!0,this):this.parseError("Lexical error on line "+(this.yylineno+1)+". You can only invoke reject() in the lexer when the lexer is of the backtracking persuasion (options.backtrack_lexer = true).\n"+this.showPosition(),{text:"",token:null,line:this.yylineno})},less:function(e){this.unput(this.match.slice(e))},pastInput:function(){var e=this.matched.substr(0,this.matched.length-this.match.length);return(e.length>20?"...":"")+e.substr(-20).replace(/\n/g,"")},upcomingInput:function(){var e=this.match;return e.length<20&&(e+=this._input.substr(0,20-e.length)),(e.substr(0,20)+(e.length>20?"...":"")).replace(/\n/g,"")},showPosition:function(){var e=this.pastInput(),t=new Array(e.length+1).join("-");return e+this.upcomingInput()+"\n"+t+"^"},test_match:function(e,t){var n,r,o;if(this.options.backtrack_lexer&&(o={yylineno:this.yylineno,yylloc:{first_line:this.yylloc.first_line,last_line:this.last_line,first_column:this.yylloc.first_column,last_column:this.yylloc.last_column},yytext:this.yytext,match:this.match,matches:this.matches,matched:this.matched,yyleng:this.yyleng,offset:this.offset,_more:this._more,_input:this._input,yy:this.yy,conditionStack:this.conditionStack.slice(0),done:this.done},this.options.ranges&&(o.yylloc.range=this.yylloc.range.slice(0))),(r=e[0].match(/(?:\r\n?|\n).*/g))&&(this.yylineno+=r.length),this.yylloc={first_line:this.yylloc.last_line,last_line:this.yylineno+1,first_column:this.yylloc.last_column,last_column:r?r[r.length-1].length-r[r.length-1].match(/\r?\n?/)[0].length:this.yylloc.last_column+e[0].length},this.yytext+=e[0],this.match+=e[0],this.matches=e,this.yyleng=this.yytext.length,this.options.ranges&&(this.yylloc.range=[this.offset,this.offset+=this.yyleng]),this._more=!1,this._backtrack=!1,this._input=this._input.slice(e[0].length),this.matched+=e[0],n=this.performAction.call(this,this.yy,this,t,this.conditionStack[this.conditionStack.length-1]),this.done&&this._input&&(this.done=!1),n)return n;if(this._backtrack){for(var a in o)this[a]=o[a];return!1}return!1},next:function(){if(this.done)return this.EOF;var e,t,n,r;this._input||(this.done=!0),this._more||(this.yytext="",this.match="");for(var o=this._currentRules(),a=0;a<o.length;a++)if((n=this._input.match(this.rules[o[a]]))&&(!t||n[0].length>t[0].length)){if(t=n,r=a,this.options.backtrack_lexer){if(!1!==(e=this.test_match(n,o[a])))return e;if(this._backtrack){t=!1;continue}return!1}if(!this.options.flex)break}return t?!1!==(e=this.test_match(t,o[r]))&&e:""===this._input?this.EOF:this.parseError("Lexical error on line "+(this.yylineno+1)+". Unrecognized text.\n"+this.showPosition(),{text:"",token:null,line:this.yylineno})},lex:function(){var e=this.next();return e||this.lex()},begin:function(e){this.conditionStack.push(e)},popState:function(){return this.conditionStack.length-1>0?this.conditionStack.pop():this.conditionStack[0]},_currentRules:function(){return this.conditionStack.length&&this.conditionStack[this.conditionStack.length-1]?this.conditions[this.conditionStack[this.conditionStack.length-1]].rules:this.conditions.INITIAL.rules},topState:function(e){return(e=this.conditionStack.length-1-Math.abs(e||0))>=0?this.conditionStack[e]:"INITIAL"},pushState:function(e){this.begin(e)},stateStackSize:function(){return this.conditionStack.length},options:{},performAction:function(e,t,n,r){switch(n){case 0:return"(";case 1:return")";case 2:return"SPLAT";case 3:return"PARAM";case 4:case 5:return"LITERAL";case 6:return"EOF"}},rules:[/^(?:\()/,/^(?:\))/,/^(?:\*+\w+)/,/^(?::+\w+)/,/^(?:[\w%\-~\n]+)/,/^(?:.)/,/^(?:$)/],conditions:{INITIAL:{rules:[0,1,2,3,4,5,6],inclusive:!0}}};function l(){this.yy={}}return i.lexer=u,l.prototype=i,i.Parser=l,new l}();t.parser=n,t.Parser=n.Parser,t.parse=function(){return n.parse.apply(n,arguments)}});Uu.parser,Uu.Parser,Uu.parse;function Au(e){return function(t,n){return{displayName:e,props:t,children:n||[]}}}var Hu={Root:Au("Root"),Concat:Au("Concat"),Literal:Au("Literal"),Splat:Au("Splat"),Param:Au("Param"),Optional:Au("Optional")},Lu=Uu.parser;Lu.yy=Hu;var zu=Lu,Yu=Object.keys(Hu);var ju=function(e){return Yu.forEach(function(t){if(void 0===e[t])throw new Error("No handler defined for "+t.displayName)}),{visit:function(e,t){return this.handlers[e.displayName].call(this,e,t)},handlers:e}},Wu=/[\-{}\[\]+?.,\\\^$|#\s]/g;function Vu(e){this.captures=e.captures,this.re=e.re}Vu.prototype.match=function(e){var t=this.re.exec(e),n={};if(t)return this.captures.forEach(function(e,r){void 0===t[r+1]?n[e]=void 0:n[e]=decodeURIComponent(t[r+1])}),n};var $u=ju({Concat:function(e){return e.children.reduce(function(e,t){var n=this.visit(t);return{re:e.re+n.re,captures:e.captures.concat(n.captures)}}.bind(this),{re:"",captures:[]})},Literal:function(e){return{re:e.props.value.replace(Wu,"\\$&"),captures:[]}},Splat:function(e){return{re:"([^?]*?)",captures:[e.props.name]}},Param:function(e){return{re:"([^\\/\\?]+)",captures:[e.props.name]}},Optional:function(e){var t=this.visit(e.children[0]);return{re:"(?:"+t.re+")?",captures:t.captures}},Root:function(e){var t=this.visit(e.children[0]);return new Vu({re:new RegExp("^"+t.re+"(?=\\?|$)"),captures:t.captures})}}),Bu=ju({Concat:function(e,t){var n=e.children.map(function(e){return this.visit(e,t)}.bind(this));return!n.some(function(e){return!1===e})&&n.join("")},Literal:function(e){return decodeURI(e.props.value)},Splat:function(e,t){return!!t[e.props.name]&&t[e.props.name]},Param:function(e,t){return!!t[e.props.name]&&t[e.props.name]},Optional:function(e,t){var n=this.visit(e.children[0],t);return n||""},Root:function(e,t){t=t||{};var n=this.visit(e.children[0],t);return!!n&&encodeURI(n)}});function Ku(e){var t;if(t=this?this:Object.create(Ku.prototype),void 0===e)throw new Error("A route spec is required");return t.spec=e,t.ast=zu.parse(e),t}Ku.prototype=Object.create(null),Ku.prototype.match=function(e){var t=$u.visit(this.ast).match(e);return t||!1},Ku.prototype.reverse=function(e){return Bu.visit(this.ast,e)};var Qu=Ku;Event.prototype.propagationPath=function(){var e=function(){var e=this.target||null,t=[e];if(!e||!e.parentElement)return[];for(;e.parentElement;)e=e.parentElement,t.unshift(e);return t}.bind(this);return this.path||this.composedPath&&this.composedPath()||e()};const qu=e=>{let t=JSON.stringify(e,"",2);return void 0===t&&(t="undefined"),((e,t,n)=>{const r="object"==typeof n?Object.assign({indent:" "},n):{indent:n||" "};if(t=void 0===t?1:t,"string"!=typeof e)throw new TypeError(`Expected \`input\` to be a \`string\`, got \`${typeof e}\``);if("number"!=typeof t)throw new TypeError(`Expected \`count\` to be a \`number\`, got \`${typeof t}\``);if("string"!=typeof r.indent)throw new TypeError(`Expected \`options.indent\` to be a \`string\`, got \`${typeof r.indent}\``);if(0===t)return e;const o=r.includeEmptyLines?/^/gm:/^(?!\s*$)/gm;return e.replace(o,r.indent.repeat(t))})(t)};class Xu{constructor(e,t=[]){this.message=e,this.object=null,this.path=t}push(e){this.path.unshift(e)}toString(){const e=this.message.trim(),t=this.path.reduce((e,t)=>{if(e.length)switch(t.type){case"FIELD":return`${e}.${t.value}`;case"ARRAY":return`${e}[${t.value}]`}else switch(t.type){case"FIELD":return t.value;case"ARRAY":return"[$(item.value)]"}},"");return t.length&&this.object?e+"\n\n"+Gu.trim().replace("{value}",qu(this.object)).replace("{path}",t):e}}const Gu="\nThe input is in this object:\n\n{value}\n\nat: {path}\n",Zu="\nI was trying to decode the value:\n\n{value}\n\nas a String, but could not.\n",Ju="\nI was trying to decode the value:\n\n{value}\n\nas a Time, but could not.\n",el="\nI was trying to decode the value:\n\n{value}\n\nas a Number, but could not.\n",tl="\nI was trying to decode the value:\n\n{value}\n\nas a Bool, but could not.\n",nl='\nI was trying to decode the field "{field}" from the object:\n\n{value}\n\nbut I could not because it\'s not an object.\n',rl="\nI was trying to decode the value:\n\n{value}\n\nas an Array, but could not.\n",ol='\nI was trying to decode the field "{field}" from the object:\n\n{value}\n\nbut I could not because it\'s not an object.\n';var al={boolean:e=>"boolean"!=typeof e?new Err(new Xu(tl.replace("{value}",qu(e)))):new Ok(e),number:e=>{let t=parseFloat(e);return isNaN(t)?new Err(new Xu(el.replace("{value}",qu(e)))):new Ok(t)},string:e=>"string"!=typeof e?new Err(new Xu(Zu.replace("{value}",qu(e)))):new Ok(e),field:(e,t)=>n=>{if(null==n||void 0==n||"object"!=typeof n||Array.isArray(n)){const t=nl.replace("{field}",e).replace("{value}",qu(n));return new Err(new Xu(t))}{const r=n[e],o=ol.replace("{field}",e).replace("{value}",qu(n));if(void 0===r)return new Err(new Xu(o));const a=t(r);return a instanceof Err&&(a.value.push({type:"FIELD",value:e}),a.value.object=n),a}},array:e=>t=>{if(!Array.isArray(t))return new Err(new Xu(rl.replace("{value}",qu(t))));let n=[],r=0;for(let o of t){let a=e(o);if(a instanceof Err)return a.value.push({type:"ARRAY",value:r}),a.value.object=t,a;n.push(a.value),r++}return new Ok(n)},maybe:e=>t=>{if(null==t||void 0==t)return new Ok(new Nothing);{const n=e(t);return n instanceof Err?n:new Ok(new Just(n.value))}},time:e=>{const t=Date.parse(e);return Number.isNaN(t)?new Err(new Xu(Ju.replace("{value}",qu(e)))):new Ok(new Date(t))}};const il=e=>{if(null==e||void 0==e)return null;if(Array.isArray(e))return e.map(il);switch(typeof e){case"string":case"boolean":case"number":return e;case"object":if(e instanceof Just)return e.value;if(e instanceof Nothing)return null;if(e instanceof Record){let t={};for(let n in e)t[n]=il(e[n]);return t}default:return e}};return Symbol.prototype[Ou]=function(e){return this.valueOf()===e},Date.prototype[Ou]=function(e){return+this==+e},Number.prototype[Ou]=function(e){return this.valueOf()===e},Boolean.prototype[Ou]=function(e){return this.valueOf()===e},String.prototype[Ou]=function(e){return this.valueOf()===e},Array.prototype[Ou]=function(e){return this.length===e.length&&(0==this.length||!!this.filter((t,n)=>Nu(t,e[n])).length)},FormData.prototype[Ou]=function(e){const t=Array.from(this.keys()),n=Array.from(e.keys());return!!Nu(t,n)&&(0==t.length||!!t.filter(t=>{const n=Array.from(this.getAll(t).sort()),r=Array.from(e.getAll(t).sort());return Nu(n,r)}).length)},{program:new class{constructor(){this.root=document.createElement("div"),document.body.appendChild(this.root),this.routes=[],this.root.addEventListener("click",e=>{for(let t of e.propagationPath())if("A"===t.tagName){let n=t.origin,r=t.search,o=t.pathname;if(n===window.location.origin)for(let n of this.routes)if(new Qu(n.path).match(o+r))return e.preventDefault(),void Fu(t.href)}}),window.addEventListener("popstate",()=>{this.handlePopState()})}handlePopState(){for(let e of this.routes)if("*"===e.path)e.handler();else{let t=new Qu(e.path).match(window.location.pathname+window.location.search);if(t){let n=e.mapping.map(e=>t[e]);e.mapping.reduce((e,n)=>(e[n]=t[n],e),{}),e.handler.apply(null,n);break}}}render(e){void 0!==e&&(this.handlePopState(),ka.render(W.createElement(e),this.root))}addRoutes(e){this.routes=this.routes.concat(e)}},normalizeEvent:e=>new Proxy(e,{get:function(e,t){if(t in e)return e[t];switch(t){case"clipboardData":return new DataTransfer;case"data":return"";case"altKey":return!1;case"charCode":return-1;case"ctrlKey":return!1;case"key":return"";case"keyCode":return-1;case"locale":return"";case"location":return-1;case"metaKey":case"repeat":case"shiftKey":return!1;case"which":case"button":case"buttons":case"clientX":case"clientY":case"pageX":case"pageY":case"screenX":case"screenY":case"detail":case"deltaMode":case"deltaX":case"deltaY":case"deltaZ":return-1;case"animationName":case"pseudoElement":return"";case"elapsedTime":return-1;case"propertyName":return"";default:return}}}),insertStyles:e=>{let t=document.createElement("style");document.head.appendChild(t),t.innerHTML=e},navigate:Fu,compare:Nu,update:(e,t)=>new Record(Object.assign(Object.create(null),e,t)),encode:il,Component:W.PureComponent,ReactDOM:ka,TestContext:class{constructor(e,t){this.teardown=t,this.subject=e,this.steps=[]}async run(){let e;try{e=await new Promise(this.next.bind(this))}finally{this.teardown&&this.teardown()}return e}async next(e,t){requestAnimationFrame(async()=>{let n=this.steps.shift();if(n)try{this.subject=await n(this.subject)}catch(e){return t(e)}this.steps.length?this.next(e,t):e(this.subject)})}step(e){return this.steps.push(e),this}},Provider:class{constructor(){this.subscriptions=new Map}_subscribe(e,t){this.subscriptions.has(e)||(this.subscriptions.set(e,t),this._update())}_unsubscribe(e){this.subscriptions.has(e)&&(this.subscriptions.delete(e),this._update())}_update(){0==this.subscriptions.size?this.detach():this.attach()}get _subscriptions(){let e=[];for(let t of this.subscriptions.values())e.push(t);return e}attach(){}detach(){}},Store:class{constructor(){this.listeners=new Set,this.props={}}setState(e,t){this.props=Object.assign({},this.state,e);for(let e of this.listeners)e.forceUpdate();t()}_subscribe(e){this.listeners.add(e)}_unsubscribe(e){this.listeners.delete(e)}},Nothing:Nothing,Just:Just,Err:Err,Ok:Ok,Decoder:al,DateFNS:Pu,Record:Record,createPortal:ka.createPortal,createElement:W.createElement,Symbols:{Equals:Ou}}}();


(() => {
  const _normalizeEvent = Mint.normalizeEvent;
  const _createElement = Mint.createElement;
  const _createPortal = Mint.createPortal;
  const _insertStyles = Mint.insertStyles;
  const _navigate = Mint.navigate;
  const _compare = Mint.compare;
  const _program = Mint.program;
  const _update = Mint.update;
  const _encode = Mint.encode;
  const _array = function() {
    let items = Array.from(arguments)
    if (Array.isArray(items[0]) && items.length === 1) {
      return items[0]
    } else {
      return items
    }
  }

  const TestContext = Mint.TestContext;
  const Component = Mint.Component;
  const ReactDOM = Mint.ReactDOM;
  const Provider = Mint.Provider;
  const Nothing = Mint.Nothing;
  const Decoder = Mint.Decoder;
  const DateFNS = Mint.DateFNS;
  const Record = Mint.Record;
  const Store = Mint.Store;
  const Just = Mint.Just;
  const Err = Mint.Err;
  const Ok = Mint.Ok;

  class DoError extends Error {}

  $Page_Dashboard = Symbol.for(`Page_Dashboard`)
$Page_Package = Symbol.for(`Page_Package`)
$Page_Entity = Symbol.for(`Page_Entity`)

$Type_Component = Symbol.for(`Type_Component`)
$Type_Provider = Symbol.for(`Type_Provider`)
$Type_Record = Symbol.for(`Type_Record`)
$Type_Module = Symbol.for(`Type_Module`)
$Type_Store = Symbol.for(`Type_Store`)
$Type_Enum = Symbol.for(`Type_Enum`)

$Status_DecodeError = Symbol.for(`Status_DecodeError`)
$Status_HttpError = Symbol.for(`Status_HttpError`)
$Status_JsonError = Symbol.for(`Status_JsonError`)
$Status_Initial = Symbol.for(`Status_Initial`)
$Status_Ok = Symbol.for(`Status_Ok`)

$Http_Error_NetworkError = Symbol.for(`Http_Error_NetworkError`)
$Http_Error_Aborted = Symbol.for(`Http_Error_Aborted`)
$Http_Error_Timeout = Symbol.for(`Http_Error_Timeout`)
$Http_Error_BadUrl = Symbol.for(`Http_Error_BadUrl`)

$Storage_Error_SecurityError = Symbol.for(`Storage_Error_SecurityError`)
$Storage_Error_QuotaExceeded = Symbol.for(`Storage_Error_QuotaExceeded`)
$Storage_Error_NotFound = Symbol.for(`Storage_Error_NotFound`)
$Storage_Error_Unkown = Symbol.for(`Storage_Error_Unkown`)

const $$Dependency = (input) => {
  let repository = Decoder.field(`repository`, Decoder.string)(input)
  if (repository instanceof Err) { return repository }

  let constraint = Decoder.field(`constraint`, Decoder.string)(input)
  if (constraint instanceof Err) { return constraint }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    repository: repository.value,
    constraint: constraint.value,
    name: name.value
  })
}

const $$ComputedProperty = (input) => {
  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let source = Decoder.field(`source`, Decoder.string)(input)
  if (source instanceof Err) { return source }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  let type = Decoder.field(`type`, Decoder.string)(input)
  if (type instanceof Err) { return type }

  return new Ok({
    description: description.value,
    source: source.value,
    name: name.value,
    type: type.value
  })
}

const $$Property = (input) => {
  let defaultValue = Decoder.field(`default`, Decoder.string)(input)
  if (defaultValue instanceof Err) { return defaultValue }

  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  let type = Decoder.field(`type`, Decoder.string)(input)
  if (type instanceof Err) { return type }

  return new Ok({
    defaultValue: defaultValue.value,
    description: description.value,
    name: name.value,
    type: type.value
  })
}

const $$Connect = (input) => {
  let keys = Decoder.field(`keys`, Decoder.array(Decoder.string))(input)
  if (keys instanceof Err) { return keys }

  let store = Decoder.field(`store`, Decoder.string)(input)
  if (store instanceof Err) { return store }

  return new Ok({
    keys: keys.value,
    store: store.value
  })
}

const $$Argument = (input) => {
  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  let type = Decoder.field(`type`, Decoder.string)(input)
  if (type instanceof Err) { return type }

  return new Ok({
    name: name.value,
    type: type.value
  })
}

const $$Method = (input) => {
  let arguments = Decoder.field(`arguments`, Decoder.array($$Argument))(input)
  if (arguments instanceof Err) { return arguments }

  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let source = Decoder.field(`source`, Decoder.string)(input)
  if (source instanceof Err) { return source }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  let type = Decoder.field(`type`, Decoder.string)(input)
  if (type instanceof Err) { return type }

  return new Ok({
    arguments: arguments.value,
    description: description.value,
    source: source.value,
    name: name.value,
    type: type.value
  })
}

const $$Use = (input) => {
  let condition = Decoder.field(`condition`, Decoder.maybe(Decoder.string))(input)
  if (condition instanceof Err) { return condition }

  let provider = Decoder.field(`provider`, Decoder.string)(input)
  if (provider instanceof Err) { return provider }

  let data = Decoder.field(`data`, Decoder.string)(input)
  if (data instanceof Err) { return data }

  return new Ok({
    condition: condition.value,
    provider: provider.value,
    data: data.value
  })
}

const $$State = (input) => {
  let data = Decoder.field(`data`, Decoder.string)(input)
  if (data instanceof Err) { return data }

  let type = Decoder.field(`type`, Decoder.string)(input)
  if (type instanceof Err) { return type }

  return new Ok({
    data: data.value,
    type: type.value
  })
}

const $$Component = (input) => {
  let computedProperties = Decoder.field(`computed-properties`, Decoder.array($$ComputedProperty))(input)
  if (computedProperties instanceof Err) { return computedProperties }

  let properties = Decoder.field(`properties`, Decoder.array($$Property))(input)
  if (properties instanceof Err) { return properties }

  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let connects = Decoder.field(`connects`, Decoder.array($$Connect))(input)
  if (connects instanceof Err) { return connects }

  let functions = Decoder.field(`functions`, Decoder.array($$Method))(input)
  if (functions instanceof Err) { return functions }

  let providers = Decoder.field(`providers`, Decoder.array($$Use))(input)
  if (providers instanceof Err) { return providers }

  let state = Decoder.field(`state`, Decoder.maybe($$State))(input)
  if (state instanceof Err) { return state }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    computedProperties: computedProperties.value,
    properties: properties.value,
    description: description.value,
    connects: connects.value,
    functions: functions.value,
    providers: providers.value,
    state: state.value,
    name: name.value
  })
}

const $$Provider = (input) => {
  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let functions = Decoder.field(`functions`, Decoder.array($$Method))(input)
  if (functions instanceof Err) { return functions }

  let subscription = Decoder.field(`subscription`, Decoder.string)(input)
  if (subscription instanceof Err) { return subscription }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    description: description.value,
    functions: functions.value,
    subscription: subscription.value,
    name: name.value
  })
}

const $$RecordField = (input) => {
  let mapping = Decoder.field(`mapping`, Decoder.maybe(Decoder.string))(input)
  if (mapping instanceof Err) { return mapping }

  let type = Decoder.field(`type`, Decoder.string)(input)
  if (type instanceof Err) { return type }

  let key = Decoder.field(`key`, Decoder.string)(input)
  if (key instanceof Err) { return key }

  return new Ok({
    mapping: mapping.value,
    type: type.value,
    key: key.value
  })
}

const $$Record = (input) => {
  let fields = Decoder.field(`fields`, Decoder.array($$RecordField))(input)
  if (fields instanceof Err) { return fields }

  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    fields: fields.value,
    description: description.value,
    name: name.value
  })
}

const $$Module = (input) => {
  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let functions = Decoder.field(`functions`, Decoder.array($$Method))(input)
  if (functions instanceof Err) { return functions }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    description: description.value,
    functions: functions.value,
    name: name.value
  })
}

const $$Store = (input) => {
  let computedProperties = Decoder.field(`computed-properties`, Decoder.array($$ComputedProperty))(input)
  if (computedProperties instanceof Err) { return computedProperties }

  let properties = Decoder.field(`properties`, Decoder.array($$Property))(input)
  if (properties instanceof Err) { return properties }

  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let functions = Decoder.field(`functions`, Decoder.array($$Method))(input)
  if (functions instanceof Err) { return functions }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    computedProperties: computedProperties.value,
    properties: properties.value,
    description: description.value,
    functions: functions.value,
    name: name.value
  })
}

const $$EnumOption = (input) => {
  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    description: description.value,
    name: name.value
  })
}

const $$Enum = (input) => {
  let description = Decoder.field(`description`, Decoder.maybe(Decoder.string))(input)
  if (description instanceof Err) { return description }

  let options = Decoder.field(`options`, Decoder.array($$EnumOption))(input)
  if (options instanceof Err) { return options }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    description: description.value,
    options: options.value,
    name: name.value
  })
}

const $$Documentation = (input) => {
  let dependencies = Decoder.field(`dependencies`, Decoder.array($$Dependency))(input)
  if (dependencies instanceof Err) { return dependencies }

  let components = Decoder.field(`components`, Decoder.array($$Component))(input)
  if (components instanceof Err) { return components }

  let providers = Decoder.field(`providers`, Decoder.array($$Provider))(input)
  if (providers instanceof Err) { return providers }

  let records = Decoder.field(`records`, Decoder.array($$Record))(input)
  if (records instanceof Err) { return records }

  let modules = Decoder.field(`modules`, Decoder.array($$Module))(input)
  if (modules instanceof Err) { return modules }

  let stores = Decoder.field(`stores`, Decoder.array($$Store))(input)
  if (stores instanceof Err) { return stores }

  let enums = Decoder.field(`enums`, Decoder.array($$Enum))(input)
  if (enums instanceof Err) { return enums }

  let name = Decoder.field(`name`, Decoder.string)(input)
  if (name instanceof Err) { return name }

  return new Ok({
    dependencies: dependencies.value,
    components: components.value,
    providers: providers.value,
    records: records.value,
    modules: modules.value,
    stores: stores.value,
    enums: enums.value,
    name: name.value
  })
}

const $$Root = (input) => {
  let packages = Decoder.field(`packages`, Decoder.array($$Documentation))(input)
  if (packages instanceof Err) { return packages }

  return new Ok({
    packages: packages.value
  })
}

const $Provider_Mouse = new (class extends Provider {
moves(event) {
  return $Array.do($Array.map(((func) => {
  return func(event)
  }), $Array.map(((subcription) => {
  return subcription.moves
  }), this._subscriptions)))
}

clicks(event) {
  return $Array.do($Array.map(((func) => {
  return func(event)
  }), $Array.map(((subcription) => {
  return subcription.clicks
  }), this._subscriptions)))
}

ups(event) {
  return $Array.do($Array.map(((func) => {
  return func(event)
  }), $Array.map(((subcription) => {
  return subcription.ups
  }), this._subscriptions)))
}

attach() {
  return (() => {
        const clicks = this._clicks || (this._clicks = this.clicks.bind(this))
        const moves = this._moves || (this._moves = this.moves.bind(this))
        const ups = this._ups || (this._ups = this.ups.bind(this))

        window.addEventListener("click", clicks, true)
        window.addEventListener("mousemove", moves)
        window.addEventListener("mouseup", ups)
      })()
}

detach() {
  return (() => {
        window.removeEventListener("click", this._clicks, true)
        window.removeEventListener("mousemove", this._moves)
        window.removeEventListener("mouseup", this._ups)
      })()
}
})

const $Provider_AnimationFrame = new (class extends Provider {
update() {
  return $Array.do($Array.map(((func) => {
  return func()
  }), $Array.map(((item) => {
  return item.frames
  }), this._subscriptions)))
}

attach() {
  return (() => {
        this.detach()
        this.id = this.frame()
      })()
}

frame() {
  return (() => {
        this.id = requestAnimationFrame(() => {
          this.update()
          this.frame()
        })
      })()
}

detach() {
  return cancelAnimationFrame(this.id)
}
})

const $Provider_Scroll = new (class extends Provider {
scrolls(event) {
  return $Array.do($Array.map(((subscription) => {
  return subscription(event)
  }), $Array.map(((subscription) => {
  return subscription.scrolls
  }), this._subscriptions)))
}

attach() {
  return (() => {
        const scrolls = this._scrolls || (this._scrolls = this.scrolls.bind(this))

        window.addEventListener("scroll", scrolls)
      })()
}

detach() {
  return (() => {
        window.removeEventListener("mousemove", this._scrolls)
      })()
}
})

const $Provider_Tick = new (class extends Provider {
update() {
  return $Array.do($Array.map(((func) => {
  return func()
  }), $Array.map(((item) => {
  return item.ticks
  }), this._subscriptions)))
}

attach() {
  return (() => {
        this.detach()
        this.id = setInterval(this.update.bind(this), 1000)
      })()
}

detach() {
  return clearInterval(this.id)
}
})

_program.addRoutes([{
  handler: ((package, tab, selected) => {
    $Application.route(package, tab, $Maybe.just(selected))
  }),
  mapping: ['package', 'tab', 'selected'],
  path: `/:package/:tab/:selected`
}, {
  handler: ((package, tab) => {
    $Application.route(package, tab, $Maybe.nothing())
  }),
  mapping: ['package', 'tab'],
  path: `/:package/:tab`
}, {
  handler: ((package) => {
    $Application.routePackage(package)
  }),
  mapping: ['package'],
  path: `/:package`
}, {
  handler: (() => {
    $Application.dashboard()
  }),
  mapping: [],
  path: `/`
}, {
  handler: (() => {
    $Application.route(``, `component`, $Maybe.nothing())
  }),
  mapping: [],
  path: `*`
}])

const $Content = new(class {
  fromComponent(item) {
    return new Record({
      description: $Maybe.withDefault(``, item.description),
      computedProperties: item.computedProperties,
      properties: item.properties,
      functions: item.functions,
      connects: item.connects,
      uses: item.providers,
      state: item.state,
      subscription: ``,
      name: item.name,
      options: [],
      fields: []
    })
  }

  fromRecord(item) {
    return new Record({
      description: $Maybe.withDefault(``, item.description),
      state: $Maybe.nothing(),
      computedProperties: [],
      fields: item.fields,
      subscription: ``,
      name: item.name,
      properties: [],
      functions: [],
      connects: [],
      options: [],
      uses: []
    })
  }

  fromEnum(item) {
    return new Record({
      description: $Maybe.withDefault(``, item.description),
      state: $Maybe.nothing(),
      computedProperties: [],
      options: item.options,
      subscription: ``,
      name: item.name,
      properties: [],
      functions: [],
      connects: [],
      fields: [],
      uses: []
    })
  }

  fromProvider(item) {
    return new Record({
      description: $Maybe.withDefault(``, item.description),
      subscription: item.subscription,
      functions: item.functions,
      computedProperties: [],
      state: $Maybe.nothing(),
      name: item.name,
      properties: [],
      connects: [],
      options: [],
      fields: [],
      uses: []
    })
  }

  fromStore(item) {
    return new Record({
      description: $Maybe.withDefault(``, item.description),
      computedProperties: item.computedProperties,
      properties: item.properties,
      functions: item.functions,
      state: $Maybe.nothing(),
      subscription: ``,
      name: item.name,
      connects: [],
      options: [],
      fields: [],
      uses: []
    })
  }

  fromModule(item) {
    return new Record({
      description: $Maybe.withDefault(``, item.description),
      functions: item.functions,
      state: $Maybe.nothing(),
      computedProperties: [],
      subscription: ``,
      name: item.name,
      properties: [],
      connects: [],
      options: [],
      fields: [],
      uses: []
    })
  }

  empty() {
    return new Record({
      state: $Maybe.nothing(),
      computedProperties: [],
      subscription: ``,
      description: ``,
      properties: [],
      functions: [],
      connects: [],
      options: [],
      fields: [],
      uses: [],
      name: ``
    })
  }
})

const $Icons = new(class {
  package() {
    return _createElement("svg", {
      "xmlns": `http://www.w3.org/2000/svg`,
      "width": `24`,
      "height": `24`,
      "viewBox": `0 0 24 24`
    }, [_createElement("path", {
      "d": `M16.677 17.868l-.343.195v-1.717l.343-.195v1.717zm2.823-3.325l-.342.195v1.717l.342-.195v-1.717zm3.5-7.602v11.507l-9.75 5.552-12.25-6.978v-11.507l9.767-5.515 12.233 6.941zm-13.846-3.733l9.022 5.178 1.7-.917-9.113-5.17-1.609.909zm2.846 9.68l-9-5.218v8.19l9 5.126v-8.098zm3.021-2.809l-8.819-5.217-2.044 1.167 8.86 5.138 2.003-1.088zm5.979-.943l-2 1.078v2.786l-3 1.688v-2.856l-2 1.078v8.362l7-3.985v-8.151zm-4.907 7.348l-.349.199v1.713l.349-.195v-1.717zm1.405-.8l-.344.196v1.717l.344-.196v-1.717zm.574-.327l-.343.195v1.717l.343-.195v-1.717zm.584-.333l-.35.199v1.717l.35-.199v-1.717z`
    })])
  }
})

const $Documentation = new(class {
  empty() {
    return new Record({
      dependencies: [],
      components: [],
      providers: [],
      modules: [],
      records: [],
      stores: [],
      enums: [],
      name: ``
    })
  }
})

const $Type = new(class {
  fromString(input) {
    return (() => {
      let __condition = input

       if (_compare(__condition, `component`)) {
        return $Result.ok($Type_Component)
      } else if (_compare(__condition, `provider`)) {
        return $Result.ok($Type_Provider)
      } else if (_compare(__condition, `record`)) {
        return $Result.ok($Type_Record)
      } else if (_compare(__condition, `module`)) {
        return $Result.ok($Type_Module)
      } else if (_compare(__condition, `store`)) {
        return $Result.ok($Type_Store)
      } else if (_compare(__condition, `enum`)) {
        return $Result.ok($Type_Enum)
      } else {
        return $Result.error(`Cannot find tab!`)
      }
    })()
  }

  char(type) {
    return (() => {
      let __condition = type

       if (_compare(__condition, $Type_Component)) {
        return `C`
      } else if (_compare(__condition, $Type_Provider)) {
        return `P`
      } else if (_compare(__condition, $Type_Record)) {
        return `R`
      } else if (_compare(__condition, $Type_Module)) {
        return `M`
      } else if (_compare(__condition, $Type_Store)) {
        return `S`
      } else if (_compare(__condition, $Type_Enum)) {
        return `E`
      }
    })()
  }

  color(type) {
    return (() => {
      let __condition = type

       if (_compare(__condition, $Type_Component)) {
        return `#369e58`
      } else if (_compare(__condition, $Type_Provider)) {
        return `#ff7b00`
      } else if (_compare(__condition, $Type_Record)) {
        return `#673ab7`
      } else if (_compare(__condition, $Type_Module)) {
        return `#be08d0`
      } else if (_compare(__condition, $Type_Store)) {
        return `#d02e2e`
      } else if (_compare(__condition, $Type_Enum)) {
        return `#00bbb5`
      }
    })()
  }

  path(type) {
    return (() => {
      let __condition = type

       if (_compare(__condition, $Type_Component)) {
        return `component`
      } else if (_compare(__condition, $Type_Provider)) {
        return `provider`
      } else if (_compare(__condition, $Type_Record)) {
        return `record`
      } else if (_compare(__condition, $Type_Module)) {
        return `module`
      } else if (_compare(__condition, $Type_Store)) {
        return `store`
      } else if (_compare(__condition, $Type_Enum)) {
        return `enum`
      }
    })()
  }

  title(type) {
    return (() => {
      let __condition = type

       if (_compare(__condition, $Type_Component)) {
        return `Components`
      } else if (_compare(__condition, $Type_Provider)) {
        return `Providers`
      } else if (_compare(__condition, $Type_Record)) {
        return `Records`
      } else if (_compare(__condition, $Type_Module)) {
        return `Modules`
      } else if (_compare(__condition, $Type_Store)) {
        return `Stores`
      } else if (_compare(__condition, $Type_Enum)) {
        return `Enums`
      }
    })()
  }

  icon(type) {
    return (() => {
      let __condition = type

       if (_compare(__condition, $Type_Component)) {
        return _createElement("svg", {
        "xmlns": `http://www.w3.org/2000/svg`,
        "viewBox": `0 0 24 24`,
        "height": `24`,
        "width": `24`
      }, [_createElement("path", {
        "d": `M4.759 5.753h-.013v.958c-.035 1.614 4.405 1.618 4.351 0v-.957c-.129-1.528-4.226-1.536-4.338-.001zm3.545.147c0 .314-.614.571-1.37.571-.755 0-1.37-.256-1.37-.571s.615-.57 1.37-.57c.756 0 1.37.256 1.37.57zm-8.304.179l.009.005-.009-.019 11.5-6.065 11.5 6.142v5.231l-11 5.798v-5.311l9.864-5.19-10.367-5.517-10.331 5.454 9.834 5.229v5.331l-11-5.858v-5.23zm23 6.434v5.813l-11 5.674v-5.689l11-5.798zm-13.692-3.37c-.035 1.615 4.406 1.618 4.351 0v-.957c-.129-1.528-4.225-1.536-4.337-.001h-.014v.958zm2.188-1.381c.755 0 1.37.255 1.37.57 0 .314-.615.57-1.37.57s-1.37-.255-1.37-.57c0-.315.615-.57 1.37-.57zm2.162-3.354v-.956c-.13-1.527-4.225-1.535-4.337-.001h-.013v.957c-.036 1.615 4.406 1.618 4.35 0zm-2.161-1.381c.754 0 1.37.256 1.37.571 0 .314-.616.571-1.37.571-.756 0-1.37-.257-1.37-.571 0-.314.614-.571 1.37-.571zm6.712 3.684v-.957c-.13-1.528-4.226-1.536-4.336-.001h-.014v.958c-.037 1.615 4.405 1.618 4.35 0zm-3.532-.81c0-.314.615-.57 1.37-.57.756 0 1.371.256 1.371.57s-.615.57-1.371.57c-.755 0-1.37-.256-1.37-.57zm-3.677 12.408v5.691l-11-5.673v-5.875l11 5.857z`
      })])
      } else if (_compare(__condition, $Type_Provider)) {
        return _createElement("svg", {
        "xmlns": `http://www.w3.org/2000/svg`,
        "width": `24`,
        "height": `24`,
        "viewBox": `0 0 24 24`
      }, [_createElement("path", {
        "d": `M15.929 11.517c.848-1.003 1.354-2.25 1.354-3.601s-.506-2.598-1.354-3.601l1.57-1.439c1.257 1.375 2.022 3.124 2.022 5.04s-.766 3.664-2.022 5.041l-1.57-1.44zm-10.992-10.076l-1.572-1.441c-2.086 2.113-3.365 4.876-3.365 7.916s1.279 5.802 3.364 7.916l1.572-1.441c-1.672-1.747-2.697-4.001-2.697-6.475s1.026-4.728 2.698-6.475zm1.564 11.515l1.57-1.439c-.848-1.003-1.354-2.25-1.354-3.601s.506-2.598 1.354-3.601l-1.57-1.439c-1.257 1.375-2.022 3.124-2.022 5.04s.765 3.664 2.022 5.04zm14.134-12.956l-1.571 1.441c1.672 1.747 2.697 4.001 2.697 6.475s-1.025 4.728-2.697 6.475l1.572 1.441c2.085-2.115 3.364-4.877 3.364-7.916s-1.279-5.803-3.365-7.916zm-2.552 24h-2.154c-.85-2.203-2.261-3.066-3.929-3.066-1.692 0-3.088.886-3.929 3.066h-2.113l5.042-13.268c-1.162-.414-2-1.512-2-2.816 0-1.657 1.344-3 3-3s3 1.343 3 3c0 1.304-.838 2.403-2 2.816l5.083 13.268zm-4.077-5l-2.006-5.214-2.006 5.214h4.012z`
      })])
      } else if (_compare(__condition, $Type_Record)) {
        return _createElement("svg", {
        "xmlns": `http://www.w3.org/2000/svg`,
        "viewBox": `0 0 24 24`,
        "height": `24`,
        "width": `24`
      }, [_createElement("path", {
        "d": `M5.485 3.567l6.488-3.279c.448-.199.904-.288 1.344-.288 1.863 0 3.477 1.629 3.287 3.616l-7.881 4.496c.118-2.088-1.173-4.035-3.238-4.545zm16.515 10.912c0 1.08-.523 2.185-1.502 2.827-.164.107.84-.506-7.997 5.065.02-.91-.293-1.836-1.061-2.71-1.422-1.623-8.513-9.85-8.531-9.873-.646-.812-.909-1.571-.909-2.225 0-2.167 2.891-3.172 4.274-1.129.799 1.18.528 3.042-.632 3.799l1.083 1.354 8.855-5.069c1.213 1.478 4.834 4.909 5.762 6.045.444.544.658 1.225.658 1.916zm-12.614-.25l6.883-4.062-.718-.737-6.83 4.031.665.768zm8.536-2.359l-.717-.738-6.951 4.101.665.768 7.003-4.131zm1.64 1.689l-.716-.737-7.07 4.171.665.769 7.121-4.203zm-11.782 4.941c-2.148 1.09-2.38 3.252-1.222 4.598.545.632 1.265.902 1.943.902 1.476 0 2.821-1.337 1.567-2.877-1.3-1.599-2.288-2.623-2.288-2.623z`
      })])
      } else if (_compare(__condition, $Type_Module)) {
        return _createElement("svg", {
        "xmlns": `http://www.w3.org/2000/svg`,
        "viewBox": `0 0 24 24`,
        "height": `24`,
        "width": `24`
      }, [_createElement("path", {
        "d": `M12 0l-11 6v12.131l11 5.869 11-5.869v-12.066l-11-6.065zm7.91 6.646l-7.905 4.218-7.872-4.294 7.862-4.289 7.915 4.365zm-16.91 1.584l8 4.363v8.607l-8-4.268v-8.702zm10 12.97v-8.6l8-4.269v8.6l-8 4.269zm6.678-5.315c.007.332-.256.605-.588.612-.332.007-.604-.256-.611-.588-.006-.331.256-.605.588-.612.331-.007.605.256.611.588zm-2.71-1.677c-.332.006-.595.28-.588.611.006.332.279.595.611.588s.594-.28.588-.612c-.007-.331-.279-.594-.611-.587zm-2.132-1.095c-.332.007-.595.281-.588.612.006.332.279.594.611.588.332-.007.594-.28.588-.612-.007-.331-.279-.594-.611-.588zm-9.902 2.183c.332.007.594.281.588.612-.007.332-.279.595-.611.588-.332-.006-.595-.28-.588-.612.005-.331.279-.594.611-.588zm1.487-.5c-.006.332.256.605.588.612s.605-.257.611-.588c.007-.332-.256-.605-.588-.611-.332-.008-.604.255-.611.587zm2.132-1.094c-.006.332.256.605.588.612.332.006.605-.256.611-.588.007-.332-.256-.605-.588-.612-.332-.007-.604.256-.611.588zm3.447-5.749c-.331 0-.6.269-.6.6s.269.6.6.6.6-.269.6-.6-.269-.6-.6-.6zm0-2.225c-.331 0-.6.269-.6.6s.269.6.6.6.6-.269.6-.6-.269-.6-.6-.6zm0-2.031c-.331 0-.6.269-.6.6s.269.6.6.6.6-.269.6-.6-.269-.6-.6-.6z`
      })])
      } else if (_compare(__condition, $Type_Store)) {
        return _createElement("svg", {
        "xmlns": `http://www.w3.org/2000/svg`,
        "viewBox": `0 0 24 24`,
        "height": `24`,
        "width": `24`
      }, [_createElement("path", {
        "d": `M22 18.055v2.458c0 1.925-4.655 3.487-10 3.487-5.344 0-10-1.562-10-3.487v-2.458c2.418 1.738 7.005 2.256 10 2.256 3.006 0 7.588-.523 10-2.256zm-10-3.409c-3.006 0-7.588-.523-10-2.256v2.434c0 1.926 4.656 3.487 10 3.487 5.345 0 10-1.562 10-3.487v-2.434c-2.418 1.738-7.005 2.256-10 2.256zm0-14.646c-5.344 0-10 1.562-10 3.488s4.656 3.487 10 3.487c5.345 0 10-1.562 10-3.487 0-1.926-4.655-3.488-10-3.488zm0 8.975c-3.006 0-7.588-.523-10-2.256v2.44c0 1.926 4.656 3.487 10 3.487 5.345 0 10-1.562 10-3.487v-2.44c-2.418 1.738-7.005 2.256-10 2.256z`
      })])
      } else if (_compare(__condition, $Type_Enum)) {
        return _createElement("svg", {
        "xmlns": `http://www.w3.org/2000/svg`,
        "width": `24`,
        "height": `24`,
        "viewBox": `0 0 24 24`
      }, [_createElement("path", {
        "d": `M12 2c5.514 0 10 4.486 10 10s-4.486 10-10 10-10-4.486-10-10 4.486-10 10-10zm0-2c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm6 17h-12v-2h12v2zm0-4h-12v-2h12v2zm0-4h-12v-2h12v2z`
      })])
      }
    })()
  }
})

const $Promise = new(class {
  reject(input) {
    return Promise.reject(input)
  }

  resolve(input) {
    return Promise.resolve(input)
  }

  wrap(method, input) {
    return method(input)
  }
})

const $Bool = new(class {
  toString(item) {
    return item.toString()
  }
})

const $Html_Event = new(class {
  stopPropagation(event) {
    return event.stopPropagation()
  }

  isPropagationStopped(event) {
    return event.isPropagationStopped()
  }

  preventDefault(event) {
    return event.preventDefault()
  }
})

const $Regexp = new(class {
  create(input) {
    return new RegExp(input)
  }

  createWithOptions(input, options) {
    return (() => {
          let flags = ""

          if (options.caseInsensitive) { flags += "i" }
          if (options.multiline) { flags += "m" }
          if (options.unicode) { flags += "u" }
          if (options.global) { flags += "g" }
          if (options.sticky) { flags += "y" }

          return new RegExp(input, flags)
        })()
  }

  toString(regexp) {
    return regexp.toString()
  }

  escape(input) {
    return input.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
  }

  split(input, regexp) {
    return input.split(regexp)
  }

  replace(input, replacer, regexp) {
    return (() => {
          let index = 0

          return input.replace(regexp, function() {
            const args =
              Array.from(arguments)

            const match =
              args.shift()

            const submatches =
              args.slice(0, -2)

            index += 1

            return replacer({
              submatches, submatches,
              index: index,
              match: match
            })
          })
        })()
  }
})

const $Url = new(class {
  parse(url) {
    return (() => {
          if (!this._a) {
            this._a = document.createElement('a')
          }

          this._a.href = url

          return {
            hostname: this._a.hostname || "",
            protocol: this._a.protocol || "",
            origin: this._a.origin || "",
            path: this._a.pathname || "",
            search: this._a.search || "",
            hash: this._a.hash || "",
            host: this._a.host || "",
            port: this._a.port || ""
          }
        })()
  }
})

const $Uid = new(class {
  generate() {
    return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11)
          .replace(/[018]/g, c =>
            (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4)
              .toString(16))
  }
})

const $Json = new(class {
  parse(input) {
    return (() => {
          try {
            return new Just(JSON.parse(input))
          } catch (error) {
            return new Nothing()
          }
        })()
  }

  stringify(input) {
    return JSON.stringify(input)
  }
})

const $Html = new(class {
  empty() {
    return false
  }
})

const $String = new(class {
  toLowerCase(string) {
    return string.toLowerCase()
  }

  toUpperCase(string) {
    return string.toUpperCase()
  }

  reverse(string) {
    return [...string].reverse().join('')
  }

  isEmpty(string) {
    return _compare(string, ``)
  }

  match(pattern, string) {
    return string.indexOf(pattern) != -1
  }

  split(separator, string) {
    return string.split(separator)
  }

  size(string) {
    return string.length
  }

  capitalize(string) {
    return string.replace(/\b[a-z]/g, char => char.toUpperCase())
  }

  repeat(times, string) {
    return string.repeat(times)
  }

  join(separator, array) {
    return array.join(separator)
  }

  concat(array) {
    return $String.join.bind($String)(``, array)
  }

  isAnagarm(string1, string2) {
    return (() => {
          const normalize = string =>
            string
              .toLowerCase()
              .replace(/[^a-z0-9]/gi, '')
              .split('')
              .sort()
              .join('');

          return normalize(string1) === normalize(string2);
        })()
  }
})

const $Time = new(class {
  fromIso(raw) {
    return (() => {
          try {
            return new Just(new Date(raw))
          } catch (error) {
            return new Nothing()
          }
        })()
  }

  toIso(date) {
    return date.toISOString()
  }

  now() {
    return new Date()
  }

  today() {
    return (() => {
          const date = new Date()

          return new Date(Date.UTC(
            date.getUTCFullYear(),
            date.getUTCMonth(),
            date.getUTCDate()
          ))
        })()
  }

  from(year, month, day) {
    return new Date(Date.UTC(year, month - 1, day))
  }

  day(date) {
    return date.getUTCDate()
  }

  month(date) {
    return (date.getUTCMonth() + 1)
  }

  year(date) {
    return date.getUTCFullYear()
  }

  format(pattern, date) {
    return DateFNS.format(date, pattern)
  }

  startOf(what, date) {
    return (() => {
          switch (what) {
            case 'month':
              return DateFNS.startOfMonth(date)
            case 'week':
              return DateFNS.startOfWeek(date, { weekStartsOn: 1 })
            case 'day':
              return DateFNS.startOfDay(date)
            default:
              return date
          }
        })()
  }

  endOf(what, date) {
    return (() => {
          switch (what) {
            case 'month':
              return DateFNS.endOfMonth(date)
            case 'week':
              return DateFNS.endOfWeek(date, { weekStartsOn: 1 })
            case 'day':
              return DateFNS.endOfDay(date)
            default:
              return date
          }
        })()
  }

  range(from, to) {
    return DateFNS.eachDay(from, to)
  }

  nextMonth(date) {
    return (() => {
          return DateFNS.addMonths(date, 1)
        })()
  }

  previousMonth(date) {
    return (() => {
          return DateFNS.addMonths(date, -1)
        })()
  }

  relative(other, now) {
    return (() => {
          return DateFNS.distanceInWordsStrict(now, other, { addSuffix: true })
        })()
  }
})

const $File = new(class {
  fromString(contents, name, type) {
    return new File([contents], name, { type: type })
  }

  name(file) {
    return file.name
  }

  size(file) {
    return file.size
  }

  mimeType(file) {
    return file.type
  }

  selectMultiple(accept) {
    return (() => {
          let input = document.createElement('input')

          input.style.position = 'absolute'
          input.style.height = '1px'
          input.style.width = '1px'
          input.style.left = '-1px'
          input.style.top = '-1px'

          input.multiple = true
          input.accept = accept
          input.type = 'file'

          document.body.appendChild(input)

          return new Promise((resolve, reject) => {
            input.addEventListener('change', () => {
              resolve(Array.from(input.files))
            })
            input.click()
            document.body.removeChild(input)
          })
        })()
  }

  select(accept) {
    return (() => {
          let input = document.createElement('input')

          input.style.position = 'absolute'
          input.style.height = '1px'
          input.style.width = '1px'
          input.style.left = '-1px'
          input.style.top = '-1px'

          input.accept = accept
          input.type = 'file'

          document.body.appendChild(input)

          return new Promise((resolve, reject) => {
            input.addEventListener('change', () => {
              resolve(input.files[0])
            })
            input.click()
            document.body.removeChild(input)
          })
        })()
  }

  readAsDataURL(file) {
    return (() => {
          let reader = new FileReader();
          return new Promise((resolve, reject) => {
            reader.addEventListener('load', (event) => {
              resolve(reader.result)
            })
            reader.readAsDataURL(file)
          })
        })()
  }

  readAsString(file) {
    return (() => {
          let reader = new FileReader();
          return new Promise((resolve, reject) => {
            reader.addEventListener('load', (event) => {
              resolve(reader.result)
            })
            reader.readAsText(file)
          })
        })()
  }
})

const $Http = new(class {
  empty() {
    return new Record({
      withCredentials: false,
      method: `GET`,
      body: null,
      headers: [],
      url: ``
    })
  }

  delete(urlValue) {
    return $Http.url.bind($Http)(urlValue, $Http.method.bind($Http)(`DELETE`, $Http.empty.bind($Http)()))
  }

  get(urlValue) {
    return $Http.url.bind($Http)(urlValue, $Http.method.bind($Http)(`GET`, $Http.empty.bind($Http)()))
  }

  put(urlValue) {
    return $Http.url.bind($Http)(urlValue, $Http.method.bind($Http)(`PUT`, $Http.empty.bind($Http)()))
  }

  post(urlValue) {
    return $Http.url.bind($Http)(urlValue, $Http.method.bind($Http)(`POST`, $Http.empty.bind($Http)()))
  }

  stringBody(body, request) {
    return _update(request, { body: body })
  }

  formDataBody(body, request) {
    return _update(request, { body: body })
  }

  method(method, request) {
    return _update(request, { method: method })
  }

  withCredentials(value, request) {
    return _update(request, { withCredentials: value })
  }

  url(url, request) {
    return _update(request, { url: url })
  }

  header(key, value, request) {
    return _update(request, { headers: $Array.push(new Record({ value: value, key: key }), request.headers) })
  }

  abortAll() {
    return this._requests && Object.keys(this._requests).forEach((uid) => {
          this._requests[uid].abort()
          delete this._requests[uid]
        })
  }

  send(request) {
    return $Http.sendWithID.bind($Http)($Uid.generate(), request)
  }

  sendWithID(uid, request) {
    return new Promise((resolve, reject) => {
          if (!this._requests) { this._requests = {} }

          let xhr = new XMLHttpRequest()

          this._requests[uid] = xhr

          xhr.withCredentials = request.withCredentials

          try {
            xhr.open(request.method.toUpperCase(), request.url, true)
          } catch (error) {
            delete this._requests[uid]

            reject({
              type: $Http_Error_BadUrl,
              status: xhr.status,
              url: request.url
            })
          }

          request.headers.forEach((item) => {
            xhr.setRequestHeader(item.key, item.value)
          })

          xhr.addEventListener('error', (event) => {
            delete this._requests[uid]

            reject({
              type: $Http_Error_NetworkError,
              status: xhr.status,
              url: request.url
            })
          })

          xhr.addEventListener('timeout', (event) => {
            delete this._requests[uid]

            reject({
              type: $Http_Error_Timeout,
              status: xhr.status,
              url: request.url
            })
          })

          xhr.addEventListener('load', (event) => {
            delete this._requests[uid]

            resolve({ body: xhr.responseText, status: xhr.status })
          })

          xhr.addEventListener('abort', (event) => {
            delete this._requests[uid]

            reject({
              type: $Http_Error_Aborted,
              status: xhr.status,
              url: request.url
            })
          })

          xhr.send(request.body)
        })
  }
})

const $Storage_Local = new(class {
  set(key, value) {
    return $Storage_Common.set(localStorage, key, value)
  }

  get(key) {
    return $Storage_Common.get(localStorage, key)
  }

  remove(key) {
    return $Storage_Common.remove(localStorage, key)
  }

  clear() {
    return $Storage_Common.clear(localStorage)
  }

  size() {
    return $Storage_Common.size(localStorage)
  }

  keys() {
    return $Storage_Common.keys(localStorage)
  }
})

const $Storage_Session = new(class {
  set(key, value) {
    return $Storage_Common.set(sessionStorage, key, value)
  }

  get(key) {
    return $Storage_Common.get(sessionStorage, key)
  }

  remove(key) {
    return $Storage_Common.remove(sessionStorage, key)
  }

  clear() {
    return $Storage_Common.clear(sessionStorage)
  }

  size() {
    return $Storage_Common.size(sessionStorage)
  }

  keys() {
    return $Storage_Common.keys(sessionStorage)
  }
})

const $Storage_Common = new(class {
  set(storage, key, value) {
    return (() => {
          try {
            storage.setItem(key, value)
            return new Ok(null)
          } catch (error) {
            switch(error.name) {
              case 'SecurityError':
                return new Err($Storage_Error_SecurityError)
              case 'QUOTA_EXCEEDED_ERR':
                return new Err($Storage_Error_QuotaExceeded)
              case 'QuotaExceededError':
                return new Err($Storage_Error_QuotaExceeded)
              case 'NS_ERROR_DOM_QUOTA_REACHED':
                return new Err($Storage_Error_QuotaExceeded)
              default:
                return new Err($Storage_Error_Unkown)
            }
          }
        })()
  }

  get(storage, key) {
    return (() => {
          try {
            let value = storage.getItem(key)

            if (typeof value === "string") {
              return new Ok(value)
            } else {
              return new Err($Storage_Error_NotFound)
            }
          } catch (error) {
            switch(error.name) {
              case 'SecurityError':
                return new Err($Storage_Error_SecurityError)
              default:
                return new Err($Storage_Error_Unkown)
            }
          }
        })()
  }

  remove(storage, key) {
    return (() => {
          try {
            storage.removeItem(key)
            return new Ok(null)
          } catch (error) {
            switch(error.name) {
              case 'SecurityError':
                return new Err($Storage_Error_SecurityError)
              default:
                return new Err($Storage_Error_Unkown)
            }
          }
        })()
  }

  clear(storage) {
    return (() => {
          try {
            storage.clear()
            return new Ok(null)
          } catch (error) {
            switch(error.name) {
              case 'SecurityError':
                return new Err($Storage_Error_SecurityError)
              default:
                return new Err($Storage_Error_Unkown)
            }
          }
        })()
  }

  size(storage) {
    return (() => {
          try {
            return new Ok(storage.length)
          } catch (error) {
            switch(error.name) {
              case 'SecurityError':
                return new Err($Storage_Error_SecurityError)
              default:
                return new Err($Storage_Error_Unkown)
            }
          }
        })()
  }

  keys(storage) {
    return (() => {
          try {
            return new Ok(Object.keys(storage).sort())
          } catch (error) {
            switch(error.name) {
              case 'SecurityError':
                return new Err($Storage_Error_SecurityError)
              default:
                return new Err($Storage_Error_Unkown)
            }
          }
        })()
  }
})

const $Result = new(class {
  ok(input) {
    return new Ok(input)
  }

  error(input) {
    return new Err(input)
  }

  withDefault(value, input) {
    return input instanceof Ok ? input.value : value
  }

  withError(value, input) {
    return input instanceof Err ? input.value : value
  }

  map(func, input) {
    return input instanceof Ok ? new Ok(func(input.value)) : input
  }

  mapError(func, input) {
    return input instanceof Err ? new Err(func(input.value)) : input
  }

  isOk(input) {
    return input instanceof Ok
  }

  isError(input) {
    return input instanceof Err
  }

  toMaybe(result) {
    return (() => {
          if (result instanceof Ok) {
            return new Just(result.value)
          } else {
            return new Nothing()
          }
        })()
  }
})

const $Dom_Dimensions = new(class {
  empty() {
    return new Record({
      bottom: 0,
      height: 0,
      width: 0,
      right: 0,
      left: 0,
      top: 0,
      x: 0,
      y: 0
    })
  }
})

const $Window = new(class {
  navigate(url) {
    return _navigate(url)
  }

  setUrl(url) {
    return _navigate(url, false)
  }

  title() {
    return document.title
  }

  setTitle(title) {
    return document.title = title
  }

  url() {
    return $Url.parse($Window.href.bind($Window)())
  }

  href() {
    return window.location.href
  }

  width() {
    return window.innerWidth
  }

  height() {
    return window.innerHeight
  }

  scrollHeight() {
    return document.body.scrollHeight
  }

  scrollWidth() {
    return document.body.scrollWidth
  }

  scrollLeft() {
    return document.body.scrollLeft
  }

  scrollTop() {
    return document.body.scrollTop
  }

  setScrollTop(position) {
    return window.scrollTo(this.scrollTop(), position)
  }

  setScrollLeft(position) {
    return window.scrollTo(position, this.scrollLeft())
  }
})

const $Timer = new(class {
  timeout(duration, subject) {
    return new Promise((resolve) => {
        	setTimeout(() => {
            resolve(subject)
          }, duration)
        })
  }

  nextFrame(subject) {
    return new Promise((resolve) => {
        	requestAnimationFrame(() => {
            resolve(subject)
          })
        })
  }
})

const $Number = new(class {
  isOdd(input) {
    return input % 2 === 1
  }

  isEven(input) {
    return Math.abs(input % 2) === 0
  }

  isNaN(input) {
    return isNaN(input)
  }

  toString(input) {
    return input.toString()
  }

  toFixed(decimalPlaces, input) {
    return input.toFixed(decimalPlaces)
  }

  fromString(input) {
    return (() => {
          let value = parseFloat(input)
          if (isNaN(value)) {
            return new Nothing()
          } else {
            return new Just(value)
          }
        })()
  }
})

const $Array = new(class {
  first(array) {
    return (() => {
          let first = array[0]
          if (first !== undefined) {
            return new Just(first)
          } else {
            return new Nothing()
          }
        })()
  }

  firstWithDefault(item, array) {
    return $Maybe.withDefault(item, $Array.first.bind($Array)(array))
  }

  last(array) {
    return (() => {
          let last = array[array.length - 1]
          if (last !== undefined) {
            return new Just(last)
          } else {
            return new Nothing()
          }
        })()
  }

  lastWithDefault(item, array) {
    return $Maybe.withDefault(item, $Array.last.bind($Array)(array))
  }

  size(array) {
    return array.length
  }

  push(item, array) {
    return [...array, item]
  }

  reverse(array) {
    return array.slice().reverse()
  }

  map(func, array) {
    return array.map(func)
  }

  mapWithIndex(func, array) {
    return array.map(func)
  }

  select(func, array) {
    return array.filter(func)
  }

  reject(func, array) {
    return array.filter((item) => !func(item))
  }

  find(func, array) {
    return (() => {
          let item = array.find(func)

          if (item != undefined) {
            return new Just(item)
          } else {
            return new Nothing()
          }
        })()
  }

  any(func, array) {
    return !!array.find(func)
  }

  sort(func, array) {
    return array.slice().sort(func)
  }

  sortBy(func, array) {
    return (() => {
          return array.sort((a, b) => {
            let aVal = func(a)
            let bVal = func(b)

            if (aVal < bVal) {
              return -1
            }

            if (aVal > bVal) {
              return 1
            }

            return 0
          })
        })()
  }

  slice(begin, end, array) {
    return array.slice(begin, end)
  }

  isEmpty(array) {
    return _compare($Array.size.bind($Array)(array), 0)
  }

  intersperse(item, array) {
    return array.reduce((a,v)=>[...a,v,item],[]).slice(0,-1)
  }

  contains(other, array) {
    return (() => {
          for (let item of array) {
            if (_compare(other, item)) {
              return true
            }
          }

          return false
        })()
  }

  range(from, to) {
    return Array.from({ length: (to + 1) - from }).map((v, i) => i + from)
  }

  delete(what, array) {
    return $Array.reject.bind($Array)(((item) => {
    return !_compare(item, what)
    }), array)
  }

  max(array) {
    return Math.max(...array)
  }

  sample(array) {
    return (() => {
          if (array.length) {
            return new Just(array[Math.floor(Math.random() * array.length)])
          } else {
            return new Nothing()
          }
        })()
  }

  at(index, array) {
    return (() => {
          let item = array[index]
          if (item !== undefined) {
            return new Just(item)
          } else {
            return new Nothing()
          }
        })()
  }

  do(array) {
    return null
  }
})

const $Object_Error = new(class {
  toString(error) {
    return error.toString()
  }
})

const $Object_Decode = new(class {
  field(key, decoder, input) {
    return Decoder.field(key, decoder)(input)
  }

  string(input) {
    return Decoder.string(input)
  }

  time(input) {
    return Decoder.time(input)
  }

  number(input) {
    return Decoder.number(input)
  }

  boolean(input) {
    return Decoder.boolean(input)
  }

  array(decoder, input) {
    return Decoder.array(decoder)(input)
  }

  maybe(decoder, input) {
    return Decoder.maybe(decoder)(input)
  }
})

const $Object_Encode = new(class {
  string(input) {
    return input
  }

  boolean(input) {
    return input
  }

  number(input) {
    return input
  }

  time(input) {
    return input.toISOString()
  }

  array(input) {
    return input
  }

  field(name, value) {
    return { name: name, value: value }
  }

  object(fields) {
    return (() => {
          let result = {}

          for (let item of fields) {
            result[item.name] = item.value
          }

          return result
        })()
  }
})

const $Math = new(class {
  negate(number) {
    return -number
  }

  abs(number) {
    return Math.abs(number)
  }

  ceil(number) {
    return Math.ceil(number)
  }

  floor(number) {
    return Math.floor(number)
  }

  round(number) {
    return Math.round(number)
  }

  min(number1, number2) {
    return Math.min(number1, number2)
  }

  max(number1, number2) {
    return Math.max(number1, number2)
  }
})

const $Dom = new(class {
  createElement(tag) {
    return document.createElement(tag)
  }

  getElementById(id) {
    return (() => {
          let element = document.getElementById(id)

          if (element) {
            return new Just(element)
          } else {
            return new Nothing()
          }
        })()
  }

  getElementBySelector(selector) {
    return (() => {
          try {
            let element = document.querySelector(selector)

            if (element) {
              return new Just(element)
            } else {
              return new Nothing()
            }
          } catch (error) {
            return new Nothing()
          }
        })()
  }

  getDimensions(dom) {
    return (() => {
          const rect = dom.getBoundingClientRect()

          return new Record({
            bottom: rect.bottom,
            height: rect.height,
            width: rect.width,
            right: rect.right,
            left: rect.left,
            top: rect.top,
            x: rect.x,
            y: rect.y
          })
        })()
  }

  getValue(dom) {
    return (() => {
          let value = dom.value

          if (typeof value === "string") {
            return value
          } else {
            return ""
          }
        })()
  }

  setValue(value, dom) {
    return (dom.value = value) && dom
  }

  matches(selector, dom) {
    return (() => {
          try {
            return dom.matches(selector)
          } catch (error) {
            return false
          }
        })()
  }
})

const $Test_Context = new(class {
  of(a) {
    return new TestContext(a)
  }

  then(proc, context) {
    return context.step((subject)=> {
          return proc(subject)
        })
  }

  timeout(duration, context) {
    return $Test_Context.then.bind($Test_Context)(((subject) => {
    return $Timer.timeout(duration, subject)
    }), context)
  }

  assertEqual(a, context) {
    return context.step((subject)=> {
          let result = _compare(a, subject)

          if (result) {
            return subject
          } else {
            throw `Assertion failed ${a} === ${subject}`
          }
        })
  }
})

const $Test_Html = new(class {
  start(node) {
    return (() => {
          let root = document.createElement('div')
          document.body.appendChild(root)
          ReactDOM.render(node, root)
          return new TestContext(root, () => {
            ReactDOM.unmountComponentAtNode(root)
            document.body.removeChild(root)
          })
        })()
  }

  triggerClick(selector, context) {
    return context.step((element) => {
          element.querySelector(selector).click()
          return element
        })
  }

  triggerMouseDown(selector, context) {
    return context.step((element) => {
          let event = document.createEvent ('MouseEvents')
          event.initEvent ("mousedown", true, true)
          element.querySelector(selector).dispatchEvent(event)
          return element
        })
  }

  triggerMouseMove(selector, context) {
    return context.step((element) => {
          let event = document.createEvent ('MouseEvents')
          event.initEvent ("mousemove", true, true)
          element.querySelector(selector).dispatchEvent(event)
          return element
        })
  }

  triggerMouseUp(selector, context) {
    return context.step((element) => {
          let event = document.createEvent ('MouseEvents')
          event.initEvent ("mouseup", true, true)
          element.querySelector(selector).dispatchEvent(event)
          return element
        })
  }

  assertTextOf(selector, value, context) {
    return context.step((element) => {
          let text = "";

          try {
            text = element.querySelector(selector).textContent
          } catch (error) {
            throw `Could not find element with selector: ${selector}`
          }

          if (text == value) {
            return element
          } else {
            throw `"${text}" != "${value}"`
          }
        })
  }

  assertElementExists(selector, context) {
    return context.step((element) => {
          let subject = element.querySelector(selector)

          if (subject) {
            return element
          } else {
            throw `Could not find element with selector: ${selector}`
          }
        })
  }

  assertCSSOf(selector, property, value, context) {
    return context.step((element) => {
          let subject = element.querySelector(selector)

          if (subject) {
            let actual = getComputedStyle(subject)[property]

            if (actual == value) {
              return element
            } else {
              throw `Style did not match`
            }
          } else {
            throw `Could not find element with selector: ${selector}`
          }
        })
  }
})

const $Test_Window = new(class {
  setScrollLeft(to, context) {
    return $Test_Context.then(((subject) => {
    return (() => {  $Window.setScrollLeft(100)

    return $Promise.resolve(subject) })()
    }), context)
  }

  setScrollTop(to, context) {
    return $Test_Context.then(((subject) => {
    return (() => {  $Window.setScrollTop(100)

    return $Promise.resolve(subject) })()
    }), context)
  }
})

const $FormData = new(class {
  empty() {
    return new FormData
  }

  keys(formData) {
    return Array.from(formData.keys())
  }

  addString(key, value, formData) {
    return (() => {
          var newFormData = new FormData();

          // Create new FormData object
          for(let pair of formData.entries()) {
            newFormData.append(pair[0], pair[1])
          }

          newFormData.append(key, value)

          return newFormData
        })()
  }

  addFile(key, value, formData) {
    return (() => {
          var newFormData = new FormData();

          // Create new FormData object
          for(let pair of formData.entries()) {
            newFormData.append(pair[0], pair[1])
          }

          newFormData.append(key, value)

          return newFormData
        })()
  }
})

const $Debug = new(class {
  log(value) {
    return (() => {
          console.log(value)
          return value
        })()
  }
})

const $Maybe = new(class {
  nothing() {
    return new Nothing
  }

  just(value) {
    return new Just(value)
  }

  isJust(maybe) {
    return maybe instanceof Just
  }

  isNothing(maybe) {
    return maybe instanceof Nothing
  }

  map(func, maybe) {
    return (() => {
         	if (maybe instanceof Just) {
         		return new Just(func(maybe.value))
         	} else {
         		return maybe
         	}
        })()
  }

  withDefault(value, maybe) {
    return (() => {
        	if (maybe instanceof Just) {
        		return maybe.value
        	} else {
        		return value
        	}
        })()
  }

  toResult(error, maybe) {
    return (() => {
          if (maybe instanceof Just) {
            return new Ok(maybe.value)
          } else {
            return new Err(error)
          }
        })()
  }

  flatten(maybe) {
    return (() => {
          if (maybe instanceof Just) {
            return maybe.value
          } else {
            return maybe
          }
        })()
  }

  oneOf(array) {
    return $Maybe.flatten.bind($Maybe)($Array.find(((item) => {
    return $Maybe.isJust(item)
    }), array))
  }
})

const $Application = new (class extends Store {
    constructor() {
    super()
    this.props = {
        selected: $Content.empty(),status: $Status_Initial,tab: $Type_Component,documentations: [],documentation: $Documentation.empty(),page: $Page_Dashboard
    }
  }

  get selected () {
    if (this.props.selected != undefined) {
      return this.props.selected
    } else {
      return $Content.empty()
    }
  }

  get status () {
    if (this.props.status != undefined) {
      return this.props.status
    } else {
      return $Status_Initial
    }
  }

  get tab () {
    if (this.props.tab != undefined) {
      return this.props.tab
    } else {
      return $Type_Component
    }
  }

  get documentations () {
    if (this.props.documentations != undefined) {
      return this.props.documentations
    } else {
      return []
    }
  }

  get documentation () {
    if (this.props.documentation != undefined) {
      return this.props.documentation
    } else {
      return $Documentation.empty()
    }
  }

  get page () {
    if (this.props.page != undefined) {
      return this.props.page
    } else {
      return $Page_Dashboard
    }
  }

  get state () {
    return {
    selected: this.selected,
    status: this.status,
    tab: this.tab,
    documentations: this.documentations,
    documentation: this.documentation,
    page: this.page
    }
  }

  load() {
    return (_compare(this.status, $Status_Initial) ? (async () => {
      try {
        let response = await (async ()=> {
      try {
        return await $Http.send($Http.get(`http://localhost:3002/documentation.json`))
      } catch(_error) {
        let error = _error;
     new Promise((_resolve) => {
      this.setState(_update(this.state, { status: $Status_HttpError }), _resolve)
    })

        throw new DoError
      }
    })()

    let _1 = $Maybe.toResult(``, $Json.parse(response.body))

    if (_1 instanceof Err) {
      let _error = _1.value

      let error = _error;
     new Promise((_resolve) => {
      this.setState(_update(this.state, { status: $Status_JsonError }), _resolve)
    })

      throw new DoError
    }

    let json = _1.value

    let _2 = $$Root(json)

    if (_2 instanceof Err) {
      let _error = _2.value

      let error = _error;
     new Promise((_resolve) => {
      this.setState(_update(this.state, { status: $Status_DecodeError }), _resolve)
    })

      throw new DoError
    }

    let root = _2.value

     await new Promise((_resolve) => {
      this.setState(_update(this.state, { documentations: root.packages, status: $Status_Ok }), _resolve)
    })
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })() : null)
  }

  dashboard() {
    return (async () => {
      try {
         await $Application.load.bind($Application)()

     await new Promise((_resolve) => {
      this.setState(_update(this.state, { documentation: $Documentation.empty(), selected: $Content.empty(), page: $Page_Dashboard }), _resolve)
    })

     await $Window.setScrollTop(0)
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })()
  }

  routePackage(name) {
    return (async () => {
      try {
         await $Application.load.bind($Application)()

    let _1 = $Maybe.toResult(`Could not find package!`, $Array.find(((item) => {
    return _compare(item.name, name)
    }), this.documentations))

    if (_1 instanceof Err) {
      let _error = _1.value

      let error = _error;
     (async () => {
      try {
         await $Debug.log(error)

     await $Window.navigate(`/`)
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })()

      throw new DoError
    }

    let documentation = _1.value

     await new Promise((_resolve) => {
      this.setState(_update(this.state, { documentation: documentation, page: $Page_Package }), _resolve)
    })

     await $Window.setScrollTop(0)
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })()
  }

  route(packageName, tabName, entity) {
    return (async () => {
      try {
         await $Application.load.bind($Application)()

    let _1 = $Maybe.toResult(`Could not find package!`, $Array.find(((item) => {
    return _compare(item.name, packageName)
    }), this.documentations))

    if (_1 instanceof Err) {
      let _error = _1.value

      let error = _error;
     $Window.navigate(`/`)

      throw new DoError
    }

    let documentation = _1.value

     await (async () => {
      try {
        let _0 = $Type.fromString(tabName)

    if (_0 instanceof Err) {
      let _error = _0.value

      let error = _error;
     $Window.navigate(`/` + documentation.name)

      throw new DoError
    }

    let tab = _0.value

    let items = await (() => {
      let __condition = tab

       if (_compare(__condition, $Type_Component)) {
        return $Array.map($Content.fromComponent.bind($Content), documentation.components)
      } else if (_compare(__condition, $Type_Provider)) {
        return $Array.map($Content.fromProvider.bind($Content), documentation.providers)
      } else if (_compare(__condition, $Type_Record)) {
        return $Array.map($Content.fromRecord.bind($Content), documentation.records)
      } else if (_compare(__condition, $Type_Module)) {
        return $Array.map($Content.fromModule.bind($Content), documentation.modules)
      } else if (_compare(__condition, $Type_Store)) {
        return $Array.map($Content.fromStore.bind($Content), documentation.stores)
      } else if (_compare(__condition, $Type_Enum)) {
        return $Array.map($Content.fromEnum.bind($Content), documentation.enums)
      }
    })()

     await (async () => {
      try {
        let _0 = $Maybe.toResult(`Could not find entity!`, $Maybe.flatten($Maybe.map(((name) => {
    return $Array.find(((item) => {
    return _compare(item.name, name)
    }), items)
    }), entity)))

    if (_0 instanceof Err) {
      let _error = _0.value

      let error = _error;
     (async () => {
      try {
        let _0 = $Maybe.toResult(`Could not find first!`, $Array.first(items))

    if (_0 instanceof Err) {
      let _error = _0.value

      let error = _error;
     $Window.navigate(`/` + documentation.name)

      throw new DoError
    }

    let first = _0.value

     await $Window.navigate(`/` + documentation.name + `/` + $Type.path(tab) + `/` + first.name)
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })()

      throw new DoError
    }

    let selected = _0.value

     await new Promise((_resolve) => {
      this.setState(_update(this.state, { documentation: documentation, page: $Page_Entity, selected: selected, tab: tab }), _resolve)
    })

     await $Window.setScrollTop(0)
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })()
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })()
      }
      catch(_error) {
        if (_error instanceof DoError) {
        } else {
          console.warn(`Unhandled error in do statement`)
          console.log(_error)
        }
      } 
    })()
  }
})
$Application.__displayName = `Application`

class $Main extends Component {
  get main() {
    return _createElement("div", {
      className: `main-base`
    }, [_createElement($Tabs, {  }), this.content])
  }

  get content() {
    return (() => {
      let __condition = this.page

       if (_compare(__condition, $Page_Dashboard)) {
        return _createElement($Dashboard, {  })
      } else if (_compare(__condition, $Page_Package)) {
        return _createElement($Package, {  })
      } else if (_compare(__condition, $Page_Entity)) {
        return _createElement("div", {
        className: `main-content`
      }, [_createElement($Sidebar, {  }), _createElement($Page, {  })])
      }
    })()
  }

  get selected () { return $Application.selected }

  get status () { return $Application.status }

  load (...params) { return $Application.load(...params) }

  get page () { return $Application.page }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    return (() => {
      let __condition = this.status

       if (_compare(__condition, $Status_JsonError)) {
        return _createElement($Error, { "content": `Could not parse the documentation json!` })
      } else if (_compare(__condition, $Status_DecodeError)) {
        return _createElement($Error, { "content": `Could not decode the documentation!` })
      } else if (_compare(__condition, $Status_HttpError)) {
        return _createElement($Error, { "content": `Could not load the documentation!` })
      } else if (_compare(__condition, $Status_Initial)) {
        return _createElement("div", {})
      } else if (_compare(__condition, $Status_Ok)) {
        return this.main
      }
    })()
  }
}

$Main.displayName = "Main"

class $Use extends Component {
  get condition () {
    if (this.props.condition != undefined) {
      return this.props.condition
    } else {
      return $Maybe.nothing()
    }
  }

  get provider () {
    if (this.props.provider != undefined) {
      return this.props.provider
    } else {
      return ``
    }
  }

  get data () {
    if (this.props.data != undefined) {
      return this.props.data
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {
      className: `use-base`
    }, [_createElement("div", {
      className: `use-name`
    }, [this.provider]), _createElement("div", {
      className: `use-code`
    }, [_createElement($Pre, { "code": this.data })]), _createElement($If, { "condition": $Maybe.isJust(this.condition) }, _array(_createElement("div", {
      className: `use-when`
    }, [`only when:`]), _createElement("div", {
      className: `use-code`
    }, [_createElement($Pre, { "code": $Maybe.withDefault(``, this.condition) })])))])
  }
}

$Use.displayName = "Use"

$Use.defaultProps = {
  condition: $Maybe.nothing(),provider: ``,data: ``
}

class $Sidebar extends Component {
  get items() {
    return (() => {
      let __condition = this.tab

       if (_compare(__condition, $Type_Component)) {
        return $Array.map(((item) => {
      return _createElement($Sidebar_Item, { "type": $Type_Component, "text": item.name })
      }), this.documentation.components)
      } else if (_compare(__condition, $Type_Provider)) {
        return $Array.map(((item) => {
      return _createElement($Sidebar_Item, { "type": $Type_Provider, "text": item.name })
      }), this.documentation.providers)
      } else if (_compare(__condition, $Type_Store)) {
        return $Array.map(((item) => {
      return _createElement($Sidebar_Item, { "type": $Type_Store, "text": item.name })
      }), this.documentation.stores)
      } else if (_compare(__condition, $Type_Record)) {
        return $Array.map(((item) => {
      return _createElement($Sidebar_Item, { "type": $Type_Record, "text": item.name })
      }), this.documentation.records)
      } else if (_compare(__condition, $Type_Module)) {
        return $Array.map(((item) => {
      return _createElement($Sidebar_Item, { "type": $Type_Module, "text": item.name })
      }), this.documentation.modules)
      } else if (_compare(__condition, $Type_Enum)) {
        return $Array.map(((item) => {
      return _createElement($Sidebar_Item, { "type": $Type_Enum, "text": item.name })
      }), this.documentation.enums)
      }
    })()
  }

  get documentation () { return $Application.documentation }

  get tab () { return $Application.tab }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    return _createElement("div", {
      className: `sidebar-base`
    }, [this.items])
  }
}

$Sidebar.displayName = "Sidebar"

class $Dependency extends Component {
  get repository () {
    if (this.props.repository != undefined) {
      return this.props.repository
    } else {
      return ``
    }
  }

  get constraint () {
    if (this.props.constraint != undefined) {
      return this.props.constraint
    } else {
      return ``
    }
  }

  get name () {
    if (this.props.name != undefined) {
      return this.props.name
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {}, [_createElement("div", {
      className: `dependency-id`
    }, [_createElement("div", {
      className: `dependency-name`
    }, [this.name]), _createElement("div", {
      className: `dependency-constraint`
    }, [this.constraint])]), _createElement("div", {
      className: `dependency-repository`
    }, [this.repository])])
  }
}

$Dependency.displayName = "Dependency"

$Dependency.defaultProps = {
  repository: ``,constraint: ``,name: ``
}

class $Connection extends Component {
  get keys () {
    if (this.props.keys != undefined) {
      return this.props.keys
    } else {
      return []
    }
  }

  get store () {
    if (this.props.store != undefined) {
      return this.props.store
    } else {
      return ``
    }
  }

  renderKey(key) {
    return _createElement("div", {
      className: `connection-key`
    }, [key])
  }

  render() {
    return _createElement("div", {
      className: `connection-base`
    }, [_createElement("div", {
      className: `connection-name`
    }, [this.store]), _createElement("span", {}, [` exposing {`]), _createElement("div", {
      className: `connection-keys`
    }, [$Array.map(this.renderKey.bind(this), this.keys)]), _createElement("div", {}, [`}`])])
  }
}

$Connection.displayName = "Connection"

$Connection.defaultProps = {
  keys: [],store: ``
}

class $RawHtml extends Component {
  get content () {
    if (this.props.content != undefined) {
      return this.props.content
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {
      "dangerouslySetInnerHTML": {__html: this.content},
      className: `raw-html-base`
    })
  }
}

$RawHtml.displayName = "RawHtml"

$RawHtml.defaultProps = {
  content: ``
}

class $Error extends Component {
  get warning() {
    return _createElement("svg", {
      "xmlns": `http://www.w3.org/2000/svg`,
      "viewBox": `0 0 24 24`,
      "height": `100`,
      "width": `100`,
      className: `error-icon`
    }, [_createElement("path", {
      "d": `M12 2c5.514 0 10 4.486 10 10s-4.486 10-10 10-10-4.486-10-10 4.486-10 10-10zm0-2c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm-1.31 7.526c-.099-.807.528-1.526 1.348-1.526.771 0 1.377.676 1.28 1.451l-.757 6.053c-.035.283-.276.496-.561.496s-.526-.213-.562-.496l-.748-5.978zm1.31 10.724c-.69 0-1.25-.56-1.25-1.25s.56-1.25 1.25-1.25 1.25.56 1.25 1.25-.56 1.25-1.25 1.25z`
    })])
  }

  get content () {
    if (this.props.content != undefined) {
      return this.props.content
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {
      className: `error-base`
    }, [this.warning, this.content])
  }
}

$Error.displayName = "Error"

$Error.defaultProps = {
  content: ``
}

class $Field extends Component {
  get mapping () {
    if (this.props.mapping != undefined) {
      return this.props.mapping
    } else {
      return $Maybe.nothing()
    }
  }

  get type () {
    if (this.props.type != undefined) {
      return this.props.type
    } else {
      return ``
    }
  }

  get name () {
    if (this.props.name != undefined) {
      return this.props.name
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {
      className: `field-base`
    }, [_createElement("div", {
      className: `field-key`
    }, [this.name]), _createElement("div", {
      className: `field-type`
    }, [this.type])])
  }
}

$Field.displayName = "Field"

$Field.defaultProps = {
  mapping: $Maybe.nothing(),type: ``,name: ``
}

class $Source extends Component {
  constructor(props) {
    super(props)
    this.state = new Record({
      shown: false
    })
  }

  get icon() {
    return _createElement("svg", {
      "xmlns": `http://www.w3.org/2000/svg`,
      "viewBox": `0 0 24 24`,
      "height": `9`,
      "width": `9`,
      className: `source-icon`,
      style: {
        [`--source-icon-transform`]: this.transform
      }
    }, [_createElement("path", {
      "d": `M5 3l3.057-3 11.943 12-11.943 12-3.057-3 9-9z`
    })])
  }

  get text() {
    return (this.state.shown ? `Hide source ` : `Show source`)
  }

  get transform() {
    return (this.state.shown ? `rotate(90deg)` : ``)
  }

  get code () {
    if (this.props.code != undefined) {
      return this.props.code
    } else {
      return ``
    }
  }

  toggle(event) {
    return new Promise((_resolve) => {
      this.setState(_update(this.state, { shown: !this.state.shown }), _resolve)
    })
  }

  render() {
    return _createElement("div", {}, [_createElement("div", {
      "onClick": (event => (this.toggle.bind(this))(_normalizeEvent(event))),
      className: `source-base`
    }, [this.icon, _createElement("div", {}, [this.text])]), _createElement($If, { "condition": this.state.shown }, _array(_createElement("div", {
      className: `source-code`
    }, [_createElement($Pre, { "code": this.code })])))])
  }
}

$Source.displayName = "Source"

$Source.defaultProps = {
  code: ``
}

class $Package extends Component {
  get documentation () { return $Application.documentation }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    let dependencies = $Array.map(((item) => {
    return _createElement($Dependency, { "constraint": item.constraint, "repository": item.repository, "name": item.name })
    }), this.documentation.dependencies)

    return _createElement("div", {
      className: `package-base`
    }, [_createElement("div", {
      className: `package-title`
    }, [this.documentation.name]), _createElement($Unless, { "condition": $Array.isEmpty(dependencies) }, _array(_createElement("div", {
      className: `package-subtitle`
    }, [`Dependencies`]), _createElement("div", {}, [dependencies])))])
  }
}

$Package.displayName = "Package"

class $Tabs extends Component {
  get isDashboard() {
    return _compare(this.page, $Page_Dashboard)
  }

  get color() {
    return (() => {
      let __condition = this.page

       if (_compare(__condition, $Page_Dashboard)) {
        return `#666`
      } else if (_compare(__condition, $Page_Package)) {
        return `#666`
      } else {
        return $Type.color(this.tab)
      }
    })()
  }

  get dashboardIcon() {
    return _createElement("svg", {
      "xmlns": `http://www.w3.org/2000/svg`,
      "viewBox": `0 0 24 24`,
      "height": `24`,
      "width": `24`
    }, [_createElement("path", {
      "d": `M12 2c-6.627 0-12 5.373-12 12 0 2.583.816 5.042 2.205 7h19.59c1.389-1.958 2.205-4.417 2.205-7 0-6.627-5.373-12-12-12zm-.758 2.14c.256-.02.51-.029.758-.029s.502.01.758.029v3.115c-.252-.027-.506-.042-.758-.042s-.506.014-.758.042v-3.115zm-5.763 7.978l-2.88-1.193c.157-.479.351-.948.581-1.399l2.879 1.192c-.247.444-.441.913-.58 1.4zm1.216-2.351l-2.203-2.203c.329-.383.688-.743 1.071-1.071l2.203 2.203c-.395.316-.754.675-1.071 1.071zm.793-4.569c.449-.231.919-.428 1.396-.586l1.205 2.875c-.485.141-.953.338-1.396.585l-1.205-2.874zm1.408 13.802c.019-1.151.658-2.15 1.603-2.672l1.501-7.041 1.502 7.041c.943.522 1.584 1.521 1.603 2.672h-6.209zm4.988-11.521l1.193-2.879c.479.156.948.352 1.399.581l-1.193 2.878c-.443-.246-.913-.44-1.399-.58zm2.349 1.217l2.203-2.203c.383.329.742.688 1.071 1.071l-2.203 2.203c-.316-.396-.675-.755-1.071-1.071zm2.259 3.32c-.147-.483-.35-.95-.603-1.39l2.86-1.238c.235.445.438.912.602 1.39l-2.859 1.238z`
    })])
  }

  get documentations () { return $Application.documentations }

  get documentation () { return $Application.documentation }

  get tab () { return $Application.tab }

  get page () { return $Application.page }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    return _createElement("div", {
      className: `tabs-base`,
      style: {
        [`--tabs-base-border-bottom`]: `5px solid ` + this.color
      }
    }, [_createElement($Tab, { "active": _compare(this.page, $Page_Dashboard), "icon": this.dashboardIcon, "color": `#666`, "link": `/` }), _createElement($If, { "condition": !_compare(this.documentation.name, ``) }, _array(_createElement($Tab, { "active": _compare(this.page, $Page_Package), "link": `/` + this.documentation.name, "title": this.documentation.name, "icon": $Icons.package(), "color": `#666` }))), _createElement($Unless, { "condition": $Array.isEmpty(this.documentation.components) }, _array(_createElement($EntityTab, { "of": $Type_Component }))), _createElement($Unless, { "condition": $Array.isEmpty(this.documentation.modules) }, _array(_createElement($EntityTab, { "of": $Type_Module }))), _createElement($Unless, { "condition": $Array.isEmpty(this.documentation.stores) }, _array(_createElement($EntityTab, { "of": $Type_Store }))), _createElement($Unless, { "condition": $Array.isEmpty(this.documentation.providers) }, _array(_createElement($EntityTab, { "of": $Type_Provider }))), _createElement($Unless, { "condition": $Array.isEmpty(this.documentation.records) }, _array(_createElement($EntityTab, { "of": $Type_Record }))), _createElement($Unless, { "condition": $Array.isEmpty(this.documentation.enums) }, _array(_createElement($EntityTab, { "of": $Type_Enum })))])
  }
}

$Tabs.displayName = "Tabs"

class $State extends Component {
  get type () {
    if (this.props.type != undefined) {
      return this.props.type
    } else {
      return ``
    }
  }

  get data () {
    if (this.props.data != undefined) {
      return this.props.data
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {
      className: `state-base`
    }, [_createElement("div", {
      className: `state-type`
    }, [this.type, _createElement("div", {
      className: `state-equals`
    }, [`=`])]), _createElement("div", {
      className: `state-code`
    }, [_createElement($Pre, { "code": this.data })])])
  }
}

$State.displayName = "State"

$State.defaultProps = {
  type: ``,data: ``
}

class $Entity extends Component {
  get description () {
    if (this.props.description != undefined) {
      return this.props.description
    } else {
      return $Maybe.nothing()
    }
  }

  get arguments () {
    if (this.props.arguments != undefined) {
      return this.props.arguments
    } else {
      return []
    }
  }

  get defaultValue () {
    if (this.props.defaultValue != undefined) {
      return this.props.defaultValue
    } else {
      return ``
    }
  }

  get source () {
    if (this.props.source != undefined) {
      return this.props.source
    } else {
      return ``
    }
  }

  get name () {
    if (this.props.name != undefined) {
      return this.props.name
    } else {
      return ``
    }
  }

  get type () {
    if (this.props.type != undefined) {
      return this.props.type
    } else {
      return ``
    }
  }

  renderArgument(argument) {
    return _createElement("div", {
      className: `entity-argument`
    }, [_createElement("strong", {}, [argument.name]), _createElement("span", {
      className: `entity-type`
    }, [argument.type])])
  }

  render() {
    return _createElement("div", {
      className: `entity-base`
    }, [_createElement("div", {
      className: `entity-definition`
    }, [_createElement("div", {
      className: `entity-name`
    }, [this.name]), _createElement($Unless, { "condition": $Array.isEmpty(this.arguments) }, _array(_createElement("div", {
      className: `entity-arguments`
    }, [$Array.map(this.renderArgument.bind(this), this.arguments)]))), _createElement("div", {
      className: `entity-type`
    }, [this.type]), _createElement($Unless, { "condition": $String.isEmpty(this.defaultValue) }, _array(_createElement("div", {
      className: `entity-default`
    }, [_createElement($Pre, { "code": this.defaultValue })])))]), _createElement($If, { "condition": $Maybe.isJust(this.description) }, _array(_createElement("div", {
      className: `entity-description`
    }, [_createElement($RawHtml, { "content": $Maybe.withDefault(``, this.description) })]))), _createElement($Unless, { "condition": $String.isEmpty(this.source) }, _array(_createElement($Source, { "code": this.source })))])
  }
}

$Entity.displayName = "Entity"

$Entity.defaultProps = {
  description: $Maybe.nothing(),arguments: [],defaultValue: ``,source: ``,name: ``,type: ``
}

class $Sidebar_Item extends Component {
  get type () {
    if (this.props.type != undefined) {
      return this.props.type
    } else {
      return $Type_Component
    }
  }

  get text () {
    if (this.props.text != undefined) {
      return this.props.text
    } else {
      return ``
    }
  }

  get tab () { return $Application.tab }

  get documentation () { return $Application.documentation }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    return _createElement("a", {
      "href": `/` + this.documentation.name + `/` + $Type.path(this.tab) + `/` + this.text,
      className: `sidebar-item-base`
    }, [_createElement("div", {
      className: `sidebar-item-badge`,
      style: {
        [`--sidebar-item-badge-background-color`]: $Type.color(this.tab)
      }
    }, [$Type.char(this.tab)]), _createElement("span", {
      className: `sidebar-item-span`
    }, [this.text])])
  }
}

$Sidebar_Item.displayName = "Sidebar.Item"

$Sidebar_Item.defaultProps = {
  type: $Type_Component,text: ``
}

class $Sidebar_Header extends Component {
  get text () {
    if (this.props.text != undefined) {
      return this.props.text
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {
      className: `sidebar-header-base`
    }, [this.text])
  }
}

$Sidebar_Header.displayName = "Sidebar.Header"

$Sidebar_Header.defaultProps = {
  text: ``
}

class $EntityTab extends Component {
  get of () {
    if (this.props.of != undefined) {
      return this.props.of
    } else {
      return $Type_Component
    }
  }

  get tab () { return $Application.tab }

  get documentation () { return $Application.documentation }

  get page () { return $Application.page }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    return _createElement($Tab, { "link": `/` + this.documentation.name + `/` + $Type.path(this.of), "active": _compare(this.of, this.tab) && _compare(this.page, $Page_Entity), "title": $Type.title(this.of), "color": $Type.color(this.of), "icon": $Type.icon(this.of) })
  }
}

$EntityTab.displayName = "EntityTab"

$EntityTab.defaultProps = {
  of: $Type_Component
}

class $Option extends Component {
  get description () {
    if (this.props.description != undefined) {
      return this.props.description
    } else {
      return $Maybe.nothing()
    }
  }

  get name () {
    if (this.props.name != undefined) {
      return this.props.name
    } else {
      return ``
    }
  }

  render() {
    return _createElement("div", {
      className: `option-base`
    }, [_createElement("div", {
      className: `option-name`
    }, [this.name]), _createElement($If, { "condition": $Maybe.isJust(this.description) }, _array(_createElement("div", {
      className: `option-description`
    }, [_createElement($RawHtml, { "content": $Maybe.withDefault(``, this.description) })])))])
  }
}

$Option.displayName = "Option"

$Option.defaultProps = {
  description: $Maybe.nothing(),name: ``
}

class $Pre extends Component {
  get code () {
    if (this.props.code != undefined) {
      return this.props.code
    } else {
      return ``
    }
  }

  render() {
    return _createElement("pre", {
      className: `pre-base`
    }, [this.code])
  }
}

$Pre.displayName = "Pre"

$Pre.defaultProps = {
  code: ``
}

class $Dashboard extends Component {
  get documentations () { return $Application.documentations }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    let packages = $Array.map(((name) => {
    return _createElement("a", {
      "href": `/` + name,
      className: `dashboard-package`
    }, [$Icons.package(), name])
    }), $Array.map(((item) => {
    return item.name
    }), this.documentations))

    return _createElement("div", {
      className: `dashboard-base`
    }, [_createElement("div", {
      className: `dashboard-title`
    }, [`Dashboard`]), _createElement("div", {}, [packages])])
  }
}

$Dashboard.displayName = "Dashboard"

class $Tab extends Component {
  get background() {
    return (this.active ? this.color : `transparent`)
  }

  get hoverBackground() {
    return (this.active ? `linear-gradient(rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.1)), ` + this.background : `#444`)
  }

  get icon () {
    if (this.props.icon != undefined) {
      return this.props.icon
    } else {
      return $Html.empty()
    }
  }

  get active () {
    if (this.props.active != undefined) {
      return this.props.active
    } else {
      return false
    }
  }

  get title () {
    if (this.props.title != undefined) {
      return this.props.title
    } else {
      return ``
    }
  }

  get color () {
    if (this.props.color != undefined) {
      return this.props.color
    } else {
      return ``
    }
  }

  get link () {
    if (this.props.link != undefined) {
      return this.props.link
    } else {
      return ``
    }
  }

  render() {
    return _createElement("a", {
      "href": this.link,
      className: `tab-base`,
      style: {
        [`--tab-base-background`]: this.background,
        [`--tab-base-hover-background`]: this.hoverBackground
      }
    }, [this.icon, _createElement($If, { "condition": !_compare(this.title, ``) }, _array(_createElement("span", {
      className: `tab-span`
    }, [this.title])))])
  }
}

$Tab.displayName = "Tab"

$Tab.defaultProps = {
  icon: $Html.empty(),active: false,title: ``,color: ``,link: ``
}

class $Page extends Component {
  get selected () { return $Application.selected }

  componentWillUnmount () {
    $Application._unsubscribe(this)
  }

  componentDidMount () {
    $Application._subscribe(this)
  }

  render() {
    let computedProperties = $Array.map(((property) => {
    return _createElement($Entity, { "key": this.selected.name + property.name, "description": property.description, "source": property.source, "name": property.name, "type": property.type })
    }), this.selected.computedProperties)

    let properties = $Array.map(((property) => {
    return _createElement($Entity, { "key": this.selected.name + property.name, "defaultValue": property.defaultValue, "description": property.description, "name": property.name, "type": property.type })
    }), this.selected.properties)

    let methods = $Array.map(((method) => {
    return _createElement($Entity, { "key": this.selected.name + method.name, "description": method.description, "arguments": method.arguments, "source": method.source, "name": method.name, "type": method.type })
    }), this.selected.functions)

    let connects = $Array.map(((item) => {
    return _createElement($Connection, { "store": item.store, "keys": item.keys })
    }), this.selected.connects)

    let fields = $Array.map(((item) => {
    return _createElement($Field, { "mapping": item.mapping, "type": item.type, "name": item.key })
    }), this.selected.fields)

    let state = $Maybe.withDefault($Html.empty(), $Maybe.map(((item) => {
    return _createElement($State, { "type": item.type, "data": item.data })
    }), this.selected.state))

    let options = $Array.map(((item) => {
    return _createElement($Option, { "description": item.description, "name": item.name })
    }), this.selected.options)

    let uses = $Array.map(((item) => {
    return _createElement($Use, { "condition": item.condition, "provider": item.provider, "data": item.data })
    }), this.selected.uses)

    return _createElement("div", {
      className: `page-base`
    }, [_createElement("div", {
      className: `page-title`
    }, [this.selected.name]), _createElement("div", {
      className: `page-description`
    }, [_createElement($RawHtml, { "content": this.selected.description })]), _createElement($Unless, { "condition": $Array.isEmpty(connects) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Connected Stores`]), _createElement("div", {}, [connects]))), _createElement($If, { "condition": $Maybe.isJust(this.selected.state) }, _array(_createElement("div", {
      className: `page-section`
    }, [`State`]), _createElement("div", {}, [state]))), _createElement($Unless, { "condition": $String.isEmpty(this.selected.subscription) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Subscription`]), _createElement("div", {
      className: `page-subscription`
    }, [this.selected.subscription]))), _createElement($Unless, { "condition": $Array.isEmpty(uses) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Using Providers`]), _createElement("div", {}, [uses]))), _createElement($Unless, { "condition": $Array.isEmpty(fields) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Fields`]), _createElement("div", {}, [fields]))), _createElement($Unless, { "condition": $Array.isEmpty(options) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Options`]), _createElement("div", {}, [options]))), _createElement($Unless, { "condition": $Array.isEmpty(properties) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Properties`]), _createElement("div", {}, [properties]))), _createElement($Unless, { "condition": $Array.isEmpty(computedProperties) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Computed Properties`]), _createElement("div", {}, [computedProperties]))), _createElement($Unless, { "condition": $Array.isEmpty(methods) }, _array(_createElement("div", {
      className: `page-section`
    }, [`Functions`]), _createElement("div", {}, [methods])))])
  }
}

$Page.displayName = "Page"

class $Html_Portals_Body extends Component {
  get children () {
    if (this.props.children != undefined) {
      return this.props.children
    } else {
      return []
    }
  }

  render() {
    return _createPortal(this.children, document.body)
  }
}

$Html_Portals_Body.displayName = "Html.Portals.Body"

$Html_Portals_Body.defaultProps = {
  children: []
}

class $Unless extends Component {
  get children () {
    if (this.props.children != undefined) {
      return this.props.children
    } else {
      return []
    }
  }

  get condition () {
    if (this.props.condition != undefined) {
      return this.props.condition
    } else {
      return true
    }
  }

  render() {
    return (!this.condition ? this.children : [])
  }
}

$Unless.displayName = "Unless"

$Unless.defaultProps = {
  children: [],condition: true
}

class $If extends Component {
  get children () {
    if (this.props.children != undefined) {
      return this.props.children
    } else {
      return []
    }
  }

  get condition () {
    if (this.props.condition != undefined) {
      return this.props.condition
    } else {
      return true
    }
  }

  render() {
    return (this.condition ? this.children : [])
  }
}

$If.displayName = "If"

$If.defaultProps = {
  children: [],condition: true
}

_insertStyles(`
  .main-base {
    font-family: sans-serif;
    flex-direction: column;
    min-height: 100vh;
    display: flex;
    color: #333;
  }

  .main-content {
    display: flex;
    flex: 1;
  }

  .use-base {
    font-family: Source Code Pro;
    flex-direction: column;
    padding-top: 15px;
    font-size: 18px;
    display: flex;
  }

  .use-name {
    color: #2e894e;
  }

  .use-code {
    align-self: flex-start;
    margin-left: 20px;
    margin-top: 20px;
  }

  .use-when {
    font-family: sans-serif;
    margin-top: 20px;
  }

  .sidebar-base {
    background: #F5F5F5;
    color: #444;
    padding: 20px;
    padding-right: 40px;
  }

  .sidebar-separator {
    margin-top: 30px;
  }

  .dependency-base {
    display: flex;
  }

  .dependency-id {
    font-size: 20px;
    display: flex;
  }

  .dependency-name {
    font-weight: bold;
  }

  .dependency-repository {
    opacity: 0.5;
  }

  .dependency-constraint {

  }

  .dependency-constraint:before {
    margin: 0 5px;
    content: "-";
  }

  .connection-base {
    font-family: Source Code Pro;
    font-weight: bold;
    padding-top: 15px;
    font-size: 18px;
  }

  .connection-name {
    display: inline;
    color: #2e894e;
  }

  .connection-keys {
    font-weight: normal;
    padding-left: 20px;
  }

  .connection-key {

  }

  .connection-key:not(:last-child):after {
    content: ", ";
  }

  .raw-html-base {

  }

  .raw-html-base *:first-child {
    margin-top: 0;
  }

  .raw-html-base *:last-child {
    margin-bottom: 0;
  }

  .raw-html-base li {
    line-height: 2;
  }

  .raw-html-base pre {
    font-family: Source Code Pro;
    background: #F2F2F2;
    border-radius: 2px;
    padding: 5px 7px;
    font-size: 14px;
    margin: 0;
  }

  .raw-html-base p code {
    font-family: Source Code Pro;
    background: #F2F2F2;
    border-radius: 2px;
    padding: 5px 7px;
    font-size: 14px;
    margin: 0;
  }

  .raw-html-base li code {
    font-family: Source Code Pro;
    background: #F2F2F2;
    border-radius: 2px;
    padding: 5px 7px;
    font-size: 14px;
    margin: 0;
  }

  .error-base {
    justify-content: center;
    font-family: sans-serif;
    flex-direction: column;
    align-items: center;
    font-size: 30px;
    display: flex;
    height: 100vh;
    color: #444;
  }

  .error-icon {
    margin-bottom: 30px;
    fill: currentColor;
  }

  .field-base {
    font-family: Source Code Pro;
    padding-top: 15px;
    font-size: 18px;
    display: flex;
  }

  .field-type {
    color: #2e894e;
  }

  .field-type:before {
    font-weight: 300;
    margin: 0 5px;
    content: ":";
    color: #999;
  }

  .field-key {
    font-weight: bold;
  }

  .source-base {
    text-transform: uppercase;
    align-items: center;
    margin-top: 10px;
    font-size: 10px;
    cursor: pointer;
    display: flex;
    opacity: 0.33;
  }

  .source-base:hover {
    opacity: 1;
  }

  .source-icon {
    transform: var(--source-icon-transform);
    position: relative;
    fill: currentColor;
    margin-right: 5px;
    top: -1px;
  }

  .source-code {
    margin-top: 10px;
  }

  .package-base {
    padding: 30px;
  }

  .package-title {
    border-bottom: 3px solid #EEE;
    padding-bottom: 5px;
    margin-bottom: 20px;
    font-size: 36px;
  }

  .package-package {
    display: block;
  }

  .package-subtitle {
    margin-bottom: 5px;
    font-size: 20px;
  }

  .tabs-base {
    border-bottom: var(--tabs-base-border-bottom);
    font-weight: bold;
    background: #333;
    display: flex;
    color: #EEE;
  }

  .state-base {
    font-family: Source Code Pro;
    flex-direction: column;
    padding-top: 15px;
    font-size: 18px;
    display: flex;
  }

  .state-type {
    align-items: center;
    color: #2e894e;
    display: flex;
  }

  .state-equals {
    margin-left: 10px;
    font-weight: 300;
    margin-top: 5px;
    content: "=";
    color: #999;
  }

  .state-code {
    align-self: flex-start;
    margin-left: 20px;
    margin-top: 20px;
    display: block;
  }

  .entity-definition {
    font-family: Source Code Pro;
    white-space: nowrap;
    align-items: center;
    font-size: 18px;
    display: flex;
  }

  .entity-name {
    align-items: center;
    font-weight: bold;
    display: flex;
  }

  .entity-type {
    color: #2e894e;
  }

  .entity-type:before {
    font-weight: 300;
    margin: 0 5px;
    content: ":";
    color: #999;
  }

  .entity-base {
    padding: 15px 0;
  }

  .entity-base + * {
    border-top: 1px dashed #DDD;
  }

  .entity-arguments {
    display: flex;
  }

  .entity-arguments:before {
    content: "(";
    opacity: 0.75;
  }

  .entity-arguments:after {
    content: ")";
    opacity: 0.75;
  }

  .entity-argument {

  }

  .entity-argument + *:before {
    content: ", ";
  }

  .entity-description {
    padding: 18px 0;
    padding-left: 20px;
    opacity: 0.8;
  }

  .entity-default {
    align-items: center;
    display: flex;
  }

  .entity-default:before {
    font-weight: 300;
    margin: 0 5px;
    content: "=";
    color: #999;
  }

  .sidebar-item-base {
    text-decoration: none;
    align-items: center;
    margin-bottom: 5px;
    cursor: pointer;
    color: inherit;
    display: flex;
  }

  .sidebar-item-base:hover span {
    text-decoration: underline;
  }

  .sidebar-item-span {
    line-height: 13px;
  }

  .sidebar-item-badge {
    background-color: var(--sidebar-item-badge-background-color);
    justify-content: center;
    display: inline-flex;
    align-items: center;
    margin-right: 7px;
    border-radius: 2px;
    font-weight: bold;
    font-size: 12px;
    height: 20px;
    width: 20px;
    color: #FFF;
  }

  .sidebar-header-base {
    text-transform: uppercase;
    margin-bottom: 10px;
    font-weight: bold;
    font-size: 14px;
  }

  .option-base {
    flex-direction: column;
    padding-top: 15px;
    display: flex;
  }

  .option-name {
    font-family: Source Code Pro;
    font-weight: bold;
    font-size: 18px;
  }

  .option-description {
    padding: 20px 0;
    padding-left: 20px;
    opacity: 0.8;
  }

  .pre-base {
    font-family: Source Code Pro;
    border: 1px dashed #DDD;
    background: #FAFAFA;
    font-size: 14px;
    padding: 10px;
    margin: 0;
  }

  .dashboard-base {
    padding: 30px;
  }

  .dashboard-package {
    align-items: center;
    font-size: 18px;
    padding: 10px 0;
    color: #2e894e;
    display: flex;
  }

  .dashboard-package svg {
    fill: currentColor;
    margin-right: 5px;
    height: 20px;
    width: 20px;
  }

  .dashboard-title {
    border-bottom: 3px solid #EEE;
    padding-bottom: 5px;
    margin-bottom: 20px;
    font-size: 36px;
  }

  .tab-base {
    background: var(--tab-base-background);
    text-decoration: none;
    align-items: center;
    padding: 0 15px;
    cursor: pointer;
    color: inherit;
    display: flex;
    height: 50px;
  }

  .tab-base:hover {
    background: var(--tab-base-hover-background);
  }

  .tab-base svg {
    filter: drop-shadow(0 1px 0 rgba(0,0,0,0.333));
    fill: currentColor;
    height: 18px;
    width: 18px;
  }

  .tab-span {
    text-shadow: 0 1px 0 rgba(0,0,0,0.333);
    text-transform: uppercase;
    margin-left: 10px;
    font-size: 14px;
  }

  .page-base {
    flex: 1;
    padding: 30px;
    padding-bottom: 150px;
  }

  .page-title {
    border-bottom: 2px solid #EEE;
    padding-bottom: 10px;
    font-size: 30px;
  }

  .page-description {
    margin-top: 20px;
    opacity: 0.8;
  }

  .page-section {
    border-bottom: 1px solid #EEE;
    text-transform: uppercase;
    padding-bottom: 10px;
    font-weight: 600;
    margin-top: 40px;
    font-size: 14px;
    opacity: 0.6;
  }

  .page-subscription {
    font-family: Source Code Pro;
    margin-top: 15px;
    font-size: 18px;
    color: #2e894e;
  }
`)
_program.render($Main)
})()