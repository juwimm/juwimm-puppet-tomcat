# Definition: tomcat::instance
#
#   Install a tomcat instance
#
# Parameters:
#
#   [*version*]       : The tomcat version
#   [*user*]          : The tomcat user name
#   [*home*]          : The tomcat base path
#
# Examples:
#
#   tomcat::instance {'me' :
#     version => '6.0.29',
#   }
#
define tomcat::instance(
  $version            = '6.0.29',
  $user               = $name,
  $home               = "/srv/system/tomcat",
  $base               = "/srv/opt",
) {

  require tomcat

  $major_ver = get_first_part($version, '.')

  exec {"curl -L http://archive.apache.org/dist/tomcat/tomcat-${major_ver}/v${version}/bin/apache-tomcat-${version}.tar.gz  | tar -xzf - && cd apache-tomcat-${version}" :
    cwd       =>  '/var/tmp',
    user      =>  'root',
    path      =>  ['/usr/local/bin', '/bin', '/usr/bin'],
    timeout   =>  0,
    logoutput =>  on_failure,
    unless    =>  "ls /var/tmp/apache-tomcat-${version}",
  }

  group {$user :
    ensure => present,
  }

  user {$user :
    ensure           => present,
    home             => $home,
    managehome       => false,
    comment          => "tomcat user ${user}",
    gid              => $user,
    shell            => "/bin/sh",
    password_min_age => '0',
    password_max_age => '99999',
    password         => '*',
  }


#  $h = get_cwd_hash_path($home, $user)
#  create_resources('file', $h)

  file {$home :
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0710',
    require => User[$user],
  }

  exec {"cp -r /var/tmp/apache-tomcat-${version} ${base}" :
    cwd       => '/',
    user      => 'root',
    path      => '/bin',
    logoutput => on_failure,
    unless    => "ls ${home}/tomcat",
    require   => [File[$home], Exec["curl -L http://archive.apache.org/dist/tomcat/tomcat-${major_ver}/v${version}/bin/apache-tomcat-${version}.tar.gz  | tar -xzf - && cd apache-tomcat-${version}"]]
  }
#
#  file {"${home}/apache-tomcat":
#    ensure  => directory,
#    owner   => $user,
#    group   => $user,
#    mode    => '0700',
#    recurse => true,
#    require => Exec["cp -r /var/tmp/apache-tomcat-${version} ${home}/apache-tomcat"],
#  }
#


}
