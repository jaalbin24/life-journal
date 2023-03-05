import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fader"
export default class extends Controller {
  connect() {

  }

  fadeIn(e) {
    e.stopImmediatePropagation();
    console.log('fadeIn() fired for %O', e.target);
    let targetId = e.currentTarget.getAttribute('data-target');
    if(targetId == null) {
      e.currentTarget.classList.remove('hiding');
      setTimeout(()=>{
        e.currentTarget.style.opacity = 1;
      }, 100);
    } else {
      let target = document.getElementById(targetId);
      target.classList.remove('hiding');
      setTimeout(()=>{
        target.style.opacity = 1;
      }, 100);
    }
  }

  fadeOut(e) {
    e.stopImmediatePropagation();
    console.log('fadeOut() fired for %O', e.target);
    let targetId = e.currentTarget.getAttribute('data-target');
    console.log("targetId: %s", targetId);
    if(targetId == null) {
      setTimeout(()=>{
        e.currentTarget.style.opacity = 0;
      }, 100);
      e.currentTarget.addEventListener('transitionend', addHidingClass);
    } else {
      let target = document.getElementById(targetId);
      console.log("target: %O", target);
      setTimeout(()=>{
        target.style.opacity = 0;
      }, 100);
      target.addEventListener('transitionend', addHidingClass);
    }
  }
}

function addHidingClass(e) {
  console.log('addHidingClass() fired!');
  if (e.currentTarget.style.opacity !== '0') {
    return;
  }
  e.currentTarget.classList.add('hiding');
  e.currentTarget.removeEventListener('transitionend', addHidingClass);
}