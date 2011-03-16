# Deploy PHP-sites using Capistrano

# Usage:
# cap deploy:setup
# cap deploy


# Inspirational URLs:
# http://www.claytonlz.com/index.php/2008/08/php-deployment-with-capistrano/
# http://paulschreiber.com/blog/2009/03/15/howto-deploy-php-sites-with-capistrano-2/
# http://wiki.dreamhost.com/index.php/Capistrano
# http://www.capify.org/index.php/Getting_Started
# http://www.jonmaddox.com/2006/08/16/automated-php-deployment-with-capistrano/
# http://github.com/leehambley/railsless-deploy

set :application, "capistrano-php"
set :repository,  "http://svn.subtree.se/private/#{application}/trunk"

# Application Deployment Location
#
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/palbrattberg/veterankraft.subtree.se/#{application}"
set :document_root, "/home/palbrattberg/veterankraft.subtree.se/httpdocs/current"

set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# Source Control Settings
#
set :scm_username, "scm-user-name" #if http
set :scm_password, "scm-password" #if http
#set :scm_checkout, "export" # may be necessary for some SCMs

role :app, "zwerbach.dreamhost.com"
role :web, "zwerbach.dreamhost.com"
role :db,  "zwerbach.dreamhost.com", :primary => true

# SSH data
set :user, "my-user-name-at-server"
#set :password, "password-at-server"

set :use_sudo, false
set :ssh_options, {:forward_agent => true}

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do

  task :update do
    transaction do
      update_code
      symlink
    end
  end

  task :finalize_update do
    transaction do
      run "chmod -R g+w #{releases_path}/#{release_name}"
    end
  end

  task :symlink do
    transaction do
      run "ln -nfs #{current_release} #{deploy_to}/#{current_dir}"
      run "ln -nfs #{deploy_to}/#{current_dir} #{document_root}"
    end
  end

  task :migrate do
    # nothing
  end

  task :restart do
    # nothing
  end

end