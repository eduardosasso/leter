import Database from "better-sqlite3";
import { watch } from "fs";
import { marked } from "marked";
import fs from "fs";
import slugify from "@sindresorhus/slugify";

let timeout;

const filePath = "./leter.json";

const jsonData = JSON.parse(fs.readFileSync(filePath, "utf-8"));

const bearDbPath = jsonData.bearNotes.database;
const postPath = "/src/content/posts";
const homePath = "/src/pages";
const homeFilename = "home.md";
const homeTag = jsonData.bearNotes.tags.home;
const postTag = jsonData.bearNotes.tags.post;
const appleCocoaTimestamp = 978307200;

const db = new Database(bearDbPath, { readonly: true });

// TODO
// time to reflect my timezone PT instead of UTC
const query = `
  SELECT
    ZSUBTITLE as description,
    ZTEXT as text,
    datetime(ZCREATIONDATE + ${appleCocoaTimestamp}, 'unixepoch') as created,
    datetime(ZMODIFICATIONDATE + ${appleCocoaTimestamp}, 'unixepoch') as updated,	
    (
      SELECT GROUP_CONCAT(ZSFNOTETAG.ZTITLE)
      FROM Z_5TAGS, ZSFNOTETAG
      WHERE ZSFNOTE.Z_PK = Z_5TAGS.Z_5NOTES
      AND Z_5TAGS.Z_13TAGS = ZSFNOTETAG.Z_PK	
      GROUP BY Z_5NOTES
    ) as tags
  FROM
    ZSFNOTE
  WHERE
    updated BETWEEN datetime(?) AND datetime(?);
`;

const projects = {};
jsonData.bearNotes.projects.forEach((project) => {
  projects[project.url] = project.output;
});

const project = (tags) => {
  const projectTag = tags.find((tag) => projects[tag]);
  return projects[projectTag];
};

const buildHomepage = (note) => {
  if (!note.tags.includes(homeTag)) return false;

  const output = project(note.tags).output;

  const filePath = `${output}/${homePath}/${homeFilename}`;

  saveFile(filePath, note.text);
};

const buildPost = (note) => {
  if (!note.tags.includes(postTag)) return false;

  const tokens = marked.lexer(note.text);
  const firstH1 = tokens.find(
    (token) => token.type === "heading" && token.depth === 1
  );

  if (firstH1) {
    const fileName = slugify(firstH1.text);
    const output = project(note.tags).output;
    const filePath = `${output}/${postPath}/${fileName}.md`;

    note.title = firstH1.text;
    const post = notePlusMetadata(note);

    saveFile(filePath, post);
  } else {
    console.error("No H1 title found in note tagged with post. Skipping.");
  }
};

const notePlusMetadata = (note) => {
  const frontmatter = `
---
  title: ${note.title}
  description: ${note.description}
  created: ${note.created}
  updated: ${note.updated}
---
`.trim();

  return `${frontmatter}\n${note.text}`;
};

const saveFile = (filePath, content) => {
  fs.writeFile(filePath, content, (err) => {
    if (err) {
      console.error(err);
    } else {
      console.log(`File ${filePath} created or updated.`);
    }
  });
};

let currentDate = new Date().toISOString();

watch(bearDbPath, () => {
  clearTimeout(timeout);

  timeout = setTimeout(() => {
    const changedDate = new Date().toISOString();

    const result = db.prepare(query).all(currentDate, changedDate);

    const notes = result.filter((note) => {
      const tags = note.tags ? note.tags.split(",") : [];
      return tags.includes(postTag) || tags.includes(homepageTag);
    });

    for (const note of notes) {
      note.tags = note.tags ? note.tags.split(",") : [];
      note.text = note.text.replace(/#[a-zA-Z0-9_]+/g, ""); // Remove all tags

      buildPost(note) || buildHomepage(note);
    }

    currentDate = changedDate;
  }, 5000); // 5 seconds debounce
});
