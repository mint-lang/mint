var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __require = /* @__PURE__ */ ((x3) => typeof require !== "undefined" ? require : typeof Proxy !== "undefined" ? new Proxy(x3, {
  get: (a4, b4) => (typeof require !== "undefined" ? require : a4)[b4]
}) : x3)(function(x3) {
  if (typeof require !== "undefined")
    return require.apply(this, arguments);
  throw Error('Dynamic require of "' + x3 + '" is not supported');
});
var __commonJS = (cb, mod) => function __require2() {
  return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));

// (disabled):crypto
var require_crypto = __commonJS({
  "(disabled):crypto"() {
  }
});

// node_modules/uuid-random/index.js
var require_uuid_random = __commonJS({
  "node_modules/uuid-random/index.js"(exports, module) {
    "use strict";
    (function() {
      var buf, bufIdx = 0, hexBytes = [], i4;
      for (i4 = 0; i4 < 256; i4++) {
        hexBytes[i4] = (i4 + 256).toString(16).substr(1);
      }
      uuid2.BUFFER_SIZE = 4096;
      uuid2.bin = uuidBin;
      uuid2.clearBuffer = function() {
        buf = null;
        bufIdx = 0;
      };
      uuid2.test = function(uuid3) {
        if (typeof uuid3 === "string") {
          return /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(uuid3);
        }
        return false;
      };
      var crypt0;
      if (typeof crypto !== "undefined") {
        crypt0 = crypto;
      } else if (typeof window !== "undefined" && typeof window.msCrypto !== "undefined") {
        crypt0 = window.msCrypto;
      }
      if (typeof module !== "undefined" && typeof __require === "function") {
        crypt0 = crypt0 || require_crypto();
        module.exports = uuid2;
      } else if (typeof window !== "undefined") {
        window.uuid = uuid2;
      }
      uuid2.randomBytes = function() {
        if (crypt0) {
          if (crypt0.randomBytes) {
            return crypt0.randomBytes;
          }
          if (crypt0.getRandomValues) {
            if (typeof Uint8Array.prototype.slice !== "function") {
              return function(n3) {
                var bytes = new Uint8Array(n3);
                crypt0.getRandomValues(bytes);
                return Array.from(bytes);
              };
            }
            return function(n3) {
              var bytes = new Uint8Array(n3);
              crypt0.getRandomValues(bytes);
              return bytes;
            };
          }
        }
        return function(n3) {
          var i5, r4 = [];
          for (i5 = 0; i5 < n3; i5++) {
            r4.push(Math.floor(Math.random() * 256));
          }
          return r4;
        };
      }();
      function randomBytesBuffered(n3) {
        if (!buf || bufIdx + n3 > uuid2.BUFFER_SIZE) {
          bufIdx = 0;
          buf = uuid2.randomBytes(uuid2.BUFFER_SIZE);
        }
        return buf.slice(bufIdx, bufIdx += n3);
      }
      function uuidBin() {
        var b4 = randomBytesBuffered(16);
        b4[6] = b4[6] & 15 | 64;
        b4[8] = b4[8] & 63 | 128;
        return b4;
      }
      function uuid2() {
        var b4 = uuidBin();
        return hexBytes[b4[0]] + hexBytes[b4[1]] + hexBytes[b4[2]] + hexBytes[b4[3]] + "-" + hexBytes[b4[4]] + hexBytes[b4[5]] + "-" + hexBytes[b4[6]] + hexBytes[b4[7]] + "-" + hexBytes[b4[8]] + hexBytes[b4[9]] + "-" + hexBytes[b4[10]] + hexBytes[b4[11]] + hexBytes[b4[12]] + hexBytes[b4[13]] + hexBytes[b4[14]] + hexBytes[b4[15]];
      }
    })();
  }
});

