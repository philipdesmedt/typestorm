class Analytics
  require 'nokogiri'
  require 'open-uri'
  require 'differ'
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def self.filter_unique_questions(data, incomplete_data)
    uniques = {}
    complexity = 0
    questions = data['questions']
    questions.each do |question|
      parts = question['id'].split('_')
      id = "#{parts[0]}_#{parts[1]}"
      if !uniques[id]
        uniques[id] = {
          question: question['question'],
          responses: data['responses'].map{ |r| r['answers'] }.select{ |s| s[id] }.count
        }
        if question['question'].include? "email"
          complexity += 1.5
        elsif id.include? "yesno"
          complexity += 0.1
        elsif id.include? "rating"
          complexity += 0.2
        elsif id.include? "choice"
          complexity += 0.5
        else
          complexity += 1
        end
      end
    end
    uniques['complexity'] = complexity.round(1)
    return uniques
  end

  def analyze
    analytics = {}
    begin
      typeform = Typeform.new
      analytics['data_one'] = typeform.get_form_data(params[:url1])
      analytics['data_two'] = typeform.get_form_data(params[:url2])
      analytics['incomplete_data_one'] = typeform.get_form_data(params[:url1], false)
      analytics['incomplete_data_two'] = typeform.get_form_data(params[:url2], false)
      analytics['drop_off_one'] = drop_off_rates(analytics['incomplete_data_one'])
      analytics['drop_off_two'] = drop_off_rates(analytics['incomplete_data_two'])

      analytics['required_questions_one'] = required_questions(params[:url1])
      analytics['required_questions_two'] = required_questions(params[:url2])

      analytics['questions_one'] = Analytics.filter_unique_questions(analytics['data_one'], analytics['incomplete_data_one'])
      analytics['questions_two'] = Analytics.filter_unique_questions(analytics['data_two'], analytics['incomplete_data_two'])
      
      analytics['conversion_rate_one'] = ((analytics['data_one']['stats']['responses']['completed'].to_f/analytics['data_one']['stats']['responses']['total'].to_f)*100).round(2)
      analytics['conversion_rate_two'] = ((analytics['data_two']['stats']['responses']['completed'].to_f/analytics['data_two']['stats']['responses']['total'].to_f)*100).round(2)

      best_ab_version = best_version(analytics)
      analytics['best_ab_version'] = best_ab_version
    rescue Exception => e
      puts "ERROR: #{e.message}"
    end
    return analytics
  end

  private
    def best_version(analytics)
      # Conversion Rate
      # Complexity
      # Number of Questions
      a_score = 0
      b_score = 0
      if analytics['conversion_rate_one'] > analytics['conversion_rate_two']
        a_score += 2
      else
        b_score += 2
      end

      if analytics['questions_one']['complexity'] > analytics['questions_two']['complexity']
        b_score += 1
      else
        a_score += 1
      end

      if analytics['questions_one'].length-1 > analytics['questions_two'].length-1
        a_score += 1
      else
        b_score += 1
      end

      winner = a_score > b_score ? 'a' : 'b'
      return {
        "winner" => winner,
        "a_score" => a_score*25,
        "b_score" => b_score*25
      }
    end

    def get_social_sources(data)
      puts data
    end

    def required_questions(url)
      doc = Nokogiri::HTML(open(url))
      (doc.to_s.scan(/"required":true/).length)/2
    end

    def drop_off_rates(data)
      drop_off_at_questions = {}
      data['responses'].each do |response|
        question_id = response['answers'].keys.last
        if drop_off_at_questions[question_id]
          drop_off_at_questions[question_id] += 1
        else
          drop_off_at_questions[question_id] = 1
        end
      end
      return drop_off_at_questions
    end
end
