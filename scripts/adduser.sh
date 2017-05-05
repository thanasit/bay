#!/usr/bin/expect
set timeout -1
puts "start"

send "sudo useradd jboss\n"

send "sudo passwd jboss\n"
expect "New password: "

send "jboss\n"
expect "Retype new password: "

send "jboss\n"