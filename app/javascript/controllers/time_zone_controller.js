import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="time-zone"
export default class extends Controller {
  static values = {
    current: String,
    url: String
  }

  connect() {
    this.updateTimezone();
  }

  updateTimezone() {
    // Get the user's current time zone
    const clientTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    console.log('Client time zone: ' + clientTimeZone);
    // Compare it with the data-time-zone attribute value
    if (this.currentValue !== clientTimeZone) {
      console.log("Client time zone (" + clientTimeZone + ") does not match user's time zone (" + this.currentValue + "). Updating remote time zone...");
      // Setup the data to be sent
      const data = { user: { time_zone: clientTimeZone } };

      // Fetch API to send the request
      fetch(this.urlValue, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          // Add other headers like 'X-CSRF-Token' as needed
          'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify(data)
      })
      .then(response => {
        if (response.ok) {
          return response;
        } else {
          throw new Error('Network response was not ok.');
        }
      })
      .then(data => {
        console.log('Time zone updated to: ' + clientTimeZone);
      })
      .catch(error => {
        console.error('There was an error updating the time zone:', error);
      });
    } else {
      // No need to update as the time zone matches
      console.log("The client time zone matches the user's current time zone. No update needed.");
    }
  }
}
