# Social Network Database (SQL)

A relational database design for a Twitter-style social network, built in MySQL. It models users, tweets, followers, hashtags, and likes, and includes sample data and queries such as generating a user's home timeline.

**Solo project** for CS3200 (Database Design), Northeastern University, Fall 2026.

## Database design

Six tables, connected with primary and foreign keys:

| Table | What it stores | Key design choice |
|---|---|---|
| `users` | Name, unique handle, unique email, password, profile, sign-up time | `handle` and `email` are `UNIQUE` |
| `tweets` | Tweet text (max 160 characters) and timestamp | Each tweet belongs to exactly one user |
| `follows` | Who follows whom | A table that links `users` to itself, with a composite primary key |
| `hashtags` | Each distinct hashtag | Stored once, so tweets can be searched by hashtag quickly |
| `tweet_hashtags` | Which hashtags appear in which tweets | Resolves the many-to-many relationship between tweets and hashtags |
| `likes` | Which users liked which tweets | Composite primary key, so a user can't like the same tweet twice |

## Queries

Using subqueries, [`social_network.sql`](social_network.sql) finds:

1. How many tweets a given user posted
2. A user's **home timeline**: tweets from everyone they follow, newest first
3. All tweets containing a given hashtag

## How to run

Open `social_network.sql` in MySQL Workbench (or any MySQL client) and run the whole script. It creates the `social_network` database, builds the tables, inserts the sample data, and runs the queries.

> ⚠️ The script starts with `DROP DATABASE IF EXISTS social_network`, so it will replace any existing database with that name.

The sample users and emails are made up for demonstration.
