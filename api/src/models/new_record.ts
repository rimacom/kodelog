export type NewRecord={
    date:Date,
    "time_spent":string,
    "programming_language":{jazyk:string,barva:number},
    rating:number,
    descriptionRaw:string,
    programmer:string
}

export type NewRecordRaw={
    date:string,
    "time_spent":string,
    "programming_language":string,
    rating:number,
    description:string
}