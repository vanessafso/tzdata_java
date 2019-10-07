#
# === Authors
#
# Vanessa Souza <vanessasouza@algartelecom.com.br>
#
# === Copyright
#
# Copyright 2019 Your name here, unless otherwise noted.
#
define tzdata_java::tzdata_java_oracle (

  $tzdata_path    = '/tmp/tzdata',
  $user_app       = undef,
  $group_app      = undef,
  $tzdata_version = undef,
  $java_home      = undef,

){

  if ! defined_with_params(File[$tzdata_path], {'ensure' => 'present'}){
    file { $tzdata_path:
      ensure  => present,
      source  => 'puppet:///modules/tzdata_java/bin',
      recurse => true,
      owner   => $user_app,
      group   => $group_app,
    }
  }

  if ! defined_with_params(File["${tzdata_path}/script.sh"], {'ensure' => 'file'}){
    file { "${tzdata_path}/script.sh":
      ensure  => file,
      owner   => $user_app,
      group   => $group_app,
      mode    => '0755',
      content => template('tzdata_java/script.sh.erb'),
      require => File[$tzdata_path],
    }
  }

  exec { "tzdata exec_${name}":
    path      => ['/bin','/usr/bin','/usr/local/bin'],
    command   => "sh ${tzdata_path}/script.sh",
    logoutput => true,
    user      => $user_app,
  }

}
