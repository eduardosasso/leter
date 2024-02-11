import fs from 'fs';

const CONFIG_FILE_PATH = './leter.json';

interface Config {
  bear: {
    database: string,
    tags: {
      post: string,
      home: string,
    },
  };
  projects: {
    tag: string,
    path: string,
  }[];
}

const loadConfig = (): Config => {
  const config = JSON.parse(fs.readFileSync(CONFIG_FILE_PATH, 'utf8'));
  return config;
};

export { Config, loadConfig };