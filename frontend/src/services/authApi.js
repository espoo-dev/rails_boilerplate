import axios from "axios";
import { HOST, getRequestConfig } from "./api";

export const OMNIAUTH_URL = `${HOST}/auth/sign_up`;
const LOGIN_URL = `${HOST}/users/tokens/sign_in`;
const CHECK_TOKEN_URL = `${HOST}/auth/check`;

export const doLoginApi = (username, password) => {
  const params = { email: username, password };

  return axios.post(LOGIN_URL, params);
};

export const checkAuthApi = () => {
  return axios.get(CHECK_TOKEN_URL, getRequestConfig());
};
