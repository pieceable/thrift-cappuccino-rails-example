
require 'thrift'

$:.push('gen-rb')
require 'shared_service'
require 'calculator'

class CalculatorHandler
  def initialize()
    @log = {}
  end

  def ping()
    puts "ping()"
  end

  def add(n1, n2)
    print "add(", n1, ",", n2, ")\n"
    return n1 + n2
  end

  def calculate(logid, work)
    print "calculate(", logid, ", {", work.op, ",", work.num1, ",", work.num2,"})\n"
    if work.op == Operation::ADD
      val = work.num1 + work.num2
    elsif work.op == Operation::SUBTRACT
      val = work.num1 - work.num2
    elsif work.op == Operation::MULTIPLY
      val = work.num1 * work.num2
    elsif work.op == Operation::DIVIDE
      if work.num2 == 0
        x = InvalidOperation.new()
        x.what = work.op
        x.why = "Cannot divide by 0"
        raise x
      end
      val = work.num1 / work.num2
    else
      x = InvalidOperation.new()
      x.what = work.op
      x.why = "Invalid operation"
      raise x
    end

    entry = SharedStruct.new()
    entry.key = logid
    entry.value = "#{val}"
    @log[logid] = entry

    return val

  end

  def getStruct(key)
    print "getStruct(", key, ")\n"
    return @log[key]
  end

  def zip()
    print "zip\n"
  end
end

def urlsafe_base64_decode(str)
  str.gsub!(/\-/, '+')
  str.gsub!(/_/, '/')
  
  Base64.decode64(str)
end

def urlsafe_base64_encode(str)
  str = Base64.encode64(str)
  str.gsub!(/\+/, '-')
  str.gsub!(/\//, '_')
  
  return str
end

class ThriftController < ApplicationController
  # Don't bother with InvalidAuthenticityToken checks
  skip_before_filter :verify_authenticity_token
  
  def index
      input_buffer = urlsafe_base64_decode(request.raw_post)
      output_buffer = StringIO.new

      handler = CalculatorHandler.new()
      processor = Calculator::Processor.new(handler)

      transport = Thrift::IOStreamTransport.new StringIO.new(input_buffer), output_buffer
      protocol_factory = Thrift::BinaryProtocolFactory.new()
      protocol = protocol_factory.get_protocol transport

      processor.process protocol, protocol

      send_data urlsafe_base64_encode(output_buffer.string)
    end
end
