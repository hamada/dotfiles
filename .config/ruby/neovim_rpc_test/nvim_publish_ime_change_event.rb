#!/usr/bin/env ruby
# Requires msgpack-rpc: gem install msgpack-rpc
#
# To run this script, execute it from a running Nvim instance (notice the
# trailing '&' which is required since Nvim won't process events while
# running a blocking command):
#
#   :!./nvim_publish_ime_change_event.rb &
#
# Or from another shell by setting NVIM_LISTEN_ADDRESS:
# $ NVIM_LISTEN_ADDRESS=127.0.0.1 NVIM_LISTEN_PORT=22222 ./nvim_publish_ime_change_event.rb
require 'msgpack/rpc'
require 'msgpack/rpc/transport/unix'

nvim_client = MessagePack::RPC::Client
                .new(ENV['NVIM_LISTEN_ADDRESS'], ENV['NVIM_LISTEN_PORT'])

# ARGV[0] is 'activated' or 'deactivated'
result = nvim_client.call(:nvim_command, "doautocmd User Ime#{ARGV[0].capitalize}")
