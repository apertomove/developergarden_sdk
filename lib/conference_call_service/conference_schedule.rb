module ConferenceCallService

  # Indicates when to start a conference call.
  # Be ware that times are are relative to the UTC timezone.
  class ConferenceSchedule
    attr_accessor :minute, :hour, :day_of_month, :month, :year, :recurring, :notify

    @@RECURRING_NONE      = 0
    @@RECURRING_HOURLY    = 1
    @@RECURRING_DAILY     = 2
    @@RECURRING_WEEKLY    = 3
    @@RECURRING_MONTHLY   = 4

    # Constructor
    def initialize(minute = Time.now.min, hour = Time.now.hour, day_of_month = Time.now.day, month = Time.now.month, year = Time.now.year, recurring = @@RECURRING_NONE)
      @minute        = minute
      @hour          = hour
      @day_of_month  = day_of_month
      @month         = month
      @year          = year
      @recurring     = recurring
    end

    #### Static methods

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