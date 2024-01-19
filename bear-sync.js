import { watch } from "fs";
import Database from "better-sqlite3";

let timeout;
const bearDbPath = process.env.BEAR_DB_PATH;

const db = new Database(bearDbPath, { readonly: true });

// TODO
// run query that fetch all the notes with a given tag sorted by the most recent updated
// if its within the last x seconds then save that to a file in a location defined in the .env file for github pages or similar
// save file(s) to disk in markdown format
// commit to github
// push to github

watch(bearDbPath, (eventType, filename) => {
  clearTimeout(timeout);
  timeout = setTimeout(() => {
    console.log(`Event type is: ${eventType}`);
    if (filename) {
      console.log(`Filename provided: ${filename}`);
    } else {
      console.log("Filename not provided");
    }
  }, 5000); // 5 seconds debounce
});
