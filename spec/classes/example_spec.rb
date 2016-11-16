require 'spec_helper'

describe 'talend_commandline' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        case facts[:osfamily]
        when 'Debian'
          let(:facts) do
            {
              osfamily: 'Debian',
              operatingsystem: 'Debian',
              operatingsystemmajrelease: 7,
              staging_http_get: 'curl',
              path: '/usr/local/bin:/usr/bin:/bin'
            }
          end
        when 'RedHat'
          let(:facts) do
            {
              osfamily: 'RedHat',
              operatingsystem: 'RedHat',
              operatingsystemmajrelease: 6,
              staging_http_get: 'curl',
              path: '/usr/local/bin:/usr/bin:/bin'
            }
          end
        end
        context 'talend_commandline class with no cmdline url' do
          let(:params) do
            {
              license_url: 'https://foobar.com/license'
            }
          end
          it { is_expected.to raise_error(Puppet::Error, //) }
        end
        context 'talend_commandline class with no license url' do
          let(:params) do
            {
              cmdline_url: 'https://foobar.com/cmdline.zip',
            }
          end
          it { is_expected.to raise_error(Puppet::Error, //) }
        end
        context 'talend_commandline with minimum variables' do
          let(:params) do
            {
              cmdline_url: 'https://foobar.com/cmdline.zip',
              license_url: 's3://talend-bucket/license'
            }
          end
          context 'install -> config ~> service pattern' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('talend_commandline::params') }
            it { is_expected.to contain_class('talend_commandline::install').that_comes_before('Class[talend_commandline::config]') }
            it { is_expected.to contain_class('talend_commandline::config') }
            it { is_expected.to contain_class('talend_commandline::service').that_subscribes_to('Class[talend_commandline::config]') }
          end
          context 'commandline installed' do
            it { is_expected.to contain_Mkdir__p('/opt/cmdline') }
            it { is_expected.to contain_file('/opt/cmdline') }
            it { is_expected.to contain_Staging__deploy('cmdline.zip') }
          end
          context 'exports folder created' do
            it { is_expected.to contain_Mkdir__p('/opt/cmdline/exports') }
          end
          context 'license installed' do
            it { is_expected.to contain_Staging__file('/opt/cmdline/Talend-Studio-20160704_1411-V6.2.1/license')}
          end
          context 'commandline service set up in supervisord' do
            it { is_expected.to contain_Supervisord__program('cmdline') }
          end
        end
      end
    end
  end
end
