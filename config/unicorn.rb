root = "/var/www/blog_from_scratch/current"
working_directory root
stdout_path "#{root}/log/unicorn.out.log"
stderr_path "#{root}/log/unicorn.err.log"
pid "#{root}/tmp/pids/unicorn.pid"

listen "/tmp/unicorn.blog_from_scratch.sock"
working_processes 2
timeout 30