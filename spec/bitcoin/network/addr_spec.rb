require_relative '../spec_helper.rb'

require 'bitcoin/network'

describe 'Bitcoin::Protocol::Parser (addr)' do

  it 'parses transaction inv' do

    pkt = [
      "f9 be b4 d9 61 64 64 72 00 00 00 00 00 00 00 00 1f 00 00 00 e8 b4 c9 ba 01 2b dd d7 4d 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff ff 52 53 de 04 20 8d"
      .split(" ").join].pack("H*")

    class Addr_Handler < Bitcoin::Protocol::Handler
      attr_reader :addr
      def on_addr(addr); (@addr ||= []) << addr; end
    end

    parser = Bitcoin::Protocol::Parser.new( handler = Addr_Handler.new )
    parser.parse(pkt + "AAAA").should == "AAAA"

    handler.addr.size              .should == 1
    handler.addr.first.alive?      .should == false
    handler.addr.map{|i| i.values }.should == [
      [1305992491, 1, "82.83.222.4", 8333]
    ]
  end

end
