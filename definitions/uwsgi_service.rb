define :uwsgi_service, 
    :home_path => "/var/www/app", 
    :pid_path => "/var/run/uwsgi-app.pid", 
    :uwsgi_path => "/usr/local/bin/uwsgi",
    :host => "127.0.0.1", 
    :port => 8080, 
    :worker_processes => 2, 
    :uid => "www-data",
    :gid => "www-data",
    :master => false,
    :no_orphans => false,
    :die_on_term => false,
    :close_on_exec => false,
    :lazy => false,
    :disable_logging => false,
    :threads => nil,
    :harakiri => nil,
    :stats => nil,
    :emperor => nil,
    :vacuum => false,
    :enable_threads => false,
    :buffer_size => nil do
  include_recipe "runit"


  # need to assign params to local vars as we can't pass params to nested definitions
  home_path = params[:home_path]
  pid_path = params[:pid_path]
  uwsgi_path = params[:uwsgi_path]
  host = params[:host]
  port = params[:port]
  worker_processes = params[:worker_processes]
  uid = params[:uid]
  gid = params[:gid]
  extra_params = ""
  extra_params += " -w %s" % [params[:app]] if params[:app]
  extra_params += " --master" if params[:master]
  extra_params += " --lazy" if params[:lazy]
  extra_params += " --no-orphans" if params[:no_orphans]
  extra_params += " --die-on-term" if params[:die_on_term]
  extra_params += " --close-on-exec" if params[:close_on_exec]
  extra_params += " --disable-logging" if params[:disable_logging]
  extra_params += " --enable-threads" if params[:enable_threads]
  extra_params += " --vacuum" if params[:vacuum]
  extra_params += " --threads %d" % [params[:threads]] if params[:threads]
  extra_params += " --harakiri %d" % [params[:harakiri]] if params[:harakiri]
  extra_params += " --stats %s" % [params[:stats]] if params[:stats]
  extra_params += " --emperor %s" % [params[:emperor]] if params[:emperor]
  extra_params += " --buffer-size %s" % [params[:buffer_size]] if params[:buffer_size]
  extra_params += " --ini %s" % [params[:ini]] if params[:ini]
  extra_params += " --xml %s" % [params[:xml]] if params[:xml]
  extra_params += " --yaml %s" % [params[:yaml]] if params[:yaml]
  extra_params += " --json %s" % [params[:json]] if params[:json]
  extra_params += " --http %s" % [params[:http]] if params[:http]
  extra_params += " --socket %s:%s" % [params[:host], params[:port]] if params[:host] and params[:port]
  
  runit_service "uwsgi" do
    service_name "uwsgi"
    run_template_name "uwsgi"
    log_template_name "uwsgi"
    cookbook "uwsgi"
    options ({
      :uwsgi_path => uwsgi_path,
      :home_path => home_path,
      :pid_path => pid_path,
      :worker_processes => worker_processes,
      :uid => uid,
      :gid => gid,
      :extra_params => extra_params
    })
  end
end
