class AwsService

  def initialize
    @conn = Aws::S3::Client.new(
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
      region: ENV['S3_REGION'],
    )
  end

  def create_new_logfile
    body = []
    UserLog.all.each do |ul|
      body.push("#{ul.id},#{ul.time},#{ul.user_id},#{ul.action},#{ul.page},#{ul.next_page},#{ul.detail},#{ul.description},#{ul.num},#{ul.msg}\n")
    end
    name = DateTime.now.strftime("%Y-%m-%d %H:%M:00s").to_s + "-userlogs"
    if UserLog.count != 0 && put_object(name, body)
      UserLog.destroy_all
    end
  end   

  def put_object (name, body)
    @conn.put_object({
        bucket: ENV["S3_BUCKET_NAME"],
        key: name,
        body: body.join(''),
      })
  end

end
