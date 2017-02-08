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
# == Class: tripleo::network::midonet::mem
#
# Configure MidoNet Enterprise Manager
#
# == Parameters:
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
# [*is_insights*]
#   (Optional) Set to true if using MEM Insights too.
#   Defaults to hiera('mem_is_insights', false)
#
# [*mem_analytics_port*]
#   (Optional) The port where the midonet analytics is listening.
#   Defaults to hiera('mem_analytics_port', undef)
#
# [*cluster_ip*]
#   (Optional) IP where the cluster service is running.
#   Defaults to hiera('mem_cluster_ip', undef)
#
# [*analytics_ip*]
#   (Optional) IP Where the analytics service is running.
#   Defaults to hiera('mem_analytics_ip', undef)
#
# [*is_ssl*]
#   (Optional) If using SSL, a specific vhost file will be created.
#   Defaults to hiera('mem_use_ssl', false)
#
# [*mem_api_namespace*]
# Namespace for the MidoNet Cluster (used to configure Apache).
#   Default: 'midonet-api'
#
# [*mem_trace_namespace*]
# Namespace for the MidoNet Traces (used to configure Apache).
#   Default: 'trace'
#
# [*mem_analytics_namespace*]
# Namespace for the MidoNet Analytics (used to configure Apache).
#   Default: 'analytics'
#
# [*mem_package*]
# Name of the MEM package.
#
# [*mem_install_path*]
# Path where the MEM package is installed.
#
# [*mem_api_version*]
#   The default value for the api_version is set to latest version. In case you
#   are using and older MidoNet REST API, change the version accordingly.
#
# [*mem_api_token*]
#   If desired, auto-login can be enabled by setting the value of api_token to
#   your Keystone token.
#   e.g. "mem_api_token": keystone_token
#
# [*mem_agent_config_api_namespace*]
#   The default value for the api_namespace is set to conf which usually
#   does not have to be changed.
#   Default value: "mem_agent_config_api_namespace": "conf"
#
# [*mem_poll_enabled*]
#   The Auto Polling will seamlessly refresh Midonet Manager data periodically.
#   It is enabled by default and can be disabled in Midonet Manager's Settings
#   section directly through the UI. This will only disable it for the duration
#   of the current session. It can also be disabled permanently by changing the
#   'poll_enabled' parameter to 'false'.
#
# [*mem_login_animation_enabled*]
#   Whether the login page background animation should be enabled or not.
#   Default: true
#
# [*mem_config_file*]
#   Path where the MEM configuration file can be found.
#   Default: "${mem_install_path}/config/client.js"
#
# [*mem_apache_docroot*]
#   Apache document root used in the MEM vhost.
#   Default: undef
#
# [*mem_apache_port*]
#   Port on which the MEM virtualhost listens.
#   Default: undef
#
# [*mem_proxy_preserve_host*]
#   Whether Apache should preserve the original host in the Host header.
#   Defaults to
#
# [*ssl_cert*]
#   Path where the SSL certificate is.
#   Default: undef
#
# [*ssl_key*]
#   Path where the SSL key can be found.
#   Default: undef
#
# [*insights_ssl*]
#   Set to true if Insights is configured to work with SSL enabled.
#   Default: undef
#
# [*mem_api_port*]
#   The port where the MidoNet API is listening.
#   Default: '8181'
#
# [*mem_trace_port*]
#   The port where the MidoNet Traces service is listening.
#   Default: '8460'
#
# [*mem_analytics_port*]
#   The port where the MidoNet Analytics is listening.
#   Default: '8000'
#
# [*mem_fabric_port*]
#   The port where the MidoNet Fabric service will listen.
#   Default: '8009'
#
# [*api_ssl*]
#   Enable if the MidoNet API is using SSL.
#   Default: false
#
class tripleo::network::midonet::mem(
  $is_insights                    = hiera('mem_is_insights', undef),
  $mem_analytics_port             = hiera('mem_analytics_port', undef),
  $cluster_ip                     = hiera('mem_cluster_ip', undef),
  $analytics_ip                   = hiera('mem_analytics_ip', undef),
  $is_ssl                         = hiera('mem_use_ssl', undef),
  $mem_api_namespace              = hiera('mem_api_namespace', undef),
  $mem_trace_namespace            = hiera('mem_trace_namespace', undef),
  $mem_analytics_namespace        = hiera('mem_analytics_namespace', undef),
  $mem_package                    = hiera('mem_package', undef),
  $mem_install_path               = hiera('mem_install_path', undef),
  $mem_api_version                = hiera('mem_api_version', undef),
  $mem_api_token                  = hiera('mem_api_token', undef),
  $mem_agent_config_api_namespace = hiera('mem_agent_config_api_namespace', undef),
  $mem_poll_enabled               = hiera('mem_poll_enabled', undef),
  $mem_login_animation_enabled    = hiera('mem_login_animation_enabled', undef),
  $mem_config_file                = hiera('mem_config_file', undef),
  $mem_apache_docroot             = hiera('mem_apache_docroot', undef),
  $mem_apache_port                = hiera('mem_apache_port', undef),
  $mem_proxy_preserve_host        = hiera('mem_proxy_preserve_host', undef),
  $ssl_cert                       = hiera('mem_ssl_cert', undef),
  $ssl_key                        = hiera('mem_ssl_key', undef),
  $insights_ssl                   = hiera('insights_ssl', undef),
  $mem_api_port                   = hiera('mem_api_port', undef),
  $mem_trace_port                 = hiera('mem_trace_port', undef),
  $mem_subscription_port          = hiera('mem_subscription_port', undef),
  $mem_fabric_port                = hiera('mem_fabric_port', undef),
  $api_ssl                        = hiera('api_ssl', undef),
  $step                           = hiera('step'),
) {
  if $step >= 4 {
    class { '::midonet::mem':
      is_insights                    => $is_insights,
      mem_analytics_port             => $mem_analytics_port,
      cluster_ip                     => $cluster_ip,
      analytics_ip                   => $analytics_ip,
      is_ssl                         => $is_ssl,
      mem_api_namespace              => $mem_api_namespace,
      mem_trace_namespace            => $mem_trace_namespace,
      mem_analytics_namespace        => $mem_analytics_namespace,
      mem_package                    => $mem_package,
      mem_install_path               => $gw_mem_install_path,
      mem_api_version                => $gw_mem_api_version,
      mem_api_token                  => $mem_api_token,
      mem_agent_config_api_namespace => $mem_agent_config_api_namespace,
      mem_poll_enabled               => $mem_poll_enabled,
      mem_login_animation_enabled    => $mem_login_animation_enabled,
      mem_config_file                => $mem_config_file,
      mem_apache_docroot             => $mem_apache_docroot,
      mem_apache_port                => $mem_apache_port,
      mem_proxy_preserve_host        => $mem_proxy_preserve_host,
      ssl_cert                       => $ssl_cert,
      ssl_key                        => $ssl_key,
      insights_ssl                   => $insights_ssl,
      mem_api_port                   => $mem_api_port,
      mem_trace_port                 => $mem_trace_port,
      mem_subscription_port          => $mem_subscription_port,
      mem_fabric_port                => $mem_fabric_port,
      api_ssl                        => $api_ssl,
    }
  }
}
