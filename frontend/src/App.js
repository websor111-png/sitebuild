import React, { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { Toaster } from 'sonner';
import axios from 'axios';
import LandingPage from './pages/LandingPage';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import DashboardPage from './pages/DashboardPage';
import AppBuilderPage from './pages/AppBuilderPage';
import AdminPanel from './pages/AdminPanel';
import InstallerPage from './pages/InstallerPage';
import '@/App.css';

const API = `${process.env.REACT_APP_BACKEND_URL}/api`;

function ProtectedRoute({ children, adminOnly = false }) {
  const { user, loading } = useAuth();
  if (loading) return (
    <div className="min-h-screen flex items-center justify-center bg-white">
      <div className="flex flex-col items-center gap-4">
        <div className="w-8 h-8 border-2 border-[#002FA7] border-t-transparent rounded-full animate-spin" />
        <p className="text-sm text-zinc-500 font-body">Loading...</p>
      </div>
    </div>
  );
  if (!user) return <Navigate to="/login" />;
  if (adminOnly && user.role !== 'admin') return <Navigate to="/dashboard" />;
  return children;
}

function PublicRoute({ children }) {
  const { user, loading } = useAuth();
  if (loading) return (
    <div className="min-h-screen flex items-center justify-center bg-white">
      <div className="w-8 h-8 border-2 border-[#002FA7] border-t-transparent rounded-full animate-spin" />
    </div>
  );
  if (user) return <Navigate to="/dashboard" />;
  return children;
}

function AppRoutes({ installed }) {
  if (!installed) {
    return (
      <Routes>
        <Route path="/install" element={<InstallerPage />} />
        <Route path="*" element={<Navigate to="/install" />} />
      </Routes>
    );
  }

  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/install" element={<Navigate to="/" />} />
      <Route path="/login" element={<PublicRoute><LoginPage /></PublicRoute>} />
      <Route path="/register" element={<PublicRoute><RegisterPage /></PublicRoute>} />
      <Route path="/dashboard" element={<ProtectedRoute><DashboardPage /></ProtectedRoute>} />
      <Route path="/builder/:appId" element={<ProtectedRoute><AppBuilderPage /></ProtectedRoute>} />
      <Route path="/admin" element={<ProtectedRoute adminOnly><AdminPanel /></ProtectedRoute>} />
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}

function App() {
  const [installed, setInstalled] = useState(null);

  useEffect(() => {
    axios.get(`${API}/install/status`)
      .then(({ data }) => setInstalled(data.installed))
      .catch(() => setInstalled(false));
  }, []);

  if (installed === null) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#0A0A0A]">
        <div className="flex flex-col items-center gap-4">
          <div className="w-8 h-8 border-2 border-[#002FA7] border-t-transparent rounded-full animate-spin" />
          <p className="text-sm text-zinc-500">Checking installation...</p>
        </div>
      </div>
    );
  }

  return (
    <AuthProvider>
      <Toaster position="top-right" richColors />
      <BrowserRouter>
        <AppRoutes installed={installed} />
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
