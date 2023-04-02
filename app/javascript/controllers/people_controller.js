import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="people"
export default class extends Controller {
  connect() {
    this.searchResultsEl = document.getElementById('people-search-results-area');
    this.searchField = document.getElementById('people-search-field');
    this.searchBox = document.getElementById('people-search-box');
    this.searchMountPoint = document.getElementById('people-search-mount-point');
    this.entryForm = document.querySelector("form[id='entry_form']")
    this.nameMountPoint = document.getElementById('people-name-mount-point');
    this.people = [];
    this.nameMountPoint.querySelectorAll('li[data-id]').forEach(el => this.people.push({
      id: el.getAttribute('data-id'),
      name: el.querySelector("span[name='person-name']"),
      avatarUrl: el.querySelector("img").getAttribute('src'),
      preAttached: true,
    }));
  }
  search() {
    if (this.searchField.value.length <= 2) {
      this.hideSearchResults();
      return;
    }
    fetch(this.searchResultsEl.getAttribute('data-search-path'), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content'),
      },
      body: JSON.stringify({
        person: {
          name: this.searchField.value,
        }
      })
    }).then((response) => {
      return response.json();
    }).then((data) => {
      this.searchMountPoint.innerHTML = '';
      if (data.length == 0 || data == null) {
        let personEl = document.createElement('p');
        personEl.classList.add('search-result-item', 'text-center');
        personEl.innerText = "No results found";
        this.searchMountPoint.appendChild(personEl);
      } else {
        data.forEach(e => {
          // Add person to people array if they're not already there.
          if (!this.people.some(el => el.id === e.id)) {
            this.people.push({
              id: e.id,
              name: e.name,
              avatarUrl: e.avatar_url,
              preAttached: false,
            });
          }

          let personEl = document.createElement('button');
          personEl.classList.add('search-result-item', 'actionable', 'grow');
          personEl.setAttribute('type', 'button');
          personEl.setAttribute('data-id', e.id);
          personEl.setAttribute('data-action', 'click->people#addPersonToEntry');
          personEl.addEventListener('focusin', (e)=>{
            e.stopPropagation();
          });
          
          let personNameEl = document.createElement('span');
          personNameEl.textContent = e.name;

          personEl.appendChild(genImgEl(e.avatar_url));
          personEl.appendChild(personNameEl);
          this.searchMountPoint.appendChild(personEl);
        });
      }
      this.showSearchResults();
    });
  }
  showSearchResults() {
    if (this.searchField.value == '') {
      this.searchMountPoint.innerHTML = '';
      this.hideSearchResults();
      return;
    }
    this.searchBox.classList.remove('rounded-b-lg');
    this.searchResultsEl.classList.remove('hidden');
  }
  hideSearchResults(e) {
    if(e != null) {
      setTimeout(()=>{
        this.hideSearchResults();
      }, 200);
      return;
    }
    this.searchBox.classList.add('rounded-b-lg');
    this.searchResultsEl.classList.add('hidden');
  }
  //{name, avatar_url, delete_mention_path(entry_id, person_id)}
  addPersonToEntry(e) {
    e.stopPropagation();
    let person = this.people.find(el => el.id == e.currentTarget.getAttribute('data-id'));
    if (this.nameMountPoint.querySelector(`[data-id='${person.id}']`) == null) {
      this.renderPersonName(person);
      this.attachPersonInputField(person);
      this.hideSearchResults();
    }
  }

  removePersonFromEntry(e) {
    let person = this.people.find(el => el.id == e.currentTarget.parentElement.getAttribute('data-id'));
    this.removePersonName(person);
    if (person.preAttached) {
      this.setInputFieldToDestroy(person);
    } else {
      this.removeInputField(person);
    }
  }

  renderPersonName(person) {
    const parser = new DOMParser();
    const htmlString = 
    `<li class="person-name" data-id="${person.id}">
      ${genImgEl(person.avatarUrl).outerHTML}
      ${person.name}
      <button class="close-button" type="button" data-action="click->people#removePersonFromEntry"></button>
    </li>`;
    const doc = parser.parseFromString(htmlString, 'text/html');
    const personName = doc.querySelector('li');
    document.getElementById('people-name-mount-point').append(personName);
  }

  removePersonName(person) {
    this.nameMountPoint.querySelector(`li[data-id='${person.id}']`).remove();
  }

  attachPersonInputField(person) {
    let flagged = true;
    let count = 0;
    while(flagged) {
      let name = `entry[mentions_attributes][${count}][person_id]`;
      let inputField = document.querySelector(`input[name='${name}']`);
      if(inputField === null) { // If there is no input element with that name...
        flagged = false;
        inputField = document.createElement('input');
        inputField.setAttribute('type', 'hidden');
        inputField.setAttribute('name', name);
        inputField.setAttribute('value', person.id);
        this.entryForm.appendChild(inputField);
      } else {
        count += 1;
      }
    }
  }

  setInputFieldToDestroy(person) {
    let inputFields = document.querySelectorAll(`input[type='hidden'][value='${person.id}']`)
    inputFields.forEach(el => el.setAttribute('name', el.getAttribute('name').replace('person_id', '_destroy')));
  }
  unsetInputFieldToDestroy(person) {
    let inputFields = document.querySelectorAll(`input[type='hidden'][value='${person.id}']`)
    inputFields.forEach(el => el.setAttribute('name', el.getAttribute('name').replace('_destroy', 'person_id')));
  }
  removeInputField(person) {
    document.querySelector(`input[type='hidden'][value='${person.id}']`).remove();
  }
}

function genImgEl(src) {
  let img = document.createElement('img');
  img.setAttribute('src', src);
  img.setAttribute('width', 24);
  img.setAttribute('height', 24);
  img.classList.add('person-avatar');
  let div = document.createElement('div');
  div.classList.add('person-avatar-container');
  div.style.width = '24px';
  div.style.paddingBottom = '24px';
  div.appendChild(img);
  return div;
}