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
#
# == Class: tripleo::network::midonet::insights
#
# Configure MidoNet Insights (analytics)
#
# == Parameters:
#
# [*heap_size_gb*]
#   (Optional) Heap size that the JVM will allocate to run Insights.
#   Defaults to hiera('insights_heap_size', undef)
#
# [*allinone*]
#   (Optional) Set to true if this an all-in-one deployment.
#   Defaults to hiera('insights_allinone', true)
#
# [*calliope_port*]
#   (Optional) Set to true if this an all-in-one deployment.
#   Defaults to hiera('insights_allinone', true)
#
# [*zookeeper_hosts*]
#   (Optional) Array containing the IPs of the hosts running Zookeeper.
#   Defaults to hiera('insights_allinone', true)
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::network::midonet::insights(
  $heap_size_gb         = hiera('insights_heap_size', undef),
  $allinone             = hiera('insights_allinone', true),
  $calliope_port        = hiera('insights_calliope_port', undef),
  $zookeeper_hosts      = hiera('midonet_nsdb_node_ips', ['127.0.0.1']),
  $step                 = hiera('step'),
) {
  if $step >= 4 {
    include ::midonet_openstack::profile::midojava::midojava

    class { '::midonet::analytics':
      heap_size_gb    => $heap_size_gb,
      allinone        => $allinone,
      calliope_port   => $calliope_port,
      zookeeper_hosts => generate_api_zookeeper_ips($zookeeper_hosts),
    }
  }
}
