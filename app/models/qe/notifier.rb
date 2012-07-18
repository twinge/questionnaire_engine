module Qe
  class Notifier < ActionMailer::Base
    include Qe::Concerns::Models::Notifier
  end
end
