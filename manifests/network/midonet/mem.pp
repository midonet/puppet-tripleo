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
#   (Optional) Set to true if using MEM Insights too
#   Defaults to hiera('mem_is_insights', false)
#
# [*mem_analytics_port*]
#   (Optional) The port where the midonet analytics is listening
#   Defaults to hiera('mem_analytics_port', undef)
#
# [*cluster_ip*]
#   (Optional) IP where the cluster service is running
#   Defaults to hiera('mem_cluster_ip', undef)
#
# [*analytics_ip*]
#   (Optional) IP Where the analytics service is running
#   Defaults to hiera('mem_analytics_ip', undef)
#
# [*is_ssl*]
#   (Optional) If using SSL, a specific vhost file will be created
#   Defaults to hiera('mem_use_ssl', false)
#
class tripleo::network::midonet::mem(
  $is_insights          = hiera('mem_is_insights', false),
  $mem_analytics_port   = hiera('mem_analytics_port', undef),
  $cluster_ip           = hiera('mem_cluster_ip', undef),
  $analytics_ip         = hiera('mem_analytics_ip', undef),
  $is_ssl               = hiera('mem_use_ssl', false),
  $step                 = hiera('step'),
) {
  if $step >= 4 {
    class { '::midonet::mem':
      is_insights        => $is_insights,
      mem_analytics_port => $mem_analytics_port,
      cluster_ip         => $cluster_ip,
      analytics_ip       => $analytics_ip,
      is_ssl             => $is_ssl,
    }
  }
}
