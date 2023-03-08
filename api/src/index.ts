import fastify from 'fastify'
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore/lite';
import { Record } from "./models/record"
import path from 'path';
import { createRecord, deleteRecord, getAllUserRecords, getUserRecord, updateRecord } from './firebase';
import { Params } from './models/params';
import { fastifyStatic } from "@fastify/static"
import { NewRecord, NewRecordRaw } from './models/new_record';

/*
        Copyright (C) 2022 Matyáš Caras a Richard Pavlikán

        This program is free software: you can redistribute it and/or modify
        it under the terms of the GNU Affero General Public License as
        published by the Free Software Foundation, either version 3 of the
        License, or (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU Affero General Public License for more details.

        You should have received a copy of the GNU Affero General Public License
        along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

debugme().then(() => {

  // Zkontrolovat proměnné
  ["FIREBASE_KEY", "FIREBASE_AUTH", "FIREBASE_ID", "FIREBASE_STORAGE", "FIREBASE_MESSAGING", "FIREBASE_APPID"].forEach(v => {
    if (!Object.keys(process.env).includes(v)) {
      throw new Error(`Chybí systémová proměnná '${v}'`)
    }
  })

  const server = fastify()
  server.register(fastifyStatic, {
    root: path.join(__dirname, "public")
  })

  // Konfigurace pro napojení na Firebase
  const firebaseConfig = {

    apiKey: process.env["FIREBASE_KEY"],

    authDomain: process.env["FIREBASE_AUTH"],

    projectId: process.env["FIREBASE_ID"],

    storageBucket: process.env["FIREBASE_STORAGE"],

    messagingSenderId: process.env["FIREBASE_MESSAGING"],

    appId: process.env["FIREBASE_APPID"]

  };

  // Připojit se na Firebase
  const firebaseApp = initializeApp(firebaseConfig);
  const db = getFirestore(firebaseApp);

  // Registrovat routy

  server.get("/", (req, res) => {
    res.sendFile("index.html")
  })

  // API routy

  // Získat jeden záznam uživatele ID
  server.get('/users/:userid/records/:recordid', async (req, res) => {

    if ((req.params as Params).userid == "" || (req.params as Params).recordid == "") return res.status(400).type("application/json").send(JSON.stringify({ "error": "Parametry nesmí být prázdné", "status": "error" }))
    const record: Record | null = await getUserRecord(db, (req.params as Params).userid as string, (req.params as Params).recordid as string)
    if (!record) return res.status(404).type("application/json").send(JSON.stringify({ "error": "Uživatel neexistuje", "status": "error" }))

    return res.type("application/json").send(JSON.stringify(record))
  })

  // Smazat jeden záznam
  server.delete("/users/:userid/records/:recordid", async (req, res) => {
    if ((req.params as Params).userid == "" || (req.params as Params).recordid == "") return res.status(400).type("application/json").send(JSON.stringify({ "error": "Parametry nesmí být prázdné", "status": "error" }))
    const r = await deleteRecord(db, (req.params as Params).userid as string, (req.params as Params).recordid as string)
    if (r == null) {
      return res.status(404).type("application/json").send(JSON.stringify({ "status": "error", "message": "Uživatel neexistuje" }))
    }
    else if (r == false) {
      return res.status(404).type("application/json").send(JSON.stringify({ "status": "error", "message": "Záznam neexistuje" }))
    }
    return res.status(200).type("application/json").send(JSON.stringify({ "status": "OK" }))
  })

  // Upravit jeden záznam
  server.put("/users/:userid/records/:recordid", {
    schema: {
      body: {
        type: 'object',
        properties: {
          "date": { type: 'string' },
          "time_spent": { type: 'string' },
          "programming_language": { type: 'string' },
          "description": { type: 'string' },
          "rating": { type: 'number' }
        }
      }
    }
  }, async (req, res) => {
    if ((req.params as Params).userid == "" || (req.params as Params).recordid == "") return res.status(400).type("application/json").send(JSON.stringify({ "error": "Parametry nesmí být prázdné", "status": "error" }))
    try {
      const data = req.body as NewRecordRaw
      if (data.rating > 5 || data.rating < 0) return res.status(400).type("application/json").send(JSON.stringify({ "error": "'rating' je mimo interval 0-5", "status": "error" }))
      const regex = /(\d+) hodin(?: |y |a )(\d+) minut(?:$|a$|y$)/gm
      if(!regex.test(data.time_spent)){
        return res.status(400).type("application/json").send(JSON.stringify({ "error": "time_spent není ve správném formátu", "status": "error" }))
      }
      const jazyky: { jazyk: string, barva: number }[] = [
        { "jazyk": "C#", "barva": 0xff8200f3 },
        { "jazyk": "JavaScript", "barva": 0xfffdd700 },
        { "jazyk": "Python", "barva": 0xff0080ee },
        { "jazyk": "PHP", "barva": 0xff00abff },
        { "jazyk": "C++", "barva": 0xff1626ff },
        { "jazyk": "Kotlin", "barva": 0xffe34b7c },
        { "jazyk": "Java", "barva": 0xfff58219 },
        { "jazyk": "Dart", "barva": 0xff40c4ff },
        { "jazyk": "F#", "barva": 0xff85ddf3 },
        { "jazyk": "Elixir", "barva": 0xff543465 },
        { "jazyk": "Carbon", "barva": 0xff606060 },

      ];

      const j: { jazyk: string, barva: number } = (jazyky.filter((v) => v.jazyk.toLowerCase() == data['programming_language'].toLowerCase()).length > 0) ? jazyky.filter((v) => v.jazyk == data['programming_language'])[0] : { "jazyk": data["programming_language"], "barva": 0xffffffff }

      const record: NewRecord = {
        date: new Date(data.date), "programming_language": j, "time_spent": data['time_spent'], rating: data.rating,
        descriptionRaw: data.description, programmer: (req.params as Params).userid as string
      }
      const r = await updateRecord(db, (req.params as Params).userid as string, (req.params as Params).recordid as string, record)
      if (r == null) {
        return res.status(404).type("application/json").send(JSON.stringify({ "status": "error", "message": "Uživatel neexistuje" }))
      }
      else if(r == false){
        return res.status(404).type("application/json").send(JSON.stringify({ "status": "error", "message": "Záznam neexistuje" }))
      }
      return res.status(200).type("application/json").send(JSON.stringify({ "status": "OK" }))
    } catch (error) {
      if (process.env["NODE_DEBUG"] == "true") console.log(error)
      return res.status(400).type("application/json").send(JSON.stringify({ "error": "Zaslaná data nejsou v platném formátu JSON", "status": "error" }))
    }
  })

  // Získat všechny záznamy uživatele
  server.get("/users/:userid/records", async (req, res) => {
    if ((req.params as Params).userid == "") return res.status(400).type("application/json").send(JSON.stringify({ "error": "Parametry nesmí být prázdné", "status": "error" }))
    const r: Record[] | null = await getAllUserRecords(db, (req.params as Params).userid as string)
    if (!r) return res.status(404).type("application/json").send(JSON.stringify({ "status": "error", "message": "Uživatel neexistuje" }))

    return res.type("application/json").send(JSON.stringify(
      r
    ))
  })

  // Vytvořit nový záznam
  server.post("/users/:userid/records", {
    schema: {
      body: {
        type: 'object',
        properties: {
          "date": { type: 'string' },
          "time_spent": { type: 'string' },
          "programming_language": { type: 'string' },
          "description": { type: 'string' },
          "rating": { type: 'number' }
        }
      }
    }
  }, async (req, res) => {
    if ((req.params as Params).userid == "") return res.status(400).type("application/json").send(JSON.stringify({ "error": "Parametry nesmí být prázdné", "status": "error" }))
    try {
      const data = req.body as NewRecordRaw
      if (data.rating > 5 || data.rating < 0) return res.status(400).type("application/json").send(JSON.stringify({ "error": "'rating' je mimo interval 0-5", "status": "error" }))
      const regex = /(\d+) hodin(?: |y |a )(\d+) minut(?:$|a$|y$)/gm
      if(!regex.test(data.time_spent)){
        return res.status(400).type("application/json").send(JSON.stringify({ "error": "time_spent není ve správném formátu", "status": "error" }))
      }
      const jazyky: { jazyk: string, barva: number }[] = [
        { "jazyk": "C#", "barva": 0xff8200f3 },
        { "jazyk": "JavaScript", "barva": 0xfffdd700 },
        { "jazyk": "Python", "barva": 0xff0080ee },
        { "jazyk": "PHP", "barva": 0xff00abff },
        { "jazyk": "C++", "barva": 0xff1626ff },
        { "jazyk": "Kotlin", "barva": 0xffe34b7c },
        { "jazyk": "Java", "barva": 0xfff58219 },
        { "jazyk": "Dart", "barva": 0xff40c4ff },
        { "jazyk": "F#", "barva": 0xff85ddf3 },
        { "jazyk": "Elixir", "barva": 0xff543465 },
        { "jazyk": "Carbon", "barva": 0xff606060 },

      ];

      const j: { jazyk: string, barva: number } = (jazyky.filter((v) => v.jazyk.toLowerCase() == data['programming_language'].toLowerCase()).length > 0) ? jazyky.filter((v) => v.jazyk == data['programming_language'])[0] : { "jazyk": data["programming_language"], "barva": 0xffffffff }

      const record: NewRecord = {
        date: new Date(data.date), "programming_language": j, "time_spent": data['time_spent'], rating: data.rating,
        descriptionRaw: data.description, programmer: (req.params as Params).userid as string
      }
      const r:string|null = await createRecord(db, (req.params as Params).userid as string, record)
      if (r == null) {
        return res.status(404).type("application/json").send(JSON.stringify({ "status": "error", "message": "Uživatel neexistuje" }))
      }
      return res.status(201).type("application/json").send(JSON.stringify({"date":record.date,"programming_language":record.programming_language.jazyk,"time_spent":record.time_spent,rating:record.rating,description:record.descriptionRaw,id:r} as Record))
    } catch (error) {
      if (process.env["NODE_DEBUG"] == "true") console.log(error)
      return res.status(400).type("application/json").send(JSON.stringify({ "error": "Zaslaná data nejsou v platném formátu JSON", "status": "error" }))
    }
  })

  server.listen({ port: (!process.env["PORT"]) ? 8080 : parseInt(process.env["PORT"]), host: "0.0.0.0" }, (err, address) => {
    if (err) {
      console.error(err)
      process.exit(1)
    }
    console.log(`Server listening at ${address}`)
  })
})


async function debugme() {
  if (process.env["NODE_DEBUG"] == "true") {
    const dotenv = await import("dotenv");
    dotenv.config()
  }
  return true;
}