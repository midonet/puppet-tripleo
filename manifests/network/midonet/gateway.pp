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
# == Class: tripleo::network::midonet::gateway
#
# Configure the uplink on a gateway node
#
# == Parameters:
#
# [*static_nic*]
#   (Optional) Name of the interface through which the egress traffic will go.
#   Defaults to hiera('static_nic', undef)
#
# [*static_fip*]
#   (Optional) Floating IP network (must include netmask).
#   Defaults to hiera('static_fip', undef)
#
# [*static_edge_router*]
#   (Optional) Name of the edge router.
#   Defaults to hiera('static_edge_router', undef)
#
# [*static_veth0_ip*]
#   (Optional) IP address for one of the two virtual interfaces (dont
#   change unless it collides with another network).
#   Defaults to hiera('static_veth0_ip', undef)
#
# [*static_veth1_ip*]
#   (Optional) IP address for the other virtual interface.
#   Defaults to hiera('static_veth1_ip', undef)
#
# [*static_veth_network*]
#   (Optional) IP network that comprises both IPs defined above.
#   Defaults to hiera('static_veth_network', undef)
#
# [*static_scripts_dir*]
#   (Optional) Directory where the script to set up the uplink will be
#   contained (no trailing slash).
#   Defaults to hiera('static_scripts_dir', undef)
#
# [*static_uplink_script*]
#   (Optional) Name for the script that sets up the static uplink.
#   Defaults to hiera('static_uplink_script', undef)
#
# [*static_ensure_scripts*]
#   (Optional) Whether you want the scripts in your system or not (must be
#   present on the 1st run).
#   Defaults to hiera('static_ensure_scripts', undef)
#
# [*static_port_name*]
#   (Optional) Name of the Neutron port that will be attached to an actual
#   interface.
#   Defaults to hiera('static_port_name', undef)
#
# [*static_subnet_name*]
#   (Optional) Name of the subnet that will be created.
#   Defaults to hiera('static_subnet_name', undef)
#
# [*static_network_name*]
#   (Optional) Name of the network that will be created.
#   Defaults to hiera('static_network_name', undef)
#
# [*static_gateway_ip*]
#   (Optional) IP address that the gateway will have (in the floating IP
#   network).
#   Defaults to hiera('static_gateway_ip', undef)
#
# [*static_subnet_cidr*]
#   (Optional) CIDR of the floating IP network.
#   Defaults to hiera('static_subnet_cidr', undef)
#
# [*static_allocation_pools*]
#   (Optional) Start and end of the floating IP range.
#   Defaults to hiera('static_allocation_pools', undef)
#
# [*bgp_local_as_number*]
#   (Optional) Local AS number.
#   Defaults to hiera('bgp_local_as_number', undef)
#
# [*bgp_advertised_networks*]
#   (Optional) Floating IP networks that are being advertised.
#   Defaults to hiera('bgp_advertised_networks', undef)
#
# [*bgp_neighbors_ips*]
#   (Optional) Array containing the IPs of the BGP neighbors.
#   Defaults to hiera('bgp_neighbors_ips', undef)
#
# [*bgp_neighbors_asns*]
#   (Optional) Array containing the ASNs of the neighbors.
#   Detaults to hiera('bgp_neighbors_asns', undef)
#
# [*bgp_neighbors_nets*]
#   (Optional) Array containing the networks in which the BGP neighbors are.
#   Defaults to hiera('bgp_neighbors_nets', undef)
#
# [*uplink_type*]
#   (Optional) Uplink to be configured. Can be set to "BGP" or "static".
#   Defaults to hiera('midonet_uplink_type', undef)
#
# [*midonet_cluster_vip*]
#   (Optional) VIP for the MidoNet Cluster.
#   Defaults to hiera('midonet_uplink_type', undef)
#
# [*username*]
#   (Optional) User used by MidoNet to authenticate against Keystone.
#   Defaults to hiera('midonet_username', 'admin')
#
# [*password*]
#   (Optional) Password of this user.
#   Defaults to hiera('midonet_password', undef)
#
# [*tenant*]
#   (Optional) Tenant name where this user resides.
#   Defaults to hiera('auth_tenant', 'admin')
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::network::midonet::gateway(
  $static_nic              = hiera('static_nic', undef),
  $static_fip              = hiera('static_fip', undef),
  $static_edge_router      = hiera('static_edge_router', undef),
  $static_veth0_ip         = hiera('static_veth0_ip', undef),
  $static_veth1_ip         = hiera('static_veth1_ip', undef),
  $static_veth_network     = hiera('static_veth_network', undef),
  $static_scripts_dir      = hiera('static_scripts_dir', undef),
  $static_uplink_script    = hiera('static_uplink_script', undef),
  $static_ensure_scripts   = hiera('static_ensure_scripts', undef),
  $static_port_name        = hiera('static_port_name', undef),
  $static_subnet_name      = hiera('static_subnet_name', undef),
  $static_network_name     = hiera('static_network_name', undef),
  $static_gateway_ip       = hiera('static_gateway_ip', undef),
  $static_subnet_cidr      = hiera('static_subnet_cidr', undef),
  $static_allocation_pools = hiera('static_allocation_pools', undef),
  $bgp_local_as_number     = hiera('bgp_local_as_number', undef),
  $bgp_advertised_networks = hiera('bgp_advertised_networks', undef),
  $bgp_neighbors_ips       = hiera('bgp_neighbors_ips', undef),
  $bgp_neighbors_asns      = hiera('bgp_neighbors_asns', undef),
  $bgp_neighbors_nets      = hiera('bgp_neighbors_nets', undef),
  $uplink_type             = hiera('midonet_uplink_type', undef),
  $midonet_cluster_vip     = hiera('midonet_cluster_vip', undef),
  $username                = hiera('midonet_username', 'admin'),
  $password                = hiera('midonet_password', undef),
  $tenant                  = hiera('auth_tenant', 'admin'),
  $bootstrap_node          = hiera('bootstrap_nodeid', undef),
  $step                    = hiera('step'),
) {


  if $step >= 5 and $::hostname == downcase($bootstrap_node) {

    if $uplink_type == 'static' {
      anchor { 'gateway_config::begin': } ->
      class { '::midonet::gateway::static':
        nic            => $static_nic,
        fip            => $static_fip,
        edge_router    => $static_edge_router,
        veth0_ip       => $static_veth0_ip,
        veth1_ip       => $static_veth1_ip,
        veth_network   => $static_veth_network,
        scripts_dir    => $static_scripts_dir,
        uplink_script  => $static_uplink_script,
        ensure_scripts => $static_ensure_scripts,
      } ->
      anchor { 'gateway_config::end': }
    }
    elsif $uplink_type == 'bgp' {
      anchor { 'gateway_config::begin': } ->
      midonet_gateway_bgp { 'edge-router':
        ensure                  => present,
        bgp_local_as_number     => $bgp_local_as_number,
        bgp_advertised_networks => $bgp_advertised_networks,
        bgp_neighbors           => generate_bgp_neighbors(
          $bgp_neighbors_ips,
          $bgp_neighbors_asns,
          $bgp_neighbors_nets
        ),
        midonet_api_url         => "http://${midonet_cluster_vip}:8181",
        username                => $username,
        password                => $password,
        tenant_name             => $tenant,
      } ->
      anchor { 'gateway_config::end': }
    }

    # Configure networks first, configure the gateway afterwards
    if defined(Class['tripleo::network::midonet::config'])
    {
      Anchor['network_creation::end'] -> Anchor['gateway_config::begin']
    }
  }

}
