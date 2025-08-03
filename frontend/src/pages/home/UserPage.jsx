import React, { useState, useEffect, useContext } from 'react';
import {
  BarChart3, User, Menu, Search, Bell, Settings, ChevronDown,
  LogOut, Plus, Edit3, Trash2, Eye, Lock, Unlock
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import './UserPage.scss';
import { AuthContext } from '../../context/AuthContext';
import AddUserModal from '../../components/AddUserModal';
import UpdateUserModal from '../../components/UpdateUserModal';
import ViewUserModal from '../../components/ViewUserModal';

const UserPage = () => {
  const navigate = useNavigate();
  const { profile, logout } = useContext(AuthContext);

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [users, setUsers] = useState([]);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [editUser, setEditUser] = useState(null);
  const [showViewModal, setShowViewModal] = useState(false);
  const [viewUser, setViewUser] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [totalPages, setTotalPages] = useState(1);
  const [userCount, setUserCount] = useState(0);

  const fetchUserCount = async () => {
    try {
      const token = localStorage.getItem('token');
      const res = await axios.get('http://localhost:8080/api/v1/admin/users-count', {
        headers: { Authorization: `Bearer ${token}` },
      });
      const count = res.data?.data;
      setUserCount(count);
    } catch (err) {
      console.error('Lỗi khi lấy tổng số user:', err);
    }
  };

  const fetchUsers = async () => {
    try {
      const token = localStorage.getItem('token');
      const res = await axios.get('http://localhost:8080/api/v1/admin/users', {
        headers: { Authorization: `Bearer ${token}` },
        params: { pageNum: currentPage, pageSize: pageSize }
      });
      const responseData = res.data?.data;
      setUsers(Array.isArray(responseData?.items) ? responseData.items : []);
      const calculatedTotalPages = Math.max(1, Math.ceil(userCount / pageSize));
      setTotalPages(calculatedTotalPages);
    } catch (err) {
      console.error('Lỗi khi lấy danh sách user:', err);
    }
  };

  const handleViewUser = async (userId) => {
    try {
      const token = localStorage.getItem('token');
      const res = await axios.get(`http://localhost:8080/api/v1/admin/users/${userId}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      const user = res.data?.data;
      if (user) {
        setViewUser({ personalInfo: user, healthInfo: user.userHealth || {} });
        setShowViewModal(true);
      } else {
        alert('Không tìm thấy thông tin người dùng');
      }
    } catch (err) {
      console.error('Lỗi khi lấy thông tin user:', err);
      alert('Không thể xem thông tin người dùng');
    }
  };

  const handleAddUser = async (data) => {
    try {
      const token = localStorage.getItem('token');
      await axios.post('http://localhost:8080/api/v1/admin/create-user', data, {
        headers: { Authorization: `Bearer ${token}` }
      });
      alert('Tạo user thành công');
      fetchUsers();
    } catch (err) {
      console.error('Lỗi khi thêm user:', err);
      alert('Thêm user thất bại');
    }
    setShowAddModal(false);
  };

  const handleUpdateUser = async (updatedData) => {
    try {
      const token = localStorage.getItem('token');
      await axios.put(`http://localhost:8080/api/v1/admin/update-user/${updatedData.id}`, updatedData, {
        headers: { Authorization: `Bearer ${token}` }
      });
      alert('Cập nhật thành công');
      fetchUsers();
    } catch (err) {
      console.error('Lỗi khi cập nhật user:', err);
      alert('Cập nhật thất bại');
    }
    setShowEditModal(false);
  };

  const handleLockUser = async (userId) => {
    try {
      const token = localStorage.getItem('token');
      await axios.put(`http://localhost:8080/api/v1/admin/lock-user/${userId}`, {}, {
        headers: { Authorization: `Bearer ${token}` }
      });
      alert('Khóa tài khoản thành công');
      setUsers(prevUsers =>
      prevUsers.map(user =>
        user.id === userId ? { ...user, locked: true } : user
      )
    );
      //fetchUsers();
    } catch (err) {
      console.error('Lỗi khi khóa user:', err);
      alert('Khóa tài khoản thất bại');
    }
  };

  const handleUnlockUser = async (userId) => {
    try {
      const token = localStorage.getItem('token');
      await axios.put(`http://localhost:8080/api/v1/admin/unlock-user/${userId}`, {}, {
        headers: { Authorization: `Bearer ${token}` }
      });
      alert('Mở khóa tài khoản thành công');
      fetchUsers();
    } catch (err) {
      console.error('Lỗi khi mở khóa user:', err);
      alert('Mở khóa tài khoản thất bại');
    }
  };

  const handleDeleteUser = async (userId) => {
  if (!window.confirm('Bạn có chắc chắn muốn xóa người dùng này?')) return;

  try {
    const token = localStorage.getItem('token');
    await axios.delete(`http://localhost:8080/api/v1/admin/delete-user/${userId}`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    alert('Xóa user thành công');
    fetchUsers(); // refresh lại danh sách
  } catch (err) {
    console.error('Lỗi khi xóa user:', err);
    alert('Xóa user thất bại');
  }
};


  useEffect(() => {
    fetchUserCount();
  }, []);

  useEffect(() => {
    if (userCount > 0) {
      fetchUsers();
    }
  }, [userCount]);

  useEffect(() => {
    fetchUsers();
  }, [currentPage]);

  const handleLogout = () => {
    if (window.confirm('Are you sure you want to logout?')) {
      logout();
      navigate('/', { replace: true });
    }
  };

  const avatar = (profile?.firstName?.[0] || '') + (profile?.lastName?.[0] || '');
  const pathname = window.location.pathname;

  const navigationItems = [
    { name: 'Dashboard', icon: BarChart3, path: '/home' },
    { name: 'Users', icon: User, path: '/users' }
  ];

  if (!profile) return <div className="loading">Đang tải thông tin người dùng...</div>;

  return (
    <div className="dashboard">
      {sidebarOpen && <div className="sidebar-overlay" onClick={() => setSidebarOpen(false)} />}
      {userDropdownOpen && <div className="dropdown-overlay" onClick={() => setUserDropdownOpen(false)} />}

      {showAddModal && <AddUserModal onClose={() => setShowAddModal(false)} onSubmit={handleAddUser} />}
      {showEditModal && <UpdateUserModal onClose={() => setShowEditModal(false)} onSubmit={handleUpdateUser} editData={editUser} />}
      {showViewModal && <ViewUserModal onClose={() => setShowViewModal(false)} viewData={viewUser} />}

      <div className="sidebar-container">
        <aside className={`sidebar ${sidebarOpen ? 'sidebar--open' : ''}`}>
          <div className="sidebar__header">
            <h2 className="sidebar__title">
              <div className="sidebar__logo"><BarChart3 className="sidebar__logo-icon" /></div>
              Dashboard
            </h2>
          </div>
          <nav className="sidebar__nav">
            <ul className="sidebar__list">
              {navigationItems.map((item, index) => {
                const isActive = pathname === item.path;
                return (
                  <li key={index} className="sidebar__item">
                    <button
                      className={`sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
                      onClick={() => navigate(item.path)}
                    >
                      <item.icon className="sidebar__link-icon" />
                      <span className="sidebar__link-text">{item.name}</span>
                    </button>
                  </li>
                );
              })}
            </ul>
          </nav>
        </aside>
      </div>

      <div className="main-container">
        <main className="main">
          <header className="header">
            <div className="header__content">
              <div className="header__left">
                <button className="header__menu-btn" onClick={() => setSidebarOpen(true)}>
                  <Menu className="header__menu-icon" />
                </button>
                <h1 className="header__title">User Management</h1>
              </div>
              <div className="header__right">
                <div className="header__search">
                  <Search className="header__search-icon" />
                  <input type="search" placeholder="Search..." className="header__search-input" />
                </div>
                <button className="header__btn header__btn--notification">
                  <Bell className="header__btn-icon" />
                  <span className="header__notification-dot"></span>
                </button>
                <button className="header__btn">
                  <Settings className="header__btn-icon" />
                </button>
                <div className="user-dropdown">
                  <button className="user-dropdown__trigger" onClick={() => setUserDropdownOpen(!userDropdownOpen)}>
                    <div className="user-dropdown__avatar">{avatar}</div>
                    <div className="user-dropdown__info">
                      <span className="user-dropdown__name">{profile.firstName} {profile.lastName}</span>
                      <span className="user-dropdown__role">{profile.role}</span>
                    </div>
                  </button>
                  {userDropdownOpen && (
                    <div className="user-dropdown__menu">
                      <div className="user-dropdown__header">
                        <div className="user-dropdown__avatar user-dropdown__avatar--large">{avatar}</div>
                        <div className="user-dropdown__details">
                          <p className="user-dropdown__name">{profile.firstName} {profile.lastName}</p>
                          <p className="user-dropdown__email">{profile.email}</p>
                        </div>
                      </div>
                      <div className="user-dropdown__divider"></div>
                      <div className="user-dropdown__items">
                        <a href="#" className="user-dropdown__item">
                          <User className="user-dropdown__item-icon" />
                          <span>Profile Settings</span>
                        </a>
                        <a href="#" className="user-dropdown__item">
                          <Settings className="user-dropdown__item-icon" />
                          <span>Account Settings</span>
                        </a>
                      </div>
                      <div className="user-dropdown__divider"></div>
                      <button className="user-dropdown__item user-dropdown__item--logout" onClick={handleLogout}>
                        <LogOut className="user-dropdown__item-icon" />
                        <span>Logout</span>
                      </button>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </header>

          <div className="content">
            <button className="add-user-button" onClick={() => setShowAddModal(true)}>
              <Plus size={16} /> Add User
            </button>

            <table className="user-table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Username</th>
                  <th>Email</th>
                  <th>Phone</th>
                  <th>Nationality</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {users.map(u => (
                  <tr key={u.id}>
                    <td>{u.firstName} {u.lastName}</td>
                    <td>{u.username}</td>
                    <td>{u.email}</td>
                    <td>{u.phone}</td>
                    <td>{u.nationality}</td>
                    <td>
                      <button className="edit" onClick={() => {
                        setEditUser({ personalInfo: u, healthInfo: u.health || {} });
                        setShowEditModal(true);
                      }}><Edit3 size={16} /></button>

                      <button className="delete" onClick={() => handleDeleteUser(u.id)}>
                        <Trash2 size={16} />
                      </button>

                      <button className="view" onClick={() => handleViewUser(u.id)}>
                        <Eye size={16} />
                      </button>

                      <button
                        className={`lock ${u.locked ? 'locked' : ''}`}
                        onClick={() => handleLockUser(u.id)}
                      >
                        <Lock size={16} />
                      </button>


                      <button className="unlock" onClick={() => handleUnlockUser(u.id)}>
                        <Unlock size={16} />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div className="pagination">
              <button onClick={() => setCurrentPage(p => Math.max(p - 1, 1))} disabled={currentPage === 1} className={currentPage === 1 ? 'disabled' : ''}>Previous</button>
              <span>Page {currentPage} of {totalPages}</span>
              <button onClick={() => setCurrentPage(p => Math.min(p + 1, totalPages))} disabled={currentPage >= totalPages} className={currentPage >= totalPages ? 'disabled' : ''}>Next</button>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};

export default UserPage;
