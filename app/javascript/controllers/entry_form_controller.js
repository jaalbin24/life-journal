import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="entry-form"
export default class extends Controller {
  connect() {
    this.formEl = document.querySelector("form#entry_form");
    this.pictureInputFieldEl = this.formEl.querySelector("input[type='file'][name='']");
    this.boundAddPicturesToForm = this.addPicturesToForm.bind(this)
    this.pictureInputFieldEl.addEventListener('change', this.boundAddPicturesToForm);
    this.picturesMountPoint = this.formEl.querySelector("#pictures-mount-point");
  }
  // Triggered when 'publish' button is pressed
  publish(e) {
    e.preventDefault();
    let inputEl = document.createElement('input');
    inputEl.setAttribute('name', 'entry[published]');
    inputEl.setAttribute('value', 'true');
    inputEl.setAttribute('type', 'hidden');
    this.formEl.appendChild(inputEl);
    this.formEl.submit();
  }
  // Called when file input field changes
  addPicturesToForm() {
    console.log("Added picture!");
    // Iterate over files w/ e.currentTarget.files
    for (const file of this.pictureInputFieldEl.files) {
      this.renderPicture(file)
      // this.addPictureInputEl
    }
  }
  renderPicture(file) {
    let reader = new FileReader();
    reader.addEventListener('load', ()=>{
      const img = new Image();
      img.src = reader.result;
      this.picturesMountPoint.appendChild(genPictureContainer(img));
    });
    reader.readAsDataURL(file);
  }
}

function genPictureContainer(img) {
  const parser = new DOMParser();
  const htmlString =
    `<div id="${img}-card" class="relative rounded-lg overflow-hidden" data-action="mousemove->fader#fadeIn mouseleave->fader#fadeOut" data-target="${img}-fader">
      <div id="${img}-fader"class="h-full w-full border-dashed border-gray-600 border flex rounded-lg bg-slate-900/50 z-20 absolute hiding opacity-0 transition-opacity">
        <div class="ml-auto mb-auto">
          <button data-action="" class="close-button" type="button"></button>
        </div>
      </div>
    </div>`;
  const doc = parser.parseFromString(htmlString, 'text/html');
  const container = doc.getElementById(`${img}-card`);
  img.classList.add('h-48','w-full','object-cover');
  container.appendChild(img);
  return container;
}