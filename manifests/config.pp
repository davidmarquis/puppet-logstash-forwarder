# Class: logstash_forwarder::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
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
#   class { 'logstash_forwarder::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
# Edit: Kayla Green <mailto:kaylagreen771@gmail.com>
# Edit: Ryan O'Keeffe
class logstash_forwarder::config {
    File {
        owner => root,
        group => root
    }
  
    $configdir = $logstash_forwarder::configdir
    $config = $logstash_forwarder::config

    if ($logstash_forwarder::ensure == 'present') {
        # Manage the config dir
        file { $configdir:
            ensure  => directory,
            mode    => '0640',
            purge   => true,
            recurse => true,
        }
        
        #Create network portion of config file
        $servers = $logstash_forwarder::servers
        $ssl_ca = $logstash_forwarder::ssl_ca_path
        $ssl_certificate = $logstash_forwarder::ssl_certificate
        $ssl_key = $logstash_forwarder::ssl_key
        
        #### Setup configuration files
        include concat::setup
        concat{ "${configdir}/${config}":
            require => File[$configdir],
        }

        # Add network portion of the config file
        concat::fragment{"default-start":
            target  => "${configdir}/${config}",
            content => template("${module_name}/network_format.erb"),
            order   => 001,
        }  

        # Add the ending brackets and additional set of {} brackets needed to fix comma/json parsing issue
        concat::fragment{"default-end":
            target  => "${configdir}/${config}",
            content => "\n\t\t}\n\t]\n}\n",
            order   => 999,
        }
        
    } else {
        # Remove the logstash_forwarder directory and all of its configs. 
        file {$configdir : 
            ensure  => 'absent',
            purge   => true,
            recurse => true,
            force   => true,
        }
        
    }
}
