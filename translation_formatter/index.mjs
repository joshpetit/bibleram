import sqlite3 from "sqlite3";
import { open } from "sqlite";
import striptags from "striptags";

// this is a top-level await
const formatNkjv = async () => {
  // open the database
  const db = await open({
    filename: "/tmp/nasb.db",
    driver: sqlite3.Database,
  });

  const reses = await db.all("SELECT * FROM verses");
  for (var res of reses) {
    var newText = striptags(res.text);
    var textToBeRemoved = newText.match(/\[\d+\†]/g);
    newText = newText.replace(/\[\d+\†]/g, "");

    if (textToBeRemoved?.length != 0) {
      console.log(
        "Update query: ",
        `UPDATE verses SET text = '${newText}' WHERE book_number=${res.book_number} AND chapter=${res.chapter} AND verse=${res.verse}`
      );
      await db.run(
        `UPDATE verses SET text = '${newText}' WHERE book_number=${res.book_number} AND chapter=${res.chapter} AND verse=${res.verse}`
      );
    }
    console.log(newText);
  }

  db.close();
};

const formatNiv = async () => {
  // open the database
  const db = await open({
    filename: "/tmp/niv.db",
    driver: sqlite3.Database,
  });

  const reses = await db.all("SELECT * FROM verses");
  for (var res of reses) {
    var newText = striptags(res.text);
    var textToBeRemoved = newText.match(/\[\d+\]/g);
    console.log(textToBeRemoved);

    newText = newText.replace(/\[\d+\]/g, "");

    if (textToBeRemoved?.length != 0) {
      console.log(
        "Update query: ",
        `UPDATE verses SET text = '${newText}' WHERE book_number=${res.book_number} AND chapter=${res.chapter} AND verse=${res.verse}`
      );
      await db.run(
        `UPDATE verses SET text = '${newText}' WHERE book_number=${res.book_number} AND chapter=${res.chapter} AND verse=${res.verse}`
      );
    }
    console.log(newText);
  }

  db.close();
};

const formatKjv = async () => {
  // open the database
  const db = await open({
    filename: "/tmp/kjv.db",
    driver: sqlite3.Database,
  });

  const reses = await db.all("SELECT * FROM verses");
  for (var res of reses) {
    var newText = striptags(res.text);
    if (newText == res.text) {
      continue;
    }
    const query = await db.prepare(
      `UPDATE verses SET text = (?) WHERE book_number=${res.book_number} AND chapter=${res.chapter} AND verse=${res.verse}`
    );
    await query.run(newText);
  }
  db.close();
  console.log("done");
};

const formatWeb = async () => {
  // open the database
  const db = await open({
    filename: "/tmp/web.db",
    driver: sqlite3.Database,
  });

  const reses = await db.all("SELECT * FROM verses");
  for (var res of reses) {
    var newText = striptags(res.text);
    var textToBeRemoved = newText.match(/\[\d+\]/g);
    var otherToBeRemove = newText.match(/\s+/g, " ");
    newText = newText.replace(/\[\d+\]/g, "");
    newText = newText.replace(/\s+/g, " ");

    if (textToBeRemoved?.length != 0 || otherToBeRemove?.length != 0) {
      // console.log(
      //   "Update query: ",
      //   `UPDATE verses SET text = '${newText}' WHERE book_number=${res.book_number} AND chapter=${res.chapter} AND verse=${res.verse}`
      // );
      await db.run(
        `UPDATE verses SET text = '${newText}' WHERE book_number=${res.book_number} AND chapter=${res.chapter} AND verse=${res.verse}`
      );
    }
    // console.log(newText);
  }

  db.close();
};

const makeBookMapping = async () => {
  const db = await open({
    filename: "/tmp/nkjv.db",
    driver: sqlite3.Database,
  });

  const reses = await db.all("SELECT * FROM books");
  const mapping = {};
  for (let i = 0; i < reses.length; i++) {
    const element = reses[i];
    mapping[i + 1] = element.book_number;
  }
  console.log(mapping);
};

formatWeb();
