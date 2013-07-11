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
#     version => '6.0.28',
#   }
#
define tomcat::instance(
  $version            = '6.0.29',
  $user               = $name,
  $home               = "/srv/system/${name}-${version}",
) {

  require tomcat

  $major_ver = get_first_part($version, '.')
  
  archive { 'apache-tomcat-${version}':
    ensure => present,
    url    => 'http://archive.apache.org/dist/tomcat/tomcat-${major_ver}/v${version}/bin/apache-tomcat-${version}.tar.gz',
    target => '/srv/opt',
  }

#  exec {"curl -L https://github.com/sitaramc/tomcat/archive/v${version}.tar.gz  | tar -xzf - && cd tomcat-${version}" :
#    cwd       =>  '/var/tmp',
#    user      =>  'root',
#    path      =>  ['/usr/local/bin', '/bin', '/usr/bin'],
#    timeout   =>  0,
#    logoutput =>  on_failure,
#    unless    =>  "ls /var/tmp/tomcat-${version}",
#  }
#
#  group {$user :
#    ensure => present,
#  }
#
#  user {$user :
#    ensure           => present,
#    home             => $home,
#    comment          => "tomcat user ${user}",
#    gid              => $user,
#    shell            => "/bin/sh",
#    password_min_age => '0',
#    password_max_age => '99999',
#    password         => '*',
#  }
#
#  $h = get_cwd_hash_path($home, $user)
#  create_resources('file', $h)
#
#  file {$home :
#    ensure  => directory,
#    owner   => $user,
#    group   => $user,
#    mode    => '0710',
#    require => User[$user],
#  }
#
#  exec {"cp -r /var/tmp/tomcat-${version} ${home}/tomcat" :
#    cwd       => '/',
#    user      => 'root',
#    path      => '/bin',
#    logoutput => on_failure,
#    unless    => "ls ${home}/tomcat",
#    require   => [File[$home], Exec["curl -L https://github.com/sitaramc/tomcat/archive/v${version}.tar.gz  | tar -xzf - && cd tomcat-${version}"]]
#  }
#
#  file {"${home}/tomcat":
#    ensure  => directory,
#    owner   => $user,
#    group   => $user,
#    mode    => '0700',
#    recurse => true,
#    require => Exec["cp -r /var/tmp/tomcat-${version} ${home}/tomcat"],
#  }
#
#  file {"${home}/${admin_username}.pub" :
#    ensure  => present,
#    owner   => $user,
#    group   => $user,
#    mode    => '0700',
#    content => $admin_pub_key,
#    require => File["${home}/tomcat"],
#  }
#
#  file {"${home}/.tomcat.rc" :
#    ensure  =>  present,
#    content =>  template("tomcat/tomcat-${major_ver}.rc"),
#    owner   =>  $user,
#    group   =>  $user,
#    mode    =>  '0770',
#    require =>  File["${home}/${admin_username}.pub"],
#  }
#
# exec {"${home}/tomcat/src/tomcat setup -pk ${admin_username}.pub" :
#    user        => $user,
#    cwd         => $home,
#    environment => ["HOME=${home}"],
#    path        => ['/usr/bin', '/bin'],
#    logoutput   => on_failure,
#    require     => File["${home}/.tomcat.rc"],
#  }
#
#  file {"${home}/.ssh" :
#    ensure  =>  present,
#    owner   =>  $user,
#    group   =>  $user,
#    mode    =>  '0600',
#    recurse =>  true,
#    require =>  Exec["${home}/tomcat/src/tomcat setup -pk ${admin_username}.pub"],
#  }

}
