define logstash_fowarder::file (
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
 
    if ($logstash_fowarder::ensure == 'present' ) { 
        concat::fragment{"${name}":
            target  => "${logstash_fowarder::configdir}/${logstash_fowarder::config}",
            content => template("${module_name}/file_format.erb"),
            order   => 010,
        }
    }
}
