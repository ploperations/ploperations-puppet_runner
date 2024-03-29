# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`puppet_runner`](#puppet_runner): Deploy puppet-runner and configure puppet runs

## Classes

### <a name="puppet_runner"></a>`puppet_runner`

This module will deploy
[puppet-runner](https://github.com/ploperations/puppet-runner) and schedule
puppet runs that use it. puppet-runner is a wrapper for running the puppet
agent that first checks that the environment an agent is configured to uses
exists. If it does not then the agent is moved back to the `production`
environment prior to running the puppet agent. The scheduling is handled by
the `puppet_run_scheduler` module.

#### Examples

##### 

```puppet
class { 'puppet_runner':
  version => '2.0.0',
}
```

#### Parameters

The following parameters are available in the `puppet_runner` class:

* [`exe_folder_path`](#exe_folder_path)
* [`install_path`](#install_path)
* [`archive_extension`](#archive_extension)
* [`base_download_url`](#base_download_url)
* [`binary_name`](#binary_name)
* [`checksum_filename`](#checksum_filename)
* [`checksum_type`](#checksum_type)
* [`version`](#version)
* [`executable_options`](#executable_options)

##### <a name="exe_folder_path"></a>`exe_folder_path`

Data type: `Stdlib::Absolutepath`

The folder that will prefix `puppet_runner::binary_name` when executing
the `puppet-runner` application

##### <a name="install_path"></a>`install_path`

Data type: `Stdlib::Absolutepath`

The folder into which `puppet-runner` will be installed

##### <a name="archive_extension"></a>`archive_extension`

Data type: `String[1]`

The file extension used by the compressed version `puppet-runner` that
will be downloaded

##### <a name="base_download_url"></a>`base_download_url`

Data type: `String[1]`

The URL to the directory that contains the files to be downloaded

##### <a name="binary_name"></a>`binary_name`

Data type: `String[1]`

The name of the uncompressed `puppet-runner` binary that will be executed

##### <a name="checksum_filename"></a>`checksum_filename`

Data type: `String[1]`

The filename that contains the checksum of the compressed version of
`puppet-runner` that will be downloaded

##### <a name="checksum_type"></a>`checksum_type`

Data type: `String[1]`

The type of checksum whose value is contained in `puppet_runner::checksum_filename

##### <a name="version"></a>`version`

Data type: `String[1]`

The version of `puppet-runner` to install

##### <a name="executable_options"></a>`executable_options`

Data type: `Optional[String[1]]`

One or more options to pass to the binary, for example: `-env-reset-delay=100 -debug=true`

Default value: ``undef``

