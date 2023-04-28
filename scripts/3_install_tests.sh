docker run --rm -v $(pwd):/work -w /work/  --network host \
    --entrypoint sqlplus gvenzl/oracle-xe:21-slim \
    project_duong_reisinger/project_duong_reisinger@//127.0.0.1:1521/XE @test/testing.sql
