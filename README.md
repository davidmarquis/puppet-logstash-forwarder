# puppet-logstash-forwarder

A puppet module for managing and configuring logstash-forwarder

https://github.com/elasticsearch/logstash-forwarder

This module is based upon https://github.com/electrical/puppet-lumberjack and https://github.com/MixMuffins/puppet-lumberjack

This updated module is in the beta stage and although it is tested, not all scenarios may be covered.
Tested on CentOS 6.4 using logstash-forwarder 0.3.1

## Assumptions

This module assumes that a package named `logstash-forwarder` can be installed on the target system.
You can build an RPM for your platform by following the _Packaging it_ instruction on [logstash-forwarder wiki](https://github.com/elasticsearch/logstash-forwarder):

## Usage

Installation, make sure service is running and will be started at boot time:

     class { 'logstash_forwarder':
       cpuprofile       => '/path/to/write/cpu/profile/to/file',
       idle_flush_time  => '5',
       log_to_syslog    => false,
       spool_size       => '1024',
       servers          => ['listof.hosts:12345', '127.0.0.1:9987'],
       ssl_ca           => '/path/to/ssl/root/certificate',
     }

Removal/decommissioning:

     class { 'logstash_forwarder':
       ensure => 'absent',
     }

Install everything but disable service(s) afterwards:

     class { 'logstash_forwarder':
       status => 'disabled',
     }

To configure file inputs:

    logstash_forwarder::file { 'localhost-syslog':
        paths    => ['/var/log/messages','/var/log/secure','/var/log/*.log/'],
        fields   => { 'type' : 'syslog' }, 
    }

## Parameters

Default parameters have been set in the params.pp class file.  Options include config file and directory, package name, install dir (used by the service(s), among others.

## Hiera

```
logstash_forwarder::cpuprofile: '/path/to/write/cpu/profile/to/file'
logstash_forwarder::log_to_syslog: false
logstash_forwarder::spool_size: '1024'
logstash_forwarder::servers: ['listof.hosts:12345', '127.0.0.1:9987']
logstash_forwarder::ssl_ca_path: '/path/to/ssl/root/certificate'

logstash_forwarder::logstash_files:
  'localhost-syslog':
    paths: ['/var/log/messages','/var/log/secure','/var/log/*.log/']
    fields:
      type: 'syslog'

  'nginx_accesslog': 
    paths: ['/var/log/nginx/access.log']
    filds:
      type: 'nginx'
```
