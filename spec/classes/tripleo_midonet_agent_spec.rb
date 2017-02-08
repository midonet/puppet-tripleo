#
# Copyright (C) 2015 Midokura SARL
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
#
# Unit tests for the midonet agent

require 'spec_helper'

describe 'tripleo::network::midonet::agent' do

  shared_examples_for 'tripleo::network::midonet::agent' do

    context 'with step 4' do
      let :params do
        {
          :step => 4,
        }
      end

      it 'should install Java on the target system' do
        is_expected.to contain_class('midonet_openstack::profile::midojava::midojava')
      end

      it 'should install the MidoNet CLI package' do
        is_expected.to contain_class('midonet::cli')
      end

      it 'should install the MidoNet Agent' do
        is_expected.to contain_class('midonet::agent')
      end
    end

    context 'with step 5' do
      let :params do
        {
          :step => 5,
        }
      end

      it 'should register the host in the MidoNet registry' do
        is_expected.to contain_midonet_host_registry('node.example.com')
      end
    end
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :hostname => 'node.example.com',
          :fqdn     => 'node.example.com'
        })
      end

      it_behaves_like 'tripleo::network::midonet::agent'
    end
  end
end
