use corevo;
SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;

SELECT * FROM address;
SELECT * FROM equipment;
SELECT * FROM goal;

SELECT * FROM invalidated_token;

SELECT * FROM level;
SELECT * FROM location;
SELECT * FROM target_muscle;

SELECT * FROM training_day;

SELECT * FROM training_exercise;
SELECT * FROM training_exercise_equipments;
SELECT * FROM training_exercise_goals;
SELECT * FROM training_exercise_levels;
SELECT * FROM training_exercise_locations;
SELECT * FROM training_exercise_primary_muscles;
SELECT * FROM training_exercise_secondary_muscles;
SELECT * FROM training_exercise_types;

SELECT * FROM training_group;
SELECT * FROM training_group_detail;

SELECT * FROM training_plan;
SELECT * FROM training_plan_equipments;
SELECT * FROM training_plan_levels;
SELECT * FROM training_plan_locations;

SELECT * FROM training_schedule;

SELECT * FROM type;
SELECT * FROM user;
SELECT * FROM user_health;

SELECT * FROM user_training_plans;










delete from address;
delete from user;
delete from user_health;
delete from training_plan;
delete from training_plan_levels;
delete from training_plan_locations;
delete from training_plan_equipments;
