-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-04-21 09:29:37.616

-- tables
-- Table: c_concept
CREATE TABLE c_concept (
    c_id integer  NOT NULL,
    c_title varchar2(128)  NOT NULL,
    c_description varchar2(2048)  NOT NULL,
    CONSTRAINT c_concept_pk PRIMARY KEY (c_id)
) ;

-- Table: d_difficulty
CREATE TABLE d_difficulty (
    d_id integer  NOT NULL,
    d_name varchar2(128)  NOT NULL,
    CONSTRAINT d_difficulty_pk PRIMARY KEY (d_id)
) ;

-- Table: e_exercise
CREATE TABLE e_exercise (
    e_id integer  NOT NULL,
    e_name varchar2(256)  NOT NULL,
    e_description varchar2(2048)  NOT NULL,
    e_track integer  NOT NULL,
    e_difficulty integer  NOT NULL,
    CONSTRAINT e_exercise_pk PRIMARY KEY (e_id)
) ;

-- Table: req_required_exercises
CREATE TABLE req_required_exercises (
    req_id integer  NOT NULL,
    req_concept integer  NOT NULL,
    req_exercise integer  NOT NULL,
    CONSTRAINT req_required_exercises_uk UNIQUE (req_concept, req_exercise),
    CONSTRAINT req_required_exercises_pk PRIMARY KEY (req_id)
) ;

-- Table: se_submited_exercise
CREATE TABLE se_submited_exercise (
    se_exercise integer  NOT NULL,
    se_user integer  NOT NULL,
    se_unlocked_exercise_key integer  NOT NULL,
    se_submission_date date  NOT NULL,
    CONSTRAINT se_submited_exercise_pk PRIMARY KEY (se_unlocked_exercise_key)
) ;

-- Table: ta_tag
CREATE TABLE ta_tag (
    ta_id integer  NOT NULL,
    ta_name varchar2(128)  NOT NULL,
    CONSTRAINT ta_tag_pk PRIMARY KEY (ta_id)
) ;

-- Table: tags_of_tracks
CREATE TABLE tags_of_tracks (
    ta_tags_ta_id integer  NOT NULL,
    tr_tracks_t_id integer  NOT NULL,
    CONSTRAINT tags_of_tracks_pk PRIMARY KEY (ta_tags_ta_id,tr_tracks_t_id)
) ;

-- Table: te_test
CREATE TABLE te_test (
    te_id integer  NOT NULL,
    te_code varchar2(2048)  NOT NULL,
    te_exercise integer  NOT NULL,
    CONSTRAINT te_test_pk PRIMARY KEY (te_id)
) ;

-- Table: tr_test_run
CREATE TABLE tr_test_run (
    tr_id integer  NOT NULL,
    tr_exercise integer  NOT NULL,
    tr_test integer  NOT NULL,
    CONSTRAINT tr_test_run_pk PRIMARY KEY (tr_id)
) ;

-- Table: tr_track
CREATE TABLE tr_track (
    t_id integer  NOT NULL,
    t_name varchar2(64)  NOT NULL,
    t_description varchar2(2048)  NOT NULL,
    CONSTRAINT tr_track_pk PRIMARY KEY (t_id)
) ;

-- Table: us_user
CREATE TABLE us_user (
    u_id integer  NOT NULL,
    u_email varchar2(256)  NOT NULL,
    u_username varchar2(128)  NOT NULL,
    u_password varchar2(512)  NOT NULL,
    CONSTRAINT us_user_pk PRIMARY KEY (u_id)
) ;

-- foreign keys
-- Reference: e_exercise_d_difficulty (table: e_exercise)
ALTER TABLE e_exercise ADD CONSTRAINT e_exercise_d_difficulty
    FOREIGN KEY (e_difficulty)
    REFERENCES d_difficulty (d_id);

-- Reference: e_exercise_tr_track (table: e_exercise)
ALTER TABLE e_exercise ADD CONSTRAINT e_exercise_tr_track
    FOREIGN KEY (e_track)
    REFERENCES tr_track (t_id);

-- Reference: exercises (table: se_submited_exercise)
ALTER TABLE se_submited_exercise ADD CONSTRAINT exercises
    FOREIGN KEY (se_exercise)
    REFERENCES e_exercise (e_id);

-- Reference: req_concepts (table: req_required_exercises)
ALTER TABLE req_required_exercises ADD CONSTRAINT req_concepts
    FOREIGN KEY (req_concept)
    REFERENCES c_concept (c_id);

-- Reference: req_exercises (table: req_required_exercises)
ALTER TABLE req_required_exercises ADD CONSTRAINT req_exercises
    FOREIGN KEY (req_exercise)
    REFERENCES e_exercise (e_id);

-- Reference: tags (table: tags_of_tracks)
ALTER TABLE tags_of_tracks ADD CONSTRAINT tags
    FOREIGN KEY (ta_tags_ta_id)
    REFERENCES ta_tag (ta_id);

-- Reference: test_runs (table: tr_test_run)
ALTER TABLE tr_test_run ADD CONSTRAINT test_runs
    FOREIGN KEY (tr_exercise)
    REFERENCES se_submited_exercise (se_unlocked_exercise_key);

-- Reference: tests (table: tr_test_run)
ALTER TABLE tr_test_run ADD CONSTRAINT tests
    FOREIGN KEY (tr_test)
    REFERENCES te_test (te_id);

-- Reference: tests_to_exercise (table: te_test)
ALTER TABLE te_test ADD CONSTRAINT tests_to_exercise
    FOREIGN KEY (te_exercise)
    REFERENCES e_exercise (e_id);

-- Reference: tracks (table: tags_of_tracks)
ALTER TABLE tags_of_tracks ADD CONSTRAINT tracks
    FOREIGN KEY (tr_tracks_t_id)
    REFERENCES tr_track (t_id);

-- Reference: users (table: se_submited_exercise)
ALTER TABLE se_submited_exercise ADD CONSTRAINT users
    FOREIGN KEY (se_user)
    REFERENCES us_user (u_id);

-- End of file.

