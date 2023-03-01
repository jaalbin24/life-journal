# Pin npm packages by running ./bin/importmap

pin "application",                                                      preload: true
pin "@hotwired/stimulus",                   to: "stimulus.min.js",      preload: true
pin "@hotwired/stimulus-loading",           to: "stimulus-loading.js",  preload: true
pin_all_from "app/javascript/controllers",  under: "controllers"

pin "@barba/core", to: "https://ga.jspm.io/npm:@barba/core@2.9.7/dist/barba.umd.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
