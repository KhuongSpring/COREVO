import React, { useState, useEffect, useContext, useRef } from 'react';
import {
  BarChart3, Users, Dumbbell, Activity
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import Sidebar from "../../components/sidebar/Sideb";
import Header from "../../components/header/Header";
import './HomePage.scss';
import { AuthContext } from '../../context/AuthContext';
import ApexCharts from 'apexcharts';

const ToggleSwitch = ({ isMonthMode, onToggle }) => {
  return (
    <div
      style={{
        cursor: 'pointer',
        width: '100px',
        height: '40px',
        backgroundColor: '#1d9bf0',
        borderRadius: '999px',
        position: 'relative',
        userSelect: 'none'
      }}
      onClick={onToggle}
    >
      <span
        style={{
          position: 'absolute',
          top: '50%',
          transform: 'translateY(-50%)',
          left: isMonthMode ? '50px' : '10px',
          fontSize: '12px',
          fontWeight: 'bold',
          color: 'white',
          zIndex: 1,
          transition: 'left 0.3s'
        }}
      >
        {isMonthMode ? 'MONTH' : 'DAY'}
      </span>
      <div
        style={{
          width: '34px',
          height: '34px',
          backgroundColor: 'white',
          borderRadius: '50%',
          position: 'absolute',
          top: '3px',
          left: isMonthMode ? '3px' : '63px',
          transition: 'left 0.3s'
        }}
      />
    </div>
  );
};

const HomePage = () => {
  const navigate = useNavigate();
  const { logout, api } = useContext(AuthContext);

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [userCount, setUserCount] = useState(0);
  const [exerciseCount, setExerciseCount] = useState(0);
  const [chartMode, setChartMode] = useState('day');

  const chartRef = useRef(null);
  const chartInstanceRef = useRef(null);

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const res = await api.get('/user/profile');
        setCurrentUser(res.data.data);
      } catch (error) {
        console.error('Lỗi khi lấy thông tin người dùng:', error);
      }
    };

    const fetchUserCount = async () => {
      try {
        const res = await api.get('admin/users', { params: { pageNum: 1, pageSize: 1 } });
        const total = res.data?.data?.meta?.totalElement || 0;
        setUserCount(total);
      } catch (err) {
        console.error('Lỗi khi lấy số lượng user:', err);
      }
    };

    const fetchExerciseCount = async () => {
      try {
        const res = await api.get('admin/exercises', { params: { pageNum: 1, pageSize: 1 } });
        const total = res.data?.data?.meta?.totalElement || 0;
        setExerciseCount(total);
      } catch (err) {
        console.error('Lỗi khi lấy số lượng bài tập:', err);
      }
    };

    fetchProfile();
    fetchUserCount();
    fetchExerciseCount();
  }, [api]);

  useEffect(() => {
    let timeoutId;

    const fetchAndRenderChart = async () => {
      try {
        const endpoint = chartMode === 'day' ? '/admin/user-day' : '/admin/user-month';
        const res = await api.post(endpoint);
        const data = res.data?.data || [];

        const categories = data.map(d => d.day || d.month);
        const seriesData = [];
        let cumulative = 0;
        data.forEach(d => {
          cumulative += d.count;
          seriesData.push(cumulative);
        });

        if (chartInstanceRef.current) {
          chartInstanceRef.current.destroy();
        }

        const options = {
          series: [{
            name: "Tổng người dùng tích lũy",
            data: seriesData
          }],
          chart: {
            height: 350,
            type: 'line',
            zoom: { enabled: false }
          },
          dataLabels: { enabled: false },
          stroke: { curve: 'smooth', width: 3 },
          grid: {
            row: {
              colors: ['#f3f3f3', 'transparent'],
              opacity: 0.5
            }
          },
          xaxis: { categories }
        };

        if (chartRef.current) {
          chartInstanceRef.current = new ApexCharts(chartRef.current, options);
          chartInstanceRef.current.render();
        }
      } catch (err) {
        console.error('Lỗi khi fetch biểu đồ:', err);
      }
    };

    const waitForChartEl = () => {
      if (chartRef.current) {
        fetchAndRenderChart();
      } else {
        timeoutId = setTimeout(waitForChartEl, 100);
      }
    };

    waitForChartEl();

    return () => {
      if (chartInstanceRef.current) {
        chartInstanceRef.current.destroy();
        chartInstanceRef.current = null;
      }
      clearTimeout(timeoutId);
    };
  }, [api, chartMode]);

  const handleLogout = () => {
    if (window.confirm('Are you sure you want to logout?')) {
      logout();
      setUserDropdownOpen(false);
      navigate('/', { replace: true });
    }
  };

  const dashboardData = [
    {
      title: "Total Users",
      subtitle: "All Time",
      value: userCount,
      isPositive: true,
      icon: Users,
      color: "emerald"
    },
    {
      title: "Total Exercises",
      subtitle: "All Time",
      value: exerciseCount,
      isPositive: true,
      icon: Dumbbell,
      color: "blue"
    }
  ];

  const navigationItems = [
    { name: 'Dashboard', icon: BarChart3, path: '/home' },
    { name: 'Users', icon: Users, path: '/users' },
    { name: 'Exercise', icon: Dumbbell, path: '/exercise' }
  ];

  if (!currentUser) {
    return <div className="loading">Đang tải thông tin người dùng...</div>;
  }

  return (
    <div className="dashboard">
      <Sidebar
        sidebarOpen={sidebarOpen}
        setSidebarOpen={setSidebarOpen}
        navigationItems={navigationItems}
      />

      {userDropdownOpen && (
        <div className="dropdown-overlay" onClick={() => setUserDropdownOpen(false)} />
      )}

      <div className="main-container">
        <main className="main">
          <Header
            currentUser={currentUser}
            sidebarOpen={sidebarOpen}
            setSidebarOpen={setSidebarOpen}
            userDropdownOpen={userDropdownOpen}
            setUserDropdownOpen={setUserDropdownOpen}
            handleLogout={handleLogout}
            pageTitle="Dashboard"
          />

          <div className="content">
            <div className="stats">
              {dashboardData.map((item, index) => (
                <div key={index} className={`card card--${item.color}`}>
                  <div className="card__content">
                    <div className="card__header">
                      <div className={`card__icon card__icon--${item.color}`}>
                        <item.icon className="card__icon-svg" />
                      </div>
                      {/* ✅ Icon TrendingUp/TrendingDown đã được xóa tại đây */}
                    </div>
                    <div className="card__body">
                      <h3 className="card__subtitle">{item.title} | {item.subtitle}</h3>
                      <p className="card__value">{item.value}</p>
                    </div>
                  </div>
                  <div className={`card__accent card__accent--${item.color}`}></div>
                </div>
              ))}
            </div>

            <div className="activity">
              <div className="activity__header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div className="activity__title-wrapper" style={{ display: 'flex', alignItems: 'center' }}>
                  <Activity className="activity__title-icon" />
                  <h2 className="activity__title">User Registration Chart</h2>
                </div>
                <ToggleSwitch
                  isMonthMode={chartMode === 'month'}
                  onToggle={() => setChartMode(chartMode === 'day' ? 'month' : 'day')}
                />
              </div>

              <div className="activity__content">
                <div ref={chartRef} style={{ width: '100%', maxWidth: '1000px', margin: '0 auto' }}></div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};

export default HomePage;
