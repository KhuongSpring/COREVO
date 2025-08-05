import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './AddExerciseModal.scss'; // dùng lại luôn style cũ
import {
  levelMap,
  typeMap,
  muscleMap,
  equipmentMap,
  locationMap,
  goalMap
} from '../../constants/exerciseMap';

const MultiSelect = ({ label, options, selectedIds, setSelectedIds }) => {
  const handleAdd = (e) => {
    const id = Number(e.target.value);
    if (id && !selectedIds.includes(id)) {
      setSelectedIds([...selectedIds, id]);
    }
    e.target.value = '';
  };

  const handleRemove = (id) => {
    setSelectedIds(selectedIds.filter((item) => item !== id));
  };

  return (
    <div className="multi-select">
      <label>{label}:</label>
      <div className="selected-tags">
        {selectedIds.map((id) => (
          <span key={id} className="tag">
            {options[id] || 'Unknown'}
            <button type="button" onClick={() => handleRemove(id)}>×</button>
          </span>
        ))}
      </div>
      <select onChange={handleAdd} value="">
        <option value="">-- Thêm lựa chọn --</option>
        {Object.entries(options).map(([id, name]) => (
          <option key={id} value={id}>{name}</option>
        ))}
      </select>
    </div>
  );
};

const UpdateExerciseModal = ({ exercise, onClose, onSuccess }) => {
  const [formData, setFormData] = useState(null);
  const [imageFile, setImageFile] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (exercise) {
      setFormData(exercise);
      setImagePreview(exercise.imageURL || null);
    }
  }, [exercise]);

  if (!formData) return null;

  const uploadImageToCloudinary = async (file) => {
    const data = new FormData();
    data.append('file', file);
    data.append('upload_preset', 'testProduct');

    try {
      const res = await fetch('https://api.cloudinary.com/v1_1/dqnvknzdv/image/upload', {
        method: 'POST',
        body: data
      });
      const result = await res.json();
      return result.secure_url;
    } catch (err) {
      console.error('Upload error:', err);
      return null;
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setImageFile(file);
      setImagePreview(URL.createObjectURL(file));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    let imageURL = formData.imageURL;
    if (imageFile) {
      imageURL = await uploadImageToCloudinary(imageFile);
      if (!imageURL) {
        alert('Lỗi upload ảnh!');
        setLoading(false);
        return;
      }
    }

    const payload = {
      ...formData,
      imageURL
    };

    try {
      const token = localStorage.getItem('token');
      await axios.put(`http://localhost:8080/api/v1/admin/update-exercise/${formData.id}`, payload, {
        headers: { Authorization: `Bearer ${token}` }
      });
      alert('Cập nhật bài tập thành công!');
      onSuccess();
      onClose();
    } catch (err) {
      console.error('Lỗi khi cập nhật bài tập:', err);
      alert('Lỗi khi cập nhật bài tập');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <h2>Cập nhật bài tập</h2>

        <form onSubmit={handleSubmit} className="exercise-form">
          <label>Tên bài tập:</label>
          <input type="text" name="name" value={formData.name} onChange={handleChange} required />

          <label>Mô tả:</label>
          <textarea name="description" value={formData.description} onChange={handleChange} required />

          <label>Min Set:</label>
          <input type="number" name="minSet" value={formData.minSet} onChange={handleChange} />

          <label>Max Set:</label>
          <input type="number" name="maxSet" value={formData.maxSet} onChange={handleChange} />

          <label>Min Rep:</label>
          <input type="number" name="minRep" value={formData.minRep} onChange={handleChange} />

          <label>Max Rep:</label>
          <input type="number" name="maxRep" value={formData.maxRep} onChange={handleChange} />

          <label>Min Duration (seconds):</label>
          <input type="number" name="minDuration" value={formData.minDuration} onChange={handleChange} />

          <label>Max Duration (seconds):</label>
          <input type="number" name="maxDuration" value={formData.maxDuration} onChange={handleChange} />

          <MultiSelect
            label="Levels"
            options={levelMap}
            selectedIds={formData.levelIds}
            setSelectedIds={(ids) => setFormData(prev => ({ ...prev, levelIds: ids }))}
          />

          <MultiSelect
            label="Types"
            options={typeMap}
            selectedIds={formData.typeIds}
            setSelectedIds={(ids) => setFormData(prev => ({ ...prev, typeIds: ids }))}
          />

          <MultiSelect
            label="Primary Muscles"
            options={muscleMap}
            selectedIds={formData.primaryMuscleIds}
            setSelectedIds={(ids) => setFormData(prev => ({ ...prev, primaryMuscleIds: ids }))}
          />

          <MultiSelect
            label="Secondary Muscles"
            options={muscleMap}
            selectedIds={formData.secondaryMuscleIds}
            setSelectedIds={(ids) => setFormData(prev => ({ ...prev, secondaryMuscleIds: ids }))}
          />

          <MultiSelect
            label="Equipments"
            options={equipmentMap}
            selectedIds={formData.equipmentIds}
            setSelectedIds={(ids) => setFormData(prev => ({ ...prev, equipmentIds: ids }))}
          />

          <MultiSelect
            label="Locations"
            options={locationMap}
            selectedIds={formData.locationIds}
            setSelectedIds={(ids) => setFormData(prev => ({ ...prev, locationIds: ids }))}
          />

          <MultiSelect
            label="Goals"
            options={goalMap}
            selectedIds={formData.goalIds}
            setSelectedIds={(ids) => setFormData(prev => ({ ...prev, goalIds: ids }))}
          />

          <label>Ảnh minh họa:</label>
          <input type="file" accept="image/*" onChange={handleImageChange} />
          {imagePreview && (
            <img src={imagePreview} alt="Preview" style={{ maxWidth: '100%', marginTop: 10, borderRadius: 8 }} />
          )}

          <div className="form-actions">
            <button type="button" onClick={onClose}>Hủy</button>
            <button type="submit" disabled={loading}>
              {loading ? 'Đang lưu...' : 'Lưu'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default UpdateExerciseModal;
