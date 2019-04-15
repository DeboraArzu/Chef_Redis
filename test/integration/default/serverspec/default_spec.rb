#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    let(:version) {'2.8.9'}

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'update the package repository' do
      expect(chef_run).to run_execute('apt-get update')
    end

    it 'installs the necessary packages' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'retrieves the application from source' do
      expect(chef_run).to create_remote_file("/tmp/redis-#{version}.tar.gz")
    end

    it 'unzips the application' do
      expect(chef_run).to nothing_execute('unzip_redis_archive')
    end

    it 'build it and installs the application' do
      expect(chef_run).to nothing_execute('redis_build_and_install')
    end

    it 'installs redis server' do
      expect(chef_run).to nothing_execute('echo -n | ./install_server.sh')
    end

    it 'start the service' do
      expect(chef_run).to start_service('redis_6379')
    end

  end
end
