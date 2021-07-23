# frozen_string_literal: true

require 'spec_helper'

describe 'puppet_runner' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:win_acl_provider) do
        Puppet::Type.type(:acl).provide :windows
      end
      let(:pre_condition) do
        allow(win_acl_provider).to receive(:validate).and_return(true)
      end

      context 'with executable_options and version set' do
        let(:params) do
          { 'executable_options' => '-foo',
            'version' => '2.0.0' }
        end

        if os_facts[:kernel].eql?('windows')
          it {
            is_expected.to contain_class('puppet_run_scheduler')
              .with_windows_puppet_executable('C:/ProgramData/PuppetLabs/puppet-runner/puppet-runner.exe -foo')
          }
        else
          it {
            is_expected.to contain_class('puppet_run_scheduler')
              .with_posix_puppet_executable('/opt/puppetlabs/bin/puppet-runner -foo')
          }
        end
      end

      context 'with version set to 2.0.0' do
        let(:params) { { 'version' => '2.0.0' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_tidy('clean up old puppet-runner versions') }

        unless os_facts[:kernel].eql?('windows')
          it { is_expected.to contain_file('/opt/puppetlabs/puppet-runner') }
          it { is_expected.to contain_file('/opt/puppetlabs/puppet-runner/2.0.0') }
          it { is_expected.to contain_file('/opt/puppetlabs/puppet-runner/tmp') }
          it {
            is_expected.to contain_class('puppet_run_scheduler')
              .with_posix_puppet_executable('/opt/puppetlabs/bin/puppet-runner')
          }

          # validate that this module's settings are being consumed as expected
          it {
            is_expected.to contain_cron('puppet-run-scheduler')
              .with_command(%r{^/opt/puppetlabs/bin/puppet-runner agent})
          }
        end

        case os_facts[:kernel]
        when 'windows'
          it { is_expected.to contain_file('C:/ProgramData/PuppetLabs/puppet-runner') }
          it { is_expected.to contain_file('C:/ProgramData/PuppetLabs/puppet-runner/2.0.0') }
          it { is_expected.to contain_file('C:/ProgramData/PuppetLabs/puppet-runner/tmp') }
          it {
            is_expected.to contain_class('puppet_run_scheduler')
              .with_windows_puppet_executable('C:/ProgramData/PuppetLabs/puppet-runner/puppet-runner.exe')
          }

          it {
            is_expected.to contain_archive('2.0.0-puppet-runner_windows_amd64.exe.zip')
              .with_path('C:/ProgramData/PuppetLabs/puppet-runner/tmp/2.0.0-puppet-runner_windows_amd64.exe.zip')
              .with_creates('C:/ProgramData/PuppetLabs/puppet-runner/2.0.0/puppet-runner_windows_amd64.exe')
          }
          it {
            is_expected.to contain_file('C:/ProgramData/PuppetLabs/puppet-runner/puppet-runner.exe')
              .with_ensure('link')
              .with_force(true)
              .with_target('C:/ProgramData/PuppetLabs/puppet-runner/2.0.0/puppet-runner_windows_amd64.exe')
          }

          # validate that this module's settings are being consumed as expected
          it {
            is_expected.to contain_scheduled_task('puppet-run-scheduler')
              .with_command('C:/ProgramData/PuppetLabs/puppet-runner/puppet-runner.exe')
          }
        when 'AIX'
          it {
            is_expected.to contain_archive('2.0.0-puppet-runner_aix_ppc64.zip')
              .with_path('/opt/puppetlabs/puppet-runner/tmp/2.0.0-puppet-runner_aix_ppc64.zip')
              .with_creates('/opt/puppetlabs/puppet-runner/2.0.0/puppet-runner_aix_ppc64')
          }
          it {
            is_expected.to contain_file('/opt/puppetlabs/bin/puppet-runner')
              .with_ensure('link')
              .with_force(true)
              .with_target('/opt/puppetlabs/puppet-runner/2.0.0/puppet-runner_aix_ppc64')
          }
        when 'Darwin'
          if os_facts[:os]['architecture'].eql?('arm64')
            it {
              is_expected.to contain_archive('2.0.0-puppet-runner_darwin_arm64.zip')
                .with_path('/opt/puppetlabs/puppet-runner/tmp/2.0.0-puppet-runner_darwin_arm64.zip')
                .with_creates('/opt/puppetlabs/puppet-runner/2.0.0/puppet-runner_darwin_arm64')
            }
          else
            it {
              is_expected.to contain_archive('2.0.0-puppet-runner_darwin_amd64.zip')
                .with_path('/opt/puppetlabs/puppet-runner/tmp/2.0.0-puppet-runner_darwin_amd64.zip')
                .with_creates('/opt/puppetlabs/puppet-runner/2.0.0/puppet-runner_darwin_amd64')
            }
          end
        when 'Linux'
          it {
            is_expected.to contain_archive('2.0.0-puppet-runner_linux_amd64.zip')
              .with_path('/opt/puppetlabs/puppet-runner/tmp/2.0.0-puppet-runner_linux_amd64.zip')
              .with_creates('/opt/puppetlabs/puppet-runner/2.0.0/puppet-runner_linux_amd64')
          }
        when 'SunOS'
          it {
            is_expected.to contain_archive('2.0.0-puppet-runner_solaris_amd64.zip')
              .with_path('/opt/puppetlabs/puppet-runner/tmp/2.0.0-puppet-runner_solaris_amd64.zip')
              .with_creates('/opt/puppetlabs/puppet-runner/2.0.0/puppet-runner_solaris_amd64')
          }
        end
      end
    end
  end
end
