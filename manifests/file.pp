define logstash_forwarder::file (
    $paths,
    $fields,
){
    
    File {
        owner => 'root',
        group => 'root',
    }

    if ($paths != '') {
        validate_array($paths)
    }
    if ($fields != ''){
        validate_hash($fields)
    }
 
    if ($logstash_forwarder::ensure == 'present' ) {
        concat::fragment{"${name}":
            target  => "${logstash_forwarder::configdir}/${logstash_forwarder::config}",
            content => template("${module_name}/file_format.erb"),
            order   => 010,
        }
    }
}
