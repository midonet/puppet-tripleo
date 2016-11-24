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

describe 'tripleo::network::midonet::gateway' do

  shared_examples_for 'tripleo::network::midonet::gateway' do

    context 'with step 3' do
      let :params do
        {
          :step        => 3,
        }
      end

      it 'should do nothing' do
        is_expected.to_not contain_class('midonet::gateway::static')
        is_expected.to_not contain_midonet_gateway_bgp('edge-router')
      end
    end

    context 'with step 4 and static uplink set' do
      let :params do
        {
          :step        => 4,
          :uplink_type => 'static',
        }
      end

      it 'should set up a static uplink' do
        is_expected.to contain_class('midonet::gateway::static')
      end
    end

    context 'with step 4 and bgp uplink set' do
      let :params do
        {
          :step               => 4,
          :uplink_type        => 'bgp',
          :bgp_neighbors_ips  => ['192.168.0.1', '192.168.0.2'],
          :bgp_neighbors_asns => ['12345', '23456'],
          :bgp_neighbors_nets => ['192.168.0.0', '192.168.0.0'],
        }
      end

      it 'should set up a bgp uplink' do
        is_expected.to contain_midonet_gateway_bgp('edge-router')
      end
    end
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({ :hostname => 'node.example.com' })
      end

      it_behaves_like 'tripleo::network::midonet::gateway'
    end
  end
end
