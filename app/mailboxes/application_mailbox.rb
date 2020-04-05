# frozen_string_literal: true

class ApplicationMailbox < ActionMailbox::Base
  routing RecruitDocumentsMailbox::MATCHER => :recruit_documents
end
