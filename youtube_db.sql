CREATE TABLE IF NOT EXISTS user_profile(
    id BIGSERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    gender TEXT NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS youtube_account (
    id BIGINT PRIMARY KEY REFERENCES user_profile(id),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS youtube_channel (
    id BIGSERIAL PRIMARY KEY,
    youtube_account_id BIGINT NOT NULL REFERENCES youtube_account(id),
    channel_name TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS channel_subscriber ( 
    youtube_account_id BIGINT REFERENCES youtube_account(id),
    youtube_channel_id BIGINT REFERENCES youtube_channel(id),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY(youtube_account_id, youtube_channel_id)
);

CREATE TABLE IF NOT EXISTS video (
    id BIGSERIAL PRIMARY KEY,
    youtube_channel_id BIGINT NOT NULL REFERENCES youtube_channel(id),
    title TEXT NOT NULL,
    url TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS video_view (
    id BIGSERIAL PRIMARY KEY,
    youtube_account_id BIGINT REFERENCES youtube_account(id),
    video_id BIGINT NOT NULL REFERENCES video(id),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS video_like (
    youtube_account_id BIGINT NOT NULL REFERENCES youtube_account(id),
    video_id BIGINT NOT NULL REFERENCES video(id),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY (youtube_account_id, video_id)
);

CREATE TABLE IF NOT EXISTS video_comment (
    id BIGSERIAL PRIMARY KEY,
    youtube_account_id BIGINT NOT NULL REFERENCES youtube_account(id),
    video_id BIGINT NOT NULL REFERENCES video(id),
    comment TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS video_comment_like (
   youtube_account_id BIGINT NOT NULL REFERENCES youtube_account(id),
   video_comment_id BIGINT NOT NULL REFERENCES video_comment(id),
   created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
   PRIMARY KEY (youtube_account_id, video_comment_id)
);

-- users

INSERT INTO public.user_profile (id, first_name, last_name, email, gender, created_at)
VALUES (1, 'Mariam', 'Ali', 'm.ali@gmail.com', 'FEMALE', '2024-11-24 23:42:47');

INSERT INTO public.user_profile (id, first_name, last_name, email, gender, created_at)
VALUES (2, 'Joe', 'James', 'j.joe@gmail.com', 'MALE', '2024-11-24 23:42:47');

INSERT INTO public.user_profile (id, first_name, last_name, email, gender, created_at)
VALUES (3, 'Jamila', 'Ahamed', 'ah.jamila@gmail.com', 'MALE', '2024-11-24 23:42:47');

INSERT INTO public.user_profile (id, first_name, last_name, email, gender, created_at)
VALUES (4, 'Alex', 'Smith', 'smith.alex@gmail.com', 'FEMALE', '2024-11-24 23:42:47');

-- accounts

INSERT INTO public.youtube_account (id, created_at)
VALUES (1, '2024-11-24 20:44:36');

INSERT INTO public.youtube_account (id, created_at)
VALUES (2, '2024-11-24 20:00:36');

INSERT INTO public.youtube_account (id, created_at)
VALUES (4, '2024-11-24 20:44:36');

-- channels

INSERT INTO public.youtube_channel (youtube_account_id, channel_name, created_at)
VALUES (1, 'MariamBeauty', '2024-11-24 23:47:05');

INSERT INTO public.youtube_channel (youtube_account_id, channel_name, created_at)
VALUES (2, 'JoeTech', '2024-11-24 23:47:50');

INSERT INTO public.youtube_channel (youtube_account_id, channel_name, created_at)
VALUES (4, 'AlexTutorials', '2024-11-24 23:47:50');

INSERT INTO public.youtube_channel (youtube_account_id, channel_name, created_at)
VALUES (1, 'AlexTutorialsSpringBoot', '2024-11-24 23:49:50');


-- subscribers

INSERT INTO public.channel_subscriber (youtube_account_id, youtube_channel_id, created_at)
VALUES (1, 2, '2024-11-25 22:19:41');

INSERT INTO public.channel_subscriber (youtube_account_id, youtube_channel_id, created_at)
VALUES (1, 3, '2024-11-25 22:19:58');

INSERT INTO public.channel_subscriber (youtube_account_id, youtube_channel_id, created_at)
VALUES (4, 1, '2024-11-25 22:19:58');

INSERT INTO public.channel_subscriber (youtube_account_id, youtube_channel_id, created_at)
VALUES (2, 1, '2024-11-25 22:19:58');

-- Joins

SELECT * FROM user_profile
JOIN youtube_account ya ON user_profile.id = ya.id
JOIN channel_subscriber ON ya.id = channel_subscriber.youtube_account_id
JOIN youtube_channel yc ON channel_subscriber.youtube_channel_id = yc.id;

-- Left Join

SELECT * FROM user_profile
LEFT JOIN youtube_account ya ON user_profile.id = ya.id
LEFT JOIN channel_subscriber ON ya.id = channel_subscriber.youtube_account_id
LEFT JOIN youtube_channel yc ON channel_subscriber.youtube_channel_id = yc.id;

-- video
INSERT INTO public.video (id, youtube_channel_id, title, url, description, category, created_at) VALUES (1, 1, 'How to take care of your skin', 'https://youtube.com/9328982', 'You will learn the best way to take care of your skin', 'People & Vlogs', '2020-05-02 22:30:28.000000');
INSERT INTO public.video (id, youtube_channel_id, title, url, description, category, created_at) VALUES (2, 6, 'Database Design', 'https://youtube.com/932898233', 'Master db design', 'Education', '2020-12-02 22:41:08.000000');
INSERT INTO public.video (id, youtube_channel_id, title, url, description, category, created_at) VALUES (3, 6, 'Advanced Database', 'https://youtube.com/423432', 'Advanced DB Course', 'Education', '2020-12-02 22:41:10.000000');
INSERT INTO public.video (id, youtube_channel_id, title, url, description, category, created_at) VALUES (4, 2, 'Macbook Air M1 Unboxing', 'https://youtube.com/432423k', 'Unboxing', 'Tech', '2020-12-02 22:41:10.000000');

-- comments
INSERT INTO public.video_comment (id, youtube_account_id, video_id, comment, created_at) VALUES (1, 4, 1, 'Nice video', '2020-12-02 22:35:08.000000');
INSERT INTO public.video_comment (id, youtube_account_id, video_id, comment, created_at) VALUES (2, 4, 2, 'I loved it.', '2020-12-02 22:35:08.000000');
INSERT INTO public.video_comment (id, youtube_account_id, video_id, comment, created_at) VALUES (3, 4, 3, 'Keep Going', '2020-12-02 22:35:08.000000');
INSERT INTO public.video_comment (id, youtube_account_id, video_id, comment, created_at) VALUES (4, 1, 1, 'Best course', '2020-12-02 22:35:08.000000');
INSERT INTO public.video_comment (id, youtube_account_id, video_id, comment, created_at) VALUES (5, 1, 1, 'Had to comment again. Best course', '2020-12-02 22:35:08.000000');
INSERT INTO public.video_comment (id, youtube_account_id, video_id, comment, created_at) VALUES (6, 2, 1, 'Good stuff', '2020-12-02 22:35:08.000000');
INSERT INTO public.video_comment (id, youtube_account_id, video_id, comment, created_at) VALUES (7, 2, 3, 'I have a question about joins', '2020-12-02 22:35:08.000000');

-- likes to comments
INSERT INTO public.video_comment_like (youtube_account_id, video_comment_id, created_at) VALUES (4, 4, '2020-12-02 22:51:00.000000');
INSERT INTO public.video_comment_like (youtube_account_id, video_comment_id, created_at) VALUES (1, 4, '2020-12-02 22:51:00.000000');
INSERT INTO public.video_comment_like (youtube_account_id, video_comment_id, created_at) VALUES (2, 3, '2020-12-02 22:51:00.000000');
INSERT INTO public.video_comment_like (youtube_account_id, video_comment_id, created_at) VALUES (1, 1, '2020-12-02 22:51:00.000000');
INSERT INTO public.video_comment_like (youtube_account_id, video_comment_id, created_at) VALUES (1, 2, '2020-12-02 22:51:00.000000');

-- likes to videos
INSERT INTO public.video_like (youtube_account_id, video_id, created_at) VALUES (4, 1, '2020-12-02 22:35:38.000000');
INSERT INTO public.video_like (youtube_account_id, video_id, created_at) VALUES (1, 2, '2020-12-02 22:35:38.000000');
INSERT INTO public.video_like (youtube_account_id, video_id, created_at) VALUES (4, 2, '2020-12-02 22:35:38.000000');
INSERT INTO public.video_like (youtube_account_id, video_id, created_at) VALUES (2, 2, '2020-12-02 22:35:38.000000');
INSERT INTO public.video_like (youtube_account_id, video_id, created_at) VALUES (2, 3, '2020-12-02 22:35:38.000000');

-- views
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (1, 4, 1, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (2, 4, 3, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (3, 4, 2, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (4, 4, 1, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (5, 4, 1, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (6, 4, 3, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (7, null, 1, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (8, null, 1, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (9, null, 1, '2020-12-02 22:36:07.000000');
INSERT INTO public.video_view (id, youtube_account_id, video_id, created_at) VALUES (10, null, 1, '2020-12-02 22:36:07.000000');