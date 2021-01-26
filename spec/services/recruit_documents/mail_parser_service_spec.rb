# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruitDocuments::MailParserService do
  # Mock external requests
  before(:each) { stub_api_client_service }

  describe 'rwm mails parser' do
    it 'adds new recruit document' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+rwm@example.com'
        from        'jobs@example.com'
        subject     'Fwd: New candidate for React Native Developer | RWM Website'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            Hi Admin,

            There's a new job application for a position React Native Developer.
            Please check the details below:

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Linkedin: https://www.linkedin.com/company/railwaymen

            Github: https://github.com/railwaymen

            Links:
            * https://www.behance.net/railwaymen
            * https://dribbble.com/Railwaymen_org

            Message: Lorem ipsum ...

            Availability: Full time job

            Available since: Now

            Salary: 1500PLN

            Contract type: Civil law contract

            Work type: Remotely

            Location: London

            Accepts current processing: Yes

            Accepts future processing: Yes

            Best wishes,
            Railwaymen Dev Team

            https://bbc.com
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rwm')

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 2

      expect(recruit_document).to have_attributes(
        first_name: 'Jack',
        last_name: 'Strong',
        email: 'jstrong@example.com',
        phone: '123456789',
        position: 'React Native Developer',
        group: 'Unknown',
        source: 'RWM Website',
        accept_current_processing: true,
        accept_future_processing: true,
        received_at: mail_datetime,
        message_id: 'this_is_test_message_id@example.com',
        social_links: [
          'https://www.linkedin.com/company/railwaymen',
          'https://github.com/railwaymen',
          'https://www.behance.net/railwaymen',
          'https://dribbble.com/Railwaymen_org'
        ],
        salary: '1500PLN',
        availability: 'Full time',
        available_since: nil,
        contract_type: 'Civil law contract',
        work_type: 'Remotely',
        message: 'Lorem ipsum ...',
        location: 'London'

      )
    end

    it 'raises an error and do not save attachments' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+rwm@example.com'
        from        'jobs@example.com'
        subject     'Fwd: New candidate for React Native Developer | RWM Website'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            Hi Admin,

            There's a new job application for a position React Native Developer.
            Please check the details below:

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Linkedin: https://www.linkedin.com/company/railwaymen

            Github: https://github.com/railwaymen

            Links:
            * https://www.behance.net/railwaymen
            * https://dribbble.com/Railwaymen_org

            Message: Lorem ipsum ...

            Availability: Full time job

            Available since: Now

            Salary: 1500PLN

            Contract type: Civil law contract

            Work type: Remotely

            Location: London

            Accepts current processing: Yes

            Accepts future processing: Yes

            Best wishes,
            Railwaymen Dev Team

            https://bbc.com
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rwm')

      allow_any_instance_of(Tempfile).to receive(:rewind).and_raise(StandardError)
      expect(Rails.logger).to receive(:error).twice.and_call_original

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 0
    end
  end

  describe 'justjoinit mail parser' do
    it 'adds new recruit document' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+justjoinit@example.com'
        from        'jobs@example.com'
        subject     'Fwd: Jan Nowak is applying for Junior RoR Developer'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            *Jan Nowak* is applying for *Junior RoR Developer
            <https://example.com>
            *in* Kraków*

            *Candidate email*: jnowak@example.com
            *Message from candidate*:
            https://github.com/schodevio

            Lorem ipsum

            *✓ Processing data in future recruitment*
            I agree to the processing of my personal data by Railwaymen located in
            Kraków for the purpose of future recruitment processes.

            Copyright © 2020
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'justjoinit')

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 2

      expect(recruit_document).to have_attributes(
        first_name: 'Jan',
        last_name: 'Nowak',
        email: 'jnowak@example.com',
        phone: nil,
        position: 'Junior RoR Developer',
        group: 'Unknown',
        source: 'JustJoinIT',
        accept_current_processing: true,
        accept_future_processing: true,
        received_at: mail_datetime,
        message_id: 'this_is_test_message_id@example.com',
        social_links: [
          'https://github.com/schodevio'
        ]
      )
    end

    it 'raises an error and do not save attachments' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+justjoinit@example.com'
        from        'jobs@example.com'
        subject     'Fwd: Jan Nowak is applying for Junior RoR Developer'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            *Jak Nowak* is applying for *Junior RoR Developer
            <https://example.com>
            *in* Kraków*

            *Candidate email*: jnowak@example.com
            *Message from candidate*:
            https://github.com/schodevio

            Lorem ipsum

            *✓ Processing data in future recruitment*
            I agree to the processing of my personal data by Railwaymen located in
            Kraków for the purpose of future recruitment processes.

            Copyright © 2020
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'justjoinit')

      allow_any_instance_of(Tempfile).to receive(:rewind).and_raise(StandardError)
      expect(Rails.logger).to receive(:error).twice.and_call_original

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 0
    end
  end

  describe 'rocketjobs mail parser' do
    it 'adds new recruit document' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+rocketjobs@example.com'
        from        'jobs@example.com'
        subject     'Fwd: Will Smith aplikuje na Project Manager'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            *Will Smith* właśnie zaaplikował na stanowisko *Project Manager
            <https://example.com>
            *w miejscowości* Kraków*

            *Email kandydata*: wsmith@example.com
            *Wiadomość od kandydata*:
            Lorem ipsum ... https://github.com/railwaymen

            *✓ Zgoda na wykorzystanie danych na potrzebę przyszłych rekrutacji*
            Wyrażam zgodę na przetwarzanie moich danych osobowych dla celów przyszłych rekrutacji.

            Copyright © 2020
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rocketjobs')

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 2

      expect(recruit_document).to have_attributes(
        first_name: 'Will',
        last_name: 'Smith',
        email: 'wsmith@example.com',
        phone: nil,
        position: 'Project Manager',
        group: 'Unknown',
        source: 'RocketJobs',
        accept_current_processing: true,
        accept_future_processing: true,
        received_at: mail_datetime,
        message_id: 'this_is_test_message_id@example.com',
        social_links: [
          'https://github.com/railwaymen'
        ]
      )
    end

    it 'raises an error and do not save attachments' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+rocketjobs@example.com'
        from        'jobs@example.com'
        subject     'Fwd: Will Smith aplikuje na Project Manager'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            *Will Smith* właśnie zaaplikował na stanowisko *Project Manager
            <https://example.com>
            *w miejscowości* Kraków*

            *Email kandydata*: wsmith@example.com
            *Wiadomość od kandydata*:
            Lorem ipsum ... https://github.com/railwaymen

            *✓ Zgoda na wykorzystanie danych na potrzebę przyszłych rekrutacji*
            Wyrażam zgodę na przetwarzanie moich danych osobowych dla celów przyszłych rekrutacji.

            Copyright © 2020
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rocketjobs')

      allow_any_instance_of(Tempfile).to receive(:rewind).and_raise(StandardError)
      expect(Rails.logger).to receive(:error).twice.and_call_original

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 0
    end
  end

  describe 'nofluffjobs mail parser' do
    it 'adds new recruit document' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+nofluffjobs@example.com'
        from        'jobs@example.com'
        subject     'Fwd: New application for Junior Ruby on Rails Developer @ Company [John Doe]'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        html_part do
          body <<~BODY
            New application is waiting for you!

            Applied for: Junior Ruby on Rails Developer
            View in employer Panel

            Name: John Doe

            E-mail: jdoe@example.com

            Linkedin / Online Profile: https://www.linkedin.com/in/johndoe

            GitHub / Website: https://github.com/jdoe

            Message: Lorem ipsum dolor sit amet...

            Consent
            Processing additional data in recruitment processes: Yes
            Processing data in future recruitment processes: Yes

            Pro Tip:
            The sooner you contact the candidates the more likely they are to accept your offer.
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'nofluffjobs')

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 2

      expect(recruit_document).to have_attributes(
        first_name: 'John',
        last_name: 'Doe',
        email: 'jdoe@example.com',
        phone: nil,
        position: 'Junior Ruby on Rails Developer',
        group: 'Unknown',
        source: 'NoFluffJobs',
        accept_current_processing: true,
        accept_future_processing: true,
        received_at: mail_datetime,
        message_id: 'this_is_test_message_id@example.com',
        social_links: [
          'https://www.linkedin.com/in/johndoe',
          'https://github.com/jdoe'
        ]
      )
    end

    it 'raises an error and do not save attachments' do
      mail_datetime = Time.current.round

      mail = Mail.new do
        to          'evallyrecruitable+nofluffjobs@example.com'
        from        'jobs@example.com'
        subject     'Fwd: New application for Junior Ruby on Rails Developer @ Company [John Doe]'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        html_part do
          body <<~BODY
            New application is waiting for you!

            Applied for: Junior Ruby on Rails Developer
            View in employer Panel

            Name: John Doe

            E-mail: jdoe@example.com

            Linkedin / Online Profile: https://www.linkedin.com/in/johndoe

            GitHub / Website: https://github.com/jdoe

            Message: Lorem ipsum dolor sit amet...

            Consent
            Processing additional data in recruitment processes: Yes
            Processing data in future recruitment processes: Yes

            Pro Tip:
            The sooner you contact the candidates the more likely they are to accept your offer.
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'nofluffjobs')

      allow_any_instance_of(Tempfile).to receive(:rewind).and_raise(StandardError)
      expect(Rails.logger).to receive(:error).twice.and_call_original

      expect do
        service.perform
      end.to(change { RecruitDocument.count }.by(1))

      recruit_document = RecruitDocument.last
      expect(recruit_document.files.attachments.count).to eq 0
    end
  end

  describe 'unknown mails' do
    it 'skips parsing action' do
      mail = Mail.new do
        to          'evallyrecruitable+unknown@example.com'
        from        'jobs@example.com'
        subject     'Fwd: Notifications: New applicant for RoR Developer.'
        message_id  '<this_is_test_message_id@example.com>'
        date        Time.current.round

        text_part do
          body <<~BODY
            Hi,

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Accepted future processing data: true

            Message: Lorem ipsum ...
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'unknown')

      expect do
        expect(service.perform).to be_nil
      end.not_to(change { RecruitDocument.count })
    end
  end

  describe 'already parsed mails' do
    it 'skips parsing action' do
      mail_datetime = Time.current.round

      FactoryBot.create(
        :recruit_document,
        message_id: 'this_is_test_message_id@example.com',
        received_at: mail_datetime
      )

      mail = Mail.new do
        to          'evallyrecruitable+rwm@example.com'
        from        'jobs@example.com'
        subject     'Fwd: Notifications: New applicant for RoR Developer.'
        message_id  '<this_is_test_message_id@example.com>'
        date        mail_datetime

        text_part do
          body <<~BODY
            Hi Admin,

            Name: Jack Strong

            Email: jstrong@example.com

            Phone number: 123456789

            Linkedin: https://www.linkedin.com/company/railwaymen

            Github: https://github.com/railwaymen

            Accepted future processing data: true

            Message: Lorem ipsum ...

            Links:
            https://www.behance.net/railwaymen
            https://dribbble.com/Railwaymen_org

            Best wishes,
            Railwaymen Dev Team

            https://bbc.com
          BODY
        end

        add_file 'spec/fixtures/sample_file.txt'
      end

      service = described_class.new(mail, source: 'rwm')

      expect do
        expect(service.perform).to be_nil
      end.not_to(change { RecruitDocument.count })
    end
  end
end
