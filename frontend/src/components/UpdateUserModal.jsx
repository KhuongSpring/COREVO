import React, { useState, useEffect } from 'react';
import './AddUserModal.scss';

const UpdateUserModal = ({ onClose, onSubmit, editData }) => {
  const [personalInfo, setPersonalInfo] = useState({
    id: '',
    username: '',
    email: '',
    firstName: '',
    lastName: '',
    birth: '',
    phone: '',
    nationality: '',
    role: 'USER',
    address: '',
    linkAvatar: ''
  });

  useEffect(() => {
    if (editData) {
      setPersonalInfo(editData.personalInfo || {});
    }
  }, [editData]);

  const validateForm = () => {
    if (!personalInfo.username) {
      alert("Tên đăng nhập không được bỏ trống.");
      return false;
    }
    if (!personalInfo.email) {
      alert("Email không được bỏ trống.");
      return false;
    }
    if (!personalInfo.role) {
      alert("Vui lòng chọn vai trò.");
      return false;
    }

    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    if (!emailPattern.test(personalInfo.email)) {
      alert("Email không hợp lệ.");
      return false;
    }

    return true;
  };

  const handleUpdate = () => {
    if (!validateForm()) return;
    onSubmit(personalInfo);
    onClose();
  };

  return (
    <div className="modal-overlay">
      <div className="modal-content">
        <h2>Thông tin cá nhân</h2>
        <form className="form-step">
          <input
            placeholder="Username"
            value={personalInfo.username}
            onChange={e => setPersonalInfo({ ...personalInfo, username: e.target.value })}
            required
          />
          <input
            placeholder="Email"
            value={personalInfo.email}
            onChange={e => setPersonalInfo({ ...personalInfo, email: e.target.value })}
            required
          />
          <input
            placeholder="First name"
            value={personalInfo.firstName}
            onChange={e => setPersonalInfo({ ...personalInfo, firstName: e.target.value })}
          />
          <input
            placeholder="Last name"
            value={personalInfo.lastName}
            onChange={e => setPersonalInfo({ ...personalInfo, lastName: e.target.value })}
          />
          <input
            type="date"
            placeholder="Birth"
            value={personalInfo.birth}
            onChange={e => setPersonalInfo({ ...personalInfo, birth: e.target.value })}
          />
          <input
            placeholder="Phone"
            value={personalInfo.phone}
            onChange={e => setPersonalInfo({ ...personalInfo, phone: e.target.value })}
          />
          <input
            placeholder="Nationality"
            value={personalInfo.nationality}
            onChange={e => setPersonalInfo({ ...personalInfo, nationality: e.target.value })}
          />
          <select
            value={personalInfo.role}
            onChange={e => setPersonalInfo({ ...personalInfo, role: e.target.value })}
            required
          >
            <option value="USER">User</option>
            <option value="ADMIN">Admin</option>
          </select>
        </form>

        <div className="modal-buttons">
          <button onClick={onClose} className="cancel">Huỷ</button>
          <button className="confirm" onClick={handleUpdate}>Cập nhật</button>
        </div>
      </div>
    </div>
  );
};

export default UpdateUserModal;
