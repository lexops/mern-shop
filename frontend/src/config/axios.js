import axios from 'axios';

// Create the Axios instance
export const axiosi = axios.create({
  withCredentials: true,
  baseURL: process.env.REACT_APP_BASE_URL
});
