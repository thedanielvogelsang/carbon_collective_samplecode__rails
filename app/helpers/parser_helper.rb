module ParserHelper

  def parse_attrs_for_nil
    self.attributes.keys.each do |att|
      if self[att] == ''
        self[att] = nil
      end
    end
  end

  def capitalize_first_line
    add = self.address_line1.split(' ')
    self.address_line1 = add
            .map{|a| a.capitalize }
            .join(' ')
  end

  def append_second_line
    addr = self.address_line2
    if addr && !addr.scan(/\d+/).empty?
      self.address_line2 = addr.scan(/\d+/).map{|n| '#' + n.to_s }.join('')
    end
  end
end
