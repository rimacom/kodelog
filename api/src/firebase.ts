import { collection, getDocs, Firestore, doc, getDoc, addDoc, deleteDoc, updateDoc } from 'firebase/firestore/lite';
import { Record } from "./models/record"
import { RawData } from "./models/rawdb"
import { NewRecord } from "./models/new_record"

export async function getUserRecord(db: Firestore, user: string, record: string): Promise<Record | null> {
    const recordDoc = await getDoc(doc(db, `users`, user, "records", record))
    if (recordDoc.exists()) {
        const d = recordDoc.data() as RawData
        return { "programming_language": d['programming_language'].jazyk, id: recordDoc.id, date: new Date(d.date.seconds), "time_spent": d['time_spent'], rating: d.rating, description: d.descriptionRaw }
    }
    else {
        return null;
    }
}

export async function getAllUserRecords(db: Firestore, user: string): Promise<Record[] | null> {
    const userDoc = await getDoc(doc(db, `users`, user))
    if (!userDoc.exists()) return null;
    const records = (await getDocs(collection(db, "users", user, "records")))
    const recordArr: Record[] = []
    records.forEach(r => {
        const d = r.data() as RawData
        recordArr.push({
            date: d.date.toDate(),
            "time_spent": d['time_spent'],
            "programming_language": d['programming_language'].jazyk,
            rating: d.rating,
            description: d.descriptionRaw,
            id: r.id
        })
    })
    return recordArr
}

export async function createRecord(db: Firestore, user: string, data: NewRecord): Promise<string | null> {
    const userDoc = await getDoc(doc(db, "users", user))
    if (userDoc.exists()) {
        const docRef = await addDoc(collection(db, "users", user, "records"), { ...data,"time_spentRaw":textToSec(data.time_spent), "description": null })
        return docRef.id;
    }
    else {
        return null;
    }
}

export async function updateRecord(db: Firestore, user: string, id: string, data: NewRecord): Promise<boolean | null> {
    const userDoc = await getDoc(doc(db, "users", user))
    if (userDoc.exists()) {
        const docRef = await getDoc(doc(db, "users", user, "records", id))
        if (!docRef.exists()) return false;
        await updateDoc(docRef.ref, {...data,"time_spentRaw":textToSec(data.time_spent)})
        return true;
    }
    else {
        return null;
    }
}

export async function deleteRecord(db: Firestore, user: string, rec: string): Promise<boolean | null> {
    const userDoc = await getDoc(doc(db, "users", user))
    if (!userDoc.exists()) return null;
    const recordDoc = await getDoc(doc(db, "users", user, "records", rec))
    if (!recordDoc.exists()) return false
    await deleteDoc(recordDoc.ref)
    return true;
}

function textToSec(vstup: string):number|undefined {
    const regex = /(\d+) hodin(?: |y |a )(\d+) minut(?:$|a$|y$)/gm
    let s:number|undefined = 0;
    let m;

    while ((m = regex.exec(vstup)) !== null) {
        // This is necessary to avoid infinite loops with zero-width matches
        if (m.index === regex.lastIndex) {
            regex.lastIndex++;
        }

        // The result can be accessed through the `m`-variable.
        let ok = true;
        m.forEach((match, groupIndex) => {
            try {
                switch (groupIndex) {
                    case 1:
                        if(s == undefined){
                            ok = false;
                            break;
                        }
                        s += parseInt(match) * 3600
                        break;
                    case 2:
                        if(s == undefined){
                            ok = false;
                            break;
                        }
                        s += parseInt(match) * 60
                        break;
                    default:
                        break;
                }
            } catch (error) {
                ok = false;
            }
        });
        if(!ok) {
            s = undefined;
            break;
        }
    }
    return s;
}