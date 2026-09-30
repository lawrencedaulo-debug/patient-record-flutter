# Patient Record Flutter

A complete Flutter patient record management app with:

- Admin login and user registration
- Multi-tenant isolation per clinic
- Dashboard summary cards
- Full CRUD for patient records
- Search, sort, filter, and delete confirmation
- Mobile-friendly modern UI

## Features

- Default admin account:
  - Email: admin@clinic.com
  - Password: admin123
- User registration with clinic/tenant name
- Users only see patient records for their tenant
- Patient list with name or ID search
- Patient create/edit/view/delete flows
- Soft delete and permanent delete
- Dashboard for total patients, monthly adds, active users, recent records

## Run the app

1. Install Flutter SDK
2. Run:

```bash
flutter pub get
flutter run
```

## Notes

This version stores data locally in SharedPreferences for a working demo that is easy to run and test without a backend.
