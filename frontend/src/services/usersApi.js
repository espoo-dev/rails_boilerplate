import axios from "axios";
import { HOST, getRequestConfig } from "./api";

const USERS_RESOURCE_URL = `${HOST}/api/v1/users`;

export const getUsersApi = () => {
  return axios.get(USERS_RESOURCE_URL, getRequestConfig());
};

