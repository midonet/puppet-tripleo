#
# Copyright (C) 2016 Midokura SARL
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe 'tripleo::network::midonet::config' do

  shared_examples_for 'tripleo::network::midonet::config' do

    context 'with step 2' do
      let :params do
        {
          :step => 2,
        }
      end

      it 'should not create a set of initial networks' do
        is_expected.to_not contain_midonet__resources__network_creation('Edge Router Setup')
      end
    end

    context 'with step 5' do
      let :params do
        {
          :step                => 5,
          :port_interface_name => 'enp0s3',
          :neutron_tenant_name => 'my_tenant',
          :edge_router_name    => 'my_edge_router',
          :edge_network_name   => 'my_edge_network',
          :edge_subnet_name    => 'my_edge_subnet',
          :port_name           => 'my_port',
        }
      end

      before(:each) do
        Puppet::Parser::Functions.newfunction(:c7_int_name, :type => :rvalue) { |args|
          raise ArgumentError, 'expected modern interface name' unless args[0] == 'enp0s3'
          'eth0'
        }
      end

      it 'should create a set of initial networks' do
        is_expected.to contain_midonet__resources__network_creation('Edge Router Setup')
      end
    end
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :hostname => 'node.example.com',
          :fqdn     => 'node.example.com',
        })
      end

      it_behaves_like 'tripleo::network::midonet::config'
    end
  end
end
