import Database from "better-sqlite3";
import { watch } from "fs";
import { marked } from "marked";
import fs from "fs";
import slugify from "@sindresorhus/slugify";

let timeout;
const bearDbPath = process.env.BEAR_DB_PATH;
const ouputPath = process.env.OUTPUT_PATH;
const blogTag = "online";
const homePageTag = "homepage";
const appleCocoaTimestamp = 978307200;

const db = new Database(bearDbPath, { readonly: true });

const query = `
  SELECT
    ZSUBTITLE as subtitle,
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

// TODO
// decide if want to keep certain tags
// save file(s) to disk in markdown format
// commit to github
// push to github

let currentDate = new Date().toISOString();

watch(bearDbPath, () => {
  clearTimeout(timeout);
  timeout = setTimeout(() => {
    const changedDate = new Date().toISOString();

    const result = db.prepare(query).all(currentDate, changedDate);
    const notes = result.map((note) => note.text);

    for (const note of notes) {
      const tokens = marked.lexer(note);
      const firstH1 = tokens.find(
        (token) => token.type === "heading" && token.depth === 1
      );

      if (firstH1) {
        const fileName = slugify(firstH1.text);
        const filePath = `${ouputPath}/${fileName}.md`;

        const cleanNote = note.replace(/#[a-zA-Z0-9_]+/g, ""); // Remove all tags

        fs.writeFile(filePath, cleanNote, (err) => {
          if (err) {
            console.error(err);
          } else {
            console.log(`File ${fileName}.md created or updated.`);
          }
        });
      }
    }

    currentDate = changedDate;
  }, 5000); // 5 seconds debounce
});
