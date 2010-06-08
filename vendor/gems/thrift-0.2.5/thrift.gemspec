# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{thrift}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2.0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kevin Ballard, Kevin Clark, Mark Slee"]
  s.date = %q{2010-06-08}
  s.description = %q{Ruby libraries for Thrift (a language-agnostic RPC system)}
  s.email = ["kevin@sb.org", "kevin.clark@gmail.com", "mcslee@facebook.com"]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "README", "ext/binary_protocol_accelerated.c", "ext/binary_protocol_accelerated.h", "ext/compact_protocol.c", "ext/compact_protocol.h", "ext/constants.h", "ext/extconf.rb", "ext/macros.h", "ext/memory_buffer.c", "ext/memory_buffer.h", "ext/protocol.c", "ext/protocol.h", "ext/struct.c", "ext/struct.h", "ext/thrift_native.c", "lib/thrift.rb", "lib/thrift/client.rb", "lib/thrift/core_ext.rb", "lib/thrift/exceptions.rb", "lib/thrift/processor.rb", "lib/thrift/struct.rb", "lib/thrift/struct_union.rb", "lib/thrift/union.rb", "lib/thrift/thrift_native.rb", "lib/thrift/types.rb", "lib/thrift/core_ext/fixnum.rb", "lib/thrift/protocol/base_protocol.rb", "lib/thrift/protocol/binary_protocol.rb", "lib/thrift/protocol/binary_protocol_accelerated.rb", "lib/thrift/protocol/compact_protocol.rb", "lib/thrift/serializer/deserializer.rb", "lib/thrift/serializer/serializer.rb", "lib/thrift/server/base_server.rb", "lib/thrift/server/mongrel_http_server.rb", "lib/thrift/server/nonblocking_server.rb", "lib/thrift/server/simple_server.rb", "lib/thrift/server/thread_pool_server.rb", "lib/thrift/server/threaded_server.rb", "lib/thrift/transport/base_server_transport.rb", "lib/thrift/transport/base_transport.rb", "lib/thrift/transport/buffered_transport.rb", "lib/thrift/transport/framed_transport.rb", "lib/thrift/transport/http_client_transport.rb", "lib/thrift/transport/io_stream_transport.rb", "lib/thrift/transport/memory_buffer_transport.rb", "lib/thrift/transport/server_socket.rb", "lib/thrift/transport/socket.rb", "lib/thrift/transport/unix_server_socket.rb", "lib/thrift/transport/unix_socket.rb"]
  s.files = ["CHANGELOG", "Manifest", "Rakefile", "README", "setup.rb", "benchmark/benchmark.rb", "benchmark/Benchmark.thrift", "benchmark/client.rb", "benchmark/server.rb", "benchmark/thin_server.rb", "ext/binary_protocol_accelerated.c", "ext/binary_protocol_accelerated.h", "ext/compact_protocol.c", "ext/compact_protocol.h", "ext/constants.h", "ext/extconf.rb", "ext/macros.h", "ext/memory_buffer.c", "ext/memory_buffer.h", "ext/protocol.c", "ext/protocol.h", "ext/struct.c", "ext/struct.h", "ext/thrift_native.c", "lib/thrift.rb", "lib/thrift/client.rb", "lib/thrift/core_ext.rb", "lib/thrift/exceptions.rb", "lib/thrift/processor.rb", "lib/thrift/struct.rb", "lib/thrift/struct_union.rb", "lib/thrift/union.rb", "lib/thrift/thrift_native.rb", "lib/thrift/types.rb", "lib/thrift/core_ext/fixnum.rb", "lib/thrift/protocol/base_protocol.rb", "lib/thrift/protocol/binary_protocol.rb", "lib/thrift/protocol/binary_protocol_accelerated.rb", "lib/thrift/protocol/compact_protocol.rb", "lib/thrift/serializer/deserializer.rb", "lib/thrift/serializer/serializer.rb", "lib/thrift/server/base_server.rb", "lib/thrift/server/mongrel_http_server.rb", "lib/thrift/server/nonblocking_server.rb", "lib/thrift/server/simple_server.rb", "lib/thrift/server/thread_pool_server.rb", "lib/thrift/server/threaded_server.rb", "lib/thrift/transport/base_server_transport.rb", "lib/thrift/transport/base_transport.rb", "lib/thrift/transport/buffered_transport.rb", "lib/thrift/transport/framed_transport.rb", "lib/thrift/transport/http_client_transport.rb", "lib/thrift/transport/io_stream_transport.rb", "lib/thrift/transport/memory_buffer_transport.rb", "lib/thrift/transport/server_socket.rb", "lib/thrift/transport/socket.rb", "lib/thrift/transport/unix_server_socket.rb", "lib/thrift/transport/unix_socket.rb", "script/proto_benchmark.rb", "script/read_struct.rb", "script/write_struct.rb", "spec/base_protocol_spec.rb", "spec/base_transport_spec.rb", "spec/binary_protocol_accelerated_spec.rb", "spec/binary_protocol_spec.rb", "spec/binary_protocol_spec_shared.rb", "spec/client_spec.rb", "spec/compact_protocol_spec.rb", "spec/exception_spec.rb", "spec/http_client_spec.rb", "spec/mongrel_http_server_spec.rb", "spec/nonblocking_server_spec.rb", "spec/processor_spec.rb", "spec/serializer_spec.rb", "spec/server_socket_spec.rb", "spec/server_spec.rb", "spec/socket_spec.rb", "spec/socket_spec_shared.rb", "spec/spec_helper.rb", "spec/struct_spec.rb", "spec/union_spec.rb", "spec/ThriftSpec.thrift", "spec/types_spec.rb", "spec/unix_socket_spec.rb", "thrift.gemspec"]
  s.homepage = %q{http://incubator.apache.org/thrift/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Thrift", "--main", "README"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{thrift}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby libraries for Thrift (a language-agnostic RPC system)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
