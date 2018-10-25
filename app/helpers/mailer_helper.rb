module MailerHelper
  def show_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      puts "opening!"
      raw file.read
    end
  end
end
