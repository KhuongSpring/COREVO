import React, { useState, useEffect, useContext } from 'react';
import { BarChart3, User, Dumbbell, Eye, Search } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import './ExercisePage.scss';
import Sidebar from '../../components/sidebar/Sideb';
import Header from '../../components/header/Header';
import { AuthContext } from '../../context/AuthContext';
import {
  levelMap,
  muscleMap,
  typeMap,
  locationMap,
  equipmentMap,
  goalMap
} from '../../constants/exerciseMap';

const ExercisePage = () => {
  const navigate = useNavigate();
  const { profile, logout, api } = useContext(AuthContext);

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [exercises, setExercises] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [totalPages, setTotalPages] = useState(1);
  const [exerciseCount, setExerciseCount] = useState(0);
  const [goToPage, setGoToPage] = useState('');
  const [selectedImage, setSelectedImage] = useState(null);
  const [viewExercise, setViewExercise] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  const navigationItems = [
    { name: 'Dashboard', icon: BarChart3, path: '/home' },
    { name: 'Users', icon: User, path: '/users' },
    { name: 'Exercise', icon: Dumbbell, path: '/exercise' }
  ];

  const fetchExercises = async () => {
    try {
      const res = await api.get('/admin/exercises', {
        params: { pageNum: currentPage, pageSize }
      });
      const responseData = res.data?.data;
      const totalElement = responseData?.meta?.totalElement || 0;
      setExerciseCount(totalElement);
      setExercises(Array.isArray(responseData?.items) ? responseData.items : []);
      setTotalPages(Math.max(1, Math.ceil(totalElement / pageSize)));
    } catch (err) {
      console.error('Lỗi khi lấy danh sách bài tập:', err);
    }
  };

  const searchExercises = async () => {
    if (!searchTerm.trim()) {
      fetchExercises();
      return;
    }
    try {
      const res = await api.post(
        '/admin/search-training-exercise',
        { searchSentence: searchTerm },
        { params: { pageNum: currentPage, pageSize } }
      );
      const responseData = res.data?.data;
      const totalElement = responseData?.meta?.totalElement || 0;
      setExerciseCount(totalElement);
      setExercises(Array.isArray(responseData?.items) ? responseData.items : []);
      setTotalPages(Math.max(1, Math.ceil(totalElement / pageSize)));
    } catch (err) {
      console.error('Lỗi khi tìm kiếm bài tập:', err);
    }
  };

  useEffect(() => {
    if (searchTerm.trim()) {
      searchExercises();
    } else {
      fetchExercises();
    }
  }, [currentPage]);

  const handleLogout = () => {
    if (window.confirm('Are you sure you want to logout?')) {
      logout();
      navigate('/', { replace: true });
    }
  };

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

  if (!profile) return <div className="loading">Đang tải thông tin người dùng...</div>;

  return (
    <div className="dashboard">
      <Sidebar
        sidebarOpen={sidebarOpen}
        setSidebarOpen={setSidebarOpen}
        navigationItems={navigationItems}
      />

      {userDropdownOpen && <div className="dropdown-overlay" onClick={() => setUserDropdownOpen(false)} />}

      <div className="main-container">
        <main className="main">
          <Header
            currentUser={profile}
            sidebarOpen={sidebarOpen}
            setSidebarOpen={setSidebarOpen}
            userDropdownOpen={userDropdownOpen}
            setUserDropdownOpen={setUserDropdownOpen}
            handleLogout={handleLogout}
            pageTitle="Exercise Management"
          />

          <div className="content">
            {/* Thanh tìm kiếm */}
            <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
              <input
                type="text"
                placeholder="Nhập tên bài tập..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                style={{
                  padding: '6px 10px',
                  borderRadius: 6,
                  border: '1px solid #ccc',
                  flex: '1'
                }}
              />
              <button
                onClick={() => {
                  setCurrentPage(1);
                  searchExercises();
                }}
                style={{
                  background: '#1e3a8a',
                  color: '#fff',
                  padding: '6px 12px',
                  border: 'none',
                  borderRadius: 6,
                  display: 'flex',
                  alignItems: 'center',
                  gap: 4,
                  cursor: 'pointer'
                }}
              >
                <Search size={16} /> Search
              </button>
            </div>

            <table className="user-table">
              <thead>
                <tr>
                  <th>Image</th>
                  <th>Name</th>
                  <th>Muscles</th>
                  <th>Levels</th>
                  <th>Description</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {exercises.map(ex => (
                  <tr key={ex.id}>
                    <td>
                      <img
                        src={ex.imageURL}
                        alt={ex.name}
                        onClick={() => setSelectedImage(ex.imageURL)}
                        style={{
                          width: 100,
                          height: 70,
                          objectFit: 'cover',
                          borderRadius: 4,
                          border: '1px solid #ccc',
                          cursor: 'pointer'
                        }}
                      />
                    </td>
                    <td><strong>{ex.name}</strong></td>
                    <td>
                      <div style={{ whiteSpace: 'pre-line' }}>
                        {ex.primaryMuscleIds?.map(muscleId => `• ${muscleMap[muscleId] || 'Unknown'}`).join('\n')}
                      </div>
                    </td>
                    <td>
                      <div style={{ whiteSpace: 'pre-line' }}>
                        {ex.levelIds?.map(id => `• ${levelMap[id] || 'Unknown'}`).join('\n')}
                      </div>
                    </td>
                    <td style={{ maxWidth: 200 }}>
                      {ex.description?.length > 80
                        ? ex.description.slice(0, 80) + '...'
                        : ex.description}
                    </td>
                    <td>
                      <button className="view" onClick={() => setViewExercise(ex)}>
                        <Eye size={16} />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div className="pagination">
              <button onClick={() => setCurrentPage(p => Math.max(p - 1, 1))} disabled={currentPage === 1}>
                Previous
              </button>
              <span>Page {currentPage} of {totalPages}</span>
              <input
                type="number"
                value={goToPage}
                min={1}
                max={totalPages}
                onChange={(e) => setGoToPage(e.target.value)}
                style={{ width: 60, textAlign: 'center', marginLeft: 8 }}
              />
              <button onClick={() => {
                const pageNum = parseInt(goToPage);
                if (!isNaN(pageNum) && pageNum >= 1 && pageNum <= totalPages) {
                  setCurrentPage(pageNum);
                } else {
                  alert(`Vui lòng nhập số trang từ 1 đến ${totalPages}`);
                }
              }}>
                Go
              </button>
              <button onClick={() => setCurrentPage(p => Math.min(p + 1, totalPages))} disabled={currentPage >= totalPages}>
                Next
              </button>
            </div>
          </div>
        </main>
      </div>

      {selectedImage && (
        <div className="modal-overlay" onClick={() => setSelectedImage(null)} style={{
          position: 'fixed', top: 0, left: 0, width: '100%', height: '100%',
          background: 'rgba(0,0,0,0.7)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000
        }}>
          <img src={selectedImage} alt="Preview" style={{
            maxWidth: '90%', maxHeight: '90%', borderRadius: 8,
            boxShadow: '0 0 20px rgba(0,0,0,0.5)'
          }} />
        </div>
      )}

      {viewExercise && (
        <div className="modal-overlay" onClick={() => setViewExercise(null)} style={{
          position: 'fixed', top: 0, left: 0, width: '100%', height: '100%',
          background: 'rgba(0,0,0,0.6)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000
        }}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()} style={{
            background: '#fff', padding: 20, borderRadius: 10,
            maxWidth: 600, width: '90%', maxHeight: '90%', overflowY: 'auto'
          }}>
            <h2>{viewExercise.name}</h2>
            <img src={viewExercise.imageURL} alt={viewExercise.name} style={{
              width: '100%', maxHeight: 250, objectFit: 'cover', borderRadius: 8, marginBottom: 16
            }} />
            <p><strong>Description:</strong> {viewExercise.description}</p>
            <p><strong>Sets:</strong> {viewExercise.minSet} - {viewExercise.maxSet}</p>
            <p><strong>Reps:</strong> {viewExercise.minRep} - {viewExercise.maxRep}</p>
            <p><strong>Duration:</strong> {viewExercise.minDuration} - {viewExercise.maxDuration} seconds</p>
            <p><strong>Levels:</strong><br />{formatList(viewExercise.levels || viewExercise.levelIds, levelMap)}</p>
            <p><strong>Types:</strong><br />{formatList(viewExercise.types || viewExercise.typeIds, typeMap)}</p>
            <p><strong>Primary Muscles:</strong><br />{formatList(viewExercise.primaryMuscles || viewExercise.primaryMuscleIds, muscleMap)}</p>
            <p><strong>Secondary Muscles:</strong><br />{formatList(viewExercise.secondaryMuscles || viewExercise.secondaryMuscleIds, muscleMap)}</p>
            <p><strong>Equipments:</strong><br />{formatList(viewExercise.equipments || viewExercise.equipmentIds, equipmentMap)}</p>
            <p><strong>Locations:</strong><br />{formatList(viewExercise.locations || viewExercise.locationIds, locationMap)}</p>
            <p><strong>Goals:</strong><br />{formatList(viewExercise.goals || viewExercise.goalIds, goalMap)}</p>
            <div style={{ textAlign: 'right', marginTop: 10 }}>
              <button onClick={() => setViewExercise(null)} style={{
                padding: '6px 12px', background: '#1e3a8a', color: '#fff',
                border: 'none', borderRadius: 6, cursor: 'pointer'
              }}>Close</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ExercisePage;
