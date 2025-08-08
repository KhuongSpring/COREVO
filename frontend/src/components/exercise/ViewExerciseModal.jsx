import React from 'react';
import './ViewExerciseModal.scss';

const ViewExerciseModal = ({
  exercise,
  onClose,
  levelMap,
  muscleMap
}) => {
  if (!exercise) return null;

  // Hàm xử lý list cả ID lẫn object
  const formatList = (list, map) => {
    if (!Array.isArray(list) || list.length === 0) return 'None';
    return list.map(item => {
      if (typeof item === 'object') {
        return `• ${item.name || 'Unknown'}`;
      }
      if (map) {
        return `• ${map[item] || 'Unknown'}`;
      }
      return `• ${item}`;
    }).join('\n');
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()}>
        <h2>{exercise.name}</h2>

        <img
          src={exercise.imageURL}
          alt={exercise.name}
          className="exercise-image"
        />

        <div className="modal-section">
          <strong>Description:</strong>
          <p>{exercise.description || 'No description'}</p>
        </div>

        <div className="modal-section">
          <strong>Sets:</strong> {exercise.minSet} - {exercise.maxSet}
        </div>

        <div className="modal-section">
          <strong>Reps:</strong> {exercise.minRep} - {exercise.maxRep}
        </div>

        <div className="modal-section">
          <strong>Duration:</strong> {exercise.minDuration} - {exercise.maxDuration} seconds
        </div>

        <div className="modal-section">
          <strong>Levels:</strong>
          <div>{formatList(exercise.levels || exercise.levelIds, levelMap)}</div>
        </div>

        <div className="modal-section">
          <strong>Types:</strong>
          <div>{formatList(exercise.types || exercise.typeIds)}</div>
        </div>

        <div className="modal-section">
          <strong>Primary Muscles:</strong>
          <div>{formatList(exercise.primaryMuscles || exercise.primaryMuscleIds, muscleMap)}</div>
        </div>

        <div className="modal-section">
          <strong>Secondary Muscles:</strong>
          <div>{formatList(exercise.secondaryMuscles || exercise.secondaryMuscleIds, muscleMap)}</div>
        </div>

        <div className="modal-section">
          <strong>Equipments:</strong>
          <div>{formatList(exercise.equipments || exercise.equipmentIds)}</div>
        </div>

        <div className="modal-section">
          <strong>Locations:</strong>
          <div>{formatList(exercise.locations || exercise.locationIds)}</div>
        </div>

        <div className="modal-section">
          <strong>Goals:</strong>
          <div>{formatList(exercise.goals || exercise.goalIds)}</div>
        </div>

        <div className="modal-footer">
          <button onClick={onClose} className="close-btn">Close</button>
        </div>
      </div>
    </div>
  );
};

export default ViewExerciseModal;
