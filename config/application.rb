require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CatSite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true

    # 言語を日本語対応にする設定
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # 以下の記述を追記する(設定必須)
    # デフォルトのlocaleを日本語(:ja)にする
    config.i18n.default_locale = :ja

    # エラーメッセージの日本語化指定のファイルを読み込ませるための設定
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    
  end
end
