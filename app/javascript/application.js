// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"







window.addEventListener('load', () => {
    console.log("Loaded!");
    document.body.classList.add('fade-in', 'active');
    const links = document.querySelectorAll('');
    links.forEach(link => {
        link.addEventListener('click', e => {
            console.log("Clicked!");
            e.preventDefault();
            const href = link.getAttribute('href');
            document.body.classList.add('fade-out');
            setTimeout(() => {
                window.location.href = href;
            }, 500);
        });
    });
});

