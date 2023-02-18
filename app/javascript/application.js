// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import barba from '@barba/core'



barba.init({
  transitions: [{
    name: 'opacity-transition',
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