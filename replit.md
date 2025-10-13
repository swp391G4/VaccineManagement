# Child Vaccination Management System

## Project Overview
A comprehensive child vaccination management and scheduling system built with Java Web (JSP/Servlet), OOP principles, and MSSQL database.

## Technology Stack
- **Backend**: Java 17 (configured in pom.xml), Jakarta Servlet API 6.0, JSP 3.1
- **Web Server**: Apache Tomcat 10 (via Cargo Maven plugin)
- **Database**: MSSQL Server
  - Username: dodt
  - Password: 123456789
- **Build Tool**: Maven 3.8.6
- **Frontend**: Bootstrap 5, JSP, JSTL
- **Security**: Plain text passwords (no hashing per user request)

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

## Database Setup
1. Open SQL Server Management Studio or Azure Data Studio
2. Run the single file: `database/schema.sql`
3. This will automatically drop old database and create new one with all tables and sample data

## Running the Application
1. Start the server: `mvn cargo:run`
2. Access the application: `http://localhost:5000`

## NetBeans Integration
This project follows the standard Maven structure and can be opened directly in NetBeans IDE:
1. File → Open Project
2. Navigate to the project root directory (where pom.xml is located)
3. NetBeans will automatically recognize it as a Maven project

## Default Admin Credentials
- Email: admin@vaccination.com
- Password: Admin@123 (plain text, no hashing)

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
- None at the moment

## Development Notes
- **Password Storage**: Plain text (no hashing per user request - for educational purposes only)
- Session-based authentication
- Role-based access control implemented via servlets
- Bootstrap 5 for responsive UI
- All workflows are managed by Cargo Maven plugin with Tomcat 10
- Project structure reorganized for NetBeans IDE compatibility

## Security Warning
⚠️ **This project uses plain text passwords for educational purposes only.**
- Passwords are stored in database without encryption
- Not recommended for production use
- Always use password hashing (bcrypt, Argon2, etc.) in real applications

Last Updated: 2025-10-13
