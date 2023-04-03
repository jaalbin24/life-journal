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
    this.imgContainerEl = this.pictureViewerEl.querySelector('#picture-viewer-img-container')
    this.uploadLabelEl = this.pictureViewerEl.querySelector('label#new-picture-label')
    this.uploadField = this.pictureViewerEl.querySelector('input#picture_file')
    this.saveMessageContainer = this.pictureViewerEl.querySelector('#save-message-container');
    this.entryId = document.querySelector('[data-entry-id]').getAttribute('data-entry-id');
    console.log(`ENTRY ID = ${this.entryId}`)
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
        this.imgContainerEl.classList.add('hiding');
        this.uploadLabelEl.classList.remove('hiding');
        // Replace img element with upload element
        // 
        break;
      case 'edit':
        this.imgContainerEl.classList.remove('hiding');
        this.uploadLabelEl.classList.add('hiding');

        break;
    }
    if (this.currentPicture != null) {
      this.mount(this.currentPicture);
    }
  }
  mount(picture) {
    this.titleField.value = picture.title;
    this.descriptionField.value = picture.description;
    if (picture.id) {
      this.formEl.setAttribute('action', `/pictures/${picture.id}`);
      this.formEl.setAttribute('method', 'patch');
    } else {
      this.formEl.setAttribute('action', `/entries/${this.entryId}/pictures`);
      console.log(`ACTION SET TO ${`/entries/${this.entryId}/pictures`}`)
      this.formEl.setAttribute('method', 'post');
    }
    if (picture.fileUrl) {
      this.imgEl.setAttribute('src', picture.fileUrl);
    }
    this.currentPicture = picture;
  }

  async getPictureById(id) {
    let localPicture = this.pictures.find(p => p.id === id);
    if (!id) {
      return new Picture(null, null, "", "");
    } else if (!localPicture) {
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
    console.log(`Action before submitting is ${this.formEl.getAttribute('action')}`);
    const formData = new FormData(this.formEl);
    fetch(this.formEl.getAttribute('action'), {
      'method': this.formEl.getAttribute('method').toUpperCase(),
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content'),
      },
      body: formData
    }).then((res) => {
      console.log(res);
      if (res.status === 200 || res.status === 204) {
        this.setSaveMessage('saved');
      } else {
        this.setSaveMessage('error');
      }
      submitButton.disabled = false;
      return res.json();
    }).then((picture) => {
      console.log(picture);
      this.currentPicture.id = picture.id;
      this.currentPicture.title = picture.title;
      this.currentPicture.description = picture.description;
      this.currentPicture.fileUrl = picture.file_url;
      this.changeMode('edit');
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

  // Called when file input field changes
  newPicture(e) {
    // Get img from input field
    // Hide upload label.
    // Render it to img element.
    // Render it to the pictures card.
    // Iterate over files w/ e.currentTarget.files
    this.renderPicture(this.uploadField.files[0]);
  }
  renderPicture(file) {
    let reader = new FileReader();
    reader.addEventListener('load', ()=>{
      this.imgEl.src = reader.result;
    });
    reader.readAsDataURL(file);
    this.uploadLabelEl.classList.add('hiding');
    this.imgContainerEl.classList.remove('hiding');
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

