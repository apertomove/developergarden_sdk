module ConferenceCallService

  # Indicates when to start a conference call.
  # Be ware that times are are relative to the UTC timezone.
  class ConferenceSchedule
    attr_accessor :minute, :hour, :day_of_month, :month, :year, :recurring, :notify

    @@RECURRING_NONE = 0
    @@RECURRING_HOURLY = 1
    @@RECURRING_DAILY = 2
    @@RECURRING_WEEKLY = 3
    @@RECURRING_MONTHLY = 4

    # Constructor
    def initialize(minute = Time.now.min, hour = Time.now.hour, day_of_month = Time.now.day, month = Time.now.month, year = Time.now.year, recurring = @@RECURRING_NONE, notify = 0)
      @minute = minute
      @hour = hour
      @day_of_month = day_of_month
      @month = month
      @year = year
      @recurring = recurring
      @notify = notify
    end

    def to_s
      ret = "#{year}-#{month}-#{day_of_month} #{hour}:#{minute} Recurring: #{recurring}, Notify: #{notify}\n"
      ret
    end

    def add_to_handsoap_xml(xml_doc)
      xml_doc.add('minute', @minute.to_s)
      xml_doc.add('hour', @hour.to_s)
      xml_doc.add('dayOfMonth', @day_of_month.to_s)
      xml_doc.add('month', @month.to_s)
      xml_doc.add('year', @year.to_s)
      xml_doc.add('recurring', @recurring.to_s)
      xml_doc.add('notify', @notify.to_s)
    end

    #### Static methods

    def self.build_from_xml(xml_doc)

      # If the service responds with non-0000 answer there might me no schedule infos available
      if xml_doc then
        minute = ConferenceCallService.xpath_query(xml_doc, "minute").to_s
        hour = ConferenceCallService.xpath_query(xml_doc, "hour").to_s
        day_of_month = ConferenceCallService.xpath_query(xml_doc, "dayOfMonth").to_s
        month = ConferenceCallService.xpath_query(xml_doc, "month").to_s
        year = ConferenceCallService.xpath_query(xml_doc, "year").to_s
        recurring = ConferenceCallService.xpath_query(xml_doc, "recurring").to_s
        notify = ConferenceCallService.xpath_query(xml_doc, "notify").to_s
        new(minute, hour, day_of_month, month, year, recurring, notify)
      end
    end

    def self.RECURRING_NONE
      @@RECURRING_NONE
    end

    def self.RECURRING_HOURLY
      @@RECURRING_HOURLY
    end

    def self.RECURRING_WEEKLY
      @@RECURRING_WEEKLY
    end

    def self.RECURRING_MONTHLY
      @@RECURRING_MONTHLY
    end
  end
end