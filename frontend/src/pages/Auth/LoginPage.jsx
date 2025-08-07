import './LoginPage.scss';
import { useState, useEffect, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { AuthContext } from '../../context/AuthContext';

const LoginPage = () => {
  const navigate = useNavigate();
  const { login, isLoggedIn } = useContext(AuthContext);
  const [form, setForm] = useState({ username: '', password: '' });

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const response = await axios.post(
        'http://localhost:8080/api/v1/auth/login',
        {
          username: form.username,
          password: form.password,
        },
        {
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const { accessToken, refreshToken } = response.data.data;

      if (!accessToken || !refreshToken) {
        alert('No token received.');
        return;
      }

      // Giải mã JWT để lấy quyền
      const payload = JSON.parse(atob(accessToken.split('.')[1]));
      const authorities = payload.authorities || [];
      const isAdmin = authorities.includes('ROLE_ADMIN');

      if (isAdmin) {
        // Gọi AuthContext login để lưu token đúng chỗ
        login(accessToken, refreshToken);
      } else {
        alert('You do not have admin privileges.');
      }
    } catch (error) {
      if (error.response?.status === 401) {
        alert('Invalid username or password.');
      } else if (error.request) {
        alert('No response from server. Please check your backend.');
      } else {
        alert('Unexpected error occurred.');
      }
      console.error('Login error:', error);
    }
  };

  useEffect(() => {
    if (isLoggedIn) {
      navigate('/home');
    }
  }, [isLoggedIn, navigate]);

  return (
    <main className="login-page">
      <div className="card">
        <div className="logo">
          <img src="/img/logo.png" alt="CoreVo Logo" />
          <span>Corevo</span>
        </div>

        <div className="card-body">
          <h5 className="card-title text-center">Login to Your Account</h5>
          <p className="subtitle">Enter your username & password to login</p>

          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label htmlFor="username">Username</label>
              <div className="input-group">
                <div className="prefix">@</div>
                <input
                  type="text"
                  name="username"
                  value={form.username}
                  onChange={handleChange}
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="password">Password</label>
              <input
                type="password"
                name="password"
                value={form.password}
                onChange={handleChange}
                required
              />
            </div>

            <button type="submit">Login</button>

            <p className="register">
              Don't have an account? <a href="/register">Create an account</a>
            </p>
          </form>
        </div>
      </div>
    </main>
  );
};

export default LoginPage;
