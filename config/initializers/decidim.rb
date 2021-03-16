# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "bosa"
  config.mailer_sender = "no-reply@democratie.brussels"
  config.mailer_reply = "no-reply@democratie.brussels"

  # Change these lines to set your preferred locales
  config.default_locale = :en
  config.available_locales = [:en, :ca, :es, :fr, :nl, :de]

  config.maximum_attachment_height_or_width = 6000

=begin
  # run in a rails console before database migration

  timestamps_to_add = ["20180611124757", "20180611124758", "20180611124759", "20180611124760", "20180611124761", "20180611124762", "20180611124763", "20180611124764", "20180611124765", "20180611124766", "20180611124767", "20180611124768", "20180611124769", "20180611124770", "20180611124771", "20180611124772", "20180611124773", "20180611124774", "20180611124775", "20180611124776", "20180611124777", "20180611124778", "20180611124779", "20180611124780", "20180611124781", "20180611124782", "20180611124783", "20180611124784", "20180611124785", "20180611124786", "20180611124787", "20180611124788", "20180611124789", "20180611124790", "20180611124791", "20180611124792", "20180611124793", "20180611124794", "20180611124795", "20180611124796", "20180611124797", "20180611124798", "20180611124799", "20180611124800", "20180611124801", "20180611124802", "20180611124803", "20180611124804", "20180611124805", "20180611124806", "20180611124807", "20180611124808", "20180611124809", "20180611124810", "20180611124811", "20180611124812", "20180611124813", "20180611124814", "20180611124815", "20180611124816", "20180611124817", "20180611124818", "20180611124819", "20180611124820", "20180611124821", "20180611124822", "20180611124823", "20180611124824", "20180611124825", "20180611124826", "20180611124827", "20180611124828", "20180611124829", "20180611124830", "20180611124831", "20180611124832", "20180611124833", "20180611124834", "20180611124835", "20180611124836", "20180611124837", "20180611124838", "20180611124839", "20180611124840", "20180611124842", "20180611124843", "20180611124844", "20180611124845", "20180611124846", "20180611124847", "20180611124848", "20180611124849", "20180611124850", "20180611124851", "20180611124852", "20180611124853", "20180611124854", "20180611124855", "20180611124856", "20180611124857", "20180611124858", "20180611124859", "20180611124860", "20180611124861", "20180611124862", "20180611124863", "20180611124864", "20180611124865", "20180611124866", "20180611124867", "20180611124868", "20180611124869", "20180611124870", "20180611124871", "20180611124872", "20180611124873", "20180611124874", "20180611124875", "20180611124876", "20180611124877", "20180611124878", "20180611124879", "20180611124880", "20180611124881", "20180611124882", "20180611124883", "20180611124884", "20180611124885", "20180611124886", "20180611124887", "20180611124888", "20180611124889", "20180611124890", "20180611124891", "20180611124892", "20180611124893", "20180611124894", "20180611124895", "20180611124896", "20180611124897", "20180611124898", "20180611124899", "20180611124900", "20180611124901", "20180611124902", "20180611124903", "20180611124904", "20180611124905", "20180611124906", "20180611124907", "20180611124908", "20180611124909", "20180611124910", "20180611124911", "20180611124912", "20180611124913", "20180611124914", "20180611124915", "20180611124916", "20180611124917", "20180611124918", "20180611124919", "20180611124920", "20180611124921", "20180611124922", "20180611124923", "20180611124924", "20180611124925", "20180611124926", "20180611124927", "20180611124928", "20180611124929", "20180611124930", "20180611124931", "20180611124932", "20180611124933", "20180611124934", "20180611124935", "20180611124936", "20180611124937", "20180611124938", "20180611124939", "20180611124940", "20180611124941", "20180611124942", "20180611124943", "20180611124944", "20180611124945", "20180611124946", "20180611124947", "20180611124948", "20180611124949", "20180611124950", "20180611124951", "20180611124952", "20180611124953", "20180611124954", "20180611124955", "20180611124956", "20180611124957", "20180611124958", "20180611124959", "20180611124960", "20180611124961", "20180611124962", "20180611124963", "20180611124964", "20180611124965", "20180611124966", "20180611124967", "20180611124968", "20180611124969", "20180611124970", "20180611124971", "20180611124972", "20180611124973", "20180611124974", "20180611124975", "20180611124976", "20180611124977", "20180611124978", "20180611124979", "20180611124980", "20180611124981", "20180611124982", "20180611124983", "20180611124984", "20180611124985", "20180611124986", "20180611124987", "20180611124988", "20180611124989", "20180611124990", "20180611124991", "20180611124992", "20180611124993", "20180611124994", "20180611124995", "20180611124996", "20180611124997", "20180611124998", "20180611124999", "20180611125000", "20180611125001", "20180611125002", "20180611125003", "20180611125004", "20180611125005", "20180611125006", "20180611125007", "20180611125008", "20180611125009", "20180611125010", "20180611125011", "20180611125012", "20180611126841", "20180611142713", "20180611142714", "20180611142715", "20180611142716", "20180611142717", "20180611142718", "20180709170619", "20181012230414", "20181012230415", "20181012230416", "20181012230417", "20181012230418", "20181012230419", "20181012230420", "20181012230421", "20181012230422", "20181012230423", "20181012230424", "20181012230425", "20181012230426", "20181012230427", "20181012230428", "20181012230429", "20181012230430", "20181012230431", "20181012230432", "20181012230433", "20181012230434", "20181012230435", "20181012230436", "20181012230437", "20181012230438", "20181012230439", "20181012230440", "20181012230441", "20181012230442", "20181012230443", "20181012230444", "20181012230445", "20181012230446", "20181220220344", "20181220220345", "20181220220346", "20181220220347", "20181220220348", "20181220220349", "20181220220350", "20181220220351", "20181220220352", "20181220220353", "20181220220354", "20181220220355", "20181220220356", "20181220220357", "20181220220358", "20181220220359", "20181220220360", "20181220220413", "20181220220420", "20181220220427", "20181220220428", "20181220220434", "20181220220441", "20181220220442", "20181220220443", "20181220220444", "20181220220445", "20181220220448", "20181220220449", "20181220220509", "20181220220510", "20181220220511", "20181220220512", "20181220220513", "20181220220514", "20181220220515", "20181220220516", "20190201194852", "20190304203102", "20190304203114", "20190304203149", "20190419230330", "20190502162611", "20190603100903", "20190717132651", "20190717132652", "20190717132653", "20190717132655", "20190717132743", "20190717132756", "20190717132828", "20190904100654", "20190904100655", "20190904100656", "20191203163447", "20191203163448", "20200109202520", "20200131210316"]
  timestamps_to_add << '20200202135602' # 20200202135602_add_deepl_api_key_to_organization.decidim.rb

  class SchemaMigration < ActiveRecord::Base; self.primary_key = :version; end

  timestamps_to_add.sort.each do |ts|
    SchemaMigration.create(version: ts) unless SchemaMigration.exists?(ts)
  end

