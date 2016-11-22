# == Class talend_commandline::params
#
# This class is meant to be called from talend_commandline.
# It sets variables according to platform.
#
class talend_commandline::params {
  $cmdline_url                  = undef
  $cmdline_home                 = '/opt/cmdline'
  $cmdline_subfolder            = 'Talend-Studio-20160704_1411-V6.2.1'
  $cmdline_user                 = 'talend'
  $cmdline_group                = 'talend'
  $manage_user                  = true
  $manage_group                 = true
  $license_url                  = undef
  $cmdline_exports_path         = '/opt/cmdline/exports'
  $cmdline_job_generation_path  = '/opt/cmdline/generatedjobs'
  $cmdline_user_components_path = '/opt/cmdline/usercomponents'
  $cmdline_db_connectors_url    = undef
  $cmdline_port                 = 8002
  $jmxremote_port               = 8887

  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
