import mysql from "mysql2/promise";

export const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "db_todo_list",
  waitForConnections: true,
  connectionLimit: 10,
});