=end

  # Restrict access to the system part with an authorized ip list.
  # You can use a single ip like ("1.2.3.4"), or an ip subnet like ("1.2.3.4/24")
  # You may specify multiple ip in an array ["1.2.3.4", "1.2.3.4/24"]
  # config.system_whitelist_ips = ["127.0.0.1"]

  # Geocoder configuration
  if Rails.application.secrets.geocoder[:here_api_key].present?
    config.geocoder = {
      static_map_url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview",
      here_api_key: Rails.application.secrets.geocoder[:here_api_key]
    }
  end

  # Custom resource reference generator method
  # config.reference_generator = lambda do |resource, component|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  # config.currency_unit = "€"

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This component also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = true

  # SMS gateway configuration
  #
  # If you want to verify your users by sending a verification code via
  # SMS you need to provide a SMS gateway service class.
  #
  # An example class would be something like:
  #
  # class MySMSGatewayService
  #   attr_reader :mobile_phone_number, :code
  #
  #   def initialize(mobile_phone_number, code)
  #     @mobile_phone_number = mobile_phone_number
  #     @code = code
  #   end
  #
  #   def deliver_code
  #     # Actual code to deliver the code
  #     true
  #   end
  # end
  #
  # config.sms_gateway_service = "MySMSGatewayService"

  # Timestamp service configuration
  #
  # Provide a class to generate a timestamp for a document. The instances of
  # this class are initialized with a hash containing the :document key with
  # the document to be timestamped as value. The istances respond to a
  # timestamp public method with the timestamp
  #
  # An example class would be something like:
  #
  # class MyTimestampService
  #   attr_accessor :document
  #
  #   def initialize(args = {})
  #     @document = args.fetch(:document)
  #   end
  #
  #   def timestamp
  #     # Code to generate timestamp
  #     "My timestamp"
  #   end
  # end
  #
  config.timestamp_service = "Decidim::Initiatives::UtcTimestamp"

  # PDF signature service configuration
  #
  # Provide a class to process a pdf and return the document including a
  # digital signature. The instances of this class are initialized with a hash
  # containing the :pdf key with the pdf file content as value. The instances
  # respond to a signed_pdf method containing the pdf with the signature
  #
  # An example class would be something like:
  #
  # class MyPDFSignatureService
  #   attr_accessor :pdf
  #
  #   def initialize(args = {})
  #     @pdf = args.fetch(:pdf)
  #   end
  #
  #   def signed_pdf
  #     # Code to return the pdf signed
  #   end
  # end
  #
  # config.pdf_signature_service = "MyPDFSignatureService"

  # Etherpad configuration
  #
  # Only needed if you want to have Etherpad integration with Decidim. See
  # Decidim docs at docs/services/etherpad.md in order to set it up.
  #
  # config.etherpad = {
  #   server: Rails.application.secrets.etherpad[:server],
  #   api_key: Rails.application.secrets.etherpad[:api_key],
  #   api_version: Rails.application.secrets.etherpad[:api_version]
  # }
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
