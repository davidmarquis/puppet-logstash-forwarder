# == Class: logstash_fowarder::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'logstash_fowarder::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class logstash_fowarder::package {

  #### Package management

  # set params: in operation
  if ($logstash_fowarder::ensure == 'present') {

    # Check if we want to install a specific version or not
    if $logstash_fowarder::version == false {

      $package_ensure = $logstash_fowarder::autoupgrade ? {
        true  => 'latest',
        false => 'present',
      }

    } else {

      # install specific version
      $package_ensure = $logstash_fowarder::version

    }

  # set params: removal
  } else {
    $package_ensure = 'absent'
  }

  # action
  package { $logstash_fowarder::params::package :
    ensure => $package_ensure,
  }

}
