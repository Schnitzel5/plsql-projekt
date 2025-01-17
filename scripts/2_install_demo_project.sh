docker run --rm -v $(pwd):/work -w /work/  --network host \
    --entrypoint sqlplus gvenzl/oracle-xe:21-slim \
    sys/oracle@//127.0.0.1:1521/XE as sysdba @source/create_user.sql

docker run --rm -v $(pwd):/work -w /work/  --network host \
    --entrypoint sqlplus gvenzl/oracle-xe:21-slim \
    project_duong_reisinger/project_duong_reisinger@//127.0.0.1:1521/XE @source/project-create.sql

docker run --rm -v $(pwd):/work -w /work/  --network host \
    --entrypoint sqlplus gvenzl/oracle-xe:21-slim \
    project_duong_reisinger/project_duong_reisinger@//127.0.0.1:1521/XE @source/insert.sql

docker run --rm -v $(pwd):/work -w /work/  --network host \
    --entrypoint sqlplus gvenzl/oracle-xe:21-slim \
    project_duong_reisinger/project_duong_reisinger@//127.0.0.1:1521/XE @source/setup.sql
