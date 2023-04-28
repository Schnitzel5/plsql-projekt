CREATE OR REPLACE PACKAGE test_use_cases AS
    PROCEDURE check_get_num;
END;
/

CREATE OR REPLACE PACKAGE BODY test_use_cases AS
    PROCEDURE check_get_num
        IS
    BEGIN
        ut.expect(basic_uc.get_num()).to_equal(123);
    END;
END;
/
