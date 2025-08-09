// src/context/AuthContext.js
import { createContext, useState, useEffect } from "react";
import axios from "axios";

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isLoggedIn, setIsLoggedIn] = useState(!!sessionStorage.getItem("accessToken"));
  const [profile, setProfile] = useState(null);

  let isRefreshing = false;
  let refreshSubscribers = [];

  const subscribeTokenRefresh = (cb) => {
    refreshSubscribers.push(cb);
  };

  const onRrefreshed = (newToken) => {
    refreshSubscribers.forEach((cb) => cb(newToken));
    refreshSubscribers = [];
  };

  const isTokenExpired = (token) => {
    if (!token) return true;
    const payload = JSON.parse(atob(token.split('.')[1]));
    return payload.exp * 1000 < Date.now();
  };

  const api = axios.create({
    baseURL: "http://146.190.101.127:8080/api/v1/",
  });

  api.interceptors.request.use(
    async (config) => {
      let accessToken = sessionStorage.getItem("accessToken");

      if (isTokenExpired(accessToken)) {
        if (!isRefreshing) {
          isRefreshing = true;
          const refreshToken = localStorage.getItem("refreshToken");

          if (refreshToken) {
            try {
              const res = await axios.post("http://146.190.101.127:8080/api/v1/auth/refresh-token", {
                refreshToken,
              });

              accessToken = res.data.data.accessToken;
              const newRefreshToken = res.data.data.refreshToken || refreshToken;

              sessionStorage.setItem("accessToken", accessToken);
              localStorage.setItem("refreshToken", newRefreshToken);

              isRefreshing = false;
              onRrefreshed(accessToken);
            } catch (err) {
              console.error("Refresh token failed:", err);
              isRefreshing = false;
              logout();
              return Promise.reject(err);
            }
          } else {
            logout();
          }
        }

        return new Promise((resolve) => {
          subscribeTokenRefresh((newToken) => {
            config.headers.Authorization = `Bearer ${newToken}`;
            resolve(config);
          });
        });
      }

      config.headers.Authorization = `Bearer ${accessToken}`;
      return config;
    },
    (error) => Promise.reject(error)
  );

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const res = await api.get("/user/profile");
        setProfile(res.data.data);
      } catch (err) {
        console.error("Lỗi lấy profile:", err);
        logout();
      }
    };

    if (isLoggedIn) {
      fetchProfile();
    }
  }, [isLoggedIn]);

  const login = (accessToken, refreshToken) => {
    sessionStorage.setItem("accessToken", accessToken);
    localStorage.setItem("refreshToken", refreshToken);
    setIsLoggedIn(true);
  };

  const logout = () => {
    sessionStorage.removeItem("accessToken");
    localStorage.removeItem("refreshToken");
    setIsLoggedIn(false);
    setProfile(null);
  };

  return (
    <AuthContext.Provider value={{ isLoggedIn, login, logout, profile, setProfile, api }}>
      {children}
    </AuthContext.Provider>
  );
};
