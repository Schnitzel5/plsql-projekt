insert into D_DIFFICULTY (D_ID, D_NAME)
values (1, 'easy');
insert into D_DIFFICULTY (D_ID, D_NAME)
values (2, 'medium');
insert into D_DIFFICULTY (D_ID, D_NAME)
values (3, 'hard');



insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('tarndtsen0@weebly.com', 'vlillie0', '4a43456fb878f4909bb1eb41b564395b97ca59e297530b99f8e4f0dc626e3599', 1);
insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('dbodker1@nyu.edu', 'atrosdall1', '418114cda689c2dcd9db453d20aa655111a8e13d71e693543fbce8b7d87ba0d7', 1);
insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('jroyston2@mapy.cz', 'clomansey2', '3723b321e4746295b00c5ff473d1423c427a449e25008af7908ed7023eac8e8a', 0);
insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('eaustwick3@360.cn', 'ssparshett3', 'f20a4cd662842d76cf4f43f079894943250bc909d75c1210577ec7727089c80c', 0);
insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('gdelve4@livejournal.com', 'pgodthaab4', 'd6ed9133847eaaf2f35d1e14192fad7e865a7b9bc5acca12cc2d971fafe1d4f2', 0);
insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('vsnarr5@tinyurl.com', 'sdriver5', '462a5c41664267431079f1978d5a36f4bfd79f952746e6184c6bb3078ef27283', 0);
insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('mgrieg6@booking.com', 'gjinkin6', '8a19af5a182982960b7f0052dd3fadc85ad95636d5b9de8c5831cd8be96288d8', 0);
insert into us_user (u_email, u_username, u_password, u_is_mentor)
values ('jdarnbrough7@cdbaby.com', 'cduinbleton7', 'e9843ac7b07285497be57c30c4dc588069b9d74977daa435883c1c5c92db8bb6',
        0);



insert into tr_track (T_NAME, T_DESCRIPTION)
values ('C++', 'https://en.wikipedia.org/wiki/C%2B%2B');
insert into tr_track (T_NAME, T_DESCRIPTION)
values ('C#', 'https://en.wikipedia.org/wiki/C_Sharp_(programming_language)');
insert into tr_track (T_NAME, T_DESCRIPTION)
values ('Java', 'https://en.wikipedia.org/wiki/Java_(programming_language)');
insert into tr_track (T_NAME, T_DESCRIPTION)
values ('Kotlin', 'https://en.wikipedia.org/wiki/Kotlin_(programming_language)');
insert into tr_track (T_NAME, T_DESCRIPTION)
values ('Rust', 'https://en.wikipedia.org/wiki/Rust_(programming_language)');


insert into MRT_MENTOR_TRACKS (MRT_TR_TRACK, MRT_US_USER)
VALUES (1, 1);
insert into MRT_MENTOR_TRACKS (MRT_TR_TRACK, MRT_US_USER)
VALUES (2, 1);
insert into MRT_MENTOR_TRACKS (MRT_TR_TRACK, MRT_US_USER)
VALUES (1, 2);
insert into MRT_MENTOR_TRACKS (MRT_TR_TRACK, MRT_US_USER)
VALUES (4, 2);
insert into MRT_MENTOR_TRACKS (MRT_TR_TRACK, MRT_US_USER)
VALUES (5, 2);


insert into TA_TAG (TA_NAME)
VALUES ('Available');
insert into TA_TAG (TA_NAME)
VALUES ('In maintenance');
insert into TA_TAG (TA_NAME)
VALUES ('Learning exercise');



insert into C_CONCEPT (C_TITLE, C_DESCRIPTION)
VALUES ('Java Basics', 'Classes, Functions, Variables, ...');
insert into C_CONCEPT (C_TITLE, C_DESCRIPTION)
VALUES ('Java Loops', 'Why not use loops? Like, why not?');
insert into C_CONCEPT (C_TITLE, C_DESCRIPTION)
VALUES ('Java Enums', 'Enums, how they work and how you can use them.');
insert into C_CONCEPT (C_TITLE, C_DESCRIPTION)
VALUES ('Kotlin Setup', 'Install Android Studio...');


insert into TOFT_TAGS_OF_TRACKS (TOFT_TA_TAG, TOFT_TR_TRACK)
VALUES (1, 1);
insert into TOFT_TAGS_OF_TRACKS (TOFT_TA_TAG, TOFT_TR_TRACK)
VALUES (1, 2);
insert into TOFT_TAGS_OF_TRACKS (TOFT_TA_TAG, TOFT_TR_TRACK)
VALUES (1, 3);
insert into TOFT_TAGS_OF_TRACKS (TOFT_TA_TAG, TOFT_TR_TRACK)
VALUES (1, 4);
insert into TOFT_TAGS_OF_TRACKS (TOFT_TA_TAG, TOFT_TR_TRACK)
VALUES (1, 5);


