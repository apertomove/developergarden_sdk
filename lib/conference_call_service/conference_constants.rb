module ConferenceCallService
  class ConferenceConstants

    # Conference Status.
    @@STATUS_ALL = 0
    
    # Conference Status.
    @@STATUS_DETAIL = 1

    # Conference Status.
    @@STATUS_PARTICIPANTS = 2

    # Conference Status.
    @@STATUS_SCHEDULE = 3

    # Conference Participant Action constant.
    @@ACTION_MUTE = 1

    # Conference Participant Action constant.
    @@ACTION_UNMUTE = 0

    # Conference list constant.
    @@CONFERENCE_LIST_ALL = 0

    # Conference list constant.
    @@CONFERENCE_LIST_ADHOC = 1

    # Conference list constant.
    @@CONFERENCE_LIST_SCHEDULE = 2

    def self.STATUS_ALL
      @@STATUS_ALL
    end

    def self.STATUS_DETAIL
      @@STATUS_DETAIL
    end

    def self.STATUS_PARTICIPANTS
      @@STATUS_PARTICIPANTS
    end

    def self.STATUS_SCHEDULE
      @@STATUS_SCHEDULE
    end

    def self.ACTION_MUTE
      @@ACTION_MUTE
    end

    def self.ACTION_UNMUTE    
      @@ACTION_UNMUTE
    end

    def self.CONFERENCE_LIST_ALL
      @@CONFERENCE_LIST_ALL
    end

    def self.CONFERENCE_LIST_ADHOC
      @@CONFERENCE_LIST_ADHOC
    end

    def self.CONFERENCE_LIST_SCHEDULE
      @@CONFERENCE_LIST_SCHEDULE
    end
  end
end