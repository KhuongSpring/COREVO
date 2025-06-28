package com.example.corevo.utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.helper_dto.RawTrainingExerciseDto;
import com.example.corevo.domain.dto.response.training_exercise.TrainingExerciseResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.TrainingExercise;
import com.example.corevo.domain.entity.training.*;
import com.example.corevo.domain.entity.TrainingPlan;
import com.example.corevo.domain.mapper.TrainingExerciseMapper;
import com.example.corevo.domain.mapper.TrainingPlanMapper;
import com.example.corevo.exception.VsException;
import com.example.corevo.helper.TrainingExerciseConverter;
import com.example.corevo.repository.*;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AppDataSeeder implements ApplicationRunner {

    ObjectMapper objectMapper;
    Cloudinary cloudinary;
    TrainingPlanMapper trainingPlanMapper;
    TrainingExerciseMapper trainingExerciseMapper;

    LevelRepository levelRepository;
    LocationRepository locationRepository;
    EquipmentRepository equipmentRepository;
    TargetMuscleRepository targetMuscleRepository;
    TypeRepository typeRepository;
    GoalRepository goalRepository;
    TrainingPlanRepository trainingPlanRepository;
    TrainingExerciseRepository trainingExerciseRepository;

    @Override
    public void run(ApplicationArguments args) {
        seedEquipments();
        seedGoal();
        seedLevels();
        seedLocations();
        seedTargetMuscle();
        seedType();

        seedTrainingPlans();
        seedTrainingExercise();
    }

    void seedEquipments() {
        try (InputStream is = getClass().getResourceAsStream("/data/equipment.json")) {
            log.info("Start seeding equipment from JSON...");
            List<Equipment> equipmentsFromDB = equipmentRepository.findAll();
            List<Equipment> equipmentsFromJson = objectMapper.readValue(is, new TypeReference<>() {
            });
            if (equipmentsFromDB.isEmpty()) {
                equipmentRepository.saveAll(equipmentsFromJson);
            } else {
                if (equipmentsFromJson.size() > equipmentsFromDB.size()) {
                    for (Equipment x : equipmentsFromJson) {
                        if (!equipmentRepository.existsByEquipmentName(x.getEquipmentName())) {
                            equipmentRepository.save(x);
                        }
                    }
                }
            }
            log.info("Seeding equipment from JSON completed!");
        } catch (IOException e) {
            log.warn("Seeding equipment from JSON fail");
        }
    }

    void seedGoal() {
        try (InputStream is = getClass().getResourceAsStream("/data/goal.json")) {
            log.info("Start seeding goal from JSON...");
            List<Goal> goalsFromDB = goalRepository.findAll();
            List<Goal> goalsFromJson = objectMapper.readValue(is, new TypeReference<>() {
            });
            if (goalsFromDB.isEmpty()) {
                goalRepository.saveAll(goalsFromJson);
            } else {
                if (goalsFromJson.size() > goalsFromDB.size()) {
                    for (Goal x : goalsFromJson) {
                        if (!goalRepository.existsByGoalName(x.getGoalName())) {
                            goalRepository.save(x);
                        }
                    }
                }
            }
            log.info("Seeding goal from JSON completed!");
        } catch (IOException e) {
            log.warn("Seeding goal from JSON fail");
        }
    }

    void seedLevels() {
        try (InputStream is = getClass().getResourceAsStream("/data/level.json")) {
            log.info("Start seeding level from JSON...");
            List<Level> levelsFromDB = levelRepository.findAll();
            List<Level> levelsFromJSON = objectMapper.readValue(is, new TypeReference<>() {
            });
            if (levelsFromDB.isEmpty()) {
                levelRepository.saveAll(levelsFromJSON);
            } else {
                if (levelsFromJSON.size() > levelsFromDB.size()) {
                    for (Level x : levelsFromJSON) {
                        if (!levelRepository.existsByLevelName(x.getLevelName())) {
                            levelRepository.save(x);
                        }
                    }
                }
            }
            log.info("Seeding level from JSON completed!");
        } catch (IOException e) {
            log.warn("Seeding levels from JSON fail");
        }
    }

    void seedLocations() {
        try (InputStream is = getClass().getResourceAsStream("/data/location.json")) {
            log.info("Start seeding location from JSON...");
            List<Location> locationsFromDB = locationRepository.findAll();
            List<Location> locationsFromJson = objectMapper.readValue(is, new TypeReference<>() {
            });
            if (locationsFromDB.isEmpty()) {
                locationRepository.saveAll(locationsFromJson);
            } else {
                if (locationsFromJson.size() > locationsFromDB.size()) {
                    for (Location x : locationsFromJson) {
                        if (!locationRepository.existsByLocationName(x.getLocationName())) {
                            locationRepository.save(x);
                        }
                    }
                }
            }
            log.info("Seeding location from JSON completed!");
        } catch (IOException e) {
            log.warn("Seeding location from JSON fail");
        }
    }

    void seedTargetMuscle() {
        try (InputStream is = getClass().getResourceAsStream("/data/targetMuscle.json")) {
            log.info("Start seeding target muscle from JSON...");
            List<TargetMuscle> targetMusclesFromDB = targetMuscleRepository.findAll();
            List<TargetMuscle> targetMusclesFromJson = objectMapper.readValue(is, new TypeReference<>() {
            });
            if (targetMusclesFromDB.isEmpty()) {
                targetMuscleRepository.saveAll(targetMusclesFromJson);
            } else {
                if (targetMusclesFromJson.size() > targetMusclesFromDB.size()) {
                    for (TargetMuscle x : targetMusclesFromJson) {
                        if (!targetMuscleRepository.existsByTargetMuscleName(x.getTargetMuscleName())) {
                            targetMuscleRepository.save(x);
                        }
                    }
                }
            }
            log.info("Seeding target muscle from JSON completed!");
        } catch (IOException e) {
            log.warn("Seeding target muscle from JSON fail");
        }
    }

    void seedType() {
        try (InputStream is = getClass().getResourceAsStream("/data/type.json")) {
            log.info("Start seeding type from JSON...");
            List<Type> typesFromDB = typeRepository.findAll();
            List<Type> typesFromJson = objectMapper.readValue(is, new TypeReference<>() {
            });
            if (typesFromDB.isEmpty()) {
                typeRepository.saveAll(typesFromJson);
            } else {
                if (typesFromJson.size() > typesFromDB.size()) {
                    for (Type x : typesFromJson) {
                        if (!typeRepository.existsByTypeName(x.getTypeName())) {
                            typeRepository.save(x);
                        }
                    }
                }
            }
            log.info("Seeding type from JSON completed!");
        } catch (IOException e) {
            log.warn("Seeding type from JSON fail");
        }
    }



    void seedTrainingPlans() {
        try (InputStream is = getClass().getResourceAsStream("/data/training_plan.json")) {
            log.info("Start seeding training plan from JSON...");
            List<TrainingPlan> trainingPlansFromDB = trainingPlanRepository.findAll();
            List<TrainingPlanResponseDto> trainingPlansFromJson = objectMapper.readValue(is, new TypeReference<>() {
            });
            if (trainingPlansFromDB.isEmpty()) {
                List<TrainingPlan> trainingPlans = trainingPlanMapper.
                        listTrainingPlanResponseDtoToListTrainingPlan(trainingPlansFromJson);
                trainingPlanRepository.saveAll(trainingPlans);
            } else {
                if (trainingPlansFromJson.size() > trainingPlansFromDB.size()) {
                    for (TrainingPlanResponseDto x : trainingPlansFromJson){
                        if (!trainingPlanRepository.existsByNameAndType(x.getName(), x.getType())){
                            trainingPlanRepository.save(
                                    trainingPlanMapper.trainingPlanResponseDtoToTrainingPlan(x)
                            );
                        }
                    }
                }
            }
            log.info("Seeding training plan from JSON completed!");
        } catch (IOException e) {
            log.warn("Seeding training plan from JSON fail");
        }
    }

    void seedTrainingExercise() {
        List<String> jsonFiles = List.of(
                "/data/training_exercise_data/abs_training_exercise.json",
                "/data/training_exercise_data/back_training_exercise.json",
                "/data/training_exercise_data/biceps_training_exercise.json",
                "/data/training_exercise_data/chest_training_exercise.json",
                "/data/training_exercise_data/glute_training_exercise.json",
                "/data/training_exercise_data/hamstring_training_exercise.json",
                "/data/training_exercise_data/quads_training_exercise.json",
                "/data/training_exercise_data/shoulders_training_exercise.json",
                "/data/training_exercise_data/triceps_training_exercise.json"
        );

        log.info("Start seeding training exercise from JSON...");

        List<TrainingExercise> trainingExercisesFromDB = trainingExerciseRepository.findAll();

        if (trainingExercisesFromDB.isEmpty()){
            for (String file : jsonFiles){
                List<TrainingExerciseResponseDto> trainingExercisesFromJSON = loadTrainingExerciseDataFromJSON(file);
                for (TrainingExerciseResponseDto x : trainingExercisesFromJSON){
                    x.setImageURL(uploadImageIfNotExists(x.getImageURL(), cloudinary));
                }
                trainingExerciseRepository.saveAll(
                        trainingExerciseMapper.
                                ListTrainingExerciseResponseDtoToListTrainingExercise(trainingExercisesFromJSON));
                log.info("Seeding training exercise from {} completed!", file);
            }
        } else {
            List<TrainingExerciseResponseDto> trainingExercisesFromJSON = new ArrayList<>();
            for (String file : jsonFiles){
                trainingExercisesFromJSON.addAll(loadTrainingExerciseDataFromJSON(file));
            }


            if (trainingExercisesFromJSON.size() > trainingExercisesFromDB.size()){
                for (TrainingExerciseResponseDto x : trainingExercisesFromJSON){
                    if (!trainingExerciseRepository.existsByNameAndTypes_IdInAndPrimaryMuscles_IdIn(
                            x.getName(),
                            x.getTypeIds(),
                            x.getPrimaryMuscleIds()
                    )) {
                        x.setImageURL(uploadImageIfNotExists(x.getImageURL(), cloudinary));
                        trainingExerciseRepository.save(
                                trainingExerciseMapper.trainingExerciseResponseDtoToTrainingExercise(x));
                    }
                }
            }
        }

        log.info("Seeding training exercise from JSON completed!");

    }

    List<TrainingExerciseResponseDto> loadTrainingExerciseDataFromJSON (String path) {
        try (InputStream is = getClass().getResourceAsStream(path)) {
            List<RawTrainingExerciseDto> rawList = objectMapper.readValue(is, new TypeReference<>() {});

            return rawList.stream()
                    .map(TrainingExerciseConverter::convert)
                    .collect(Collectors.toList());
        } catch (IOException e) {
            log.warn("Load training exercise data from {} fail", path);
        }
        return List.of();
    }

    private boolean imageExists(Cloudinary cloudinary, String publicId) {
        try {
            cloudinary.uploader().explicit(publicId, ObjectUtils.asMap(
                    "type", "upload",
                    "resource_type", "image"
            ));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private String uploadImageIfNotExists(String filePath, Cloudinary cloudinary) {
        String filename = Paths.get(filePath).getFileName().toString();
        String nameWithoutExt = filename.replaceAll("\\.[^.]*$", "");
        String folder = Paths.get(filePath).getParent().toString().replace("\\", "/").replace("images/", "");
        String publicId = "init/" + folder + "/" + nameWithoutExt;


        if (imageExists(cloudinary, publicId)) {
            return null;
        }

        try {
            return uploadImageFromResources(cloudinary, filePath, publicId);
        } catch (Exception e) {
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_UPLOAD_IMAGE_FAIL);
        }
    }

    public String uploadImageFromResources(Cloudinary cloudinary, String pathInResources, String publicId) {
        try {
            ClassPathResource resource = new ClassPathResource(pathInResources);
            try (InputStream inputStream = resource.getInputStream()) {
                byte[] imageBytes = inputStream.readAllBytes();

                Map result = cloudinary.uploader().upload(
                        imageBytes,
                        ObjectUtils.asMap(
                                "resource_type", "image",
                                "public_id", publicId
                        )
                );

                return (String) result.get("secure_url");
            }
        } catch (IOException e) {
            e.printStackTrace();
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_UPLOAD_IMAGE_FAIL);
        }
    }

}
