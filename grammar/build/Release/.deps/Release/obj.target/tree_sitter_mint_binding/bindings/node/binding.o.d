cmd_Release/obj.target/tree_sitter_mint_binding/bindings/node/binding.o := g++ -o Release/obj.target/tree_sitter_mint_binding/bindings/node/binding.o ../bindings/node/binding.cc '-DNODE_GYP_MODULE_NAME=tree_sitter_mint_binding' '-DUSING_UV_SHARED=1' '-DUSING_V8_SHARED=1' '-DV8_DEPRECATION_WARNINGS=1' '-DV8_DEPRECATION_WARNINGS' '-DV8_IMMINENT_DEPRECATION_WARNINGS' '-D_GLIBCXX_USE_CXX11_ABI=1' '-D_LARGEFILE_SOURCE' '-D_FILE_OFFSET_BITS=64' '-D__STDC_FORMAT_MACROS' '-DOPENSSL_NO_PINSHARED' '-DOPENSSL_THREADS' '-DBUILDING_NODE_EXTENSION' -I/home/gus/.cache/node-gyp/20.10.0/include/node -I/home/gus/.cache/node-gyp/20.10.0/src -I/home/gus/.cache/node-gyp/20.10.0/deps/openssl/config -I/home/gus/.cache/node-gyp/20.10.0/deps/openssl/openssl/include -I/home/gus/.cache/node-gyp/20.10.0/deps/uv/include -I/home/gus/.cache/node-gyp/20.10.0/deps/zlib -I/home/gus/.cache/node-gyp/20.10.0/deps/v8/include -I../node_modules/nan -I../src  -fPIC -pthread -Wall -Wextra -Wno-unused-parameter -m64 -O3 -fno-omit-frame-pointer -fno-rtti -fno-exceptions -std=gnu++17 -MMD -MF ./Release/.deps/Release/obj.target/tree_sitter_mint_binding/bindings/node/binding.o.d.raw   -c
Release/obj.target/tree_sitter_mint_binding/bindings/node/binding.o: \
 ../bindings/node/binding.cc ../src/tree_sitter/parser.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/cppgc/common.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8config.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-array-buffer.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-local-handle.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-internal.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-version.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8config.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-object.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-maybe.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-persistent-handle.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-weak-callback-info.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-primitive.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-data.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-value.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-traced-handle.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-container.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-context.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-snapshot.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-date.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-debug.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-script.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-callbacks.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-promise.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-message.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-exception.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-extension.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-external.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-function.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-function-callback.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-template.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-memory-span.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-initialization.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-isolate.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-embedder-heap.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-microtask.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-statistics.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-unwinder.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-embedder-state-scope.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-platform.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-json.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-locker.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-microtask-queue.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-primitive-object.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-proxy.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-regexp.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-typed-array.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-value-serializer.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/v8-wasm.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node_version.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node_api.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/js_native_api.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/js_native_api_types.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node_api_types.h \
 ../node_modules/nan/nan.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node_version.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/uv.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/uv/errno.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/uv/version.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/uv/unix.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/uv/threadpool.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/uv/linux.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node_buffer.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node.h \
 /home/gus/.cache/node-gyp/20.10.0/include/node/node_object_wrap.h \
 ../node_modules/nan/nan_callbacks.h \
 ../node_modules/nan/nan_callbacks_12_inl.h \
 ../node_modules/nan/nan_maybe_43_inl.h \
 ../node_modules/nan/nan_converters.h \
 ../node_modules/nan/nan_converters_43_inl.h \
 ../node_modules/nan/nan_new.h \
 ../node_modules/nan/nan_implementation_12_inl.h \
 ../node_modules/nan/nan_persistent_12_inl.h \
 ../node_modules/nan/nan_weak.h ../node_modules/nan/nan_object_wrap.h \
 ../node_modules/nan/nan_private.h \
 ../node_modules/nan/nan_typedarray_contents.h \
 ../node_modules/nan/nan_json.h ../node_modules/nan/nan_scriptorigin.h
../bindings/node/binding.cc:
../src/tree_sitter/parser.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/cppgc/common.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8config.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-array-buffer.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-local-handle.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-internal.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-version.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8config.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-object.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-maybe.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-persistent-handle.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-weak-callback-info.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-primitive.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-data.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-value.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-traced-handle.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-container.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-context.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-snapshot.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-date.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-debug.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-script.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-callbacks.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-promise.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-message.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-exception.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-extension.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-external.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-function.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-function-callback.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-template.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-memory-span.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-initialization.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-isolate.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-embedder-heap.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-microtask.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-statistics.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-unwinder.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-embedder-state-scope.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-platform.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-json.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-locker.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-microtask-queue.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-primitive-object.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-proxy.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-regexp.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-typed-array.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-value-serializer.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/v8-wasm.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node_version.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node_api.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/js_native_api.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/js_native_api_types.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node_api_types.h:
../node_modules/nan/nan.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node_version.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/uv.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/uv/errno.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/uv/version.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/uv/unix.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/uv/threadpool.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/uv/linux.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node_buffer.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node.h:
/home/gus/.cache/node-gyp/20.10.0/include/node/node_object_wrap.h:
../node_modules/nan/nan_callbacks.h:
../node_modules/nan/nan_callbacks_12_inl.h:
../node_modules/nan/nan_maybe_43_inl.h:
../node_modules/nan/nan_converters.h:
../node_modules/nan/nan_converters_43_inl.h:
../node_modules/nan/nan_new.h:
../node_modules/nan/nan_implementation_12_inl.h:
../node_modules/nan/nan_persistent_12_inl.h:
../node_modules/nan/nan_weak.h:
../node_modules/nan/nan_object_wrap.h:
../node_modules/nan/nan_private.h:
../node_modules/nan/nan_typedarray_contents.h:
../node_modules/nan/nan_json.h:
../node_modules/nan/nan_scriptorigin.h:
