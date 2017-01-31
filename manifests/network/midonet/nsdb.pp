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
# == Class: tripleo::network::midonet::nsdb
#
# Configure Zookeeper and Cassandra (NSDB node)
#
# == Parameters:
#
# [*zookeeper_cfg_dir*]
#   (Optional) Zookeeper configuration directory.
#   Defaults to hiera('zookeeper_cfg_dir', undef)
#
# [*client_ip*]
#   (Optional) IP where Zookeeper and Cassandra will bind their ports.
#   Defaults to $::ipaddress
#
# [*nsdb_nodes*]
#   (Optional) Array containing the IPs of the nodes that run Zookeeper and Cassandra
#   Defaults to hiera('midonet_nsdb_node_ips', ['127.0.0.1'])
#
# [*controller_nodes*]
#   (Optional) Array containing the IPs of the controller nodes
#   Defaults to hiera('controller_node_names', undef)
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::network::midonet::nsdb(
  $client_ip            = $::ipaddress,
  $zookeeper_cfg_dir    = hiera('zookeeper_cfg_dir', undef),
  $nsdb_nodes           = hiera('midonet_nsdb_node_ips', ['127.0.0.1']),
  $controller_nodes     = hiera('controller_node_names', undef),
  $step                 = hiera('step'),
) {
  if $step >= 3 {
    include ::midonet_openstack::profile::midojava::midojava

    anchor { 'zookeeper_begin': } ->
    class { '::midonet_openstack::profile::zookeeper::midozookeeper':
      zk_servers => $nsdb_nodes,
      id         => extract_id($controller_nodes, $::hostname),
      client_ip  => $client_ip,
      require    => Class['midonet_openstack::profile::midojava::midojava'],
    } ->
    anchor { 'zookeeper_end': }

    anchor { 'cassandra_begin': } ->
    class { '::midonet_openstack::profile::cassandra::midocassandra':
      seeds        => join($nsdb_nodes, ','),
      seed_address => $client_ip,
      require      => Anchor['zookeeper_end'],
    } ->
    anchor { 'cassandra_end': }
  }
}
