import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="people"
export default class extends Controller {
  connect() {
    this.searchResultsEl = document.getElementById('people-search-results-area');
    this.searchField = document.getElementById('people-search-field');
    this.searchBox = document.getElementById('people-search-box');
    this.searchMountPoint = document.getElementById('people-search-mount-point');
    this.people = [];
  }
  search() {
    console.log('Searching...')
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
          if (!this.people.some(el => el.publicId === e.public_id)) {
            this.people.push({
              publicId: e.public_id,
              name: e.name,
              showPath: e.show_path,
              avatarUrl: e.avatar_url,
            });
          }

          let personEl = document.createElement('button');
          personEl.classList.add('search-result-item', 'actionable', 'grow');
          personEl.setAttribute('type', 'button');
          personEl.setAttribute('data-public-id', e.public_id);
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
      console.log(this.people);
    });
  }
  showSearchResults() {
    console.log('Focused inside div');
    console.log(`value=${this.searchField.value}`);
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
      console.log(e.target);
      setTimeout(()=>{
        this.hideSearchResults();
      }, 200);
      return;
    }
    console.log('Focused outside div');
    this.searchBox.classList.add('rounded-b-lg');
    this.searchResultsEl.classList.add('hidden');
  }
  //{name, avatar_url, delete_mention_path(entry_public_id, person_public_id)}
  addPersonToEntry(e) {
    e.stopPropagation();
    console.log("IT WORKS BWAHAHAHAHAHA");
    let person = this.people.find(el => el.publicId == e.currentTarget.getAttribute('data-public-id'))
    this.showPersonName(person);
    //attachPersonInputField(person);
    this.hideSearchResults();
  }

  showPersonName(person) {
    const parser = new DOMParser();
    const htmlString = 
    `<li class="person-name" data-public-id="${person.publicId}">
      ${genImgEl(person.avatarUrl).outerHTML}
      ${person.name}
      <button class="close-button" type="button"></button>
    </li>`;
    const doc = parser.parseFromString(htmlString, 'text/html');
    const personName = doc.querySelector('li');
    document.getElementById('people-name-mount-point').append(personName);
  }
}

function genImgEl(src) {
  let img = document.createElement('img');
  img.setAttribute('src', src);
  img.setAttribute('width', 24);
  img.setAttribute('height', 24);
  img.classList.add('person-avatar');
  return img;
}