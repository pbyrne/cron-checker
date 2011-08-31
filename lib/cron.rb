class Cron
  attr :statement, true
  attr :statement_fragments
  attr :minute, true
  attr :hour, true
  attr :dom, true
  attr :month, true
  attr :dow, true
  attr :command, true
  attr :valid
  attr :english, true
  
  # aliasing the Date:: arrays for ease of use
  MONTHNAMES = Date::MONTHNAMES
  ABBR_MONTHNAMES = Date::ABBR_MONTHNAMES
  DAYNAMES = Date::DAYNAMES
  ABBR_DAYNAMES = Date::ABBR_DAYNAMES
  
  # The list of accepted special schedule flags
  SPECIAL_SCHEDULES = %w(@reboot @hourly @daily @midnight @monthly @yearly @annually)
  
  # common regexes
  # just a number, like '5', '10', or '30'
  NUMBER = /^\d+$/
  # a range of numbers, like '0-10' or '25-30'
  NUMBER_RANGE = /^\d+\-\d+$/
  # a list of numbers, like '1,2' or '5, 10, 45'
  NUMBER_LIST = /^\d+(,\d+)+$/
  # a list of ranges, like '1-2,4-10'
  NUMBER_LIST_OF_RANGES = /^\d+(-\d+)?(,\d+(-\d+)?)+$/
  # asterisk step definitions, like '*/5' or '*/23'
  STEPS = /^\*\/\d+$/
  # number step definitions, like '1-10/2' or '7-12/3'
  NUMBER_STEPS = /^\d+\-\d+\/\d+$/
  
  def initialize(statement)
    @statement = statement
    @valid = false
    @minute = @hour = @dom = @month = @dow = @command = nil
    @english = {}
    
    parse_statement
  end
  
  def parse_statement
    @statement_fragments = statement.split
    if SPECIAL_SCHEDULES.include? statement_fragments[0]
      @valid = true
      
      @command = statement_fragments[1..-1].join(' ')
      case statement_fragments[0]
      when "@reboot"
        english[:time] = ""
        english[:date] = "when the computer reboots"
      when "@hourly"
        @minute = "0"
        @hour = @dom = @month = @dow = "*"

        english[:time] = plain_english_time
        english[:date] = plain_english_date
      when "@daily", "@midnight"
        @minute = @hour = "0"
        @dom = @month = @dow = "*"
        
        english[:time] = plain_english_time
        english[:date] = plain_english_date
      when "@monthly"
        @minute = @hour = "0"
        @dom = "1"
        @month = @dow = "*"
        
        english[:time] = plain_english_time
        english[:date] = plain_english_date
      when "@yearly", "@annually"
        @minute = @hour = "0"
        @dom = @month = "1"
        @dow = "*"
        
        english[:time] = plain_english_time
        english[:date] = plain_english_date
      end        
    elsif statement_fragments.size >= 6
      # initially supposing it's valid, will override if english parsing proves otherwise
      @valid = true
      
      @minute = statement_fragments[0]
      @hour = statement_fragments[1]
      @dom = statement_fragments[2]
      @month = statement_fragments[3]
      @dow = statement_fragments[4]
      @command = statement_fragments[5..-1].join(' ')      
      
      english[:time] = plain_english_time
      english[:date] = plain_english_date
    end
    
  end
  
  def valid?
    @valid
  end
  
  def plain_english
    "The command <code>#{command}</code> will execute #{english[:time].blank? ? '' : english[:time] + ' '}#{english[:date]}."
  end
  
  def plain_english_time
    result = ''
    
    if minute =~ NUMBER && hour =~ NUMBER
      h = hour.to_i >= 12 ? hour.to_i - 12 : hour.to_i
      m = minute.rjust(2, '0')
      z = hour.to_i >= 12 ? 'pm' : 'am'
      # and after picking the am/pm, reset midnight (0) to 12 for display purposes
      h = 12 if h == 0
      result << "at #{h}:#{m}#{z} on"
    else
      if minute == '*'
        result << "every minute of "
      elsif minute =~ NUMBER
        result << "the #{minute.to_i.ordinalize} minute of "
      elsif minute =~ STEPS
        number_of_minutes = minute.delete('*/')
        result << "every #{number_of_minutes} minutes of "
      elsif minute =~ NUMBER_RANGE
        first, last = minute.split('-').map(&:to_i)
        result << "the #{first.ordinalize}–#{last.ordinalize} minutes of "
      elsif minute =~ NUMBER_LIST
        numbers = minute.split(',').map {|x| x.to_i.ordinalize}
        result << "the #{numbers.to_sentence} minutes of "
      elsif minute =~ NUMBER_LIST_OF_RANGES
        numbers_ranges = minute.split(',')
        numbers = numbers_ranges.map { |x| "#{x.split('-')[0].to_i.ordinalize}–#{x.split('-')[1].to_i.ordinalize}" }
        result << "the #{numbers.to_sentence} minutes of "
      elsif minute =~ NUMBER_STEPS
        first, last, step = minute.split(/[\-\/]/).map(&:to_i)
        result << "every #{step} minutes in the #{first.ordinalize}–#{last.ordinalize} minutes of "
      else
        @valid = false
      end
      
      if hour == "*"
        result << "every hour on"
      elsif hour =~ NUMBER
        h = hour.to_i >= 12 ? hour.to_i - 12 : hour.to_i
        z = hour.to_i >= 12 ? 'pm' : 'am'
        result << "#{h}#{z} on"
      elsif hour =~ STEPS
        number_of_hours = hour.delete('*/')
        result << "every #{number_of_hours} hours on"
      elsif hour =~ NUMBER_RANGE
        first, last = hour.split('-').map(&:to_i)
        result << "the #{first.ordinalize}–#{last.ordinalize} hours on"
      elsif hour =~ NUMBER_LIST
        numbers = hour.split(',').map {|x| x.to_i.ordinalize}
        result << "the #{numbers.to_sentence} hours of"
      elsif hour =~ NUMBER_LIST_OF_RANGES
        numbers_ranges = hour.split(',')
        numbers = numbers_ranges.map { |x| "#{x.split('-')[0].to_i.ordinalize}–#{x.split('-')[1].to_i.ordinalize}" }
        result << "the #{numbers.to_sentence} hours of"
      elsif hour =~ NUMBER_STEPS
        first, last, step = hour.split(/[\-\/]/).map(&:to_i)
        result << "every #{step} hours in the #{first.ordinalize}–#{last.ordinalize} hours of"
      else
        @valid = false
      end
    end
    
    result
  end
  
  def plain_english_date
    result = ''
    # "every day of every month."
    
    if dom == '*'
      if dow == '*'
        result << "every day "
      elsif ABBR_DAYNAMES.include?(dow.titlecase)
        result << "every #{DAYNAMES[ABBR_DAYNAMES.index(dow.titlecase)]} "
      elsif dow =~ NUMBER_RANGE
        first, last = dow.split('-').map(&:to_i)
        if DAYNAMES[first] && DAYNAMES[last]
          result << "#{DAYNAMES[first]}–#{DAYNAMES[last]} "
        else
          @valid = false
        end
      elsif dow =~ NUMBER_LIST
        names = dow.split(',').map { |n| DAYNAMES[n.to_i] }
        # the list is invalid if any of the numbers aren't in DAYNAMES, which would return nil
        if names.include? nil
          @valid = false
        else
          result << "#{names.to_sentence} "
        end
      elsif dow =~ NUMBER_LIST_OF_RANGES
        numbers_ranges = dow.split(',')
        numbers = numbers_ranges.map { |x| "#{DAYNAMES[x.split('-')[0]]}–#{DAYNAMES[x.split('-')[1]]}" }
        result << "#{numbers.to_sentence} "
      elsif dow =~ NUMBER_STEPS
        first, last, step = dow.split(/[\-\/]/).map(&:to_i)
        result << "every #{step} days in the #{DAYNAMES[first]}–#{DAYNAMES[last]} "
      end
    elsif @valid
      days = []
      if dom =~ NUMBER
        days << "the #{dom.to_i.ordinalize} "
      elsif dom =~ NUMBER_RANGE
        first, last = dom.split('-').map(&:to_i)
        days << "the #{first.ordinalize}–#{last.ordinalize} "
      elsif dom =~ NUMBER_LIST
        numbers = dom.split(',').map {|x| x.to_i.ordinalize}
        days << "the #{numbers.to_sentence} "
      elsif dom =~ NUMBER_LIST_OF_RANGES
        numbers_ranges = dom.split(',')
        numbers = numbers_ranges.map { |x| "#{x.split('-')[0].to_i.ordinalize}–#{x.split('-')[1].to_i.ordinalize}" }
        days << "the #{numbers.to_sentence} "
      elsif dom =~ NUMBER_STEPS
        first, last, step = dom.split(/[\-\/]/).map(&:to_i)
        days << "every #{step} days in the #{first.ordinalize}–#{last.ordinalize} "
      else
        @valid = false
      end
      
      if dow == '*'
        # don't do much.
      elsif dow =~ NUMBER
        # use % 7, since we accept either 0 or 7 to mean Sunday
        days << "every #{DAYNAMES[dow.to_i % 7]} "
      elsif dow =~ NUMBER_LIST
        names = dow.split(',').map { |n| DAYNAMES[n.to_i] }
        # the list is invalid if any of the numbers aren't in DAYNAMES, which would return nil
        if names.include? nil
          @valid = false
        else
          days << "every #{names.to_sentence} "
        end
      elsif dow =~ NUMBER_LIST_OF_RANGES
        numbers_ranges = dow.split(',')
        numbers = numbers_ranges.map { |x| "#{DAYNAMES[x.split('-')[0].to_i]}–#{DAYNAMES[x.split('-')[1].to_i]}" }
        # the list is invalid if any of the numbers aren't in DAYNAMES, which sould result in "–Mon" or "Tue–" or "–"
        if numbers.select{|x| x.starts_or_ends_with?("–")}.size > 0
          @valid = false
        else 
          days << "every #{numbers.to_sentence} "
        end
      elsif dow =~ NUMBER_STEPS
        first, last, step = dow.split(/[\-\/]/).map(&:to_i)
        days << "every #{step} days in every #{DAYNAMES[first]}–#{DAYNAMES[last]} "
      else
        @valid = false
      end
      
      result << days.join("and ")
    end
    
    if month == '*'
      result << "of every month"
    elsif ABBR_MONTHNAMES.include? month.titlecase
      result << "in #{MONTHNAMES[ABBR_MONTHNAMES.index(month.titlecase)]}"
    elsif month =~ NUMBER
      if MONTHNAMES[month.to_i]
        result << "of #{MONTHNAMES[month.to_i]}"
      else
        @valid = false
      end
    elsif month =~ NUMBER_RANGE
      first, last = month.split('-').map(&:to_i)
      result << "of #{MONTHNAMES[first]}–#{MONTHNAMES[last]}"
    elsif month =~ NUMBER_LIST
      # TODO add failing test with a list including an invalid dow number (like 1, 4, 50)
      names = month.split(',').map { |n| MONTHNAMES[n.to_i] }
      result << "of #{names.to_sentence}"
    elsif month =~ NUMBER_LIST_OF_RANGES
      # TODO add failing test with a list including an invalid dow number (like 1, 4, 50)
      numbers_ranges = month.split(',')
      names = numbers_ranges.map { |x| "#{MONTHNAMES[x.split('-')[0].to_i]}–#{MONTHNAMES[x.split('-')[1].to_i]}" }
      result << "of #{names.to_sentence}"
    elsif month =~ NUMBER_STEPS
      first, last, step = month.split(/[\-\/]/).map(&:to_i)
      result << "of every #{step} months in #{MONTHNAMES[first]}–#{MONTHNAMES[last]}"
    elsif month =~ STEPS
      number_of_months = month.delete("*/")
      result << "of every #{number_of_months.to_i.ordinalize} month"
    else
      @valid = false
    end
    
    result
  end
end
