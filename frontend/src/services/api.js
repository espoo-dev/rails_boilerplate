import axios from "axios";

export const HOST = "http://localhost:3000";

export const getRequestConfig = () => {
  const token = localStorage.getItem("token");
  const requestConfig = {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };

  return requestConfig;
};

export const deleteApi = (url) => {
  return axios.delete(url, getRequestConfig());
};

export const editApi = (url, resource) => {
  return axios.put(url, resource, getRequestConfig());
};