insert into E_EXERCISE (E_NAME, E_DESCRIPTION, E_TR_TRACK, E_D_DIFFICULTY)
VALUES ('Infinite Loops: Conquering the Endless Challenge!', 'Prepare yourself for an epic coding odyssey where loops know no bounds! In this mind-bending journey, you''ll be thrust into the depths of complex looping scenarios that defy conventional limits. Brace yourself as you navigate through a maze of intricate conditions, dynamic iterations, and enigmatic patterns. With each loop iteration, you''ll face new challenges that push your problem-solving prowess to the extreme. Only the bravest coders dare to embark on this quest to conquer the elusive infinite loop. Are you up for the challenge? Sharpen your logic, steel your determination, and get ready to conquer the endless abyss of coding complexity in Infinite Loops: Conquering the Endless Challenge!', 3, 2);
insert into E_EXERCISE (E_NAME, E_DESCRIPTION, E_TR_TRACK, E_D_DIFFICULTY)
VALUES ('Enum-igma: Deciphering the Enigmatic Enumerations!', 'Step into a realm of enigmatic codes and unravel the mysteries of powerful enumerations in this brain-teasing adventure! Prepare to embark on a quest where the true essence of enums lies hidden. As you delve deeper into the Enum-igma, you''ll face perplexing puzzles, complex decision-making scenarios, and mind-bending transformations. Your skills will be put to the test as you unlock the secrets of enum-based architectures, harness their versatility, and conquer the code''s ultimate conundrums. Brace yourself for a thrilling journey where deciphering the enigmatic enumerations is the key to programming mastery. Can you crack the Enum-igma and emerge as the undisputed Enum Maestro?', 3, 2);
insert into E_EXERCISE (E_NAME, E_DESCRIPTION, E_TR_TRACK, E_D_DIFFICULTY)
VALUES ('Looping Around: Unraveling the Tangled Code!', 'Welcome to a coding adventure like no other! Prepare to dive headfirst into a whirlwind of loops as you unravel the mysteries of tangled code. In this thrilling challenge, you''ll navigate through a maze of loops, twist and turn your way around complex logic, and emerge victorious as the Master Unraveler. Brace yourself for a rollercoaster of emotions, from frustration to elation, as you conquer each loop and bring order to the chaos. Get ready to loop around, debug with gusto, and untangle that code like a true coding hero!', 3, 1);
insert into E_EXERCISE (E_NAME, E_DESCRIPTION, E_TR_TRACK, E_D_DIFFICULTY)
VALUES ('Enumjoy the Journey: Exploring the World of Enumerations', 'Get ready for a whimsical adventure through the realm of enumerations! In this coding quest, you''ll unlock the hidden powers of enums and embark on a journey that will have you giggling and pondering at every step. Prepare to chuckle your way through clever wordplay, discover the versatility of enums, and become the ultimate Enumaster! So grab your coding cape, put on your witty thinking cap, and get ready to Enumjoy the Journey like never before!', 3, 1);
insert into E_EXERCISE (E_NAME, E_DESCRIPTION, E_TR_TRACK, E_D_DIFFICULTY)
VALUES ('Hello World', 'Let''s dive into the fantastic world of Java by writing the most famous beginner programm! Hello World!', 3, 1);
insert into E_EXERCISE (E_NAME, E_DESCRIPTION, E_TR_TRACK, E_D_DIFFICULTY)
VALUES ('Eternal Loop: Defying the Boundaries of Complexity!', 'Prepare to enter a coding realm where loops transcend the realm of the ordinary and delve into the abyss of true complexity! Brace yourself for an extraordinary challenge as you confront the Eternal Loop—a mind-bending trial that defies all expectations. In this grueling journey, you''ll encounter loops of unimaginable intricacy, demanding your utmost concentration, creativity, and mastery of algorithmic thinking. Each twist and turn will test the very limits of your coding abilities as you navigate through tangled logic, intricate conditions, and labyrinthine iterations. Prepare to confront the relentless Eternal Loop, surpass its infinite challenges, and emerge as a true loop virtuoso—a coder who defies the boundaries of complexity!', 3, 3);



insert into REQ_REQUIRED_EXERCISES (REQ_C_CONCEPT, REQ_E_EXERCISE)
VALUES (1, 3);
insert into REQ_REQUIRED_EXERCISES (REQ_C_CONCEPT, REQ_E_EXERCISE)
VALUES (1, 4);
insert into REQ_REQUIRED_EXERCISES (REQ_C_CONCEPT, REQ_E_EXERCISE)
VALUES (1, 5);
insert into REQ_REQUIRED_EXERCISES (REQ_C_CONCEPT, REQ_E_EXERCISE)
VALUES (2, 1);
insert into REQ_REQUIRED_EXERCISES (REQ_C_CONCEPT, REQ_E_EXERCISE)
VALUES (2, 6);
insert into REQ_REQUIRED_EXERCISES (REQ_C_CONCEPT, REQ_E_EXERCISE)
VALUES (3, 2);



insert into TE_TEST (TE_CODE, TE_E_EXERCISE)
VALUES ('assertThat(loopResult).isEqualTo(new int[] {1,2,3})', 1);
insert into TE_TEST (TE_CODE, TE_E_EXERCISE)
VALUES ('assertThat(ENUM.Go).isEqualTo(1);', 2);
insert into TE_TEST (TE_CODE, TE_E_EXERCISE)
VALUES ('assertThat(loopResult).isEqualTo(new int[] {1,2,3})', 3);
insert into TE_TEST (TE_CODE, TE_E_EXERCISE)
VALUES ('assertThat(enumResult).isEqualTo(new ENUM[] {Ready, Go, Set});', 4);
insert into TE_TEST (TE_CODE, TE_E_EXERCISE)
VALUES ('assertThat(result).isEqualTo("Hello World!")', 5);
insert into TE_TEST (TE_CODE, TE_E_EXERCISE)
VALUES ('assertEqualsOrLower(trackTimerMillis(submittedCode.run()), 1000);', 6);



-- tr_test_run, se_submitted_exercise, mr_mentor_request WERDEN ÜBER FUNCTIONS/PROCEDURES gefüllt


