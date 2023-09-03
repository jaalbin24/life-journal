import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="entries"
export default class extends Controller {
  connect() {
    form = this.element
    statusField = form.querySelector("input#entry_status");
    saveBar = form.querySelector("turbo-frame#entry-save-bar");
  }

  publish() {
    statusField.setAttribute("value", "published")

    Turbo.visit(form.action, {
      action: form.method,
      params: new URLSearchParams(new FormData(form)),
      target: saveBar
    });
  }
  unpublish() {
    statusField.setAttribute("value", "draft")

    Turbo.visit(form.action, {
      action: form.method,
      params: new URLSearchParams(new FormData(form)),
      target: saveBar
    });
  }

}

let form;
let statusField;
let saveBar