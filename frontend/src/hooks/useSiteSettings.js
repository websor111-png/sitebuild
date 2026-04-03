import { useState, useEffect } from 'react';
import axios from 'axios';

const API = `${process.env.REACT_APP_BACKEND_URL}/api`;
const DEFAULT_LOGO = "https://customer-assets.emergentagent.com/job_deploy-automation-14/artifacts/bf162d38_file_00000000607472438cf619bea5a5c3b5.png";

let cachedSettings = null;

export function useSiteSettings() {
  const [settings, setSettings] = useState(cachedSettings || {
    logo_url: DEFAULT_LOGO,
    site_name: "Elyn Builder",
    favicon_url: DEFAULT_LOGO
  });

  useEffect(() => {
    if (cachedSettings) return;
    axios.get(`${API}/settings`).then(({ data }) => {
      cachedSettings = data;
      setSettings(data);
    }).catch(() => {});
  }, []);

  return settings;
}
