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

require 'spec_helper'

describe 'tripleo::network::midonet::nsdb' do

  shared_examples_for 'tripleo::network::midonet::nsdb' do

    let :params do
      {
        :step => 4,
      }
    end

    it 'should install Java on the target system' do
        is_expected.to contain_class('midonet_openstack::profile::midojava::midojava')
    end

    it 'should install and configure Zookeeper' do
        is_expected.to contain_class('midonet_openstack::profile::zookeeper::midozookeeper')
    end

    it 'should install and configure Cassandra' do
        is_expected.to contain_class('midonet_openstack::profile::cassandra::midocassandra')
    end

  end


  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({})
      end

      it_behaves_like 'tripleo::network::midonet::nsdb'
    end
  end

end
