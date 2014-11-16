class Typeform
  attr_accessor :key

  def initialize(key = "bd7c0cc32f7d9dc87e6c57627a081533753d2d86")
    @key = key
  end

  def get_form_data(url, complete = true)
    id_one = typeform_id(url)

    begin
      query = "https://api.typeform.com/v0/form/#{id_one}?key=#{key}&completed=#{complete}"
      response = HTTParty.get(query).parsed_response
      return response
    rescue Exception => e
      puts "Exception getting events: #{e}"
    end
    return nil
  end

  private
    def typeform_id(url)
      parts = url.split('/')
      return parts.last
    end

    def build_data(response)
    end
end
