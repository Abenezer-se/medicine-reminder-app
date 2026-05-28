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

-----------------------------------------------------------------------------------------

## Meeting 2 – Feature Review & Requirement Confirmation


Date: Week 2–3  
Attendees: Project Manager, Product Manager, UX/UI Designer, Flutter Developers, Tester

### Discussion

The Product Manager presented the complete feature list for the Medicine Reminder App. The team reviewed, discussed, and confirmed all features for inclusion.

Confirmed Feature Set:

1. Add Medicine with dosage, notes, and schedule
2. Multiple reminder time settings (daily, weekly, custom intervals)
3. Push notification reminders — functional even when the app is closed
4. Medicine history tracking with summary reports
5. Edit medicine schedule
6. Delete medicine
7. Search and filter medicines
8. Map / Pharmacy Locator — find nearby pharmacies and clinics
9. Dark Mode / Light Mode theme toggle
10. User settings for notification and app preferences

UX/UI Designer — Screen Planning:
- Home dashboard displaying today's reminders
- Add Medicine form
- Medicine history page
- Map screen for pharmacy locator
- Settings screen

Developers — Technical Analysis:
- Local database (SQLite) is sufficient for medicine storage and history.
- Push notifications will require background service integration.
- The Map / Pharmacy Locator feature will likely require Google Maps API integration.

Tester — Testing Focus Areas Identified:
- Reminder accuracy and notification timing reliability
- Data saving, editing, and deletion correctness
- App performance during background operation
- Map loading behavior and location permission handling

Project Manager confirmed that core features should be prioritized in Phase 1,
with advanced features (Map Locator, theme settings) deferred to Phase 2.

### Decisions Made

- Core features will be implemented in Phase 1.
- Advanced features will be implemented in Phase 2.
- UX/UI Designer must finalize all wireframes before development begins.

### Next Steps

- UX/UI Designer — Prepare complete Figma wireframes for all screens.
- Developers — Begin implementing the Add Medicine module and local database integration.
- Tester — Prepare structured test cases aligned to confirmed features.
- Product Manager — Update the requirements document if any changes arise.
- Project Manager — Schedule Meeting 3 for development progress review.

--------------------------------------------------------------------------------------------
## Meeting 3 – Design Review & Development Kickoff

Date: Weeks 4–5  
Attendees: Project Manager, Product Manager, UX/UI Designer, Flutter Developers, Tester

### Discussion

The UX/UI Designer presented the completed Figma wireframes for all planned screens.
The team reviewed each screen in sequence and provided feedback before clearing
development to begin.

Screens Reviewed and Approved:
- Splash screen and onboarding flow (3 slides)
- Home dashboard with today's schedule and stats
- Add Medicine bottom sheet with dose, frequency, time, and date pickers
- Medicine list screen
- History screen with adherence chart
- Health screen (BMI and Blood Pressure calculators)
- Symptom Checker screen
- Pharmacy Finder screen
- Emergency Contacts screen
- Settings screen

Technical Stack Finalized:  
After further analysis, the team agreed to replace SQLite with Hive CE as the
local database due to its better performance with Flutter and simpler API.
Firebase was deferred to a future release. The final confirmed stack:

| Technology | Purpose |
|---|---|
| Flutter / Dart | Cross-platform UI framework |
| Hive CE | Local database and persistence |
| Provider | State management |
| flutter_local_notifications | Push notifications |
| android_alarm_manager_plus | Background alarm scheduling |
| url_launcher | Phone calls, SMS, and Maps |
| fl_chart | Adherence bar charts |

Developer confirmed the Flutter project was initialized, folder structure
organized, and the GitHub repository was set up with branching conventions agreed upon.

### Decisions Made

- Hive CE adopted as the local database in place of SQLite.
- Development to begin immediately following this meeting.
- Tester to begin writing test cases in parallel with development.

### Next Steps

- Developers — Implement splash screen, onboarding, home screen, and
  the Add Medicine flow with Hive persistence.
- Tester — Write unit test cases for models and providers.
- Product Manager — Update the requirements document to reflect Hive adoption.
- Project Manager — Schedule Meeting 4 after core screens are implemented.

--------------------------------------------------------------------------------------------

## Meeting 4 – Core Development Progress Review

Date: Weeks 6–8  
Attendees: Project Manager, Product Manager, Flutter Developers, Tester

### Discussion

