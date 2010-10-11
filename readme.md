# TZM Developer Portal

Issue tracking for the dev portal is handled in our Redmine
http://projects.zmdev.net/projects/dev-portal

The project is a Rails application built with Refinery CMS.

## Getting Started

If you want to contribute to the development of the portal itself you can fork this project.

Once you have a repository cloned on your system you'll want to run the bundler to install
necessary gems and setup/migrate the database.

    bundle install
    rake db:setup
    
You then should be able to start the WebRick server and test that it's working properly.

    rails s

If you want to run the server in the background on a different port you can set optional flags

    rail s -d -p 4000


# Links

## TZM Developers

[Portal](http://zmdev.net "Portal")
[Projects](http://projects.zmdev.net "Projects")
[Forum](http://forum.zmdev.net "Forum")
