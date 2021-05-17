require 'spec_helper_acceptance'

describe 'puppet_runner class' do
  context 'default parameters' do
    it 'works with no errors based on the example' do
      pp = <<-EOS
        unless $facts['kernel'] == 'windows' {
          package { 'unzip':
            ensure => present,
            before => Class['puppet_runner'],
          }
        }

        if $facts['os']['family'] == 'Debian' {
          package { 'cron':
            ensure => present,
            before => Class['puppet_runner'],
          }
        }

        class { 'puppet_runner':
          version => '2.0.1',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
