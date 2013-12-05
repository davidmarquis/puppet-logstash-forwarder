# == Class: logstash_fowarder::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
# Editor: Ryan O'Keeffe

class logstash_fowarder::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false

  # service status
  $status = 'enabled'

  # Config Directory
  $configdir = '/etc/logstash_fowarder'

  # Config File
  $config = 'logstash_fowarder.conf'
  
  # Install Directory
  $installdir = '/opt/logstash_fowarder'

  # Restart service on change
  $restart_on_change = false

  #### Internal module values

  # packages
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'OracleLinux', 'Amazon', 'RedHat', 'OEL': {
      # main application
      $package = [ 'logstash-fowarder' ]
    }
    'Debian', 'Ubuntu': {
      # main application
      $package = [ 'logstash-fowarder' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'OracleLinux', 'Amazon', 'RedHat', 'OEL': {
      $service_name       = 'logstash_fowarder'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
    }
    'Debian', 'Ubuntu': {
      $service_name       = 'logstash_fowarder'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
    }
    default: {
      fail("\"${module_name}\" provides no service parameters
            for \"${::operatingsystem}\"")
    }
  }

}
