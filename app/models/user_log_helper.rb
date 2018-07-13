class UserLogHelper

  def self.user_logs_in(id)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first + ' ' + u.last} logs in: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_logs_out(id)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first + ' ' + u.last} logs out: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_presses_button(id, name, page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("Action: presses #{name} button on #{page}: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_lands_on_page(id, page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("lands on #{page}: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_leaves_page(id, prev_page, next_page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#leaves #{prev_page}, for #{next_page}: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_hits_nav_button(id, type, prev_page)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#Navbar: hits #{type} button from #{prev_page}: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_adds_bill(id, type)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first} adds new #{type} bill: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_completes_questionairre(id, type)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{u.first} completes #{type} bill questionairre: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n")
    f.close
  end

  def self.user_invites_someone(user, num, msg)
    f = File.new("log/userlogs/#{user.filename}", "a")
    f.write("#{user.first} #{user.last} invited #{num} people to Carbon Collective!: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n---> saying this: #{msg}\n")
    f.close
  end
  def self.user_sends_suggestion(user, msg)
    f = File.new("log/userlogs/#{user.filename}", "a")
    f.write("#{user.first} #{user.last} sends suggestion: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n---> saying this: #{msg}\n")
    f.close
  end
  def self.user_finds_bug(user, msg)
    f = File.new("log/userlogs/#{user.filename}", "a")
    f.write("#{user.first} #{user.last} finds a bug: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")}\n---> saying this: #{msg}\n")
    f.close
  end

  def self.page_mounted(id, page, time)
    u = User.find(id)
    f = File.new("log/userlogs/#{u.filename}", "a")
    f.write("#{page} mounts: #{time}\n")
    f.close
  end

end
