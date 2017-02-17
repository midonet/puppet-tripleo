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
# == Class: tripleo::network::midonet::config
#
# Configure Neutron properly and create the edge router as well as the
# initial networks
#
# == Parameters:
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
# [*edge_router_name*]
#   (Optional) Name that will be given to the edge router.
#   Defaults to hiera('nc_edge_router_name', undef)
#
# [*edge_network_name*]
#   (Optional) Name of the external network where the port will be bound.
#   Defaults to hiera('nc_edge_network_name', undef)
#
# [*edge_subnet_name*]
#   (Optional) Name of the subnet where the port will be bound.
#   Defaults to hiera('nc_edge_subnet_name', undef)
#
# [*edge_cidr*]
#   (Optional) CIDR of this network.
#   Defaults to hiera('nc_edge_cidr', undef)
#
# [*port_name*]
#   (Optional) Name of the neutron port.
#   Defaults to hiera('nc_port_name', undef)
#
# [*port_fixed_ip*]
#   (Optional) IP that the bound interface has.
#   Defaults to hiera('nc_port_fixed_ip', undef)
#
# [*port_interface_name*]
#   (Optional) Name of the bound interface.
#   Defaults to hiera('nc_port_interface_name', undef)
#
# [*gateway_ip*]
#   (Optional) IP of the edge router in the floating IP network.
#   Defaults to hiera('nc_gateway_ip', undef)
#
# [*subnet_cidr*]
#   (Optional) CIDR belonging to the floating IP network.
#   Defaults to hiera('nc_subnet_cidr', undef)
#
# [*allocation_pools*]
#   (Optional) Allocation pool on the FIP network.
#   Defaults to hiera('nc_allocation_pools', undef)
#
# [*neutron_tenant_name*]
#   (Optional) Tenant name that is being used with Neutron.
#   Defaults to hiera('neutron_auth_tenant', undef)
#
# [*neutron_service_providers*]
#   (Optional) Service providers to be used by Neutron.
#   Defaults to hiera('neutron_auth_tenant', undef)
#
# [*midonet_cluster_ip*]
# VIP of the MidoNet Cluster, where requests will be made.
# Defaults to hiera('midonet_cluster_vip', undef)
#
# [*midonet_cluster_port*]
# Port on which the MidoNet Cluster listens.
# Defaults to '8181'
#
# [*keystone_username*]
# Username to used to authenticate requests.
# Defaults to hiera('nova::network::neutron::neutron_username', undef)
#
# [*keystone_password*]
# Password for $keystone_username.
# Defaults to hiera('neutron::keystone::auth::password', undef)
#
# [*keystone_tenant*]
# Tenant on which $keystone_username has permissions.
# Defaults to hiera('neutron::keystone::auth::tenant', undef)
#
class tripleo::network::midonet::config(
  $edge_router_name          = hiera('nc_edge_router_name', undef),
  $edge_network_name         = hiera('nc_edge_network_name', undef),
  $edge_subnet_name          = hiera('nc_edge_subnet_name', undef),
  $edge_cidr                 = hiera('nc_edge_cidr', undef),
  $port_name                 = hiera('nc_port_name', undef),
  $port_fixed_ip             = hiera('nc_port_fixed_ip', undef),
  $port_interface_name       = hiera('nc_port_interface_name', undef),
  $gateway_ip                = hiera('nc_gateway_ip', undef),
  $subnet_cidr               = hiera('nc_subnet_cidr', undef),
  $allocation_pools          = hiera('nc_allocation_pools', undef),
  $neutron_tenant_name       = hiera('neutron_auth_tenant', undef),
  $neutron_service_providers = hiera('neutron_service_provider', undef),
  $midonet_cluster_ip        = hiera('midonet_cluster_vip', undef),
  $midonet_cluster_port      = '8181',
  $keystone_username         = hiera('nova::network::neutron::neutron_username', undef),
  $keystone_password         = hiera('neutron::keystone::auth::password', undef),
  $keystone_tenant           = hiera('neutron::keystone::auth::tenant', undef),
  $step                      = hiera('step'),
) {
  if $step >= 5 {
    anchor { 'network_creation::begin': } ->
    midonet::resources::network_creation { 'Edge Router Setup':
      tenant_name         => $neutron_tenant_name,
      edge_router_name    => $edge_router_name,
      edge_network_name   => $edge_network_name,
      edge_subnet_name    => $edge_subnet_name,
      edge_cidr           => $edge_cidr,
      port_name           => $port_name,
      port_fixed_ip       => $port_fixed_ip,
      port_interface_name => $port_interface_name,
      gateway_ip          => $gateway_ip,
      subnet_cidr         => $subnet_cidr,
      allocation_pools    => [$allocation_pools],
      binding_host_id     => $::fqdn,
      require             => Class['::neutron'],
    } ->
    anchor { 'network_creation::end': }
  }
  if $step >= 4 {
    if !defined(Neutron_config['service_providers/service_provider'])
    {
      neutron_config {
        'client': value => ['LOADBALANCERV2:Midonet:midonet.neutron.services.loadbalancer.v2_driver.MidonetLoadBalancerDriver:default']
      }
      Class['::midonet::neutron_plugin'] -> Neutron_config['service_providers/service_providers'] -> Service['neutron-server']
    }
    Neutron_config<| title == 'service_providers/service_provider' |> {
      value => $neutron_service_providers,
    }

    neutron_plugin_midonet {
      'MIDONET/client': value => 'midonet_ext.neutron.client.api.MidonetApiClient';
    }

    class { '::neutron::plugins::midonet':
      midonet_api_ip    => $midonet_cluster_ip,
      midonet_api_port  => $midonet_cluster_port,
      keystone_username => $keystone_username,
      keystone_password => $keystone_password,
      keystone_tenant   => $keystone_tenant,
      sync_db           => true,
    }
  }
}
