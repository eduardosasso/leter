import { test } from "node:test";

test("will pass", () => {
  console.log("hello world");
});

test("will fail", () => {
  // throw new Error("fail");
  console.log("hello world");
});