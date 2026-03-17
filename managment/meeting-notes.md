## Meeting 1 – Project Kickoff 
Attendees: Project Manager, Product Manager, UX/UI Designer, Flutter Developers, Tester

Discussion:
- Decided to build a medicine reminder app.  
- Roles:
  - Project Manager: oversee project, timeline, and team coordination.  
  - Product Manager: define app features, write requirements, and prioritize user stories.  
  - UX/UI Designer: create initial app screens and design flow in Figma.  
  - Developers: set up Flutter project and environment for implementation.  
  - Tester: plan testing strategy, track bugs, and ensure app meets requirements once development starts.  
- App features discussed: reminders, notifications, medicine history.  
- Technical stack: Flutter/Dart for frontend and backend, database options (Firebase or SQLite).  

Next Steps:
- Product Manager finalizes feature list and requirements document.  
- UX/UI Designer starts creating Figma designs based on requirements.  
- Developers set up Flutter project structure and environment.  
- Tester prepares testing checklist and plans for later verification.  
- Project Manager organizes shared folder and GitHub repo for designs, docs, and code.  
- Team to review designs and requirements in the next meeting before development begins.

______________________________________________________

## Meeting 2 – Feature Review & Requirement Confirmation

Attendees: Project Manager, Product Manager, UX/UI Designer, Flutter Developers, Tester

 Discussion:

- Product Manager presented the **complete feature list** for the Medicine Reminder App.
- The team reviewed and confirmed the following features:

1. Add Medicine with dosage, notes, and schedule
2. Multiple Reminder Time settings (daily, weekly, custom)
3. Push Notification Reminder even when the app is closed
4. Medicine History tracking with summary reports
5. Edit Medicine Schedule
6. Delete Medicine
7. Search and Filter Medicines
8. Map / Pharmacy Locator to find nearby pharmacies and clinics
9. Dark Mode / Light Mode theme option
10. User Settings for notification preferences and app preferences

- UX/UI Designer discussed initial screen planning based on features:

  * Home dashboard with today’s reminders
  * Add Medicine form
  * Medicine history page
  * Map screen for pharmacy locator
  * Settings screen

- Developers analyzed **technical requirements and complexity:**

  * Local database (SQLite) can be used for medicine storage.
  * Push notifications require background service integration.
  * Map feature may require Google Maps API integration.

- Tester identified **important testing focus areas:**

  * Reminder accuracy and notification timing
  * Data saving and updating correctness
  * App performance when running in background
  * Map loading and location permission handling

* Project Manager confirmed timeline priorities and suggested implementing **core features first (Add Medicine, Reminder, Notification, History)** before advanced features like Map Locator and Theme settings.

- Decisions Made:

* Core features will be implemented in Phase 1.
* Advanced features will be implemented in Phase 2.
* UX/UI Designer will finalize wireframes before coding begins.

### Next Steps:

* UX/UI Designer prepares complete Figma wireframes.
* Developers start implementing Add Medicine module and local database integration.
* Tester prepares structured test cases.
* Product Manager updates requirement document if changes occur.
* Project Manager schedules Meeting 3 for development progress review.