// node_modules/route-parser/lib/route/compiled-grammar.js
var require_compiled_grammar = __commonJS({
  "node_modules/route-parser/lib/route/compiled-grammar.js"(exports) {
    var parser = function() {
      var o4 = function(k3, v5, o5, l5) {
        for (o5 = o5 || {}, l5 = k3.length; l5--; o5[k3[l5]] = v5)
          ;
        return o5;
      }, $V0 = [1, 9], $V1 = [1, 10], $V2 = [1, 11], $V3 = [1, 12], $V4 = [5, 11, 12, 13, 14, 15];
      var parser2 = {
        trace: function trace() {
        },
        yy: {},
        symbols_: { "error": 2, "root": 3, "expressions": 4, "EOF": 5, "expression": 6, "optional": 7, "literal": 8, "splat": 9, "param": 10, "(": 11, ")": 12, "LITERAL": 13, "SPLAT": 14, "PARAM": 15, "$accept": 0, "$end": 1 },
        terminals_: { 2: "error", 5: "EOF", 11: "(", 12: ")", 13: "LITERAL", 14: "SPLAT", 15: "PARAM" },
        productions_: [0, [3, 2], [3, 1], [4, 2], [4, 1], [6, 1], [6, 1], [6, 1], [6, 1], [7, 3], [8, 1], [9, 1], [10, 1]],
        performAction: function anonymous(yytext, yyleng, yylineno, yy, yystate, $$, _$) {
          var $0 = $$.length - 1;
          switch (yystate) {
            case 1:
              return new yy.Root({}, [$$[$0 - 1]]);
              break;
            case 2:
              return new yy.Root({}, [new yy.Literal({ value: "" })]);
              break;
            case 3:
              this.$ = new yy.Concat({}, [$$[$0 - 1], $$[$0]]);
              break;
            case 4:
            case 5:
              this.$ = $$[$0];
              break;
            case 6:
              this.$ = new yy.Literal({ value: $$[$0] });
              break;
            case 7:
              this.$ = new yy.Splat({ name: $$[$0] });
              break;
            case 8:
              this.$ = new yy.Param({ name: $$[$0] });
              break;
            case 9:
              this.$ = new yy.Optional({}, [$$[$0 - 1]]);
              break;
            case 10:
              this.$ = yytext;
              break;
            case 11:
            case 12:
              this.$ = yytext.slice(1);
              break;
          }
        },
        table: [{ 3: 1, 4: 2, 5: [1, 3], 6: 4, 7: 5, 8: 6, 9: 7, 10: 8, 11: $V0, 13: $V1, 14: $V2, 15: $V3 }, { 1: [3] }, { 5: [1, 13], 6: 14, 7: 5, 8: 6, 9: 7, 10: 8, 11: $V0, 13: $V1, 14: $V2, 15: $V3 }, { 1: [2, 2] }, o4($V4, [2, 4]), o4($V4, [2, 5]), o4($V4, [2, 6]), o4($V4, [2, 7]), o4($V4, [2, 8]), { 4: 15, 6: 4, 7: 5, 8: 6, 9: 7, 10: 8, 11: $V0, 13: $V1, 14: $V2, 15: $V3 }, o4($V4, [2, 10]), o4($V4, [2, 11]), o4($V4, [2, 12]), { 1: [2, 1] }, o4($V4, [2, 3]), { 6: 14, 7: 5, 8: 6, 9: 7, 10: 8, 11: $V0, 12: [1, 16], 13: $V1, 14: $V2, 15: $V3 }, o4($V4, [2, 9])],
        defaultActions: { 3: [2, 2], 13: [2, 1] },
        parseError: function parseError(str, hash) {
          if (hash.recoverable) {
            this.trace(str);
          } else {
            let _parseError2 = function(msg, hash2) {
              this.message = msg;
              this.hash = hash2;
            };
            var _parseError = _parseError2;
            _parseError2.prototype = Error;
            throw new _parseError2(str, hash);
          }
        },
        parse: function parse(input) {
          var self2 = this, stack = [0], tstack = [], vstack = [null], lstack = [], table = this.table, yytext = "", yylineno = 0, yyleng = 0, recovering = 0, TERROR = 2, EOF = 1;
          var args = lstack.slice.call(arguments, 1);
          var lexer2 = Object.create(this.lexer);
          var sharedState = { yy: {} };
          for (var k3 in this.yy) {
            if (Object.prototype.hasOwnProperty.call(this.yy, k3)) {
              sharedState.yy[k3] = this.yy[k3];
            }
          }
          lexer2.setInput(input, sharedState.yy);
          sharedState.yy.lexer = lexer2;
          sharedState.yy.parser = this;
          if (typeof lexer2.yylloc == "undefined") {
            lexer2.yylloc = {};
          }
          var yyloc = lexer2.yylloc;
          lstack.push(yyloc);
          var ranges = lexer2.options && lexer2.options.ranges;
          if (typeof sharedState.yy.parseError === "function") {
            this.parseError = sharedState.yy.parseError;
          } else {
            this.parseError = Object.getPrototypeOf(this).parseError;
          }
          function popStack(n3) {
            stack.length = stack.length - 2 * n3;
            vstack.length = vstack.length - n3;
            lstack.length = lstack.length - n3;
          }
          var lex = function() {
            var token;
            token = lexer2.lex() || EOF;
            if (typeof token !== "number") {
              token = self2.symbols_[token] || token;
            }
            return token;
          };
          var symbol, preErrorSymbol, state, action, a4, r4, yyval = {}, p5, len, newState, expected;
          while (true) {
            state = stack[stack.length - 1];
            if (this.defaultActions[state]) {
              action = this.defaultActions[state];
            } else {
              if (symbol === null || typeof symbol == "undefined") {
                symbol = lex();
              }
              action = table[state] && table[state][symbol];
            }
            if (typeof action === "undefined" || !action.length || !action[0]) {
              var errStr = "";
              expected = [];
              for (p5 in table[state]) {
                if (this.terminals_[p5] && p5 > TERROR) {
                  expected.push("'" + this.terminals_[p5] + "'");
                }
              }
              if (lexer2.showPosition) {
                errStr = "Parse error on line " + (yylineno + 1) + ":\n" + lexer2.showPosition() + "\nExpecting " + expected.join(", ") + ", got '" + (this.terminals_[symbol] || symbol) + "'";
              } else {
                errStr = "Parse error on line " + (yylineno + 1) + ": Unexpected " + (symbol == EOF ? "end of input" : "'" + (this.terminals_[symbol] || symbol) + "'");
              }
              this.parseError(errStr, {
                text: lexer2.match,
                token: this.terminals_[symbol] || symbol,
                line: lexer2.yylineno,
                loc: yyloc,
                expected
              });
            }
            if (action[0] instanceof Array && action.length > 1) {
              throw new Error("Parse Error: multiple actions possible at state: " + state + ", token: " + symbol);
            }
            switch (action[0]) {
              case 1:
                stack.push(symbol);
                vstack.push(lexer2.yytext);
                lstack.push(lexer2.yylloc);
                stack.push(action[1]);
                symbol = null;
                if (!preErrorSymbol) {
                  yyleng = lexer2.yyleng;
                  yytext = lexer2.yytext;
                  yylineno = lexer2.yylineno;
                  yyloc = lexer2.yylloc;
                  if (recovering > 0) {
                    recovering--;
                  }
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
                r4 = this.performAction.apply(yyval, [
                  yytext,
                  yyleng,
                  yylineno,
                  sharedState.yy,
                  action[1],
                  vstack,
                  lstack
                ].concat(args));
                if (typeof r4 !== "undefined") {
                  return r4;
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
        }
      };
      var lexer = /* @__PURE__ */ function() {
        var lexer2 = {
          EOF: 1,
          parseError: function parseError(str, hash) {
            if (this.yy.parser) {
              this.yy.parser.parseError(str, hash);
            } else {
              throw new Error(str);
            }
          },
          // resets the lexer, sets new input
          setInput: function(input, yy) {
            this.yy = yy || this.yy || {};
            this._input = input;
            this._more = this._backtrack = this.done = false;
            this.yylineno = this.yyleng = 0;
            this.yytext = this.matched = this.match = "";
            this.conditionStack = ["INITIAL"];
            this.yylloc = {
              first_line: 1,
              first_column: 0,
              last_line: 1,
              last_column: 0
            };
            if (this.options.ranges) {
              this.yylloc.range = [0, 0];
            }
            this.offset = 0;
            return this;
          },
          // consumes and returns one char from the input
          input: function() {
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
          unput: function(ch) {
            var len = ch.length;
            var lines = ch.split(/(?:\r\n?|\n)/g);
            this._input = ch + this._input;
            this.yytext = this.yytext.substr(0, this.yytext.length - len);
            this.offset -= len;
            var oldLines = this.match.split(/(?:\r\n?|\n)/g);
            this.match = this.match.substr(0, this.match.length - 1);
            this.matched = this.matched.substr(0, this.matched.length - 1);
            if (lines.length - 1) {
              this.yylineno -= lines.length - 1;
            }
            var r4 = this.yylloc.range;
            this.yylloc = {
              first_line: this.yylloc.first_line,
              last_line: this.yylineno + 1,
              first_column: this.yylloc.first_column,
              last_column: lines ? (lines.length === oldLines.length ? this.yylloc.first_column : 0) + oldLines[oldLines.length - lines.length].length - lines[0].length : this.yylloc.first_column - len
            };
            if (this.options.ranges) {
              this.yylloc.range = [r4[0], r4[0] + this.yyleng - len];
            }
            this.yyleng = this.yytext.length;
            return this;
          },
          // When called from action, caches matched text and appends it on next action
          more: function() {
            this._more = true;
            return this;
          },
          // When called from action, signals the lexer that this rule fails to match the input, so the next matching rule (regex) should be tested instead.
          reject: function() {
            if (this.options.backtrack_lexer) {
              this._backtrack = true;
            } else {
              return this.parseError("Lexical error on line " + (this.yylineno + 1) + ". You can only invoke reject() in the lexer when the lexer is of the backtracking persuasion (options.backtrack_lexer = true).\n" + this.showPosition(), {
                text: "",
                token: null,
                line: this.yylineno
              });
            }
            return this;
          },
          // retain first n characters of the match
          less: function(n3) {
            this.unput(this.match.slice(n3));
          },
          // displays already matched input, i.e. for error messages
          pastInput: function() {
            var past = this.matched.substr(0, this.matched.length - this.match.length);
            return (past.length > 20 ? "..." : "") + past.substr(-20).replace(/\n/g, "");
          },
          // displays upcoming input, i.e. for error messages
          upcomingInput: function() {
            var next = this.match;
            if (next.length < 20) {
              next += this._input.substr(0, 20 - next.length);
            }
            return (next.substr(0, 20) + (next.length > 20 ? "..." : "")).replace(/\n/g, "");
          },
          // displays the character position where the lexing error occurred, i.e. for error messages
          showPosition: function() {
            var pre = this.pastInput();
            var c4 = new Array(pre.length + 1).join("-");
            return pre + this.upcomingInput() + "\n" + c4 + "^";
          },
          // test the lexed token: return FALSE when not a match, otherwise return token
          test_match: function(match2, indexed_rule) {
            var token, lines, backup;
            if (this.options.backtrack_lexer) {
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
            lines = match2[0].match(/(?:\r\n?|\n).*/g);
            if (lines) {
              this.yylineno += lines.length;
            }
            this.yylloc = {
              first_line: this.yylloc.last_line,
              last_line: this.yylineno + 1,
              first_column: this.yylloc.last_column,
              last_column: lines ? lines[lines.length - 1].length - lines[lines.length - 1].match(/\r?\n?/)[0].length : this.yylloc.last_column + match2[0].length
            };
            this.yytext += match2[0];
            this.match += match2[0];
            this.matches = match2;
            this.yyleng = this.yytext.length;
            if (this.options.ranges) {
              this.yylloc.range = [this.offset, this.offset += this.yyleng];
            }
            this._more = false;
            this._backtrack = false;
            this._input = this._input.slice(match2[0].length);
            this.matched += match2[0];
            token = this.performAction.call(this, this.yy, this, indexed_rule, this.conditionStack[this.conditionStack.length - 1]);
            if (this.done && this._input) {
              this.done = false;
            }
            if (token) {
              return token;
            } else if (this._backtrack) {
              for (var k3 in backup) {
                this[k3] = backup[k3];
              }
              return false;
            }
            return false;
          },
          // return next match in input
          next: function() {
            if (this.done) {
              return this.EOF;
            }
            if (!this._input) {
              this.done = true;
            }
            var token, match2, tempMatch, index;
            if (!this._more) {
              this.yytext = "";
              this.match = "";
            }
            var rules = this._currentRules();
            for (var i4 = 0; i4 < rules.length; i4++) {
              tempMatch = this._input.match(this.rules[rules[i4]]);
              if (tempMatch && (!match2 || tempMatch[0].length > match2[0].length)) {
                match2 = tempMatch;
                index = i4;
                if (this.options.backtrack_lexer) {
                  token = this.test_match(tempMatch, rules[i4]);
                  if (token !== false) {
                    return token;
                  } else if (this._backtrack) {
                    match2 = false;
                    continue;
                  } else {
                    return false;
                  }
                } else if (!this.options.flex) {
                  break;
                }
              }
            }
            if (match2) {
              token = this.test_match(match2, rules[index]);
              if (token !== false) {
                return token;
              }
              return false;
            }
            if (this._input === "") {
              return this.EOF;
            } else {
              return this.parseError("Lexical error on line " + (this.yylineno + 1) + ". Unrecognized text.\n" + this.showPosition(), {
                text: "",
                token: null,
                line: this.yylineno
              });
            }
          },
          // return next match that has a token
          lex: function lex() {
            var r4 = this.next();
            if (r4) {
              return r4;
            } else {
              return this.lex();
            }
          },
          // activates a new lexer condition state (pushes the new lexer condition state onto the condition stack)
          begin: function begin(condition) {
            this.conditionStack.push(condition);
          },
          // pop the previously active lexer condition state off the condition stack
          popState: function popState() {
            var n3 = this.conditionStack.length - 1;
            if (n3 > 0) {
              return this.conditionStack.pop();
            } else {
              return this.conditionStack[0];
            }
          },
          // produce the lexer rule set which is active for the currently active lexer condition state
          _currentRules: function _currentRules() {
            if (this.conditionStack.length && this.conditionStack[this.conditionStack.length - 1]) {
              return this.conditions[this.conditionStack[this.conditionStack.length - 1]].rules;
            } else {
              return this.conditions["INITIAL"].rules;
            }
          },
          // return the currently active lexer condition state; when an index argument is provided it produces the N-th previous condition state, if available
          topState: function topState(n3) {
            n3 = this.conditionStack.length - 1 - Math.abs(n3 || 0);
            if (n3 >= 0) {
              return this.conditionStack[n3];
            } else {
              return "INITIAL";
            }
          },
          // alias for begin(condition)
          pushState: function pushState(condition) {
            this.begin(condition);
          },
          // return the number of states currently on the stack
          stateStackSize: function stateStackSize() {
            return this.conditionStack.length;
          },
          options: {},
          performAction: function anonymous(yy, yy_, $avoiding_name_collisions, YY_START) {
            var YYSTATE = YY_START;
            switch ($avoiding_name_collisions) {
              case 0:
                return "(";
                break;
              case 1:
                return ")";
                break;
              case 2:
                return "SPLAT";
                break;
              case 3:
                return "PARAM";
                break;
              case 4:
                return "LITERAL";
                break;
              case 5:
                return "LITERAL";
                break;
              case 6:
                return "EOF";
                break;
            }
          },
          rules: [/^(?:\()/, /^(?:\))/, /^(?:\*+\w+)/, /^(?::+\w+)/, /^(?:[\w%\-~\n]+)/, /^(?:.)/, /^(?:$)/],
          conditions: { "INITIAL": { "rules": [0, 1, 2, 3, 4, 5, 6], "inclusive": true } }
        };
        return lexer2;
      }();
      parser2.lexer = lexer;
      function Parser() {
        this.yy = {};
      }
      Parser.prototype = parser2;
      parser2.Parser = Parser;
      return new Parser();
    }();
    if (typeof __require !== "undefined" && typeof exports !== "undefined") {
      exports.parser = parser;
      exports.Parser = parser.Parser;
      exports.parse = function() {
        return parser.parse.apply(parser, arguments);
      };
    }
  }
});

// node_modules/route-parser/lib/route/nodes.js
var require_nodes = __commonJS({
  "node_modules/route-parser/lib/route/nodes.js"(exports, module) {
    "use strict";
    function createNode(displayName) {
      return function(props, children) {
        return {
          displayName,
          props,
          children: children || []
        };
      };
    }
    module.exports = {
      Root: createNode("Root"),
      Concat: createNode("Concat"),
      Literal: createNode("Literal"),
      Splat: createNode("Splat"),
      Param: createNode("Param"),
      Optional: createNode("Optional")
    };
  }
});

// node_modules/route-parser/lib/route/parser.js
var require_parser = __commonJS({
  "node_modules/route-parser/lib/route/parser.js"(exports, module) {
    "use strict";
    var parser = require_compiled_grammar().parser;
    parser.yy = require_nodes();
    module.exports = parser;
  }
});

// node_modules/route-parser/lib/route/visitors/create_visitor.js
var require_create_visitor = __commonJS({
  "node_modules/route-parser/lib/route/visitors/create_visitor.js"(exports, module) {
    "use strict";
    var nodeTypes = Object.keys(require_nodes());
    function createVisitor(handlers) {
      nodeTypes.forEach(function(nodeType) {
        if (typeof handlers[nodeType] === "undefined") {
          throw new Error("No handler defined for " + nodeType.displayName);
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
          return this.handlers[node.displayName].call(this, node, context);
        },
        handlers
      };
    }
    module.exports = createVisitor;
  }
});

// node_modules/route-parser/lib/route/visitors/regexp.js
var require_regexp = __commonJS({
  "node_modules/route-parser/lib/route/visitors/regexp.js"(exports, module) {
    "use strict";
    var createVisitor = require_create_visitor();
    var escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g;
    function Matcher(options) {
      this.captures = options.captures;
      this.re = options.re;
    }
    Matcher.prototype.match = function(path) {
      var match2 = this.re.exec(path);
      var matchParams = {};
      if (!match2) {
        return false;
      }
      this.captures.forEach(function(capture, i4) {
        if (typeof match2[i4 + 1] === "undefined") {
          matchParams[capture] = void 0;
        } else {
          matchParams[capture] = decodeURIComponent(match2[i4 + 1]);
        }
      });
      return matchParams;
    };
    var RegexpVisitor = createVisitor({
      Concat: function(node) {
        return node.children.reduce(
          function(memo, child) {
            var childResult = this.visit(child);
            return {
              re: memo.re + childResult.re,
              captures: memo.captures.concat(childResult.captures)
            };
          }.bind(this),
          { re: "", captures: [] }
        );
      },
      Literal: function(node) {
        return {
          re: node.props.value.replace(escapeRegExp, "\\$&"),
          captures: []
        };
      },
      Splat: function(node) {
        return {
          re: "([^?#]*?)",
          captures: [node.props.name]
        };
      },
      Param: function(node) {
        return {
          re: "([^\\/\\?#]+)",
          captures: [node.props.name]
        };
      },
      Optional: function(node) {
        var child = this.visit(node.children[0]);
        return {
          re: "(?:" + child.re + ")?",
          captures: child.captures
        };
      },
      Root: function(node) {
        var childResult = this.visit(node.children[0]);
        return new Matcher({
          re: new RegExp("^" + childResult.re + "(?=\\?|#|$)"),
          captures: childResult.captures
        });
      }
    });
    module.exports = RegexpVisitor;
  }
});

// node_modules/route-parser/lib/route/visitors/reverse.js
var require_reverse = __commonJS({
  "node_modules/route-parser/lib/route/visitors/reverse.js"(exports, module) {
    "use strict";
    var createVisitor = require_create_visitor();
    var ReverseVisitor = createVisitor({
      Concat: function(node, context) {
        var childResults = node.children.map(function(child) {
          return this.visit(child, context);
        }.bind(this));
        if (childResults.some(function(c4) {
          return c4 === false;
        })) {
          return false;
        }
        return childResults.join("");
      },
      Literal: function(node) {
        return decodeURI(node.props.value);
      },
      Splat: function(node, context) {
        if (typeof context[node.props.name] === "undefined") {
          return false;
        }
        return context[node.props.name];
      },
      Param: function(node, context) {
        if (typeof context[node.props.name] === "undefined") {
          return false;
        }
        return context[node.props.name];
      },
      Optional: function(node, context) {
        var childResult = this.visit(node.children[0], context);
        if (childResult) {
          return childResult;
        }
        return "";
      },
      Root: function(node, context) {
        context = context || {};
        var childResult = this.visit(node.children[0], context);
        if (childResult === false || typeof childResult === "undefined") {
          return false;
        }
        return encodeURI(childResult);
      }
    });
    module.exports = ReverseVisitor;
  }
});

// node_modules/route-parser/lib/route.js
var require_route = __commonJS({
  "node_modules/route-parser/lib/route.js"(exports, module) {
    "use strict";
    var Parser = require_parser();
    var RegexpVisitor = require_regexp();
    var ReverseVisitor = require_reverse();
    function Route(spec) {
      var route;
      if (this) {
        route = this;
      } else {
        route = Object.create(Route.prototype);
      }
      if (typeof spec === "undefined") {
        throw new Error("A route spec is required");
      }
      route.spec = spec;
      route.ast = Parser.parse(spec);
      return route;
    }
    Route.prototype = /* @__PURE__ */ Object.create(null);
    Route.prototype.match = function(path) {
      var re = RegexpVisitor.visit(this.ast);
      var matched = re.match(path);
      return matched !== null ? matched : false;
    };
    Route.prototype.reverse = function(params) {
      return ReverseVisitor.visit(this.ast, params);
    };
    module.exports = Route;
  }
});

// node_modules/route-parser/index.js
var require_route_parser = __commonJS({
  "node_modules/route-parser/index.js"(exports, module) {
    "use strict";
    var Route = require_route();
    module.exports = Route;
  }
});

// node_modules/preact/dist/preact.module.js
var n;
var l;
var u;
var t;
var i;
var o;
var r;
var f;
var e;
var c = {};
var s = [];
var a = /acit|ex(?:s|g|n|p|$)|rph|grid|ows|mnc|ntw|ine[ch]|zoo|^ord|itera/i;
var h = Array.isArray;
function v(n3, l5) {
  for (var u4 in l5)
    n3[u4] = l5[u4];
  return n3;
}
function p(n3) {
  var l5 = n3.parentNode;
  l5 && l5.removeChild(n3);
}
function y(l5, u4, t4) {
  var i4, o4, r4, f4 = {};
  for (r4 in u4)
    "key" == r4 ? i4 = u4[r4] : "ref" == r4 ? o4 = u4[r4] : f4[r4] = u4[r4];
  if (arguments.length > 2 && (f4.children = arguments.length > 3 ? n.call(arguments, 2) : t4), "function" == typeof l5 && null != l5.defaultProps)
    for (r4 in l5.defaultProps)
      void 0 === f4[r4] && (f4[r4] = l5.defaultProps[r4]);
  return d(l5, f4, i4, o4, null);
}
function d(n3, t4, i4, o4, r4) {
  var f4 = { type: n3, props: t4, key: i4, ref: o4, __k: null, __: null, __b: 0, __e: null, __d: void 0, __c: null, constructor: void 0, __v: null == r4 ? ++u : r4, __i: -1, __u: 0 };
  return null == r4 && null != l.vnode && l.vnode(f4), f4;
}
function g(n3) {
  return n3.children;
}
function b(n3, l5) {
  this.props = n3, this.context = l5;
}
function m(n3, l5) {
  if (null == l5)
    return n3.__ ? m(n3.__, n3.__i + 1) : null;
  for (var u4; l5 < n3.__k.length; l5++)
    if (null != (u4 = n3.__k[l5]) && null != u4.__e)
      return u4.__e;
  return "function" == typeof n3.type ? m(n3) : null;
}
function k(n3) {
  var l5, u4;
  if (null != (n3 = n3.__) && null != n3.__c) {
    for (n3.__e = n3.__c.base = null, l5 = 0; l5 < n3.__k.length; l5++)
      if (null != (u4 = n3.__k[l5]) && null != u4.__e) {
        n3.__e = n3.__c.base = u4.__e;
        break;
      }
    return k(n3);
  }
}
function w(n3) {
  (!n3.__d && (n3.__d = true) && i.push(n3) && !x.__r++ || o !== l.debounceRendering) && ((o = l.debounceRendering) || r)(x);
}
function x() {
  var n3, u4, t4, o4, r4, e4, c4, s4, a4;
  for (i.sort(f); n3 = i.shift(); )
    n3.__d && (u4 = i.length, o4 = void 0, e4 = (r4 = (t4 = n3).__v).__e, s4 = [], a4 = [], (c4 = t4.__P) && ((o4 = v({}, r4)).__v = r4.__v + 1, l.vnode && l.vnode(o4), L(c4, o4, r4, t4.__n, void 0 !== c4.ownerSVGElement, 32 & r4.__u ? [e4] : null, s4, null == e4 ? m(r4) : e4, !!(32 & r4.__u), a4), o4.__.__k[o4.__i] = o4, M(s4, o4, a4), o4.__e != e4 && k(o4)), i.length > u4 && i.sort(f));
  x.__r = 0;
}
function C(n3, l5, u4, t4, i4, o4, r4, f4, e4, a4, h3) {
  var v5, p5, y3, d5, _5, g4 = t4 && t4.__k || s, b4 = l5.length;
  for (u4.__d = e4, P(u4, l5, g4), e4 = u4.__d, v5 = 0; v5 < b4; v5++)
    null != (y3 = u4.__k[v5]) && "boolean" != typeof y3 && "function" != typeof y3 && (p5 = -1 === y3.__i ? c : g4[y3.__i] || c, y3.__i = v5, L(n3, y3, p5, i4, o4, r4, f4, e4, a4, h3), d5 = y3.__e, y3.ref && p5.ref != y3.ref && (p5.ref && z(p5.ref, null, y3), h3.push(y3.ref, y3.__c || d5, y3)), null == _5 && null != d5 && (_5 = d5), 65536 & y3.__u || p5.__k === y3.__k ? e4 = S(y3, e4, n3) : "function" == typeof y3.type && void 0 !== y3.__d ? e4 = y3.__d : d5 && (e4 = d5.nextSibling), y3.__d = void 0, y3.__u &= -196609);
  u4.__d = e4, u4.__e = _5;
}
function P(n3, l5, u4) {
  var t4, i4, o4, r4, f4, e4 = l5.length, c4 = u4.length, s4 = c4, a4 = 0;
  for (n3.__k = [], t4 = 0; t4 < e4; t4++)
    null != (i4 = n3.__k[t4] = null == (i4 = l5[t4]) || "boolean" == typeof i4 || "function" == typeof i4 ? null : "string" == typeof i4 || "number" == typeof i4 || "bigint" == typeof i4 || i4.constructor == String ? d(null, i4, null, null, i4) : h(i4) ? d(g, { children: i4 }, null, null, null) : void 0 === i4.constructor && i4.__b > 0 ? d(i4.type, i4.props, i4.key, i4.ref ? i4.ref : null, i4.__v) : i4) ? (i4.__ = n3, i4.__b = n3.__b + 1, f4 = H(i4, u4, r4 = t4 + a4, s4), i4.__i = f4, o4 = null, -1 !== f4 && (s4--, (o4 = u4[f4]) && (o4.__u |= 131072)), null == o4 || null === o4.__v ? (-1 == f4 && a4--, "function" != typeof i4.type && (i4.__u |= 65536)) : f4 !== r4 && (f4 === r4 + 1 ? a4++ : f4 > r4 ? s4 > e4 - r4 ? a4 += f4 - r4 : a4-- : a4 = f4 < r4 && f4 == r4 - 1 ? f4 - r4 : 0, f4 !== t4 + a4 && (i4.__u |= 65536))) : (o4 = u4[t4]) && null == o4.key && o4.__e && (o4.__e == n3.__d && (n3.__d = m(o4)), N(o4, o4, false), u4[t4] = null, s4--);
  if (s4)
    for (t4 = 0; t4 < c4; t4++)
      null != (o4 = u4[t4]) && 0 == (131072 & o4.__u) && (o4.__e == n3.__d && (n3.__d = m(o4)), N(o4, o4));
}
function S(n3, l5, u4) {
  var t4, i4;
  if ("function" == typeof n3.type) {
    for (t4 = n3.__k, i4 = 0; t4 && i4 < t4.length; i4++)
      t4[i4] && (t4[i4].__ = n3, l5 = S(t4[i4], l5, u4));
    return l5;
  }
  return n3.__e != l5 && (u4.insertBefore(n3.__e, l5 || null), l5 = n3.__e), l5 && l5.nextSibling;
}
function H(n3, l5, u4, t4) {
  var i4 = n3.key, o4 = n3.type, r4 = u4 - 1, f4 = u4 + 1, e4 = l5[u4];
  if (null === e4 || e4 && i4 == e4.key && o4 === e4.type)
    return u4;
  if (t4 > (null != e4 && 0 == (131072 & e4.__u) ? 1 : 0))
    for (; r4 >= 0 || f4 < l5.length; ) {
      if (r4 >= 0) {
        if ((e4 = l5[r4]) && 0 == (131072 & e4.__u) && i4 == e4.key && o4 === e4.type)
          return r4;
        r4--;
      }
      if (f4 < l5.length) {
        if ((e4 = l5[f4]) && 0 == (131072 & e4.__u) && i4 == e4.key && o4 === e4.type)
          return f4;
        f4++;
      }
    }
  return -1;
}
function I(n3, l5, u4) {
  "-" === l5[0] ? n3.setProperty(l5, null == u4 ? "" : u4) : n3[l5] = null == u4 ? "" : "number" != typeof u4 || a.test(l5) ? u4 : u4 + "px";
}
function T(n3, l5, u4, t4, i4) {
  var o4;
  n:
    if ("style" === l5)
      if ("string" == typeof u4)
        n3.style.cssText = u4;
      else {
        if ("string" == typeof t4 && (n3.style.cssText = t4 = ""), t4)
          for (l5 in t4)
            u4 && l5 in u4 || I(n3.style, l5, "");
        if (u4)
          for (l5 in u4)
            t4 && u4[l5] === t4[l5] || I(n3.style, l5, u4[l5]);
      }
    else if ("o" === l5[0] && "n" === l5[1])
      o4 = l5 !== (l5 = l5.replace(/(PointerCapture)$|Capture$/, "$1")), l5 = l5.toLowerCase() in n3 ? l5.toLowerCase().slice(2) : l5.slice(2), n3.l || (n3.l = {}), n3.l[l5 + o4] = u4, u4 ? t4 ? u4.u = t4.u : (u4.u = Date.now(), n3.addEventListener(l5, o4 ? D : A, o4)) : n3.removeEventListener(l5, o4 ? D : A, o4);
    else {
      if (i4)
        l5 = l5.replace(/xlink(H|:h)/, "h").replace(/sName$/, "s");
      else if ("width" !== l5 && "height" !== l5 && "href" !== l5 && "list" !== l5 && "form" !== l5 && "tabIndex" !== l5 && "download" !== l5 && "rowSpan" !== l5 && "colSpan" !== l5 && "role" !== l5 && l5 in n3)
        try {
          n3[l5] = null == u4 ? "" : u4;
          break n;
        } catch (n4) {
        }
      "function" == typeof u4 || (null == u4 || false === u4 && "-" !== l5[4] ? n3.removeAttribute(l5) : n3.setAttribute(l5, u4));
    }
}
function A(n3) {
  var u4 = this.l[n3.type + false];
  if (n3.t) {
    if (n3.t <= u4.u)
      return;
  } else
    n3.t = Date.now();
  return u4(l.event ? l.event(n3) : n3);
}
function D(n3) {
  return this.l[n3.type + true](l.event ? l.event(n3) : n3);
}
function L(n3, u4, t4, i4, o4, r4, f4, e4, c4, s4) {
  var a4, p5, y3, d5, _5, m3, k3, w4, x3, P2, S2, $, H2, I2, T3, A2 = u4.type;
  if (void 0 !== u4.constructor)
    return null;
  128 & t4.__u && (c4 = !!(32 & t4.__u), r4 = [e4 = u4.__e = t4.__e]), (a4 = l.__b) && a4(u4);
  n:
    if ("function" == typeof A2)
      try {
        if (w4 = u4.props, x3 = (a4 = A2.contextType) && i4[a4.__c], P2 = a4 ? x3 ? x3.props.value : a4.__ : i4, t4.__c ? k3 = (p5 = u4.__c = t4.__c).__ = p5.__E : ("prototype" in A2 && A2.prototype.render ? u4.__c = p5 = new A2(w4, P2) : (u4.__c = p5 = new b(w4, P2), p5.constructor = A2, p5.render = O), x3 && x3.sub(p5), p5.props = w4, p5.state || (p5.state = {}), p5.context = P2, p5.__n = i4, y3 = p5.__d = true, p5.__h = [], p5._sb = []), null == p5.__s && (p5.__s = p5.state), null != A2.getDerivedStateFromProps && (p5.__s == p5.state && (p5.__s = v({}, p5.__s)), v(p5.__s, A2.getDerivedStateFromProps(w4, p5.__s))), d5 = p5.props, _5 = p5.state, p5.__v = u4, y3)
          null == A2.getDerivedStateFromProps && null != p5.componentWillMount && p5.componentWillMount(), null != p5.componentDidMount && p5.__h.push(p5.componentDidMount);
        else {
          if (null == A2.getDerivedStateFromProps && w4 !== d5 && null != p5.componentWillReceiveProps && p5.componentWillReceiveProps(w4, P2), !p5.__e && (null != p5.shouldComponentUpdate && false === p5.shouldComponentUpdate(w4, p5.__s, P2) || u4.__v === t4.__v)) {
            for (u4.__v !== t4.__v && (p5.props = w4, p5.state = p5.__s, p5.__d = false), u4.__e = t4.__e, u4.__k = t4.__k, u4.__k.forEach(function(n4) {
              n4 && (n4.__ = u4);
            }), S2 = 0; S2 < p5._sb.length; S2++)
              p5.__h.push(p5._sb[S2]);
            p5._sb = [], p5.__h.length && f4.push(p5);
            break n;
          }
          null != p5.componentWillUpdate && p5.componentWillUpdate(w4, p5.__s, P2), null != p5.componentDidUpdate && p5.__h.push(function() {
            p5.componentDidUpdate(d5, _5, m3);
          });
        }
        if (p5.context = P2, p5.props = w4, p5.__P = n3, p5.__e = false, $ = l.__r, H2 = 0, "prototype" in A2 && A2.prototype.render) {
          for (p5.state = p5.__s, p5.__d = false, $ && $(u4), a4 = p5.render(p5.props, p5.state, p5.context), I2 = 0; I2 < p5._sb.length; I2++)
            p5.__h.push(p5._sb[I2]);
          p5._sb = [];
        } else
          do {
            p5.__d = false, $ && $(u4), a4 = p5.render(p5.props, p5.state, p5.context), p5.state = p5.__s;
          } while (p5.__d && ++H2 < 25);
        p5.state = p5.__s, null != p5.getChildContext && (i4 = v(v({}, i4), p5.getChildContext())), y3 || null == p5.getSnapshotBeforeUpdate || (m3 = p5.getSnapshotBeforeUpdate(d5, _5)), C(n3, h(T3 = null != a4 && a4.type === g && null == a4.key ? a4.props.children : a4) ? T3 : [T3], u4, t4, i4, o4, r4, f4, e4, c4, s4), p5.base = u4.__e, u4.__u &= -161, p5.__h.length && f4.push(p5), k3 && (p5.__E = p5.__ = null);
      } catch (n4) {
        u4.__v = null, c4 || null != r4 ? (u4.__e = e4, u4.__u |= c4 ? 160 : 32, r4[r4.indexOf(e4)] = null) : (u4.__e = t4.__e, u4.__k = t4.__k), l.__e(n4, u4, t4);
      }
    else
      null == r4 && u4.__v === t4.__v ? (u4.__k = t4.__k, u4.__e = t4.__e) : u4.__e = j(t4.__e, u4, t4, i4, o4, r4, f4, c4, s4);
  (a4 = l.diffed) && a4(u4);
}
function M(n3, u4, t4) {
  u4.__d = void 0;
  for (var i4 = 0; i4 < t4.length; i4++)
    z(t4[i4], t4[++i4], t4[++i4]);
  l.__c && l.__c(u4, n3), n3.some(function(u5) {
    try {
      n3 = u5.__h, u5.__h = [], n3.some(function(n4) {
        n4.call(u5);
      });
    } catch (n4) {
      l.__e(n4, u5.__v);
    }
  });
}
function j(l5, u4, t4, i4, o4, r4, f4, e4, s4) {
  var a4, v5, y3, d5, _5, g4, b4, k3 = t4.props, w4 = u4.props, x3 = u4.type;
  if ("svg" === x3 && (o4 = true), null != r4) {
    for (a4 = 0; a4 < r4.length; a4++)
      if ((_5 = r4[a4]) && "setAttribute" in _5 == !!x3 && (x3 ? _5.localName === x3 : 3 === _5.nodeType)) {
        l5 = _5, r4[a4] = null;
        break;
      }
  }
  if (null == l5) {
    if (null === x3)
      return document.createTextNode(w4);
    l5 = o4 ? document.createElementNS("http://www.w3.org/2000/svg", x3) : document.createElement(x3, w4.is && w4), r4 = null, e4 = false;
  }
  if (null === x3)
    k3 === w4 || e4 && l5.data === w4 || (l5.data = w4);
  else {
    if (r4 = r4 && n.call(l5.childNodes), k3 = t4.props || c, !e4 && null != r4)
      for (k3 = {}, a4 = 0; a4 < l5.attributes.length; a4++)
        k3[(_5 = l5.attributes[a4]).name] = _5.value;
    for (a4 in k3)
      _5 = k3[a4], "children" == a4 || ("dangerouslySetInnerHTML" == a4 ? y3 = _5 : "key" === a4 || a4 in w4 || T(l5, a4, null, _5, o4));
    for (a4 in w4)
      _5 = w4[a4], "children" == a4 ? d5 = _5 : "dangerouslySetInnerHTML" == a4 ? v5 = _5 : "value" == a4 ? g4 = _5 : "checked" == a4 ? b4 = _5 : "key" === a4 || e4 && "function" != typeof _5 || k3[a4] === _5 || T(l5, a4, _5, k3[a4], o4);
    if (v5)
      e4 || y3 && (v5.__html === y3.__html || v5.__html === l5.innerHTML) || (l5.innerHTML = v5.__html), u4.__k = [];
    else if (y3 && (l5.innerHTML = ""), C(l5, h(d5) ? d5 : [d5], u4, t4, i4, o4 && "foreignObject" !== x3, r4, f4, r4 ? r4[0] : t4.__k && m(t4, 0), e4, s4), null != r4)
      for (a4 = r4.length; a4--; )
        null != r4[a4] && p(r4[a4]);
    e4 || (a4 = "value", void 0 !== g4 && (g4 !== l5[a4] || "progress" === x3 && !g4 || "option" === x3 && g4 !== k3[a4]) && T(l5, a4, g4, k3[a4], false), a4 = "checked", void 0 !== b4 && b4 !== l5[a4] && T(l5, a4, b4, k3[a4], false));
  }
  return l5;
}
function z(n3, u4, t4) {
  try {
    "function" == typeof n3 ? n3(u4) : n3.current = u4;
  } catch (n4) {
    l.__e(n4, t4);
  }
}
function N(n3, u4, t4) {
  var i4, o4;
  if (l.unmount && l.unmount(n3), (i4 = n3.ref) && (i4.current && i4.current !== n3.__e || z(i4, null, u4)), null != (i4 = n3.__c)) {
    if (i4.componentWillUnmount)
      try {
        i4.componentWillUnmount();
      } catch (n4) {
        l.__e(n4, u4);
      }
    i4.base = i4.__P = null, n3.__c = void 0;
  }
  if (i4 = n3.__k)
    for (o4 = 0; o4 < i4.length; o4++)
      i4[o4] && N(i4[o4], u4, t4 || "function" != typeof n3.type);
  t4 || null == n3.__e || p(n3.__e), n3.__ = n3.__e = n3.__d = void 0;
}
function O(n3, l5, u4) {
  return this.constructor(n3, u4);
}
function q(u4, t4, i4) {
  var o4, r4, f4, e4;
  l.__ && l.__(u4, t4), r4 = (o4 = "function" == typeof i4) ? null : i4 && i4.__k || t4.__k, f4 = [], e4 = [], L(t4, u4 = (!o4 && i4 || t4).__k = y(g, null, [u4]), r4 || c, c, void 0 !== t4.ownerSVGElement, !o4 && i4 ? [i4] : r4 ? null : t4.firstChild ? n.call(t4.childNodes) : null, f4, !o4 && i4 ? i4 : r4 ? r4.__e : t4.firstChild, o4, e4), M(f4, u4, e4);
}
function F(n3, l5) {
  var u4 = { __c: l5 = "__cC" + e++, __: n3, Consumer: function(n4, l6) {
    return n4.children(l6);
  }, Provider: function(n4) {
    var u5, t4;
    return this.getChildContext || (u5 = [], (t4 = {})[l5] = this, this.getChildContext = function() {
      return t4;
    }, this.shouldComponentUpdate = function(n5) {
      this.props.value !== n5.value && u5.some(function(n6) {
        n6.__e = true, w(n6);
      });
    }, this.sub = function(n5) {
      u5.push(n5);
      var l6 = n5.componentWillUnmount;
      n5.componentWillUnmount = function() {
        u5.splice(u5.indexOf(n5), 1), l6 && l6.call(n5);
      };
    }), n4.children;
  } };
  return u4.Provider.__ = u4.Consumer.contextType = u4;
}
n = s.slice, l = { __e: function(n3, l5, u4, t4) {
  for (var i4, o4, r4; l5 = l5.__; )
    if ((i4 = l5.__c) && !i4.__)
      try {
        if ((o4 = i4.constructor) && null != o4.getDerivedStateFromError && (i4.setState(o4.getDerivedStateFromError(n3)), r4 = i4.__d), null != i4.componentDidCatch && (i4.componentDidCatch(n3, t4 || {}), r4 = i4.__d), r4)
          return i4.__E = i4;
      } catch (l6) {
        n3 = l6;
      }
  throw n3;
} }, u = 0, t = function(n3) {
  return null != n3 && null == n3.constructor;
}, b.prototype.setState = function(n3, l5) {
  var u4;
  u4 = null != this.__s && this.__s !== this.state ? this.__s : this.__s = v({}, this.state), "function" == typeof n3 && (n3 = n3(v({}, u4), this.props)), n3 && v(u4, n3), null != n3 && this.__v && (l5 && this._sb.push(l5), w(this));
}, b.prototype.forceUpdate = function(n3) {
  this.__v && (this.__e = true, n3 && this.__h.push(n3), w(this));
}, b.prototype.render = g, i = [], r = "function" == typeof Promise ? Promise.prototype.then.bind(Promise.resolve()) : setTimeout, f = function(n3, l5) {
  return n3.__v.__b - l5.__v.__b;
}, x.__r = 0, e = 0;

// node_modules/preact/hooks/dist/hooks.module.js
var t2;
var r2;
var u2;
var i2;
var o2 = 0;
var f2 = [];
var c2 = [];
var e2 = l.__b;
var a2 = l.__r;
var v2 = l.diffed;
var l2 = l.__c;
var m2 = l.unmount;
function d2(t4, u4) {
  l.__h && l.__h(r2, t4, o2 || u4), o2 = 0;
  var i4 = r2.__H || (r2.__H = { __: [], __h: [] });
  return t4 >= i4.__.length && i4.__.push({ __V: c2 }), i4.__[t4];
}
function p2(u4, i4) {
  var o4 = d2(t2++, 3);
  !l.__s && z2(o4.__H, i4) && (o4.__ = u4, o4.i = i4, r2.__H.__h.push(o4));
}
function _(n3) {
  return o2 = 5, F2(function() {
    return { current: n3 };
  }, []);
}
function F2(n3, r4) {
  var u4 = d2(t2++, 7);
  return z2(u4.__H, r4) ? (u4.__V = n3(), u4.i = r4, u4.__h = n3, u4.__V) : u4.__;
}
function T2(n3, t4) {
  return o2 = 8, F2(function() {
    return n3;
  }, t4);
}
function q2(n3) {
  var u4 = r2.context[n3.__c], i4 = d2(t2++, 9);
  return i4.c = n3, u4 ? (null == i4.__ && (i4.__ = true, u4.sub(r2)), u4.props.value) : n3.__;
}
function b2() {
  for (var t4; t4 = f2.shift(); )
    if (t4.__P && t4.__H)
      try {
        t4.__H.__h.forEach(k2), t4.__H.__h.forEach(w2), t4.__H.__h = [];
      } catch (r4) {
        t4.__H.__h = [], l.__e(r4, t4.__v);
      }
}
l.__b = function(n3) {
  r2 = null, e2 && e2(n3);
}, l.__r = function(n3) {
  a2 && a2(n3), t2 = 0;
  var i4 = (r2 = n3.__c).__H;
  i4 && (u2 === r2 ? (i4.__h = [], r2.__h = [], i4.__.forEach(function(n4) {
    n4.__N && (n4.__ = n4.__N), n4.__V = c2, n4.__N = n4.i = void 0;
  })) : (i4.__h.forEach(k2), i4.__h.forEach(w2), i4.__h = [], t2 = 0)), u2 = r2;
}, l.diffed = function(t4) {
  v2 && v2(t4);
  var o4 = t4.__c;
  o4 && o4.__H && (o4.__H.__h.length && (1 !== f2.push(o4) && i2 === l.requestAnimationFrame || ((i2 = l.requestAnimationFrame) || j2)(b2)), o4.__H.__.forEach(function(n3) {
    n3.i && (n3.__H = n3.i), n3.__V !== c2 && (n3.__ = n3.__V), n3.i = void 0, n3.__V = c2;
  })), u2 = r2 = null;
}, l.__c = function(t4, r4) {
  r4.some(function(t5) {
    try {
      t5.__h.forEach(k2), t5.__h = t5.__h.filter(function(n3) {
        return !n3.__ || w2(n3);
      });
    } catch (u4) {
      r4.some(function(n3) {
        n3.__h && (n3.__h = []);
      }), r4 = [], l.__e(u4, t5.__v);
    }
  }), l2 && l2(t4, r4);
}, l.unmount = function(t4) {
  m2 && m2(t4);
  var r4, u4 = t4.__c;
  u4 && u4.__H && (u4.__H.__.forEach(function(n3) {
    try {
      k2(n3);
    } catch (n4) {
      r4 = n4;
    }
  }), u4.__H = void 0, r4 && l.__e(r4, u4.__v));
};
var g2 = "function" == typeof requestAnimationFrame;
function j2(n3) {
  var t4, r4 = function() {
    clearTimeout(u4), g2 && cancelAnimationFrame(t4), setTimeout(n3);
  }, u4 = setTimeout(r4, 100);
  g2 && (t4 = requestAnimationFrame(r4));
}
function k2(n3) {
  var t4 = r2, u4 = n3.__c;
  "function" == typeof u4 && (n3.__c = void 0, u4()), r2 = t4;
}
function w2(n3) {
  var t4 = r2;
  n3.__c = n3.__(), r2 = t4;
}
function z2(n3, t4) {
  return !n3 || n3.length !== t4.length || t4.some(function(t5, r4) {
    return t5 !== n3[r4];
  });
}

// node_modules/@preact/signals-core/dist/signals-core.module.js
function i3() {
  throw new Error("Cycle detected");
}
var t3 = Symbol.for("preact-signals");
function r3() {
  if (!(v3 > 1)) {
    var i4, t4 = false;
    while (void 0 !== f3) {
      var r4 = f3;
      f3 = void 0;
      e3++;
      while (void 0 !== r4) {
        var n3 = r4.o;
        r4.o = void 0;
        r4.f &= -3;
        if (!(8 & r4.f) && l3(r4))
          try {
            r4.c();
          } catch (r5) {
            if (!t4) {
              i4 = r5;
              t4 = true;
            }
          }
        r4 = n3;
      }
    }
    e3 = 0;
    v3--;
    if (t4)
      throw i4;
  } else
    v3--;
}
function n2(i4) {
  if (v3 > 0)
    return i4();
  v3++;
  try {
    return i4();
  } finally {
    r3();
  }
}
var o3 = void 0;
var h2 = 0;
function s2(i4) {
  if (h2 > 0)
    return i4();
  var t4 = o3;
  o3 = void 0;
  h2++;
  try {
    return i4();
  } finally {
    h2--;
    o3 = t4;
  }
}
var f3 = void 0;
var v3 = 0;
var e3 = 0;
var u3 = 0;
function c3(i4) {
  if (void 0 !== o3) {
    var t4 = i4.n;
    if (void 0 === t4 || t4.t !== o3) {
      t4 = { i: 0, S: i4, p: o3.s, n: void 0, t: o3, e: void 0, x: void 0, r: t4 };
      if (void 0 !== o3.s)
        o3.s.n = t4;
      o3.s = t4;
      i4.n = t4;
      if (32 & o3.f)
        i4.S(t4);
      return t4;
    } else if (-1 === t4.i) {
      t4.i = 0;
      if (void 0 !== t4.n) {
        t4.n.p = t4.p;
        if (void 0 !== t4.p)
          t4.p.n = t4.n;
        t4.p = o3.s;
        t4.n = void 0;
        o3.s.n = t4;
        o3.s = t4;
      }
      return t4;
    }
  }
}
function d3(i4) {
  this.v = i4;
  this.i = 0;
  this.n = void 0;
  this.t = void 0;
}
d3.prototype.brand = t3;
d3.prototype.h = function() {
  return true;
};
d3.prototype.S = function(i4) {
  if (this.t !== i4 && void 0 === i4.e) {
    i4.x = this.t;
    if (void 0 !== this.t)
      this.t.e = i4;
    this.t = i4;
  }
};
d3.prototype.U = function(i4) {
  if (void 0 !== this.t) {
    var t4 = i4.e, r4 = i4.x;
    if (void 0 !== t4) {
      t4.x = r4;
      i4.e = void 0;
    }
    if (void 0 !== r4) {
      r4.e = t4;
      i4.x = void 0;
    }
    if (i4 === this.t)
      this.t = r4;
  }
};
d3.prototype.subscribe = function(i4) {
  var t4 = this;
  return O2(function() {
    var r4 = t4.value, n3 = 32 & this.f;
    this.f &= -33;
    try {
      i4(r4);
    } finally {
      this.f |= n3;
    }
  });
};
d3.prototype.valueOf = function() {
  return this.value;
};
d3.prototype.toString = function() {
  return this.value + "";
};
d3.prototype.toJSON = function() {
  return this.value;
};
d3.prototype.peek = function() {
  return this.v;
};
Object.defineProperty(d3.prototype, "value", { get: function() {
  var i4 = c3(this);
  if (void 0 !== i4)
    i4.i = this.i;
  return this.v;
}, set: function(t4) {
  if (o3 instanceof _2)
    !function() {
      throw new Error("Computed cannot have side-effects");
    }();
  if (t4 !== this.v) {
    if (e3 > 100)
      i3();
    this.v = t4;
    this.i++;
    u3++;
    v3++;
    try {
      for (var n3 = this.t; void 0 !== n3; n3 = n3.x)
        n3.t.N();
    } finally {
      r3();
    }
  }
} });
function a3(i4) {
  return new d3(i4);
}
function l3(i4) {
  for (var t4 = i4.s; void 0 !== t4; t4 = t4.n)
    if (t4.S.i !== t4.i || !t4.S.h() || t4.S.i !== t4.i)
      return true;
  return false;
}
function y2(i4) {
  for (var t4 = i4.s; void 0 !== t4; t4 = t4.n) {
    var r4 = t4.S.n;
    if (void 0 !== r4)
      t4.r = r4;
    t4.S.n = t4;
    t4.i = -1;
    if (void 0 === t4.n) {
      i4.s = t4;
      break;
    }
  }
}
function w3(i4) {
  var t4 = i4.s, r4 = void 0;
  while (void 0 !== t4) {
    var n3 = t4.p;
    if (-1 === t4.i) {
      t4.S.U(t4);
      if (void 0 !== n3)
        n3.n = t4.n;
      if (void 0 !== t4.n)
        t4.n.p = n3;
    } else
      r4 = t4;
    t4.S.n = t4.r;
    if (void 0 !== t4.r)
      t4.r = void 0;
    t4 = n3;
  }
  i4.s = r4;
}
function _2(i4) {
  d3.call(this, void 0);
  this.x = i4;
  this.s = void 0;
  this.g = u3 - 1;
  this.f = 4;
}
(_2.prototype = new d3()).h = function() {
  this.f &= -3;
  if (1 & this.f)
    return false;
  if (32 == (36 & this.f))
    return true;
  this.f &= -5;
  if (this.g === u3)
    return true;
  this.g = u3;
  this.f |= 1;
  if (this.i > 0 && !l3(this)) {
    this.f &= -2;
    return true;
  }
  var i4 = o3;
  try {
    y2(this);
    o3 = this;
    var t4 = this.x();
    if (16 & this.f || this.v !== t4 || 0 === this.i) {
      this.v = t4;
      this.f &= -17;
      this.i++;
    }
  } catch (i5) {
    this.v = i5;
    this.f |= 16;
    this.i++;
  }
  o3 = i4;
  w3(this);
  this.f &= -2;
  return true;
};
_2.prototype.S = function(i4) {
  if (void 0 === this.t) {
    this.f |= 36;
    for (var t4 = this.s; void 0 !== t4; t4 = t4.n)
      t4.S.S(t4);
  }
  d3.prototype.S.call(this, i4);
};
_2.prototype.U = function(i4) {
  if (void 0 !== this.t) {
    d3.prototype.U.call(this, i4);
    if (void 0 === this.t) {
      this.f &= -33;
      for (var t4 = this.s; void 0 !== t4; t4 = t4.n)
        t4.S.U(t4);
    }
  }
};
_2.prototype.N = function() {
  if (!(2 & this.f)) {
    this.f |= 6;
    for (var i4 = this.t; void 0 !== i4; i4 = i4.x)
      i4.t.N();
  }
};
_2.prototype.peek = function() {
  if (!this.h())
    i3();
  if (16 & this.f)
    throw this.v;
  return this.v;
};
Object.defineProperty(_2.prototype, "value", { get: function() {
  if (1 & this.f)
    i3();
  var t4 = c3(this);
  this.h();
  if (void 0 !== t4)
    t4.i = this.i;
  if (16 & this.f)
    throw this.v;
  return this.v;
} });
function p3(i4) {
  return new _2(i4);
}
function g3(i4) {
  var t4 = i4.u;
  i4.u = void 0;
  if ("function" == typeof t4) {
    v3++;
    var n3 = o3;
    o3 = void 0;
    try {
      t4();
    } catch (t5) {
      i4.f &= -2;
      i4.f |= 8;
      b3(i4);
      throw t5;
    } finally {
      o3 = n3;
      r3();
    }
  }
}
function b3(i4) {
  for (var t4 = i4.s; void 0 !== t4; t4 = t4.n)
    t4.S.U(t4);
  i4.x = void 0;
  i4.s = void 0;
  g3(i4);
}
function x2(i4) {
  if (o3 !== this)
    throw new Error("Out-of-order effect");
  w3(this);
  o3 = i4;
  this.f &= -2;
  if (8 & this.f)
    b3(this);
  r3();
}
function E(i4) {
  this.x = i4;
  this.u = void 0;
  this.s = void 0;
  this.o = void 0;
  this.f = 32;
}
E.prototype.c = function() {
  var i4 = this.S();
  try {
    if (8 & this.f)
      return;
    if (void 0 === this.x)
      return;
    var t4 = this.x();
    if ("function" == typeof t4)
      this.u = t4;
  } finally {
    i4();
  }
};
E.prototype.S = function() {
  if (1 & this.f)
    i3();
  this.f |= 1;
  this.f &= -9;
  g3(this);
  y2(this);
  v3++;
  var t4 = o3;
  o3 = this;
  return x2.bind(this, t4);
};
E.prototype.N = function() {
  if (!(2 & this.f)) {
    this.f |= 2;
    this.o = f3;
    f3 = this;
  }
};
E.prototype.d = function() {
  this.f |= 8;
  if (!(1 & this.f))
    b3(this);
};
function O2(i4) {
  var t4 = new E(i4);
  try {
    t4.c();
  } catch (i5) {
    t4.d();
    throw i5;
  }
  return t4.d.bind(t4);
}

// node_modules/@preact/signals/dist/signals.module.js
var v4;
var s3;
function l4(n3, i4) {
  l[n3] = i4.bind(null, l[n3] || function() {
  });
}
function d4(n3) {
  if (s3)
    s3();
  s3 = n3 && n3.S();
}
function p4(n3) {
  var r4 = this, f4 = n3.data, o4 = useSignal(f4);
  o4.value = f4;
  var e4 = F2(function() {
    var n4 = r4.__v;
    while (n4 = n4.__)
      if (n4.__c) {
        n4.__c.__$f |= 4;
        break;
      }
    r4.__$u.c = function() {
      var n5;
      if (!t(e4.peek()) && 3 === (null == (n5 = r4.base) ? void 0 : n5.nodeType))
        r4.base.data = e4.peek();
      else {
        r4.__$f |= 1;
        r4.setState({});
      }
    };
    return p3(function() {
      var n5 = o4.value.value;
      return 0 === n5 ? 0 : true === n5 ? "" : n5 || "";
    });
  }, []);
  return e4.value;
}
p4.displayName = "_st";
Object.defineProperties(d3.prototype, { constructor: { configurable: true, value: void 0 }, type: { configurable: true, value: p4 }, props: { configurable: true, get: function() {
  return { data: this };
} }, __b: { configurable: true, value: 1 } });
l4("__b", function(n3, r4) {
  if ("string" == typeof r4.type) {
    var i4, t4 = r4.props;
    for (var f4 in t4)
      if ("children" !== f4) {
        var o4 = t4[f4];
        if (o4 instanceof d3) {
          if (!i4)
            r4.__np = i4 = {};
          i4[f4] = o4;
          t4[f4] = o4.peek();
        }
      }
  }
  n3(r4);
});
l4("__r", function(n3, r4) {
  d4();
  var i4, t4 = r4.__c;
  if (t4) {
    t4.__$f &= -2;
    if (void 0 === (i4 = t4.__$u))
      t4.__$u = i4 = function(n4) {
        var r5;
        O2(function() {
          r5 = this;
        });
        r5.c = function() {
          t4.__$f |= 1;
          t4.setState({});
        };
        return r5;
      }();
  }
  v4 = t4;
  d4(i4);
  n3(r4);
});
l4("__e", function(n3, r4, i4, t4) {
  d4();
  v4 = void 0;
  n3(r4, i4, t4);
});
l4("diffed", function(n3, r4) {
  d4();
  v4 = void 0;
  var i4;
  if ("string" == typeof r4.type && (i4 = r4.__e)) {
    var t4 = r4.__np, f4 = r4.props;
    if (t4) {
      var o4 = i4.U;
      if (o4)
        for (var e4 in o4) {
          var u4 = o4[e4];
          if (void 0 !== u4 && !(e4 in t4)) {
            u4.d();
            o4[e4] = void 0;
          }
        }
      else
        i4.U = o4 = {};
      for (var a4 in t4) {
        var c4 = o4[a4], s4 = t4[a4];
        if (void 0 === c4) {
          c4 = _3(i4, a4, s4, f4);
          o4[a4] = c4;
        } else
          c4.o(s4, f4);
      }
    }
  }
  n3(r4);
});
function _3(n3, r4, i4, t4) {
  var f4 = r4 in n3 && void 0 === n3.ownerSVGElement, o4 = a3(i4);
  return { o: function(n4, r5) {
    o4.value = n4;
    t4 = r5;
  }, d: O2(function() {
    var i5 = o4.value.value;
    if (t4[r4] !== i5) {
      t4[r4] = i5;
      if (f4)
        n3[r4] = i5;
      else if (i5)
        n3.setAttribute(r4, i5);
      else
        n3.removeAttribute(r4);
    }
  }) };
}
l4("unmount", function(n3, r4) {
  if ("string" == typeof r4.type) {
    var i4 = r4.__e;
    if (i4) {
      var t4 = i4.U;
      if (t4) {
        i4.U = void 0;
        for (var f4 in t4) {
          var o4 = t4[f4];
          if (o4)
            o4.d();
        }
      }
    }
  } else {
    var e4 = r4.__c;
    if (e4) {
      var u4 = e4.__$u;
      if (u4) {
        e4.__$u = void 0;
        u4.d();
      }
    }
  }
  n3(r4);
});
l4("__h", function(n3, r4, i4, t4) {
  if (t4 < 3 || 9 === t4)
    r4.__$f |= 2;
  n3(r4, i4, t4);
});
b.prototype.shouldComponentUpdate = function(n3, r4) {
  var i4 = this.__$u;
  if (!(i4 && void 0 !== i4.s || 4 & this.__$f))
    return true;
  if (3 & this.__$f)
    return true;
  for (var t4 in r4)
    return true;
  for (var f4 in n3)
    if ("__source" !== f4 && n3[f4] !== this.props[f4])
      return true;
  for (var o4 in this.props)
    if (!(o4 in n3))
      return true;
  return false;
};
function useSignal(n3) {
  return F2(function() {
    return a3(n3);
  }, []);
}
function useSignalEffect(n3) {
  var r4 = _(n3);
  r4.current = n3;
  p2(function() {
    return O2(function() {
      return r4.current();
    });
  }, []);
}

// src/symbols.js
var Equals = Symbol("Equals");
var Name = Symbol("Name");

// src/equality.js
if (typeof Node === "undefined") {
  self.Node = class {
  };
}
Boolean.prototype[Equals] = Symbol.prototype[Equals] = Number.prototype[Equals] = String.prototype[Equals] = function(other) {
  return this.valueOf() === other;
};
Date.prototype[Equals] = function(other) {
  return +this === +other;
};
Function.prototype[Equals] = Node.prototype[Equals] = function(other) {
  return this === other;
};
URLSearchParams.prototype[Equals] = function(other) {
  if (other === null || other === void 0) {
    return false;
  }
  return this.toString() === other.toString();
};
Set.prototype[Equals] = function(other) {
  if (other === null || other === void 0) {
    return false;
  }
  return compare(Array.from(this).sort(), Array.from(other).sort());
};
Array.prototype[Equals] = function(other) {
  if (other === null || other === void 0) {
    return false;
  }
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
  if (other === null || other === void 0) {
    return false;
  }
  const bKeys = Array.from(other.keys()).sort();
  const aKeys = Array.from(this.keys()).sort();
  if (compare(aKeys, bKeys)) {
    if (aKeys.length == 0) {
      return true;
    }
    for (let key of aKeys) {
      const bValue = Array.from(other.getAll(key).sort());
      const aValue = Array.from(this.getAll(key).sort());
      if (!compare(aValue, bValue)) {
        return false;
      }
    }
    return true;
  } else {
    return false;
  }
};
Map.prototype[Equals] = function(other) {
  if (other === null || other === void 0) {
    return false;
  }
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
var isVnode = (object) => object !== void 0 && object !== null && typeof object == "object" && "constructor" in object && "props" in object && "type" in object && "ref" in object && "key" in object && "__" in object;
var compare = (a4, b4) => {
  if (a4 === void 0 && b4 === void 0 || a4 === null && b4 === null) {
    return true;
  } else if (a4 != null && a4 != void 0 && a4[Equals]) {
    return a4[Equals](b4);
  } else if (b4 != null && b4 != void 0 && b4[Equals]) {
    return b4[Equals](a4);
  } else if (isVnode(a4) || isVnode(b4) || a4 instanceof d3 || b4 instanceof d3) {
    return a4 === b4;
  } else {
    return compareObjects(a4, b4);
  }
};
var compareObjects = (a4, b4) => {
  if (a4 instanceof Object && b4 instanceof Object) {
    const aKeys = Object.keys(a4);
    const bKeys = Object.keys(b4);
    if (aKeys.length !== bKeys.length) {
      return false;
    }
    const keys2 = new Set(aKeys.concat(bKeys));
    for (let key of keys2) {
      if (!compare(a4[key], b4[key])) {
        return false;
      }
    }
    return true;
  } else {
    return a4 === b4;
  }
};

// src/testing.js
var TestContext = class {
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
};
var TestRunner = class {
  constructor(suites, globals, url, id) {
    this.root = document.createElement("div");
    document.body.appendChild(this.root);
    this.socket = new WebSocket(url);
    this.globals = globals;
    this.suites = suites;
    this.url = url;
    this.id = id;
    window.DEBUG = {
      log: (value) => {
        let result = "";
        if (value === void 0) {
          result = "undefined";
        } else if (value === null) {
          result = "null";
        } else {
          result = value.toString();
        }
        this.log(result);
      }
    };
    let error = null;
    window.onerror = (message) => {
      if (this.socket.readyState === 1) {
        this.crash(message);
      } else {
        error = error || message;
      }
    };
    this.socket.onopen = () => {
      if (error != null) {
        this.crash(error);
      }
    };
    this.start();
  }
  renderGlobals() {
    const components = [];
    for (let key in this.globals) {
      components.push(y(this.globals[key], { key }));
    }
    q(components, this.root);
  }
  start() {
    if (this.socket.readyState === 1) {
      this.run();
    } else {
      this.socket.addEventListener("open", () => this.run());
    }
  }
  run() {
    return new Promise((resolve, reject) => {
      this.next(resolve, reject);
    }).catch((e4) => this.log(e4.reason)).finally(() => this.socket.send("DONE"));
  }
  report(type, suite, name, message, location) {
    if (message && message.toString) {
      message = message.toString();
    }
    this.socket.send(
      JSON.stringify({
        location,
        result: message,
        suite,
        id: this.id,
        type,
        name
      })
    );
  }
  reportTested(test, type, message) {
    this.report(type, this.suite.name, test.name, message, test.location);
  }
  crash(message) {
    this.report("CRASHED", null, null, message);
  }
  log(message) {
    this.report("LOG", null, null, message);
  }
  cleanSlate() {
    return new Promise((resolve) => {
      q(null, this.root);
      if (window.location.pathname !== "/") {
        window.history.replaceState({}, "", "/");
      }
      sessionStorage.clear();
      localStorage.clear();
      requestAnimationFrame(() => {
        this.renderGlobals();
        requestAnimationFrame(resolve);
      });
    });
  }
  next(resolve) {
    requestAnimationFrame(async () => {
      if (!this.suite || this.suite.tests.length === 0) {
        this.suite = this.suites.shift();
        if (this.suite) {
          this.report("SUITE", this.suite.name);
        } else {
          return resolve();
        }
      }
      const test = this.suite.tests.shift();
      try {
        await this.cleanSlate();
        const result = await test.proc();
        if (result instanceof TestContext) {
          try {
            await result.run();
            this.reportTested(test, "SUCCEEDED", result.subject);
          } catch (error) {
            this.reportTested(test, "FAILED", error);
          }
        } else {
          if (result) {
            this.reportTested(test, "SUCCEEDED");
          } else {
            this.reportTested(test, "FAILED");
          }
        }
      } catch (error) {
        this.reportTested(test, "ERRORED", error);
      }
      this.next(resolve);
    });
  }
};
var testOperation = (left, right, operator) => {
  return new TestContext(left).step((subject) => {
    let result = compare(subject, right);
    if (operator === "==") {
      result = !result;
    }
    if (result) {
      throw `Assertion failed: ${right} ${operator} ${subject}`;
    }
    return true;
  });
};
var testContext = TestContext;
var testRunner = TestRunner;

// src/pattern_matching.js
var Pattern = class {
  constructor(variant2, pattern2) {
    this.pattern = pattern2;
    this.variant = variant2;
  }
};
var PatternRecord = class {
  constructor(patterns) {
    this.patterns = patterns;
  }
};
var PatternMany = class {
  constructor(patterns) {
    this.patterns = patterns;
  }
};
var pattern = (variant2, pattern2) => new Pattern(variant2, pattern2);
var patternRecord = (patterns) => new PatternRecord(patterns);
var patternMany = (patterns) => new PatternMany(patterns);
var patternVariable = Symbol("Variable");
var patternSpread = Symbol("Spread");
var destructure = (value, pattern2, values = []) => {
  if (pattern2 === null) {
  } else if (pattern2 === patternVariable) {
    values.push(value);
  } else if (Array.isArray(pattern2)) {
    const hasSpread = pattern2.some((item) => item === patternSpread);
    if (hasSpread && value.length >= pattern2.length - 1) {
      let startIndex = 0;
      let endValues = [];
      let endIndex = 1;
      while (pattern2[startIndex] !== patternSpread && startIndex < pattern2.length) {
        if (!destructure(value[startIndex], pattern2[startIndex], values)) {
          return false;
        }
        startIndex++;
      }
      while (pattern2[pattern2.length - endIndex] !== patternSpread && endIndex < pattern2.length) {
        if (!destructure(
          value[value.length - endIndex],
          pattern2[pattern2.length - endIndex],
          endValues
        )) {
          return false;
        }
        endIndex++;
      }
      values.push(value.slice(startIndex, value.length - (endIndex - 1)));
      for (let item of endValues) {
        values.push(item);
      }
    } else {
      if (pattern2.length !== value.length) {
        return false;
      } else {
        for (let index in pattern2) {
          if (!destructure(value[index], pattern2[index], values)) {
            return false;
          }
        }
      }
    }
  } else if (pattern2 instanceof Pattern) {
    if (value instanceof pattern2.variant) {
      for (let index in pattern2.pattern) {
        if (!destructure(value[`_${index}`], pattern2.pattern[index], values)) {
          return false;
        }
      }
    } else {
      return false;
    }
  } else if (pattern2 instanceof PatternRecord) {
    for (let key in pattern2.patterns) {
      if (!destructure(value[key], pattern2.patterns[key], values)) {
        return false;
      }
    }
  } else if (pattern2 instanceof PatternMany) {
    for (let item of pattern2.patterns) {
      if (destructure(value, item, values)) {
        return values;
      }
    }
    return false;
  } else {
    if (!compare(value, pattern2)) {
      return false;
    }
  }
  return values;
};
var match = (value, branches) => {
  for (let branch of branches) {
    if (branch[0] === null) {
      return branch[1]();
    } else {
      const values = destructure(value, branch[0]);
      if (values) {
        return branch[1].apply(null, values);
      }
    }
  }
};

// src/normalize_event.js
if (!("DataTransfer" in window)) {
  window.DataTransfer = class {
    constructor() {
      this.effectAllowed = "none";
      this.dropEffect = "none";
      this.files = [];
      this.types = [];
      this.cache = {};
    }
    getData(format2) {
      return this.cache[format2] || "";
    }
    setData(format2, data) {
      this.cache[format2] = data;
      return null;
    }
    clearData() {
      this.cache = {};
      return null;
    }
  };
}
var normalizeEvent = (event) => {
  return new Proxy(event, {
    get: function(obj, prop) {
      if (prop === "event") {
        return event;
      } else if (prop in obj) {
        const value = obj[prop];
        if (value instanceof Function) {
          return () => obj[prop]();
        } else {
          return value;
        }
      } else {
        switch (prop) {
          case "clipboardData":
            return obj.clipboardData = new DataTransfer();
          case "dataTransfer":
            return obj.dataTransfer = new DataTransfer();
          case "data":
            return "";
          case "altKey":
            return false;
          case "charCode":
            return 0;
          case "ctrlKey":
            return false;
          case "key":
            return "";
          case "keyCode":
            return 0;
          case "locale":
            return "";
          case "location":
            return 0;
          case "metaKey":
            return false;
          case "repeat":
            return false;
          case "shiftKey":
            return false;
          case "which":
            return 0;
          case "button":
            return -1;
          case "buttons":
            return 0;
          case "clientX":
            return 0;
          case "clientY":
            return 0;
          case "pageX":
            return 0;
          case "pageY":
            return 0;
          case "screenX":
            return 0;
          case "screenY":
            return 0;
          case "layerX":
            return 0;
          case "layerY":
            return 0;
          case "offsetX":
            return 0;
          case "offsetY":
            return 0;
          case "detail":
            return 0;
          case "deltaMode":
            return -1;
          case "deltaX":
            return 0;
          case "deltaY":
            return 0;
          case "deltaZ":
            return 0;
          case "animationName":
            return "";
          case "pseudoElement":
            return "";
          case "elapsedTime":
            return 0;
          case "propertyName":
            return "";
          default:
            return void 0;
        }
      }
    }
  });
};
l.event = normalizeEvent;

// src/utilities.js
var mapAccess = (map, key, just, nothing) => {
  for (const item of map) {
    if (compare(item[0], key)) {
      return new just(item[1]);
    }
  }
  return new nothing();
};
var bracketAccess = (array, index, just, nothing) => {
  if (array.length >= index + 1 && index >= 0) {
    return new just(array[index]);
  } else {
    return new nothing();
  }
};
var setTestRef = (signal, just, nothing) => (element) => {
  let current;
  if (element === null) {
    current = new nothing();
  } else {
    current = new just(element);
  }
  if (signal) {
    if (!compare(signal.peek(), current)) {
      signal.value = current;
    }
  }
};
var setRef = (signal, just, nothing) => {
  return T2((element) => {
    setTestRef(signal, just, nothing)(element);
  }, []);
};
var useRefSignal = useSignal;
var useSignal2 = (value) => {
  const item = F2(() => a3(value), []);
  item.value;
  return item;
};
var useDidUpdate = (callback) => {
  const hasMount = _(false);
  p2(() => {
    if (hasMount.current) {
      callback();
    } else {
      hasMount.current = true;
    }
  });
};
var or = (nothing, err, item, value) => {
  if (item instanceof nothing || item instanceof err) {
    return value;
  } else {
    return item._0;
  }
};
var toArray = (...args) => {
  let items = Array.from(args);
  if (Array.isArray(items[0]) && items.length === 1) {
    return items[0];
  } else {
    return items;
  }
};
var access = (field) => (value) => value[field];
var identity = (a4) => a4;
var record = (name) => (value) => ({ [Name]: name, ...value });
var lazyComponent = class extends b {
  async componentDidMount() {
    let x3 = await this.props.x();
    this.setState({ x: x3 });
  }
  render() {
    if (this.state.x) {
      return y(this.state.x, this.props.p, this.props.c);
    } else {
      if (this.props.f) {
        return this.props.f();
      } else {
        return null;
      }
    }
  }
};
var lazy = (path) => async () => load(path);
var load = async (path) => {
  const x3 = await import(path);
  return x3.default;
};
var isThruthy = (value, just, ok) => {
  return value instanceof ok || value instanceof just;
};
var useDimensions = (ref, get, empty) => {
  const signal = useSignal2(empty());
  useSignalEffect(() => {
    const observer = new ResizeObserver(() => {
      signal.value = ref.value && ref.value._0 ? get(ref.value._0) : empty();
    });
    if (ref.value && ref.value._0) {
      observer.observe(ref.value._0);
    }
    return () => {
      signal.value = empty();
      observer.disconnect();
    };
  });
  return signal;
};

// src/translate.js
var translations = a3({});
var locale = a3({});
var setLocale = (value) => locale.value = value;
var translate = (key) => (translations.value[locale.value] || {})[key] || "";

// src/provider.js
var import_uuid_random = __toESM(require_uuid_random());
var createProvider = (subscriptions2, update) => {
  return (owner, object) => {
    const unsubscribe = () => {
      if (subscriptions2.has(owner)) {
        subscriptions2.delete(owner);
        s2(update);
      }
    };
    p2(() => {
      return unsubscribe;
    }, []);
    p2(() => {
      const data = object();
      if (data === null) {
        unsubscribe();
      } else {
        const current = subscriptions2.get(owner);
        if (!compare(current, data)) {
          subscriptions2.set(owner, data);
          s2(update);
        }
      }
    });
  };
};
var subscriptions = (items) => Array.from(items.values());
var useId = () => F2(import_uuid_random.default, []);

// node_modules/indent-string/index.js
function indentString(string, count = 1, options = {}) {
  const {
    indent = " ",
    includeEmptyLines = false
  } = options;
  if (typeof string !== "string") {
    throw new TypeError(
      `Expected \`input\` to be a \`string\`, got \`${typeof string}\``
    );
  }
  if (typeof count !== "number") {
    throw new TypeError(
      `Expected \`count\` to be a \`number\`, got \`${typeof count}\``
    );
  }
  if (count < 0) {
    throw new RangeError(
      `Expected \`count\` to be at least 0, got \`${count}\``
    );
  }
  if (typeof indent !== "string") {
    throw new TypeError(
      `Expected \`options.indent\` to be a \`string\`, got \`${typeof indent}\``
    );
  }
  if (count === 0) {
    return string;
  }
  const regex = includeEmptyLines ? /^/gm : /^(?!\s*$)/gm;
  return string.replace(regex, indent.repeat(count));
}

// src/decoders.js
var format = (value) => {
  let string = JSON.stringify(value, "", 2);
  if (typeof string === "undefined") {
    string = "undefined";
  }
  return indentString(string, 2);
};
var Error2 = class {
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
            return `[${item.value}]`;
        }
      }
    }, "");
    if (path.length && this.object) {
      return message + "\n\n" + IN_OBJECT.trim().replace("{value}", format(this.object)).replace("{path}", path);
    } else {
      return message;
    }
  }
};
var IN_OBJECT = `
The input is in this object:

{value}

at: {path}
`;
var NOT_A_STRING = `
I was trying to decode the value:

{value}

as a String, but could not.
`;
var NOT_A_TIME = `
I was trying to decode the value:

{value}

as a Time, but could not.
`;
var NOT_A_NUMBER = `
I was trying to decode the value:

{value}

as a Number, but could not.
`;
var NOT_A_BOOLEAN = `
I was trying to decode the value:

{value}

as a Bool, but could not.
`;
var NOT_AN_OBJECT = `
I was trying to decode the field "{field}" from the object:

{value}

but I could not because it's not an object.
`;
var NOT_AN_ARRAY = `
I was trying to decode the value:

{value}

as an Array, but could not.
`;
var NOT_A_TUPLE = `
I was trying to decode the value:

{value}

as an Tuple, but could not.
`;
var TUPLE_SIZE_MISMATCH = `
I was trying to decode a tuple with {count} items but the value:

{value}

has only {valueCount} items.
`;
var NOT_A_MAP = `
I was trying to decode the value:

{value}

as a Map, but could not.
`;
var decodeString = (ok, err) => (input) => {
  if (typeof input != "string") {
    return new err(new Error2(NOT_A_STRING.replace("{value}", format(input))));
  } else {
    return new ok(input);
  }
};
var decodeTime = (ok, err) => (input) => {
  let parsed = NaN;
  if (typeof input === "number") {
    parsed = new Date(input);
  } else {
    parsed = Date.parse(input);
  }
  if (Number.isNaN(parsed)) {
    return new err(new Error2(NOT_A_TIME.replace("{value}", format(input))));
  } else {
    return new ok(new Date(parsed));
  }
};
var decodeNumber = (ok, err) => (input) => {
  let value = parseFloat(input);
  if (isNaN(value)) {
    return new err(new Error2(NOT_A_NUMBER.replace("{value}", format(input))));
  } else {
    return new ok(value);
  }
};
var decodeBoolean = (ok, err) => (input) => {
  if (typeof input != "boolean") {
    return new err(new Error2(NOT_A_BOOLEAN.replace("{value}", format(input))));
  } else {
    return new ok(input);
  }
};
var decodeField = (key, decoder2, err) => (input) => {
  if (typeof input !== "object" || Array.isArray(input) || input == void 0 || input == null) {
    const message = NOT_AN_OBJECT.replace("{field}", key).replace(
      "{value}",
      format(input)
    );
    return new err(new Error2(message));
  } else {
    const decoded = decoder2(input[key]);
    if (decoded instanceof err) {
      decoded._0.push({ type: "FIELD", value: key });
      decoded._0.object = input;
    }
    return decoded;
  }
};
var decodeArray = (decoder2, ok, err) => (input) => {
  if (!Array.isArray(input)) {
    return new err(new Error2(NOT_AN_ARRAY.replace("{value}", format(input))));
  }
  let results = [];
  let index = 0;
  for (let item of input) {
    let result = decoder2(item);
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
var decodeMaybe = (decoder2, ok, err, just, nothing) => (input) => {
  if (input === null || input === void 0) {
    return new ok(new nothing());
  } else {
    const result = decoder2(input);
    if (result instanceof err) {
      return result;
    } else {
      return new ok(new just(result._0));
    }
  }
};
var decodeTuple = (decoders, ok, err) => (input) => {
  if (!Array.isArray(input)) {
    return new err(new Error2(NOT_A_TUPLE.replace("{value}", format(input))));
  }
  if (input.length != decoders.length) {
    return new err(
      new Error2(
        TUPLE_SIZE_MISMATCH.replace("{value}", format(input)).replace("{count}", decoders.length).replace("{valueCount}", input.length)
      )
    );
  }
  let results = [];
  let index = 0;
  for (let decoder2 of decoders) {
    let result = decoder2(input[index]);
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
var decodeMap = (decoder2, ok, err) => (input) => {
  if (typeof input !== "object" || Array.isArray(input) || input == void 0 || input == null) {
    const message = NOT_A_MAP.replace("{value}", format(input));
    return new err(new Error2(message));
  } else {
    const map = [];
    for (let key in input) {
      const result = decoder2(input[key]);
      if (result instanceof err) {
        return result;
      } else {
        map.push([key, result._0]);
      }
    }
    return new ok(map);
  }
};
var decodeMapArray = (keyDecoder, valueDecoder, ok, err) => (input) => {
  if (!Array.isArray(input)) {
    const message = NOT_AN_ARRAY.replace("{value}", format(input));
    return new err(new Error2(message));
  } else {
    const map = [];
    for (let item of input) {
      const keyResult = keyDecoder(item[0]);
      if (keyResult instanceof err) {
        return keyResult;
      }
      const valueResult = valueDecoder(item[1]);
      if (valueResult instanceof err) {
        return valueResult;
      }
      map.push([keyResult._0, valueResult._0]);
    }
    return new ok(map);
  }
};
var decoder = (name, mappings, ok, err) => (input) => {
  const object = { [Name]: name };
  for (let key in mappings) {
    let decoder2 = mappings[key];
    let target = key;
    if (Array.isArray(decoder2)) {
      decoder2 = mappings[key][0];
      target = mappings[key][1];
    }
    const result = decodeField(target, decoder2, err)(input);
    if (result instanceof err) {
      return result;
    }
    object[key] = result._0;
  }
  return new ok(object);
};
var decodeObject = (ok) => (value) => new ok(value);
var decodeVariant = (variant2, decoders, ok, err) => (input) => {
  let items = [];
  if (Array.isArray(decoders)) {
    const result = decodeTuple(decoders, ok, err)(input);
    if (result instanceof err) {
      return result;
    }
    items = result._0;
  }
  return new ok(new variant2(...items));
};
var decodeType = (name, decoders, ok, err) => (input) => {
  const result = decodeField("type", decodeString(ok, err), err)(input);
  if (result instanceof err) {
    return result;
  }
  const decoder2 = decoders[result._0];
  if (decoder2) {
    return decoder2(input.value);
  } else {
    return new err(
      new Error2(`Invalid type ${input["type"]} for type: ${name}`)
    );
  }
};

// src/encoders.js
var encodeTime = (value) => value.toISOString();
var encodeArray = (encoder2) => (value) => {
  return value.map((item) => {
    return encoder2 ? encoder2(item) : item;
  });
};
var encodeMap = (encoder2) => (value) => {
  const result = {};
  for (let item of value) {
    result[item[0]] = encoder2 ? encoder2(item[1]) : item[1];
  }
  return result;
};
var encodeMapArray = (keyEncoder, valueEncoder) => (value) => {
  const result = [];
  for (let item of value) {
    result.push([
      keyEncoder ? keyEncoder(item[0]) : item[0],
      valueEncoder ? valueEncoder(item[1]) : item[1]
    ]);
  }
  return result;
};
var encodeMaybe = (encoder2, just) => (value) => {
  if (value instanceof just) {
    return encoder2(value._0);
  } else {
    return null;
  }
};
var encodeTuple = (encoders) => (value) => {
  return value.map((item, index) => {
    const encoder2 = encoders[index];
    return encoder2 ? encoder2(item) : item;
  });
};
var encoder = (encoders) => (value) => {
  const result = {};
  for (let key in encoders) {
    let encoder2 = encoders[key];
    let field = key;
    if (Array.isArray(encoder2)) {
      encoder2 = encoders[key][0];
      field = encoders[key][1];
    }
    result[field] = (encoder2 || identity)(value[key]);
  }
  return result;
};
var encodeVariant = (encoders) => (value) => {
  const variant2 = encoders.find((item) => value instanceof item[0]);
  const result = { type: value[Name] };
  if (variant2[1]) {
    result.value = [];
    for (let index = 0; index < variant2[1].length; index++) {
      result.value.push(variant2[1][index](value[`_${index}`]));
    }
  }
  return result;
};

// node_modules/fast-equals/dist/esm/index.mjs
var getOwnPropertyNames = Object.getOwnPropertyNames;
var getOwnPropertySymbols = Object.getOwnPropertySymbols;
var hasOwnProperty = Object.prototype.hasOwnProperty;
function combineComparators(comparatorA, comparatorB) {
  return function isEqual(a4, b4, state) {
    return comparatorA(a4, b4, state) && comparatorB(a4, b4, state);
  };
}
function createIsCircular(areItemsEqual) {
  return function isCircular(a4, b4, state) {
    if (!a4 || !b4 || typeof a4 !== "object" || typeof b4 !== "object") {
      return areItemsEqual(a4, b4, state);
    }
    var cache = state.cache;
    var cachedA = cache.get(a4);
    var cachedB = cache.get(b4);
    if (cachedA && cachedB) {
      return cachedA === b4 && cachedB === a4;
    }
    cache.set(a4, b4);
    cache.set(b4, a4);
    var result = areItemsEqual(a4, b4, state);
    cache.delete(a4);
    cache.delete(b4);
    return result;
  };
}
function getStrictProperties(object) {
  return getOwnPropertyNames(object).concat(getOwnPropertySymbols(object));
}
var hasOwn = Object.hasOwn || function(object, property) {
  return hasOwnProperty.call(object, property);
};
function sameValueZeroEqual(a4, b4) {
  return a4 || b4 ? a4 === b4 : a4 === b4 || a4 !== a4 && b4 !== b4;
}
var OWNER = "_owner";
var getOwnPropertyDescriptor = Object.getOwnPropertyDescriptor;
var keys = Object.keys;
function areArraysEqual(a4, b4, state) {
  var index = a4.length;
  if (b4.length !== index) {
    return false;
  }
  while (index-- > 0) {
    if (!state.equals(a4[index], b4[index], index, index, a4, b4, state)) {
      return false;
    }
  }
  return true;
}
function areDatesEqual(a4, b4) {
  return sameValueZeroEqual(a4.getTime(), b4.getTime());
}
function areMapsEqual(a4, b4, state) {
  if (a4.size !== b4.size) {
    return false;
  }
  var matchedIndices = {};
  var aIterable = a4.entries();
  var index = 0;
  var aResult;
  var bResult;
  while (aResult = aIterable.next()) {
    if (aResult.done) {
      break;
    }
    var bIterable = b4.entries();
    var hasMatch = false;
    var matchIndex = 0;
    while (bResult = bIterable.next()) {
      if (bResult.done) {
        break;
      }
      var _a = aResult.value, aKey = _a[0], aValue = _a[1];
      var _b = bResult.value, bKey = _b[0], bValue = _b[1];
      if (!hasMatch && !matchedIndices[matchIndex] && (hasMatch = state.equals(aKey, bKey, index, matchIndex, a4, b4, state) && state.equals(aValue, bValue, aKey, bKey, a4, b4, state))) {
        matchedIndices[matchIndex] = true;
      }
      matchIndex++;
    }
    if (!hasMatch) {
      return false;
    }
    index++;
  }
  return true;
}
function areObjectsEqual(a4, b4, state) {
  var properties = keys(a4);
  var index = properties.length;
  if (keys(b4).length !== index) {
    return false;
  }
  var property;
  while (index-- > 0) {
    property = properties[index];
    if (property === OWNER && (a4.$$typeof || b4.$$typeof) && a4.$$typeof !== b4.$$typeof) {
      return false;
    }
    if (!hasOwn(b4, property) || !state.equals(a4[property], b4[property], property, property, a4, b4, state)) {
      return false;
    }
  }
  return true;
}
function areObjectsEqualStrict(a4, b4, state) {
  var properties = getStrictProperties(a4);
  var index = properties.length;
  if (getStrictProperties(b4).length !== index) {
    return false;
  }
  var property;
  var descriptorA;
  var descriptorB;
  while (index-- > 0) {
    property = properties[index];
    if (property === OWNER && (a4.$$typeof || b4.$$typeof) && a4.$$typeof !== b4.$$typeof) {
      return false;
    }
    if (!hasOwn(b4, property)) {
      return false;
    }
    if (!state.equals(a4[property], b4[property], property, property, a4, b4, state)) {
      return false;
    }
    descriptorA = getOwnPropertyDescriptor(a4, property);
    descriptorB = getOwnPropertyDescriptor(b4, property);
    if ((descriptorA || descriptorB) && (!descriptorA || !descriptorB || descriptorA.configurable !== descriptorB.configurable || descriptorA.enumerable !== descriptorB.enumerable || descriptorA.writable !== descriptorB.writable)) {
      return false;
    }
  }
  return true;
}
function arePrimitiveWrappersEqual(a4, b4) {
  return sameValueZeroEqual(a4.valueOf(), b4.valueOf());
}
function areRegExpsEqual(a4, b4) {
  return a4.source === b4.source && a4.flags === b4.flags;
}
function areSetsEqual(a4, b4, state) {
  if (a4.size !== b4.size) {
    return false;
  }
  var matchedIndices = {};
  var aIterable = a4.values();
  var aResult;
  var bResult;
  while (aResult = aIterable.next()) {
    if (aResult.done) {
      break;
    }
    var bIterable = b4.values();
    var hasMatch = false;
    var matchIndex = 0;
    while (bResult = bIterable.next()) {
      if (bResult.done) {
        break;
      }
      if (!hasMatch && !matchedIndices[matchIndex] && (hasMatch = state.equals(aResult.value, bResult.value, aResult.value, bResult.value, a4, b4, state))) {
        matchedIndices[matchIndex] = true;
      }
      matchIndex++;
    }
    if (!hasMatch) {
      return false;
    }
  }
  return true;
}
function areTypedArraysEqual(a4, b4) {
  var index = a4.length;
  if (b4.length !== index) {
    return false;
  }
  while (index-- > 0) {
    if (a4[index] !== b4[index]) {
      return false;
    }
  }
  return true;
}
var ARGUMENTS_TAG = "[object Arguments]";
var BOOLEAN_TAG = "[object Boolean]";
var DATE_TAG = "[object Date]";
var MAP_TAG = "[object Map]";
var NUMBER_TAG = "[object Number]";
var OBJECT_TAG = "[object Object]";
var REG_EXP_TAG = "[object RegExp]";
var SET_TAG = "[object Set]";
var STRING_TAG = "[object String]";
var isArray = Array.isArray;
var isTypedArray = typeof ArrayBuffer === "function" && ArrayBuffer.isView ? ArrayBuffer.isView : null;
var assign = Object.assign;
var getTag = Object.prototype.toString.call.bind(Object.prototype.toString);
function createEqualityComparator(_a) {
  var areArraysEqual2 = _a.areArraysEqual, areDatesEqual2 = _a.areDatesEqual, areMapsEqual2 = _a.areMapsEqual, areObjectsEqual2 = _a.areObjectsEqual, arePrimitiveWrappersEqual2 = _a.arePrimitiveWrappersEqual, areRegExpsEqual2 = _a.areRegExpsEqual, areSetsEqual2 = _a.areSetsEqual, areTypedArraysEqual2 = _a.areTypedArraysEqual;
  return function comparator(a4, b4, state) {
    if (a4 === b4) {
      return true;
    }
    if (a4 == null || b4 == null || typeof a4 !== "object" || typeof b4 !== "object") {
      return a4 !== a4 && b4 !== b4;
    }
    var constructor = a4.constructor;
    if (constructor !== b4.constructor) {
      return false;
    }
    if (constructor === Object) {
      return areObjectsEqual2(a4, b4, state);
    }
    if (isArray(a4)) {
      return areArraysEqual2(a4, b4, state);
    }
    if (isTypedArray != null && isTypedArray(a4)) {
      return areTypedArraysEqual2(a4, b4, state);
    }
    if (constructor === Date) {
      return areDatesEqual2(a4, b4, state);
    }
    if (constructor === RegExp) {
      return areRegExpsEqual2(a4, b4, state);
    }
    if (constructor === Map) {
      return areMapsEqual2(a4, b4, state);
    }
    if (constructor === Set) {
      return areSetsEqual2(a4, b4, state);
    }
    var tag = getTag(a4);
    if (tag === DATE_TAG) {
      return areDatesEqual2(a4, b4, state);
    }
    if (tag === REG_EXP_TAG) {
      return areRegExpsEqual2(a4, b4, state);
    }
    if (tag === MAP_TAG) {
      return areMapsEqual2(a4, b4, state);
    }
    if (tag === SET_TAG) {
      return areSetsEqual2(a4, b4, state);
    }
    if (tag === OBJECT_TAG) {
      return typeof a4.then !== "function" && typeof b4.then !== "function" && areObjectsEqual2(a4, b4, state);
    }
    if (tag === ARGUMENTS_TAG) {
      return areObjectsEqual2(a4, b4, state);
    }
    if (tag === BOOLEAN_TAG || tag === NUMBER_TAG || tag === STRING_TAG) {
      return arePrimitiveWrappersEqual2(a4, b4, state);
    }
    return false;
  };
}
function createEqualityComparatorConfig(_a) {
  var circular = _a.circular, createCustomConfig = _a.createCustomConfig, strict = _a.strict;
  var config = {
    areArraysEqual: strict ? areObjectsEqualStrict : areArraysEqual,
    areDatesEqual,
    areMapsEqual: strict ? combineComparators(areMapsEqual, areObjectsEqualStrict) : areMapsEqual,
    areObjectsEqual: strict ? areObjectsEqualStrict : areObjectsEqual,
    arePrimitiveWrappersEqual,
    areRegExpsEqual,
    areSetsEqual: strict ? combineComparators(areSetsEqual, areObjectsEqualStrict) : areSetsEqual,
    areTypedArraysEqual: strict ? areObjectsEqualStrict : areTypedArraysEqual
  };
  if (createCustomConfig) {
    config = assign({}, config, createCustomConfig(config));
  }
  if (circular) {
    var areArraysEqual$1 = createIsCircular(config.areArraysEqual);
    var areMapsEqual$1 = createIsCircular(config.areMapsEqual);
    var areObjectsEqual$1 = createIsCircular(config.areObjectsEqual);
    var areSetsEqual$1 = createIsCircular(config.areSetsEqual);
    config = assign({}, config, {
      areArraysEqual: areArraysEqual$1,
      areMapsEqual: areMapsEqual$1,
      areObjectsEqual: areObjectsEqual$1,
      areSetsEqual: areSetsEqual$1
    });
  }
  return config;
}
function createInternalEqualityComparator(compare2) {
  return function(a4, b4, _indexOrKeyA, _indexOrKeyB, _parentA, _parentB, state) {
    return compare2(a4, b4, state);
  };
}
function createIsEqual(_a) {
  var circular = _a.circular, comparator = _a.comparator, createState = _a.createState, equals2 = _a.equals, strict = _a.strict;
  if (createState) {
    return function isEqual(a4, b4) {
      var _a2 = createState(), _b = _a2.cache, cache = _b === void 0 ? circular ? /* @__PURE__ */ new WeakMap() : void 0 : _b, meta = _a2.meta;
      return comparator(a4, b4, {
        cache,
        equals: equals2,
        meta,
        strict
      });
    };
  }
  if (circular) {
    return function isEqual(a4, b4) {
      return comparator(a4, b4, {
        cache: /* @__PURE__ */ new WeakMap(),
        equals: equals2,
        meta: void 0,
        strict
      });
    };
  }
  var state = {
    cache: void 0,
    equals: equals2,
    meta: void 0,
    strict
  };
  return function isEqual(a4, b4) {
    return comparator(a4, b4, state);
  };
}
var deepEqual = createCustomEqual();
var strictDeepEqual = createCustomEqual({ strict: true });
var circularDeepEqual = createCustomEqual({ circular: true });
var strictCircularDeepEqual = createCustomEqual({
  circular: true,
  strict: true
});
var shallowEqual = createCustomEqual({
  createInternalComparator: function() {
    return sameValueZeroEqual;
  }
});
var strictShallowEqual = createCustomEqual({
  strict: true,
  createInternalComparator: function() {
    return sameValueZeroEqual;
  }
});
var circularShallowEqual = createCustomEqual({
  circular: true,
  createInternalComparator: function() {
    return sameValueZeroEqual;
  }
});
var strictCircularShallowEqual = createCustomEqual({
  circular: true,
  createInternalComparator: function() {
    return sameValueZeroEqual;
  },
  strict: true
});
function createCustomEqual(options) {
  if (options === void 0) {
    options = {};
  }
  var _a = options.circular, circular = _a === void 0 ? false : _a, createCustomInternalComparator = options.createInternalComparator, createState = options.createState, _b = options.strict, strict = _b === void 0 ? false : _b;
  var config = createEqualityComparatorConfig(options);
  var comparator = createEqualityComparator(config);
  var equals2 = createCustomInternalComparator ? createCustomInternalComparator(comparator) : createInternalEqualityComparator(comparator);
  return createIsEqual({ circular, comparator, createState, equals: equals2, strict });
}

// src/program.js
var import_route_parser = __toESM(require_route_parser());
var DecodingError = class extends Error {
};
var equals = (a4, b4) => {
  if (a4 instanceof Object) {
    return b4 instanceof Object && deepEqual(a4, b4);
  } else {
    return !(b4 instanceof Object) && a4 === b4;
  }
};
var queueTask = (callback) => {
  if (typeof window.queueMicrotask !== "function") {
    Promise.resolve().then(callback).catch(
      (e4) => setTimeout(() => {
        throw e4;
      })
    );
  } else {
    window.queueMicrotask(callback);
  }
};
var getRouteInfo = (url, routes) => {
  for (let route of routes) {
    if (route.path === "*") {
      return { route, vars: false, url };
    } else {
      let vars = new import_route_parser.default(route.path).match(url);
      if (vars) {
        return { route, vars, url };
      }
    }
  }
  return null;
};
var Program = class {
  constructor(ok, routes, hashRouting) {
    this.root = document.createElement("div");
    this.hashRouting = hashRouting;
    this.routeInfo = null;
    this.routes = routes;
    this.ok = ok;
    if (hashRouting) {
      this.navigate = navigateHash;
    } else {
      this.navigate = navigate;
    }
    document.body.appendChild(this.root);
    window.addEventListener("submit", this.handleSubmit.bind(this), true);
    window.addEventListener("popstate", this.handlePopState.bind(this));
    window.addEventListener("click", this.handleClick.bind(this), true);
  }
  handleSubmit(event) {
    if (event.target.method !== "get") {
      return;
    }
    if (event.defaultPrevented) {
      return;
    }
    const url = new URL(event.target.action);
    if (url.origin === window.location.origin) {
      const search = "?" + new URLSearchParams(new FormData(event.target)).toString();
      const fullPath = url.pathname + search + url.hash;
      if (this.handleRoute(fullPath)) {
        event.preventDefault();
      }
    }
  }
  handleClick(event) {
    if (event.defaultPrevented) {
      return;
    }
    if (event.ctrlKey) {
      return;
    }
    for (let element of event.composedPath()) {
      if (element.tagName === "A") {
        if (element.target.trim() !== "") {
          return;
        }
        if (element.origin === window.location.origin) {
          const fullPath = element.pathname + element.search + element.hash;
          if (this.handleRoute(fullPath)) {
            event.preventDefault();
            return;
          }
        }
      }
    }
  }
  handleRoute(fullPath) {
    const routeInfo = getRouteInfo(fullPath, this.routes);
    if (routeInfo) {
      this.navigate(
        fullPath,
        /* dispatch */
        true,
        /* triggerJump */
        true,
        routeInfo
      );
      return true;
    }
    return false;
  }
  // Handles resolving the page position after a navigation event.
  resolvePagePosition(triggerJump) {
    queueTask(() => {
      requestAnimationFrame(() => {
        const hash = window.location.hash;
        if (hash) {
          let elem = null;
          try {
            elem = this.root.querySelector(hash) || // ID
            this.root.querySelector(`a[name="${hash.slice(1)}"]`);
          } catch {
          }
          if (elem) {
            if (triggerJump) {
              elem.scrollIntoView();
            }
          }
        } else if (triggerJump) {
          window.scrollTo(0, 0);
        }
      });
    });
  }
  // Handles navigation events.
  async handlePopState(event) {
    let url;
    if (this.hashRouting) {
      url = hrefHash();
    } else {
      url = window.location.pathname + window.location.search + window.location.hash;
    }
    const routeInfo = event?.routeInfo || getRouteInfo(url, this.routes);
    if (routeInfo) {
      if (this.routeInfo === null || routeInfo.url !== this.routeInfo.url || !equals(routeInfo.vars, this.routeInfo.vars)) {
        const handler = this.runRouteHandler(routeInfo);
        if (routeInfo.route.await) {
          await handler;
        }
      }
      this.resolvePagePosition(!!event?.triggerJump);
    }
    this.routeInfo = routeInfo;
  }
  // Helper function for above.
  async runRouteHandler(routeInfo) {
    const { route } = routeInfo;
    if (route.path === "*") {
      return route.handler();
    } else {
      const { vars } = routeInfo;
      try {
        let args = route.mapping.map((name, index) => {
          const value = vars[name];
          const result = route.decoders[index](value);
          if (result instanceof this.ok) {
            return result._0;
          } else {
            throw new DecodingError();
          }
        });
        return route.handler.apply(null, args);
      } catch (error) {
        if (error.constructor !== DecodingError) {
          throw error;
        }
      }
    }
  }
  // Renders the program and runs current route handlers.
  render(main, globals) {
    const components = [];
    for (let key in globals) {
      components.push(y(globals[key], { key }));
    }
    let mainNode;
    if (typeof main !== "undefined") {
      mainNode = y(main, { key: "MINT_MAIN" });
    }
    q([...components, mainNode], this.root);
    this.handlePopState();
  }
};
var navigate = (url, dispatch = true, triggerJump = true, routeInfo = null) => {
  let pathname = window.location.pathname;
  let search = window.location.search;
  let hash = window.location.hash;
  let fullPath = pathname + search + hash;
  if (fullPath !== url) {
    if (dispatch) {
      window.history.pushState({}, "", url);
    } else {
      window.history.replaceState({}, "", url);
    }
  }
  if (dispatch) {
    let event = new PopStateEvent("popstate");
    event.triggerJump = triggerJump;
    event.routeInfo = routeInfo;
    dispatchEvent(event);
  }
};
var navigateHash = (url, dispatch = true, triggerJump = true, routeInfo = null) => {
  let fullPath = hrefHash();
  if (fullPath !== url) {
    if (dispatch) {
      window.history.pushState({}, "", `#${url}`);
    } else {
      window.history.replaceState({}, "", `#${url}`);
    }
  }
  if (dispatch) {
    let event = new PopStateEvent("popstate");
    event.triggerJump = triggerJump;
    event.routeInfo = routeInfo;
    dispatchEvent(event);
  }
};
var hrefHash = () => {
  const hash = window.location.hash.toString().replace(/^#/, "");
  if (hash.startsWith("/")) {
    return hash;
  } else {
    return `/${hash}`;
  }
};
var href = () => window.location.href;
var program = (main, globals, ok, routes = [], hashRouting = false) => {
  new Program(ok, routes, hashRouting).render(main, globals);
};
var embed = (component) => {
  return (element, props = () => {
  }, children = () => []) => {
    return {
      render: () => q(y(component, props(), children()), element),
      cleanup: () => q(null, element)
    };
  };
};

// src/portals.js
function ContextProvider(props) {
  this.getChildContext = () => props.context;
  return props.children;
}
function Portal(props) {
  const _this = this;
  let container = props._container;
  _this.componentWillUnmount = function() {
    q(null, _this._temp);
    _this._temp = null;
    _this._container = null;
  };
  if (_this._container && _this._container !== container) {
    _this.componentWillUnmount();
  }
  if (!_this._temp) {
    _this._container = container;
    _this._temp = {
      nodeType: 1,
      parentNode: container,
      childNodes: [],
      appendChild(child) {
        this.childNodes.push(child);
        _this._container.appendChild(child);
      },
      insertBefore(child, before) {
        this.childNodes.push(child);
        _this._container.appendChild(child);
      },
      removeChild(child) {
        this.childNodes.splice(this.childNodes.indexOf(child) >>> 1, 1);
        _this._container.removeChild(child);
      }
    };
  }
  q(
    y(ContextProvider, { context: _this.context }, props._vnode),
    _this._temp
  );
}
function createPortal(vnode, container) {
  const el = y(Portal, { _vnode: vnode, _container: container });
  el.containerInfo = container;
  return el;
}

// src/variant.js
var Variant = class {
  [Equals](other) {
    if (!(other instanceof this.constructor)) {
      return false;
    }
    if (other.length !== this.length) {
      return false;
    }
    if (this.record) {
      return compareObjects(this, other);
    }
    for (let index = 0; index < this.length; index++) {
      if (!compare(this["_" + index], other["_" + index])) {
        return false;
      }
    }
    return true;
  }
};
var variant = (input, name) => {
  return class extends Variant {
    constructor(...args) {
      super();
      this[Name] = name;
      if (Array.isArray(input)) {
        this.length = input.length;
        this.record = true;
        for (let index = 0; index < input.length; index++) {
          this[input[index]] = args[index];
          this[`_${index}`] = args[index];
        }
      } else {
        this.length = input;
        for (let index = 0; index < input; index++) {
          this[`_${index}`] = args[index];
        }
      }
    }
  };
};
var newVariant = (item) => (...args) => new item(...args);

// src/styles.js
var style = (items) => {
  let important = false;
  const result = {};
  const setKeyValue = (key, value) => {
    const stringValue = value.toString().trim();
    if (stringValue.indexOf("!important") != -1) {
      important = true;
    }
    result[key.toString().trim()] = stringValue;
  };
  for (let item of items) {
    if (typeof item === "string") {
      item.split(";").forEach((prop) => {
        const [key, value] = prop.split(":");
        if (key && value) {
          setKeyValue(key, value);
        }
      });
    } else if (item instanceof Map || item instanceof Array) {
      for (let [key, value] of item) {
        setKeyValue(key, value);
      }
    } else {
      for (let key in item) {
        setKeyValue(key, item[key]);
      }
    }
  }
  if (important) {
    let string = "";
    for (let key in result) {
      string += `${key}:${result[key]};`;
    }
    return string;
  } else {
    return result;
  }
};

// src/debug.js
var render = (items, prefix, suffix, fn) => {
  items = items.map(fn);
  const newLines = items.size > 3 || items.filter((item) => item.indexOf("\n") > 0).length;
  const joined = items.join(newLines ? ",\n" : ", ");
  if (newLines) {
    return `${prefix.trim()}
${indentString(joined, 2)}
${suffix.trim()}`;
  } else {
    return `${prefix}${joined}${suffix}`;
  }
};
var toString = (object) => {
  if (object.type === "null") {
    return "null";
  } else if (object.type === "undefined") {
    return "undefined";
  } else if (object.type === "string") {
    return `"${object.value}"`;
  } else if (object.type === "number") {
    return `${object.value}`;
  } else if (object.type === "boolean") {
    return `${object.value}`;
  } else if (object.type === "element") {
    return `<${object.value.toLowerCase()}>`;
  } else if (object.type === "variant") {
    if (object.items) {
      return render(object.items, `${object.value}(`, `)`, toString);
    } else {
      return object.value;
    }
  } else if (object.type === "array") {
    return render(object.items, `[`, `]`, toString);
  } else if (object.type === "object") {
    return render(object.items, `{ `, ` }`, toString);
  } else if (object.type === "record") {
    return render(object.items, `${object.value} { `, ` }`, toString);
  } else if (object.type === "unknown") {
    return `{ ${object.value} }`;
  } else if (object.type === "vnode") {
    return `VNode`;
  } else if (object.key) {
    return `${object.key}: ${toString(object.value)}`;
  } else if (object.value) {
    return toString(object.value);
  }
};
var objectify = (value) => {
  if (value === null) {
    return { type: "null" };
  } else if (value === void 0) {
    return { type: "undefined" };
  } else if (typeof value === "string") {
    return { type: "string", value };
  } else if (typeof value === "number") {
    return { type: "number", value: value.toString() };
  } else if (typeof value === "boolean") {
    return { type: "boolean", value: value.toString() };
  } else if (value instanceof HTMLElement) {
    return { type: "element", value: value.tagName };
  } else if (value instanceof Variant) {
    const items = [];
    if (value.record) {
      for (const key in value) {
        if (key === "length" || key === "record" || key.startsWith("_")) {
          continue;
        }
        items.push({
          value: objectify(value[key]),
          key
        });
      }
    } else {
      for (let i4 = 0; i4 < value.length; i4++) {
        items.push({
          value: objectify(value[`_${i4}`])
        });
      }
    }
    if (items.length) {
      return { type: "variant", value: value[Name], items };
    } else {
      return { type: "variant", value: value[Name] };
    }
  } else if (Array.isArray(value)) {
    return {
      items: value.map((item) => ({ value: objectify(item) })),
      type: "array"
    };
  } else if (isVnode(value)) {
    return { type: "vnode" };
  } else if (typeof value == "object") {
    const items = [];
    for (const key in value) {
      items.push({
        value: objectify(value[key]),
        key
      });
    }
    if (Name in value) {
      return { type: "record", value: value[Name], items };
    } else {
      return { type: "object", items };
    }
  } else {
    return { type: "unknown", value: value.toString() };
  }
};
var inspect = (value) => {
  return toString(objectify(value));
};
var export_uuid = import_uuid_random.default;
export {
  Error2 as Error,
  Variant,
  access,
  n2 as batch,
  bracketAccess,
  compare,
  compareObjects,
  F as createContext,
  y as createElement,
  createPortal,
  createProvider,
  decodeArray,
  decodeBoolean,
  decodeField,
  decodeMap,
  decodeMapArray,
  decodeMaybe,
  decodeNumber,
  decodeObject,
  decodeString,
  decodeTime,
  decodeTuple,
  decodeType,
  decodeVariant,
  decoder,
  destructure,
  embed,
  encodeArray,
  encodeMap,
  encodeMapArray,
  encodeMaybe,
  encodeTime,
  encodeTuple,
  encodeVariant,
  encoder,
  g as fragment,
  href,
  hrefHash,
  identity,
  inspect,
  isThruthy,
  isVnode,
  lazy,
  lazyComponent,
  load,
  locale,
  mapAccess,
  match,
  navigate,
  navigateHash,
  newVariant,
  normalizeEvent,
  or,
  pattern,
  patternMany,
  patternRecord,
  patternSpread,
  patternVariable,
  program,
  record,
  setLocale,
  setRef,
  setTestRef,
  a3 as signal,
  style,
  subscriptions,
  testContext,
  testOperation,
  q as testRender,
  testRunner,
  toArray,
  translate,
  translations,
  q2 as useContext,
  useDidUpdate,
  useDimensions,
  p2 as useEffect,
  useId,
  F2 as useMemo,
  useRefSignal,
  useSignal2 as useSignal,
  export_uuid as uuid,
  variant
};
