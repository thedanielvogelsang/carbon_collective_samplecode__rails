desc "clears rails pid when frozen"
task :clear_pid do
  pid_file = File.open("/Users/thedanielvogelsang/ContractWork/CarbonCollective/carbon_collective/tmp/pids/server.pid")
  pid = pid_file.read.to_i
  Process.kill 9, pid
end
