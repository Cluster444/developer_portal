source 'http://rubygems.org'

gem 'rails', '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'nokogiri'

gem 'aws-s3', :require => 'aws/s3'

# REFINERY CMS ================================================================

# Specify the Refinery CMS core:
gem 'refinerycms',              '~> 0.9.8.5'

# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-inquiries',    '~> 0.9.8.8'
# gem 'refinerycms-news',       '~> 0.9.9'
# gem 'refinerycms-portfolio',  '~> 0.9.8'
# gem 'refinerycms-theming',    '~> 0.9.8'

gem 'refinerycms-blog', :git => 'git://github.com/Cluster444/refinerycms-blog'


# Add support (optional, you can remove this if you really want to).
gem 'refinerycms-i18n',         '~> 0.9.8.7'

# Figure out how to get RMagick:
rmagick_options = {:require => false}
rmagick_options.update({
  :git => 'git://github.com/refinerycms/rmagick.git',
  :branch => 'windows'
}) if Bundler::WINDOWS

# Specify a version of RMagick that works in your environment:
gem 'rmagick',                  '~> 2.12.0', rmagick_options

# END REFINERY CMS ============================================================
