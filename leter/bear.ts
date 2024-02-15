import Database from "better-sqlite3";
import { watch } from "fs";
import { Config, Item, ItemType } from "./types";

const APPLE_COCOA_TIMESTAMP = 978307200;

// TODO
// time to reflect my timezone PT instead of UTC

/**
 * SQL query to retrieve notes with their descriptions, text, creation date, modification date, and tags.
 *
 * @param {string} startDate - The start date for filtering the notes.
 * @param {string} endDate - The end date for filtering the notes.
 * @returns {string} The SQL query.
 */
const query = `
  SELECT
    ZSUBTITLE as description,
    ZTEXT as text,
    datetime(ZCREATIONDATE + ${APPLE_COCOA_TIMESTAMP}, 'unixepoch') as created,
    datetime(ZMODIFICATIONDATE + ${APPLE_COCOA_TIMESTAMP}, 'unixepoch') as updated,	
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

const bearNotesWatcher = (config: Config, callback: any) => {
  let timeout: NodeJS.Timeout;
  let currentDate = new Date().toISOString();

  const db = new Database(config.bear.database, { readonly: true });

  watch(config.bear.database, () => {
    clearTimeout(timeout);

    timeout = setTimeout(() => {
      const changedDate = new Date().toISOString();

      const stmt = db.prepare(query);

      const notes = stmt.all(currentDate, changedDate).map((note: any) => ({
        ...note,
        text: note.text.replace(/#[a-zA-Z0-9_]+/g, ""), // Remove all tags
        tags: note.tags ? note.tags.split(",") : [],
        type: noteType(note.tags, config),
      })) as Item[];

      callback(notes);

      currentDate = changedDate;
    }, 5000); // 5 seconds debounce
  });
};

const noteType = (tags: string[], config: Config): ItemType | null => {
  if (tags.includes(config.bear.tags.post)) return ItemType.Post;
  if (tags.includes(config.bear.tags.home)) return ItemType.Home;

  return null;
};

export { bearNotesWatcher };
