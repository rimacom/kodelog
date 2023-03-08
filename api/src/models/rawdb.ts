import { Timestamp } from "firebase/firestore/lite"

export type RawData = {
    "programming_language": {jazyk:string,barva:number},
    rating:number,
    descriptionRaw: string,
    description:unknown[],
    date:Timestamp,
    programmer:string,
    toDate:Timestamp,
    "time_spent":string
}