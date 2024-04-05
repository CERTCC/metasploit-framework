# -*- coding: binary -*-

require 'spec_helper'
require 'rex/proto/mysql/client'

RSpec.describe Rex::Proto::MySQL::Client do
  let(:host) { '127.0.0.1' }
  let(:port) { 1234 }
  let(:info) { "#{host}:#{port}" }
  let(:db_name) { 'my_db_name' }

  subject do
    addr_info = instance_double(Addrinfo, ip_address: host, ip_port: port)
    socket = instance_double(Socket, remote_address: addr_info)
    client = described_class.new(io: socket)
    allow(client).to receive(:session_track).and_return({ 1 => [db_name] })
    client
  end

  it { is_expected.to be_a ::Mysql }

  it_behaves_like 'session compatible SQL client'

  describe '#current_database' do
    context 'we have not selected a database yet' do
      before(:each) do
        allow(subject).to receive(:session_track).and_return({})
      end

      it 'returns an empty database name' do
        expect(subject.current_database).to eq('')
      end
    end
  end
end
