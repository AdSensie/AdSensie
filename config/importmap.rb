# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "https://cdn.jsdelivr.net/npm/@hotwired/turbo-rails@8.0.12/+esm"
pin "@hotwired/stimulus", to: "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"
pin "@hotwired/turbo", to: "https://cdn.jsdelivr.net/npm/@hotwired/turbo@8.0.12/+esm"
pin "@rails/actioncable/src", to: "https://cdn.jsdelivr.net/npm/@rails/actioncable@7.1.3/+esm"

pin_all_from "app/javascript/controllers", under: "controllers"

# Relative imports used in controllers/index.js
pin "./application", to: "controllers/application.js"
pin "./channel_comparison_controller", to: "controllers/channel_comparison_controller.js"
pin "./hello_controller", to: "controllers/hello_controller.js"
pin "./loading_controller", to: "controllers/loading_controller.js"
pin "./removal_controller", to: "controllers/removal_controller.js"
pin "./sync_controller", to: "controllers/sync_controller.js"
