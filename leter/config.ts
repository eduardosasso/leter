import fs from 'fs';
import { Config, JsonConfig } from './types';

const CONFIG_PATH = './leter.json';
const HOME_PATH = "/src/pages";
const HOME_FILENAME = "home.md";
const POST_PATH = "/src/content/posts";

const loadConfig = (): Config => {
  const config: JsonConfig = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf8'));

  return {
    ...config,
    projects: projects(config),
  };
};

const projects = (config: JsonConfig) => {
  return config.projects.reduce((acc, project) => {
    acc[project.tag] = project.path;
    return acc;
  }, {} as { [key: string]: string });
};


export { HOME_PATH, HOME_FILENAME, POST_PATH, loadConfig};