# Child Vaccination Management System

## Project Overview
A comprehensive child vaccination management and scheduling system built with Java Web (JSP/Servlet), OOP principles, and MSSQL database.

## Technology Stack
- **Backend**: Java 19, Jakarta Servlet API 6.0, JSP 3.1
- **Web Server**: Apache Tomcat 7 (via Maven plugin)
- **Database**: MSSQL Server (configured but not connected yet)
- **Build Tool**: Maven 3.8.6
- **Frontend**: Bootstrap 5, JSP, JSTL

## Architecture & Design Patterns
- **MVC Pattern**: Model-View-Controller architecture
- **DAO Pattern**: Data Access Objects for database operations
- **Singleton Pattern**: DatabaseConnection utility
- **Factory Pattern**: For object creation
- **Service Layer Pattern**: Business logic separation (to be implemented)

## Project Structure
```
/
├── src/main/
│   ├── java/com/vaccination/
│   │   ├── model/           # Entity classes (User, Child, Vaccine, etc.)
│   │   ├── dao/             # Data Access Objects
│   │   ├── service/         # Business logic layer (to be implemented)
│   │   ├── controller/      # Servlets
│   │   │   ├── parent/      # Parent role controllers
│   │   │   └── ...          # Other role controllers
│   │   └── util/            # Utilities (DatabaseConnection, PasswordUtil)
│   ├── resources/           # Configuration files
│   └── webapp/
│       ├── WEB-INF/         # Web configuration
│       └── views/           # JSP pages
│           ├── guest/       # Public pages
│           ├── parent/      # Parent role pages
│           ├── reception/   # Reception staff pages
│           ├── medical/     # Medical staff pages
│           └── admin/       # Admin pages
├── database/                # SQL scripts
└── pom.xml                  # Maven configuration
```

## User Roles
1. **Guest**: View vaccine information, centers, schedules (public access)
2. **Parent**: Manage children, book appointments, view vaccination records
3. **Reception Staff**: Manage appointments, confirm/reject bookings, update payment status
4. **Medical Staff**: Perform vaccinations, record health checks, manage vaccine inventory
5. **Admin**: Manage centers, vaccines, staff accounts, generate reports

## Database Schema
### Main Tables
- `Users`: User accounts with role-based access
- `Children`: Child profiles linked to parent users
- `Vaccines`: Vaccine catalog
- `Centers`: Vaccination centers
- `VaccineStock`: Inventory management per center
- `Appointments`: Vaccination appointments
- `VaccinationRecords`: Vaccination history
- `Notifications`: System notifications
- `WorkingSchedule`: Center operating hours
- `StaffAssignments`: Staff-center assignments

## Current Development Status
- ✅ Project structure setup
- ✅ Database schema created
- ✅ Model classes implemented (OOP)
- ✅ DAO layer implemented
- ✅ Basic authentication (login/register/logout)
- ✅ Guest pages (home, login, register)
- ✅ Parent dashboard and child management
- ⏳ Appointment booking system (in progress)
- ⏳ Reception staff features
- ⏳ Medical staff features
- ⏳ Admin features
- ⏳ Reporting and analytics

## Running the Application
1. Start the server: `mvn tomcat7:run -Dmaven.tomcat.port=5000`
2. Access the application: `http://localhost:5000`

## Default Admin Credentials
- Email: admin@vaccination.com
- Password: Admin@123 (SHA-256 hash in database)

## Next Steps
1. Complete appointment booking functionality
2. Implement reception staff appointment management
3. Implement medical staff vaccination recording
4. Implement admin dashboard and management features
5. Add email notification system
6. Implement reporting and analytics
7. Add payment integration (optional)
8. Generate digital vaccination certificates (PDF/QR)

## Known Issues
- Tomcat 7 shows warnings about module-info.class compatibility with Jakarta/Java 19 (non-fatal)
- MSSQL database connection not configured (using default properties)

## Development Notes
- Uses SHA-256 for password hashing
- Session-based authentication
- Role-based access control implemented via servlets
- Bootstrap 5 for responsive UI
- All workflows are managed by Tomcat Maven plugin

Last Updated: 2025-10-12
