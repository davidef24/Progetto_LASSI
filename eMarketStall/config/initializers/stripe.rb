Rails.application.configure do
    config.stripe.secret_key = ENV["STRIPE_SECRET_KEY"]
    config.stripe.publishable_key = ENV["STRIPE_PUBLISHABLE_KEY"]
    Stripe.api_version = '2020-08-27'
end

