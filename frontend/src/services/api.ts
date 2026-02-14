import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: `${API_BASE_URL}/api/v1`,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to requests if available
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('access_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export interface UserRegisterData {
  email: string;
  password: string;
  full_name?: string;
  tenant_name?: string;
}

export interface UserLoginData {
  email: string;
  password: string;
}

export interface TokenResponse {
  access_token: string;
  token_type: string;
}

export const authService = {
  register: (data: UserRegisterData) => 
    api.post<any>('/auth/register', data),
  
  login: async (data: UserLoginData): Promise<TokenResponse> => {
    const response = await api.post<TokenResponse>('/auth/login', data);
    if (response.data.access_token) {
      localStorage.setItem('access_token', response.data.access_token);
    }
    return response.data;
  },
  
  logout: () => {
    localStorage.removeItem('access_token');
  },
  
  getCurrentUser: () => 
    api.get('/auth/me'),
  
  isAuthenticated: (): boolean => {
    return !!localStorage.getItem('access_token');
  }
};

export default api;
