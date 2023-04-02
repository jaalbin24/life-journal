import { Controller } from "@hotwired/stimulus"
import Picture from "/assets/resources/picture"

// Connects to data-controller="picture-viewer"
export default class extends Controller {
  connect() {
    console.log("GLEE");
    this.pictureViewerEl = document.getElementById('picture-viewer');
    this.formEl = this.pictureViewerEl.querySelector('form');
    this.titleField = this.pictureViewerEl.querySelector('input#picture_title')
    this.descriptionField = this.pictureViewerEl.querySelector('textarea#picture_description')
    this.imgEl = this.pictureViewerEl.querySelector('img#picture-viewer-img')
    this.saveMessageContainer = this.pictureViewerEl.querySelector('#save-message-container');
    this.changeMode('show');
    this.pictures = new Array();
    console.log("MORE GLEE");
  }
  close() {
    this.pictureViewerEl.classList.add('opacity-0');
    this.pictureViewerEl.addEventListener('transitionend', addHidingClass)
  }
  async open(e) {
    console.log("GLEEFUL");
    this.setSaveMessage();
    this.changeMode(e.currentTarget.dataset.mode);
    this.getPictureById(
      e.currentTarget.dataset.picId,
    ).then(picture => {
      console.log(picture);
      this.mount(picture);
      this.pictureViewerEl.classList.remove('hiding');
      this.pictureViewerEl.classList.remove('opacity-0');
    });
  }
  // show, new, edit
  changeMode(mode) {
    if (!mode || mode === this.currentMode) {
      return;
    }
    switch (mode) {
      case 'show':
        // Hide
        break;
      case 'new':
        break;

      case 'edit':

        break;
    }
  }
  mount(picture) {
    this.imgEl.setAttribute('src', picture.fileUrl);
    this.titleField.value = picture.title;
    this.descriptionField.value = picture.description;
    this.formEl.setAttribute('action', `/pictures/${picture.id}`);
    this.formEl.setAttribute('method', 'patch');
    // replace textContent of title and description elements
    this.currentPicture = picture;
  }

  async getPictureById(id) {
    let localPicture = this.pictures.find(p => p.id === id);
    if (!localPicture) {
      console.warn(`No picture with id=${id} found locally. Attempting to retrieve from remote server.`);
      let remotePicture = await this.getPictureFromRemote(id);
      if (!remotePicture) {
        console.error(`No picture with id=${id} found on remote server!`);
      } else {
        return remotePicture;
      }
    } else {
      console.warn(`Picture with id=${id} found locally.`);
      return localPicture;
    }
  }
  async getPictureFromRemote(id) {
    let pictureData =  await fetch(`/pictures/${id}`, {
      headers: {
        'Content-Type': 'application/json',
      }
    }).then((response) => {
      return response.json();
    }).then((data) => {
      return data;
    });
    let picture = new Picture(
      pictureData.id,
      pictureData.file_url,
      pictureData.title,
      pictureData.description
    )
    this.pictures.push(picture);
    return picture;
  }

  submitForm(e) {
    let submitButton = e.currentTarget;
    submitButton.disabled = true;
    this.setSaveMessage('saving');
    fetch(this.formEl.getAttribute('action'), {
      'method': this.formEl.getAttribute('method').toUpperCase(),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content'),
      },
      body: JSON.stringify({
        picture: {
          title: this.titleField.value,
          description: this.descriptionField.value,
        }
      })
    }).then((response) => {
      return response.status;
    }).then((status) => {
      if (status == 200) {
        this.setSaveMessage('saved');
        this.currentPicture.title = this.titleField.value;
        this.currentPicture.description = this.descriptionField.value;
      } else {
        this.setSaveMessage('error');
      }
      submitButton.disabled = false;
    }).catch(e => {
      this.setSaveMessage('error');
      console.error(e);
      submitButton.disabled = false;
    });
  }
  setSaveMessage(type) {
    let saveMessageEls = this.saveMessageContainer.querySelectorAll('[name]');
    for (const saveMessageEl of saveMessageEls) {
      if (saveMessageEl.getAttribute('name') == type) {
        saveMessageEl.classList.remove('hiding');
      } else {
        saveMessageEl.classList.add('hiding');
      }
    }
  }
}



function addHidingClass(e) {
  console.log(e.propertyName);
  if (e.propertyName != 'opacity') {
    return;
  }
  e.currentTarget.classList.add('hiding');
  e.currentTarget.removeEventListener('transitionend', addHidingClass);
}

