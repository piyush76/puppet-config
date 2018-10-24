# Copyright 2018 Your name here, unless otherwise noted.
#
class profiles {


}

class profiles::testprofile1{
  class{ 'testprofile2':}
  class{ 'putty':}
}

class profiles::testprofile1::testprofile2{
   file { 'c:\blah.txt':
    ensure  => 'present',
    content => inline_template("Created by Puppet at <%= Time.now %>\n"),
  }
  
  file { 'c:/temp/':
    ensure => 'directory',
  }

  download_file { "Microsoft Visual C++ 2013":
    url                   => 'http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe',
    destination_directory => 'c:\temp',
  }

  package { "Microsoft Visual C++ 2013":
    ensure          => 'installed',
    require         => Download_file['Microsoft Visual C++ 2013'],
    source          => 'c:\temp\vcredist_x64.exe',
    install_options => [ '/quiet'],
  }

  
  download_file { "Microsoft .NET":
    url                   => 'http://download.microsoft.com/download/5/6/2/562A10F9-C9F4-4313-A044-9C94E0A8FAC8/dotNetFx40_Client_x86_x64.exe',
    destination_directory => 'c:\temp',
  }


  package { "Microsoft .NET":
    ensure          => 'installed',
    require         => Download_file['Microsoft .NET'],
    source          => 'c:\temp\dotNetFx40_Client_x86_x64.exe',
    install_options => [ '/q'],
  } 

}

class profiles::testprofile1::putty {

  file { 'c:/admin-tools/':
    ensure => 'directory',
  }

  download_file { "Download putty":
    url                   => 'http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe',
    destination_directory => 'c:\admin-tools',
  }

  download_file { "Download puttygen":
    url                   => 'http://the.earth.li/~sgtatham/putty/latest/x86/puttygen.exe',
    destination_directory => 'c:\admin-tools',
  }

}


  


