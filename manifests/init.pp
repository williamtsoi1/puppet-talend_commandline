# Class: talend_commandline
# ===========================
#
#
# Parameters
# ----------
#
# * `tomcat_service_name`
#   The name of the service of the running Tomcat. This service will be restarted
#   after configuration of Talend Administration Center
#

class talend_commandline (
  $cmdline_url                  = $::talend_commandline::params::cmdline_url,
  $cmdline_home                 = $::talend_commandline::params::cmdline_home,
  $cmdline_subfolder            = $::talend_commandline::params::cmdline_subfolder,
  $cmdline_user                 = $::talend_commandline::params::cmdline_user,
  $cmdline_group                = $::talend_commandline::params::cmdline_group,
  $manage_user                  = $::talend_commandline::params::manage_user,
  $manage_group                 = $::talend_commandline::params::manage_group,
  $license_url                  = $::talend_commandline::params::license_url,
  $cmdline_exports_path         = $::talend_commandline::params::cmdline_exports_path,
  $cmdline_job_generation_path  = $::talend_commandline::params::cmdline_job_generation_path,
  $cmdline_user_components_path = $::talend_commandline::params::cmdline_user_components_path,
  $cmdline_db_connectors_url    = $::talend_commandline::params::cmdline_db_connectors_url,
  $cmdline_port                 = $::talend_commandline::params::cmdline_port,
  $jmxremote_port               = $::talend_commandline::params::jmxremote_port,
) inherits ::talend_commandline::params {

  # validate parameters here
  validate_string($cmdline_url)
  validate_string($cmdline_home)
  validate_string($cmdline_subfolder)
  validate_string($cmdline_user)
  validate_string($cmdline_group)
  validate_bool($manage_user)
  validate_bool($manage_group)
  validate_string($license_url)
  validate_string($cmdline_exports_path)
  validate_string($cmdline_job_generation_path)
  validate_string($cmdline_user_components_path)

  class { '::talend_commandline::install':
    cmdline_url                  => $cmdline_url,
    cmdline_home                 => $cmdline_home,
    cmdline_subfolder            => $cmdline_subfolder,
    cmdline_user                 => $cmdline_user,
    cmdline_group                => $cmdline_group,
    manage_user                  => $manage_user,
    manage_group                 => $manage_group,
    license_url                  => $license_url,
    cmdline_exports_path         => $cmdline_exports_path,
    cmdline_job_generation_path  => $cmdline_job_generation_path,
    cmdline_user_components_path => $cmdline_user_components_path,
    cmdline_db_connectors_url    => $cmdline_db_connectors_url,
  } ->
  class { '::talend_commandline::config':
  } ~>
  class { '::talend_commandline::service':
    cmdline_home      => $cmdline_home,
    cmdline_subfolder => $cmdline_subfolder,
    cmdline_user      => $cmdline_user,
    cmdline_port      => $cmdline_port,
    jmxremote_port    => $jmxremote_port,
  } ->
  Class['::talend_commandline']
}
