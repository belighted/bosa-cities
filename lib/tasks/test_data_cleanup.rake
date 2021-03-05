# frozen_string_literal: true

namespace :i_know_what_im_doing do
  task test_data_cleanup: :environment do
    Decidim::Initiative.destroy_all
    Decidim::Suggestion.destroy_all
  end
end
