# Football Ticket Booking System — Database Design & SQL

A simplified relational database for a football ticket booking platform. The system manages football fans, upcoming tournament matches, and the individual ticket booking receipts that connect them. This repository contains the database schema, sample data, SQL queries, and an Entity Relationship Diagram (ERD).

## Table of Contents

- [Overview](#overview)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Database Schema](#database-schema)
- [Relationships](#relationships)
- [SQL Queries](#sql-queries)
- [How to Run](#how-to-run)
- [Theory Notes](#theory-notes)

## Overview

The database is built around three tables:

- **Users** — administrative staff and customers who use the platform.
- **Matches** — the catalog of tournament events, including stadium pricing and ticket availability.
- **Bookings** — a transactional table that records each individual ticket purchase by linking a user to a match.

## Entity Relationship Diagram

The full ERD (with primary keys, foreign keys, crow's foot cardinality, and status fields) is available here:

**ERD link:** https://drawsql.app/teams/md-shanto/diagrams/football-ticket-booking-system

## Database Schema

### Users

| Column | Type | Notes |
| --- | --- | --- |
| `user_id` | SERIAL | Primary key |
| `full_name` | VARCHAR | Not null |
| `email` | VARCHAR | Not null, unique (login) |
| `role` | VARCHAR | `Ticket Manager` or `Football Fan` |
| `phone_number` | VARCHAR | Nullable contact number |

### Matches

| Column | Type | Notes |
| --- | --- | --- |
| `match_id` | SERIAL | Primary key |
| `fixture` | VARCHAR | The two competing teams |
| `tournament_category` | VARCHAR | League or cup title |
| `base_ticket_price` | DECIMAL | Non-negative (check constraint) |
| `match_status` | VARCHAR | `Available`, `Selling Fast`, `Sold Out`, `Postponed` |

### Bookings

| Column | Type | Notes |
| --- | --- | --- |
| `booking_id` | SERIAL | Primary key |
| `user_id` | INT | Foreign key → `Users(user_id)` |
| `match_id` | INT | Foreign key → `Matches(match_id)` |
| `seat_number` | VARCHAR | Nullable seat identifier |
| `payment_status` | VARCHAR | `Pending`, `Confirmed`, `Cancelled`, `Refunded` |
| `total_cost` | DECIMAL | Non-negative (check constraint) |

## Relationships

- **One User → Many Bookings** — a single fan can buy tickets for multiple matches across the season.
- **Many Bookings → One Match** — a popular match can be tied to many individual booking records.
- **One-to-One (logical)** — each individual row in the Bookings table maps exactly one user to one match for one reserved seat. This is a property of how a single booking row behaves (it holds exactly one `user_id` and one `match_id`), not a separate physical relationship, so it is represented through the two foreign keys rather than an extra connector.

## SQL Queries

All queries live in [`QUERY.sql`](./QUERY.sql). They demonstrate:

| # | Query | Concepts |
| --- | --- | --- |
| 1 | Champions League matches that are Available | `WHERE`, multiple conditions |
| 2 | Users whose names start with "Tanvir" or contain "Haque" | `ILIKE`, pattern matching |
| 3 | Bookings with missing payment status flagged as "Action Required" | `IS NULL`, `COALESCE` |
| 4 | Booking details with user names and match fixtures | `INNER JOIN` |
| 5 | All users and their booking IDs, including fans with no bookings | `LEFT JOIN` |
| 6 | Bookings costing more than the average booking | Subquery, `AVG` |
| 7 | Top 2 most expensive matches, skipping the highest | `ORDER BY`, `LIMIT`, `OFFSET` |

## How to Run

This project targets PostgreSQL.

1. Create or select a database.
2. Run the schema and seed data, then the queries:

   ```bash
   psql -U your_username -d your_database -f QUERY.sql
   ```

   The script drops existing tables, recreates them with all constraints, inserts the sample data, and runs the seven queries in order.

3. Alternatively, paste the contents of `QUERY.sql` into a SQL client (pgAdmin, DBeaver, or an online PostgreSQL playground) and run it.

## Theory Notes

Short answers to the viva-practice questions are included for reference.

**Foreign keys in the Bookings table.** The `user_id` and `match_id` columns are foreign keys referencing `Users` and `Matches`. They enforce referential integrity — the database rejects any booking whose `match_id` does not correspond to an existing match, so a ticket can never be sold for a match that does not exist.

**`HAVING` vs `WHERE`.** `WHERE` filters individual rows before grouping, so it runs before aggregate functions are calculated and cannot reference something like `COUNT(booking_id)`. `HAVING` filters after grouping and aggregation, which is why aggregate conditions belong there.

**Why a primary key cannot be `NULL`.** A primary key uniquely identifies each row. `NULL` represents an unknown or absent value and cannot be reliably compared, so allowing it would break the guarantee that every row is uniquely identifiable.

---

*Built as a database design and SQL assignment. All work is original.*