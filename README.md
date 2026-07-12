# ALU LaunchPad

A mobile app that connects ALU students with student-led startups on campus.

Startups get help with development, design, marketing, and more. Students get real internship-style experience without having to compete for spots at big companies. Everyone wins.

## What it does

- Sign up as a student or a startup (ALU emails only)
- Startups post opportunities, students browse and apply
- Everything updates live — no refreshing needed
- Startups can shortlist, accept, or reject applicants
- Students track their application status in real time

## Built with

- Flutter
- Firebase (Auth + Firestore)
- Provider for state management

## Getting started

```
flutter pub get
flutterfire configure
flutter run
```

You'll need your own Firebase project connected via `flutterfire configure` for this to work.

## Why it's built this way

Screens never talk to Firebase directly — everything goes through a provider, which goes through a service. Keeps things easy to change later without breaking the UI.

More detail on the architecture, schema, and design decisions is in the technical report.
