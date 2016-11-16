# == Class talend_commandline::install
#
# This class is called from talend_commandline for install.
#
class talend_commandline::install (
  $cmdline_url,
  $cmdline_home,
  $cmdline_subfolder,
  $cmdline_user,
  $cmdline_group,
  $manage_user,
  $manage_group,
  $license_url,
  $cmdline_exports_path,
  $cmdline_db_connectors_url,
){
  include ::staging

  # create users and groups if required
  if $manage_user {
    ensure_resource('user', $cmdline_user, {
      ensure => present,
      gid    => $cmdline_group,
    })
  }
  if $manage_group {
    ensure_resource('group', $cmdline_group, {
      ensure => present,
    })
  }

  # Create commandline exports folder
  mkdir::p { $cmdline_exports_path:
    owner => $cmdline_user,
    group => $cmdline_group,
    mode  => '0744',
  }

  # Create commandline home folder
  mkdir::p { $cmdline_home:
    owner        => $cmdline_user,
    group        => $cmdline_group,
    mode         => '0744',
    declare_file => true,
  }

  # install commandline, and license, and symlinks folder to /$cmdline_home/current
  staging::deploy { 'cmdline.zip':
    source  => $cmdline_url,
    target  => $cmdline_home,
    user    => $cmdline_user,
    group   => $cmdline_group,
    require => File[$cmdline_home],
  } ->
  staging::file { "${cmdline_home}/${cmdline_subfolder}/license":
    source => $license_url,
    target => "${cmdline_home}/${cmdline_subfolder}",
  }
  # installs required cmdline_db_connectors
  if $cmdline_db_connectors_url != undef {
    file { [
      "${cmdline_home}/${cmdline_subfolder}/configuration",
      "${cmdline_home}/${cmdline_subfolder}/configuration/lib",
      "${cmdline_home}/${cmdline_subfolder}/configuration/lib/java",
    ]:
      ensure  => 'directory',
      owner   => $cmdline_user,
      group   => $cmdline_group,
      mode    => '0644',
      require => Staging:Deploy['cmdline.zip'],
    }

    staging::deploy { 'cmdline-connectors.zip':
      source  => $cmdline_db_connectors_url,
      target  => "/${cmdline_home}/${cmdline_subfolder}/configuration/lib/java",
      require => File[
        "${cmdline_home}/${cmdline_subfolder}/configuration",
        "${cmdline_home}/${cmdline_subfolder}/configuration/lib",
        "${cmdline_home}/${cmdline_subfolder}/configuration/lib/java"
      ],
      user    => $cmdline_user,
      group   => $cmdline_group,
    }
  }
}
