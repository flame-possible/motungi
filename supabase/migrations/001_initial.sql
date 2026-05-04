CREATE TABLE users (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kakao_id     text UNIQUE,
  nickname     text,
  avatar_url   text,
  created_at   timestamptz DEFAULT now()
);

CREATE TABLE quests (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title        text NOT NULL,
  category     text CHECK (category IN ('관찰','감각','경로','사진','발견')),
  difficulty   text CHECK (difficulty IN ('easy','normal')),
  tags         text[]
);

CREATE TABLE walks (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid REFERENCES auth.users(id),
  duration       int NOT NULL,
  mood           text,
  purpose        text,
  route_geojson  jsonb,
  distance_m     int,
  started_at     timestamptz,
  completed_at   timestamptz
);

CREATE TABLE walk_quests (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  walk_id       uuid REFERENCES walks(id),
  quest_id      uuid REFERENCES quests(id),
  photo_url     text,
  memo          text,
  completed_at  timestamptz
);
