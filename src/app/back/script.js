import http from 'http';
import PG from 'pg';
import dotenv from 'dotenv';
import fs from 'fs'; 

dotenv.config();

const port = Number(process.env.PORT);
const { DATABASE_HOST, DATABASE_PORT, DATABASE_NAME, POSTGRESQL_USERNAME, POSTGRESQL_PASSWORD } = process.env;

const client = new PG.Client({
  user: POSTGRESQL_USERNAME,
  host: DATABASE_HOST,
  database: DATABASE_NAME,
  password: POSTGRESQL_PASSWORD,
  port: Number(DATABASE_PORT),
});

let successfulConnection = false;

client.connect()
  .then(() => {
    console.log('Connected to the database');
    const sql = fs.readFileSync('/usr/src/app/sql/script.sql', 'utf8');
    return client.query(sql);
  })
  .then(() => {
    console.log("Conectado ao banco de dados!");
    successfulConnection = true;
  })
  .catch((err) => {
    console.error("Erro de conexão com o banco de dados:", err);
    successfulConnection = false;
  });

http.createServer(async (req, res) => {
  console.log(`Request: ${req.url}`);

  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  if (req.url === "/api") {
    client.connect()
      .then(() => { successfulConnection = true })
      .catch(err => console.error('Database not connected -', err.stack));

    res.setHeader("Content-Type", "application/json");
    res.writeHead(200);

    let result;

    try {
      result = (await client.query("SELECT * FROM users")).rows[0];
    } catch (error) {
      console.error(error);
      res.writeHead(500);
      res.end("Erro ao consultar o banco de dados");
      return;
    }

    const data = {
      host: successfulConnection,
      admin: successfulConnection && result?.role === "admin"
    };

    res.end(JSON.stringify(data));
  } else {
    res.writeHead(503);
    res.end("Internal Server Error");
  }

}).listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});
