[![Build Status](https://img.shields.io/travis/williamtsoi1/puppet-talend_commandline.svg)](https://travis-ci.org/williamtsoi1/puppet-talend_commandline)

# Overview

This module is used to install Talend CommandLine (essentially a copy of Talend Studio), as well as install a service using supervisord.

# Module Description

This module will:
* Download and extract a copy of Talend studio from a given URL
* Download and install a license file from a given URL
* (optional) Download and extract a compressed file with required libraries (such as jdbc connectors)
* Manage and create (if required) a user and group used to run the CommandLine service
* Create a folder to store builds required for Talend builds
* Install supervisord, used to run the commandline process
* Configure the CommandLine as a program within supervisord
* Start the CommandLine service

# Usage

## Basic (minimal) setup
~~~~
class { '::talend_commandline':
  cmdline_url => 'http://foo.com/Talend-Studio-20160704_1411-V6.2.1.zip',
  license_url => 'http://foo.com/license',
}
~~~~

## Custom Setup with all parameters
~~~~
class { '::talend_commandline':
  $cmdline_url                => 'http://foo.com/Talend-Studio-20160704_1411-V6.2.1.zip',
  $cmdline_home               => '/opt/cmdline',
  $cmdline_subfolder          => 'Talend-Studio-20160704_1411-V6.2.1',
  $cmdline_user               => 'talend',
  $cmdline_group              => 'talend',
  $manage_user                => true,
  $manage_group               => true,
  $license_url                => 'http://foo.com/license',
  $cmdline_exports_path       => '/opt/cmdline/exports',
  $cmdline_db_connectors_url  => undef,
  $cmdline_port               => 8002,
  $jmxremote_port             => 8887,
}
~~~~


# Limitations

TODO: This is where you list OS compatibility, version compatibility, etc.

# Development

TODO: Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.
