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
# == Class: tripleo::network::midonet::agent
#
# Configure the MidoNet Agent, MidoNet CLI, configure a set of initial
# networks and register the node in the MidoNet registry
#
# == Parameters:
#
# [*controller_host*]
#   (Optional) IP pointing to the controller.
#   Defaults to hiera('controller_host_ip', undef)
#
# [*midonet_cluster_vip*]
#   (Optional) VIP for the MidoNet Cluster.
#   Defaults to hiera('midonet_cluster_vip', undef)
#
# [*zookeeper_hosts*]
#   (Optional) Array containing the IPs of the hosts that run Zookeeper.
#   Defaults to hiera('midonet_nsdb_node_ips', ['127.0.0.1'])
#
# [*tunnelzone_type*]
#   (Optional) Tunnelzone type to be used when registering the host.
#   Defaults to hiera('tunnelzone_type', 'gre')
#
# [*metadata_port*]
#   (Optional) Port on which the Metadata service listens.
#   Defaults to hiera('metadata_port', '8775')
#
# [*shared_secret*]
#   (Optional) Neutron shared secret.
#   Defaults to hiera('neutron_shared_secret', undef)
#
# [*manage_repo*]
#   (Optional) Whether to manage the MidoNet repositories or not.
#   Defaults to hiera('midonet_manage_repos', false)
#
# [*username*]
#   (Optional) Username that will be used to connect to Keystone.
#  Defaults to hiera('admin_username', 'admin')
#
# [*password*]
#   (Optional) Password for this user.
#  Defaults to hiera('admin_password', undef)
#
# [*is_mem*]
#   (Optional) Whether is the enterprise version of MidoNet or not.
#   Defaults to hiera('step')
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::network::midonet::agent (
  $controller_host     = hiera('controller_virtual_ip', undef),
  $midonet_cluster_vip = hiera('midonet_cluster_vip', undef),
  $zookeeper_hosts     = hiera('midonet_nsdb_node_ips', ['127.0.0.1']),
  $tunnelzone_type     = hiera('tunnelzone_type', 'gre'),
  $metadata_port       = hiera('metadata_port', '8775'),
  $shared_secret       = hiera('neutron_shared_secret', undef),
  $manage_repo         = hiera('midonet_manage_repos', false),
  $username            = hiera('admin_username', 'admin'),
  $password            = hiera('admin_password', undef),
  $is_mem              = hiera('midonet_version', 'oss'),
  $step                = hiera('step'),
) {
  include ::midonet_openstack::profile::midojava::midojava

  $mem = $is_mem ? {
    'mem'   => true,
    'oss'   => false,
    default => false
  }

  # midonet-cluster might be running on the base image. This ensures that
  # the service is stopped in nodes other than the controller.
  if ! defined("tripleo::network::midonet::cluster") {
    service { 'midonet-cluster': ensure => stopped }
  }

  if $step >= 4 {
    class { '::midonet::cli':
      username => $username,
      password => $password,
    }
    class { '::midonet::agent':
      controller_host => $controller_host,
      metadata_port   => $metadata_port,
      shared_secret   => $shared_secret,
      manage_repo     => $manage_repo,
      zookeeper_hosts => generate_api_zookeeper_ips($zookeeper_hosts),
      is_mem          => $mem,
      require         => Class['::midonet_openstack::profile::midojava::midojava'],
    }
  }

  if $step >= 5 {
    midonet_host_registry { $::fqdn:
      ensure          => present,
      midonet_api_url => "http://${midonet_cluster_vip}:8181",
      tunnelzone_type => $tunnelzone_type,
      username        => $username,
      password        => $password,
    }
  }
}
