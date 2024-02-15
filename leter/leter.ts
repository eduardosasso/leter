import slugify from "@sindresorhus/slugify";
import fs from "fs";
import { marked } from "marked";
import path from "path";
import { bearNotesWatcher } from "./bear";
import { HOME_FILENAME, HOME_PATH, POST_PATH, loadConfig } from "./config";
import { Config, Item, ItemType } from "./types";

const start = () => {
  const config = loadConfig();

  // TODO support out frontmatter for multiple outputs to file
  bearNotesWatcher(config, (items: Item[]) => {
    items.forEach((item) => {
      buildHomepage(item, config);
      buildPost(item, config);
    });
  });
};

const project = (tags: string[], config: Config): string | null => {
  const projectTag = tags.find((tag) => config.projects[tag]);

  if (!projectTag) {
    const projectTags = Object.keys(config.projects).toString();
    console.error(
      `No project tag found. Note tags: ${tags}, projects: ${projectTags}`
    );
    return null;
  }

  return config.projects[projectTag];
};

const buildHomepage = (item: Item, config: Config) => {
  if (item.type !== ItemType.Home) return false;

  const output = project(item.tags, config);

  if (!output) return;

  const filePath = path.join(output, HOME_PATH, HOME_FILENAME);

  saveFile(filePath, item.text);
};

const buildPost = (item: Item, config: Config) => {
  if (item.type !== ItemType.Post) return false;

  const tokens = marked.lexer(item.text);
  const firstH1 = tokens.find(
    (token) => token.type === "heading" && token.depth === 1
  );

  if (!firstH1 || firstH1.type !== "text") {
    console.error(
      `No H1 title found in note tagged with ${config.bear.tags.post}.`
    );
    return;
  }

  const fileName = slugify(firstH1.text);
  const output = project(item.tags, config);

  if (!output) return;

  const filePath = path.join(output, POST_PATH, `${fileName}.md`);

  item.title = firstH1.text;
  const post = addMetadata(item);

  saveFile(filePath, post);
};

const addMetadata = (item: Item) => {
  const frontmatter = `
---
  title: ${item.title}
  description: ${item.description}
  created: ${item.created}
  updated: ${item.updated}
---
`.trim();

  return `${frontmatter}\n${item.text}`;
};

const saveFile = (filePath: fs.PathOrFileDescriptor, content: string) => {
  fs.writeFile(filePath, content, (err) => {
    if (err) {
      console.error(err);
    } else {
      console.log(`File ${filePath} created or updated.`);
    }
  });
};