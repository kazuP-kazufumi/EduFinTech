# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "stylesheets")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "stylesheets", "base")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "stylesheets", "components")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "stylesheets", "layouts")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "stylesheets", "pages")

# Precompile additional assets.
Rails.application.config.assets.precompile += %w[ *.css ]
Rails.application.config.assets.precompile += %w[ *.js ]

Rails.application.config.assets.precompile += %w[ application.js ]

# Enable serving of static files from the `/public` folder by default
Rails.application.config.serve_static_files = true

# Enable serving of static files from the `/public` folder in development
Rails.application.config.serve_static_assets = true

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