Developers demonstrated the first working build of the app. Core screens and
data persistence were functional. The team reviewed progress against the Phase 4 plan.

Completed and Demonstrated:
- Splash screen with logo, app name, and progress indicator
- Onboarding flow (3 slides, navigates to Home on completion)
- Home screen — greeting, today's date, stat cards (Total, Taken, Pending, Skipped),
  today's medicine schedule list with Taken and Skipped action buttons
- Add Medicine sheet — name, dose with unit dropdown, frequency dropdown,
  time picker, date picker for start and end dates
- Hive CE integration — medicines and emergency contacts persisted locally
- Provider state management wired across all screens
- Navigation drawer linking all screens

Issues Identified During Review:

 Issue | Severity | Assigned To |

 Emergency contact adapter not registered — app crash on save | Critical | Developer |
 emergencyBox opened without type parameter | Critical | Developer |
 Medicine status changes not saved to Hive after restart | Critical | Developer |
 Notification time parsing crash for AM/PM format | High | Developer |
 Splash screen delay set to 7 seconds — too long | Low | Developer |

Project Manager Note: All four critical bugs were identified before the
build was distributed for testing. Fixes were prioritized and resolved within
the same sprint.

### Decisions Made

- Critical bugs to be fixed before any further feature development proceeds.
- Alarm and notification feature development to begin immediately after bug fixes.
- Dark mode implementation to be included in Phase 5 alongside advanced features.

### Next Steps
- Developers — Fix all four critical bugs; implement alarm scheduling and
  notification service using android_alarm_manager_plus and flutter_local_notifications.
- Tester — Begin testing core screens once bug fixes are merged.
- Project Manager — Update timeline to reflect one-week delay from bug resolution.

--------------------------------------------------------------------------------------------

## Meeting 5 – Advanced Features & Alarm System Review

Date: Weeks 9–12  
Attendees: Project Manager, Product Manager, Flutter Developers, Tester

### Discussion

Developers presented the second build incorporating the alarm system and all
advanced features. This was the most technically complex phase of the project.

Alarm System — Completed:
- Background alarm scheduling using android_alarm_manager_plus with exact
  wakeup and rescheduleOnReboot: true so alarms survive phone restarts
- alarmCallback() top-level function fires even when the app is fully closed,
  writes a flag to SharedPreferences, and shows a heads-up notification
- _MyAppState checks for the alarm flag every 2 seconds and on app resume,
  then opens the full-screen AlarmRingScreen automatically
- AlarmRingScreen — pulsing animated medicine icon, medicine name, dose,
  scheduled time, three actions: I Took It, Snooze 10 min, Send SMS
- Snooze reschedules the alarm 10 minutes from the current time
- Stop marks the medicine as Taken and cancels the notification
- Send SMS opens the SMS app pre-filled with all emergency contact numbers
  and the medicine name and dose in the message body
- 3 bundled alarm sounds: Gentle Bell, Soft Chime, Urgent Beep
- User selects sound per medicine when adding; global default in Settings

Advanced Features — Completed:
- Edit Medicine — dialog with time picker, frequency dropdown, date fields;
  cancels old alarm and reschedules with new time on save
- Delete Medicine — cancels alarm before removing from Hive
- Multiple alarm times enforced by frequency (Twice Daily requires exactly 2 times;
  Three Times Daily requires exactly 3; counter shown during input)
- Dark Mode — persisted via Hive; ThemeHelper utility applied to all screens
- Health screen — BMI Calculator and Blood Pressure Calculator with
  5-stage color-coded classification
- Symptom Checker — 8 common conditions with guidance and medical disclaimer
- Pharmacy Finder — search, call, and Google Maps directions
- Emergency module — add/remove contacts, one-tap SMS alert, quick-dial buttons
- History screen — search, filter by status, bar chart from real Hive data
- Medicines screen — full list with status badges, Taken, Skip, Edit, Delete actions
- Settings screen — profile edit, alarm sound picker, vibration toggle,
  reminder lead time, dark mode toggle

Issues Identified During Review:

 Issue | Resolution |

| flutter_local_notifications API mismatch (v17 vs v21) | Locked versions in pubspec.yaml |
| Alarm only firing when app open | Rewrote callback to show notification directly; added SharedPreferences flag polling |
| Dark mode not applying to all screens | Introduced TH ThemeHelper class; all screens updated |
| Medicine adapter writeByte count wrong (8 instead of 10) | Fixed medicine.g.dart |
| alarm package incompatible | Replaced with android_alarm_manager_plus + audioplayers |

