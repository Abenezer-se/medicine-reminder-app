# Product Requirements

## Functional Requirements

1. **User Registration and Login**
   - The system must allow users to create an account using email or phone number.
   - Users must be able to securely log in and log out.
   - Passwords must be stored securely (hashed).

2. **Add Medicine**
   - The system must allow users to add medicine details including name, dosage, and schedule.
   - Users should be able to add optional notes or instructions for each medicine.

3. **Set Reminder Time**
   - Users must be able to set multiple reminders per medicine.
   - Reminders can repeat daily, weekly, or custom intervals.
   - Reminders should sync with the device clock to avoid missed notifications.

4. **Notification Reminder**
   - The app must send push notifications when it is time to take medicine.
   - Notifications must work even if the app is closed.
   - Notifications should display medicine name, dosage, and time.

5. **Medicine History**
   - Users must be able to view their history of taken and missed doses.
   - The system should generate daily, weekly, and monthly summary reports.
   - Missed medicines must be flagged clearly.

6. **Edit Medicine Schedule**
   - Users must be able to update medicine details or change reminder times.
   - Changes must immediately update notifications.

7. **Delete Medicine**
   - Users must be able to remove medicines from their list.
   - Deleting a medicine should also cancel its associated reminders.

8. **Search and Filter Medicines**
   - Users must be able to search medicines by name.
   - Users must be able to filter medicines by status: active, completed, or missed.

9. **Map / Pharmacy Locator**
   - The app must display nearby pharmacies and clinics on an interactive map.
   - Users should be able to click on a pharmacy to see contact info and directions.
   - Optional: Users can filter by open now or distance.

10. **Dark Mode / Light Mode**
    - Users must be able to switch between dark and light mode.
    - The theme should apply to all app screens consistently.

11. **User Settings**
    - Users must be able to manage notification preferences (enable/disable, sound, vibration).
    - Users must be able to update account information (name, email/phone, password).
    - The app should provide a clear way to reset settings to default.

---

## Non-Functional Requirements

1. **Performance**
   - The app should load any screen within 2 seconds.
   - Notifications must be delivered reliably on time.

2. **Usability**
   - The app must be intuitive and easy to use for elderly and non-technical users.
   - Instructions and labels must be clear and concise.

3. **Compatibility**
   - The app must run on Android and iOS devices (minimum OS versions: Android 8+, iOS 13+).
   - The map feature must work with Google Maps or equivalent.

4. **Security**
   - All user data must be encrypted at rest and in transit.
   - The app must handle authentication securely and prevent unauthorized access.

5. **Reliability**
   - Notifications and reminders must work even if the app is in the background or closed.
   - Data must be saved and synced reliably to prevent loss.

6. **Accessibility**
   - The app must support screen readers and high-contrast mode.
   - Font sizes and buttons must be adjustable for visually impaired users.