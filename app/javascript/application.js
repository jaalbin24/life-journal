// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import barba from '@barba/core'
import "trix"
import "@rails/actiontext"


window.barba = barba;
barba.init({
  transitions: [{
    name: 'opacity-transition',
    from: {
      // define a custom rule based on the trigger class
      custom: () => {
        return true;
      },
    },
    to: {
      // define rule based on multiple namespaces
      custom: () => {
        return true;
      },
    },
    leave(data) {
      console.log("leave()");
      return gsap.to(data.current.container, {
        position: 'absolute',
        opacity: 0
      });
    },
    enter(data) {
      console.log("enter()");
      return gsap.from(data.next.container, {
        opacity: 0
      });
    }
  }]
});
