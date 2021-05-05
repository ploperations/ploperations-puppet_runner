# @summary Deploy puppet-runner and configure puppet runs
#
# This module will deploy
# [puppet-runner](https://github.com/ploperations/puppet-runner) and schedule
# puppet runs that use it. puppet-runner is a wrapper for running the puppet
# agent that first checks that the environment an agent is configured to uses
# exists. If it does not then the agent is moved back to the `production`
# environment prior to running the puppet agent. The scheduling is handled by
# the `puppet_run_scheduler` module.
#
#
# @example
#   class { 'puppet_runner':
#     version => '2.0.0',
#   }
#
# @param [Stdlib::Absolutepath] exe_folder_path
#   The folder that will prefix `puppet_runner::binary_name` when executing
#   the `puppet-runner` application
#
# @param [Stdlib::Absolutepath] install_path
#   The folder into which `puppet-runner` will be installed
#
# @param [String[1]] archive_extension
#   The file extension used by the compressed version `puppet-runner` that
#   will be downloaded
#
# @param [String[1]] base_download_url
#   The URL to the directory that contains the files to be downloaded
#
# @param [String[1]] binary_name
#   The name of the uncompressed `puppet-runner` binary that will be executed
#
# @param [String[1]] checksum_filename
#   The filename that contains the checksum of the compressed version of
#   `puppet-runner` that will be downloaded
#
# @param [String[1]] checksum_type
#   The type of checksum whose value is contained in `puppet_runner::checksum_filename
#
# @param [String[1]] version
#   The version of `puppet-runner` to install
#
class puppet_runner (
  Stdlib::Absolutepath $exe_folder_path,
  Stdlib::Absolutepath $install_path,
  String[1] $archive_extension,
  String[1] $base_download_url,
  String[1] $binary_name,
  String[1] $checksum_filename,
  String[1] $checksum_type,
  String[1] $version,
) {
  $_file_ownership = $facts['kernel'] ? {
    'windows' => undef,
    default   => 'root',
  }

  # Setting the mode to 555 on Windows breaks Puppet's ability to create subdirectories
  $_file_permissions = $facts['kernel'] ? {
    'windows' => undef,
    default   => '0555',
  }

  file {
    default:
      ensure => directory,
      owner  => $_file_ownership,
      group  => $_file_ownership,
      mode   => $_file_permissions,
      ;
    $install_path: ;
    "${$install_path}/${version}": ;
    "${$install_path}/tmp": ;
  }

  $_archive_name = "${binary_name}.${archive_extension}"
  $_source_url = "${base_download_url}/${version}/${_archive_name}"
  $_checksum_url = "${base_download_url}/${version}/${checksum_filename}"

  archive { "${version}-${_archive_name}":
    path          => "${install_path}/tmp/${version}-${_archive_name}",
    source        => $_source_url,
    checksum_url  => $_checksum_url,
    checksum_type => $checksum_type,
    extract       => true,
    extract_path  => "${install_path}/${version}",
    creates       => "${install_path}/${version}/${binary_name}",
    cleanup       => true,
  }

  $_exe_symlink = $facts['kernel'] ? {
    'windows' => "${exe_folder_path}/puppet-runner.exe",
    default   => "${exe_folder_path}/puppet-runner",
  }

  file { $_exe_symlink:
    ensure  => link,
    force   => true,
    target  => "${install_path}/${version}/${binary_name}",
    require => Archive["${version}-${_archive_name}"],
  }

  tidy { 'clean up old puppet-runner versions':
    path    => "${$install_path}/tmp",
    age     => '1w',
    backup  => false,
    recurse => true,
    rmdirs  => true,
  }

  # determine which platform is being targeted and then pass the symlink's path
  # to the corresponding parameter of puppet_run_scheduler
  if $facts['kernel'] == 'windows' {
    $_posix_exe = undef
    $_windows_exe = $_exe_symlink
  } else {
    $_posix_exe = $_exe_symlink
    $_windows_exe = undef
  }

  class { 'puppet_run_scheduler':
    ensure                    => present,
    posix_puppet_executable   => $_posix_exe,
    windows_puppet_executable => $_windows_exe,
  }
}
