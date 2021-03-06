# Copyright 2017 Red Hat, Inc.
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
# == Class: tripleo::profile::base::docker_registry
#
# Docker Registry profile for tripleo
#
# === Parameters:
#
# [*registry_host*]
#  (String) IP address or hostname the Docker registry binds to
#  Defaults to hiera('controller_host')
#
# [*registry_port*]
#  (Integer) The port on which the Docker registry is listening on
#  Defaults to 8787
#
# [*registry_admin_host*]
#  (String) IP address or hostname the Docker registry binds to in the admin
#  network
#  Defaults to hiera('controller_admin_host')
#
class tripleo::profile::base::docker_registry (
  $registry_host       = hiera('controller_host'),
  $registry_port       = 8787,
  $registry_admin_host = hiera('controller_admin_host'),
) {
  # We want a v2 registry
  package{'docker-registry':
    ensure => absent,
  }
  package{'docker-distribution': }
  package{'docker': }
  file { '/etc/docker-distribution/registry/config.yml' :
    ensure  => file,
    content => template('tripleo/docker_distribution/registry_config.yml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['docker-distribution'],
    notify  => Service['docker-distribution'],
  }
  file_line { 'docker insecure registry':
    path    => '/etc/sysconfig/docker',
    line    => join ([
      'INSECURE_REGISTRY="',
      '--insecure-registry ', $registry_host, ':', $registry_port, ' ',
      '--insecure-registry ', $registry_admin_host, ':', $registry_port, '"']),
    match   => 'INSECURE_REGISTRY=',
    require => Package['docker'],
    notify  => Service['docker'],
  }
  service { 'docker-distribution':
    ensure  => running,
    enable  => true,
    require => Package['docker-distribution'],
  }
  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker'],
  }
}