### Decisions Made

- Alarm system architecture confirmed as stable and ready for QA testing.
- App icon and name configuration (Medicare) to be handled in Phase 7.
- README to be updated with full documentation before final submission.

### Next Steps

- Tester — Begin comprehensive functional and unit testing across all screens.
- Developers — Support bug fixes as test results come in.
- Project Manager — Schedule Meeting 6 for testing results review.

------------------------------------------------------------------------------------------

## Meeting 6 – Testing Results & Bug Fix Review

Date: Weeks 13–15  
Attendees: Project Manager, Product Manager, Flutter Developers, Tester

### Discussion

The Tester presented the full test results. A comprehensive unit test suite
was written and executed covering all layers of the application.

Test Coverage Completed:
| Area | Tests Written |
|---|---|
| Models | Field defaults, Hive serialization, factory constructors |
| Providers | Medicine CRUD, status updates, Hive persistence, emergency contacts |
| Theme Provider | Dark/light toggle, persistence across restarts |
| Settings Provider | Sound, vibration, lead time persistence |
| Alarm Service | Sound list contents, scheduling, cancellation |
| Screens | All screen UI elements, navigation, form interactions |
| Add Medicine Sheet | Validation, frequency-time enforcement, date/time pickers, save flow |
| Symptom Screen | Quick symptoms, result display, warning disclaimer |
| Health Screen | BMI calculation accuracy, blood pressure classification |
| History Screen | Search, filter chips, chart data binding |

Bugs Found and Fixed During This Phase:

| Bug | Fix Applied |
|---|---|
| Test viewport too small — buttons off-screen | Set tester.view.physicalSize to 1080×2400 in all widget tests |
| ensureVisible missing before tapping off-screen widgets | Added await tester.ensureVisible(finder) before all scroll-dependent taps |
| DropdownButton test finding wrong instance | Used .at(index) to target specific dropdowns |
| Time chip delete test failing | Used find.descendant to scope the close icon to the Chip widget |
| Alarm not firing when phone screen off | Added wakeup: true and USE_EXACT_ALARM permission to AndroidManifest |
| Alarm not surviving phone restart | Added rescheduleOnReboot: true and BOOT_COMPLETED receiver |

QA Sign-off: All critical and high-priority issues resolved. App approved
to proceed to final review.

### Decisions Made

- All test cases pass. No blocking issues remain.
- Final build to be prepared for demo and submission.

### Next Steps

- Developers — Configure app icon, finalize app name in AndroidManifest,
  update README, and build release APK.
- Project Manager — Prepare final project documentation and presentation.
- All Members — Review final build on physical devices before submission.

---------------------------------------------------------------------------------------------

## Meeting 7 – Final Review & Submission Preparation

Date: Week 16  
Attendees: All Team Members

### Discussion

The team conducted the final review meeting. The complete application was
demonstrated on a physical Android device.

Final Build Verified On-Device:
- Splash screen displays logo and app name correctly
- Onboarding shows on first install; skipped on subsequent launches
- All 9 screens accessible and functioning correctly in both light and dark mode
- Add Medicine correctly enforces time count per frequency selection
- Alarm fires on the physical device at the scheduled time, even with the app closed
- Full-screen AlarmRingScreen appears with pulsing animation, medicine name and dose
- I Took It, Snooze 10 min, and Send SMS all function correctly
- Send SMS opens the SMS app pre-filled with emergency contact numbers
- Emergency alert sends a formatted SMS to all saved contacts
- BMI and Blood Pressure calculators return accurate results
- History chart reflects real data from Hive
- Dark mode applied consistently across all screens
- App name shows as Medicare on the device home screen

App Icon: Configured via flutter_launcher_icons using the project logo
with teal adaptive background (#2EC4B6).

Documentation Completed:
- README.md — full feature list, tech stack, setup instructions, team details,
  project structure, test instructions, and roadmap
- management/meeting-notes.md — all 7 meeting records documented
- management/project-timeline.md — full 16-week phase plan with status updates

Project Manager Closing Note:  
The team delivered a fully functional, well-tested Flutter application that
meets and exceeds the original requirements. Despite scheduling delays in
Phases 3 and 4, the team successfully consolidated work and delivered all
planned features. The codebase is clean, documented, and ready for future
extension.

### Final Deliverables Submitted