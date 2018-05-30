module ParserHelper

  def parse_attrs_for_nil
    self.attributes.keys.each do |att|
      if self[att] == ''
        self[att] = nil
      end
    end
  end

end
