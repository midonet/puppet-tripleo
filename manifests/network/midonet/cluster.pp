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
# == Class: tripleo::network::midonet::cluster
#
# Configure the MidoNet Cluster (formerly known as MidoNet API)
#
# == Parameters:
#
# [*is_insights*]
#   (Optional) Whether this deployment uses MidoNet Insights or not.
#   Defaults to hiera('cluster_is_insights', undef)
#
# [*keystone_host*]
#   (Optional) Keystone VIP so the Cluster can authenticate.
#   Defaults to hiera('keystone_host', undef)
#
# [*keystone_user_name*]
#   (Optional) Keystone user to be used (must have the admin role)
#   Defaults to hiera('midonet_cluster_user', undef)
#
# [*keystone_user_password*]
#   (Optional) Password for this user
#   Defaults to hiera('midonet_cluster_pass', undef)
#
# [*keystone_tenant_name*]
#   (Optional) Keystone tenant where this user has the admin role
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*nsdb_nodes*]
#   (Optional) A list of IPs of the hosts that run Zookeeper.
#   Defaults to hiera('midonet_nsdb_node_ips', undef)
#
# [*max_heap_size*]
#   (Optional) Maximum heap size.
#   Defaults to hiera('midonet_cluster_heap', undef)
#
# [*heap_newsize*]
#   (Optional) Heap new size.
#   Defaults to hiera('midonet_cluster_heap_newsize', undef)
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::network::midonet::cluster (
  $is_insights            = hiera('cluster_is_insights', undef),
  $keystone_host          = hiera('keystone_host', '127.0.0.1'),
  $nsdb_nodes             = hiera('midonet_nsdb_node_ips', ['127.0.0.1']),
  $keystone_user_name     = hiera('midonet_cluster_user', undef),
  $keystone_user_password = hiera('midonet_cluster_pass', undef),
  $keystone_tenant_name   = hiera('midonet_cluster_tenant', undef),
  $max_heap_size          = hiera('midonet_cluster_heap', undef),
  $heap_newsize           = hiera('midonet_cluster_heap_newsize', undef),
  $step                   = hiera('step'),
) {
  if $step >= 4 {
    include ::midonet_openstack::profile::midojava::midojava

    anchor { 'mn-cluster_begin': } ->
    class { '::midonet::cluster':
      keystone_host          => $keystone_host,
      keystone_user_name     => $keystone_user_name,
      keystone_user_password => $keystone_user_password,
      keystone_tenant_name   => $keystone_tenant_name,
      zookeeper_hosts        => generate_api_zookeeper_ips($nsdb_nodes),
      cassandra_servers      => $nsdb_nodes,
      cassandra_rep_factor   => count($nsdb_nodes),
      is_insights            => $is_insights,
      require                => Class['::midonet_openstack::profile::midojava::midojava'],
    } ->
    anchor { 'mn-cluster_end': }
  }
}
