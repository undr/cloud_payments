# frozen_string_literal: true
module CloudPayments
  module LikeSubscription
    ACTIVE = 'Active'
    PAST_DUE = 'PastDue'
    CANCELLED = 'Cancelled'
    REJECTED = 'Rejected'
    EXPIRED = 'Expired'

    def active?
      status == ACTIVE
    end

    def past_due?
      status == PAST_DUE
    end

    def cancelled?
      status == CANCELLED
    end

    def rejected?
      status == REJECTED
    end

    def expired?
      status == EXPIRED
    end
  end
end
