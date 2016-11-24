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

describe 'tripleo::network::midonet::cluster' do

  shared_examples_for 'tripleo::network::midonet::cluster' do

    context 'with step 3' do
      let :params do
        {
          :step => 3,
        }
      end

      it 'should do nothing' do
          is_expected.to_not contain_class('midonet_openstack::profile::midojava::midojava')
          is_expected.to_not contain_class('midonet::cluster')
      end
    end

    context 'with step 4' do
      let :params do
        {
          :step => 4,
        }
      end

      it 'should install Java on the target system' do
          is_expected.to contain_class('midonet_openstack::profile::midojava::midojava')
      end
      it 'should install the MidoNet Cluster on the target system' do
          is_expected.to contain_class('midonet::cluster')
      end
    end

  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({ :hostname => 'node.example.com' })
      end

      it_behaves_like 'tripleo::network::midonet::cluster'
    end
  end
end
