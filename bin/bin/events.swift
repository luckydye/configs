#!/usr/bin/env swift
import EventKit
import Foundation

let store = EKEventStore()
let sem = DispatchSemaphore(value: 0)
var granted = false

if #available(macOS 14.0, *) {
  store.requestFullAccessToEvents { ok, _ in granted = ok; sem.signal() }
} else {
  store.requestAccess(to: .event) { ok, _ in granted = ok; sem.signal() }
}
sem.wait()
guard granted else { FileHandle.standardError.write("Calendar access denied\n".data(using: .utf8)!); exit(1) }

let cal = Calendar.current
let start = cal.date(byAdding: .day, value: -3, to: cal.startOfDay(for: Date()))!
let end = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: Date()))!

let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
let events = store.events(matching: predicate).filter { !$0.isAllDay }.sorted { $0.startDate < $1.startDate }

let df = DateFormatter()
df.dateFormat = "yyyy-MM-dd'T'HH:mm"
let tf = DateFormatter()
tf.dateFormat = "HH:mm"

func pad(_ s: String, _ n: Int) -> String {
  let count = s.count
  return count >= n ? String(s.prefix(n)) : s + String(repeating: " ", count: n - count)
}

func c(_ code: String, _ s: String) -> String {
  "\u{1B}[\(code)m\(s)\u{1B}[0m"
}

let calWidth = 30
var prev: Date? = nil

for e in events {
  if let p = prev, e.startDate.timeIntervalSince(p) > 43200 { print("") }
  prev = e.startDate
  let startStr = df.string(from: e.startDate)
  let endStr = pad(tf.string(from: e.endDate), 8)
  let calName = pad(e.calendar.title, 30)
  let org = e.organizer?.name ?? e.organizer?.url.absoluteString.replacingOccurrences(of: "mailto:", with: "") ?? ""
  let orgStr = pad(org, 18)
  let title = e.title ?? ""
  print("\(c("90", startStr))  \(c("33", endStr))  \(c("36", calName))  \(c("35", orgStr))  \(title)")
}
