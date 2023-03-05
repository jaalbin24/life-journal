import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="potd"
// 'potd' means 'picture of the day'
export default class extends Controller {
  connect() {
  }
  showFileField() {
    // fade out potd if it exists
    // fade in file field
  }

  hideFileField() {
    // fade out file field
    // fade in potd if it exists
  }

  addPictureToEntry() {
    // fade out old picture
    // add input field
    // fade in new picture
  }

  removePictureFromEntry() {
    // fade out old picture
    // add input field with value = ""
  }
}
