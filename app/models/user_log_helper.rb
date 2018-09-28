class UserLogHelper

  def make_call
    Aws::S3::Client.new(
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
      region: ENV['S3_REGION'],
    )
  end

  def self.user_logs_in(id)
    u = User.friendly.find(id)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    # body = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)},#{u.id},logsin,,,,#{u.first + ' ' + u.last} logs in\n"
    UserLog.create(time: time,
                   user_id: id,
                   action: "logsin",
                   page: nil,
                   next_page: nil,
                   detail: nil,
                   description: "#{u.first + ' ' + u.last} logs in",
                   num: nil,
                   msg: nil,
            )
    # s3 = make_call
    # survey = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: ENV['S3_OBJECT_NAME'], body: body)
  end

  def self.user_logs_out(id)
    u = User.friendly.find(id)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    # body = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)},#{u.id},logsout,,,,#{u.first + ' ' + u.last} logs out\n"
    UserLog.create(time: time,
                   user_id: id,
                   action: "logsout",
                   page: nil,
                   next_page: nil,
                   detail: nil,
                   description: "#{u.first + ' ' + u.last} logs out"
            )
    # s3 = make_call
    # survey = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: ENV['S3_OBJECT_NAME'], body: body)
  end

  def self.user_presses_button(id, name, page)
    u = User.friendly.find(id)
    # body = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)},#{u.id},pressesBtn,#{page},,#{name},#{u.first + ' ' + u.last} presses #{type} button on #{prev_page}\n"
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: id,
                   action: "pressesBtn",
                   page: page,
                   detail: name,
                   description: "#{u.first + ' ' + u.last} presses #{name} button on #{page}"
            )
    # s3 = make_call
    # survey = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: ENV['S3_OBJECT_NAME'], body: body)
  end

  def self.user_lands_on_page(id, page)
    u = User.friendly.find(id)
    # body = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)},#{u.id},pageView,#{page},,,#{u.first + ' ' + u.last} lands on #{page}\n"
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: id,
                   action: "pageView",
                   page: page,
                   description: "#{u.first + ' ' + u.last} lands on #{page}"
            )
    # s3 = make_call
    # survey = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: ENV['S3_OBJECT_NAME'], body: body)
  end

  def self.user_leaves_page(id, prev_page, next_page)
    u = User.friendly.find(id)
    # body = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)},#{u.id},pageLeave,#{prev_page},#{next_page},,#{u.first + ' ' + u.last} leaves #{prev_page} for #{next_page}\n"
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: id,
                   action: "pageLeave",
                   page: prev_page,
                   next_page: next_page,
                   description: "#{u.first + ' ' + u.last} leaves #{prev_page} for #{next_page}"
            )
    # s3 = make_call
    # survey = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: ENV['S3_OBJECT_NAME'], body: body)
  end

  def self.user_hits_nav_button(id, type, prev_page)
    u = User.friendly.find(id)
    # body = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)},#{u.id},hitsNavBtn,#{prev_page},,#{type},#{u.first + ' ' + u.last} hits #{type} button on navbar from #{prev_page}\n"
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: id,
                   action: "hitsNavBtn",
                   page: prev_page,
                   detail: type,
                   description: "#{u.first + ' ' + u.last} hits #{type} button on navbar from #{prev_page}"
            )
    # s3 = make_call
    # survey = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: ENV['S3_OBJECT_NAME'], body: body)
  end

  def self.user_adds_bill(id, type)
    u = User.find(id)
    # body = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)},#{u.id},addsBill,/manageBills,,#{type},#{u.first + ' ' + u.last} adds new #{type} bill\n"
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: id,
                   action: "addsBill",
                   detail: type,
                   description: "#{u.first + ' ' + u.last} adds new #{type} bill"
            )
    # s3 = make_call
    # survey = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: ENV['S3_OBJECT_NAME'], body: body)
  end

  def self.user_completes_questionairre(id, type)
    u = User.find(id)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: id,
                   action: "completesQuestionairre",
                   detail: type,
                   description: "#{u.first + ' ' + u.last} completes #{type} bill questionairre"
            )
    # f = File.new("log/userlogs/#{u.filename}", "a")
    # f.write("#{u.first} completes #{type} bill questionairre: #{time}\n")
    # f.close
  end

  def self.user_invites_someone(user, num, msg)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: user.id,
                   action: "invitesSomeone",
                   num: num,
                   msg: msg,
                   description: "#{user.first} #{user.last} invited #{num} people to Carbon Collective!"
            )
  end
  def self.user_sends_suggestion(user, msg)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: user.id,
                   action: "sendsSuggestion",
                   msg: msg,
                   description: "#{user.first} #{user.last} sends us a suggestion!"
            )
    # f = File.new("log/userlogs/#{user.filename}", "a")
    # f.write("#{user.first} #{user.last} sends suggestion: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)}\n---> saying this: #{msg}\n")
    # f.close
  end
  def self.user_finds_bug(user, msg)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: user.id,
                   action: "sendsSuggestion",
                   msg: msg,
                   description: "#{user.first} #{user.last} found a bug"
            )
    # f = File.new("log/userlogs/#{user.filename}", "a")
    # f.write("#{user.first} #{user.last} finds a bug: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)}\n---> saying this: #{msg}\n")
    # f.close
  end

  def self.page_mounted(id, page, time)
    user = User.friendly.find(id)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: user.id,
                   action: "pageMounts",
                   page: page,
                   description: "#{page} mounts: #{time}"
            )
    # f = File.new("log/userlogs/#{u.filename}", "a")
    # f.write("#{page} mounts: #{time}\n")
    # f.close
  end

  def self.user_accepts_invite(user)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: user.id,
                   action: "acceptsInvite",
                   description: "#{user.first} #{user.last} accepts invite"
            )
    # f = File.new("log/userlogs/#{user.filename}", "a")
    # f.write("#{user.first} #{user.last} accepts invite: #{Time.now.strftime("%Y-%m-%d %H:%M:%S.%L") - (6 * 60 * 60)}\n")
    # f.close
  end

  def self.log_house_creation(id, hId)
    user = User.find(id)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: id,
                   action: "houseCreated",
                   description: "#{user.first} #{user.last} creates house with id: #{hId}"
            )
    # f = File.new("log/userlogs/#{u.filename}", "a")
    # f.write("#{u.first + ' ' + u.last} creates house at #{self.created_at}: #{h.id}: #{Time.now}\n")
    # f.close
  end

  def self.user_created(id)
    user = User.find(id)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-%d %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: user.id,
                   action: "userCreated",
                   description: "New user created: #{user.email}"
            )
  end

  def self.user_deletes_account(id)
    user = User.find(id)
    time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-% %H:%M:%S.%L")
    UserLog.create(time: time,
                   user_id: user.id,
                   action: "accountDeleted",
                   description: "#{user.first} #{user.last} deletes account: #{user.email}"
            )
  end

  def self.user_chooses_unsupported_region(id, region_hash)
    region = sort_and_find_region(region_hash)
    if region
      user = User.find(id)
      time = (Time.now - (6 * 60 * 60)).strftime("%Y-%m-% %H:%M:%S.%L")
      UserLog.create(time: time,
                    user_id: id,
                    action: "userChoosesUnsupportedRegion",
                    description: "#{user.first} #{user.last} selects unsupported region: #{region}",
                    )
    end
  end

  private

  def sort_and_find_region(region_hash)
    case region_hash[:area]
    when "Country"
      Country.find(region_hash[:id])
    when "Region"
      Region.find(region_hash[:id])
    when "County"
      County.find(region_hash[:id])
    when "City"
      City.find(region_hash[:id])
    else
      nil
    end
  end
end
