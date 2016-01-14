require 'chef'
require 'chef/node/immutable_collections'
require './libraries/mongodb3_helper'

describe 'Mongodb3Helper' do
  subject do
    Class.new do
      extend Mongodb3Helper
    end
  end
  context '#mongodb_config' do
    let(:config) { Chef::Node::ImmutableMash.new('systemLog' => { 'verbosity' => nil, 'path' => '/var/log', 'empty' => { 'foo' => nil } }) }
    it 'with an immutable Mash' do
      expect(YAML.load(subject.mongodb_config(config))).to eq('systemLog' => { 'path' => '/var/log' })
    end
  end
end
