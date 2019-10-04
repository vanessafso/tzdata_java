#
# === Authors
#
# Vanessa Souza <vanessasouza@algartelecom.com.br>
#
# === Copyright
#
# Copyright 2019 Your name here, unless otherwise noted.
#
class tzdata_java (
  String $tzdata_path    = '/tmp/tzdata',
  String $user_app       = 'root',
  String $group_app      = 'root',
  String $tzdata_version = '2019c',

){

  file { $tzdata_path:
    ensure  => present,
    source  => 'puppet:///modules/tzdata_java/bin',
    recurse => true,
    owner   => $user_app,
    group   => $group_app,
  }

  file { "${tzdata_path}/script.sh":
    ensure  => file,
    owner   => $user_app,
    group   => $group_app,
    mode    => '0755',
    content => template('tzdata_java/script.sh.erb'),
    require => File[$tzdata_path],
  }

  exec { 'tzdata exec':
    path      => ['/bin','/usr/bin','/usr/local/bin'],
    command   => "sh ${tzdata_path}/script.sh",
    require   => File["${tzdata_path}/script.sh"],
    logoutput => true,
  }

}
