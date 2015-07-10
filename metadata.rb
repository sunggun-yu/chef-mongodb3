name             'mongodb3'
maintainer       'Sunggun Yu'
maintainer_email 'sunggun.dev@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures mongodb3'
long_description 'Installs/Configures mongodb3'
version          '1.0.0'

supports 'ubuntu', '= 12.04'
supports 'redhat', '= 6.6'
supports 'centos', ['= 5.11', '= 6.6']
supports 'oracle', '= 6.6'


depends 'apt'
depends 'yum'
depends 'user'
depends 'runit', '~> 1.6.0'
