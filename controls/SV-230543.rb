control 'SV-230543' do
  title "RHEL 8 must not allow interfaces to perform Internet Control Message
Protocol (ICMP) redirects by default."
  desc  "ICMP redirect messages are used by routers to inform hosts that a more
direct route exists for a particular destination. These messages contain
information from the system's route table, possibly revealing portions of the
network topology.

    There are notable differences between Internet Protocol version 4 (IPv4)
and Internet Protocol version 6 (IPv6). There is only a directive to disable
sending of IPv4 redirected packets. Refer to RFC4294 for an explanation of
\"IPv6 Node Requirements\", which resulted in this difference between IPv4 and
IPv6.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify RHEL 8 does not allow interfaces to perform Internet Protocol
version 4 (IPv4) ICMP redirects by default.

    Note: If either IPv4 or IPv6 is disabled on the system, this requirement
only applies to the active internet protocol version.

    Check the value of the \"default send_redirects\" variables with the
following command:

    $ sudo sysctl net.ipv4.conf.default.send_redirects

    net.ipv4.conf.default.send_redirects=0

    If the returned line does not have a value of \"0\", or a line is not
returned, this is a finding.
  "
  desc 'fix', "
    Configure RHEL 8 to not allow interfaces to perform Internet Protocol
version 4 (IPv4) ICMP redirects by default with the following command:

    $ sudo sysctl -w net.ipv4.conf.default.send_redirects=0

    If \"0\" is not the system's default value then add or update the following
line in the appropriate file under \"/etc/sysctl.d\":

    net.ipv4.conf.default.send_redirects=0
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-230543'
  tag rid: 'SV-230543r627750_rule'
  tag stig_id: 'RHEL-08-040270'
  tag fix_id: 'F-33187r568376_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  if virtualization.system.eql?('docker')
    impact 0.0
    describe "Control not applicable within a container" do
      skip "Control not applicable within a container"
    end
  else
    describe kernel_parameter('net.ipv4.conf.default.send_redirects') do
      its('value') { should eq 0 }
    end
  end
end
