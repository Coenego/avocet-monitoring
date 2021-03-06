class kibana (

  # Installation configuration
  $install_method     = 'archive',
  $install_config     = {
      'url_base'                  => 'https://download.elasticsearch.org/kibana/kibana',
      'url_extension'             => 'tar.gz',
      'version_major_minor'       => '4.0.0-BETA1.1'
  },

  # Kibana directory
  $stats_dir              = '/opt/kibana',

  # Kibana service
  $service_name           = 'kibana') {

  # Install Kibana
  class { "::kibana::install::${install_method}":
      install_config  => $install_config,
      stats_dir       => $stats_dir
  }

  # Startup script for the kibana service
  file { 'kibana_service':
      path    => "/etc/init/${service_name}.conf",
      ensure  => present,
      content => template('kibana/kibana.conf.erb'),
      require => [Class["::kibana::install::${install_method}"]]
  }

  # Start the kibana service
  service { $service_name:
      ensure      => running,
      provider    => upstart,
      require     => [
          File['kibana_service']
      ]
  }
}
