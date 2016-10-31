name             'belongsto'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures belongsto'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'apache2'
depends 'mysql', '~> 6.0'
depends 'php'
depends 'database'
depends 'mysql2_chef_gem'
