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
# [*is_mem*]
#   (Optional) Whether to install MEM packages or OSS packages.
#   Defaults to undef
#
# [*keystone_host*]
#   (Optional) Keystone VIP so the Cluster can authenticate.
#   Defaults to hiera('keystone_host', undef)
#
# [*keystone_user_name*]
#   (Optional) Keystone user to be used (must have the admin role).
#   Defaults to hiera('midonet_cluster_user', undef)
#
# [*keystone_user_password*]
#   (Optional) Password for this user.
#   Defaults to hiera('midonet_cluster_pass', undef)
#
# [*keystone_tenant_name*]
#   (Optional) Keystone tenant where this user has the admin role.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*keystone_protocol*]
#   (Optional) Protocol ("http" or "https") to make the keystone requests.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*keystone_admin_token*]
#   (Optional) Keystone token for the admin user.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*keystone_domain_name*]
#   (Optional) Keystone domain where the user has enough rights.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*keystone_domain_id*]
#   (Optional) ID for this keystone domain.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*keystone_version*]
#   (Optional) Whether to use v2 or v3 of the Keystone API.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*ssl_keystore_path*]
#   (Optional) Path where the SSL keystore is.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*ssl_keystore_pwd*]
#   (Optional) Password for the SSL keystore.
#   Defaults to hiera('midonet_cluster_tenant', undef)
#
# [*nsdb_nodes*]
#   (Optional) A list of IPs of the hosts that run Zookeeper.
#   Defaults to hiera('midonet_nsdb_node_ips', undef)
#
# [*max_heap_size*]
#   (Optional) Maximum heap size that will be allocated for the JVM.
#   Defaults to hiera('midonet_cluster_heap', undef)
#
# [*heap_newsize*]
#   (Optional) Heap new size that will be allocated for the JVM.
#   Defaults to hiera('midonet_cluster_heap_newsize', undef)
#
# [*package_name*]
#   (Optional) Name of the MidoNet Cluster package to be installed.
#   Default: undef
#
# [*package_ensure*]
#   (Optional) Whether the package should be installed or absent.
#   Default: undef
#
# [*service_name*]
#   (Optional) Name of the MidoNet Cluster service.
#   Default: undef
#
# [*service_ensure*]
#   (Optional) Whether this service should be running or stopped.
#   Default: undef
#
# [*service_enable*]
#  (Optional) Whether to enable the service at boot time or not.
#   Default: undef
#
# [*cluster_config_path*]
#   (Optional) Path where the MidoNet Cluster configuration files are located.
#   Default: undef
#
# [*cluster_jvm_config_path*]
#   (Optional) Path to store the MidoNet Cluster JVM configuration files.
#   Default: undef
#
# [*cluster_host*]
#   (Optional) IP where the MidoNet Cluster will bind itself.
#   Default: undef
#
# [*cluster_port*]
#   (Optional) Port to bind to be used by the MidoNet Cluster.
#   Default: undef
#
# [*keystone_port*]
#   (Optional) Port where the Keystone service is running.
#   Default: undef
#
# [*insights_ssl*]
#   (Optional) Enable if Insights will use SSL or not.
#   Default: undef
#
# [*analytics_ip*]
#   (Optional) IP of the Analytics node.
#   Default: undef
#
# [*midonet_version*]
#   (Optional) Version of Midonet that is being deployed.
#   Default: '5.2'
#
# [*elk_seeds*]
#   (Optional) List of ELK seeds , in the form of "ip1,ip2,ip3".
#   Default: '5.2'
#
# [*cluster_api_address*]
#   (Optional) IP Address that will be publicly exposed for the REST API.
#   Default: '$::ipaddress'
#
# [*cluster_api_port*]
#   (Optional) Port that will be bound. Usually you don't want to modify this.
#   Default: '8181'
#
# [*elk_cluster_name*]
#   (Optional) Elasticsearch cluster name. Not needed if running a single
#   ELK node.
#   Default: 'undef'
#
# [*elk_target_endpoint*]
#   (Optional) Target ELK endpoint to be configured.
#   Default: 'undef'
#
# [*endpoint_host*]
#   (Optional) Host where the unified endpoint will be bound.
#   Default: 'undef'
#
# [*endpoint_port*]
#   (Optional) Port that is going to be bound.
#   Default: 'undef'
#
# [*ssl_source_type*]
#   (Optional) SSL source type. Choose between 'autosigned' , 'keystore'
#   or 'certificate'.
#   Default: 'undef'
#
# [*ssl_cert_path*]
#   (Optional) Path for the SSL certificate.
#   Default: 'undef'
#
# [*ssl_privkey_path*]
#   (Optional) Path for the private SSL key.
#   Default: 'undef'
#
# [*ssl_privkey_pwd*]
#   (Optional) SSL private key password.
#   Default: 'undef'
#
# [*flow_history_port*]
#   (Optional) Port to be used by the flow history endpoint.
#   Default: 'undef'
#
# [*jarvis_enabled*]
#   (Optional) Whether to enable Jarvis or not.
#   Default: 'undef'
#
# [*state_proxy_address*]
#   (Optional) Address that the state proxy service will bind.
#   Default: undef
#
# [*state_proxy_port*]
#   (Optional) Port to be used by the state proxy.
#   Default: undef
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::network::midonet::cluster (
  $is_insights               = hiera('cluster_is_insights', undef),
  $is_mem                    = hiera('is_mem', undef),
  $keystone_host             = hiera('keystone_host', undef),
  $nsdb_nodes                = hiera('midonet_nsdb_node_ips', undef),
  $max_heap_size             = hiera('midonet_cluster_heap', undef),
  $heap_newsize              = hiera('midonet_cluster_heap_newsize', undef),
  $keystone_user_name        = hiera('midonet_cluster_user', undef),
  $keystone_user_password    = hiera('midonet_cluster_pass', undef),
  $keystone_tenant_name      = hiera('midonet_cluster_tenant', undef),
  $keystone_protocol         = hiera('midonet_cluster_keystone_protocol', undef),
  $keystone_admin_token      = hiera('midonet_cluster_keystone_admin_token', undef),
  $keystone_domain_name      = hiera('mdionet_cluster_keystone_domain_name', undef),
  $keystone_domain_id        = hiera('midonet_cluster_keystone_domain_id', undef),
  $keystone_version          = hiera('midonet_cluster_keystone_version', undef),
  $package_name              = hiera('midonet_cluster_package_name', undef),
  $package_ensure            = hiera('midonet_cluster_package_ensure', undef),
  $service_name              = hiera('midonet_cluster_service_name', undef),
  $service_ensure            = hiera('midonet_cluster_service_ensure', undef),
  $service_enable            = hiera('midonet_cluster_service_enable', undef),
  $cluster_config_path       = hiera('midonet_cluster_cluster_config_path', undef),
  $cluster_jvm_config_path   = hiera('midonet_cluster_cluster_jvm_config_path', undef),
  $cluster_host              = hiera('midonet_cluster_cluster_host', undef),
  $cluster_port              = hiera('midonet_cluster_cluster_port', undef),
  $keystone_port             = hiera('midonet_cluster_keystone_port', undef),
  $insights_ssl              = hiera('midonet_cluster_insights_ssl', undef),
  $analytics_ip              = hiera('midonet_cluster_analytics_ip', undef),
  $midonet_version           = hiera('midonet_cluster_midonet_version', undef),
  $elk_seeds                 = hiera('midonet_cluster_elk_seeds', undef),
  $cluster_api_address       = hiera('midonet_cluster_cluster_api_address', undef),
  $cluster_api_port          = hiera('midonet_cluster_cluster_api_port', undef),
  $elk_cluster_name          = hiera('midonet_cluster_elk_cluster_name', undef),
  $elk_target_endpoint       = hiera('midonet_cluster_elk_target_endpoint', undef),
  $endpoint_host             = hiera('midonet_cluster_endpoint_host', undef),
  $endpoint_port             = hiera('midonet_cluster_endpoint_port', undef),
  $ssl_source_type           = hiera('midonet_cluster_ssl_source_type', undef),
  $ssl_cert_path             = hiera('midonet_cluster_ssl_cert_path', undef),
  $ssl_privkey_path          = hiera('midonet_cluster_ssl_privkey_path', undef),
  $ssl_privkey_pwd           = hiera('midonet_cluster_ssl_privkey_pwd', undef),
  $ssl_keystore_path         = hiera('midonet_cluster_ssl_keystore_path', undef),
  $ssl_keystore_pwd          = hiera('midonet_cluster_ssl_keystore_pwd', undef),
  $flow_history_port         = hiera('midonet_cluster_flow_history_port', undef),
  $jarvis_enabled            = hiera('midonet_cluster_jarvis_enabled', undef),
  $state_proxy_address       = hiera('midonet_cluster_state_proxy_address', undef),
  $state_proxy_port          = hiera('midonet_cluster_state_proxy_port', undef),
  $step                      = hiera('step'),
) {
  if $step >= 4 {
    include ::midonet_openstack::profile::midojava::midojava

    anchor { 'mn-cluster_begin': } ->
    class { '::midonet::cluster':
      keystone_host             => $keystone_host,
      keystone_user_name        => $keystone_user_name,
      keystone_user_password    => $keystone_user_password,
      keystone_tenant_name      => $keystone_tenant_name,
      zookeeper_hosts           => generate_api_zookeeper_ips($nsdb_nodes),
      cassandra_servers         => $nsdb_nodes,
      cassandra_rep_factor      => count($nsdb_nodes),
      is_insights               => $is_insights,
      is_mem                    => hiera('is_mem', undef),
      max_heap_size             => $max_heap_size,
      heap_newsize              => $heap_newsize,
      keystone_protocol         => $keystone_protocol,
      keystone_admin_token      => $keystone_admin_token,
      keystone_domain_name      => $keystone_domain_name,
      keystone_domain_id        => $keystone_domain_id,
      keystone_keystone_version => $keystone_version,
      package_name              => $package_name,
      package_ensure            => $package_ensure,
      service_name              => $service_name,
      service_ensure            => $service_ensure,
      service_enable            => $service_enable,
      cluster_config_path       => $cluster_config_path,
      cluster_jvm_config_path   => $cluster_jvm_config_path,
      cluster_host              => $cluster_host,
      cluster_port              => $cluster_port,
      keystone_port             => $keystone_port,
      insights_ssl              => $insights_ssl,
      analytics_ip              => $analytics_ip,
      midonet_version           => $midonet_version,
      elk_seeds                 => $elk_seeds,
      cluster_api_address       => $cluster_api_address,
      cluster_api_port          => $cluster_api_port,
      elk_cluster_name          => $elk_cluster_name,
      elk_target_endpoint       => $elk_target_endpoint,
      endpoint_host             => $endpoint_host,
      endpoint_port             => $endpoint_port,
      ssl_source_type           => $ssl_source_type,
      ssl_cert_path             => $ssl_cert_path,
      ssl_privkey_path          => $ssl_privkey_path,
      ssl_privkey_pwd           => $ssl_privkey_pwd,
      ssl_keystore_path         => $ssl_keystore_path,
      ssl_keystore_pwd          => $ssl_keystore_pwd,
      flow_history_port         => $flow_history_port,
      jarvis_enabled            => $jarvis_enabled,
      state_proxy_address       => $state_proxy_address,
      state_proxy_port          => $state_proxy_port,
      require                   => Class['::midonet_openstack::profile::midojava::midojava'],
    } ->
    anchor { 'mn-cluster_end': }
  }
}
