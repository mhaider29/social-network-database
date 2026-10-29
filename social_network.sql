-- PART 0: Creating Database
drop database if exists social_network;
create database social_network;
use social_network;

-- PART 1: Creating Tables

-- 1. User Table
-- Users have a full name “John Doe” or “Northeastern University”, a twitter handle (@JohnDoe) an email address, password, and an optional
-- short profile (255 characters max). The databased also tracks the DATETIME when the user’s account was registered. 
create table users (
	user_id int primary key auto_increment,
	full_name varchar(100) not null,
    handle varchar (100) not null unique,
    email varchar(100) not null unique,
    password varchar(255),
    profile varchar (255),
    registered_at datetime not null
);

-- 2. Tweets Table
-- Twitter/X is a social network where users post tweets. A tweet is a string of text at most 160 characters
-- long. Each tweet has a timestamp and is created by one and only one unique user.
create table tweets (
	tweet_id int primary key auto_increment,
    user_id int not null,
	tweet_text varchar (160) not null,
    created_at datetime not null,
    constraint fk_tweets_user foreign key(user_id) references users(user_id)
);

-- 3. Follows Table 
--  Users follow other users (unary relationship)
create table follows (
	follower_id int,
    followee_id int,
    primary key (follower_id, followee_id),
    constraint fk_follows_follower foreign key (follower_id) references users(user_id),
    constraint fk_follows_followee foreign key (followee_id) references users(user_id)
);


-- 4. Hashtags Table
-- Tweets may contain hashtags (words proceeded by a ‘#’ symbol) and users need to be able to
-- efficiently search for tweets that contain specific hashtags. (Hint: have a hashtag table!)
create table hashtags (
	hashtag_id int primary key auto_increment,
    tag_name varchar(255) not null unique
);

-- 5. Tweet-Hashtags Table
create table tweet_hashtags (
	tweet_id int,
    hashtag_id int,
    primary key (tweet_id, hashtag_id),
	constraint fk_th_tweet foreign key (tweet_id) references tweets(tweet_id),
    constraint fk_th_hashtag foreign key (hashtag_id) references hashtags(hashtag_id)
);

-- 6. Likes Table
-- Users can indicate that they “like” a particular tweet they find, even if the tweet isn’t by one of the users that they normally follow. 
create table likes (
	user_id int,
    tweet_id int,
    primary key (user_id, tweet_id),
    constraint fk_likes_user foreign key (user_id) references users(user_id),
    constraint fk_likes_tweet foreign key (tweet_id) references tweets(tweet_id)
);


-- PART 2: Populate Datatables

-- Insert the three users (@jsmith, @khoury, @mlee) with their attributes
insert into users (handle, full_name, email, password, profile, registered_at) values
('@jsmith', 'John Smith', 'john.smith@example.com', 'pass1', 'A student at Northeastern', '2026-08-01 09:00:00'),
('@khoury', 'Khoury College', 'khoury@example.com', 'pass2', 'The Khoury College of Computer Sciences', '2026-08-01 09:00:00'),
('@mlee', 'Maya Lee', 'maya.lee@example.com', 'pass3', 'A professor in the Khoury College of Computer Sciences', '2026-08-01 09:00:00');

-- Follower relationships: @jsmith follows @mlee and @khoury; @mlee follows @khoury and @jsmith
insert into follows (follower_id, followee_id) values
(1, 3), -- @jsmith -> @mlee
(1, 2), -- @jsmith -> @khoury
(3, 2), -- @mlee -> @khoury
(3, 1); -- @mlee -> @jsmith

-- Insert hashtags found in the tweets (#studentlife, #neu, #databases)
insert into hashtags (tag_name) values
('#studentlife'),
('#neu'),
('#databases');

-- Insert tweets with specific texts and timestamps
insert into tweets (user_id, tweet_text, created_at) values
(3, 'Welcome Freshman to Khoury College! #studentlife', '2026-09-01 08:00:00'),
(1, 'I sure do love Northeastern! #neu #studentlife', '2026-10-18 10:00:00'),
(1, 'My CS3200 homework is due in an hour! #databases #neu', '2026-10-20 22:59:00'),
(2, 'All is quiet in West Village H. Students studying hard!! #studentlife', '2026-10-20 23:54:00');

-- Linking each tweet to its respective hashtags in tweet_hashtags
insert into tweet_hashtags (tweet_id, hashtag_id) values
(1, 1), -- Tweet 1: #studentlife
(2, 1), (2, 2), -- Tweet 2: #neu, #studentlife
(3, 2), (3, 3), -- Tweet 3: #databases, #neu
(4, 1); -- Tweet 4: #studentlife

-- "Both @khoury and @mlee liked @jsmith's tweet above loving Northeastern" (tweet_id = 2)
insert into likes (user_id, tweet_id) values
(2, 2), -- @khoury liked tweet 2
(3, 2); -- @mlee liked tweet 2


-- PART 3: select queries (using subqueries)

-- 1. How many tweets did @jsmith post?
select count(*) as jsmith_tweet_count
from tweets
where user_id = (select user_id from users where handle = '@jsmith');

-- 2. Generate the home timeline for @mlee (use subquery)
select tweet_text, created_at
from tweets
where user_id in (
    select followee_id 
    from follows 
    where follower_id = (select user_id from users where handle = '@mlee')
)
order by created_at desc;

-- 3. Find all tweets that contain the hashtag #studentlife
select tweet_text, created_at
from tweets
where tweet_id in (
    select tweet_id 
    from tweet_hashtags
    where hashtag_id = (select hashtag_id from hashtags where tag_name = '#studentlife')
);



