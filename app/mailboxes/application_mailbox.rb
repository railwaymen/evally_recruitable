# frozen_string_literal: true

class ApplicationMailbox < ActionMailbox::Base
  routing RecruitDocumentsMailbox::EMAIL_MATCHER => :recruit_documents
  routing RecruitDocumentsMailbox::GROUP_EMAIL => :recruit_documents
end
