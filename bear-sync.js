import Database from "better-sqlite3";
import { watch } from "fs";
import { marked } from "marked";
import fs from "fs";
import slugify from "@sindresorhus/slugify";

let timeout;

const bearDbPath = process.env.BEAR_DB_PATH;
const ouputPath = process.env.OUTPUT_PATH;
const isAstro = process.env.ASTRO;
const postPath = isAstro ? `${ouputPath}/src/content/posts` : null;
const homepagePath = isAstro ? `${ouputPath}/src/pages` : null;
const homepageFilename = "home.md";
const postTag = "post";
const homepageTag = "homepage";
const appleCocoaTimestamp = 978307200;

const db = new Database(bearDbPath, { readonly: true });

// TODO
// time to reflecrt my timezone PT instead of UTC
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

const buildHomepage = (note) => {
  if (!note.tags.includes(homepageTag)) return false;

  const filePath = `${homepagePath}/${homepageFilename}`;

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
    const filePath = `${postPath}/${fileName}.md`;

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
