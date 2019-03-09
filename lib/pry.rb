require 'pp'
require 'pry/forwardable'
require 'pry/input_lock'
require 'pry/exceptions'
require 'pry/helpers/base_helpers'
require 'pry/hooks'

class Pry
  # Deal with the ^D key being pressed. Different behaviour in different cases:
  #   1. In an expression behave like `!` command.
  #   2. At top-level session behave like `exit` command.
  #   3. In a nested session behave like `cd ..`.
  DEFAULT_CONTROL_D_HANDLER = proc do |eval_string, _pry_|
    if !eval_string.empty?
      eval_string.replace('') # Clear input buffer.
    elsif _pry_.binding_stack.one?
      _pry_.binding_stack.clear
      throw(:breakout)
    else
      # Otherwise, saves current binding stack as old stack and pops last
      # binding out of binding stack (the old stack still has that binding).
      _pry_.command_state["cd"] ||= Pry::Config.from_hash({})
      _pry_.command_state['cd'].old_stack = _pry_.binding_stack.dup
      _pry_.binding_stack.pop
    end
  end

  DEFAULT_SYSTEM = proc do |output, cmd, _|
    unless system(cmd)
      output.puts "Error: there was a problem executing system command: #{cmd}"
    end
  end

  # This is to keep from breaking under Rails 3.2 for people who are doing that
  # IRB = Pry thing.
  module ExtendCommandBundle; end
end

require 'method_source'
require 'shellwords'
require 'stringio'
require 'strscan'
require 'coderay'
require 'pry/slop'
require 'rbconfig'
require 'tempfile'
require 'pathname'

require 'pry/version'
require 'pry/last_exception'
require 'pry/input_completer'
require 'pry/repl'
require 'pry/code'
require 'pry/ring'
require 'pry/helpers'
require 'pry/code_object'
require 'pry/method'
require 'pry/wrapped_module'
require 'pry/history'
require 'pry/command'
require 'pry/command_set'
require 'pry/commands'
require 'pry/plugins'
require 'pry/core_extensions'
require 'pry/basic_object'
require "pry/prompt"
require 'pry/config/lazy'
require 'pry/config/behavior'
require 'pry/config/convenience'
require 'pry/config'
require 'pry/pry_class'
require 'pry/pry_instance'
require 'pry/cli'
require 'pry/color_printer'
require 'pry/pager'
require 'pry/terminal'
require 'pry/editor'
require 'pry/rubygem'
require "pry/indent"
require "pry/inspector"
require 'pry/object_path'
require 'pry/output'
