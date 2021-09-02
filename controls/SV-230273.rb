control 'SV-230273' do
  title "RHEL 8 must have the packages required for multifactor authentication
installed."
  desc  "Using an authentication device, such as a DoD Common Access Card (CAC)
or token that is separate from the information system, ensures that even if the
information system is compromised, credentials stored on the authentication
device will not be affected.

    Multifactor solutions that require devices separate from information
systems gaining access include, for example, hardware tokens providing
time-based or challenge-response authenticators and smart cards such as the
U.S. Government Personal Identity Verification (PIV) card and the DoD CAC.

    A privileged account is defined as an information system account with
authorizations of a privileged user.

    Remote access is access to DoD nonpublic information systems by an
authorized user (or an information system) communicating through an external,
non-organization-controlled network. Remote access methods include, for
example, dial-up, broadband, and wireless.

    This requirement only applies to components where this is specific to the
function of the device or has the concept of an organizational user (e.g., VPN,
proxy capability). This does not apply to authentication for the purpose of
configuring the device itself (management).
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the operating system has the packages required for multifactor
authentication installed with the following commands:

    $ sudo yum list installed esc openssl-pkcs11

    esc.x86_64          1.1.2-7.el8          @AppStream
    openssl-pkcs11.x86_64          0.4.8-2.el8          @anaconda

    If the \"esc\" and \"openssl-pkcs11\" packages are not installed, ask the
administrator to indicate what type of multifactor authentication is being
utilized and what packages are installed to support it.  If there is no
evidence of multifactor authentication being used, this is a finding.
  "
  desc 'fix', "
    Configure the operating system to implement multifactor authentication by
installing the required packages with the following command:

    $ sudo yum install esc openssl-pkcs11
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000375-GPOS-00160'
  tag gid: 'V-230273'
  tag rid: 'SV-230273r627750_rule'
  tag stig_id: 'RHEL-08-010390'
  tag fix_id: 'F-32917r567566_fix'
  tag cci: ['CCI-001948']
  tag nist: ['IA-2 (11)']

  smart_card_status = input('smart_card_status')
  mfa_pkg_list = %w(esc openssl-pkcs11)

  if virtualization.system.eql?('docker')
    impact 0.0
    describe "Control not applicable within a container" do
      skip "Control not applicable within a container"
    end
  else
    if smart_card_status.eql?('disabled')
      impact 0.0
      describe 'The system is not smartcard enabled thus this control is Not Applicable' do
        skip 'The system is not using Smartcards / PIVs to fulfil the MFA requirement, this control is Not Applicable.'
      end
    else
      mfa_pkg_list.each do |pkg|
        describe package(pkg) do
          it { should be_installed }
        end
      end
    end
  end
end
