class UserLogHelper

  def self.user_logs_in(id)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first + ' ' + u.last} logs in: #{Time.now}\n")
    f.close
  end

  def self.user_presses_button(id, name, page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first + ' ' + u.last} presses #{name} button on #{page}: #{Time.now}\n")
    f.close
  end

  def self.user_lands_on_page(id, page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first} lands on #{page}: #{Time.now}\n")
    f.close
  end

  def self.user_leaves_page(id, prev_page, next_page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first} leaves #{page}, for #{next_page}: #{Time.now}\n")
    f.close
  end

  def user_hits_nav_button(id, type, prev_page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first} hits #{type} button on #{prev_page}: #{Time.now}\n")
    f.close
  end

end
