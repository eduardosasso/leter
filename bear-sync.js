import { watch } from "fs";
import Database from "better-sqlite3";

let timeout;
const bearDbPath = process.env.BEAR_DB_PATH;
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
// run query that fetch all the notes with a given tag sorted by the most recent updated
// if its within the last x seconds then save that to a file in a location defined in the .env file for github pages or similar
// save file(s) to disk in markdown format
// commit to github
// push to github

let currentDate = new Date().toISOString();

watch(bearDbPath, () => {
  clearTimeout(timeout);
  timeout = setTimeout(() => {
    const changedDate = new Date().toISOString();

    const notes = db.prepare(query).all(currentDate, changedDate);
    console.log(currentDate, changedDate);
    console.log(notes);

    currentDate = changedDate;
  }, 5000); // 5 seconds debounce
});
