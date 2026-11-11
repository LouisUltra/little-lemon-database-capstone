# Little Lemon Database — Database Engineer Capstone

Data model for the Little Lemon restaurant, deployed in MySQL, together with the five
stored procedures required by the brief.

Author: Xingyu Lin · 11 November 2026

## Contents

| Path | What it is |
| --- | --- |
| `screenshots/little_lemon_erd.png` | ER diagram — the five tables and the connections between them |
| `screenshots/little_lemon_erd.svg` | Same diagram, vector version |
| `LittleLemonDB.sql` | Full schema: database, tables, seed data and all five stored procedures |
| `stored_procedures.sql` | The five procedures on their own, for review |
| `verification.txt` | Output of an actual run, showing every procedure working |

## Database schema

Five tables, normalised to third normal form:

* **Customers** — `CustomerID` (PK), `FullName`, `ContactNumber`, `Email`
* **Bookings** — `BookingID` (PK), `BookingDate`, `TableNo`, `CustomerID` (FK → Customers)
* **Orders** — `OrderID` (PK), `OrderDate`, `Quantity`, `TotalCost`, `CustomerID` (FK → Customers), `MenuID` (FK → Menu)
* **Menu** — `MenuID` (PK), `MenuItems`, `Cuisine`
* **MenuItems** — `MenuItemID` (PK), `CourseName`, `ItemName`, `ItemPrice`

Relationships: `Customers 1:N Bookings`, `Customers 1:N Orders`, `Menu 1:N Orders`.

## Stored procedures

| Procedure | Purpose |
| --- | --- |
| `GetMaxQuantity()` | Returns the largest quantity in any single order |
| `ManageBooking(booking_id)` | Looks up one booking together with its customer |
| `UpdateBooking(booking_id, date)` | Moves an existing booking to a new date |
| `AddBooking(booking_id, customer_id, table_no, date)` | Creates a booking and returns a confirmation |
| `CancelBooking(booking_id)` | Removes a booking and returns a confirmation |

## How to rebuild

```bash
mysql -u root -p < LittleLemonDB.sql
```

Or, against an existing `little_lemon_db`:

```bash
mysql -u root -p little_lemon_db < stored_procedures.sql
```

## Verified results

See `verification.txt`. In short, against the seeded data:

```
GetMaxQuantity()   -> 4
ManageBooking(1)   -> Booking 1 · 2026-11-20 · table 12 · Anna Iversen
AddBooking(6,3,7,'2026-11-25')   -> new booking confirmed, Bookings 5 -> 6 rows
UpdateBooking(6,'2026-11-26')    -> date changed to 2026-11-26
CancelBooking(6)                 -> booking removed, Bookings 6 -> 5 rows
```

## Notes on tooling

The schema was deployed to a live MySQL 8.0 server and the ER diagram was generated
programmatically from that model, rather than drawn by hand inside the MySQL Workbench
canvas — the resulting model and DDL are the same. No Tableau workbook is included
because Tableau Desktop is not installed in this environment.
