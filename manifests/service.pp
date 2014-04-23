# == Class: logstash_forwarder::service
#
# This class exists to
# 1. Provide seperation between service creation and other aspects of the module
# 2. Provide a basis for future enhancements involving multiple running instances
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
# Editor Ryan O'Keeffe

class logstash_forwarder::service {

  $fullconfig = "${logstash_forwarder::configdir}/${logstash_forwarder::config}" 
  $cpuprofile = $logstash_forwarder::cpuprofile
  $idle_flush_time = $logstash_forwarder::idle_flush_time
  $log_to_syslog    = $logstash_forwarder::log_to_syslog
  $spool_size       = $logstash_forwarder::spool_size
  $run_as_service   = $logstash_forwarder::run_as_service          
  $ensure = $logstash_forwarder::ensure  
  $installdir = $logstash_forwarder::installdir
  $log_file = $logstash_forwarder::params::log_file

  validate_bool($run_as_service)

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  if ($run_as_service == true ) {
    # Setup init file if running as a service
    $notify_logstash_forwarder = $logstash_forwarder::restart_on_change ? {
       true  => Service["logstash-forwarder"],
       false => undef,
    }

    file { '/etc/init.d/logstash-forwarder' :
      ensure  => $ensure,
      mode    => '0755',
      content => template("${module_name}/etc/init.d/logstash-forwarder.erb"),
      notify  => $notify_logstash_forwarder
    }

    logrotate::rule { "logstash-forwarder":
      compress     => true,
      copytruncate => true,
      missingok    => true,
      path         => "${log_file}",
      rotate       => 5,
      size         => '1M',
    }

    #### Service management

    # set params: in operation
    if $logstash_forwarder::ensure == 'present' {

      case $logstash_forwarder::status {
        # make sure service is currently running, start it on boot
        'enabled': {
          $service_ensure = 'running'
          $service_enable = true
        }
        # make sure service is currently stopped, do not start it on boot
        'disabled': {
          $service_ensure = 'stopped'
          $service_enable = false
        }
        # make sure service is currently running, do not start it on boot
        'running': {
          $service_ensure = 'running'
          $service_enable = false
        }
        # do not start service on boot, do not care whether currently running or not
        'unmanaged': {
          $service_ensure = undef
          $service_enable = false
        }
        # unknown status
        # note: don't forget to update the parameter check in init.pp if you
        #       add a new or change an existing status.
        default: {
          fail("\"${logstash_forwarder::status}\" is an unknown service status value")
        }
      }

    # set params: removal
    } else {

      # make sure the service is stopped and disabled (the removal itself will be
      # done by package.pp)
      $service_ensure = 'stopped'
      $service_enable = false
    }
    service { "logstash-forwarder":
            ensure     => $service_ensure,
            enable     => $service_enable,
            name       => $logstash_forwarder::params::service_name,
            hasstatus  => $logstash_forwarder::params::service_hasstatus,
            hasrestart => $logstash_forwarder::params::service_hasrestart,
            pattern    => $logstash_forwarder::params::service_pattern,
            require    => File['/etc/init.d/logstash-forwarder'],
    }
  } 
  else {
    $notify_logstash_forwarder = undef
  }
}
