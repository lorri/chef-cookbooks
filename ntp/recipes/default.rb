#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2012, Hiroaki Nakamura
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

package 'ntp' do
  action [:install]
end

template '/etc/ntp.conf' do
  source 'ntp.conf.erb'
  variables(
    :ntp_servers => [
      '0.centos.pool.ntp.org',
      '1.centos.pool.ntp.org',
      '2.centos.pool.ntp.org',
    ]
  )
  notifies :restart, 'service[ntpd]'
end
 
execute 'ntpdate' do
  command 'ntpdate 0.centos.pool.ntp.org'
  not_if { File.exists? '/var/run/ntpd.pid' }
end
 
service 'ntpd' do
  action [:enable,:start]
end