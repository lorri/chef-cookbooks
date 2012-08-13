#
# Cookbook Name:: daemontools-toaster
# Recipe:: default
#
# Copyright 2012, Hiroaki Nakamura
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

%w{ make gcc rpm-build }.each do |pkg|
  package pkg
end

bash 'install_daemontools-toaster' do
  cwd '/'
  code <<-EOH
    rpm -ivh http://mirrors.qmailtoaster.com/daemontools-toaster-0.76-1.3.6.src.rpm &&
    rpmbuild -ba /root/rpmbuild/SPECS/daemontools-toaster.spec &&
    rpm -ivh /root/rpmbuild/RPMS/x86_64/daemontools-toaster-0.76-1.3.6.x86_64.rpm

    /command/svscanboot &
  EOH
  not_if 'rpm -q --quiet daemontools-toaster'
end

template '/etc/init/svscanboot.conf' do
  source 'svscanboot.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
end
