-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-05 09:10:47.291

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
    d_name varchar2(64)  NOT NULL,
    CONSTRAINT d_difficulty_pk PRIMARY KEY (d_id)
) ;

-- Table: e_exercise
CREATE TABLE e_exercise (
    e_id integer  NOT NULL,
    e_name varchar2(256)  NOT NULL,
    e_description varchar2(2048)  NOT NULL,
    e_tr_track integer  NOT NULL,
    e_d_difficulty integer  NOT NULL,
    CONSTRAINT e_exercise_pk PRIMARY KEY (e_id)
) ;

-- Table: mr_mentor_request
CREATE TABLE mr_mentor_request (
    mr_id integer  NOT NULL,
    mr_us_requester integer  NOT NULL,
    mr_us_mentor integer  NULL,
    mr_se_exercise integer  NOT NULL,
    CONSTRAINT mr_mentor_request_pk PRIMARY KEY (mr_id)
) ;

-- Table: mrt_mentor_tracks
CREATE TABLE mrt_mentor_tracks (
    mrt_id integer  NOT NULL,
    mrt_tr_track integer  NOT NULL,
    mrt_us_user integer  NOT NULL,
    CONSTRAINT mrt_mentor_tracks_pk PRIMARY KEY (mrt_id)
) ;

-- Table: req_required_exercises
CREATE TABLE req_required_exercises (
    req_id integer  NOT NULL,
    req_c_concept integer  NOT NULL,
    req_e_exercise integer  NOT NULL,
    CONSTRAINT req_required_exercises_uk UNIQUE (req_c_concept, req_e_exercise),
    CONSTRAINT req_required_exercises_pk PRIMARY KEY (req_id)
) ;

-- Table: se_submited_exercise
CREATE TABLE se_submited_exercise (
    se_id integer  NOT NULL,
    se_e_exercise integer  NOT NULL,
    se_us_user integer  NOT NULL,
    se_unlocked_exercise_key integer  NOT NULL,
    se_submission_date date  NOT NULL,
    se_public number(1,0)  NOT NULL,
    se_code varchar2(2048)  NOT NULL,
    CONSTRAINT se_submited_exercise_pk PRIMARY KEY (se_id)
) ;

-- Table: ta_tag
CREATE TABLE ta_tag (
    ta_id integer  NOT NULL,
    ta_name varchar2(128)  NOT NULL,
    CONSTRAINT ta_tag_pk PRIMARY KEY (ta_id)
) ;

-- Table: te_test
CREATE TABLE te_test (
    te_id integer  NOT NULL,
    te_code varchar2(2048)  NOT NULL,
    te_e_exercise integer  NOT NULL,
    CONSTRAINT te_test_pk PRIMARY KEY (te_id)
) ;

-- Table: toft_tags_of_tracks
CREATE TABLE toft_tags_of_tracks (
    toft_id integer  NOT NULL,
    toft_ta_tag integer  NOT NULL,
    toft_tr_track integer  NOT NULL,
    CONSTRAINT toft_tags_of_tracks_pk PRIMARY KEY (toft_id)
) ;

-- Table: tr_test_run
CREATE TABLE tr_test_run (
    tr_id integer  NOT NULL,
    tr_te_test integer  NOT NULL,
    tr_se_exercise integer  NOT NULL,
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
    u_is_mentor number(1,0)  NOT NULL,
    CONSTRAINT us_user_pk PRIMARY KEY (u_id)
) ;

-- foreign keys
-- Reference: e_exercise_d_difficulty (table: e_exercise)
ALTER TABLE e_exercise ADD CONSTRAINT e_exercise_d_difficulty
    FOREIGN KEY (e_d_difficulty)
    REFERENCES d_difficulty (d_id);

-- Reference: e_exercise_tr_track (table: e_exercise)
ALTER TABLE e_exercise ADD CONSTRAINT e_exercise_tr_track
    FOREIGN KEY (e_tr_track)
    REFERENCES tr_track (t_id);

-- Reference: exercises (table: se_submited_exercise)
ALTER TABLE se_submited_exercise ADD CONSTRAINT exercises
    FOREIGN KEY (se_e_exercise)
    REFERENCES e_exercise (e_id);

-- Reference: mr_mentor (table: mr_mentor_request)
ALTER TABLE mr_mentor_request ADD CONSTRAINT mr_mentor
    FOREIGN KEY (mr_us_mentor)
    REFERENCES us_user (u_id);

-- Reference: mr_mentor_request_us_user (table: mr_mentor_request)
ALTER TABLE mr_mentor_request ADD CONSTRAINT mr_mentor_request_us_user
    FOREIGN KEY (mr_us_requester)
    REFERENCES us_user (u_id);

-- Reference: mr_se_submited_exercise (table: mr_mentor_request)
ALTER TABLE mr_mentor_request ADD CONSTRAINT mr_se_submited_exercise
    FOREIGN KEY (mr_se_exercise)
    REFERENCES se_submited_exercise (se_id);

-- Reference: mrt_mentor_tracks_tr_track (table: mrt_mentor_tracks)
ALTER TABLE mrt_mentor_tracks ADD CONSTRAINT mrt_mentor_tracks_tr_track
    FOREIGN KEY (mrt_tr_track)
    REFERENCES tr_track (t_id);

-- Reference: mrt_mentor_tracks_us_user (table: mrt_mentor_tracks)
ALTER TABLE mrt_mentor_tracks ADD CONSTRAINT mrt_mentor_tracks_us_user
    FOREIGN KEY (mrt_us_user)
    REFERENCES us_user (u_id);

-- Reference: req_concepts (table: req_required_exercises)
ALTER TABLE req_required_exercises ADD CONSTRAINT req_concepts
    FOREIGN KEY (req_c_concept)
    REFERENCES c_concept (c_id);

-- Reference: req_exercises (table: req_required_exercises)
ALTER TABLE req_required_exercises ADD CONSTRAINT req_exercises
    FOREIGN KEY (req_e_exercise)
    REFERENCES e_exercise (e_id);

-- Reference: tags (table: toft_tags_of_tracks)
ALTER TABLE toft_tags_of_tracks ADD CONSTRAINT tags
    FOREIGN KEY (toft_ta_tag)
    REFERENCES ta_tag (ta_id);

-- Reference: tests (table: tr_test_run)
ALTER TABLE tr_test_run ADD CONSTRAINT tests
    FOREIGN KEY (tr_te_test)
    REFERENCES te_test (te_id);

-- Reference: tests_to_exercise (table: te_test)
ALTER TABLE te_test ADD CONSTRAINT tests_to_exercise
    FOREIGN KEY (te_e_exercise)
    REFERENCES e_exercise (e_id);

-- Reference: tr_test_submited_exercise (table: tr_test_run)
ALTER TABLE tr_test_run ADD CONSTRAINT tr_test_submited_exercise
    FOREIGN KEY (tr_se_exercise)
    REFERENCES se_submited_exercise (se_id);

-- Reference: tracks (table: toft_tags_of_tracks)
ALTER TABLE toft_tags_of_tracks ADD CONSTRAINT tracks
    FOREIGN KEY (toft_tr_track)
    REFERENCES tr_track (t_id);

-- Reference: users (table: se_submited_exercise)
ALTER TABLE se_submited_exercise ADD CONSTRAINT users
    FOREIGN KEY (se_us_user)
    REFERENCES us_user (u_id);

-- End of file.

