# Class: tomcat
#
#   This module manages tomcat installation
#
# Parameters: none
#
# Actions:
#
#   Declares all other classes in the tomcat module. Currently, this consists
#   of tomcat::instance.
#
# Requires: nothing
#
# Samples Usage:
#
class tomcat {

  class { 'tomcat::instance': }

}
